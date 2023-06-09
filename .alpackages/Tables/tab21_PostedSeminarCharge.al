table 50121 " CSD Posted Seminar Charge"
// CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 7 - Lab 3-4

{
    Caption = 'CSD Posted Seminar Charge';

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';

        }
        field(2; "Type"; Option)
        {
            caption = 'Type';
            OptionMembers = "Resource","G/L Account";

        }
        field(3; "Quantity"; Decimal)
        {
            caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(4; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(5; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Editable = false;

        }
        field(6; "Unit of Measure Code"; Code[20])
        {
            caption = 'Unit of Measure Code';

        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        Resource: Record "Resource";
        GLAccount: Record "G/L Account";
        ResourceUofM: Record "Resource Unit of Measure";




    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

}