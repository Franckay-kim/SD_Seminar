table 51532236 "Deposit Return Buffer"
{

    fields
    {
        field(1;"No.";Integer)
        {
        }
        field(2;Range;Option)
        {
            OptionCaption = 'Less 50000,50001_100000,100001_300000,300001_1000000,Over 1000000';
            OptionMembers = "Less 50000","50001_100000","100001_300000","300001_1000000","Over 1000000";
        }
        field(3;"Type of Deposit";Option)
        {
            OptionMembers = " ",Non_Withdrawable,Savings,Term;
        }
        field(4;"No. of Accounts";Integer)
        {
        }
        field(5;"Amount in KES";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"No.","Type of Deposit")
        {
        }
    }

    fieldgroups
    {
    }
}

