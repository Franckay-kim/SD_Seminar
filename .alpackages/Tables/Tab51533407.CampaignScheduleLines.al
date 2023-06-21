table 51533407 "Campaign Schedule Lines"
{
    Caption = 'Campaign Schedule Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Header No."; Code[20])
        {
            Caption = 'Header No.';
            DataClassification = ToBeClassified;
        }
        field(3; Location; Code[20])
        {
            Caption = 'Location';
            DataClassification = ToBeClassified;
        }
        field(4; "Visit Date"; Date)
        {
            Caption = 'Visit Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Nature Of Visit"; Option)
        {
            Caption = 'Nature Of Visit';
            DataClassification = ToBeClassified;
            OptionMembers = Recruitment,Education,FollowUp,Loan;
        }
        field(6; Remarks; Text[100])
        {
            Caption = 'Remarks';
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
