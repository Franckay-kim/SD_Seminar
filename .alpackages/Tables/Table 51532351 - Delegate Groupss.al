/// <summary>
/// Table Delegate Groupss (ID 51532351).
/// </summary>
table 51532351 "Delegate Groupss"
{
    DataCaptionFields = "Code", "Delegate Group Description", "Electoral Zone";
    //DrillDownPageID = "Delegate Group Lists";
    //LookupPageID = "Delegate Group Lists";

    fields
    {
        field(1; "Code"; Code[50])
        {
        }
        field(2; "Delegate Group Description"; Text[100])
        {
        }
        field(3; "Electoral Zone"; Code[50])
        {
            Description = 'lookup Electrol Zones/Area Svr Center (52018626) (Type=FILTER(Electral Zone))';
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = FILTER("Electral Zone"));

            trigger OnValidate()
            begin
                ElectrolZonesAreaSvrCenter.Reset;
                ElectrolZonesAreaSvrCenter.SetRange(Code, "Electoral Zone");
                ElectrolZonesAreaSvrCenter.SetRange(Type, ElectrolZonesAreaSvrCenter.Type::"Electral Zone");
                if ElectrolZonesAreaSvrCenter.Find('-') then begin
                    "Electoral Zone Name" := ElectrolZonesAreaSvrCenter.Description;
                end;
            end;
        }
        field(4; "Electoral Zone Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(6; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(7; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(8; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; County; Code[50])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));

            trigger OnValidate()
            begin
                SegmentCountyDividendSignat.Reset;
                SegmentCountyDividendSignat.SetRange(Code, County);
                SegmentCountyDividendSignat.SetRange(Type, SegmentCountyDividendSignat.Type::County);
                if SegmentCountyDividendSignat.Find('-') then begin
                    "County Name" := SegmentCountyDividendSignat.Description;
                    ;
                end;
            end;
        }
        field(11; "Sub-County"; Code[50])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST("Sub-County"));

            trigger OnValidate()
            begin
                SegmentCountyDividendSignat.Reset;
                SegmentCountyDividendSignat.SetRange(Code, "Sub-County");
                SegmentCountyDividendSignat.SetRange(Type, SegmentCountyDividendSignat.Type::"Sub-County");
                if SegmentCountyDividendSignat.Find('-') then begin
                    "Sub-County Name" := SegmentCountyDividendSignat.Description;
                    ;
                end;
            end;
        }
        field(12; "County Name"; Text[100])
        {
            Editable = false;
        }
        field(13; "Sub-County Name"; Text[100])
        {
            Editable = false;
        }
        field(14; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = Open,Pending,Approved;
        }
        field(17; "Global Dimension 1 Name"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code Name';
            Editable = false;
        }
        field(18; "Global Dimension 2 Name"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code Name';
            Editable = false;
        }
        field(19; "Province Code"; Code[50])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Province));

            trigger OnValidate()
            begin
                SegmentCountyDividendSignat.Reset;
                SegmentCountyDividendSignat.SetRange(Code, "Province Code");
                SegmentCountyDividendSignat.SetRange(Type, SegmentCountyDividendSignat.Type::Province);
                if SegmentCountyDividendSignat.Find('-') then begin
                    "Province Name" := SegmentCountyDividendSignat.Description;
                    ;
                end;
            end;
        }
        field(20; "Province Name"; Code[50])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code", "Delegate Group Description", "Electoral Zone")
        {
        }
        key(Key2; "Delegate Group Description", "Electoral Zone")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(as; "Code", "Delegate Group Description", "Electoral Zone")
        {
        }
    }

    trigger OnInsert()
    begin
        if Code = '' then begin
            MembNoSeries.Get;
            MembNoSeries.TestField(MembNoSeries."Delegate Nos.");
            NoSeriesMgt.InitSeries(MembNoSeries."Delegate Nos.", xRec."No. Series", 0D, Code, "No. Series");
            "Created By" := UserId;
            "Creation Date" := Today;
        end;
    end;

    var
        ElectrolZonesAreaSvrCenter: Record "Electrol Zones/Area Svr Center";
        MembNoSeries: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SegmentCountyDividendSignat: Record "Segment/County/Dividend/Signat";
        DimensionValue: Record "Dimension Value";
}

