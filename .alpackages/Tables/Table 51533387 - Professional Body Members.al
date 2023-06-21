table 51533387 "Professional Body Members"
{

    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Member No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Member Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Job Title"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Department Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Mandatory; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Development hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

