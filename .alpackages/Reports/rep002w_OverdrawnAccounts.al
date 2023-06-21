report 50104 "Overdrawn Accounts"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Overdrawn Accounts';
    ApplicationArea = All;
    RDLCLayout = './Layouts/OverdrawnAccounts.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        /*dataitem(DataItemName; SourceTableName)
        {
            column(ColumnName; SourceFieldName)
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


}