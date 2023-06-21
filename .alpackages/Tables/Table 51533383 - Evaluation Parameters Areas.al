table 51533383 "Evaluation Parameters Areas"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Parameter Code"; Code[10])
        {
            TableRelation = "Evaluation Parameters Setup".Code;

            trigger OnValidate();
            begin
                EvaluationParametersSetup.RESET;
                EvaluationParametersSetup.SETRANGE(EvaluationParametersSetup.Code, "Parameter Code");
                IF EvaluationParametersSetup.FIND('-') THEN
                    Description := EvaluationParametersSetup.Description;
            end;
        }
        field(3; Description; Text[250])
        {
        }
        field(4; "Expected Min.Value"; Decimal)
        {
        }
        field(5; "Expected Max.Value"; Decimal)
        {
        }
        field(6; "Vendor No."; Code[10])
        {

            trigger OnValidate();
            begin
                Vend.RESET;
                Vend.SETRANGE(Vend."No.", "Vendor No.");
                IF Vend.FIND('-') THEN
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(7; "Evaluation Year"; Code[30])
        {
            //TableRelation = "Evaluation Year".Code;
        }
        field(8; "Vendor Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Line No", "Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EvaluationParametersSetup: Record "Evaluation Parameters Setup";
        Vend: Record Vendor;
}

