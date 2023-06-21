table 51532126 "Tiered Charges Header"
{
    // DrillDownPageID = "Tiered Charges List";
    // LookupPageID = "Tiered Charges List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = 'Charge,Share Transfer,Income Deposits';
            OptionMembers = Charge,"Share Transfer","Income Deposits";
        }
        field(4; Product; Code[20])
        {
            TableRelation = "Product Factory";
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

