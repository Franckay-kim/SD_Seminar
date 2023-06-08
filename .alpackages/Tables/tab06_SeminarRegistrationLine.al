table 50111 "CSD Seminar Registration Line"
// CSD1.00 - 2023-06-06 - D. E. Veloper
//chapter 6 - Lab 1
//Created new table
{
    Caption = 'Seminar Registration Line';

    fields
    {
        field(1; "Bill-to Customer No"; Integer)
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
        if SeminarRegistrationHeader."No." <> "Document No." then
            SeminarRegistrationHeader.Get("Document No.");
    end;

    local procedure UpdateAmount();
    begin
        GLSetup.Get;
        Amount := Round("Seminar Price" - "Line Discount Amount",
        GLSetup."Amount Rounding Precision");
    end;

}