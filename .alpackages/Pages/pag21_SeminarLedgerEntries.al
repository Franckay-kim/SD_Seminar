page 50121 "CSD Seminar Ledger Entries"
// CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 7 - Lab 2-9

{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Ledger Entry";
    Caption = 'Seminar Ledger Entry';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Document Date"; rec."Document Date")
                {
                    Visible = false;
                }
                field("Entry Type"; rec."Entry Type")
                {

                }
                field("Seminar No."; rec."Seminar No.")
                {

                }
                field(Description; rec.Description)
                {

                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                }
                field("Charge Type"; rec."Charge Type")
                {

                }
                field(Type; rec.Type)
                {

                }
                field(Quantity; rec.Description)
                {

                }
                field("Unit Price"; rec."Unit Price")
                {

                }
                field("Total Price"; rec."Total Price")
                {

                }
                field(Chargeable; rec.Chargeable)
                {

                }
                field("Participant Contact No."; rec."Participant Contact No.")
                {

                }
                field("Instructor Resource No."; rec."Instructor Resource No.")
                {

                }
                field("Room Resource No."; rec."Room Resource No.")
                {

                }
                field("Starting Date"; rec."Starting Date")
                {

                }
                field("Seminar Registration No."; rec."Seminar Registration No.")
                {

                }
                field("Entry No."; rec."Entry No.")
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
                    Navigate.SetDoc(rec."Posting Date", rec."Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }
}