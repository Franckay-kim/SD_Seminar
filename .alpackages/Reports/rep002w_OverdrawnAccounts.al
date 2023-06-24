/// <summary>
/// Report Overdrawn Accounts (ID 50104).
/// </summary>
report 50104 "Overdrawn Accounts"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Overdrawn Accounts';
    ApplicationArea = All;
    RDLCLayout = './Layouts/OverdrawnAccounts.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Savings Accounts"; "Savings Accounts")
        {
            //sort using NO. field, for accounts with a balance less than 0
            DataItemTableView = sorting("No.") where(Balance = filter('<0'));
            RequestFilterFields = "No.", "Savings Account No.";

            column(No; "No.")
            {
                IncludeCaption = true;
            }
            column(Name; Name)
            {
                IncludeCaption = true;
            }
            column(Member_No_; "Member No.")
            {
                IncludeCaption = true;
            }
            column(Balance; Balance)
            {
                IncludeCaption = true;
            }
            column(Balance__LCY_; "Balance (LCY)")
            {
                IncludeCaption = true;
            }
            column(Debit_Amount; "Debit Amount")
            {
                IncludeCaption = true;
            }
            column(Credit_Amount; "Credit Amount")
            {
                IncludeCaption = true;
            }
            column(Savings_Account_No_; "Savings Account No.")
            {
                IncludeCaption = true;
            }

            trigger OnPreDataItem()
            begin
                //get company info for the header.
                CompInfo.Get;
                CompInfo.Get(CompInfo.Name);
                CompInfo.Get(CompInfo."E-Mail");
                CompInfo.Get(CompInfo."Post Code");
                CompInfo.Get(CompInfo."Phone No.");
            end;

            trigger OnAfterGetRecord()
            begin
                if Balance < 0 then
                    SavingsAcc.Get("No.");

            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    /*field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    }*/
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    labels
    {
        OverdrawnAccountsCap = 'Overdrawn Accounts';
    }

    var
        SavingsAcc: Record "Savings Accounts";
        CompInfo: Record "Company Information";
}