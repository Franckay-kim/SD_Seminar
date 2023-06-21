table 51532115 "M-SACCO Transactions"
{

    fields
    {
        field(1; "Document No."; Code[30])
        {
        }
        field(2; "Transaction Date"; Date)
        {
        }
        field(3; "Account No."; Code[50])
        {
        }
        field(4; Description; Text[200])
        {
        }
        field(5; Amount; Decimal)
        {
        }
        field(6; Posted; Boolean)
        {
        }
        field(7; "Transaction Type"; Option)
        {
            OptionCaption = 'Withdrawal,Deposit,Balance,Ministatement,Transfer,Advance,Loan Repayment,Guarantors,Guaranteed';
            OptionMembers = Withdrawal,Deposit,Balance,Ministatement,Transfer,Advance,"Loan Repayment",Guarantors,Guaranteed;
        }
        field(8; "Transaction Time"; Time)
        {
        }
        field(11; "Date Posted"; Date)
        {
        }
        field(12; "Time Posted"; Time)
        {
        }
        field(25; "Entry No"; Integer)
        {
            AutoIncrement = true;
            InitValue = 1;
        }
        field(26; Comments; Text[250])
        {
        }
        field(27; "Loan Amount"; Decimal)
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

    trigger OnDelete()
    begin
        Error('You cannot delete MPESA transactions.');
    end;

    trigger OnModify()
    begin

        if Posted = true then begin
            Error('You cannot modify posted MPESA transactions.');
        end;
    end;
}

