table 51532225 "ATM Charges"
{

    fields
    {
        field(1;"Transaction Type";Option)
        {
            OptionCaption = 'Balance Enquiry,Mini Statement,Cash Withdrawal - Coop ATM,Cash Withdrawal - VISA ATM,Reversal,Utility Payment,POS - Normal Purchase,M-PESA Withdrawal,Airtime Purchase,POS - School Payment,POS - Purchase With Cash Back,POS - Cash Deposit,POS - Benefit Cash Withdrawal,POS - Cash Deposit to Card,POS - M Banking,POS - Cash Withdrawal,POS - Balance Enquiry,POS - Mini Statement,MINIMUM BALANCE';
            OptionMembers = "Balance Enquiry","Mini Statement","Cash Withdrawal - Coop ATM","Cash Withdrawal - VISA ATM",Reversal,"Utility Payment","POS - Normal Purchase","M-PESA Withdrawal","Airtime Purchase","POS - School Payment","POS - Purchase With Cash Back","POS - Cash Deposit","POS - Benefit Cash Withdrawal","POS - Cash Deposit to Card","POS - M Banking","POS - Cash Withdrawal","POS - Balance Enquiry","POS - Mini Statement","MINIMUM BALANCE";
        }
        field(2;"Total Amount";Decimal)
        {
        }
        field(3;"Sacco Amount";Decimal)
        {
        }
        field(4;Source;Option)
        {
            OptionMembers = ATM,POS;
        }
        field(5;"Bank Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Transaction Type")
        {
        }
    }

    fieldgroups
    {
    }
}

