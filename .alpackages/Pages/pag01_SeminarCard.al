/// <summary>
/// Page CSD Seminar Card (ID 50101).
/// </summary>
page 50101 "CSD Seminar Card"
//CSD1.00 - 2023-30-05 - D. E. Veloper
//seminar card page
{
    Caption = 'Seminar';
    PageType = Card;
    SourceTable = "CSD Seminar";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;

                    end;
                }
                field("Name"; Rec.Name)
                {

                }
                field("Search Name"; Rec."Search Name")
                {

                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {

                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {

                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {

                }
                field("Blocked"; Rec.Blocked)
                {

                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {

                }
            }
            group(invoicing)
            {
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {

                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {

                }
                field("Seminar Price"; Rec."Seminar Price")
                {

                }
            }
        }
        area(FactBoxes)
        {
            systempart("Links"; Links)
            {

            }
            systempart("Notes"; Notes)
            {

            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group("&Seminar")
            {
                action(Comments)
                {
                    //RunObject=page "CSD Seminar Comment Sheet";
                    //RunPageLink = "Table Name"= const(Seminar), 
                    // "No."=field("No.")
                    Image = Comment;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                }

                // >> Lab 8 1-2
                action("Ledger Entries")
                {
                    Caption = 'Ledger Entries';
                    RunObject = page "CSD Seminar Ledger Entries";
                    RunPageLink = "Seminar No." = field("No.");
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortcutKey = "Ctrl+F7";
                    Image = WarrantyLedger;
                }
                // >> Lab 8 1-2
                action("&Registrations")
                {
                    Caption = '&Registrations';
                    RunObject = page "CSD Seminar Registration List";
                    RunPageLink = "Seminar No." = field("No.");
                    Image = Timesheet;
                    Promoted = true;
                    PromotedCategory = Process;
                }
                // << Lab 8 1-2
            }
        }

        // >> Lab 8 1-2
        area(Processing)
        {
            action("Seminar Registration")
            {
                RunObject = page "CSD Seminar Registration";
                RunPageLink = "Seminar No." = field("No.");
                RunPageMode = Create;
                Image = NewTimesheet;
                Promoted = true;
                PromotedCategory = New;
            }
        }
        // << Lab 8 1-2

    }
}
