page 50111 "CSD Seminar Reg Subpage"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Registration Line";
    Caption = 'Lines';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Bill-to Customer No"; rec."Bill-to Customer No.")
                {

                }
                field("Participant Contact No."; rec."Participant Contact No.")
                {

                }
                field("Seminar Price"; rec."Seminar Price")
                {

                }
                field("Line Discount %"; rec."Line Discount %")
                {

                }
                field("Line Discount Amount"; rec."Line Discount Amount")
                {

                }
                field("Amount"; rec.Amount)
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}