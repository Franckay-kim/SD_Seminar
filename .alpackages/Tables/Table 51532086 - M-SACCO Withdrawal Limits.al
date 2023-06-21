table 51532086 "M-SACCO Withdrawal Limits"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Limit Amount"; Decimal)
        {
        }
        field(4; Default; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

