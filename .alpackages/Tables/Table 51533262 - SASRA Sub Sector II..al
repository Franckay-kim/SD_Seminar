table 51533262 "SASRA Sub Sector II."
{

    fields
    {
        field(1; "Main Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Sub Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Pre Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Main Code", "Sub Code", "Pre Code")
        {
        }
    }

    fieldgroups
    {
    }
}

