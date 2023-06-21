table 51532365 "Loan Recovery Modes"
{
    //DrillDownPageID = "Loan Recovery Modes";
    //LookupPageID = "Loan Recovery Modes";

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
        field(4; "Product ID"; Code[20])
        {
            TableRelation = "Product Factory";
        }
        field(5; "Loan No."; Code[30])
        {
        }
        field(6; "Percentage for Loans"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Product ID", "Loan No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
    // CreditProductCategories: Record "Credit Product Categories";
}

