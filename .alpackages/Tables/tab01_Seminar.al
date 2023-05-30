table 50101 "CSD Seminar"
//CSD1.00 - 2023-30-05 - D. E. Veloper
//seminar table
//new table
//chapter 5 lab 2-2
{
    Caption = 'Seminar';
    LookupPageId = "CSD Seminar List";
    DrillDownPageId = "CSD Seminar List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.GET;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or
                    ("Search Name" = '') then
                    "Search Name" := Name;
            end;
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
            trigger OnValidate()
            begin
                if (xRec."Gen. Prod. Posting Group" <>
                    "Gen. Prod. Posting Group") then begin
                    if GenProdPostingGroup.ValidateVatProdPostingGroup
                    (GenProdPostingGroup, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group",
                        GenProdPostingGroup."Def. VAT Prod. Posting Group");
                end;
            end;
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
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key1; "Search Name")
        {

        }
    }

    var
        SeminarSetup: Record "CSD Seminar Setup";
        //CommentLine : record "CSD Seminar Comment Line";
        Seminar: Record "CSD Seminar";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.get;
            SeminarSetup.TestField("Seminar Nos");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;

    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnDelete()
    begin
        //CommentLine.Reset;
        //CommentLine.SetRange("Table Name", 
        //CommentLine."Table Name"::Seminar); 
        //CommentLine.SetRange("No.","No.");
        // CommentLine.DeleteAll;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    procedure AssistEdit(): Boolean;

    begin
        with Seminar do begin
            Seminar := Rec;
            SeminarSetup.get;
            SeminarSetup.TestField("Seminar Nos");
            if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos"
            , xRec."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                Rec := Seminar;
                exit(true);
            end;
        end;
    end;
}