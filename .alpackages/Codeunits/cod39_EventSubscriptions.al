/// <summary>
/// Codeunit CSD EventSubscriptions (ID 50139).
/// </summary>
codeunit 50139 "CSD EventSubscriptions"
// CSD1.00 - 2023-06-12 - D. E. Veloper
// Chapter 7 - Lab 4-4

{
    [EventSubscriber(ObjectType::Codeunit, 212, 'OnBeforeResLedgEntryInsert', '', true, true)]
    local procedure PostResJnlLineOnBeforeResLedgEntryInsert(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line")

    begin
        ResLedgerEntry."CSD Seminar No." := ResJournalLine."CSD Seminar No.";
        ResLedgerEntry."CSD Seminar Registration No." := ResJournalLine."CSD Seminar Registration No.";
    end;

    [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateFindRecords', '', true, true)]
    local procedure ExtendNavigateOnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text);

    var
        SeminarLedgerEntry: record "CSD Seminar Ledger Entry";
        PostedSeminarRegHeader: record "CSD Posted Seminar Reg. Header";
        DocNoOfRecords: Integer;
        NextEntryNo: Integer;

    begin
        if PostedSeminarRegHeader.ReadPermission then begin
            PostedSeminarRegHeader.Reset;
            PostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
            PostedSeminarRegHeader.SetFilter("Posting Date",
            PostingDateFilter);
            DocNoOfRecords := PostedSeminarRegHeader.Count;

            // With DocumentEntry do begin
            if DocNoOfRecords = 0 then
                exit;
            if DocumentEntry.FindLast then
                NextEntryNo := DocumentEntry."Entry No." + 1
            else
                NextEntryNo := 1;
            DocumentEntry.Init;
            DocumentEntry."Entry No." := NextEntryNo;
            DocumentEntry."Table ID" := Database::"CSD Posted Seminar Reg. Header";
            DocumentEntry."Document Type" := 0;
            DocumentEntry."Table Name" := COPYSTR(PostedSeminarRegHeader.
            TableCaption, 1, MAXSTRLEN(DocumentEntry."Table Name"));
            DocumentEntry."No. of Records" := DocNoOfRecords;
            DocumentEntry.Insert;
            //end;
        end;

        if SeminarLedgerEntry.ReadPermission then begin
            SeminarLedgerEntry.Reset;
            SeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
            SeminarLedgerEntry.SetFilter("Posting Date",
            PostingDateFilter);
            DocNoOfRecords := SeminarLedgerEntry.Count;

            //With DocumentEntry do begin
            if DocNoOfRecords = 0 then
                exit;
            if DocumentEntry.FindLast then
                NextEntryNo := DocumentEntry."Entry No." + 1
            else
                NextEntryNo := 1;
            DocumentEntry.Init;
            DocumentEntry."Entry No." := NextEntryNo;
            DocumentEntry."Table ID" := Database::"CSD Seminar Ledger Entry";
            DocumentEntry."Document Type" := 0;
            DocumentEntry."Table Name" := COPYSTR(SeminarLedgerEntry.
            TableCaption, 1, MAXSTRLEN(DocumentEntry."Table Name"));
            DocumentEntry."No. of Records" := DocNoOfRecords;
            DocumentEntry.Insert;
            //end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateShowRecords', '', true, true)]
    local procedure ExtendNavigateOnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean);

    var
        SeminarLedgerEntry: record "CSD Seminar Ledger Entry";
        PostedSeminarRegHeader: record "CSD Posted Seminar Reg. Header";
    begin
        case TableID of
            Database::"CSD Posted Seminar Reg. Header":
                begin
                    PostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
                    PostedSeminarRegHeader.SetFilter("Posting Date",
                    PostingDateFilter);
                    Page.Run(0, PostedSeminarRegHeader);
                end;
            Database::"CSD Seminar Ledger Entry":
                begin
                    SeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
                    SeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
                    Page.Run(0, SeminarLedgerEntry);
                end;
        end;
    end;
}