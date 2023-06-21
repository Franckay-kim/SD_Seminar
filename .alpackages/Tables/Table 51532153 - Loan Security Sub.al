table 51532153 "Loan Security Sub"
{


    fields
    {
        field(1; "Loan No"; Code[20])
        {
            NotBlank = true;
            TableRelation = Loans."Loan No.";
        }
        field(2; "Savings Account No./Member No."; Code[20])
        {
            /*TableRelation = IF ("Guarantor Type" = CONST(Guarantor)) "Savings Accounts"."No." where("Can Guarantee Loan" = const(true), "Product Category" = const("Deposit Contribution"))
            ELSE
            IF ("Guarantor Type" = CONST(Collateral)) Members."No."
            ELSE
            IF ("Guarantor Type" = CONST(Lien)) "Savings Accounts"."No."
            ELSE
            IF ("Guarantor Type" = CONST(Institution)) Customer."No." WHERE("Account Type" = CONST(Employer));*/

            trigger OnValidate()
            begin
                if "Savings Account No./Member No." <> '' then
                    "New Security" := true
                else
                    "New Security" := false;


                LoanSubHeader.Get("Sub Header");
                //"Loan No" := LoanSubHeader."Loan No.";






                GenSetUp.Get;

                "Self Guarantee" := false;
                SelfGuaranteedA := 0;
                Date := Today;


                //Set Member Guaranteed
                if LoansR.Get("Loan No") then begin
                    "Member Guaranteed" := LoansR."Member No.";
                    "Loanee Name" := LoansR."Member Name";
                    Members.Get(LoansR."Member No.");
                    LoaneeEmployer := Members."Employer Code";
                end;

                if "Guarantor Type" = "Guarantor Type"::Guarantor then begin

                    //Evaluate guarantor basic info
                    if Cust.Get("Savings Account No./Member No.") then begin



                        if Employer.Get(Cust."Employer Code") then begin

                            //if Employer.Guarantorship = Employer.Guarantorship::"Cannot Guarantee" then
                            // Error(Text001,Employer.Name);

                        end;
                        GenSetUp.Get;

                        Cust.CalcFields(Cust."Balance (LCY)");
                        Name := Cust.Name;
                        "Staff/Payroll No." := Cust."Payroll/Staff No.";
                        "Deposits/Shares" := Cust."Balance (LCY)" * GenSetUp."Guarantors Multiplier";

                        "ID No." := Cust."ID No.";
                        "Member No" := Cust."Member No.";
                        //"Application Amount Guaranteed" := LoanProcess.GetMemberCommittedDeposits("Savings Account No./Member No.", false);
                        // "Total Guarantor Commitment" := "Application Amount Guaranteed" + LoanProcess.GetMemberCommittedDeposits("Savings Account No./Member No.", true);
                        if Substituted then
                            "Total Guarantor Commitment" -= "Amount Guaranteed";

                        "Available Guarantorship" := "Deposits/Shares" - "Total Guarantor Commitment";
                        "Qualifying Amount" := "Deposits/Shares" - "Total Guarantor Commitment";


                        if "Available Guarantorship" < 0 then
                            "Available Guarantorship" := 0;

                    end;

                end
                else
                    if "Guarantor Type" = "Guarantor Type"::Collateral then begin
                        if Members.Get("Savings Account No./Member No.") then begin
                            SecReg.Reset;
                            SecReg.SetRange("Account No.", "Savings Account No./Member No.");
                            SecReg.SetRange(Status, SecReg.Status::Approved);
                            if SecReg.FindFirst then begin
                                Name := Members.Name;
                                "Staff/Payroll No." := Members."Payroll/Staff No.";
                                "ID No." := Members."ID No.";
                                "Member No" := "Savings Account No./Member No.";
                                "Deposits/Shares" := SecReg."Charged Value";
                                /*"Current Committed" := LoanProcess.GetCommittedCollateral("Collateral Reg. No.", true);
                                "Qualifying Amount" := "Deposits/Shares" - "Current Committed";
                                "Application Amount Guaranteed" := LoanProcess.GetCommittedCollateral("Savings Account No./Member No.", false);
                                "Total Guarantor Commitment" := "Application Amount Guaranteed" + LoanProcess.GetCommittedCollateral("Savings Account No./Member No.", true);
                                "Available Guarantorship" := "Deposits/Shares" - "Total Guarantor Commitment";*/

                            end;
                        end;
                    end
                    else
                        if "Guarantor Type" = "Guarantor Type"::Institution then begin
                            if Employer.Get("Savings Account No./Member No.") then begin

                                if LoaneeEmployer <> Employer."No." then
                                    Error('Loanee is not under this employer. Current Value is %1', LoaneeEmployer);

                                Name := Employer.Name;
                                //"Staff/Payroll No." := Members."Payroll/Staff No.";
                                //"ID No.":=Members."ID No.";
                                //"Member No":="Savings Account No./Member No.";

                            end;
                        end
                        else begin
                            if Cust.Get("Savings Account No./Member No.") then begin
                                //        IF (Cust.Status<>Cust.Status::Active)OR (Cust.Status<>Cust.Status::Dormant)THEN
                                //           ERROR('Member No. %1 is not an Active Member',Cust."No.");

                                Name := Cust.Name;
                                "Staff/Payroll No." := Cust."Payroll/Staff No.";
                                "Deposits/Shares" := Cust."Balance (LCY)";
                                "ID No." := Cust."ID No.";
                                "Member No" := Cust."Member No.";
                                /*"Application Amount Guaranteed" := LoanProcess.GetMemberCommittedLien("Savings Account No./Member No.", false);
                                "Total Guarantor Commitment" := "Application Amount Guaranteed" + LoanProcess.GetMemberCommittedLien("Savings Account No./Member No.", true);*/
                                if Substituted then
                                    "Total Guarantor Commitment" -= "Amount Guaranteed";

                                "Available Guarantorship" := "Deposits/Shares" - "Total Guarantor Commitment";

                                if "Available Guarantorship" < 0 then
                                    "Available Guarantorship" := 0;

                                //"Amount Guaranteed":=Cust."Lien Placed";

                            end;
                        end;
            end;
        }
        field(3; Name; Text[200])
        {
            Editable = false;
        }
        field(4; "Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(5; "Deposits/Shares"; Decimal)
        {
            Editable = false;
        }
        field(6; "Loans Guaranteed"; Integer)
        {
            CalcFormula = Count("Loan Guarantors and Security" WHERE("Savings Account No./Member No." = FIELD("Savings Account No./Member No."),
                                                                      Substituted = FILTER(false),
                                                                      "Outstanding Balance" = FILTER(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; Substituted; Boolean)
        {

            trigger OnValidate()
            begin
                Date := Today;

                /*
                IF Substituted THEN
                  TESTFIELD("Substitute Account No")
                ELSE
                  "Substitute Account No":='';
                  */

                Validate("Savings Account No./Member No.");

            end;
        }
        field(8; Date; Date)
        {
        }
        field(9; "Shares Recovery"; Boolean)
        {
        }
        field(10; "New Upload"; Boolean)
        {
        }
        field(11; "Amount Guaranteed"; Decimal)
        {

            trigger OnValidate()
            begin

                LoanApp.Get("Loan No");

                CalcFields("Outstanding Balance");
                "Current Committed" := Round("Amount Guaranteed" / LoanApp."Approved Amount" * "Outstanding Balance", 0.01, '>');

                TotG := 0;
                if "Current Committed" > "Available Guarantorship" then
                    Error('You cannot guarantee more than the available guarantorship of %1', "Available Guarantorship");
            end;
        }
        field(12; "Staff/Payroll No."; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                Cust.RESET;
                Cust.SETRANGE(Cust."Payroll/Staff No.","Staff/Payroll No.");
                Cust.SETRANGE(Cust."Loan Security Inclination",Cust."Loan Security Inclination"::"Long Term Loan Security");
                IF Cust.FIND('-') THEN BEGIN
                "Savings Account No./Member No.":=Cust."No.";
                VALIDATE("Savings Account No./Member No.");
                END
                ELSE BEGIN
                "Savings Account No./Member No.":='';
                //**ERROR('Member deposits account not found.');
                END;
                */

            end;
        }
        field(13; "Account No."; Code[20])
        {
        }
        field(14; "Self Guarantee"; Boolean)
        {
        }
        field(15; "ID No."; Code[50])
        {
        }
        field(16; "Outstanding Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Loan No" = FIELD("Loan No"),
                                                                  "Transaction Type" = FILTER(Loan | Repayment)));
            FieldClass = FlowField;
        }
        field(17; "Member Guaranteed"; Code[50])
        {
        }
        field(18; "Percentage Guaranteed"; Decimal)
        {
        }
        field(19; "Total Guaranteed"; Decimal)
        {
        }
        field(20; "Available Guarantorship"; Decimal)
        {
        }
        field(21; Signature; BLOB)
        {
        }
        field(22; "Member No"; Code[20])
        {
        }
        field(23; "Loan Type"; Code[20])
        {
            CalcFormula = Lookup(Loans."Loan Product Type" WHERE("Loan No." = FIELD("Loan No")));
            FieldClass = FlowField;
        }
        field(24; "Guaranteed Balance"; Decimal)
        {
        }
        field(25; "Loanee Name"; Text[150])
        {
            Editable = false;
        }
        field(26; "Guarantor Type"; Option)
        {
            OptionCaption = 'Guarantor,Collateral,Lien,Institution';
            OptionMembers = Guarantor,Collateral,Lien,Institution;
        }
        field(27; "Collateral Reg. No."; Code[20])
        {
            TableRelation = "Securities Register"."No." WHERE("Account No." = FIELD("Savings Account No./Member No."),
                                                               Status = CONST(Approved),
                                                               "Inward/Outward" = CONST("In-Store"));

            trigger OnValidate()
            begin
                if "Collateral Reg. No." <> '' then
                    "New Security" := true
                else
                    "New Security" := false;

                /*if SecReg.Get("Collateral Reg. No.") then begin
                    //"Deposits/Shares" := SecReg."Charged Value";
                    //"Deposits/Shares" := SecReg."Forced Sale Value";
                    "Deposits/Shares" := SecReg."Collateral Limit";

                    "Collateral Value" := SecReg."Collateral Value";
                    "Current Committed" := LoanProcess.GetCommittedCollateral("Collateral Reg. No.", true);
                    "Qualifying Amount" := "Deposits/Shares" - "Current Committed";
                    "Application Amount Guaranteed" := LoanProcess.GetCommittedCollateral("Collateral Reg. No.", false);
                    "Total Guarantor Commitment" := "Application Amount Guaranteed" + LoanProcess.GetCommittedCollateral("Collateral Reg. No.", true);
                    "Available Guarantorship" := "Deposits/Shares" - "Total Guarantor Commitment";

                    if "Available Guarantorship" < 0 then
                        "Available Guarantorship" := 0;

                end;*/

                /*
                LoanGuar.RESET;
                LoanGuar.SETFILTER("Outstanding Balance",'>0');
                LoanGuar.SETRANGE("Collateral Reg. No.","Collateral Reg. No.");
                IF LoanGuar.FIND('-') THEN BEGIN
                  LoanGuar.CALCFIELDS("Outstanding Balance");
                  ERROR(Text004,LoanGuar."Loan No",LoanGuar."Outstanding Balance");
                END;
                */

            end;
        }
        field(28; "Collateral Value"; Decimal)
        {
        }
        field(29; "SMS Sent"; Boolean)
        {
        }
        field(30; "Total Sum"; Decimal)
        {
        }
        field(31; "Substitute Account No"; Code[50])
        {
            /*  TableRelation = IF ("Substitute Type" = CONST(Guarantor)) "Savings Accounts"."No." WHERE("Product Category" = FILTER("Deposit Contribution"))
              ELSE
              IF ("Substitute Type" = CONST(Collateral)) Members."No." WHERE(Status = CONST(Active))
              ELSE
              IF ("Substitute Type" = CONST(Lien)) "Savings Accounts"."No." WHERE("Lien Placed" = FILTER(<> 0))
              ELSE
              IF ("Substitute Type" = CONST("Micro Savings")) "Savings Accounts"."No." WHERE("Product Category" = FILTER("Micro Credit Deposits"));*/
        }
        field(32; "Substitute Name"; Text[30])
        {
        }
        field(33; "Current Committed"; Decimal)
        {
        }
        field(34; "Application Amount Guaranteed"; Decimal)
        {
        }
        field(35; "Total Guarantor Commitment"; Decimal)
        {
        }
        field(36; "Sub Header"; Code[20])
        {
        }
        field(37; "Substitute Type"; Option)
        {
            OptionCaption = 'Guarantor,Collateral,Lien,Micro Savings';
            OptionMembers = Guarantor,Collateral,Lien,"Micro Savings";
        }
        field(38; "New Security"; Boolean)
        {
        }
        field(39; "Super Guarantor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40; Added; Boolean)
        {

        }
        field(41; "Qualifying Amount"; Decimal)
        {

        }

    }

    keys
    {
        key(Key1; "Sub Header", "Loan No", "Staff/Payroll No.", "Savings Account No./Member No.", "Collateral Reg. No.")
        {
        }
        key(Key2; "Loan No", "Savings Account No./Member No.")
        {
            SumIndexFields = "Deposits/Shares";
        }
        key(Key3; "Total Sum")
        {
        }

    }


    fieldgroups
    {
    }
    trigger OnInsert()

    begin
        Added := true;
    end;

    var
        Cust: Record "Savings Accounts";
        LoanGuarantors: Record "Loan Guarantors and Security";
        Loans: Record Loans;
        LoansR: Record Loans;
        LoansG: Integer;
        GenSetUp: Record "General Set-Up";
        SelfGuaranteedA: Decimal;
        StatusPermissions: Record "Credit Ledger Entry";
        LoanProduct: Record "Loan Charges";
        TotalGuaranteed: Decimal;
        BalanceRemaining: Decimal;
        LoanGuar: Record "Loan Guarantors and Security";
        TotG: Decimal;
        Members: Record Members;
        SecReg: Record "Securities Register";
        Employer: Record Customer;
        Text001: Label '%1 Members are not allowed to guarantee loans';
        Text002: Label 'This member has self guaranteed %1 and has a balance of %2';
        LoanApp: Record Loans;
        Text003: Label 'This Loan is already %1 and cannot modify';
        Text004: Label 'This collateral has been used for loan no. %1 and has a outstanding balance of %2';
        LoanGs: Record "Loan Guarantors and Security";
        //LoanProcess: Codeunit "Loans Process";
        LoanSubHeader: Record "Guarantors Substitution";
        LoanSubLine: Record "Loan Security Sub";
        LoaneeEmployer: Code[20];
}

