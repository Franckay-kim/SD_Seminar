table 51532129 "Salutation Tittles"
{
    //DrillDownPageID = "Salutation Tittles";
    //LookupPageID = "Salutation Tittles";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = ',Tittle,Position';
            OptionMembers = ,Tittle,Position;
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

