table 51532337 "Agent Transactions Charged"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            Editable = false;
            InitValue = 0;
        }
        field(2;"Document No";Code[30])
        {
            Editable = false;
        }
        field(3;"Total Commission";Decimal)
        {
            Editable = false;
        }
        field(4;"Sacco Commission";Decimal)
        {
            Editable = false;
        }
        field(5;"Agent Comission";Decimal)
        {
            Editable = false;
        }
        field(6;"Vendor Commission";Decimal)
        {
            Editable = false;
        }
        field(7;"Date Logged";Date)
        {
            Editable = false;
        }
        field(8;"Time Logged";Time)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

