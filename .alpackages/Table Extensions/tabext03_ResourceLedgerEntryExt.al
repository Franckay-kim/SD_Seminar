/// <summary>
/// TableExtension  CSD ResourceLedgerEntryExt (ID 50103) extends Record Res. Ledger Entry.
/// </summary>
tableextension 50103 " CSD ResourceLedgerEntryExt" extends "Res. Ledger Entry"
// CSD1.00 - 2023-06-12 - D. E. Veloper
// Chapter 7 - Lab 4-1

{
    fields
    {
        field(50100; "CSD Seminar No."; code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";
        }
        field(50101; "CSD Seminar Registration No."; code[20])
        {
            Caption = 'Seminar Registration No.';
            TableRelation = "Seminar Registration Header";
        }
    }

    var
        myInt: Integer;
}