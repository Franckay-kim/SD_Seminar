/// <summary>
/// Report Reversed Journals (ID 50103).
/// </summary>
report 50103 "Reversed Journals"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    caption = 'Reversed Journals';
    RDLCLayout = './Layouts/ReversedJournals.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            //DataItemTableView = sorting("Entry No.") where(Reversed = const(true));
            RequestFilterFields = "Entry No.", "G/L Account No.";

            column(Entry_No_; "Entry No.")
            {
                IncludeCaption = true;
            }
            column(GL_Account_No; "G/L Account No.")
            {
                IncludeCaption = true;
            }
            column(G_L_Account_Name; "G/L Account Name")
            {
                IncludeCaption = true;
            }
            column(Amount; Amount)
            {
                IncludeCaption = true;
            }
            column(Reversed_Entry_No_; "Reversed Entry No.")
            {
                IncludeCaption = true;
            }
            column(Transaction_No_; "Transaction No.")
            {
                IncludeCaption = true;
            }
            column(Posting_Date; "Posting Date")
            {
                IncludeCaption = true;
            }
            column(Document_Type; "Document Type")
            {
                IncludeCaption = true;
            }
            column(Document_No_; "Document No.")
            {
                IncludeCaption = true;
            }
            column(User_ID; "User ID")
            {
                IncludeCaption = true;
            }


            trigger OnAfterGetRecord()
            begin

                if Reversed = true then
                    GLEntry.Get("Entry No.");


                /* if SavingsLedgerEntry."Customer No." = '' then
                     SavingsLedgerEntry.Get(SavingsLedgerEntry."Customer No.");
                 SavingsLedgerEntry.Get(SavingsLedgerEntry."Entry No.");
                 SavingsLedgerEntry.Get(SavingsLedgerEntry."Document No."); */









            end;

        }


        /*dataitem("Company Information"; "Company Information")
        {
            column(Company_Name; Name)
            {
            }
        } */
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
        ReversedJournalsCap = 'Reversed Journals';
    }

    var
        GLEntry: Record "G/L Entry";
        SavingsLedgerEntry: Record "Savings Ledger Entry";
}