table 51532363 "Credit Product Categories"
{
    // DrillDownPageID = "Credit Product Categories";
    //LookupPageID = "Credit Product Categories";

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Maximum Concurrent Loans"; Integer)
        {
        }
        field(4; "Percentage for Loans"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Annual Payment"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

