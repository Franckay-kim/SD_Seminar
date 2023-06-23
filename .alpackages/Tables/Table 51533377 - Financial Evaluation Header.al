/// <summary>
/// Table Financial Evaluation Header (ID 51533377).
/// </summary>
table 51533377 "Financial Evaluation Header"
{
    // version RFP


    fields
    {
        field(1; "Code"; Code[20])
        {

            trigger OnValidate();
            var
                PurchSetup: Record "Purchases & Payables Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                IF Code <> xRec.Code THEN BEGIN
                    PurchSetup.GET;
                    //NoSeriesMgt.TestManual(PurchSetup."Financial Evaluation No");
                    "No. Series" := '';
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
        field(4; "Vendor No."; Code[20])
        {
            TableRelation = IF ("Vendor Type" = CONST(Supplier)) "E-Tender Company Information"
            ELSE
            IF ("Vendor Type" = CONST(Vendor)) "Quotation Request Vendors"."Vendor No.";// WHERE("Requisition Document No." = FIELD(RFQ No));

            trigger OnValidate();
            var
                Vend: Record "E-Tender Company Information";
                Vendor: Record Vendor;
            begin
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
                //"Vendor Category" := Vendor."Vendor Category";

                EvaluationParameterLine.RESET;
                EvaluationParameterLine.SETRANGE(EvaluationParameterLine.Code, Code);
                IF EvaluationParameterLine.FIND('-') THEN BEGIN
                    //Clear existing data
                    EvaluationParameterLine.DELETEALL;
                END;


                EvalCriteria.RESET;
                EvalCriteria.SETRANGE("Type Of Service", "Vendor Category");
                IF EvalCriteria.FINDFIRST THEN BEGIN
                    REPEAT
                        //Populate Lines
                        EvaluationParameterLine.INIT;
                        EvaluationParameterLine."Line No." := GetLastEntryNo;
                        EvaluationParameterLine."Vendor No" := "Vendor No.";
                        //IF Vend.GET("Vendor No.") THEN
                        EvaluationParameterLine."Vendor Name" := "Vendor Name";
                        EvaluationParameterLine.Code := Code;
                        EvaluationParameterLine."Parameter Code" := EvalCriteria.Code;
                        EvaluationParameterLine."Parameter Description" := EvalCriteria.Description;
                        EvaluationParameterLine."Max. Score" := EvalCriteria."Actual Weight Assigned";
                        EvaluationParameterLine."Evaluation Type" := EvalCriteria."Evaluation Type";
                        EvaluationParameterLine.INSERT;
                    UNTIL EvalCriteria.NEXT = 0;
                END;


                MESSAGE('Process Complete');
            end;
        }
        field(5; "Total Expected Value"; Decimal)
        {
        }
        field(6; "Overall Comment"; Text[100])
        {
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
        field(50003; "Evaluation Type"; Code[20])
        {
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
        }
        field(50007; "RFQ No"; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No.";

            trigger OnValidate();
            begin
                PurchaseQuoteHeader.RESET;
                PurchaseQuoteHeader.SETRANGE("No.", "RFQ No");
                IF PurchaseQuoteHeader.FIND('-') THEN
                    Description := PurchaseQuoteHeader."Posting Description";

                FinancialEvaluationLines.RESET;
                FinancialEvaluationLines.SETRANGE(FinancialEvaluationLines.Code, Code);
                IF FinancialEvaluationLines.FINDSET THEN
                    FinancialEvaluationLines.DELETEALL;

                RFPEvaluationHeader.RESET;
                RFPEvaluationHeader.SETRANGE(RFPEvaluationHeader."RFQ No", "RFQ No");
                IF RFPEvaluationHeader.FIND('-') THEN BEGIN
                    REPEAT
                        IF RFPEvaluationHeader."Vendor No." <> VendNo THEN BEGIN
                            //IF RFPEvaluationHeader.Average > 70 THEN BEGIN
                            FinancialEvaluationLines.INIT;
                            FinancialEvaluationLines."Line No." := 0;
                            FinancialEvaluationLines.Code := Code;
                            FinancialEvaluationLines."Vendor No" := RFPEvaluationHeader."Vendor No.";
                            FinancialEvaluationLines."Vendor Name" := RFPEvaluationHeader.Description;
                            RFPEvaluationLines.RESET;
                            RFPEvaluationLines.SETRANGE(Code, RFPEvaluationHeader.Code);
                            IF RFPEvaluationLines.FINDFIRST THEN BEGIN
                                FinancialEvaluationLines."Financial Sum" := RFPEvaluationLines."Quotation Amount";
                                LowestBid := FinancialEvaluationLines."Financial Sum";
                                IF RFPEvaluationLines."Quotation Amount" < LowestBid THEN
                                    FinancialEvaluationLines."Lowest Price(Fm)" := RFPEvaluationLines."Quotation Amount" ELSE
                                    FinancialEvaluationLines."Lowest Price(Fm)" := LowestBid;
                            END;
                            //FinancialEvaluationLines."Average Score" := RFPEvaluationHeader.Average;
                            //FinancialEvaluationLines."Financial Proposal(F)" := RFPEvaluationHeader.Average * 80 / 100;
                            //FinancialEvaluationLines."Financial Score (Sf)" := (FinancialEvaluationLines."Lowest Price(Fm)" / FinancialEvaluationLines."Financial Sum") * 20;
                            FinancialEvaluationLines."Price Weight Factor" := FinancialEvaluationLines."Financial Proposal(F)" + FinancialEvaluationLines."Financial Score (Sf)";

                            FinancialEvaluationLines.INSERT;
                            //END;
                            VendNo := RFPEvaluationHeader."Vendor No.";
                            LowestBid := FinancialEvaluationLines."Financial Sum";
                        END;
                    UNTIL RFPEvaluationHeader.NEXT = 0;
                END;
            end;
        }
        field(50008; "Quote No"; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote),
                                                         "Buy-from Vendor No." = FIELD("Vendor No."));
        }
        field(50009; "Vendor Type"; Option)
        {
            OptionMembers = " ",Vendor,Supplier;
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
            //PurchSetup.TESTFIELD(PurchSetup."Financial Evaluation No");
            //NoSeriesMgt.InitSeries(PurchSetup."Financial Evaluation No", xRec."No. Series", 0D, Code, "No. Series");
        END;
        "User Id" := USERID;
        "Evaluation Start Period" := TODAY;
    end;

    var
        EvaluationParametersAreas: Record "Evaluation Parameters Areas";
        EvaluationParameterLine: Record "RFP Evaluation Lines";
        Vend: Record "E-Tender Company Information";
        lastno: Integer;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EvalCriteria: Record "RFP Evaluation Criteria";
        Vendor: Record Vendor;
        RFPEvaluationHeader: Record "RFP Evaluation Header";
        RFPEvaluationLines: Record "RFP Evaluation Lines";
        FinancialEvaluationLines: Record "Financial Evaluation Lines";
        Total: Decimal;
        "Average": Decimal;
        Score: Decimal;
        TotalScore: Decimal;
        Over70name: Text[100];
        Over70Score: Decimal;
        "AboveVendNo.": Code[20];
        RFPEvaluaHeader: Record "RFP Evaluation Header";
        VendNo: Code[20];
        LowestBid: Decimal;
        PurchaseQuoteHeader: Record "Purchase Quote Header";

    local procedure GetLastEntryNo() LastLineNum: Integer;
    var
        EvaluationParameterLine_2: Record "RFP Evaluation Lines";
    begin
        EvaluationParameterLine_2.RESET;
        IF EvaluationParameterLine_2.FIND('+') THEN BEGIN
            LastLineNum := EvaluationParameterLine_2."Line No." + 1;
        END ELSE BEGIN
            LastLineNum := 1000;
        END;
    end;
}

