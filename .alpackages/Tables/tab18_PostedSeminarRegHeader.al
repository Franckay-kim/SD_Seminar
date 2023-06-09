table 50118 "CSD Posted Seminar Reg. Header"
// CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 7 - Lab 3-1

{
    Caption = 'Posted Seminar Reg. Header';

    fields
    {
        field(1; "No."; code[20])
        {
            Caption = 'No.';

        }
        field(2; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            CalcFormula = lookup(Resource.Name where("No." = field("Instructor Resource No."), Type = const(person)));

            Editable = false;
            FieldClass = FlowField;
        }
        field(3; comment; Boolean)
        {
            Caption = 'comment';
            CalcFormula = Exist("CSD Seminar Comment Line" where("Table Name" = const("Posted Seminar Registration"), "No." = Field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
        }
        field(5; "Instructor Resource No."; Code[20])
        {
            caption = 'Instuctor Resource No.';
        }
        field(6; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
        }
        field(7; "Seminar Registration Nos."; code[20])
        {
            Caption = 'Seminar Registration Nos.';
        }
        field(8; "No. Series"; Integer)
        {
            caption = 'No. Series';
        }
        field(9; "status"; Option)
        {
            OptionMembers = "open","active","canceled","planning";
            Caption = 'status';
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(11; "Seminar No."; Code[20])
        {
            caption = 'Seminar No.';
        }
        field(12; "Room Post Code"; code[20])
        {
            Caption = 'Room Post Code';

        }
        field(13; "Room City"; Text[20])
        {
            Caption = 'Room City';

        }
        field(14; "Seminar Price"; Decimal)
        {
            caption = 'Seminar Price';
        }
        field(29; "User Id"; Code[50])
        {
            Caption = 'User Id';
            TableRelation = User;
            ValidateTableRelation = false;
        }
        field(30; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
    }

    keys
    {
        key(PK; "No.")
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