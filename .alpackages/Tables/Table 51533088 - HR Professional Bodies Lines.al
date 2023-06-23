/// <summary>
/// Table HR Professional Bodies Lines (ID 51533088).
/// </summary>
table 51533088 "HR Professional Bodies Lines"
{

    fields
    {
        field(1; "No."; Code[10])
        {
            TableRelation = "HR Professional body Header"."No.";
        }
        field(2; "Qualification Type"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER(Grade));
        }
        field(3; "Qualification Code"; Code[20])
        {
            TableRelation = "HR Job Qualifications".Code WHERE("Qualification Type" = FIELD("Qualification Type"));

            trigger OnValidate()
            begin
                if HRQualifications.Get("Qualification Type", "Qualification Code") then
                    "Qualification Description" := HRQualifications.Description;
            end;
        }
        field(4; "Qualification Description"; Text[100])
        {
        }
        field(5; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Line No", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRQualifications: Record "HR Job Qualifications";
}

