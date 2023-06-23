/// <summary>
/// Table HR Shortlisting Panel (ID 51533189).
/// </summary>
table 51533189 "HR Shortlisting Panel"
{

    fields
    {
        field(1; "Requisition No."; Code[20])
        {
            TableRelation = "HR Employee Requisitions"."Requisition No.";
        }
        field(2; "Line  No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Employee No."; Code[10])
        {
            TableRelation = "HR Employees";

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Employee No.");
                if HREmp.Find('-') then begin
                    "Employee Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Job Id" := HREmp."Job Title";
                    Department := HREmp."Department Code";
                    Region := HREmp.Region;
                end;
            end;
        }
        field(4; "Employee Name"; Text[150])
        {
        }
        field(5; "Job Id"; Code[50])
        {
        }
        field(6; Department; Code[10])
        {
        }
        field(7; Region; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Requisition No.", "Line  No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HREmp: Record "HR Employees";
}

