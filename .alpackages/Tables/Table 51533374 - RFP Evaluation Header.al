table 51533374 "RFP Evaluation Header"
{
    // version RFP


    fields
    {
        field(1; "Code"; Code[20])
        {

            trigger OnValidate();
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
                PurchSetup: Record "Purchases & Payables Setup";
            begin
                IF Code <> xRec.Code THEN BEGIN
                    PurchSetup.GET;
                    //NoSeriesMgt.TestManual(PurchSetup."RFP Evaluation No");
                    //"No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Evaluation  Period"; Code[20])
        {
            //TableRelation = "Evaluation Year".Code;
        }
        field(50008; "Quote No"; Code[20])
        {
            /* TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote),
                                                          "RFQ/Tender No" = FIELD("RFQ No")); */

            trigger OnValidate()
            var
                PurchLine: Record "RFP Evaluation Lines";
                RFQ: Record "Purchase Header";
            begin

                PurchLine.Reset;
                PurchLine.SetRange(PurchLine.Code, Code);
                PurchLine.DeleteAll;

                RFQ.Reset;
                RFQ.SetRange(RFQ."No.", "Quote No");
                if RFQ.Find('-') then begin
                    /*repeat
                        PurchLine.Init;
                        PurchLine.Code := Code;
                        PurchLine."Document No." := "No.";
                        PurchLine."Line No." := RFQ."Line No.";
#pragma warning disable AL0603
                        PurchLine.Type := RFQ.Type;
#pragma warning restore AL0603
                        PurchLine."No." := RFQ."No.";
                        //PurchLine."Expense Code":=RFQ."Expense Code";
                        PurchLine.Validate("No.");
                        PurchLine."Location Code" := RFQ."Location Code";
                        PurchLine.Validate("Location Code");
                        PurchLine."Unit of Measure" := RFQ."Unit of Measure";
                        PurchLine.Validate("Unit of Measure");
                        PurchLine.Quantity := RFQ.Quantity;
                        PurchLine.Validate(Quantity);
                        PurchLine."Direct Unit Cost" := RFQ."Direct Unit Cost";
                        PurchLine.Validate("Direct Unit Cost");
                        PurchLine.Amount := RFQ.Amount;
                        PurchLine.Insert;
                    until RFQ.Next = 0;*/
                end;
            end;
        }
        field(50009; "Vendor Type"; Option)
        {
            OptionMembers = " ",Vendor,Supplier;

            trigger OnValidate();
            begin
                "Vendor No." := '';
                "Quote No" := '';
                "Vendor Name" := '';
            end;
        }
        field(4; "Vendor No."; Code[20])
        {
            TableRelation = IF ("Vendor Type" = CONST(Vendor)) Vendor."No." ELSE
            IF ("Vendor Type" = CONST(Supplier)) "E-Tender Company Information"."Primary Key";

            trigger OnValidate();
            var
                ETenderCompanyInformation: Record "E-Tender Company Information";
                PurchaseHeader: Record "Purchase Header";
                Vend: Record "E-Tender Company Information";
                Vendor: Record Vendor;
            begin

                IF "Vendor Type" = "Vendor Type"::Supplier THEN BEGIN
                    ETenderCompanyInformation.RESET;
                    ETenderCompanyInformation.SETRANGE("Primary Key", "Vendor No.");
                    IF ETenderCompanyInformation.FIND('-') THEN
                        "Vendor Name" := ETenderCompanyInformation.Name;
                    PurchaseHeader.RESET;
                    //PurchaseHeader.SETRANGE("Supplier No", "Vendor No.");
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    IF PurchaseHeader.FIND('-') THEN
                        "Quote No" := PurchaseHeader."No.";
                END;

                IF "Vendor Type" = "Vendor Type"::Vendor THEN BEGIN
                    PurchaseHeader.RESET;
                    //PurchaseHeader.SETRANGE("RFQ No.", "RFQ No");
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    IF PurchaseHeader.FIND('-') THEN
                        "Quote No" := PurchaseHeader."No.";
                END;
                PurchaseHeader.RESET;
                PurchaseHeader.SETRANGE("Buy-from Vendor No.", "Vendor No.");
                //PurchaseHeader.SETRANGE("RFQ No.", Rec."RFQ No");
                PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                IF PurchaseHeader.FINDFIRST THEN "Quote No" := PurchaseHeader."No.";

                CASE "Evaluation Type" OF
                    "Evaluation Type"::RFP, "Evaluation Type"::RFQ:
                        BEGIN
                            IF "Vendor Type" = "Vendor Type"::Supplier THEN BEGIN
                                Vend.RESET;
                                Vend.SETRANGE(Vend."Primary Key", "Vendor No.");
                                IF Vend.FIND('-') THEN
                                    "Vendor Name" := Vend.Name;
                                //"Vendor Category" := Vend."Vendor Category";
                            END ELSE
                                IF "Vendor Type" = "Vendor Type"::Vendor THEN
                                    Vendor.RESET;
                            Vendor.SETRANGE("No.", "Vendor No.");
                            IF Vendor.FINDFIRST THEN
                                "Vendor Name" := Vendor.Name;
                            //"Vendor Category":=Vendor."Vendor Category";
                        END;

                END;
                IF "Evaluation Type" = "Evaluation Type"::"Open Tender" THEN BEGIN
                    IF "Vendor Type" = "Vendor Type"::Vendor THEN BEGIN
                        Vendor.RESET;
                        Vendor.SETRANGE("No.", "Vendor No.");
                        IF Vendor.FINDFIRST THEN
                            "Vendor Name" := Vendor.Name;
                    END ELSE
                        IF "Vendor Type" = "Vendor Type"::Supplier THEN BEGIN
                            Vend.RESET;
                            Vend.SETRANGE(Vend."Primary Key", "Vendor No.");
                            IF Vend.FIND('-') THEN
                                "Vendor Name" := Vend.Name;
                            //"Vendor Category" := Vend."Vendor Category";
                        END;
                END;



                MESSAGE('Process Complete');
            end;
        }
        field(5; "Total Expected Value"; Decimal)
        {
        }
        field(6; "Overall Comment"; Option)
        {
            OptionMembers = " ",Recommended,"Not Recommended";
        }
        field(7; "Total Actuals Value"; Decimal)
        {
            CalcFormula = Sum("RFP Evaluation Lines"."Actuals Scores" WHERE(Code = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(8; "Vendor Name"; Text[100])
        {
        }
        field(50000; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50001; "Evaluation Start Period"; Date)
        {
        }
        field(50002; "Evaluation  End Period"; Date)
        {
        }
        field(50003; "Evaluation Type"; Option)
        {
            OptionCaption = '" ,RFQ,RFP,Open Tender"';
            OptionMembers = " ",RFQ,RFP,"Open Tender";

            trigger OnValidate();
            begin
                "RFQ No" := '';
                "Vendor No." := '';
                "Evaluation Start Period" := 0D;
                "Evaluation  End Period" := 0D;
            end;
        }
        field(50004; "Criteria Code"; Code[20])
        {
            TableRelation = "RFP Evaluation Criteria".Code;
        }
        field(50005; Status; Option)
        {
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(50006; "Vendor Category"; Code[50])
        {
            //TableRelation = "Vendor Categories";

            trigger OnValidate();
            var
                PurchaseHeader: Record "Purchase Header";
            begin


            end;
        }
        field(50007; "RFQ No"; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No.";

            trigger OnValidate();
            begin
                RFPEvaluationHeader.RESET;
                RFPEvaluationHeader.SETFILTER(RFPEvaluationHeader."RFQ No", '%1', Rec."RFQ No");
                RFPEvaluationHeader.SETRANGE(RFPEvaluationHeader."Vendor No.", "Vendor No.");
                RFPEvaluationHeader.SETRANGE(RFPEvaluationHeader."User Id", Rec."User Id");
                IF RFPEvaluationHeader.FIND('-') THEN ERROR(Txt001);

                PurchaseQuoteHeader.RESET;
                PurchaseQuoteHeader.SETRANGE("No.", "RFQ No");
                IF PurchaseQuoteHeader.FIND('-') THEN BEGIN
                    Closing := DT2DATE(PurchaseQuoteHeader."Expected Closing Date");
                    IF "Evaluation Type" = "Evaluation Type"::RFP THEN
                        IF TODAY - Closing > 21 THEN
                            ERROR('Evaluation Period has ended') ELSE
                            IF TODAY - Closing > 30 THEN ERROR('Evaluation Period has ended');

                    "Evaluation Start Period" := Closing;
                    IF "Evaluation Type" = "Evaluation Type"::RFP THEN
                        "Evaluation  End Period" := CALCDATE('21D', Closing) ELSE
                        "Evaluation  End Period" := CALCDATE('30D', Closing);
                    MODIFY;
                END;
                "Evaluation Start Period" := Closing;
                MODIFY;

                IF EvaluationParameterLine.FINDLAST THEN
                    lastno := EvaluationParameterLine."Line No.";

                EvalCriteria.RESET;
                EvalCriteria.SETRANGE("RFQ No.", "RFQ No");
                IF EvalCriteria.FINDFIRST THEN BEGIN
                    REPEAT
                        lastno += 1;
                        //Populate Lines
                        EvaluationParameterLine.INIT;
                        EvaluationParameterLine."Line No." := lastno;
                        EvaluationParameterLine."Vendor No" := "Vendor No.";
                        EvaluationParameterLine."Vendor Name" := "Vendor Name";
                        EvaluationParameterLine."Quotation Amount" := PurchaseHeader.Amount;
                        EvaluationParameterLine.Code := Code;
                        EvaluationParameterLine."Parameter Code" := EvalCriteria.Code;
                        EvaluationParameterLine."Parameter Description" := EvalCriteria.Description;
                        EvaluationParameterLine."Max. Score" := EvalCriteria."Actual Weight Assigned";
                        //EvaluationParameterLine."Evaluation Type" := EvalCriteria."Evaluation Type";
                        EvaluationParameterLine."Evaluation Year" := FORMAT(EvalCriteria."Evaluation Year");
                        EvaluationParameterLine.INSERT;
                    UNTIL EvalCriteria.NEXT = 0;
                END;

                PurchaseQuoteHeader.RESET;
                PurchaseQuoteHeader.SETRANGE("No.", "RFQ No");
                IF PurchaseQuoteHeader.FIND('-') THEN
                    Description := PurchaseQuoteHeader."Posting Description";
            end;
        }
        field(50010; Shortlisted; Boolean)
        {
        }
        field(50011; "Committe No"; Code[20])
        {
            CalcFormula = Lookup("Procurement Committees".Code WHERE("RFQ No" = FIELD("RFQ No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "User Id"; Code[30])
        {
        }
        field(50013; "Final Evaluation"; Boolean)
        {
        }
        field(50014; "Average"; Decimal)
        {
        }
        field(50015; "Approval Date"; Date)
        {
        }
        field(50016; "Document Date"; Date)
        {
        }
        field(50017; "Amount Quoted"; Decimal)
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Evaluation  Period", "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF Code = '' THEN BEGIN
            PurchSetup.GET;
            //PurchSetup.TESTFIELD(PurchSetup."RFP Evaluation No");
            //NoSeriesMgt.InitSeries(PurchSetup."RFP Evaluation No", xRec."No. Series", 0D, Code, "No. Series");
        END;
        "User Id" := USERID;
        "Document Date" := TODAY;
        "Total Expected Value" := 100;
    end;

    var
        EvaluationParametersAreas: Record "Evaluation Parameters Areas";
        EvaluationParameterLine: Record "RFP Evaluation Lines";
        Vend: Record "E-Tender Company Information";
        lastno: Integer;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EvalCriteria: Record "Evaluation Criteria Header";
        Vendor: Record Vendor;
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        PurchaseHeader: Record "Purchase Header";
        RFPEvaluationHeader: Record "RFP Evaluation Header";
        Txt001: Label 'You can not Evaluate same RFQ Twice';
        EvaluationParameterLine_2: Record "RFP Evaluation Lines";
        PurchaseLine: Record "Purchase Line";
        ETenderCompanyInformation: Record "E-Tender Company Information";
        VendoNo: Code[20];
        Closing: Date;

    local procedure GetLastEntryNo() LastLineNum: Integer;
    var
        EvaluationParameterLine_2: Record "RFP Evaluation Lines";
    begin
        EvaluationParameterLine_2.RESET;
        IF EvaluationParameterLine_2.FINDLAST THEN BEGIN
            LastLineNum := EvaluationParameterLine_2."Line No." + 1;
        END;
    end;
}

