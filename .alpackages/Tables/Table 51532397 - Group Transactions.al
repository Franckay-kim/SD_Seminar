table 51532397 "Group Transactions"
{
    // DrillDownPageID = 39004340;
    // LookupPageID = 52018842;

    fields
    {
        field(1; "Transactions number"; Code[30])
        {
        }
        field(2; "Loan Type"; Code[60])
        {
        }
        field(3; "Loan Number"; Code[50])
        {
            Editable = false;
            TableRelation = Loans;
        }
        field(4; "Interest Amount"; Decimal)
        {
        }
        field(5; Principal; Decimal)
        {
        }
        field(6; "Penalty Amount"; Decimal)
        {
        }
        field(7; "Member Number"; Code[60])
        {
        }
    }

    keys
    {
        key(Key1; "Transactions number", "Loan Number")
        {
        }
    }

    fieldgroups
    {
    }
}

