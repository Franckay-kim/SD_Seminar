/// <summary>
/// Table HR Training App Lines (ID 51533076).
/// </summary>
table 51533076 "HR Training App Lines"
{


    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Application No."; Code[20])
        {
        }
        field(3; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                HREmployees.Reset;
                if HREmployees.Get("Employee No.") then begin
                    Name := HREmployees."First Name" + ' ' + HREmployees."Middle Name" + ' ' + HREmployees."Last Name";
                    "Job ID" := HREmployees.Position;
                    "Job Title" := HREmployees."Job Title";
                    "Participant Email" := HREmployees."Company E-Mail";

                end else begin
                    Name := '';
                    "Job ID" := '';
                    "Job Title" := '';
                end;
            end;
        }
        field(4; Name; Text[50])
        {
        }
        field(5; Objectives; Text[250])
        {
        }
        field(6; "Job ID"; Code[10])
        {
        }
        field(7; "Job Title"; Text[50])
        {
        }
        field(8; Notified; Boolean)
        {
        }
        field(9; Suggested; Boolean)
        {
            Editable = false;
        }
        field(10; "Participant Email"; Text[100])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Application No.", "Employee No.")
        {
        }

    }

    fieldgroups
    {
    }

    var
        HREmployees: Record "HR Employees";
}

