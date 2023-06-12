pageextension 50103 "CSD ResourceLedgerEntryExt" extends "Resource Ledger Entries"
// CSD1.00 - 2023-06-12 - D. E. Veloper
// Chapter 7 - Lab 4-3

{
    layout
    {
        addlast(content)
        {
            field("Seminar No."; rec."CSD Seminar No.")
            {

            }
            field("Seminar Registration No."; rec."CSD Seminar Registration No.")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}