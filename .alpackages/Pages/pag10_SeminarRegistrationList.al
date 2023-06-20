/// <summary>
/// Page CSD Seminar Registration List (ID 50113).
/// </summary>
page 50113 "CSD Seminar Registration List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Seminar Registration Header";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; rec."No.")
                {

                }
                field("Instructor Name"; rec."Instructor Name")
                {

                }
                field("comment"; rec."comment")
                {

                }
                field("Instructor Code"; rec."Instructor Code")
                {

                }
                field("Instructor Resource No."; rec."Instructor Resource No.")
                {

                }
                field("Room Resource No."; rec."Room Resource No.")
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
            // Chapter 7 - Lab 4-8
            // Added Action Post
            action("&Post")
            {
                Caption = '&Post';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ShortcutKey = F9;
                //RunObject = codeunit "CSD Seminar-Post (Yes/No)";
            }
        }

        area(Navigation)
        {
            action("&Print")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    SeminarReportSelection: Record "CSD Seminar Report Selections";
                begin
                    //SeminarReportSelection.PrintReportSelection
                    //(SeminarReportSelection.Usage::Registration, Rec);
                end;
            }
        }

    }
}
