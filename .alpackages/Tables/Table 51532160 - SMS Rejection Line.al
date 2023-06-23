/// <summary>
/// Table SMS Rejection Line (ID 51532160).
/// </summary>
table 51532160 "SMS Rejection Line"
{
    Caption = 'Dynamic Request Page Field';
    LookupPageID = "Dynamic Request Page Fields";

    fields
    {
        field(1; "Header No"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Source; Option)
        {
            OptionCaption = 'New Member,New Account,Loan Approval,Deposit Confirmation,Cash Withdrawal Confirm,Loan Application,Loan Appraisal,Loan Guarantors,Loan Rejected,Loan Posted,Loan defaulted,Salary Processing,Teller Cash Deposit,Teller Cash Withdrawal,Teller Cheque Deposit,Fixed Deposit Maturity,InterAccount Transfer,Account Status,Status Order,EFT Effected, ATM Application Failed,ATM Collection,MSACCO,Member Changes,Cashier Below Limit,Cashier Above Limit,Chq Book,Bankers Cheque,Teller Cheque Transfer,Defaulter Loan Issued,Bonus,Dividend,Bulk,Standing Order,Loan Bill Due,POS Deposit,Mini Bonus,Leave Application';
            OptionMembers = "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application";
        }
        field(3; "Member No."; Code[20])
        {
            Caption = 'Customer CID';
        }
        field(4; Unsubscribe; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(5; "Modified By"; Code[50])
        {
            Editable = false;
        }
        field(6; "Date Modified"; Date)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Header No", Source)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if SMSRejectionHeader.Get("Header No") then begin
            "Member No." := SMSRejectionHeader."Member No";
        end;

        "Modified By" := UserId;
        "Date Modified" := Today;
    end;

    trigger OnModify()
    begin

        "Modified By" := UserId;
        "Date Modified" := Today;

        if SMSRejectionHeader.Get("Header No") then begin
            "Member No." := SMSRejectionHeader."Member No";
        end;
    end;

    trigger OnRename()
    begin

        "Modified By" := UserId;
        "Date Modified" := Today;
    end;

    var
        SMSRejectionHeader: Record "SMS Rejection Header";
}

