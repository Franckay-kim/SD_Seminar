table 51533253 "File Stages"
{
    //DrillDownPageID = "File Stages";
    //LookupPageID = "File Stages";

    fields
    {
        field(1; Stage; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Station; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Duration (Days)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Stage)
        {
        }
    }

    fieldgroups
    {
    }
}

