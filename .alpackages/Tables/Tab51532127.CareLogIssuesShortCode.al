table 51532127 "Care Log Issues Short Code"
{
    Caption = 'Care Log Issues Short Code';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; Reference; Code[10])
        {
            Caption = 'Reference';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[150])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Reference)
        {
            Clustered = true;
        }
    }
}
