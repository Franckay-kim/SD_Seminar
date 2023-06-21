table 51532198 "Archdiocese Setup"
{
    Caption = 'Archdiocese Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        // field(3; Type; Option)
        // {
        //     OptionCaption = ' ,Archdiocese,Diocese,Town County';
        //     OptionMembers = " ",Archdiocese,Diocese,Town,County;
        // }
        field(5; Archdiocese; Code[50])
        {
            Caption = 'Archdiocese';
            DataClassification = ToBeClassified;
        }
        field(6; Diocese; Code[50])
        {
            Caption = 'Diocese';
            TableRelation = Diocese;
            DataClassification = ToBeClassified;
        }
        field(7; Town; Code[50])
        {
            Caption = 'Town';
            DataClassification = ToBeClassified;
        }
        field(8; County; Code[30])
        {
            Caption = 'County';
            TableRelation = "Segment/County/Dividend/Signat".Code where(Type = const(County));
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
