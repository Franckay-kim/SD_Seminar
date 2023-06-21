table 51532142 "M-SACCO Other Services"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Trace ID"; Code[100])
        {
        }
        field(3; "Account No"; Code[150])
        {
        }
        field(4; "Telephone No"; Code[20])
        {
        }
        field(5; "Transaction Type"; Option)
        {
            OptionCaption = 'Cheque Request,Stop Cheque,ATM Request,Stop ATM';
            OptionMembers = "Cheque Request","Stop Cheque","ATM Request","Stop ATM";
        }
        field(6; "Cheque Leaf From"; Code[10])
        {
        }
        field(7; "Cheque Leaf To"; Code[10])
        {
        }
        field(8; "Transaction Date"; DateTime)
        {
        }
        field(9; Posted; Boolean)
        {
        }
        field(10; Comment; Text[150])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

