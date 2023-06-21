table 51533267 Diocese
{
    Caption = 'Diocese';
    // DrillDownPageId = Diocese;
    //LookupPageId = Diocese;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Diocese Name"; Text[100])
        {
            Caption = 'Diocese Name';
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
