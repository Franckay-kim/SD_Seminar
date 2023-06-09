pageextension 50102 "CSD SourceCodeSetupExt" extends "Source Code Setup"
// CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 7 - Lab 1-8
//new field
{
    layout
    {
        addafter("Cost Accounting")
        {
            group("CSD SeminarGroup")
            {
                Caption = 'Seminar';
                field(Seminar; rec."CSD Seminar")
                {
                }
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