/// <summary>
/// Report Fosa Transfer (ID 50105).
/// </summary>
report 50105 "Fosa Transfer"
{
    Caption = 'Fosa Transfer';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fosa Transfer.rdl';

    dataset
    {
        dataitem("Savings Ledger Entry"; "Savings Ledger Entry")
        {

            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Entry No.", "Transaction No.";

            column(Entry_No_; "Entry No.")
            {
                IncludeCaption = true;
            }
            column(Customer_No_; "Customer No.")
            {
                IncludeCaption = true;
            }
            column(Bal__Account_No_; "Bal. Account No.")
            {
                IncludeCaption = true;
            }
            column(Transaction_No_; "Transaction No.")
            {
                IncludeCaption = true;
            }
            column(Credit_Amount; "Credit Amount")
            {
                IncludeCaption = true;
            }
            column(Debit_Amount; "Debit Amount")
            {
                IncludeCaption = true;
            }
            column(Company_name; CompInfo.Name)
            {
                IncludeCaption = true;
            }
            column(Company_Email; CompInfo."E-Mail")
            {
                IncludeCaption = true;
            }
            column(Company_PostCode; CompInfo."Post Code")
            {
                IncludeCaption = true;
            }
            column(Company_PhoneNo; CompInfo."Phone No.")
            {
                IncludeCaption = true;
            }



            trigger OnAfterGetRecord()
            begin
                if "Debit Amount" = "Credit Amount" then begin
                    if "Bal. Account No." <> "Bal. Account No." then
                        SavLedg.Get("Transaction No.");
                end;
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
                    /* field(Name; SourceExpression)
                     {
                         ApplicationArea = All;

                     } */
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
        FosaTransferCap = 'Fosa Transfer';
    }

    trigger OnPreReport()
    begin
        CompInfo.Get;
        CompInfo.SetAutoCalcFields();
    end;

    var
        SavLedg: Record "Savings Ledger Entry";
        CompInfo: Record "Company Information";
        myInt: Integer;
}
