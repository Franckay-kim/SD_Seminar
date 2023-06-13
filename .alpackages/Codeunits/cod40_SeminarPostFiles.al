codeunit 50140 "CSD Seminar Post Files"//CSD1.00 - 2023-06-12 - D. E. Veloper
// Chapter 7 - Lab 4-7
{
    trigger OnRun()
    begin
        ClearAll;
        //SeminarRegHeader := Rec;
        with SeminarRegHeader do begin
            TestField("Posting Date");
            TestField("Document Date");
            TestField("Seminar No.");
            TestField(Duration);
            TestField("Instructor Resource No.");
            TestField("Room Resource No.");
            TestField(Status, Status::Closed);
            SeminarRegLine.Reset;
            SeminarRegLine.SetRange("Document No.", "No.");
            if SeminarRegLine.IsEmpty then
                Error('Text001');
            //open a dialog box to showthe posting progress
            //Window.Update(1, StrSubstNo('Text004', "No.", PstdSeminarRegHeader."No."));


            if SeminarRegHeader."Posting No." = '' then begin
                TestField("Posting No. Series");
                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", true);
                modify;
                Commit;
            end;
            SeminarRegLine.LockTable;

            //assign the source code variable from the seminar field of the source code setup table
            SourceCodeSetup.Get;
            SourceCode := SourceCodeSetup."CSD Seminar";
            // initialize and insert a new posted registration line by transferring the fields from the registration line, and assigning the appropriate Document No. value.
            PstdSeminarRegHeader.Init;
            PstdSeminarRegHeader.TransferFields(SeminarRegHeader);
            PstdSeminarRegHeader."No." := "Posting No.";
            PstdSeminarRegHeader."No. Series" := "Posting No. Series";
            PstdSeminarRegHeader."Source Code" := SourceCode;
            PstdSeminarRegHeader."User ID" := UserId;
            PstdSeminarRegHeader.Insert;

            //copy the comment lines and charges from the reg header to the posted reg header 
            CopyCommentLines(
                SeminarCommentLine."Table Name"::"Seminar Registration",
                SeminarCommentLine."Table Name"::"Posted Seminar Registration", "No.", PstdSeminarRegHeader."No.");
            CopyCharges("No.", PstdSeminarRegHeader."No.");

            //set the line count variable to zero.
            //LineCount := 0;
            SeminarRegLine.Reset;
            SeminarRegLine.SetRange("Document No.", "No.");
            if SeminarRegLine.FindSet then begin
                repeat
                until SeminarRegLine.Next = 0;
            end;

            // Window.Update(2, LineCount);
            SeminarRegLine.TestField("Bill-to Customer No.");
            SeminarRegLine.TestField("Participant Contact No.");
            if not SeminarRegLine."To Invoice" then begin
                SeminarRegLine."Seminar Price" := 0;
                SeminarRegLine."Line Discount %" := 0;
                SeminarRegLine."Line Discount Amount" := 0;
                SeminarRegLine.Amount := 0;
            end;
            // Post seminar entry 
            PostSeminarJnlLine(2); // Participant
            // Insert posted seminar registration line 
            PstdSeminarRegLine.Init;
            PstdSeminarRegLine.TransferFields(SeminarRegLine);
            PstdSeminarRegLine."Document No." :=
            PstdSeminarRegHeader."No.";
            PstdSeminarRegLine.Insert;


            // Post charges to seminar ledger 
            PostCharges;
            // Post instructor to seminar ledger 
            PostSeminarJnlLine(0); // Instructor
            // Post seminar room to seminar ledger 
            PostSeminarJnlLine(1); // Room

            //Delete the registration header, lines, comments and charges.
            Delete(true);
        end;
        //Rec := SeminarRegHeader;
    end;


    var
        SeminarCommentLine: Record "CSD Seminar Comment Line";
        SeminarCommentLine2: Record "CSD Seminar Comment Line";
        SeminarCharge: Record "CSD Seminar Charge";
        PstdSeminarCharge: Record " CSD Posted Seminar Charge";
        SeminarRegHeader: Record "Seminar Registration Header";
        ResJnlLine: Record "Res. Journal Line";
        PstdSeminarRegHeader: Record "CSD Posted Seminar Reg. Header";
        //ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ResLedgEntry: Record "Res. Ledger Entry";
        SeminarJnlLine: Record "CSD Seminar Journal Line";
        SeminarRegLine: Record "CSD Seminar Registration Line";
        SeminarJnlPostLine: Codeunit "CSD Seminar Jnl.-Post Line";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        SourceCodeSetup: Record "Source Code Setup";
        PstdSeminarRegLine: Record "CSD Posted Seminar Reg. Line";

    local procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]);

    begin
        SeminarCommentLine.Reset;
        SeminarCommentLine.SetRange("Table Name",
        FromDocumentType);
        SeminarCommentLine.SetRange("No.", FromNumber);
        if SeminarCommentLine.FindSet then
            repeat
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Table Name" := ToDocumentType;
                SeminarCommentLine2."No." := ToNumber;
                SeminarCommentLine2.Insert;
            until SeminarCommentLine.Next = 0;
    end;

    local procedure CopyCharges(FromNumber: Code[20]; ToNumber: Code[20]);

    begin
        SeminarCharge.Reset;
        SeminarCharge.SetRange("Document No.", FromNumber);
        if SeminarCharge.FindSet then
            repeat
                PstdSeminarCharge.TransferFields(SeminarCharge);
                PstdSeminarCharge."Document No." := ToNumber;
                PstdSeminarCharge.Insert;
            until SeminarCharge.Next = 0;
    end;

    local procedure PostResJnlLine(Resource: Record Resource): Integer;

    begin
        with SeminarRegHeader do begin
            ResJnlLine.Init;
            ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
            ResJnlLine."Document No." := PstdSeminarRegHeader."No.";
            ResJnlLine."Resource No." := Resource."No.";

            ResJnlLine."Posting Date" := "Posting Date";
            ResJnlLine."Reason Code" := "Reason Code";
            ResJnlLine.Description := "Seminar Name";
            ResJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ResJnlLine."Posting No. Series" := "Posting No. Series";
            ResJnlLine."Source Code" := SourceCode;
            ResJnlLine."Resource No." := Resource."No.";
            ResJnlLine."Unit of Measure Code" :=
            Resource."Base Unit of Measure";
            ResJnlLine."Unit Cost" := Resource."Unit Cost";
            ResJnlLine."Qty. per Unit of Measure" := 1;

            ResJnlLine.Quantity := Duration * Resource."CSD Quantity Per Day";
            ResJnlLine."Total Cost" := ResJnlLine."Unit Cost" *
            ResJnlLine.Quantity;
            ResJnlLine."CSD Seminar No." := "Seminar No.";
            ResJnlLine."CSD Seminar Registration No." :=
            PstdSeminarRegHeader."No.";
            // ResJnlPostLine.RunWithCheck(ResJnlLine);
        end;

        ResLedgEntry.FindLast;
        exit(ResLedgEntry."Entry No.");
    end;

    local procedure PostSeminarJnlLine(ChargeType: Option Instructor,Room,Participant,Charge);

    begin
        with SeminarRegHeader do begin
            SeminarJnlLine.init;
            SeminarJnlLine."Seminar No." := "Seminar No.";
            SeminarJnlLine."Posting Date" := "Posting Date";
            SeminarJnlLine."Document Date" := "Document Date";
            SeminarJnlLine."Document No." := PstdSeminarRegHeader."No.";
            SeminarJnlLine."Charge Type" := ChargeType;
            SeminarJnlLine."Instructor Resource No." :=
            "Instructor Resource No.";
            SeminarJnlLine."Starting Date" := "Starting Date";
            SeminarJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
            SeminarJnlLine."Room Resource No." := "Room Resource No.";
            SeminarJnlLine."Source Type" := SeminarJnlLine."Source Type"::Seminar;
            SeminarJnlLine."Source No." := "Seminar No.";
            SeminarJnlLine."Source Code" := SourceCode;
            SeminarJnlLine."Reason Code" := "Reason Code";
            SeminarJnlLine."Posting No. Series" := "Posting No. Series";

            case ChargeType of
                ChargeType::Instructor:
                    begin
                        //Instructor.get("Instructor Resource No.");
                        //SeminarJnlLine.Description := Instructor.Name;
                        SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                        SeminarJnlLine.Chargeable := false;
                        SeminarJnlLine.Quantity := Duration;
                        //SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Instructor);
                    end;
                ChargeType::Room:
                    begin
                        //Room.GET("Room Resource No.");
                        //SeminarJnlLine.Description := Room.Name;
                        SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                        SeminarJnlLine.Chargeable := false;
                        SeminarJnlLine.Quantity := Duration;
                        // Post to resource ledger
                        //SeminarJnlLine."Res. Ledger Entry No." :=
                        //PostResJnlLine(Room);
                    end;
                ChargeType::Participant:
                    begin
                        SeminarJnlLine."Bill-to Customer No." := SeminarRegLine."Bill-to Customer No.";
                        SeminarJnlLine."Participant Contact No." := SeminarRegLine."Participant Contact No.";
                        SeminarJnlLine."Participant Name" := SeminarRegLine."Participant Name";
                        SeminarJnlLine.Description := SeminarRegLine."Participant Name";
                        SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                        SeminarJnlLine.Chargeable := SeminarRegLine."To Invoice";
                        SeminarJnlLine.Quantity := 1;
                        SeminarJnlLine."Unit Price" := SeminarRegLine.Amount;
                        SeminarJnlLine."Total Price" := SeminarRegLine.Amount;
                    end;
                ChargeType::Charge:
                    begin
                        SeminarJnlLine.Description := SeminarCharge.Description;
                        SeminarJnlLine."Bill-to Customer No." := SeminarCharge."Bill-to Customer No.";
                        SeminarJnlLine.Type := SeminarCharge.Type;
                        SeminarJnlLine.Quantity := SeminarCharge.Quantity;
                        SeminarJnlLine."Unit Price" := SeminarCharge."Unit Price";
                        SeminarJnlLine."Total Price" := SeminarCharge."Total Price";
                        SeminarJnlLine.Chargeable := SeminarCharge."To Invoice";

                    end;
            end;
            SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);

        end;
    end;

    local procedure PostCharges();
    begin
        SeminarCharge.reset;
        SeminarCharge.SetRange("Document No.", SeminarRegHeader."No.");
        if SeminarCharge.FindSet(false, false) then
            repeat
                PostSeminarJnlLine(3); // Charge 
            until SeminarCharge.next = 0;
    end;


}