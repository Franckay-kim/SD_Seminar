/// <summary>
/// Codeunit CSD Seminar Jnl.-Check Line (ID 50131).
/// </summary>
codeunit 50131 "CSD Seminar Jnl.-Check Line"
//CSD1.00 - 2023-06-09 - D. E. Veloper
// Chapter 7 - Lab 2-1
{
    TableNo = "CSD Seminar Journal Line";


    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        GlSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        ClosingDateTxt: Label 'cannot be a closing date.';
        PostingDateTxt: label 'is not within your range of allowed posting dates.';

    /// <summary>
    /// RunCheck.
    /// </summary>
    /// <param name="SemJnLine">VAR Record "CSD Seminar Journal Line".</param>
    procedure RunCheck(var SemJnLine: Record "CSD Seminar Journal Line");
    var
        myInt: Integer;

    begin
        //with SemJnLine do begin
        if SemJnLine.EmptyLine then
            exit;

        SemJnLine.TestField("Posting Date");
        SemJnLine.TestField("Instructor Resource No.");
        SemJnLine.TestField("Seminar No.");

        case SemJnLine."Charge Type" of
            SemJnLine."Charge Type"::Instructor:
                SemJnLine.TestField("Instructor Resource No.");
            SemJnLine."Charge Type"::Room:
                SemJnLine.TestField("Room Resource No.");
            SemJnLine."Charge Type"::Participant:
                SemJnLine.TestField("Participant Contact No.");
        end;

        if SemJnLine.Chargeable then
            SemJnLine.TestField("Bill-to Customer No.");

        if SemJnLine."Posting Date" = ClosingDate(SemJnLine."Posting Date") then
            SemJnLine.FieldError("Posting Date", ClosingDateTxt);

        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            if UserId <> '' then
                if UserSetup.GET(UserId) then begin
                    AllowPostingFrom := UserSetup."Allow Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                end;
            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D)
            then begin
                GLSetup.GET;
                AllowPostingFrom := GLSetup."Allow Posting From";
                AllowPostingTo := GLSetup."Allow Posting To";
            end;
            if AllowPostingTo = 0D then
                AllowPostingTo := DMY2Date(31, 12, 9999);
        end;
        if (SemJnLine."Posting Date" < AllowPostingFrom) OR
        (SemJnLine."Posting Date" > AllowPostingTo) then
            SemJnLine.FieldError("Posting Date", PostingDateTxt);

        if (SemJnLine."Document Date" <> 0D) then
            if (SemJnLine."Document Date" = CLOSINGDATE(SemJnLine."Document Date")) then
                SemJnLine.FIELDERROR("Document Date", PostingDateTxt);

    end;

    //end;
}