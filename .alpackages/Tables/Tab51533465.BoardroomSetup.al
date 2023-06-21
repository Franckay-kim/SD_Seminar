table 51533465 "Boardroom Setup"
{
    Caption = 'Boardroom Setup';

    fields
    {
        field(1; "Booking Nos."; Code[10])
        {
            Caption = 'Booking No.';
            TableRelation = "No. Series";
        }
        field(2; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
