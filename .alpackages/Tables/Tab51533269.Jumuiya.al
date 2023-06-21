table 51533269 Jumuiya
{
    Caption = 'Jumuiya';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Jumuiya Name"; Text[100])
        {
            Caption = 'Jumuiya Name';
            DataClassification = ToBeClassified;
        }
        field(3; Diocese; code[30])
        {
            TableRelation = Diocese.Code;
            DataClassification = ToBeClassified;
        }
        field(4; Parish; code[30])
        {
            TableRelation = Parish.Code where("Diocese Code" = field(Diocese));
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
