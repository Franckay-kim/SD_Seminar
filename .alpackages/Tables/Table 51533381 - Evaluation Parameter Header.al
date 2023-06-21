table 51533381 "Evaluation Parameter Header"
{

    fields
    {
        field(1; "Criteria Code"; Code[20])
        {

            trigger OnValidate();
            begin
                IF "Criteria Code" <> xRec."Criteria Code" THEN BEGIN
                    PurchSetup.GET;
                    //NoSeriesMgt.TestManual(PurchSetup."Appraisal Parameter No");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Criteria Description"; Text[100])
        {
        }
        field(3; "Evaluation  Period"; Code[20])
        {
            //TableRelation = "Evaluation Year".Code;

            trigger OnValidate();
            begin
                CLEAR(lastno);

                EvaluationParameterLine.RESET;
                EvaluationParameterLine.SETRANGE(EvaluationParameterLine.Code, "Criteria Code");
                IF EvaluationParameterLine.FIND('-') THEN BEGIN
                    EvaluationParameterLine.DELETEALL;
                END;

                // //*******************************

                // EvaluationParameterLine.RESET;
                //IF  EvaluationParameterLine.FIND('+') THEN
                //lastno:= EvaluationParameterLine."Line No.";
                //IF lastno<>0 THEN lastno:=lastno+100 ELSE lastno:=100;
                // //*****************************

                EvaluationParametersAreas.RESET;
                EvaluationParametersAreas.SETRANGE(EvaluationParametersAreas."Evaluation Year", "Evaluation  Period");
                IF EvaluationParametersAreas.FIND('-') THEN BEGIN
                    REPEAT
                        //Populate Lines
                        EvaluationParameterLine.INIT;
                        EvaluationParameterLine."Line No." := GetLastEntryNo;
                        EvaluationParameterLine."Line No." := lastno;
                        EvaluationParameterLine.Code := "Criteria Code";
                        EvaluationParameterLine."Vendor No" := EvaluationParametersAreas."Vendor No.";
                        EvaluationParameterLine."Overall Comment" := EvaluationParametersAreas.Description;
                        EvaluationParameterLine."Parameter Code" := EvaluationParametersAreas."Parameter Code";
                        EvaluationParameterLine."Vendor Name" := EvaluationParametersAreas."Vendor Name";
                        EvaluationParameterLine."Evaluation Year" := EvaluationParametersAreas."Evaluation Year";
                        EvaluationParameterLine."Min. Score" := EvaluationParametersAreas."Expected Min.Value";
                        EvaluationParameterLine."Max. Score" := EvaluationParametersAreas."Expected Max.Value";

                        EvaluationParameterLine.INSERT;
                    UNTIL EvaluationParametersAreas.NEXT = 0;
                END;

                /*
                
                 ELSE BEGIN
                    //ERROR('Vendor Evaluation Areas for this vendor have not been setup');
                    EvaluationParameterLine.RESET;
                    EvaluationParameterLine.SETRANGE(EvaluationParameterLine.Code,"Criteria Code");
                    IF EvaluationParameterLine.FIND('-') THEN
                    BEGIN
                    REPEAT
                        //Clear existing data
                        EvaluationParameterLine.DELETEALL;
                    UNTIL EvaluationParameterLine.NEXT =0;
                
                    END;
                
                END;*/


                MESSAGE('Process Complete');

            end;
        }
        field(4; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                Vend.RESET;
                Vend.SETRANGE(Vend."No.", "Vendor No.");
                IF Vend.FIND('-') THEN
                    "Vendor Name" := Vend.Name;

                EvaluationParameterLine.RESET;
                EvaluationParameterLine.SETRANGE(EvaluationParameterLine.Code, "Criteria Code");
                IF EvaluationParameterLine.FIND('-') THEN BEGIN
                    //Clear existing data
                    EvaluationParameterLine.DELETEALL;
                END;



                EvaluationParametersAreas.RESET;
                EvaluationParametersAreas.SETRANGE(EvaluationParametersAreas."Vendor No.", "Vendor No.");
                IF EvaluationParametersAreas.FIND('-') THEN BEGIN
                    REPEAT
                        //Populate Lines
                        EvaluationParameterLine.INIT;

                        EvaluationParameterLine."Line No." := GetLastEntryNo;
                        EvaluationParameterLine.Code := "Criteria Code";
                        EvaluationParameterLine."Parameter Code" := EvaluationParametersAreas."Parameter Code";
                        EvaluationParameterLine."Min. Score" := EvaluationParametersAreas."Expected Min.Value";
                        EvaluationParameterLine."Max. Score" := EvaluationParametersAreas."Expected Max.Value";

                        EvaluationParameterLine.INSERT;
                    UNTIL EvaluationParametersAreas.NEXT = 0;
                END ELSE BEGIN
                    //ERROR('Vendor Evaluation Areas for this vendor have not been setup');
                    EvaluationParameterLine.RESET;
                    EvaluationParameterLine.SETRANGE(EvaluationParameterLine.Code, "Criteria Code");
                    IF EvaluationParameterLine.FIND('-') THEN BEGIN
                        //Clear existing data
                        EvaluationParameterLine.DELETEALL;
                    END;

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
            CalcFormula = Lookup("Evaluation Parameter Line"."Actuals Scores" WHERE(Code = FIELD("Criteria Code")));
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
    }

    keys
    {
        key(Key1; "Criteria Code")
        {
        }
        key(Key2; "Evaluation  Period", "Criteria Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Criteria Code" = '' THEN BEGIN
            PurchSetup.GET;
            //PurchSetup.TESTFIELD(PurchSetup."Appraisal Parameter No");
            //NoSeriesMgt.InitSeries(PurchSetup."Appraisal Parameter No", xRec."No. Series", 0D, "Criteria Code", "No. Series");
        END;
    end;

    var
        EvaluationParametersAreas: Record "Evaluation Parameters Areas";
        EvaluationParameterLine: Record "Evaluation Parameter Line";
        Vend: Record Vendor;
        lastno: Integer;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure GetLastEntryNo() LastLineNum: Integer;
    var
        EvaluationParameterLine_2: Record "Evaluation Parameter Line";
    begin
        EvaluationParameterLine_2.RESET;
        IF EvaluationParameterLine_2.FIND('+') THEN BEGIN
            LastLineNum := EvaluationParameterLine_2."Line No." + 1;
        END ELSE BEGIN
            LastLineNum := 1000;
        END;
    end;
}

