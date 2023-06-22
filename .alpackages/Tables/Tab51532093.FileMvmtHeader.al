/// <summary>
/// Table File Mvmt Header (ID 51532093).
/// </summary>
table 51532093 "File Mvmt Header"
{
    Caption = 'File Mvmt Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "File No."; Code[20])
        {
            Caption = 'File No.';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                if "File No." <> xRec."File No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."File Nos.");
                    "No. Series" := '';
                    "File No." := UpperCase("File No.");
                end;
            end;
        }
        field(2; "Related Table"; Integer)
        {
            Caption = 'Related Table';
            DataClassification = ToBeClassified;
        }
        field(3; "Document No."; Code[30])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(4; "File Location"; Code[50])
        {
            Caption = 'File Location';
            FieldClass = FlowField;
            CalcFormula = lookup("File Mvmt Lines".To where("File No." = field("File No.")));

        }
        field(5; "Created By"; Code[30])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(8; "DateAndTime Created"; DateTime)
        {

        }
        field(6; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(7; To; Code[30])
        {

        }
    }
    keys
    {
        key(PK; "File No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()

    begin
        if "File No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."File Nos.");
            NoSeriesMgt.InitSeries(SeriesSetup."File Nos.", xRec."No. Series", 0D, "File No.", "No. Series");
        end;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    /// <summary>
    /// InitFileLines.
    /// </summary>
    /// <param name="TableID">Integer.</param>
    /// <param name="DocNo">Code[30].</param>
    /*procedure InitFileLines(TableID: Integer; DocNo: Code[30])
    FileMvmtLines: Record "File Mvmt Lines";
    begin
        Init();
        "File No." := '';
        "Related Table" := TableID;
        "Document No." := DocNo;
        "File Location" := UserId;
        "Created By" := UserId;
        "DateAndTime Created" := CurrentDateTime;
        Insert(True);

        FileMvmtLines.Init();
        FileMvmtLines."File No." := Rec."File No.";
        FileMvmtLines."Entry No." := 0;
        FileMvmtLines.From := UserId;
        FileMvmtLines."To" := UserId;
        FileMvmtLines."Date Created" := WorkDate();
        FileMvmtLines."Date Moved" := WorkDate();
        FileMvmtLines."Time Created" := Time;
        FileMvmtLines."Time Moved" := Time;
        FileMvmtLines.Status := FileMvmtLines.Status::Approved;
        FileMvmtLines.Insert(true);
    end; */

    /// <summary>
    /// SendFile.
    /// </summary>
    /// <param name="ToWho">Code[30].</param>
    /* procedure SendFile(ToWho: Code[30])
    var
        FileMvmtLines: Record "File Mvmt Lines";
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
    begin
        FileMvmtLines.Reset();
        FileMvmtLines.Init();
        FileMvmtLines."File No." := Rec."File No.";
        FileMvmtLines."Entry No." := 0;
        FileMvmtLines.From := UserId;
        FileMvmtLines."To" := ToWho;
        FileMvmtLines."Date Created" := WorkDate();
        // FileMvmtLines."Date Moved" := WorkDate();
        FileMvmtLines."Time Created" := Time;
        //FileMvmtLines."Time Moved" := Time;
        FileMvmtLines.Status := FileMvmtLines.Status::Open;
        FileMvmtLines.Insert(true);

        VarVariant := FileMvmtLines;
        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then begin
            CustomApprovals.OnSendDocForApproval(VarVariant);
        end;

    end; */
}
