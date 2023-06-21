table 51532227 "ATM Log Entries"
{

    fields
    {
        field(1;"Entry No";BigInteger)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2;"Date Time";DateTime)
        {
        }
        field(3;"Account No";Code[20])
        {
        }
        field(4;Amount;Decimal)
        {
        }
        field(5;"ATM No";Code[20])
        {
        }
        field(6;"ATM Location";Text[250])
        {
        }
        field(7;"Transaction Type";Option)
        {
            OptionCaption = 'Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE';
            OptionMembers = "Balance Enquiry","Mini Statement","Cash Withdrawal - Coop ATM","Cash Withdrawal - VISA ATM",Reversal,"Utility Payment","POS - Normal Purchase","M-PESA Withdrawal","Airtime Purchase","POS - School Payment","POS - Purchase With Cash Back","POS - Cash Deposit","POS - Benefit Cash Withdrawal","POS - Cash Deposit to Card","POS - M Banking","POS - Cash Withdrawal","POS - Balance Enquiry","POS - Mini Statement","MINIMUM BALANCE";
        }
        field(8;"Return Code";Option)
        {
            OptionMembers = "Transaction Succeded","Insufficient Funds","Invalid Card","Card Blocked","Unspecified Error";
        }
        field(9;"Trace ID";Code[20])
        {
        }
        field(13;"Account No.";Code[20])
        {
        }
        field(14;"Card No.";Code[20])
        {
        }
        field(15;"ATM Amount";Decimal)
        {
        }
        field(16;"Withdrawal Location";Text[100])
        {
        }
        field(17;"Refference No.";Code[100])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
        key(Key2;"Date Time")
        {
        }
        key(Key3;"Account No")
        {
        }
        key(Key4;Amount)
        {
        }
        key(Key5;"Transaction Type")
        {
        }
    }

    fieldgroups
    {
    }
}

