table 51532090 "M-SACCO SMS Messages"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            NotBlank = true;
        }
        field(2; Source; Option)
        {
            OptionCaption = 'New Member,New Account,Loan Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit,Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued,Bonus,Dividend,Bulk,Standing Order,Loan Bill Due,POS Deposit,Mini Bonus,Leave Application,Loan Witness,PV,Insurance Expiry';
            OptionMembers = "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application","Loan Witness",PV,"Insurance Expiry";
        }
        field(3; "Telephone No"; Code[40])
        {
        }
        field(4; "Date Entered"; Date)
        {
        }
        field(5; "Time Entered"; Time)
        {
        }
        field(6; "Entered By"; Code[150])
        {
        }
        field(7; "SMS Message"; Text[360])
        {
        }
        field(8; "Sent To Server"; Option)
        {
            OptionCaption = 'No,Yes,Failed';
            OptionMembers = No,Yes,Failed;
        }
        field(9; "Date Sent to Server"; Date)
        {
        }
        field(13; "Account No"; Code[30])
        {
            TableRelation = "Savings Accounts";
        }
        field(15; "Document No"; Code[30])
        {
        }
        field(16; "System Created Entry"; Boolean)
        {
        }
        field(17; "Bulk SMS Balance"; Decimal)
        {
        }
        field(21; IsChargeable; Boolean)
        {
        }
        field(22; Posted; Boolean)
        {
        }
        field(23; Source2; Code[20])
        {
        }
        field(24; "Post to Loan Penalty"; Boolean)
        {
        }
        field(25; "Charge Not Found"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No", "Telephone No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        NoSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

