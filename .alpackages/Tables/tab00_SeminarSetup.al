table 50100 "CSD Seminar Setup"
//CSD1.00 - 2023-30-05 - D. E. Veloper
//Seminar setup table
//new table
{
    Caption = 'Seminar Setup';

    fields
    {
        field(10; "primary key"; Code[20])
        {
            Caption = 'primary key';
        }
        field(20; "Seminar Nos"; Code[20])
        {
            Caption = 'Seminar Nos';
            TableRelation = "No. Series";
        }
        field(30; "Seminar Registration Nos"; Code[20])
        {
            caption = 'Seminar Registration Nos';
            TableRelation = "No. Series";
        }
        field(40; "Posted Seminar Reg. Nos"; Code[20])
        {
            Caption = 'Posted Seminar Reg. Nos';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "primary key")
        {
            Clustered = true;
        }
    }

}