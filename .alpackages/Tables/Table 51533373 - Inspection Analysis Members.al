table 51533373 "Inspection Analysis Members"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Staff Code"; Code[20])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate();
            begin
                IF Emp.GET("Staff Code") THEN
                    "User Id" := Emp."User ID";
                "User Name" := Emp."Full Name";
            end;
        }
        field(3; "User Id"; Code[50])
        {
        }
        field(4; "User Name"; Text[100])
        {
        }
        field(5; Approve; Boolean)
        {

            trigger OnValidate();
            begin
                IF "User Id" <> USERID THEN ERROR('Only users assigned to an inspection can approve');
            end;
        }
        field(6; Comment; Text[250])
        {
        }
        field(7; "Line No"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Line No")
        {
        }
        key(Key2; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Emp: Record "HR Employees";
}

