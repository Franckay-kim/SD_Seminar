table 51533176 "HR Employment History"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = false;
            TableRelation = "HR Employees"."No.";
        }
        field(2; From; Code[20])
        {
            NotBlank = false;
        }
        field(3; "To Date"; Code[20])
        {
            NotBlank = false;
        }
        field(4; "Company Name"; Text[150])
        {
            NotBlank = false;
        }
        field(5; "Postal Address"; Text[40])
        {
        }
        field(6; "Address 2"; Text[40])
        {
        }
        field(7; "Job Title"; Text[150])
        {
        }
        field(8; "Key Experience"; Text[150])
        {
        }
        field(9; "Salary On Leaving"; Decimal)
        {
        }
        field(10; "Reason For Leaving"; Text[150])
        {
        }
        field(16; Comment; Text[200])
        {
            Editable = true;
            FieldClass = Normal;
        }
        field(17; "Online Application No"; Code[30])
        {

        }
        field(18; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record "HR Employees";
        OK: Boolean;
}

