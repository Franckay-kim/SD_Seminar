table 51533402 "Delegate Regions"
{
    Caption = 'Delegate Regions';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Region Code"; Code[20])
        {
            Caption = 'Region Code';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Region Name"; Text[100])
        {
            Caption = 'Region Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Region Location"; Text[100])
        {
            Caption = 'Region Location';
            DataClassification = ToBeClassified;
        }
        field(4; Diocese; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Diocese.Code;
            trigger OnValidate()

            begin
                Diocese := UpperCase(Diocese);
            end;
        }
        field(5; "Arch Diocese"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Parish.Code where("Diocese Code" = field(Diocese));
            trigger OnValidate()

            begin
                "Arch Diocese" := UpperCase("Arch Diocese");
            end;
        }
        field(6; Jumuiya; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Jumuiya.Code where(Diocese = field(Diocese), Parish = field("Arch Diocese"));
            trigger OnValidate()

            begin
                Jumuiya := UpperCase(Jumuiya);
            end;
        }
        field(7; "Administrative Town"; Text[100])
        {
            Caption = 'Administrative Town';
            DataClassification = ToBeClassified;
        }
        field(8; County; Code[50])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
        }
        field(9; "No Series"; Code[20])
        {

        }
    }
    keys
    {
        key(PK; "Region Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Region Code" = '' then begin
            CreditNoSeries.Get();
            CreditNoSeries.TestField("Delegate Region Nos");
            NoSeriesMgt.InitSeries(CreditNoSeries."Delegate Region Nos", xRec."No Series", 0D, "Region Code", "No Series");
        end;

    end;

    var
        CreditNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
