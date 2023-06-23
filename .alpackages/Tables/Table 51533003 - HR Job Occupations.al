/// <summary>
/// Table HR Job Occupations (ID 51533003).
/// </summary>
table 51533003 "HR Job Occupations"
{

    fields
    {
        field(2; "Employee No."; Code[20])
        {
            // TableRelation = "HR Succession Job Rotation"."Line No.";

            trigger OnValidate()
            begin

            end;
        }
        field(3; "First Name"; Text[30])
        {

        }
        field(4; "Middle Name"; Text[30])
        {

        }
        field(5; "Last Name"; Text[30])
        {

        }
        field(6; Extension; Text[30])
        {
            FieldClass = Normal;
        }
        field(7; Email; Text[30])
        {
            FieldClass = Normal;
        }
        field(8; "Date of Join"; Date)
        {
            FieldClass = Normal;
        }
        field(9; Department; Code[20])
        {
            FieldClass = Normal;
        }
        field(55; "Job Desc"; Text[50])
        {

        }
        field(56; "Job Id"; Code[100])
        {
            TableRelation = "Vendor Invoice Disc."."Service Charge";
        }
    }

    keys
    {
        key(Key1; "Job Id", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        //HREmp: Record "HR Succession Job Rotation";
        HRJobs: Record "HR Jobs";
}

