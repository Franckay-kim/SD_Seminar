page 50123 "CSD Posted Seminar Reg. List"
// CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 8 - Lab 2-3
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Posted Seminar Reg. Header";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; rec."No.")
                {

                }
                field("Instructor Code"; rec."Instructor Code")
                {

                }
                field("Instructor Name"; rec."Instructor Name")
                {

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            // Chapter 8 - Lab 2 - 4
            // Added Action Navigate

            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    Navigate: page Navigate;
                begin
                    Navigate.SetDoc(rec."Posting Date", rec."No.");
                    Navigate.RUN;
                end;
            }
        }
    }
}
