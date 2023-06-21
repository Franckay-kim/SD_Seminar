table 51533401 "Field Officer Activities"
{
    Caption = 'Field Officer Activities';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = ToBeClassified;
        }
        field(3; Location; Text[100])
        {
            Caption = 'Location';
            DataClassification = ToBeClassified;
        }
        field(4; "Activity Date"; Date)
        {
            Caption = 'Activity Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Nature of Visit"; Option)
        {
            Caption = 'Nature of Visit';
            DataClassification = ToBeClassified;
            OptionMembers = Recruitment,Education,FollowUp,Loan,Rejoining,"Category B";
        }
        field(6; "Officer Name"; Text[100])
        {
            Caption = 'Officer Name';
            DataClassification = ToBeClassified;
        }
        field(7; Diocese; code[20])
        {
            TableRelation = Diocese;
        }
        field(8; "Member No"; code[20])
        {
            TableRelation = Members;
        }
        field(9; "Loans Sold"; Integer)
        {

        }
        field(10; "Members Recruited"; Integer)
        {

        }
    }
    keys
    {
        key(PK; "No.", "Entry No")
        {
            Clustered = true;
        }
    }
}
