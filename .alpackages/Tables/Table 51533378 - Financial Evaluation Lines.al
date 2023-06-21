table 51533378 "Financial Evaluation Lines"
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
            Editable = false;
        }
        field(6; "Max. Score"; Decimal)
        {
            Editable = false;
        }
        field(7; "Vendor No"; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                Vend.RESET;
                Vend.SETRANGE(Vend."No.", "Vendor No");
                IF Vend.FIND('-') THEN
                    "Vendor Name" := Vend.Name;
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
            begin
                IF "Actuals Scores" > "Max. Score" THEN ERROR('Score cannot exceed maximum score');
                IF "Actuals Scores" < "Min. Score" THEN ERROR('Score cannot be less than minimum score');
            end;
        }
        field(11; Comment; Text[100])
        {
        }
        field(12; "Total Actual Scores"; Decimal)
        {
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
        field(16; "Average Score"; Decimal)
        {
        }
        field(17; "Technical Weighted Factor"; Decimal)
        {
        }
        field(18; "Technical Score"; Decimal)
        {
        }
        field(19; "Financial Sum"; Decimal)
        {
        }
        field(20; "Lowest Price(Fm)"; Decimal)
        {
        }
        field(21; "Financial Proposal(F)"; Decimal)
        {
        }
        field(22; "Financial Score (Sf)"; Decimal)
        {
        }
        field(23; "Price Weight Factor"; Decimal)
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
}

