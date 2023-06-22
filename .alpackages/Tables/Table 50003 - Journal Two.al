/// <summary>
/// Table Journal Two (ID 51533467).
/// </summary>
table 51533467 "Journal Two"
{

    fields
    {
        field(1; "No."; Integer)
        {
        }
        field(2; "Account No"; Code[30])
        {
            /*  TableRelation = IF ("Accout Type" = FILTER("G/L Account")) "G/L Account"
              ELSE
              IF ("Accout Type" = FILTER("Fixed Asset")) "Fixed Asset"
              ELSE
              IF ("Accout Type" = FILTER(Savings)) "Savings Accounts"
              ELSE
              IF ("Accout Type" = FILTER(Credit)) "Credit Accounts"
              ELSE
              IF ("Accout Type" = FILTER("Bank Account")) "Bank Account"
              ELSE
              IF ("Accout Type" = FILTER(Customer)) Customer
              ELSE
              IF ("Accout Type" = FILTER(Vendor)) Vendor;*/

            trigger OnValidate()
            begin
                /*IF SavingsAccounts.GET("Account No") THEN BEGIN
                  IF Members.GET(SavingsAccounts."Member No.") THEN
                  Dim1:=Members."Global Dimension 1 Code";// ."Global Dimension 1 Code";
                  END;
                
                IF CreditAccounts.GET("Account No") THEN BEGIN
                  IF Members.GET(CreditAccounts."Member No.") THEN
                  Dim1:=Members."Global Dimension 1 Code";// ."Global Dimension 1 Code";
                
                  END;
                  */

            end;
        }
        field(3; Description; Code[100])
        {
        }
        field(4; "Accout Type"; Enum "Gen. Journal Account Type")
        {
            // OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit,Member';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit,Member;
        }
        field(8; "Posting Date"; Date)
        {
        }
        field(9; Amount; Decimal)
        {
        }
        field(10; Dim1; Code[20])
        {
        }
        field(12; "Document No"; Code[30])
        {
        }
        field(13; "External Doc"; Code[30])
        {
        }
        field(14; Posted; Boolean)
        {
        }
        field(15; "Depreciation Book"; Code[50])
        {
            TableRelation = "Depreciation Book";
        }
        field(16; "Batch Name"; Code[50])
        {
        }
        field(17; Userid; Code[20])
        {
        }
        field(18; "System created"; Boolean)
        {
        }
        field(19; "G/L ACC No."; Code[20])
        {
        }
        field(69021; "Bal Accout Type"; Enum "Gen. Journal Account Type")
        {
            // OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None,Staff';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Member,"None",Staff;
        }
        field(69022; "bal Account No"; Code[30])
        {
        }
        field(69023; "TransaCTION tYPE"; Option)
        {
            // OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
            OptionMembers = " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Loan Registration Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid","Partial Disbursement","Suspended Interest Due","Suspended Interest Paid";
        }
        field(69024; "Loan No"; Code[21])
        {
        }
        field(69025; Duplicate; Integer)
        {
        }
        field(39003901; "FA Posting Type"; Enum "Gen. Journal Line FA Posting Type")
        {
            AccessByPermission = TableData 5600 = R;
            Caption = 'FA Posting Type';
            // OptionCaption = ' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance';
            // OptionMembers = " ","Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SavingsAccounts: Record "Savings Accounts";
        Members: Record Members;
        CreditAccounts: Record "Credit Accounts";
}

