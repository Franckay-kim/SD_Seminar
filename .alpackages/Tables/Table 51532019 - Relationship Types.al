/// <summary>
/// Table Relationship Types (ID 51532019).
/// </summary>
table 51532019 "Relationship Types"
{
    // LookupPageID = "Relationship Types";

    fields
    {
        field(1; Description; Text[30])
        {

            trigger OnValidate()
            begin
                if Description <> '' then
                    Description := UpperCase(Description);
            end;
        }
    }


    keys
    {
        key(Key1; Description)
        {
        }
    }

    fieldgroups
    {
    }
}

