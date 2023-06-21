table 51532081 "ATM Transactions"
{


    fields
    {
        field(1; "Trace ID"; Code[20])
        {
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; "Account No"; Code[20])
        {
        }
        field(4; Description; Text[200])
        {
        }
        field(5; Amount; Decimal)
        {
        }
        field(6; "Posting S"; Text[50])
        {
        }
        field(7; Posted; Boolean)
        {
        }
        field(8; "Unit ID"; Code[10])
        {
        }
        field(9; "Transaction Type"; Text[30])
        {
        }
        field(10; "Trans Time"; Text[50])
        {
        }
        field(11; "Transaction Time"; Time)
        {
        }
        field(12; "Transaction Date"; Date)
        {
        }
        field(13; Source; Option)
        {
            OptionMembers = ATM,"M-PESA";
        }
        field(14; Reversed; Boolean)
        {
        }
        field(16; "Reversed Posted"; Boolean)
        {
            Editable = true;
        }
        field(17; "Reversal Trace ID"; Code[20])
        {
        }
        field(18; "Transaction Description"; Text[100])
        {
        }
        field(19; "Withdrawal Location"; Text[150])
        {
        }
        field(20; "Entry No"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(22; "Transaction Type Charges"; Option)
        {
            OptionCaption = 'Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE';
            OptionMembers = "Balance Enquiry","Mini Statement","Cash Withdrawal - Coop ATM","Cash Withdrawal - VISA ATM",Reversal,"Utility Payment","POS - Normal Purchase","M-PESA Withdrawal","Airtime Purchase","POS - School Payment","POS - Purchase With Cash Back","POS - Cash Deposit","POS - Benefit Cash Withdrawal","POS - Cash Deposit to Card","POS - M Banking","POS - Cash Withdrawal","POS - Balance Enquiry","POS - Mini Statement","MINIMUM BALANCE";
        }
        field(23; "Card Acceptor Terminal ID"; Code[20])
        {
        }
        field(24; "ATM Card No"; Code[20])
        {
        }
        field(25; "Customer Names"; Text[100])
        {
        }
        field(26; "Process Code"; Code[20])
        {
        }
        field(27; "Is Coop Bank"; Boolean)
        {
        }
        field(28; "POS Vendor"; Option)
        {
            OptionCaption = 'ATM Lobby,Coop,Sacco';
            OptionMembers = "ATM Lobby",Coop,Sacco;
        }
        field(29; "Reference No"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
        key(Key2; "Trace ID", "Unit ID", "Transaction Type", "Posting S")
        {
        }
        key(Key3; "Account No", Posted)
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Transaction Date", "Transaction Time")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('You are not allowed to delete anything from this table');
    end;

    trigger OnInsert()
    begin
        Error('You are not allowed to manually insert anything into this table');
    end;

    trigger OnModify()
    begin
        Error('You are not allowed to modify anything in this table');
    end;

    trigger OnRename()
    begin
        Error('You are not allowed to edit anything from this table');
    end;
}

