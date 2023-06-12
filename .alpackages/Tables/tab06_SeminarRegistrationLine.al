table 50111 "CSD Seminar Registration Line"
// CSD1.00 - 2023-06-06 - D. E. Veloper
//chapter 6 - Lab 1
//Created new table
{
    Caption = 'Seminar Registration Line';

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
        field(10; "Participant Name"; text[50])
        {
            caption = 'Participant Name';
        }
        field(11; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
        }
    }

    keys
    {
        key(Pk; "participant Contact No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        SeminarRegHeader: Record "Seminar Registration Header";
        GLSetup: Record "General Ledger Setup";

    trigger OnInsert()
    begin
        GetSeminarRegHeader;
        "Registration Date" := WorkDate;
        "Seminar Price" := SeminarRegHeader."Seminar Price";
        Amount := SeminarRegHeader."Seminar Price";
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    local procedure GetSeminarRegHeader();
    begin
        if SeminarRegHeader."No." <> "Document No." then
            SeminarRegHeader.Get("Document No.");
    end;

    local procedure UpdateAmount();
    begin
        GLSetup.Get;
        Amount := Round("Seminar Price" - "Line Discount Amount",
        GLSetup."Amount Rounding Precision");
    end;

}