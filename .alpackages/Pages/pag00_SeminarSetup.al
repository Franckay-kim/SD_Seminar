/// <summary>
/// Page CSD Seminar Setup (ID 50100).
/// </summary>
page 50100 "CSD Seminar Setup"
//CSD1.00 - 2023-30-05 - D. E. Veloper
//seminar setup card page
{
    Caption = '"Seminar Setup"';
    PageType = Card;
    SourceTable = "CSD Seminar Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Seminar Nos"; Rec."Seminar Nos")
                {

                }
                field("Seminar Registration Nos"; Rec."Seminar Registration Nos")
                {

                }
                field("Posted Seminar Reg. Nos"; Rec."Posted Seminar Reg. Nos")
                {

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.get then begin
            Rec.init;
            Rec.insert;
        end;
    end;
}
