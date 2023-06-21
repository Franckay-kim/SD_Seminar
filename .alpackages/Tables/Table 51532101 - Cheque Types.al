table 51532101 "Cheque Types"
{
    // DrillDownPageID = "Cheque Types";
    // LookupPageID = "Cheque Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Clearing Days"; DateFormula)
        {
        }
        field(4; "Clearing Charge Code"; Code[20])
        {
            TableRelation = "Tiered Charges Header";
        }
        field(5; Type; Option)
        {
            OptionCaption = 'Local,Inhouse,Upcountry';
            OptionMembers = "Local",Inhouse,Upcountry;
        }
        field(6; "Clearing Charges GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Clearing  Days"; Integer)
        {
        }
        field(8; "Cheque Limit"; Decimal)
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

