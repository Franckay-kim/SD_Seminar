/// <summary>
/// Table Rejection Reason (ID 51532360).
/// </summary>
table 51532360 "Rejection Reason"
{

    fields
    {
        field(1; "Code"; Code[50])
        {
        }
        field(2; "Rejection Reason"; Text[250])
        {
        }
        field(3; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(4; "Created By"; Code[50])
        {
            Editable = false;
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
        fieldgroup(a; "Code", "Rejection Reason")
        {
        }
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Creation Date" := Today;
    end;
}

