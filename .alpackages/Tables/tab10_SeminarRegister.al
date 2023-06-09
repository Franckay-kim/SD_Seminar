table 50133 "CSD Seminar Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "From Entry No."; Integer)
        {
            caption = 'From Entry No.';
        }
        field(3; "To Entry No."; Integer)
        {
            caption = 'To Entry No.';
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(5; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(7; "Journal Batch Name"; code[10])
        {
            Caption = 'Journal Batch Name';
        }
    }

    keys
    {
        key(pk; "No.")
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

}