/// <summary>
/// Table Dividend Simulation Header (ID 51532036).
/// </summary>
table 51532036 "Dividend Simulation Header"
{

    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                //*
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Dividend Rate No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if xRec."Start Date" <> 0D then
                    if Confirm(ConfirmChange, false) then
                        ClearDividendLines("No.")
                    else
                        Error(ExitProcessErr);
            end;
        }
        field(3; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                if xRec."End Date" <> 0D then
                    if Confirm(ConfirmChange, false) then
                        ClearDividendLines("No.")
                    else
                        Error(ExitProcessErr);
            end;
        }
        field(4; Deposits; Decimal)
        {
            CalcFormula = Sum("Dividend Simulation Lines".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Weighted Amount"; Decimal)
        {
            CalcFormula = Sum("Dividend Simulation Lines"."Weighted Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Total Payout"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                /* CALCFIELDS(Deposits,"Weighted Amount");
                 IF (Deposits<>0) AND ("Weighted Amount"<>0) AND ("Total Payout"<> 0)  THEN
                    Rate:= ("Total Payout"/"Weighted Amount")*100;
                 */

            end;
        }
        field(7; Rate; Decimal)
        {

            trigger OnLookup()
            begin
                /*CALCFIELDS(Deposits,"Weighted Amount");
                IF (Deposits<>0) AND ("Weighted Amount"<>0) AND ("Total Payout"<> 0)  THEN
                   Rate:= ("Total Payout"/"Weighted Amount")*100;*/

            end;

            trigger OnValidate()
            begin
                TestField("All Products", false);

                DividendCalculationBuffer.Reset;
                DividendCalculationBuffer.SetRange(DividendCalculationBuffer."Document No.", "No.");
                if DividendCalculationBuffer.FindSet then
                    DividendCalculationBuffer.DeleteAll;
            end;
        }
        field(8; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Rejected,Approved,Transferred';
            OptionMembers = Open,Pending,Rejected,Approved,Transferred;
        }
        field(9; "Product Type"; Code[10])
        {
            TableRelation = "Product Factory" WHERE("Product Class Type" = CONST(Savings));

            trigger OnValidate()
            var
                ProductFactory: Record "Product Factory";
                CustomerPostingGroup: Record "Customer Posting Group";
            begin
                if ProductFactory.Get("Product Type") then begin
                    "Product Name" := ProductFactory."Product Description";
                    if CustomerPostingGroup.Get(ProductFactory."Product Posting Group") then
                        "G/L Account" := CustomerPostingGroup."Receivables Account";
                end;
            end;
        }
        field(10; "Product Name"; Text[80])
        {
            Editable = false;
        }
        field(11; "G/L Account"; Code[20])
        {
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(12; "No. Series"; Code[10])
        {
        }
        field(13; "Created By"; Code[50])
        {
        }
        field(14; "All Products"; Boolean)
        {

            trigger OnValidate()
            begin

                if "All Products" then
                    Rate := 0;
            end;
        }
        field(15; "Total Pay"; Decimal)
        {
            CalcFormula = Sum("Dividend Simulation Lines"."Pay Out" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Total W/Tax"; Decimal)
        {
            CalcFormula = Sum("Dividend Simulation Lines"."W/Tax" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Total Net"; Decimal)
        {
            CalcFormula = Sum("Dividend Simulation Lines"."Net Pay" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //*
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Dividend Rate No.");
            NoSeriesMgt.InitSeries(SeriesSetup."Dividend Rate No.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Created By" := UserId;
    end;

    var
        ExitProcessErr: Label 'You have selected to abort process date Change will be rolled back';
        ConfirmChange: Label 'The Change you want to will  affect any processed data do you wish to continue?';
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DividendCalculationBuffer: Record "Dividend Simulation Lines";

    local procedure ClearDividendLines(No: Code[20])
    var
        DividendSimulationLines: Record "Standing Order Header";
    begin
        DividendSimulationLines.Reset;
        DividendSimulationLines.SetRange(DividendSimulationLines."No.", No);
        if DividendSimulationLines.Find('-') then
            DividendSimulationLines.DeleteAll;
    end;
}

