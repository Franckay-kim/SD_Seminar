table 50132 "CSD Seminar Ledger Entry"
{
    Caption = 'Seminar Ledger Entry';
    // Chapter 8 - Lab 2 - 3
    // Added LookupPageId & DrilldownPageId properties
    LookupPageId = "CSD Seminar Ledger Entries";
    DrillDownPageId = "CSD Seminar Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Seminar No."; code[20])
        {
            caption = 'Seminar No.';
        }
        field(3; "Posting Date"; Date)
        {
            caption = 'Posting Date';
        }
        field(4; "Document Date"; Date)
        {
            caption = 'Document Date';
        }
        field(5; "Entry Type"; Option)
        {
            caption = 'Entry Type';
            OptionMembers = "";
        }
        field(6; "Document No."; Code[20])
        {
            caption = 'Document No';
        }
        field(7; "Description"; Text[50])
        {
            caption = 'Description';
        }
        field(8; "Bill-to Customer No."; code[20])
        {
            caption = 'Bill-to Customer No.';
        }
        field(9; "Charge Type"; Option)
        {
            caption = 'Charge Type';
            OptionMembers = "Instructor","Room","Participant";
        }
        field(10; "Type"; Option)
        {
            caption = 'Type';
            OptionMembers = "";
        }
        field(11; "Quantity"; Decimal)
        {
            caption = 'Quantity';
        }
        field(12; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(13; "Total Price"; Decimal)
        {
            caption = 'Total Price';
        }
        field(14; "Participant Contact No."; code[20])
        {
            Caption = 'Participant Contact No.';
        }
        field(15; "Partcicipant Name"; Text[50])
        {
            caption = 'Partcicpant Name';
        }
        field(16; "Chargeable"; Boolean)
        {
            Caption = 'Chargeable';
        }
        field(17; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
        }
        field(18; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
        }
        field(19; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(20; "Seminar Registration No."; code[20])
        {
            caption = 'Seminar Registration No.';
        }
        field(21; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
        }
        field(22; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = "";
        }
        field(23; "Source No."; Code[20])
        {
            Caption = 'Source No';
        }
        field(24; "Journal Batch Name"; Code[10])
        {
            caption = 'Journal Batch Name';
        }
        field(25; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(26; "Reason Code"; code[10])
        {
            Caption = 'Reason Code';
        }
        field(27; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(28; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = user where("User Name" = field("User Id"));
            ValidateTableRelation = false;

            trigger OnLookup();
            var
                UserMgt: Codeunit "User Management";
            begin
                //    usermgt.LookupUserID("User Id");
            end;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        // Chapter 8 - Lab 2-1
        // Added key2
        key(key2; "Document No.", "Posting Date")
        {
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

}