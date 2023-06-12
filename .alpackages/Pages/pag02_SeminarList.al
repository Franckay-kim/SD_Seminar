page 50102 "CSD Seminar List"
//CSD1.00 - 2023-30-05 - D. E. Veloper
//seminar list
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar";
    Caption = 'seminar';
    Editable = false;
    CardPageId = 50101;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {

                }
                field("Name"; rec.Name)
                {

                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {

                }
                field("Seminar Price"; Rec."Seminar Price")
                {

                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {

                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {

                }
            }
        }
        area(Factboxes)
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
                    RunObject = page "CSD Seminar Comment Sheet";
                    RunPageLink = "Table Name" = const(Seminar), "No." = field("No.");
                    Image = Comment;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                }
                // >> Lab 8-2
                action("Ledger Entries")
                {
                    RunObject = page "CSD Seminar Ledger Entries";
                    RunPageLink = "Seminar No." = field("No.");
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortcutKey = "Ctrl+F7";
                    Image = WarrantyLedger;
                }
                action("&Registrations")
                {
                    RunObject = page "CSD Seminar Registration List";
                    RunPageLink = "Seminar No." = field("No.");
                    Image = Timesheet;
                    Promoted = true;
                    PromotedCategory = Process;
                }
                // << Lab 8-2

            }
        }

        // >> Lab 8-2
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
        // << Lab 8-2

    }
}