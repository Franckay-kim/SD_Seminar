table 51532007 "Options List"
{
    Caption = 'Options List';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Option Value"; Text[150])
        {
            Caption = 'Option Value';
            DataClassification = ToBeClassified;
        }
        field(3; "Option Description"; Text[150])
        {
            Caption = 'Option Description';
            DataClassification = ToBeClassified;
        }
        field(4; "Option Type"; Text[150])
        {
            Caption = 'Option Type';
            DataClassification = ToBeClassified;
        }
        field(6; "Option Order"; Integer)
        {
            Caption = 'Option Order';
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
