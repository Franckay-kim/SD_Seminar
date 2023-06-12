page 50110 "CSD Seminar Registration"
// CSD1.00 - 2023-06-12 - D. E. Veloper
// Chapter 7 - Lab 4-8
// Added Action Post

{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Seminar Registration Header";


    layout
    {
        area(Content)
        {
            part(SeminarRegistrationLines; "CSD Seminar Reg Subpage")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
            }

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

            part("Customer Details Factbox"; "Customer Details FactBox")
            {
                Provider = SeminarRegistrationLines;
                SubPageLink = "No." = field("Bill-to Customer No.");
            }

        }
    }
    // Chapter 7 - Lab 4-8
    // Added Action Post
    actions
    {
        area(Processing)
        {
            action("&Post")
            {
                Caption = '&Post';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ShortcutKey = F9;
                RunObject = codeunit "CSD Seminar-Post (Yes/No)";
            }


        }
    }
}