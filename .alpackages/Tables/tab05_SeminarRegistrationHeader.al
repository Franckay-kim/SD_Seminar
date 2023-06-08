table 50110 "Seminar Registration Header"
// CSD1.00 - 2023-06-06 - D. E. Veloper
//chapter 6 - Lab 1
//Created new table
{
    Caption = 'Seminar Registration Header';

    fields
    {
        field(1; "No."; code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.GET;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Registration Nos.");
                end;
            end;

        }
        field(2; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            CalcFormula = lookup(Resource.Name where("No." = field("Instructor Resource No."), Type = const(person)));

            Editable = false;
            FieldClass = FlowField;
        }
        field(3; comment; Text[20])
        {
            Caption = 'comment';
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
            trigger OnValidate()
            begin
                if "Starting Date" <> xRec."Starting Date" then
                    TestField(Status, Status::Planning);
            end;
        }
        field(11; "Seminar No."; Code[20])
        {
            caption = 'Seminar No.';
            trigger OnValidate()
            begin
                If "Seminar No." <> xRec."Seminar No." then begin
                    SeminarRegLine.RESET;
                    SeminarRegLine.SETRANGE("Document No.", "No.");
                    SeminarRegLine.SETRANGE(Registered, TRUE);
                    if not SeminarRegLine.ISEMPTY then
                        ERROR(
                        Text002,
                        FieldCaption("Seminar No.")
                        )
                end;
            end;
        }
        field(12; "Room Post Code"; code[20])
        {
            Caption = 'Room Post Code';
            trigger OnValidate();
            begin
                PostCode.ValidatePostCode("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;

        }
        field(13; "Room City"; Text[20])
        {
            Caption = 'Room City';
            trigger OnValidate();
            begin
                PostCode.ValidatePostCode("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;

        }
        field(14; "Seminar Price"; Decimal)
        {
            caption = 'Seminar Price';
            trigger OnValidate()
            begin
                if ("Seminar Price" <> xRec."Seminar Price") and
 (Status <> Status::Canceled) then begin
                    SeminarRegLine.RESET;
                    SeminarRegLine.SETRANGE("Document No.", "No.");
                    SeminarRegLine.SETRANGE(Registered, FALSE);
                    if SeminarRegLine.FINDSET(FALSE, FALSE) then
                        if CONFIRM(Text005, FALSE,
                        FieldCaption("Seminar Price"),
                        SeminarRegLine.TableCaption) then
                            repeat
                                SeminarRegLine.VALIDATE("Seminar Price",
                                "Seminar Price");
                                SeminarRegLine.Modify;
                            until SeminarRegLine.NEXT = 0;
                    Modify;
                end;

            end;
        }
        field(15; "Posting No. Series"; Integer)
        {
            caption = 'Posting No. Series';
            trigger OnValidate();
            begin
                if "Posting No. Series" <> '' then begin
                    SeminarSetup.GET;
                    SeminarSetup.TestField("Seminar Registration Nos.");
                    SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    NoSeriesMgt.TestSeries(SeminarSetup."Posted Seminar 
 Reg. Nos.", "Posting No. Series");
 end;
                TestField("Posting No.", '');
            end;

            trigger OnLookup();
            begin
                with SeminarRegHeader do begin
                    SeminarRegHeader := Rec;
                    SeminarSetup.GET;
                    SeminarSetup.TestField("Seminar Registration Nos.");
                    SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    if NoSeriesMgt.LookupSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series") then begin
                        validate("Posting No. Series");
                    end;
                    Rec := SeminarRegHeader;
                end;
            end;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }




    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.GET;
            SeminarSetup.TESTFIELD("Seminar Registration Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Registration Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        InitRecord;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        if (CurrFieldNo > 0) then
            TestField(Status, Status::Canceled);
        SeminarRegLine.RESET;
        SeminarRegLine.SETRANGE("Document No.", "No.");
        SeminarRegLine.SETRANGE(Registered, TRUE);
        if SeminarRegLine.FIND('-') then
            ERROR(
            Text001,
            SeminarRegLine.TABLECAPTION,
            SeminarRegLine.FIELDCAPTION(Registered),
            TRUE);
        SeminarRegLine.SETRANGE(Registered);
        SeminarRegLine.DELETEALL(TRUE);

        SeminarCharge.RESET;
        SeminarCharge.SETRANGE("Document No.", "No.");
        if not SeminarCharge.ISEMPTY then
            ERROR(Text006, SeminarCharge.TABLECAPTION);

        SeminarCommentLine.RESET;
        SeminarCommentLine.SETRANGE("Table Name",
        SeminarCommentLine."Table Name"::"Seminar 
 Registration");
 SeminarCommentLine.SETRANGE("No.", "No.");
        SeminarCommentLine.DELETEALL;


    end;

    trigger OnRename()
    begin

    end;

    local procedure InitRecord()

    begin
        if "Posting Date" = 0D then
            "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        SeminarSetup.GET;
        NoSeriesMgt.SetDefaultSeries("Posting No. Series",
        SeminarSetup."Posted Seminar Reg. Nos.");
    end;

    procedure AssistEdit(OldSeminarRegHeader: Record “CSD 
Seminar Reg. Header”): Boolean;
    begin
        with SeminarRegHeader do begin
            SeminarRegHeader := Rec;
            SeminarSetup.GET;
            SeminarSetup.TestField("Seminar Registration Nos.");
            if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Registration Nos.", OldSeminarRegHeader."No. Series", "No. Series") then begin
                SeminarSetup.GET;
                SeminarSetup.TestField("Seminar Registration Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := SeminarRegHeader;
                exit(True);
            end;
        end;
    end;
}