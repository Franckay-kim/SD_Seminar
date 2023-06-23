/// <summary>
/// Table Technical Evaluation Header (ID 51533379).
/// </summary>
table 51533379 "Technical Evaluation Header"
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
                    //NoSeriesMgt.TestManual(PurchSetup."Technical Evaluation No");
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
            IF ("Vendor Type" = CONST(Vendor)) Vendor."No.";

            trigger OnValidate();
            var
                Vendor: Record Vendor;
                Vemd: Record "E-Tender Company Information";
            begin
                IF "Vendor Type" = "Vendor Type"::Supplier THEN BEGIN
                    Vend.RESET;
                    Vend.SETRANGE(Vend."Primary Key", "Vendor No.");
                    IF Vend.FIND('-') THEN
                        "Vendor Name" := Vend.Name;
                    //"Vendor Category" := Vend."Supplier Category";
                END ELSE
                    IF "Vendor Type" = "Vendor Type"::Vendor THEN
                        Vendor.RESET;
                Vendor.SETRANGE("No.", "Vendor No.");
                IF Vendor.FINDFIRST THEN
                    "Vendor Name" := Vendor.Name;
                //"Vendor Category" := Vendor."Supplier Category";

                EvaluationParameterLine.RESET;
                EvaluationParameterLine.SETRANGE(EvaluationParameterLine.Code, Code);
                IF EvaluationParameterLine.FIND('-') THEN BEGIN
                    //Clear existing data
                    EvaluationParameterLine.DELETEALL;
                END;

                EvaluationParameterLine."Line No." := 0;

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
                        EvaluationParameterLine."Evaluation Year" := FORMAT(EvalCriteria."Evaluation Year");
                        IF "RFQ No" <> '' THEN BEGIN
                            TenderCommitteeMembers.RESET;
                            TenderCommitteeMembers.SETRANGE(TenderCommitteeMembers."RFQ No", Rec."RFQ No");
                            IF TenderCommitteeMembers.FIND('-') THEN BEGIN
                                REPEAT
                                    EvaluationParameterLine."Committe Number" := TenderCommitteeMembers.COUNT;
                                UNTIL NEXT = 0;
                            END;
                        END;

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
        field(50006; "Vendor Category"; code[50])
        {
            //OptionMembers = ,Youth,Women,PWD,General;
            //TableRelation = "Vendor Categories";
        }
        field(50007; "RFQ No"; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No.";
        }
        field(50008; "Quote No"; Code[20])
        {
            TableRelation = if ("Vendor Type" = CONST(Supplier)) "Purchase Header"."No." WHERE("Document Type" = CONST(Quote),
                                                         // "Supplier No" = FIELD("Vendor No."))
                                                         //else
                                                         //if ("Vendor Type" = const(Vendor)) "Purchase Header"."No." WHERE("Document Type" = CONST(Quote),
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
            //CalcFormula = Lookup("Tender Committee Activities".Code WHERE (RFQ No.=FIELD(RFQ No)));
            Editable = false;
            TableRelation = "Procurement Committees";
            //FieldClass = FlowField;
        }
        field(50012; "User Id"; Code[30])
        {
        }
        field(50013; "Final Evaluation"; Boolean)
        {
        }
        field(50014; "Total Score"; Decimal)
        {
        }
        field(50015; "Average"; Decimal)
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
            //PurchSetup.TESTFIELD(PurchSetup."Technical Evaluation No");
            //NoSeriesMgt.InitSeries(PurchSetup."Technical Evaluation No", xRec."No. Series", 0D, Code, "No. Series");
        END;
        "User Id" := USERID;
    end;

    var
        EvaluationParametersAreas: Record "Evaluation Parameters Areas";
        EvaluationParameterLine: Record "Technical Evaluation Lines";
        Vend: Record "E-Tender Company Information";
        lastno: Integer;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EvalCriteria: Record "RFP Evaluation Criteria";
        //Vendor: Record "23";
        TenderCommitteeMembers: Record "Procurement Committees";

    local procedure GetLastEntryNo() LastLineNum: Integer;
    var
        EvaluationParameterLine_2: Record "Technical Evaluation Lines";
    begin
        EvaluationParameterLine_2.RESET;
        IF EvaluationParameterLine_2.FIND('+') THEN BEGIN
            LastLineNum := EvaluationParameterLine_2."Line No." + 1;
        END ELSE BEGIN
            LastLineNum := 1000;
        END;
    end;
}

