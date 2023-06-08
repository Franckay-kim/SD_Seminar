page 50110 "CSD Seminar Registration"
{
    PageType = Document;
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
            part("Seminar Details FactBox"; "CSD Seminar Details FactBox")
            {
                SubPageLink = "No." = field("Seminar No.");
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