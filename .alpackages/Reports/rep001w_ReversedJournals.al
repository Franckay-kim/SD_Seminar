/// <summary>
/// Report Reversed Journals (ID 50103).
/// </summary>
report 50103 "Reversed Journals"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    caption = 'Reversed Journals';
    RDLCLayout = './Layouts/ReversedJournals.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            column(Entry_No_; "Entry No.")
            {

            }
            column(GL_Account_No; "G/L Account No.")
            {

            }
            column(G_L_Account_Name; "G/L Account Name")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(Amount; Amount)
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Transaction_No_; "Transaction No.")
            {

            }
            column(Reversed_Entry_No_; "Reversed Entry No.")
            {

            }

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

}