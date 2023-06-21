table 51533268 Parish
{
    Caption = 'Parish';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Parish Name"; Text[100])
        {
            Caption = 'Parish Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Diocese Code"; Code[30])
        {
            Caption = 'Diocese Code';
            TableRelation = Diocese.Code;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
