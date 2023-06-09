page 50122 "CSD Seminar Registers"
// CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 7 - Lab 2-11

{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Register";
    Caption = 'Seminar Registers';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; rec."No.")
                {

                }
                field("Creation Date"; rec."Creation Date")
                {

                }
                field("User ID"; rec."User ID")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Journal Batch Name"; rec."Journal Batch Name")
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
        area(Navigation)
        {
            action("Seminar Ledgers")
            {
                Image = WarrantyLedger;
                RunObject = codeunit "CSD Seminar Reg.-ShowLedger";
            }
        }
    }
}