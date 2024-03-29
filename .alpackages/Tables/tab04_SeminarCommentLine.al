/// <summary>
/// Table CSD Seminar Comment Line (ID 50104).
/// </summary>
table 50104 "CSD Seminar Comment Line"
//CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 5 - Lab 2-1
// Chapter 7 - Lab 3-2
{
    Caption = 'Seminar Comment Line';
    LookupPageId = "CSD Seminar Comment List";
    DrillDownPageId = "CSD Seminar Comment List";

    fields
    {
        field(10; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionMembers = "Seminar","Seminar Registration","Posted Seminar Registration";
        }
        field(20; "Document line No."; Integer)
        {
            Caption = 'Document Line No';
        }
        field(30; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if ("Table Name" = CONST(Seminar)) "CSD Seminar"
            else
            if ("Table Name" = const("Seminar Registration")) "Seminar Registration Header"
            else
            if ("Table Name" = const("Posted Seminar Registration")) "CSD Posted Seminar Reg. Header";

        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; Date; Date)
        {
            caption = 'Date';
        }
        field(60; code; code[10])
        {
            Caption = 'Code';
        }
        field(70; Comment; text[80])
        {
            Caption = 'Comment';
        }

    }

    keys
    {
        key(Pk; "Table Name", "Document Line No.", "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// SetupNewLine.
    /// </summary>
    procedure SetupNewLine()
    //new procedure
    var
        SeminarCommentLine: Record "CSD Seminar Comment Line";
    begin
        SeminarCommentLine.SetRange("Table Name", "Table Name");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.SetRange("Document Line No.", "Document Line No.");
        SeminarCommentLine.SetRange("Date", WorkDate);
        if SeminarCommentLine.IsEmpty then
            Date := WorkDate;

    end;
}