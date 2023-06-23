/// <summary>
/// Table Technical Evaluation Lines (ID 51533380).
/// </summary>
table 51533380 "Technical Evaluation Lines"
{
    // version RFP


    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Overall Comment"; Text[50])
        {
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(4; "Parameter Code"; Code[10])
        {
            Editable = false;
        }
        field(5; "Min. Score"; Decimal)
        {
            //Editable = false;
        }
        field(6; "Max. Score"; Decimal)
        {
            //Editable = false;
        }
        field(7; "Vendor No"; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate();
            var
                Vend: Record Vendor;
            begin
                Vend.RESET;
                Vend.SETRANGE(Vend."No.", "Vendor No");
                IF Vend.FIND('-') THEN
                    "Vendor Name" := Vend.Name;
                /*
                TechnicalEvaluationHeader.RESET;
                TechnicalEvaluationHeader.SETRANGE(TechnicalEvaluationHeader.Code, Code);
                IF TechnicalEvaluationHeader.FIND('-') THEN TechnicalEvaluationHeader."Committe No":=Rec."Committe Number";*/

            end;
        }
        field(8; "Vendor Name"; Text[100])
        {
        }
        field(9; "Evaluation Year"; Code[50])
        {
        }
        field(10; "Actuals Scores"; Decimal)
        {

            trigger OnValidate();
            var
                TechnicalEvaluationHeader: Record "Technical Evaluation Header";
            begin
                /*IF "Actuals Scores" > "Max. Score" THEN ERROR('Score cannot exceed maximum score');
                IF "Actuals Scores" < "Min. Score" THEN ERROR('Score cannot be less than minimum score');

                TechnicalEvaluationHeader.RESET;
                TechnicalEvaluationHeader.SETRANGE(TechnicalEvaluationHeader.Code, Code);
                IF TechnicalEvaluationHeader.FIND('-') THEN BEGIN

                    Total := 0;
                    REPEAT
                        Total := Total + Rec."Actuals Scores";
                    UNTIL Rec.NEXT = 0;
                    TechnicalEvaluationHeader."Total Actuals Value" := Total;
                    TechnicalEvaluationHeader.Average := TechnicalEvaluationHeader."Total Actuals Value" / "Committe Number";
                    TechnicalEvaluationHeader.MODIFY;
                END;,*/
            end;
        }
        field(11; Comment; Text[100])
        {
        }
        field(12; "Total Actual Scores"; Decimal)
        {
            CalcFormula = Sum("RFP Evaluation Lines"."Actuals Scores" WHERE("Parameter Code" = FIELD("Parameter Code"),
                                                                             "Vendor No" = FIELD("Vendor No"),
                                                                             "Evaluation Year" = FIELD("Evaluation Year")));
            FieldClass = FlowField;
        }
        field(13; "Parameter Description"; Text[250])
        {
        }
        field(14; Pass; Boolean)
        {
        }
        field(15; "Evaluation Type"; Option)
        {
            OptionMembers = "Score-Based","Non-Score-Based";
        }
        field(16; "Committe Number"; Integer)
        {
        }
        field(17; "Average"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vend: Record Vendor;
        //TenderCommitteeMembers: Record "52018747";
        TechnicalEvaluationHeader: Record "Technical Evaluation Header";
        TechnicalEvaluationLines: Record "Technical Evaluation Lines";
        Total: Decimal;
}

