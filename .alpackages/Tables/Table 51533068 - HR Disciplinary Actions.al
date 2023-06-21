table 51533068 "HR Disciplinary Actions"
{
    // DrillDownPageID = "HR Disciplinary Actions";
    // LookupPageID = "HR Disciplinary Actions";

    fields
    {
        field(1; "Action Code"; Code[20])
        {
        }
        field(2; Instance; Integer)
        {
        }
        field(3; "Recommended Action"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Action Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Action Code", Instance, "Recommended Action")
        {
        }
    }
}

