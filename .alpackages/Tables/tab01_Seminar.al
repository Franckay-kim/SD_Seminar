table 50101 "CSD Seminar"
//CSD1.00 - 2023-30-05 - D. E. Veloper
//seminar table
//new table
//chapter 5 lab 2-2
{
    Caption = 'Seminar';

    fields
    {
        field(10; No; Code[20])
        {
            Caption = 'No';
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(30; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(40; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(50; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(60; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(70; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
        }
        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(90; comment; Boolean)
        {
            Caption = 'comment';
            Editable = false;
            FieldClass = FlowField;
            //CalcFormula=exist("Seminar Comment Line" 
            //where("Table Name"= const("Seminar"), 
            // "No."=Field("No.")));
        }
        field(100; "Seminar Price"; Decimal)
        {
            caption = 'Seminar Price';
            AutoFormatType = 1;
        }
        field(110; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(120; "VAT prod. Posting Group"; code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT product Posting Group";
        }
        field(130; "No. Series"; Code[10])
        {
            Caption = 'No.Series';
            Editable = false;
            TableRelation = "No. Series";
        }




    }

    keys
    {
        key(Key1; No)
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