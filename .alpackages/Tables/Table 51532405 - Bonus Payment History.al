table 51532405 "Bonus Payment History"
{

    fields
    {
        field(1; "Account No."; Code[20])
        {
        }
        field(2; "Member No."; Code[20])
        {
        }
        field(3; Name; Text[150])
        {
        }
        field(4; Date; Date)
        {
        }
        field(5; Year; Integer)
        {
        }
        field(6; "Bonus Amount"; Decimal)
        {
        }
        field(7; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Account No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

