table 51532122 "Cashier Transaction Lines"
{


    fields
    {
        field(1; "Transaction No"; Code[20])
        {
        }
        field(2; "Member No"; Code[20])
        {
            Caption = 'Customer CID';
            TableRelation = Members WHERE("Customer Type" = FILTER(<> Cell));

            trigger OnValidate()
            begin
                members.Reset;
                members.SetRange("No.", "Member No");
                if members.FindFirst then begin
                    "Global Dimension 1 Code" := members."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := members."Global Dimension 2 Code";
                end;
            end;
        }
        field(3; "Transaction Type"; Option)
        {
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal Due,Loan Registration Fee,Appraisal Paid,Pre-Earned Interest,Penalty Due,Penalty Paid,Partial Disbursement,Suspended Interest Due,Suspended Interest Paid';
            OptionMembers = " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Loan Registration Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid","Partial Disbursement","Suspended Interest Due","Suspended Interest Paid";

            trigger OnValidate()
            var
                ErrorOnInvalidTransType: Label 'Transaction type -%1- is disabled on this document. Please contact your system administrator.';
            begin
                case "Transaction Type" of
                    "Transaction Type"::Loan:
                        begin
                            Error(ErrorOnInvalidTransType, "Transaction Type");
                        end;
                end;
            end;
        }
        field(4; "Loan No"; Code[30])
        {
            TableRelation = Loans WHERE("Member No." = FIELD("Member No"),
                                         Posted = CONST(true),
                                         "Loan Account" = FIELD("Account No"));

            trigger OnValidate()
            begin
                if Loans.Get("Loan No") then begin
                    Loans.CalcFields(Loans."Outstanding Bills", "Outstanding Interest", "Outstanding Balance", "Outstanding Appraisal", "Outstanding Penalty");
                    "Outstanding Balance" := Loans."Outstanding Balance";
                    "Outstanding Interest" := Loans."Outstanding Interest";
                    "Outstanding Bill" := Loans."Outstanding Bills";
                    "Outstanding Appraisal" := Loans."Outstanding Appraisal";
                    "Penalty Due" := Loans."Outstanding Penalty";
                    //"Appraisal Fee Due" := PeriodicActivities.GetAppraisalDue(Loans);
                    //"Interest Due" := PeriodicActivities.GetInterestDue(Loans);
                end;
            end;
        }
        field(5; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if Amount < 0 then
                    Error('Amount cannot be less than zero');

                DiffReg := 0;
                /*
                CASE Type OF
                  Type::Credit:
                    BEGIN
                
                        TESTFIELD("Loan No");
                        IF Loans.GET("Loan No") THEN BEGIN
                            IF Amount > ("Outstanding Balance"+"Outstanding Interest"+"Outstanding Appraisal"+"Penalty Due") THEN
                                ERROR(Text001);
                
                            IF Amount >= "Outstanding Balance" THEN
                              "Loan Clearance":=TRUE
                            ELSE
                              "Loan Clearance":=FALSE;
                        END;
                    END;
                END;
                */

                "Charge Amount" := 0;
                if CashTrans.Get("Transaction No") then begin
                    if CashTrans."Mobile Transaction" then begin
                        if Transaction = Transaction::" " then begin
                            Error('Transaction Must have a value');
                        end;
                        if Transaction = Transaction::Withdrawal then begin
                            // "Charge Amount":=SaccoTransactions.GetChargeAmountPlusDuty(CashTrans."Transaction Type",Amount,'','',0D,'',0,'','',0,'','','',TRUE);
                        end;
                    end;
                end;
                if Type = Type::Credit then begin
                    TestField("Loan No");
                    if Loans.Get("Loan No") then begin
                        Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Penalty");

                        case "Transaction Type" of
                            "Transaction Type"::Repayment:
                                begin
                                    if Amount >= Loans."Outstanding Balance" then
                                        Amount := Loans."Outstanding Balance" else
                                        Amount := Amount;

                                end;
                            "Transaction Type"::"Interest Paid":
                                begin
                                    if Amount > Loans."Outstanding Interest" then
                                        Amount := Loans."Outstanding Interest" else
                                        Amount := Amount;
                                end;
                            "Transaction Type"::"Appraisal Due":
                                begin
                                    if Amount > Loans."Outstanding Penalty" then
                                        Amount := Loans."Outstanding Penalty" else
                                        Amount := Amount;
                                end;

                        end;
                    end;
                end;
                CashTrans.Reset;
                CashTrans.SetRange(No, "Transaction No");
                CashTrans.SetRange("Account Type", CashTrans."Account Type"::"Deposit Slip");
                if CashTrans.FindFirst then begin

                    Depslip.Reset;
                    Depslip.SetRange("Reference No", "Deposit Slip Ref No");
                    if Depslip.FindFirst then begin
                        if Amount > Depslip.Amount then Error('Amount cannot exceed deposit slip amount');
                    end;
                end;

            end;
        }
        field(6; "Transaction Date"; Date)
        {
        }
        field(7; "Account No"; Code[20])
        {
            TableRelation = IF (Type = CONST(Credit)) "Credit Accounts" WHERE("Member No." = FIELD("Member No"))
            ELSE
            IF (Type = CONST(Savings)) "Savings Accounts" WHERE("Member No." = FIELD("Member No"))
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"."No.";

            trigger OnValidate()
            begin
                if creditacc.Get("Account No") then begin
                    "Member No" := creditacc."Member No.";
                    "Product Type" := creditacc."Product Type";
                    Description := creditacc.Name;
                    "Product Name" := creditacc."Product Name";
                end else
                    if savingsacc.Get("Account No") then begin
                        "Member No" := savingsacc."Member No.";
                        "Product Type" := savingsacc."Product Type";
                        Description := savingsacc.Name;
                        "Product Name" := savingsacc."Product Name";

                        savingsacc.CalcFields("Balance (LCY)");
                        "Book Balance" := savingsacc."Balance (LCY)";
                        //"Available Balance" := PeriodicActivities.GetAccountBalance("Account No");
                    end;

                "Loan No" := '';
                //Amount:=0;
                "Charge Amount" := 0;
            end;
        }
        field(8; Type; Option)
        {
            OptionCaption = 'Savings,Credit,G/L Account';
            OptionMembers = Savings,Credit,"G/L Account";
        }
        field(9; "Product Type"; Code[80])
        {
            Editable = false;
            TableRelation = "Product Factory"."Product ID";
        }
        field(10; "Outstanding Bill"; Decimal)
        {
            Editable = false;
        }
        field(11; "Outstanding Interest"; Decimal)
        {
            Editable = false;
        }
        field(12; "Outstanding Balance"; Decimal)
        {
        }
        field(13; "Appraisal Fee Due"; Decimal)
        {
        }
        field(14; "Penalty Due"; Decimal)
        {
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Activity Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                if CashTrans.Get("Transaction No") then begin
                    "Member No" := CashTrans."Member No.";
                end;
            end;
        }
        field(16; Description; Text[250])
        {
        }
        field(17; Transaction; Option)
        {
            OptionMembers = " ",Deposit,Withdrawal;
        }
        field(18; "Charge Amount"; Decimal)
        {
        }
        field(19; "Book Balance"; Decimal)
        {
            Editable = false;
        }
        field(20; "Available Balance"; Decimal)
        {
            Editable = false;
        }
        field(21; "Outstanding Appraisal"; Decimal)
        {
        }
        field(22; "Interest Due"; Decimal)
        {
        }
        field(23; "Loan Clearance"; Boolean)
        {
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                if CashTrans.Get("Transaction No") then begin
                    "Member No" := CashTrans."Member No.";
                end;
            end;
        }
        field(25; "Deposit Slip Ref No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Product Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(27; Lookup; Decimal)
        {
            CalcFormula = Lookup("Cashier Transactions".Amount WHERE(No = FIELD("Transaction No")));
            FieldClass = FlowField;
        }
        field(28; Cleared; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Header Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Credit Cheque","Cheque Deposit";
        }
        field(30; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Loan Held at"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Transaction No", "Account No", "Transaction Type", "Loan No", Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if CashTrans.Get("Transaction No") then begin
            "Member No" := CashTrans."Member No.";
        end;
    end;

    trigger OnModify()
    begin
        // IF CashTrans.GET("Transaction No") THEN BEGIN
        //  "Member No":=CashTrans."Member No.";
        // END;
    end;

    var
        creditacc: Record "Credit Accounts";
        savingsacc: Record "Savings Accounts";
        ProductF: Record "Product Factory";
        DiffReg: Decimal;
        Loans: Record Loans;
        members: Record Members;
        memberCat: Record "Member Category";
        DiffShare: Decimal;
        CashTrans: Record "Cashier Transactions";
        Text001: Label 'This will lead to Loan Clearance with an Excess. ';
        // SaccoTransactions: Codeunit "Sacco Transactions";
        //PeriodicActivities: Codeunit "Periodic Activities";
        Depslip: Record "Deposit Slip";
}

