table 51533260 "SASRA Main Sector."
{

    fields
    {
        field(1; "Main Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Date filter"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Main Code")
        {
        }
    }

    fieldgroups
    {
    }
}

