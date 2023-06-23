/// <summary>
/// Table prPayroll Variations (ID 51533151).
/// </summary>
table 51533151 "prPayroll Variations"
{

    fields
    {
        field(1; "Employee Code"; Code[30])
        {
            TableRelation = "HR Employees"."No." WHERE(Status = FILTER(Active));

            trigger OnValidate()
            begin
                "Employee Names" := '';
                if "Employee Code" <> '' then begin
                    if SalaryCard.Get("Employee Code") = false then
                        Error('You must enter employee salary details first. Employee Code: %1', "Employee Code");

                    if HREmployee.Get("Employee Code") then begin
                        "Employee Names" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";

                    end;
                end;
            end;
        }
        field(2; "Transaction Code"; Code[30])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code";

            trigger OnValidate()
            begin
                if Transcode.Get("Transaction Code") then begin
                    if Transcode."IsActing Allowance" = true then begin
                        EmployeeTrans.Reset;
                        EmployeeTrans.SetRange(EmployeeTrans."Employee Code", "Employee Code");
                        EmployeeTrans.SetRange(EmployeeTrans."Transaction Code", "Transaction Code");
                        if EmployeeTrans.Find('-') then begin
                            repeat
                                if EmployeeTrans."Period Year" = "Period Year" then
                                    MonthName := Format(EmployeeTrans."Payroll Period", 0, '<Month Text>');
                                //ERROR(MonthName);
                                Error('Employee has already been paid leave allowance in the period of %1. - %2', EmployeeTrans."Payroll Period",
                                       "Employee Code");
                            until EmployeeTrans.Next = 0;
                        end;
                    end;
                end;
            end;
        }
        field(3; "Transaction Name"; Text[100])
        {
        }
        field(4; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if (Balance > 0) and (Amount > 0) then
                    "#of Repayments" := Balance / Amount;
            end;
        }
        field(5; Balance; Decimal)
        {

            trigger OnValidate()
            begin
                if (Balance > 0) and (Amount > 0) and ("#of Repayments" = 0) then
                    "#of Repayments" := Balance / Amount;

                if (Balance > 0) and ("#of Repayments" > 0) then
                    Amount := Balance / "#of Repayments";
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
        field(20; "Loan Number"; Code[10])
        {
        }
        field(21; "Payroll Code"; Code[20])
        {
            //TableRelation = "prPayroll Type";
        }
        field(22; "No of Units"; Decimal)
        {

            trigger OnValidate()
            begin
                /*IF Transcode.GET("Transaction Code") THEN BEGIN
                IF Transcode."Transaction Category" = Transcode."Transaction Category"::Overtime THEN BEGIN
                Amount:=0;
                Transcode.TESTFIELD(Transcode.Suspended);
                IF SalCard.GET("Employee Code") THEN BEGIN
                IF SalaryNotches.GET(SalCard."Date of Birth",SalCard."Scheme Code 2") THEN BEGIN
                IF Transcode.Suspended = Transcode.Suspended::yes THEN
                Amount:=SalaryNotches."Hourly Rate"*2*"No of Units"
                ELSE IF Transcode.Suspended = Transcode.Suspended::"3" THEN
                Amount:=SalaryNotches."Hourly Rate"*3*"No of Units"
                ELSE
                Amount:=SalaryNotches."Hourly Rate"*1.5*"No of Units";
                END;
                END;
                END;
                END;
                */

            end;
        }
        field(23; Suspended; Boolean)
        {
        }
        field(24; "Employee Names"; Text[200])
        {
        }
        field(25; "Transaction Type"; Option)
        {
            Description = 'Income,Deduction';
            OptionMembers = Income,Deduction;
        }
        field(26; Frequency; Option)
        {
            Description = 'Fixed,Varied';
            OptionMembers = "Fixed",Varied;
        }
        field(27; Processed; Boolean)
        {
        }
        field(28; Currency; Code[10])
        {
            TableRelation = Currency;
        }
        field(29; "Basic Pay"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Employee Code", "Transaction Code", "Reference No", "Period Month", "Period Year", "Payroll Period", Currency)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    var
        Transcode: Record "PR Transaction Codes";
        EmployeeTrans: Record "PR Employee Transactions";
        MonthName: Text[100];
        HREmployee: Record "HR Employees";
        SalaryCard: Record "PR Salary Card";
        SalCard: Record "PR Salary Card";
    //SalaryNotches: Record "Salary Notch";
}

