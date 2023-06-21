table 51533117 "PR Period Transactions"
{
    // DrillDownPageID = "prPeriodTransaction List";
    //LookupPageID = "prPeriodTransaction List";

    fields
    {
        field(1; "Employee Code"; Code[50])
        {
            Description = '"HR Employees".No.';
            TableRelation = "HR Employees"."No.";
        }
        field(2; "Transaction Code"; Text[30])
        {
            Description = '"PR Transaction Codes"."Transaction Code"';
            TableRelation = "PR Transaction Codes"."Transaction Code";
        }
        field(3; "Group Text"; Text[30])
        {
            Description = 'e.g Statutory, Deductions, Tax Calculation etc';
        }
        field(4; "Transaction Name"; Text[200])
        {
        }
        field(5; Amount; Decimal)
        {
        }
        field(6; Balance; Decimal)
        {
        }
        field(7; "Original Amount"; Decimal)
        {
        }
        field(8; "Group Order"; Integer)
        {
        }
        field(9; "Sub Group Order"; Integer)
        {
        }
        field(10; "Period Month"; Integer)
        {
        }
        field(11; "Period Year"; Integer)
        {
        }
        field(12; "Period Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(13; "Payroll Period"; Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(14; Membership; Code[50])
        {
            //TableRelation = "prInstitutional Membership"."Institution No";
        }
        field(15; "Reference No"; Text[20])
        {
        }
        field(16; "Department Code"; Code[20])
        {
        }
        field(17; Lumpsumitems; Boolean)
        {
        }
        field(18; TravelAllowance; Code[20])
        {
        }
        field(19; "GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(20; "Company Deduction"; Boolean)
        {
            Description = 'Dennis- Added to filter out the company deductions esp: the Pensions';
        }
        field(21; "Emp Amount"; Decimal)
        {
            Description = 'Dennis- Added to take care of the balances that need a combiantion btwn employee and employer';
        }
        field(22; "Emp Balance"; Decimal)
        {
            Description = 'Dennis- Added to take care of the balances that need a combiantion btwn employee and employer';
        }
        field(23; "Journal Account Code"; Code[20])
        {
        }
        field(24; "Journal Account Type"; Option)
        {
            OptionCaption = ' ,G/L Account,Customer,Vendor,Credit,Savings';
            OptionMembers = " ","G/L Account",Customer,Vendor,Credit,Savings;
        }
        field(25; "Post As"; Option)
        {
            OptionMembers = " ",Debit,Credit;
        }
        field(26; "Loan Number"; Code[20])
        {
        }
        field(27; "coop parameters"; Option)
        {
            Description = 'to be able to report the different coop contributions -Dennis';
            OptionMembers = "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,NSSF,Overtime,NHIF;
        }
        field(28; "Payroll Code"; Code[20])
        {
            // TableRelation = "prPayroll Type";
        }
        field(29; "Payment Mode"; Option)
        {
            Description = 'Bank Transfer,Cheque,Cash,SACCO';
            OptionMembers = " ","Bank Transfer",Cheque,Cash,SACCO;
        }
        field(30; "Location/Division"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(31; Department; Code[20])
        {

        }
        field(32; "Cost Centre"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('COSTCENTRE'));
        }
        field(33; "Salary Grade"; Code[20])
        {
            // TableRelation = "prInstitutional Membership"."Group No";
        }
        field(34; "Salary Notch"; Code[20])
        {
        }
        field(35; "Payslip Order"; Integer)
        {
        }
        field(36; "No. Of Units"; Decimal)
        {
        }
        field(37; "Employee Classification"; Code[20])
        {
        }
        field(38; State; Code[20])
        {
            TableRelation = "Post Code";
        }
        field(39; "New Departmental Code"; Code[20])
        {
        }
        field(40; grants; Code[20])
        {
            // TableRelation = "HR Employee Qualifications"."Employee No.";
        }
        field(41; "Bank Code"; Code[10])
        {
        }
        field(42; "Branch Code"; Code[10])
        {
        }
        field(43; "A/C Number"; Code[20])
        {
        }
        field(44; "Bank Details"; Text[100])
        {
        }
        field(45; "Branch Details"; Text[100])
        {
        }
        field(50000; "Sacco Loan Transaction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal Due,Loan Registration Fee,Appraisal Paid,Pre-Earned Interest,Penalty Due,Penalty Paid';
            OptionMembers = " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Loan Registration Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid";

            trigger OnValidate()
            begin


            end;
        }
        field(39003900; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(39003901; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(39003902; "Contract Type"; Code[20])
        {
        }
        field(39003903; "Transaction Type"; Option)
        {
            OptionCaption = 'Income,Deduction, ';
            OptionMembers = Income,Deduction," ";
        }
        field(39003904; "Period Closed"; Boolean)
        {
            CalcFormula = Lookup("PR Payroll Periods".Closed WHERE("Date Opened" = FIELD("Payroll Period")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Transaction Code", "Period Month", "Period Year", Membership, "Reference No", "Sacco Loan Transaction")
        {
            SumIndexFields = Amount, "No. Of Units";
        }
        key(Key2; "Employee Code", "Period Month", "Period Year", "Group Order", "Sub Group Order", "Payslip Order", Membership, "Reference No")
        {
            SumIndexFields = Amount, "No. Of Units";
        }
        key(Key3; "Group Order", "Transaction Code", "Period Month", "Period Year", Membership, "Reference No", "Department Code")
        {
            SumIndexFields = Amount, "No. Of Units";
        }
        key(Key4; Membership)
        {
        }
        key(Key5; "Transaction Code", "Payroll Period", Membership, "Reference No")
        {
            SumIndexFields = Amount, "No. Of Units";
        }
        key(Key6; "Payroll Period", "Group Order", "Sub Group Order")
        {
            SumIndexFields = Amount, "No. Of Units";
        }
        key(Key7; "Employee Code", "Department Code")
        {
            SumIndexFields = Amount, "No. Of Units";
        }
        key(Key8; "Transaction Code", "Employee Code", "Payroll Period", "Location/Division", Department)
        {
            SumIndexFields = Amount, "No. Of Units";
        }
        key(Key9; "Payslip Order")
        {
        }
        key(Key10; "Transaction Code", "Employee Code", "Payroll Period", "Reference No")
        {
        }
        key(Key11; Department)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PRPayrollPeriods.Reset;
        if PRPayrollPeriods.Get("Payroll Period") then begin
            if PRPayrollPeriods.Closed = true then begin
                Error(Text001, 'DELETE', "Payroll Period");
            end;
        end;
    end;

    trigger OnInsert()
    begin
        PRPayrollPeriods.Reset;
        if PRPayrollPeriods.Get("Payroll Period") then begin
            if PRPayrollPeriods.Closed = true then begin
                Error(Text001, 'INSERT', "Payroll Period");
            end;
        end;
    end;

    trigger OnModify()
    begin
        PRPayrollPeriods.Reset;
        if PRPayrollPeriods.Get("Payroll Period") then begin
            if PRPayrollPeriods.Closed = true then begin
                Error(Text001, 'MODIFY', "Payroll Period");
            end;
        end;
    end;

    trigger OnRename()
    begin
        /*PRPayrollPeriods.RESET;
        IF PRPayrollPeriods.GET("Payroll Period") THEN
        BEGIN
            IF PRPayrollPeriods.Closed = TRUE THEN
            BEGIN
                ERROR(Text001,'RENAME',"Payroll Period");
            END;
        END;
        */

    end;

    var
        PRPayrollPeriods: Record "PR Payroll Periods";
        Text001: Label 'You cannot [ %1  ] records in this Payroll Period [ %2  ] because it is CLOSED';
}

