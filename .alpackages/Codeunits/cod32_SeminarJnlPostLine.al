codeunit 50132 "CSD Seminar Jnl.-Post Line"
// CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 7 - Lab 2-8

{
    TableNo = "CSD Seminar Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        SeminarJnlLine: Record "CSD Seminar Journal Line";
        SeminarLedgerEntry: Record "CSD Seminar Ledger Entry";
        SeminarRegister: Record "CSD Seminar Register";
        SeminarJnlCheckLine: Codeunit "CSD Seminar Jnl.-Check Line";
        NextEntryNo: Integer;

    procedure RunWithCheck(var SeminarJnLine2: Record "CSD Seminar Journal Line");

    var
        myInt: Integer;
    begin
        with SeminarJnLine2 do begin
            SeminarJnlLine := SeminarJnLine2;
            Code();
            SeminarJnLine2 := SeminarJnlLine;
        end;
    end;

    local procedure Code()
    var
        myInt: Integer;
        CheckLine: Codeunit "CSD Seminar Jnl.-Check Line";
    begin
        with SeminarJnlLine do begin
            if EmptyLine then
                exit;

            //run(CheckLine.RunCheck());

            if NextEntryNo = 0 then begin
                SeminarLedgerEntry.LockTable;
                if SeminarLedgerEntry.FindLast then
                    NextEntryNo := SeminarLedgerEntry."Entry No.";
                NextEntryNo := NextEntryNo + 1;
            end;

            if "Posting Date" = 0D then
                "Document Date" := "Posting Date";

            if SeminarRegister."No." = 0 then begin
                SeminarRegister.LockTable;
                if (not SeminarRegister.FindLast) or
                (SeminarRegister."To Entry No." <> 0) then begin
                    SeminarRegister.INIT;
                    SeminarRegister."No." := SeminarRegister."No." + 1;
                    SeminarRegister."From Entry No." := NextEntryNo;
                    SeminarRegister."To Entry No." := NextEntryNo;
                    SeminarRegister."Creation Date" := TODAY;
                    SeminarRegister."Source Code" := "Source Code";
                    SeminarRegister."Journal Batch Name" :=
                    "Journal Batch Name";
                    SeminarRegister."User ID" := USERID;
                    SeminarRegister.Insert;
                end;
                SeminarRegister."To Entry No." := NextEntryNo;
                SeminarRegister.Modify;
            end;

            SeminarLedgerEntry.INIT;
            SeminarLedgerEntry."Seminar No." := "Seminar No.";
            SeminarLedgerEntry."Posting Date" := "Posting Date";
            SeminarLedgerEntry."Document Date" := "Document Date";
            SeminarLedgerEntry."Bill-to Customer No." :=
            "Bill-to Customer No.";
            SeminarLedgerEntry."Charge Type" := "Charge Type";
            SeminarLedgerEntry.Quantity := Quantity;
            SeminarLedgerEntry."Participant Contact No." :=
            "Participant Contact No.";
            SeminarLedgerEntry.Chargeable := Chargeable;
            SeminarLedgerEntry."Room Resource No." :=
            "Room Resource No.";
            SeminarLedgerEntry."Instructor Resource No." :=
            "Instructor Resource No.";
            SeminarLedgerEntry."Journal Batch Name" := "Journal Batch Name";
            SeminarLedgerEntry."Source Code" := "Source Code";
            SeminarLedgerEntry."Reason Code" := "Reason Code";
            SeminarLedgerEntry."Entry No." := NextEntryNo;
            NextEntryNo += 1;
            SeminarLedgerEntry.Insert;



        end;
    end;

}