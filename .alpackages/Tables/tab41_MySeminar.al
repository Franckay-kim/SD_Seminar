table 50141 "CSD My Seminar"
// CSD1.00 - 2023-06-14 - D. E. Veloper
// Chapter 10 - Lab 1 - 3
// - Created new page
{
    DataClassification = ToBeClassified;
    Caption = 'My Seminar';

    fields
    {
        field(10; "User Id"; Code[50])
        {
            Caption = 'User Id';
            TableRelation = User;
            DataClassification = ToBeClassified;
        }
        field(20; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "User Id", "Seminar No.")
        {
            Clustered = true;
        }
    }

}