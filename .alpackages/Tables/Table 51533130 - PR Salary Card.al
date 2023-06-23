/// <summary>
/// Table PR Salary Card (ID 51533130).
/// </summary>
table 51533130 "PR Salary Card"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(2; "Basic Pay"; Decimal)
        {

            trigger OnValidate()
            var
                Text0000: Label 'Do you want to change the Basic Pay for this Employee %1 and Update his/her Employee Card?';
                HREmp: Record "HR Employees";
                Text0001: Label 'Aborted. Press F5 to discard the changes';
                Text0002: Label 'Employee %1 does not exist in HR Employees list. Please liase with HR Officer to Create this Employee';
            begin
                "1/3 Basic" := 1 / 3 * "Basic Pay";
                /*
    //*************************DW******************************************
    // TO ENSURE PR SALARY CARD BASIC PAY AND HR EMPLOYEES BASIC
    // PAY ARE SAME WHEN CHANGED
       IF HREmp.GET("Employee Code") THEN
       BEGIN
          HREmp."New Basic Pay":="Rate Per Day";
          HREmp."Basic Pay":="Basic Pay";
          HREmp.MODIFY;
       END ELSE
       BEGIN
          ERROR(Text0002,"Employee Code");
       END;

    // For NIB MWEA :: Function to check if Employee is Paid Daily
    // and place a check mark on the field is "Is Paid Daily" on this table
                //  fnIsEmployeePaidDaily;
    //*********************************************************************
                 */

            end;
        }
        field(3; "Payment Mode"; Option)
        {
            Description = 'Bank Transfer,Cheque,Cash,FOSA';
            OptionMembers = "Bank Transfer",Cheque,Cash,FOSA;
        }
        field(4; Currency; Code[10])
        {
        }
        field(5; "Pays NSSF"; Boolean)
        {
        }
        field(6; "Pays NHIF"; Boolean)
        {
        }
        field(7; "Pays PAYE"; Boolean)
        {
        }
        field(8; "Payslip Message"; Text[100])
        {
        }
        field(9; "Cumm BasicPay"; Decimal)
        {
            CalcFormula = Sum("PR Employee P9 Info"."Basic Pay" WHERE("Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Cumm GrossPay"; Decimal)
        {
            CalcFormula = Sum("PR Employee P9 Info"."Gross Pay" WHERE("Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Cumm NetPay"; Decimal)
        {
            CalcFormula = Sum("PR Employee P9 Info"."Net Pay" WHERE("Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Cumm Allowances"; Decimal)
        {
            CalcFormula = Sum("PR Employee P9 Info"."Basic Pay" WHERE("Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Cumm Deductions"; Decimal)
        {
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Group Order" = FILTER(8),
                                                                     "Sub Group Order" = FILTER(0 | 1),
                                                                     "Employee Code" = FIELD("Employee Code"),
                                                                     "Transaction Code" = FILTER(<> 'Total Deductions')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Suspend Pay"; Boolean)
        {
        }
        field(15; "Suspension Date"; Date)
        {
        }
        field(16; "Suspension Reasons"; Text[200])
        {
        }
        field(17; "Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(18; Exists; Boolean)
        {
        }
        field(19; "Cumm PAYE"; Decimal)
        {
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Transaction Code" = FILTER('PAYE'),
                                                                     "Employee Code" = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(20; "Cumm NSSF"; Decimal)
        {
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Transaction Code" = FILTER('NSSF'),
                                                                     "Employee Code" = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(21; "Cumm Pension"; Decimal)
        {
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Transaction Code" = FILTER('455'),
                                                                     "Employee Code" = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(22; "Cumm HELB"; Decimal)
        {
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Employee Code" = FIELD("Employee Code"),
                                                                     "Transaction Code" = FILTER('320')));
            FieldClass = FlowField;
        }
        field(23; "Cumm NHIF"; Decimal)
        {
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Employee Code" = FIELD("Employee Code"),
                                                                     "Transaction Code" = FILTER('NHIF')));
            FieldClass = FlowField;
        }
        field(24; "Bank Account Number"; Code[50])
        {
        }
        field(25; "Bank Branch"; Code[50])
        {
        }
        field(26; "Employee's Bank"; Code[50])
        {
        }
        field(27; "Posting Group"; Code[20])
        {
            NotBlank = false;
            TableRelation = "prEmployee Posting Group".Code;
        }
        field(28; "No. Overtime Day(s) Worked"; Decimal)
        {
        }
        field(29; "Identification Number"; Code[20])
        {
        }
        field(30; "Mobile Number"; Code[20])
        {
        }
        field(31; Nationality; Code[20])
        {
        }
        field(32; "Date of Birth"; Date)
        {
        }
        field(33; "Scheme Code 2"; Code[20])
        {
        }
        field(34; "Job Title"; Code[20])
        {
        }
        field(35; "Job Description"; Text[100])
        {
        }
        field(36; Address; Text[100])
        {
        }
        field(37; "Employment Date"; Date)
        {
        }
        field(38; Status; Text[20])
        {
        }
        field(39; "PIN No."; Code[20])
        {
        }
        field(40; "Bank Account No."; Text[100])
        {
        }
        field(41; "Contract End Date"; Date)
        {
        }
        field(42; "Job Group"; Text[100])
        {
        }
        field(43; "Company E-Mail"; Text[100])
        {
        }
        field(44; "Days Worked"; Decimal)
        {
        }
        field(60000; "Grade Level"; Code[20])
        {
        }
        field(60001; "Gratuity %"; Code[10])
        {
        }
        field(60002; "Gratuity Amount"; Decimal)
        {
        }
        field(60003; Gratuity; Integer)
        {
        }
        field(60004; "No.Of Days PDM"; Integer)
        {
        }
        field(60005; "Rate Per Day"; Decimal)
        {
        }
        field(60006; "Scheme Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('SCHEME'));
        }
        field(60007; "Employee Contract Type"; Code[10])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER("Contract Type"));
        }
        field(60008; "No. of Days Worked"; Decimal)
        {
        }
        field(60009; "Is Paid Daily?"; Boolean)
        {
            Description = 'FOR MWEA';
        }
        field(60010; "No. of Sundays / Holidays Work"; Decimal)
        {
            Description = 'FOR MWEA';
        }
        field(60011; "Assign Resp Allowance"; Boolean)
        {
            Description = 'FOR MWEA';
        }
        field(60012; "Not Based on Rates"; Boolean)
        {
            Description = 'FOR MWEA';
        }
        field(60013; "Insurance Certificate?"; Boolean)
        {
        }
        field(60014; "PAYE Relief?"; Boolean)
        {
        }
        field(60015; Gender; Option)
        {
            CalcFormula = Lookup("HR Employees".Gender WHERE("No." = FIELD("Employee Code")));
            FieldClass = FlowField;
            OptionCaption = 'Female,Male';
            OptionMembers = Female,Male;
        }
        field(60016; "Is Security?"; Boolean)
        {
            Description = 'FOR MIAD';
        }
        field(60017; "Emp Name"; Text[100])
        {
            CalcFormula = Lookup("HR Employees"."Full Name" WHERE("No." = FIELD("Employee Code")));
            FieldClass = FlowField;
        }
        field(60018; "Disable Personal Relief?"; Boolean)
        {
        }
        field(60019; "1/3 Basic"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "1/3 Basic" := 1 / 3 * "Basic Pay";
            end;
        }
    }

    keys
    {
        key(Key1; "Employee Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HREmp: Record "HR Employees";

    /// <summary>
    /// fnIsEmployeePaidDaily.
    /// </summary>
    procedure fnIsEmployeePaidDaily()
    var
        PaidDaily: Boolean;
    begin
        PaidDaily := false;
        if ("Basic Pay" <= 0) and ("Rate Per Day" <= 0) then begin
            PaidDaily := false;

        end;

        if ("Basic Pay" <= 0) and ("Rate Per Day" > 0) then begin
            PaidDaily := true;
        end;
        if ("Basic Pay" > 0) and ("Rate Per Day" <= 0) then begin
            PaidDaily := false;
        end;
        if ("Basic Pay" > 0) and ("Rate Per Day" > 0) then begin
            Error('Both "Rate per Day" and "Basic Pay" CANNOT be filled');
        end;


        if PaidDaily = true then begin
            "Is Paid Daily?" := true;
            Modify;
        end else begin
            PaidDaily := false;
            if PaidDaily = false then begin
                "Is Paid Daily?" := false;
                Modify;
            end;
        end;
    end;
}

