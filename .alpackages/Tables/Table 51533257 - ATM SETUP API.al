table 51533257 "ATM SETUP API"
{

    fields
    {
        field(1;ID;Integer)
        {
        }
        field(2;"ATM Bank";Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(3;"Sacco Charge A/C";Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4;"Bank Charge A/C";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(5;"CoreTec Charge A/C";Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
    }

    keys
    {
        key(Key1;ID)
        {
        }
    }

    fieldgroups
    {
    }
}

