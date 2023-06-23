/// <summary>
/// Table Transaction Types (ID 51532099).
/// </summary>
table 51532099 "Transaction Types"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = 'Cash Deposit,Cash Withdrawal,Credit Receipt,Credit Cheque,Bankers Cheque,Cheque Deposit,Cheque Withdrawal,Salary Processing,EFT,RTGS,Overdraft,Standing Order,Dividend,Msacco Balance Enquiry,Msacco Deposit,Msacco Ministatement,Msacco Transfer,Msacco Withdrawal,Msacco Registration,Msacco Charge,Transfers,ATM Applications,Member Withdrawal,ATM Replacement,Statement,Bounced Cheque,Lien,Cheque Application,Bank Transfer Mode,Sacco_Co-op Charge,Savings Penalty,Delegates Payment,Msacco Sms,Income Transactions,Cheque Unpay,Inhouse Cheque Transfer,Mobile Transaction,MSACCO Utility Payment,Loan Penalty,Share Transfer,Top Up';
            OptionMembers = "Cash Deposit","Cash Withdrawal","Credit Receipt","Credit Cheque","Bankers Cheque","Cheque Deposit","Cheque Withdrawal","Salary Processing",EFT,RTGS,Overdraft,"Standing Order",Dividend,"Msacco Balance Enquiry","Msacco Deposit","Msacco Ministatement","Msacco Transfer","Msacco Withdrawal","Msacco Registration","Msacco Charge",Transfers,"ATM Applications","Member Withdrawal","ATM Replacement",Statement,"Bounced Cheque",Lien,"Cheque Application","Bank Transfer Mode","Sacco_Co-op Charge","Savings Penalty","Delegates Payment","Msacco Sms","Income Transactions","Cheque Unpay","Inhouse Cheque Transfer","Mobile Transaction","MSACCO Utility Payment","Loan Penalty","Share Transfer","Top Up";
        }
        field(4; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Savings));

            trigger OnValidate()
            var
                ProductFactory: Record "Product Factory";
            begin
                if ProductFactory.Get("Product Type") then
                    "Product Name" := ProductFactory."Product Description";
            end;
        }
        field(5; "Default Mode"; Option)
        {
            OptionCaption = 'Cash,Cheque';
            OptionMembers = Cash,Cheque;
        }
        field(12; "Requires Finger Verification"; Boolean)
        {
        }
        field(13; "Product Name"; Text[50])
        {
            Editable = false;
        }
        field(14; "Upper Limit"; Decimal)
        {
        }
        field(15; Category; Option)
        {
            OptionCaption = ' ,Cashier';
            OptionMembers = " ",Cashier;
        }
        field(16; "Account Type"; Option)
        {
            Caption = 'Default Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit,Member';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit,Member;
        }
        field(17; "Account No."; Code[20])
        {
            Caption = 'Default Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Account Type" = CONST(Credit)) "Credit Accounts";
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

