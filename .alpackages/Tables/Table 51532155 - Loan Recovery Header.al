table 51532155 "Loan Recovery Header"
{
    // DrillDownPageID = "Loan Defaulter Recovery List";
    // LookupPageID = "Loan Defaulter Recovery List";

    fields
    {
        field(1; "No."; Code[50])
        {
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Members WHERE("Customer Type" = FILTER(<> Cell));

            trigger OnValidate()
            var
                Loans: Record Loans;
            begin
                if Members.Get("Member No.") then begin
                    /*
                    MemberCategory.GET(Members."Member Category");
                
                    SavingsAccounts.RESET;
                    SavingsAccounts.SETRANGE("Member No.","Member No.");
                    SavingsAccounts.SETRANGE("Product Category",SavingsAccounts."Product Category"::"Share Capital");
                    IF SavingsAccounts.FINDFIRST THEN BEGIN
                        SavingsAccounts.CALCFIELDS("Balance (LCY)");
                        IF SavingsAccounts."Balance (LCY)" < MemberCategory."Minimum Share Capital" THEN
                          ERROR('Member has only Contributed %1 Share Capital instead of %2',SavingsAccounts."Balance (LCY)",MemberCategory."Minimum Share Capital");
                    END;
                
                
                
                    SavingsAccounts.RESET;
                    SavingsAccounts.SETRANGE("Member No.","Member No.");
                    SavingsAccounts.SETRANGE("Product Category",SavingsAccounts."Product Category"::Benevolent);
                    IF SavingsAccounts.FINDFIRST THEN BEGIN
                        SavingsAccounts.CALCFIELDS("Balance (LCY)");
                        IF SavingsAccounts."Balance (LCY)" < MemberCategory."Minimum Benevolent" THEN
                          ERROR('Member has only Contributed %1 Share Capital instead of %2',SavingsAccounts."Balance (LCY)",MemberCategory."Minimum Benevolent");
                    END;
                    */


                    LoansG := 0;
                    LoanGuarantors.Reset;
                    LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No.");
                    //LoanGuarantors.SETRANGE(LoanGuarantors."Guarantor Type",LoanGuarantors."Guarantor Type"::Guarantor);
                    if LoanGuarantors.Find('-') then begin

                        repeat
                            if Loans.Get(LoanGuarantors."Loan No") then begin
                                Loans.CalcFields(Loans."Outstanding Balance");
                                if Loans."Outstanding Balance" > 0 then begin
                                    LoansG += 1;
                                end;
                            end;
                        until LoanGuarantors.Next = 0;

                        if LoansG > 0 then
                            Message('Member is Guaranteeing %1 Active Loans', LoansG);
                    end;
                    Loans.Reset();
                    Loans.SetRange("Member No.", rec."Member No.");
                    Loans.SetFilter("Outstanding Balance", '>0');
                    Loans.SetFilter("Current Loans Category-SASRA", '<>%1&<>%2&<>%3', Loans."Current Loans Category-SASRA"::Substandard
                    , Loans."Current Loans Category-SASRA"::Loss, Loans."Current Loans Category-SASRA"::Doubtful);
                    IF Loans.FindSet() then
                        Message('This member does not have a loan that is in sasra categories: Substandard/Doubtful/Loss');




                    "Member Name" := Members.Name;
                    "ID No." := Members."ID No.";
                    "Staff No." := Members."Payroll/Staff No.";

                    //"Global Dimension 1 Code" := Members."Global Dimension 1 Code";
                    //"Global Dimension 2 Code" := Members."Global Dimension 2 Code";

                    "Application Date" := Today;
                    "Member Category" := "Member Category"::" ";
                    "Savings Scheme" := "Savings Scheme"::" ";
                    "Loans Option" := "Loans Option"::" ";
                    "Total Interest" := 0;
                    "Total Loan" := 0;
                    "Suspended Interest" := 0;
                    TotalSaving := 0;

                end;
                Validate("Savings Scheme");

            end;
        }
        field(3; "Member Name"; Text[50])
        {
        }
        field(4; "Document Date"; Date)
        {
        }
        field(5; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(6; Posted; Boolean)
        {
        }
        field(7; "Total Loan"; Decimal)
        {
        }
        field(8; "Total Interest"; Decimal)
        {
        }
        field(9; "Member Savings"; Decimal)
        {
        }
        field(10; "No. Series"; Code[10])
        {
        }
        field(11; "Member Category"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Creditor,Defaulter';
            OptionMembers = " ",Creditor,Defaulter;
        }
        field(12; "Application Date"; Date)
        {
        }
        field(13; "Deposit Refundable"; Decimal)
        {
        }
        field(14; Remarks; Text[50])
        {
        }
        field(15; "Savings Scheme"; Option)
        {
            OptionCaption = ' ,All,Specific';
            OptionMembers = " ",All,Specific;

            trigger OnValidate()
            var
                SavingsAccounts: Record "Savings Accounts";
                ProductFactory: Record "Product Factory";
                TotalSaving: Decimal;
                GenSetup: Record "General Set-Up";
                LoanTotal: Decimal;
                IntTotal: Decimal;
                Loans: Record Loans;
                LoansG: Decimal;
                LoanGuarantors: Record "Loan Guarantors and Security";
                BBF: Decimal;
                AccountClosureFee: Decimal;
                Amount: array[2] of Integer;
                TransactionCharges: Record "Transaction Charges";
                TariffDetails: Record "Tiered Charges Lines";
                //Periodic: Codeunit "Periodic Activities";
                Penalty: Decimal;
                Appraisal: Decimal;
                ClosureAccounts: Record "Account Closure Line";
                PFactory: Record "Product Factory";
                MemberwithdrawalNotice: Record "Member withdrawal Notice";
                TransactionTypes: Record "Transaction Type";
                TCharges: Decimal;
                Duty: Decimal;
                DisbAcc: Record "Savings Accounts";
                MemberCategory: Record "Member Category";
                LoanType: Record "Product Factory";
                AccountType: Record "Product Factory";
                TrAcc: Code[20];
                LoanApp: Record Loans;
                LoanRecoveryHeader: Record "Loan Recovery Header";
            begin
                "Loans Option" := "Loans Option"::" ";
                if "Savings Scheme" <> "Savings Scheme"::" " then
                    "Loans Option" := "Loans Option"::All;



                AccLine.Reset;
                AccLine.SetRange(AccLine."No.", "No.");
                if AccLine.Find('-') then
                    AccLine.DeleteAll;


                LoansG := 0;
                LoanGuarantors.Reset;
                LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No.");
                //LoanGuarantors.SETRANGE(LoanGuarantors."Guarantor Type",LoanGuarantors."Guarantor Type"::Guarantor);
                if LoanGuarantors.Find('-') then begin

                    repeat
                        if Loans.Get(LoanGuarantors."Loan No") then begin
                            Loans.CalcFields(Loans."Outstanding Balance");
                            if Loans."Outstanding Balance" > 0 then begin
                                LoansG += 1;
                            end;
                        end;
                    until LoanGuarantors.Next = 0;

                    if LoansG > 0 then
                        Message('Member is Guaranteeing %1 Active Loans', LoansG);
                end;


                "Member Savings" := 0;
                "Deposit Refundable" := 0;


                GenSetup.Get;
                SavingsAccounts.Reset;

                SavingsAccounts.SetRange(SavingsAccounts."Member No.", "Member No.");
                if "Recover from FOSA" = false then
                    SavingsAccounts.SetFilter("Product Category", '<>%1&<>%2', ProductFactory."Product Category"::Housing, ProductFactory."Product Category"::Prime)
                else
                    SavingsAccounts.SetFilter("Product Category", '<>%1', ProductFactory."Product Category"::Housing);
                if SavingsAccounts.Find('-') then begin
                    repeat
                        //IF SavingsAccounts."Loan Disbursement Account"=FALSE THEN BEGIN
                        SavingsAccounts.CalcFields("Balance (LCY)");
                        if ProductFactory.Get(SavingsAccounts."Product Type") then begin
                            IF ProductFactory."Can Offset Loan" then begin
                                if ProductFactory."Can Close Account" then begin
                                    if ProductFactory."Product Class Type" = ProductFactory."Product Class Type"::Savings then begin
                                        if ProductFactory."Product Category" <> ProductFactory."Product Category"::"Share Capital" then begin

                                            if ProductFactory."Product Category" <> ProductFactory."Product Category"::"Registration Fee" then begin
                                                if ProductFactory."Product Category" <> ProductFactory."Product Category"::Benevolent then begin
                                                    if ProductFactory."Product Category" <> ProductFactory."Product Category"::"Fixed Deposit" then begin
                                                        if ProductFactory."Product Category" <> ProductFactory."Product Category"::Redeemable then begin
                                                            if ProductFactory."Product Category" <> ProductFactory."Product Category"::"Junior Savings" then begin

                                                                AccLine.Init;
                                                                AccLine."No." := "No.";
                                                                AccLine."Account No." := SavingsAccounts."No.";
                                                                AccLine.Name := SavingsAccounts.Name;
                                                                AccLine."Product Type" := SavingsAccounts."Product Type";
                                                                AccLine.Balance := SavingsAccounts."Balance (LCY)";
                                                                AccLine.Amount := AccLine.Balance;
                                                                AccLine."Product Category" := SavingsAccounts."Product Category";
                                                                if "Savings Scheme" = "Savings Scheme"::All then
                                                                    AccLine.Close := true;
                                                                AccLine.Blocked := SavingsAccounts.Blocked;
                                                                AccLine."Member No." := SavingsAccounts."Member No.";


                                                                DisbAcc.Reset;
                                                                DisbAcc.SetRange("Member No.", "Member No.");
                                                                //DisbAcc.SETRANGE("Loan Disbursement Account",TRUE);
                                                                //DisbAcc.SetRange("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
                                                                DisbAcc.SetRange("Product Category", DisbAcc."Product Category"::"Deposit Contribution");
                                                                if DisbAcc.FindFirst then
                                                                    AccLine."Transfer Account" := DisbAcc."No.";

                                                                AccLine.Insert;

                                                                //CLosure Fee
                                                                //*Oketch AccountClosureFee:=ProdutFactory."Closure Fee";
                                                                AccountClosureFee := 0;
                                                                TransactionCharges.Reset;
                                                                TransactionCharges.SetRange(TransactionCharges."Transaction Type", ProductFactory."Closure Fee");
                                                                if TransactionCharges.Find('-') then begin
                                                                    repeat
                                                                        Amount[1] := 0;
                                                                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then
                                                                            Amount[1] := ("Member Savings" * TransactionCharges."Percentage of Amount") * 0.01
                                                                        else
                                                                            Amount[1] := TransactionCharges."Charge Amount";

                                                                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                                                            TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                                                            TariffDetails.Reset;
                                                                            TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                                                            if TariffDetails.Find('-') then begin
                                                                                repeat
                                                                                    if ("Member Savings" >= TariffDetails."Lower Limit") and ("Member Savings" <= TariffDetails."Upper Limit") then begin
                                                                                        if TariffDetails."Use Percentage" then
                                                                                            Amount[1] := "Member Savings" * TariffDetails.Percentage * 0.01
                                                                                        else
                                                                                            Amount[1] := TariffDetails."Charge Amount";
                                                                                    end;
                                                                                until TariffDetails.Next = 0;
                                                                            end;
                                                                        end;
                                                                        Amount[2] += Amount[1];
                                                                    until TransactionCharges.Next = 0;
                                                                end;

                                                                AccountClosureFee := Amount[2];
                                                                TotalSaving := TotalSaving + (AccLine.Balance - AccountClosureFee);
                                                            end
                                                            else begin
                                                                if ProductFactory."Product Category" <> ProductFactory."Product Category"::Benevolent then begin
                                                                    AccLine.Init;
                                                                    AccLine."No." := "No.";
                                                                    AccLine."Account No." := SavingsAccounts."No.";
                                                                    AccLine.Name := SavingsAccounts.Name;
                                                                    AccLine."Product Type" := SavingsAccounts."Product Type";
                                                                    AccLine.Balance := SavingsAccounts."Balance (LCY)";
                                                                    if "Savings Scheme" = "Savings Scheme"::All then
                                                                        AccLine.Close := true;
                                                                    AccLine.Blocked := SavingsAccounts.Blocked;
                                                                    AccLine."Member No." := SavingsAccounts."Member No.";
                                                                    AccLine.Insert;

                                                                    BBF := BBF + (SavingsAccounts."Balance (LCY)" * (GenSetup."BBF Claim %" / 100));
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    //END;
                    until SavingsAccounts.Next = 0;
                end;

                ValidateAmounts;
            end;
        }
        field(16; "Loans Option"; Option)
        {
            OptionCaption = ' ,Short Term,Long Term,All';
            OptionMembers = " ","Short Term","Long Term",All;

            trigger OnValidate()
            begin

                LoansG := 0;
                LoanGuarantors.Reset;
                LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No.");

                if LoanGuarantors.Find('-') then begin

                    repeat
                        if Loans.Get(LoanGuarantors."Loan No") then begin
                            Loans.CalcFields(Loans."Outstanding Balance");
                            if Loans."Outstanding Balance" > 0 then begin
                                LoansG += 1;
                            end;
                        end;
                    until LoanGuarantors.Next = 0;

                    if LoansG > 0 then
                        Message('Member is Guaranteeing %1 Active Loans', LoansG);
                end;


                //VALIDATE("Closure Type");

                ValidateAmounts;
            end;
        }
        field(17; "Entered By"; Code[30])
        {
        }
        field(18; Transaction; Option)
        {
            OptionCaption = 'Member Withdrawal';
            OptionMembers = "Member Withdrawal";
        }
        field(19; "ID No."; Code[20])
        {
        }
        field(20; "Benevolent Fund"; Decimal)
        {
        }
        field(21; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(22; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(23; "Insurance Amount"; Decimal)
        {

            trigger OnValidate()
            begin


                ValidateAmounts;
            end;
        }
        field(24; "Transfer Account"; Code[20])
        {
            TableRelation = "Savings Accounts";

            trigger OnValidate()
            begin
                "Transfer Account Name" := '';
                if SavingsAccounts.Get("Transfer Account") then
                    "Transfer Account Name" := SavingsAccounts.Name;
            end;
        }
        field(25; "Transfer Account Name"; Text[150])
        {
        }
        field(26; "Total Penalty"; Decimal)
        {
        }
        field(27; "Total Appraisal"; Decimal)
        {
        }
        field(28; "Total Savings"; Decimal)
        {
            CalcFormula = Sum("Account Closure Line".Amount WHERE("No." = FIELD("No."),
                                                                   Close = FILTER(true)));
            FieldClass = FlowField;
        }
        field(29; "Total Charges"; Decimal)
        {
        }
        field(30; "Minute Nos."; Code[20])
        {
        }
        field(31; "Charge Rejoining Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; "Defaulter Loan"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Charge Offset Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Recovered From Shares"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Recovered From Guarantors"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Transfered to Creditor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Loan Registration Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(41; LoanNo; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Loans."Loan No." WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                if Loans.Get(LoanNo) then begin
                    Loans.CalcFields(Loans."Outstanding Balance", Loans."Outstanding Interest", "Interest Suspended");
                    "Outstanding Interest" := Loans."Outstanding Interest";
                    "Outstanding Balance" := Loans."Outstanding Balance";
                    "Total Penalty" := Loans."Outstanding Penalty";
                    "Total Appraisal" := Loans."Outstanding Appraisal";
                    "Total Loan" := Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Interest Suspended";
                    "Suspended Interest" := Loans."Interest Suspended";
                    "Total Interest" := Loans."Outstanding Interest";

                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."Member No.", "Member No.");
                    SavingsAccounts.SetRange(SavingsAccounts."Product Category", SavingsAccounts."Product Category"::"Deposit Contribution");
                    if SavingsAccounts.Find('-') then begin
                        SavingsAccounts.CalcFields(SavingsAccounts."Balance (LCY)");
                        "Member Savings" := SavingsAccounts."Balance (LCY)";
                    end;

                end else begin
                    "Member Savings" := 0;
                    "Outstanding Interest" := 0;
                    "Outstanding Balance" := 0;
                end;
            end;
        }
        field(42; Recovered; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Recovery Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Single,All';
            OptionMembers = " ",Single,All;
        }
        field(44; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Outstanding Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Outstanding Interest"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Recovered (Deposits)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Fosa Recovery Reason"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Recover from FOSA"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
            //SaccoTrans: Codeunit "Periodic Activities";
            begin
                // Validate("Savings Scheme");
                if "Recover from FOSA" then begin
                    SavingsAccounts.reset;
                    SavingsAccounts.SetRange("Member No.", rec."Member No.");
                    //SavingsAccounts.SetRange("Loan Disbursement Account", true);
                    SavingsAccounts.SetRange("Product Category", SavingsAccounts."Product Category"::Prime);
                    if SavingsAccounts.Find('-') then
                        repeat
                            AccLine.Reset();
                            AccLine.SetRange("Account No.", SavingsAccounts."No.");
                            AccLine.SetRange("No.", "No.");
                            if AccLine.Find('-') = false then begin
                                SavingsAccounts.CalcFields("Balance (LCY)");
                                AccLine.Init;
                                AccLine."No." := "No.";
                                AccLine."Account No." := SavingsAccounts."No.";
                                AccLine.Name := SavingsAccounts.Name;
                                AccLine."Product Type" := SavingsAccounts."Product Type";
                                //AccLine.Balance := SaccoTrans.GetAccountBalance(SavingsAccounts."No.");
                                /*if "Savings Scheme" = "Savings Scheme"::All then
                                    AccLine.Close := true;*/
                                if "Total Loan" > "Member Savings" then begin
                                    if AccLine.Balance > ("Total Loan" - "Member Savings") then
                                        AccLine.Amount := "Total Loan" - "Member Savings"
                                    else
                                        AccLine.Amount := AccLine.Balance;
                                end;
                                AccLine.Blocked := SavingsAccounts.Blocked;
                                AccLine."Member No." := SavingsAccounts."Member No.";
                                DisbAcc.Reset;
                                DisbAcc.SetRange("Member No.", "Member No.");
                                //DisbAcc.SETRANGE("Loan Disbursement Account",TRUE);
                                //DisbAcc.SetRange("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
                                DisbAcc.SetRange("Product Category", DisbAcc."Product Category"::"Deposit Contribution");
                                if DisbAcc.FindFirst then
                                    AccLine."Transfer Account" := DisbAcc."No.";
                                AccLine.Insert;
                                // "Member Savings" += SaccoTrans.GetAccountBalance(SavingsAccounts."No.");
                            end;
                        until SavingsAccounts.Next() = 0;
                end else
                    validate("Savings Scheme");
            end;
        }
        field(50; "Suspended Interest"; Decimal)
        {

        }

    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Status <> Status::Open then
            Error(Txt0000);
    end;

    trigger OnInsert()
    var
        USetup: Record "User Setup";
    begin
        NoSetup.Get();

        NoSetup.TestField(NoSetup."Loan Recovery");
        NoSeriesMgt.InitSeries(NoSetup."Loan Recovery", xRec."No. Series", 0D, "No.", "No. Series");
        if USetup.Get(UserId) then begin
            /* "Global Dimension 1 Code" := USetup."Global Dimension 1 Code";
             "Global Dimension 2 Code" := USetup."Global Dimension 2 Code";*/
        end;
        //"Date Entered":=TODAY;
        "Entered By" := UserId;
        "Charge Offset Fee" := true;

        "Loans Option" := "Loans Option"::All;
    end;

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Members: Record Members;
        AccLine: Record "Account Closure Line";
        SavingsAccounts: Record "Savings Accounts";
        ProductFactory: Record "Product Factory";
        TotalSaving: Decimal;
        GenSetup: Record "General Set-Up";
        LoanTotal: Decimal;
        InterestSus: Decimal;
        IntTotal: Decimal;
        Loans: Record Loans;
        LoansG: Decimal;
        LoanGuarantors: Record "Loan Guarantors and Security";
        Txt0000: Label 'You cannot delete when status is not open';
        BBF: Decimal;
        AccountClosureFee: Decimal;
        Amount: array[2] of Integer;
        TransactionCharges: Record "Transaction Charges";
        TariffDetails: Record "Tiered Charges Lines";
        //Periodic: Codeunit "Periodic Activities";
        Penalty: Decimal;
        Appraisal: Decimal;
        ClosureAccounts: Record "Account Closure Line";
        PFactory: Record "Product Factory";
        MemberwithdrawalNotice: Record "Member withdrawal Notice";
        TransactionTypes: Record "Transaction Types";
        TCharges: Decimal;
        Duty: Decimal;
        DisbAcc: Record "Savings Accounts";
        MemberCategory: Record "Member Category";
        LoanType: Record "Product Factory";
        AccountType: Record "Product Factory";
        TrAcc: Code[20];
        LoanApp: Record Loans;
        LoanRecoveryHeader: Record "Loan Recovery Header";

    procedure ValidateAmounts()
    var
        LType: Record "Product Factory";
        AcctType: Enum "Gen. Journal Account Type";
        Gl: Code[20];
    begin

        GenSetup.Get;
        IntTotal := 0;
        LoanTotal := 0;
        Appraisal := 0;
        Penalty := 0;
        "Total Loan" := LoanTotal;
        "Total Interest" := IntTotal;
        "Total Penalty" := Penalty;
        "Total Appraisal" := Appraisal;
        "Loan Registration Fee" := 0;
        "Suspended Interest" := InterestSus;

        "Defaulter Loan" := 0;

        if "Loans Option" <> "Loans Option"::" " then begin

            ClosureAccounts.Reset;
            ClosureAccounts.SetRange(ClosureAccounts."No.", "No.");
            ClosureAccounts.SetRange(ClosureAccounts.Close, true);
            if ClosureAccounts.Find('-') then begin
                repeat
                    SavingsAccounts.Get(ClosureAccounts."Account No.");
                    SavingsAccounts.CalcFields("Balance (LCY)");
                    "Member Savings" += SavingsAccounts."Balance (LCY)";
                    AccountType.Get(SavingsAccounts."Product Type");
                    LoanType.Reset;
                    LoanType.SetRange("Product Class Type", LoanType."Product Class Type"::Loan);
                    LoanType.SetRange("Appraisal Savings Product", AccountType."Product ID");

                    if LoanType.FindFirst then begin
                        repeat

                            Loans.Reset;
                            Loans.SetRange(Loans."Member No.", "Member No.");
                            Loans.SetRange("Loan Product Type", LoanType."Product ID");
                            Loans.SetFilter(Loans."Outstanding Balance", '>0');
                            //Loans.SetFilter("Global Dimension 1 Code", "Global Dimension 1 Code");
                            /* if "Loans Option" = "Loans Option"::"Long Term" then
                                 Loans.SetRange(Loans."Loan Span", Loans."Loan Span"::"Long Term")
                             else
                                 if "Loans Option" = "Loans Option"::"Short Term" then
                                     Loans.SetRange(Loans."Loan Span", Loans."Loan Span"::"Short Term");*/
                            if Loans.Find('-') then begin
                                repeat
                                    Loans.CalcFields(Loans."Outstanding Balance", "Interest Suspended", Loans."Outstanding Interest", "Outstanding Appraisal", "Outstanding Penalty", "Outstanding Loan Reg. Fee");
                                    IntTotal := IntTotal + Loans."Outstanding Interest";
                                    LoanTotal := LoanTotal + Loans."Outstanding Balance";
                                    Appraisal += Loans."Outstanding Appraisal";
                                    Penalty += Loans."Outstanding Penalty";
                                    InterestSus += Loans."Interest Suspended";
                                    "Loan Registration Fee" += Loans."Outstanding Loan Reg. Fee";
                                    if LType.Get(Loans."Loan Product Type") then
                                        if LType."Nature of Loan Type" = LType."Nature of Loan Type"::Defaulter then
                                            "Defaulter Loan" += (Loans."Outstanding Interest" + Loans."Outstanding Balance");

                                until Loans.Next = 0;
                            end;
                        until LoanType.Next = 0;
                    end;
                until ClosureAccounts.Next = 0
            end
            else begin
                //ERROR('Kindly update Which Accounts to Close First');
            end;


            "Total Loan" := LoanTotal;
            "Total Interest" := IntTotal;
            "Total Penalty" := Penalty;
            "Total Appraisal" := Appraisal;
            "Suspended Interest" := InterestSus;
        end;

        //CalcFields("Total Savings");
        /*SavingsAccounts.Reset();
        ;
        SavingsAccounts.SetRange("Product Category", SavingsAccounts."Product Category"::"Deposit Contribution");
        SavingsAccounts.SetRange("Member No.", "Member No.");
        if SavingsAccounts.FindFirst() then SavingsAccounts.CalcFields("Balance (LCY)");

        "Member Savings" := SavingsAccounts."Balance (LCY)";*/

        "Total Charges" := GetCharges + GetWithdrawalFee(Gl, AcctType);
        if "Charge Offset Fee" then
            "Total Charges" += Round(("Total Loan" + "Total Interest" - "Defaulter Loan") * GenSetup."Closure Loan Offset Fee %" / 100);
        if "Charge Rejoining Fee" then
            "Total Charges" += GenSetup."Rejoining Fee";



        "Deposit Refundable" := "Member Savings" - "Total Charges" - "Total Loan" - "Total Interest" - "Total Appraisal" - "Total Penalty" - "Loan Registration Fee";
        if "Deposit Refundable" > 0 then
            "Member Category" := "Member Category"::Creditor;
        if "Deposit Refundable" < 0 then
            "Member Category" := "Member Category"::Defaulter;
        if "Deposit Refundable" = 0 then
            "Member Category" := "Member Category"::" ";
    end;

    procedure GetCharges(): Decimal
    var
        DepPresent: Boolean;
    begin

        TCharges := 0;
        DepPresent := false;
        ClosureAccounts.Reset;
        ClosureAccounts.SetRange(ClosureAccounts."No.", "No.");
        ClosureAccounts.SetRange(ClosureAccounts.Close, true);
        if ClosureAccounts.Find('-') then begin
            repeat
                if PFactory.Get(ClosureAccounts."Product Type") then
                    if PFactory."Product Category" = PFactory."Product Category"::"Deposit Contribution" then
                        DepPresent := true;
            until ClosureAccounts.Next = 0;
        end;

        AccountClosureFee := 0;
        ClosureAccounts.Reset;
        ClosureAccounts.SetRange(ClosureAccounts."No.", "No.");
        ClosureAccounts.SetRange(ClosureAccounts.Close, true);
        if ClosureAccounts.Find('-') then begin
            repeat
                PFactory.Reset;
                PFactory.SetRange("Product ID", ClosureAccounts."Product Type");
                if DepPresent then
                    PFactory.SetRange("Product Category", PFactory."Product Category"::"Deposit Contribution");
                if PFactory.FindFirst then begin
                    //IF ProdutFactory."Account Type"<>ProdutFactory."Account Type"::"Share Deposit Account" THEN BEGIN

                    Amount[2] := 0;
                    //CLosure Fee

                    TransactionCharges.Reset;
                    TransactionCharges.SetRange(TransactionCharges."Transaction Type", PFactory."Closure Fee");
                    if TransactionCharges.Find('-') then begin
                        repeat
                            Amount[1] := 0;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then
                                Amount[1] := ("Member Savings" * TransactionCharges."Percentage of Amount") * 0.01
                            else
                                Amount[1] := TransactionCharges."Charge Amount";

                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if ("Member Savings" >= TariffDetails."Lower Limit") and ("Member Savings" <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" then
                                                Amount[1] := "Member Savings" * TariffDetails.Percentage * 0.01
                                            else
                                                Amount[1] := TariffDetails."Charge Amount";
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;

                            Amount[2] += Amount[1];
                        until TransactionCharges.Next = 0;


                        if Amount[2] < TransactionCharges."Minimum Amount" then
                            Amount[2] := TransactionCharges."Minimum Amount";


                        if Amount[2] > TransactionCharges."Maximum Amount" then
                            Amount[2] := TransactionCharges."Maximum Amount";

                    end;

                    if ClosureAccounts.Balance <= 0 then
                        Amount[2] := 0;


                    AccountClosureFee += Amount[2];


                    //            MESSAGE('%1',AccountClosureFee);

                    //IF "Close Account"="Close Account"::All THEN
                    //  AccountClosureFee:=0;


                    if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                        //Excise Duty
                        AccountClosureFee += (Amount[2] * GenSetup."Excise Duty (%)" * 0.01);

                    end;

                end;


            until ClosureAccounts.Next = 0;

        end;
        //End of Close Accounts
        TCharges += AccountClosureFee;
        AccountClosureFee := 0;


        //*********************Premature Withdrawal
        MemberwithdrawalNotice.Reset;
        MemberwithdrawalNotice.SetRange(MemberwithdrawalNotice."Member No.", "Member No.");
        MemberwithdrawalNotice.SetRange(MemberwithdrawalNotice.Status, MemberwithdrawalNotice.Status::Approved);
        if "Member Category" = "Member Category"::Creditor then
            if MemberwithdrawalNotice.Find('+') then begin
                if MemberwithdrawalNotice."Maturity Date" > "Document Date" then begin
                    //GenSetup.TESTFIELD("Premature Withdrawal Fee");

                    TransactionTypes.Reset;
                    TransactionTypes.SetRange(Code, GenSetup."Premature Withdrawal Fee");
                    if TransactionTypes.Find('-') then begin

                        //Charges
                        TCharges := 0;

                        TransactionCharges.Reset;
                        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionTypes.Code);
                        if TransactionCharges.Find('-') then begin
                            repeat

                                AccountClosureFee := 0;
                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                    AccountClosureFee := ("Member Savings" * TransactionCharges."Percentage of Amount") * 0.01
                                else
                                    AccountClosureFee := TransactionCharges."Charge Amount";

                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                                    TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                    TariffDetails.Reset;
                                    TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                    if TariffDetails.Find('-') then begin
                                        repeat
                                            if ("Member Savings" >= TariffDetails."Lower Limit") and ("Member Savings" <= TariffDetails."Upper Limit") then begin
                                                if TariffDetails."Use Percentage" = true then
                                                    AccountClosureFee := "Member Savings" * TariffDetails.Percentage * 0.01
                                                else
                                                    AccountClosureFee := TariffDetails."Charge Amount"
                                            end;

                                        until TariffDetails.Next = 0;
                                    end;
                                end;

                                if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                                    //Excise Duty
                                    AccountClosureFee += (AccountClosureFee * GenSetup."Excise Duty (%)" * 0.01);

                                end;
                            until TransactionCharges.Next = 0;
                        end;
                    end;
                end;
            end;
        //^^
        TCharges += AccountClosureFee;
        AccountClosureFee := 0;





        /*        
                IF "Close Account"="Close Account"::All THEN BEGIN


                    GenSetup.TESTFIELD("Full Withdrawal Fee");
                    Amount[2]:=0;
                    //CLosure Fee
                    AccountClosureFee:=0;
                    TransactionCharges.RESET;
                    TransactionCharges.SETRANGE(TransactionCharges."Transaction Type",GenSetup."Full Withdrawal Fee");
                    IF TransactionCharges.FIND('-') THEN BEGIN
                        REPEAT
                            Amount[1]:=0;
                            IF TransactionCharges."Charge Type"=TransactionCharges."Charge Type"::"% of Amount" THEN
                                Amount[1]:=("Member Savings"*TransactionCharges."Percentage of Amount")*0.01
                            ELSE
                                Amount[1]:=TransactionCharges."Charge Amount";

                            IF TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered THEN BEGIN
                                TransactionCharges.TESTFIELD(TransactionCharges."Staggered Charge Code");
                                TariffDetails.RESET;
                                TariffDetails.SETRANGE(TariffDetails.Code,TransactionCharges."Staggered Charge Code");
                                IF TariffDetails.FIND('-') THEN BEGIN
                                    REPEAT
                                        IF ("Member Savings" >= TariffDetails."Lower Limit") AND ("Member Savings"<= TariffDetails."Upper Limit") THEN BEGIN
                                            IF TariffDetails."Use Percentage" THEN
                                              Amount[1]:="Member Savings"*TariffDetails.Percentage*0.01
                                            ELSE
                                              Amount[1]:= TariffDetails."Charge Amount";
                                        END;
                                    UNTIL TariffDetails.NEXT =0;
                                END;
                            END;

                            IF Amount[1]<TransactionCharges."Minimum Amount" THEN
                            Amount[1]:=TransactionCharges."Minimum Amount";


                            IF Amount[1]>TransactionCharges."Maximum Amount" THEN
                            Amount[1]:=TransactionCharges."Maximum Amount";


                            Amount[2]+=Amount[1];

                            AccountClosureFee:=Amount[2];

                            Duty:=0;
                            IF TransactionCharges."Transaction Charge Category"<>TransactionCharges."Transaction Charge Category"::"Stamp Duty" THEN BEGIN
                                //Excise Duty
                                Duty:=(AccountClosureFee*GenSetup."Excise Duty (%)")*0.01;
                            END;

                            AccountClosureFee+=Duty;

                        UNTIL TransactionCharges.NEXT = 0;


                    END;
                END;

                TCharges+=AccountClosureFee;
            */


        exit(TCharges);

    end;

    procedure GetWithdrawalFee(var GLAcc: Code[20]; var AcctType: Enum "Gen. Journal Account Type"): Decimal
    var
        ChargeAmount: Decimal;
    begin
        GenSetup.Get();
        If GenSetUp."Withdrawal Fee" <> '' then begin
            GenSetUp.TestField("Withdrawal Fee");

            TransactionTypes.Reset;
            TransactionTypes.SetRange(TransactionTypes."Code", GenSetUp."Withdrawal Fee");
            if TransactionTypes.Find('-') then begin
                //Charges
                TCharges := 0;
                TransactionCharges.Reset;
                TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionTypes."Code");
                if TransactionCharges.Find('-') then begin
                    //repeat


                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (GetLineSavings() * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Rec."Member Savings" >= TariffDetails."Lower Limit") and (GetLineSavings() <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then
                                        ChargeAmount := GetLineSavings() * TariffDetails.Percentage * 0.01
                                    else
                                        ChargeAmount := TariffDetails."Charge Amount"
                                end;

                            until TariffDetails.Next = 0;
                        end;
                    end;

                    if ChargeAmount < TransactionCharges."Minimum Amount" then
                        ChargeAmount := TransactionCharges."Minimum Amount";


                    if ChargeAmount > TransactionCharges."Maximum Amount" then
                        ChargeAmount := TransactionCharges."Maximum Amount";
                end;
            end;
        end;
        GLAcc := TransactionCharges."G/L Account";
        AcctType := TransactionCharges."Account Type"::"G/L Account";
        exit(ChargeAmount);
    end;

    local procedure GetLineSavings() LineSav: Decimal
    var
        Sacc: Record "Savings Accounts";
    begin
        LineSav := 0;
        Sacc.Reset();
        Sacc.SetRange("Member No.", Rec."Member No.");
        // Sacc.SetRange("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
        if Sacc.Find('-') then
            repeat
                Sacc.CalcFields("Balance (LCY)");
                LineSav += Sacc."Balance (LCY)";
            until Sacc.Next() = 0;
    end;

}

