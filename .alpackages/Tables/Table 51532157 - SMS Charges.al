table 51532157 "SMS Charges"
{

    fields
    {
        field(1;Source;Option)
        {
            OptionCaption = 'New Member,New Account,Loan Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit,Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued,Bonus,Dividend,Bulk,Standing Order,Loan Bill Due,POS Deposit,Mini Bonus,Leave Application,Loan Witness,PV';
            OptionMembers = "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application","Loan Witness",PV;
        }
        field(2;"Charge Amount";Decimal)
        {
        }
        field(3;"Charge G/L Account";Code[20])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1;Source)
        {
        }
    }

    fieldgroups
    {
    }
}

