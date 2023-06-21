table 51533119 "prEmployer Deductions"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
        }
        field(2; "Transaction Code"; Code[20])
        {
        }
        field(3; Amount; Decimal)
        {
        }
        field(4; "Period Month"; Integer)
        {
        }
        field(5; "Period Year"; Integer)
        {
        }
        field(6; "Payroll Period"; Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(7; "Payroll Code"; Code[20])
        {

        }
    }

    keys
    {
        key(Key1; "Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }
}

