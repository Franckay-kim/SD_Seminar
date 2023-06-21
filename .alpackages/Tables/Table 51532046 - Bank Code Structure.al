table 51532046 "Bank Code Structure"
{
    //DrillDownPageID = "Bank Code Structure";
    //LookupPageID = "Bank Code Structure";

    fields
    {
        field(1; "Bank Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Bank Name"; Text[150])
        {
        }
        field(3; "Branch Code"; Code[10])
        {
        }
        field(4; Branch; Text[150])
        {
        }
    }

    keys
    {
        key(Key1; "Bank Code", "Branch Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Bank Code", "Bank Name", "Branch Code", Branch)
        {
        }
    }
}

