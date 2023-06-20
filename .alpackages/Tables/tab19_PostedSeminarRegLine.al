/// <summary>
/// Table CSD Posted Seminar Reg. Line (ID 50119).
/// </summary>
table 50119 "CSD Posted Seminar Reg. Line"
// CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 7 - Lab 3-3

{
    Caption = 'CSD Posted Seminar Reg. Line';

    fields
    {
        field(1; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No';
        }
        field(2; "Participant Contact No."; code[20])
        {
            Caption = 'Participant Contact No.';
        }
        field(3; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
        }
        field(4; "Line Discount %"; Integer)
        {
            Caption = 'Line Discount %';
        }
        field(5; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(6; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(7; "Document No."; code[20])
        {
            Caption = 'Document No.';
        }
        field(8; "Registered"; Boolean)
        {
            Caption = 'Registered';
        }
        field(9; "Registration Date"; Date)
        {
            caption = 'Registration Date';
        }
    }

    keys
    {
        key(Pk; "participant Contact No.")
        {
            Clustered = true;
        }
    }



    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;


}