table 51532199 "Travel Destination"
{
    //DrillDownPageID = "Destination Code List";
    //LookupPageID = "Destination Code List";

    fields
    {
        field(1; "Destination Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Destination Name"; Text[50])
        {
        }
        field(3; "Destination Type"; Option)
        {
            OptionMembers = "Local",Foreign;
        }
        field(4; Currency; Code[10])
        {
            CalcFormula = Lookup("Destination Rate Entry".Currency WHERE("Destination Code" = FIELD("Destination Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Destination Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Options; "Destination Code", "Destination Name", "Destination Type")
        {
        }
    }
}

