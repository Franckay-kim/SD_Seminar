/// <summary>
/// Table PR Employee Transactions (ID 51533116).
/// </summary>
table 51533116 "PR Employee Transactions"
{
    DataCaptionFields = "Employee Code";

    fields
    {
        field(1; "Employee Code"; Code[30])
        {
            Description = '"HR Employees".No.';
            TableRelation = "HR Employees"."No.";
        }
        field(2; "Transaction Code"; Code[30])
        {
            Description = '"PR Transaction Codes"."Transaction Code"';
            TableRelation = "PR Transaction Codes"."Transaction Code";

            trigger OnValidate()
            begin



                Transcode.Reset;
                Transcode.SetRange(Transcode."Transaction Code", "Transaction Code");
                if Transcode.Find('-') then
                    "Transaction Name" := Transcode."Transaction Name";
                "Loan product Type" := Transcode."Loan Product Type";


                if Transcode."Special Transactions" = Transcode."Special Transactions"::"Leave Allowance" then begin

                    objPeriod.Reset;
                    objPeriod.SetRange(objPeriod.Closed, false);
                    if objPeriod.Find('-') then begin
                        PREmployeeTrans.Reset;
                        PREmployeeTrans.SetRange("Employee Code", "Employee Code");
                        PREmployeeTrans.SetRange("Transaction Code", Transcode."Transaction Code");
                        PREmployeeTrans.SetRange("Period Year", objPeriod."Period Year");
                        if PREmployeeTrans.FindFirst then
                            Error('Member has already earned this allowance for the Year %1', objPeriod."Period Year");
                    end;
                end;

                //Allowances based on job grades
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Employee Code");
                if HREmp.Find('-') then begin
                    Members.Reset;
                    Members.SetRange("Payroll/Staff No.", "Employee Code");
                    Members.SetRange("Account Category", Members."Account Category"::"Staff Members");
                    if Members.FindFirst then
                        "Member No" := Members."No.";


                end;


                //Consume checkoff loan amounts from loans
                Transcode.Reset;
                Transcode.SetRange(Transcode."Transaction Code", "Transaction Code");
                Transcode.SetRange(Transcode.Subledger, Transcode.Subledger::Savings);
                if Transcode.Find('-') then begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange("Member No.", "Member No");
                    SavingsAccounts.SetRange("Product Type", Transcode."Loan Product Type");
                    if SavingsAccounts.FindFirst then begin
                        SavingsAccounts.CalcFields("Balance (LCY)");
                        Balance := SavingsAccounts."Balance (LCY)";
                        Amount := SavingsAccounts."Monthly Contribution";
                        if SavingsAccounts."Product Category" = SavingsAccounts."Product Category"::"Registration Fee" then begin
                            if Balance = 0 then begin
                                ProductFactory.Get(SavingsAccounts."Product Type");
                                Amount := ProductFactory."Minimum Contribution";
                            end;
                        end;
                    end;
                end;


                Transcode.Reset;
                Transcode.SetRange(Transcode."Transaction Code", "Transaction Code");
                Transcode.SetRange(Transcode."Special Transactions", Transcode."Special Transactions"::"Staff Loan (Sacco)");
                if Transcode.Find('-') then begin

                    Loans.Reset;
                    Loans.SetRange(Loans."Member No.", "Member No");
                    Loans.SetFilter("Total Outstanding Balance", '>0');
                    Loans.SetRange(Loans."Loan Product Type", Transcode."Loan Product Type");
                    Loans.SetCurrentKey("Disbursement Date");
                    if Loans.Find('+') then begin
                        Loans.CalcFields("Outstanding Interest", "Outstanding Balance", "Outstanding Penalty", "Outstanding Loan Reg. Fee");
                        "#of Repayments" := Loans.Installments;
                        "Loan Number" := Loans."Loan No.";
                        Balance := Loans."Outstanding Balance";
                        if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::Amortised then begin
                            if (Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Outstanding Penalty") >= Loans.Repayment then
                                Amount := Loans.Repayment else
                                Amount := (Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Outstanding Penalty");
                        end
                        else begin
                            if (Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Outstanding Penalty") >= Loans.Repayment then
                                Amount := Loans.Repayment else
                                Amount := (Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Outstanding Penalty");
                        end;
                        "Loan Interest Rate" := Loans.Interest / 12;
                        "Amortized Loan Total Repay Amt" := PrLoans.Repayment;

                    end

                end
            end;
        }
        field(3; "Transaction Name"; Text[100])
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; Balance; Decimal)
        {

            trigger OnValidate()
            begin
                "#of Repayments" := 0;
                //IF (Balance > 0) AND ("#of Repayments" > 0) THEN
                //Amount:=Balance/"#of Repayments"
            end;
        }
        field(6; "Original Amount"; Decimal)
        {
        }
        field(7; "Period Month"; Integer)
        {
        }
        field(8; "Period Year"; Integer)
        {
        }
        field(9; "Payroll Period"; Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(10; "#of Repayments"; Integer)
        {

            trigger OnValidate()
            begin
                if (Balance > 0) and ("#of Repayments" > 0) then
                    Amount := Balance / "#of Repayments"
            end;
        }
        field(11; Membership; Code[10])
        {
            // TableRelation = "prInstitutional Membership"."Institution No";
        }
        field(12; "Reference No"; Text[100])
        {
        }
        field(13; integera; Integer)
        {
        }
        field(14; "Employer Amount"; Decimal)
        {
        }
        field(15; "Employer Balance"; Decimal)
        {
        }
        field(16; "Stop for Next Period"; Boolean)
        {
        }
        field(17; "Amortized Loan Total Repay Amt"; Decimal)
        {
        }
        field(18; "Start Date"; Date)
        {
        }
        field(19; "End Date"; Date)
        {
        }
        field(20; "Loan Number"; Code[20])
        {
            TableRelation = Loans."Loan No." WHERE("Staff No" = FIELD("Employee Code"),
                                                    "Outstanding Balance" = FILTER(> 0),
                                                    "Loan Product Type" = FIELD("Loan product Type"));

            trigger OnValidate()
            begin
                Loans.Reset;
                Loans.SetRange("Loan No.", "Loan Number");
                if Loans.FindFirst then begin
                    Transcode.Get("Transaction Code");
                    Loans.CalcFields("Outstanding Interest", "Outstanding Balance");
                    "#of Repayments" := Loans.Installments;
                    "Loan Number" := Loans."Loan No.";

                    "Loan Interest Rate" := Loans.Interest / 12;
                    "Amortized Loan Total Repay Amt" := PrLoans.Repayment;
                    Message(Format(Transcode."coop parameters"));
                    if Transcode."coop parameters" = Transcode."coop parameters"::loan then begin
                        if (Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Outstanding Penalty") >= Loans.Repayment then
                            Amount := Round(Loans.Repayment, 0.01, '>') else
                            Amount := (Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Outstanding Penalty");
                        Balance := Round(Loans."Outstanding Balance", 0.01, '>');
                    end;

                    if Transcode."coop parameters" = Transcode."coop parameters"::"loan Interest" then begin
                        Amount := Round(Loans."Loan Interest Repayment", 0.01, '>');
                        Balance := Round(Loans."Outstanding Interest", 0.01, '>');
                    end;
                end
            end;
        }
        field(21; "Payroll Code"; Code[20])
        {
            //TableRelation = "prPayroll Type";
        }
        field(22; "No of Units"; Decimal)
        {
        }
        field(23; Suspended; Boolean)
        {
        }
        field(24; "Entry No"; Integer)
        {
            AutoIncrement = false;
        }
        field(38; "IsCoop/LnRep"; Boolean)
        {
            CalcFormula = Lookup("PR Transaction Codes"."IsCoop/LnRep" WHERE("Transaction Code" = FIELD("Transaction Code")));
            Description = 'to be able to report the different coop contributions -Dennis';
            FieldClass = FlowField;
        }
        field(39; EmployeePostingG; Code[20])
        {
            CalcFormula = Lookup("HR Employees"."Posting Group" WHERE("No." = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(40; grants; Code[20])
        {
        }
        field(41; Stopped; Boolean)
        {
        }
        field(42; "Subledger Account"; Code[10])
        {
            TableRelation = IF ("Subledger Account" = CONST('VENDOR')) Vendor."No." WHERE(Blocked = FILTER(<> All),
                                                                                         "Vendor Posting Group" = CONST('OTHERS'))
            ELSE
            IF ("Subledger Account" = CONST('CUSTOMER')) Customer."No." WHERE(Blocked = FILTER(<> All));
        }
        field(43; Subledger; Option)
        {
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(44; "Sacco loan"; Boolean)
        {
        }
        field(45; "Sacco share"; Boolean)
        {
        }
        field(47; "Loan Interest Rate"; Decimal)
        {
        }
        field(48; "Exempt from Interest"; Boolean)
        {

            trigger OnValidate()
            begin
                /*
                if not "Exempt from Interest" then
                begin
                    if Confirm('Disable Staff No [ %1 ] from paying Interest on this Transaction Code [ %2 - %3? ]',false
                                  ,"Employee Code","Transaction Code","Transaction Name") = true then
                    begin
                        "Exempt from Interest":=true;
                    end else
                    begin
                        error('Aborted');
                    end;
                end else
                begin
                    if Confirm('Enalbe Staff No [ %1 ] to pay Interest on this Transaction Code [ %2 - %3? ]',false
                                  ,"Employee Code","Transaction Code","Transaction Name") = true then
                    begin
                        "Exempt from Interest":=true;
                    end else
                    begin
                        error('Aborted');
                    end;
                
                end;
                 */

            end;
        }
        field(49; Grade; Code[20])
        {
            CalcFormula = Lookup("HR Employees".Grade WHERE("No." = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(50; "Member No"; Code[20])
        {
        }
        field(51; "Loan product Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period", "Reference No")
        {
            SumIndexFields = Amount;
        }
        key(Key2; "Employee Code", "Transaction Code", "Period Month", "Period Year", Suspended)
        {
        }
    }

    fieldgroups
    {
    }

    var
        CurrPeriod: Date;
        TotalAmount: Decimal;
        Transcode: Record "PR Transaction Codes";
        EmployeeTrans: Record "PR Employee Transactions";
        MonthName: Text[100];
        //SalCard: Record "PR Salary Card";
        CurrentYr: Integer;
        objPeriod: Record "PR Payroll Periods";
        //PRAllowances: Record "PR Employee Allowances";
        HREmp: Record "HR Employees";
        //PayMethods: Record "Payment Methods";
        Members: Record Members;
        Loans: Record Loans;
        PrLoans: Record Loans;
        SavingsAccounts: Record "Savings Accounts";
        USetup: Record "User Setup";
        PREmployeeTrans: Record "PR Employee Transactions";
        ProductFactory: Record "Product Factory";
}

