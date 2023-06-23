/// <summary>
/// Table Delegate Payment Line (ID 51532357).
/// </summary>
table 51532357 "Delegate Payment Line"
{

    fields
    {
        field(1; "Code"; Code[50])
        {
            Description = 'Lookup to 52018556';
            Editable = false;
            TableRelation = "Delegates Payment".Code;
        }
        field(2; "Delegate MNO."; Code[50])
        {
            Description = 'Lookup to Member table';
            TableRelation = "Delegate Memberss"."Delegate MNO." WHERE(Code = FIELD("Delegate Group"),
                                                                       Retired = FILTER(false));

            trigger OnValidate()
            begin
                DelegateMemberss.Reset;
                DelegateMemberss.SetRange(DelegateMemberss."Delegate MNO.", "Delegate MNO.");
                if DelegateMemberss.Find('-') then begin
                    "Delegate Name" := DelegateMemberss."Delegate Name";
                    DelegatesPayment.Reset;
                    DelegatesPayment.SetRange(DelegatesPayment.Code, Code);
                    if DelegatesPayment.Find('-') then begin
                        "Payment Frequency" := DelegatesPayment."Payment Frequency";

                    end;
                end;
            end;
        }
        field(3; "Delegate Name"; Text[100])
        {
            Editable = false;
        }
        field(4; Position; Code[50])
        {
            Description = 'Lookup 39004358 filter type tittle';
            Editable = false;
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Position));
        }
        field(5; "Job Tittle"; Code[50])
        {
            Description = '39004358';
            Editable = false;
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
        }
        field(6; "Service Period"; Text[30])
        {
            Editable = false;
        }
        field(7; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(8; "Tariff Code"; Code[10])
        {
            Description = '52018549';
            TableRelation = "Delegates Tariff".Code WHERE("Payment Frequency" = FIELD("Payment Frequency"));

            trigger OnValidate()
            begin

                MyCount := 1;
                DelegatePaymentLine.Reset;
                DelegatePaymentLine.SetRange(Code, Code);
                DelegatePaymentLine.SetRange("Tariff Code", "Tariff Code");
                if DelegatePaymentLine.Find('-') then begin
                    repeat
                        MyCount += 1;
                    until DelegatePaymentLine.Next = 0;
                end;
                //MESSAGE('%1',MyCount);
                Tariffs.Reset;
                Tariffs.SetRange(Tariffs.Code, "Tariff Code");
                if Tariffs.Find('-') then begin
                    if MyCount > Tariffs."Maximum No Paid" then
                        Error('Maximum payement of %1 exceedsmaximum allowable of %2', Tariffs.Description, Tariffs."Maximum No Paid");
                end;
                DelegatesTariff.Reset;
                DelegatesTariff.SetRange(DelegatesTariff.Code, "Tariff Code");
                if DelegatesTariff.Find('-') then begin
                    if DelegatesTariff.CalculationMethod = DelegatesTariff.CalculationMethod::Milleage then begin
                        DimensionValue.Reset;
                        DimensionValue.SetRange(Code, "Electoral Zone");
                        if DimensionValue.Find('-') then begin
                            "Amount Payable" := DimensionValue."Mileage (KMs)" * DelegatesTariff."Rate Per KM";
                        end;
                    end else
                        "Amount Payable" := DelegatesTariff.Amount;
                end;
                DelegatesPayment.Reset;
                DelegatesPayment.SetRange(Code, Code);
                if DelegatesPayment.Find('-') then begin
                    "Electoral Zone" := DelegatesPayment."Electoral Zone";
                    "Electoral Zone Name" := DelegatesPayment."Electoral Zone Name";
                end;
                DelegatePaymentLines.Reset;
                DelegatePaymentLines.SetRange(Code, Code);
                DelegatePaymentLines.SetRange("Delegate MNO.", "Delegate MNO.");
                DelegatePaymentLines.SetRange("Tariff Code", "Tariff Code");
                if DelegatePaymentLines.Find('-') then begin
                    Error('This Member has already been assigned this allowance');
                end;
            end;
        }
        field(9; "Amount Payable"; Decimal)
        {
        }
        field(10; Posted; Boolean)
        {
            Editable = false;
        }
        field(11; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(12; "Delegate Group"; Code[50])
        {
            Description = 'Lookup to 52018551';
            Editable = false;
            TableRelation = "Delegate Groupss".Code;
        }
        field(13; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Payment Frequency"; Option)
        {
            OptionCaption = ',Weekly,Monthly,Quartely,Semi Annual,Annual';
            OptionMembers = ,Weekly,Monthly,Quartely,"Semi Annual",Annual;
        }
        field(16; "Electoral Zone"; Code[50])
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
        field(17; "Electoral Zone Name"; Text[100])
        {
            Editable = false;
        }
        field(18; "Period Ending Date"; Date)
        {
            Editable = false;
        }
        field(19; "Excess Amount"; Decimal)
        {

        }
    }

    keys
    {
        key(Key1; "Code", "Entry No", "Delegate Group")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Members: Record Members;
        DelegateMembers: Record "Delegate Members Applicationss";
        ErrPosition: Label 'You cannot have the same position of %1 within the same group';
        GeneralSetUp: Record "General Set-Up";
        ErrMemb: Label 'This member has not met minimum membership period of %1';
        DelegatesTariff: Record "Delegates Tariff";
        DimensionValue: Record "Electrol Zones/Area Svr Center";
        ElectrolZonesAreaSvrCenter: Record "Electrol Zones/Area Svr Center";
        ElectrolZonesAreaSvrCenters: Record "Electrol Zones/Area Svr Center";
        DelegateMemberss: Record "Delegate Memberss";
        DelegatesPayment: Record "Delegates Payment";
        Tariffs: Record "Delegates Tariff";
        DelegatePaymentLine: Record "Delegate Payment Line";
        MyCount: Integer;
        DelegatePaymentLines: Record "Delegate Payment Line";
}

