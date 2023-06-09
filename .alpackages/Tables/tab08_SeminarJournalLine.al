table 50131 "CSD Seminar Journal Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Journal Template Name"; code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(2; "Seminar No."; Code[10])
        {
            caption = 'Seminar No.';
        }
        field(3; "Journal Batch Name"; code[10])
        {
            caption = 'Journal Batch Name';
        }
        field(4; "Posting Date"; Date)
        {
            caption = 'Posting Date';
            trigger OnValidate();
            begin
                Validate("Document Date", "Posting Date");
            end;
        }
        field(5; "Document Date"; Date)
        {
            caption = 'Document Date';
        }
        field(6; "Source Code"; Code[10])
        {
            caption = 'Source Code';
        }
        field(7; "Reason Code"; code[10])
        {
            caption = 'Reason Code';
        }
        field(8; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(9; "Quantity"; Decimal)
        {
            caption = 'Quantity';
        }
        field(10; "Instructor Resource No."; code[20])
        {
            Caption = 'Instructor Resource No.';
        }
        field(11; "Charge Type"; Option)
        {
            caption = 'Charge Type';
            OptionMembers = "Instructor","Room","Participant";
        }
        field(12; "Participant Contact No."; code[20])
        {
            caption = 'Participant Contact No.';
        }
        field(13; "Room Resource No."; code[20])
        {
            caption = 'Room Resorce No.';
        }
        field(14; "Chargeable"; Boolean)
        {
            Caption = 'Chargeable';
        }
        field(15; "Bill-to Customer No."; code[20])
        {
            caption = 'Bill-to Customer No.';
        }

    }

    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

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

    procedure EmptyLine(): Boolean;
    begin
        exit(("Seminar No." = '') AND (Quantity = 0));
    end;
}