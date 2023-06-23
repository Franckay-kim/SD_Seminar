/// <summary>
/// Table Micro_Fin_Transactions (ID 51532395).
/// </summary>
table 51532395 Micro_Fin_Transactions
{

    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = true;
        }
        field(2; "Transaction Date"; Date)
        {
            Editable = true;
        }
        field(3; "Transaction Time"; Time)
        {
            Editable = true;
        }
        field(4; "Micro Saver Control Account"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor."No.";
        }
        field(5; "Group Code"; Code[20])
        {
            Editable = true;
            TableRelation = Members."No." WHERE("Group Account" = CONST(true));

            trigger OnValidate()
            begin
                if Posted <> true then begin
                    MicroSubform.Reset;
                    MicroSubform.SetRange(MicroSubform."No.", "No.");
                    if MicroSubform.Find('-') then
                        MicroSubform.DeleteAll;

                    if Memb.Get("Group Code") then
                        "Group Name" := Memb.Name;

                    if "Payment Type" = "Payment Type"::Normal then begin
                        SavingsAccounts.Reset;
                        SavingsAccounts.SetRange("Product Category", SavingsAccounts."Product Category"::"Micro Credit Deposits");
                        SavingsAccounts.SetRange(SavingsAccounts."Group Account No", "Group Code");
                        if SavingsAccounts.Find('-') then begin
                            repeat
                                SavingsAccounts.CalcFields("Balance (LCY)");
                                MicroSubform.Init;
                                MicroSubform."No." := "No.";
                                MicroSubform."Account Number" := SavingsAccounts."No.";
                                MicroSubform."Account Name" := SavingsAccounts.Name;
                                MicroSubform."Group Code" := "Group Code";
                                MicroSubform."Member No." := SavingsAccounts."Member No.";
                                MicroSubform.Savings := SavingsAccounts."Balance (LCY)";
                                MicroSubform."Branch/Agent" := "Deposited By";
                                MicroSubform."Date Banked" := "Date Banked";

                                ProductFactory.Get(SavingsAccounts."Product Type");
                                ProductFactory.TestField("Minimum Contribution");

                                AmtPaid := 0;
                                SLedger.Reset;
                                SLedger.SetRange("Customer No.", SavingsAccounts."No.");
                                SLedger.SetRange("Posting Date", CalcDate('-CM', Today), CalcDate('CM', Today));
                                if SLedger.FindFirst then begin
                                    SLedger.CalcSums(Amount);
                                    AmtPaid := SLedger.Amount * -1;
                                end;

                                MicroSubform."Expected Deposits" := ProductFactory."Minimum Contribution" - AmtPaid;

                                if MicroSubform."Expected Deposits" < 0 then
                                    MicroSubform."Expected Deposits" := 0;


                                LoanApplic.Reset;
                                LoanApplic.SetRange("Member No.", SavingsAccounts."Member No.");
                                LoanApplic.SetRange(LoanApplic."Group Code", "Group Code");
                                LoanApplic.SetFilter(LoanApplic."Outstanding Balance", '>0');
                                LoanApplic.SetRange("Loan Group", LoanApplic."Loan Group"::MFI);
                                LoanApplic.SetFilter("Date Filter", '..%1', Today);
                                if LoanApplic.Find('-') then begin
                                    repeat
                                        MicroSubform."Loan No." := LoanApplic."Loan No.";

                                        LoanApplic.CalcFields("Interest Paid", "Schedule Interest", "Outstanding Balance", "Outstanding Bills", "Outstanding Interest", "Outstanding Penalty", "Outstanding Appraisal");

                                        if LoanApplic."Outstanding Bills" > LoanApplic."Outstanding Balance" then
                                            LoanApplic."Outstanding Bills" := LoanApplic."Outstanding Balance";

                                        LoanApplic."Outstanding Bills" += LoanApplic."Loan Principle Repayment";


                                        if LoanApplic."Outstanding Bills" < 0 then
                                            LoanApplic."Outstanding Bills" := 0;
                                        if LoanApplic."Outstanding Interest" < 0 then
                                            LoanApplic."Outstanding Interest" := 0;
                                        if LoanApplic."Outstanding Penalty" < 0 then
                                            LoanApplic."Outstanding Penalty" := 0;

                                        LoanApplic."Interest Paid" := (LoanApplic."Loan Interest Repayment" * LoanApplic.Installments) - LoanApplic."Outstanding Interest";

                                        //IF LoanApplic."Member No." = '29864' THEN
                                        //MESSAGE('',);

                                        InterestDue := 0;

                                        if LoanApplic."Outstanding Interest" > 0 then begin
                                            //InterestDue:=LoanApplic."Loan Interest Repayment"-LoansProcess.GetLoanMonthlyFeePaid(LoanApplic."Loan No.",CALCDATE('-CM',TODAY),TODAY,TransType::"Interest Paid");

                                            //InterestDue := Periodic.GetInterestDue(LoanApplic);

                                            if InterestDue > LoanApplic."Outstanding Interest" then
                                                InterestDue := LoanApplic."Outstanding Interest";

                                        end;




                                        if InterestDue < 0 then
                                            InterestDue := 0;


                                        MicroSubform."Outstanding Interest" := LoanApplic."Outstanding Interest";
                                        MicroSubform."Outstanding Appraisal" := LoanApplic."Outstanding Appraisal";

                                        AppraisalDue := 0;

                                        if LoanApplic."Outstanding Appraisal" > 0 then begin
                                            //AppraisalDue:=LoanApplic."Appraisal Fee"-LoansProcess.GetLoanMonthlyFeePaid(LoanApplic."Loan No.",CALCDATE('-CM',TODAY),TODAY,TransType::"Appraisal Paid");

                                            //AppraisalDue := Periodic.GetAppraisalDue(LoanApplic);

                                            if AppraisalDue > LoanApplic."Outstanding Appraisal" then
                                                AppraisalDue := LoanApplic."Outstanding Appraisal";

                                        end;



                                        if AppraisalDue < 0 then
                                            AppraisalDue := 0;

                                        MicroSubform."Expected Penalty" += LoanApplic."Outstanding Penalty";
                                        MicroSubform."Expected Appraisal Fee" += AppraisalDue;
                                        MicroSubform."Expected Interest" += InterestDue;
                                        MicroSubform."Expected Principle Amount" += LoanApplic."Outstanding Bills";
                                        MicroSubform."Outstanding Balance" += LoanApplic."Outstanding Balance";

                                        MicroSubform."Branch Code" := "Transacting Branch";

                                    until LoanApplic.Next = 0;
                                end;

                                MicroSubform.Insert;
                            until SavingsAccounts.Next = 0;
                        end;
                    end;


                    if "Payment Type" = "Payment Type"::"Pass Book" then begin
                        SavingsAccounts.Reset;
                        SavingsAccounts.SetRange("Product Category", SavingsAccounts."Product Category"::"Micro Credit Deposits");
                        SavingsAccounts.SetRange(SavingsAccounts."Group Account No", "Group Code");
                        if SavingsAccounts.Find('-') then begin
                            repeat
                                SavingsAccounts.CalcFields("Balance (LCY)");
                                MicroSubform.Init;
                                MicroSubform."No." := "No.";
                                MicroSubform."Account Number" := SavingsAccounts."No.";
                                MicroSubform."Account Name" := SavingsAccounts.Name;
                                MicroSubform."Group Code" := "Group Code";
                                MicroSubform."Member No." := SavingsAccounts."Member No.";
                                MicroSubform.Savings := SavingsAccounts."Balance (LCY)";
                                MicroSubform."Branch/Agent" := "Deposited By";
                                MicroSubform."Date Banked" := "Date Banked";
                                MicroSubform."Branch Code" := "Transacting Branch";
                                MicroSubform.Insert;
                            until SavingsAccounts.Next = 0;
                        end;
                    end;

                    /*
                    IF "Payment Type"="Payment Type"::Savings THEN BEGIN
                        SavingsAccounts.RESET;
                        SavingsAccounts.SETRANGE("Product Category",SavingsAccounts."Product Category"::"Micro Credit Deposits");
                        SavingsAccounts.SETRANGE(SavingsAccounts."Group Account No","Group Code");
                        IF SavingsAccounts.FIND('-') THEN BEGIN
                            REPEAT
                                SavingsAccounts.CALCFIELDS("Balance (LCY)");
                                MicroSubform.INIT;
                                MicroSubform."No.":="No.";
                                MicroSubform."Account Number":=SavingsAccounts."No.";
                                MicroSubform."Account Name":=SavingsAccounts.Name;
                                MicroSubform."Group Code":="Group Code";
                                MicroSubform."Member No.":=SavingsAccounts."Member No.";
                                MicroSubform.Savings:=SavingsAccounts."Balance (LCY)";
                                MicroSubform."Branch/Agent":="Deposited By";
                                MicroSubform."Date Banked":="Date Banked";
                                IF "Group Code"<>'' THEN
                                  Memb.GET("Group Code");
                                "Group Name":=Memb.Name;
                                MicroSubform.INSERT;
                            UNTIL SavingsAccounts.NEXT=0;
                        END;
                    END
                    ELSE BEGIN
                        LoanApplic.RESET;
                        LoanApplic.SETRANGE(LoanApplic."Group Code","Group Code");
                        LoanApplic.SETFILTER(LoanApplic."Outstanding Balance",'>0');
                        IF LoanApplic.FIND('-') THEN BEGIN
                            REPEAT
                                LoanApplic.CALCFIELDS(LoanApplic."Outstanding Balance",LoanApplic."Outstanding Bills",LoanApplic."Outstanding Interest");
                                MicroSubform.INIT;
                                MicroSubform."No.":="No.";
                                MicroSubform."Account Number":=LoanApplic."Loan Account";
                                MicroSubform."Account Name":=LoanApplic."Member Name";
                                MicroSubform."Group Code":="Group Code";
                                MicroSubform."Branch/Agent":="Deposited By";
                                MicroSubform."Date Banked":="Date Banked";
                                IF "Group Code"<>'' THEN
                                Memb.GET("Group Code");
                                "Group Name":=Memb.Name;
                                MicroSubform."Expected Principle Amount":=LoanApplic."Outstanding Bills";
                                MicroSubform."Expected Interest":=LoanApplic."Outstanding Interest";
                                MicroSubform."Outstanding Balance":=LoanApplic."Outstanding Balance";
                                MicroSubform."Branch Code":="Transacting Branch";
                                MicroSubform."Member No.":=LoanApplic."Member No.";
                                MicroSubform."Loan No.":=LoanApplic."Loan No.";
                                MicroSubform.INSERT;
                            UNTIL LoanApplic.NEXT=0;
                        END;
                    END;
                    */
                end;

            end;
        }
        field(6; Amount; Decimal)
        {
            Editable = true;
        }
        field(7; Balance; Decimal)
        {
        }
        field(8; Posted; Boolean)
        {
            Editable = false;
        }
        field(9; "Posted By"; Code[50])
        {
            Editable = false;
        }
        field(10; "Total Repayment"; Decimal)
        {
            FieldClass = Normal;
        }
        field(11; "Account No"; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Members)) Members
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::"Bank Account" then begin
                    BANKACC.Reset;
                    BANKACC.SetRange(BANKACC."No.", "Account No");
                    if BANKACC.Find('-') then begin
                        "Account Name" := BANKACC.Name;
                    end else
                        if "Account Type" = "Account Type"::Members then begin
                            SavAccs.Reset;
                            SavAccs.SetRange(SavAccs."No.", "Account No");
                            if SavAccs.Find('-') then begin
                                "Account Name" := SavAccs.Name;
                            end;
                        end;
                end;
            end;
        }
        field(12; "No. Series"; Code[10])
        {
        }
        field(13; "Savings/Loan Rep"; Option)
        {
            OptionMembers = Savings,"Loan Repayment";
        }
        field(14; "Post to InterBranch Account"; Boolean)
        {
        }
        field(15; "Transacting Branch"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(16; "Total Savings"; Decimal)
        {
            CalcFormula = Sum(Micro_Fin_Schedules.Amount WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(17; "Account Type"; Option)
        {
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Members,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Members,"Bank Account","Fixed Asset";
        }
        field(18; "Account Name"; Code[50])
        {
            Editable = false;
        }
        field(19; "Total Penalty"; Decimal)
        {
        }
        field(20; "Total Principle"; Decimal)
        {
        }
        field(21; "Total Interest"; Decimal)
        {
        }
        field(22; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(23; "Total Amount"; Decimal)
        {
            CalcFormula = Sum(Micro_Fin_Schedules.Amount WHERE("No." = FIELD("No."),
                                                                "Group Code" = FIELD("Group Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Group Name"; Text[50])
        {
        }
        field(25; "Total Amount Received"; Decimal)
        {
            CalcFormula = Sum(Micro_Fin_Schedules.Amount WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; Cashier; Code[50])
        {
        }
        field(27; "Date Banked"; Date)
        {
        }
        field(28; "Deposited By"; Text[50])
        {
        }
        field(50008; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            Enabled = false;
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50009; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            Editable = false;
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50010; "Payment Type"; Option)
        {
            OptionCaption = ' ,Normal,Pass Book';
            OptionMembers = " ",Normal,"Pass Book";

            trigger OnValidate()
            begin
                if "Group Code" <> '' then
                    Validate("Group Code");
            end;
        }
        field(50011; "Loan Clearance"; Boolean)
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
        if Posted then
            Error('Cannot delete a posted transaction');
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Micro Finance Transactions");
            noseriesmgt.InitSeries(SalesSetup."Micro Finance Transactions", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Transaction Date" := Today;
        "Transaction Time" := Time;
        Cashier := UserId;
        //"Posted By":= USERID;
        Temp.Get(UserId);

        Jtemplate := Temp."Cashier Journal Template";
        TillNo := Temp."Default  Bank";
        "Date Banked" := Today;
        //IF TillNo='' THEN
        //ERROR('User does not have a cashier till')

        "Account Type" := "Account Type"::"Bank Account";
        "Account No" := TillNo;
        Validate("Account No");

        UserSetup.Get(UserId);
        // "Transacting Branch":=UserSetup."Global Dimension 2 Code";
        // "Global Dimension 1 Code":=UserSetup."Global Dimension 1 Code";
        // "Global Dimension 2 Code":=UserSetup."Global Dimension 2 Code";
    end;

    trigger OnModify()
    begin
        if Posted then
            Error('Cannot modify a posted transaction');
    end;

    var
        SavingsAccounts: Record "Savings Accounts";
        LoanApplic: Record Loans;
        noseriesmgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Banking No Setup";
        MicroSubform: Record Micro_Fin_Schedules;
        BANKACC: Record "Bank Account";
        SavAccs: Record "Savings Accounts";
        grouptrans: Record "Group Transactions";
        Memb: Record Members;
        user: Record "User Setup";
        UserSetup: Record "User Setup";
        CredAccs: Record "Credit Accounts";
        Temp: Record "Banking User Template";
        Jtemplate: Code[20];
        TillNo: Code[20];
        //LoansProcess: Codeunit "Loans Process";
        AppraisalDue: Decimal;
        ProductFactory: Record "Product Factory";
        InterestDue: Decimal;
        SLedger: Record "Savings Ledger Entry";
        AmtPaid: Decimal;
        TransType: Option " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Ledger Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid";
    //Periodic: Codeunit "Periodic Activities";
}

