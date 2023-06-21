table 51532118 "Cheque Set Up"
{
    // DrillDownPageID = "Cheque Set Up";
    // LookupPageID = "Cheque Set Up";

    fields
    {
        field(1; "Cheque Code"; Code[30])
        {
        }
        field(2; "Number Of Leaf"; Integer)
        {
        }
        field(3; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Cheque Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cheque Code", "Number Of Leaf", Amount)
        {
        }
    }
}

