/// <summary>
/// Table Loan Write Off Header (ID 51532091).
/// </summary>
table 51532091 "Loan Write Off Header"
{
    Caption = 'Loan Write Off Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Loan Write Off Nos.");
                    "No. Series" := '';
                    "No." := UpperCase("No.");
                end;
            end;
        }
        field(2; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = ToBeClassified;
            TableRelation = Members."No.";

            trigger OnValidate()
            var
                Members: Record Members;
            begin
                GenSetup.Get();
                GenSetup.TestField("Loan Provisioning Account");
                "Write Off GL" := GenSetup."Loan Provisioning Account";
                Members.Reset();
                Members.SetRange("No.", "Member No.");
                if Members.FindFirst() then
                    "Member Name" := Members.Name;
            end;
        }
        field(3; "Loan No."; Code[30])
        {
            Caption = 'Loan No.';
            TableRelation = Loans."Loan No." where("Member No." = field("Member No."));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Loans: Record Loans;
            begin
                Loans.Reset();
                Loans.SetRange("Loan No.", "Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Balance", "Outstanding Interest");
                    "Outstanding Balance" := Loans."Outstanding Balance";
                    "Outstanding Interest" := Loans."Outstanding Interest";
                end;
            end;
        }
        field(4; "Write Off GL"; Code[20])
        {
            Caption = 'Write Off GL';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(5; "Outstanding Balance"; Decimal)
        {
            Caption = 'Outstanding Balance';
            DataClassification = ToBeClassified;
        }
        field(6; "Outstanding Interest"; Decimal)
        {
            Caption = 'Outstanding Interest';
            DataClassification = ToBeClassified;
        }
        field(9; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(10; "Member Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,Pending,Approved,Rejected;
            DataClassification = ToBeClassified;
            Editable = false;
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
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Loan Write Off Nos.");
            NoSeriesMgt.InitSeries(SeriesSetup."Loan Write Off Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenSetup: Record "General Set-Up";

    /// <summary>
    /// PostWriteOff.
    /// </summary>
    procedure PostWriteOff()
    var
        Temp: Record "Banking User Template";
        USetup: Record "User Setup";
        //JournalPosting: Codeunit "Journal Posting";
        AccType: Enum "Gen. Journal Account Type";
        Loans: Record Loans;
        TransType: Option " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Ledger Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid";

    begin
        TestField(Posted, false);
        TestField(Status, Status::Approved);
        Temp.Get(UserId);
        USetup.Get(UserId);
        Temp.TestField("Loans Template");
        Temp.TestField("Loans Batch");
        Loans.Get("Loan No.");
        Loans.CalcFields("Outstanding Balance", "Outstanding Interest");
        //clear lines
        /* JournalPosting.ClearJournalLines(Temp."Loans Template", Temp."Loans Batch");

        JournalPosting.PostJournal(Temp."Loans Template", Temp."Loans Batch", 1000, AccType::"G/L Account", "No."
        , 'Loan WriteOFF' + "Loan No.", (Loans."Outstanding Balance" + Loans."Outstanding Interest"), "Write Off GL", Today
        , AccType::"G/L Account", '', "Loan No.", USetup."Global Dimension 1 Code", USetup."Global Dimension 2 Code", TransType::" ", '', '', '', 0, '', 0, false);
        //loan outstanding interest 
        JournalPosting.PostJournal(Temp."Loans Template", Temp."Loans Batch", 2000, AccType::Credit, "No."
        , 'Loan WriteOFF' + "Loan No.", -(Loans."Outstanding Interest"), Loans."Loan Account", Today
        , AccType::"G/L Account", '', "Loan No.", USetup."Global Dimension 1 Code", USetup."Global Dimension 2 Code", TransType::"Interest Paid", "Loan No.", '', '', 0, '', 0, false);
        //loan outstanding balance
        JournalPosting.PostJournal(Temp."Loans Template", Temp."Loans Batch", 3000, AccType::Credit, "No."
        , 'Loan WriteOFF' + "Loan No.", -(Loans."Outstanding Balance"), Loans."Loan Account", Today
        , AccType::"G/L Account", '', "Loan No.", USetup."Global Dimension 1 Code", USetup."Global Dimension 2 Code", TransType::Repayment, "Loan No.", '', '', 0, '', 0, false);

        //post entries
        JournalPosting.CompletePosting(Temp."Loans Template", Temp."Loans Batch");
        Posted := true;
        Modify(); */
    end;
}
