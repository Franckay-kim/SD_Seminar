/// <summary>
/// Table Delegates Payment (ID 51532356).
/// </summary>
table 51532356 "Delegates Payment"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            Editable = false;
        }
        field(2; "Delegate Group"; Code[20])
        {
            Description = 'Lookup to 52018551';
            TableRelation = "Delegate Groupss".Code;

            trigger OnValidate()
            begin
                DelegateGroup.Reset;
                DelegateGroup.SetRange(Code, "Delegate Group");
                if DelegateGroup.Find('-') then begin
                    "Delegate Group Description" := DelegateGroup."Delegate Group Description";
                end;
                "Posting Date" := 0D;
            end;
        }
        field(3; "Delegate Group Description"; Text[100])
        {
            Editable = false;
        }
        field(4; "Electoral Zone"; Code[50])
        {
            Description = 'lookup Electrol Zones/Area Svr Center (52018626) (Type=FILTER(Electral Zone))';
            Editable = false;
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
        field(5; "Electoral Zone Name"; Text[100])
        {
            Editable = false;
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(8; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(9; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(10; "No. Series"; Code[20])
        {
            Editable = false;
        }
        field(11; County; Code[50])
        {
            Editable = false;
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
        field(12; "Sub-County"; Code[50])
        {
            Editable = false;
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
        field(13; "County Name"; Text[100])
        {
            Editable = false;
        }
        field(14; "Sub-County Name"; Text[100])
        {
            Editable = false;
        }
        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = Open,Pending,Approved;
        }
        field(16; "Amount To Pay"; Decimal)
        {
        }
        field(17; Posted; Boolean)
        {
            Editable = false;
        }
        field(18; "Date Posted"; Date)
        {
            Editable = false;
        }
        field(19; "Posted By"; Code[50])
        {
            Editable = false;
        }
        field(20; "Posting Date"; Date)
        {

            trigger OnValidate()
            var
                DMs: Record "Delegates Minutes Header";
                DMLines: Record "Delegates Meeting Attendees";
            begin
                TestField("Payment Frequency");
                TestField("Delegate Group");
                if "Payment Frequency" = "Payment Frequency"::Weekly then
                    "Period Ending Date" := CalcDate('CW', "Posting Date") else
                    if "Payment Frequency" = "Payment Frequency"::Monthly then
                        "Period Ending Date" := CalcDate('CM', "Posting Date") else
                        if "Payment Frequency" = "Payment Frequency"::Quartely then
                            "Period Ending Date" := CalcDate('CQ', "Posting Date") else
                            if "Payment Frequency" = "Payment Frequency"::"Semi Annual" then
                                "Period Ending Date" := CalcDate('-6M', (CalcDate('CY', "Posting Date"))) else
                                if "Payment Frequency" = "Payment Frequency"::Annual then
                                    "Period Ending Date" := CalcDate('CY', "Posting Date") else
                                    "Period Ending Date" := CalcDate('CM', "Posting Date");
                DelegateGroupss.Reset;
                DelegateGroupss.SetRange(Code, "Delegate Group");
                if DelegateGroupss.Find('-') then
                //IF DelegateGroupss.GET("Delegate Group") THEN
                begin
                    "Delegate Group Description" := DelegateGroupss."Delegate Group Description";
                    "Electoral Zone" := DelegateGroupss."Electoral Zone";
                    Validate("Electoral Zone");
                    "Global Dimension 1 Code" := DelegateGroupss."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := DelegateGroupss."Global Dimension 2 Code";
                    "Created By" := UserId;
                    "Creation Date" := Today;
                    County := DelegateGroupss.County;
                    Validate(County);
                    "Sub-County" := DelegateGroupss."Sub-County";
                    Validate("Sub-County");
                    //Delete existing Lines
                    DelegatePaymentLines.Reset;
                    DelegatePaymentLines.SetRange(Code, Code);
                    DelegatePaymentLines.SetRange(Posted, false);
                    if DelegatePaymentLines.Find('-') then begin
                        repeat
                            DelegatePaymentLines.Delete;
                        until DelegatePaymentLines.Next = 0;
                    end;
                    //Insert Payment Lines with the members
                    MyRec2.Reset;
                    if MyRec2.Find('-') then
                        LineNo := MyRec2."Entry No" + 1
                    else
                        LineNo := 1;

                    //start from meeting 
                    //get delegates who attended meeting and combine all payments together  
                    DMs.Reset();
                    DMs.SetRange(Code, rec."Minute No.");
                    if DMs.Find('-') then begin
                        DMLines.Reset();
                        DMLines.SetRange(Code, DMs.Code);
                        DMLines.SetRange("Attendance Confirmed", true);
                        if DMLines.Find('-') then
                            repeat
                                DelegateMemberss.Reset;
                                DelegateMemberss.SetRange(Code, DMLines."Delegate No.");
                                DelegateMemberss.SetRange(DelegateMemberss.Retired, false);
                                if DelegateMemberss.Find('-') then begin
                                    repeat
                                        LineNo += 1;
                                        DelegatePaymentLine.Init;
                                        DelegatePaymentLine."Entry No" := LineNo + 1;
                                        DelegatePaymentLine.Code := Code;
                                        DelegatePaymentLine."Delegate Group" := "Delegate Group";
                                        DelegatePaymentLine."Delegate MNO." := DelegateMemberss."Delegate MNO.";
                                        DelegatePaymentLine."Delegate Name" := DelegateMemberss."Delegate Name";
                                        DelegatePaymentLine.Position := DelegateMemberss.Position;
                                        DivTarriff.Reset();
                                        DivTarriff.SetRange("Delegate Region", DelegateMemberss.Code);
                                        DivTarriff.SetRange("Destination Code", Rec.Destination);
                                        //DivTarriff.SetRange("Payment Frequency", REc."Payment Frequency");

                                        DivTarriff.SetRange("Meeting Type", DMs."Meeting Type");
                                        if DivTarriff.Find('-') then begin
                                            DivTarriff.CalcSums(Amount);
                                            DelegatePaymentLine.Validate("Amount Payable", DivTarriff.Amount);
                                        end;
                                        DelegatePaymentLine."Job Tittle" := DelegateMemberss."Job Tittle";
                                        DelegatePaymentLine."Service Period" := DelegateMemberss."Service Period";
                                        DelegatePaymentLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                                        DelegatePaymentLine."Global Dimension 2 Code" := "Global Dimension 2 Code";
                                        DelegatePaymentLine."Electoral Zone" := DelegateGroupss."Electoral Zone";
                                        DelegatePaymentLine."Electoral Zone Name" := DelegateGroupss."Electoral Zone Name";
                                        DelegatePaymentLine."Period Ending Date" := "Period Ending Date";
                                        DelegatePaymentLine.Validate("Delegate MNO.");
                                        DelegatePaymentLine.Insert;
                                    until DelegateMemberss.Next = 0;
                                end;
                            until DMLines.Next() = 0;
                    end;

                    /*DelegateMemberss.Reset;
                    DelegateMemberss.SetRange(Code, "Delegate Group");
                    DelegateMemberss.SetRange(DelegateMemberss.Retired, false);
                    if DelegateMemberss.Find('-') then begin
                        repeat
                            LineNo += 1;
                            DelegatePaymentLine.Init;
                            DelegatePaymentLine."Entry No" := LineNo + 1;
                            DelegatePaymentLine.Code := Code;
                            DelegatePaymentLine."Delegate Group" := "Delegate Group";
                            DelegatePaymentLine."Delegate MNO." := DelegateMemberss."Delegate MNO.";
                            DelegatePaymentLine."Delegate Name" := DelegateMemberss."Delegate Name";
                            DelegatePaymentLine.Position := DelegateMemberss.Position;
                            DivTarriff.Reset();
                            DivTarriff.SetRange("Delegate Region", DelegateMemberss.Code);
                            DivTarriff.SetRange("Destination Code", Rec.Destination);
                            DivTarriff.SetRange("Payment Frequency", REc."Payment Frequency");
                            DMs.Reset();
                            DMs.SetRange(Code, rec."Minute No.");
                            if DMs.Find('-') then
                                DivTarriff.SetRange("Meeting Type", DMs."Meeting Type");
                            if DivTarriff.Find('-') then
                                DelegatePaymentLine.Validate("Amount Payable", DivTarriff.Amount);
                            DelegatePaymentLine."Job Tittle" := DelegateMemberss."Job Tittle";
                            DelegatePaymentLine."Service Period" := DelegateMemberss."Service Period";
                            DelegatePaymentLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                            DelegatePaymentLine."Global Dimension 2 Code" := "Global Dimension 2 Code";
                            DelegatePaymentLine."Electoral Zone" := DelegateGroupss."Electoral Zone";
                            DelegatePaymentLine."Electoral Zone Name" := DelegateGroupss."Electoral Zone Name";
                            DelegatePaymentLine."Period Ending Date" := "Period Ending Date";
                            DelegatePaymentLine.Validate("Delegate MNO.");
                            DelegatePaymentLine.Insert;
                        until DelegateMemberss.Next = 0;
                    end;*/
                end;
                Validate("Period Ending Date");
            end;
        }
        field(21; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(22; "Payment Description"; Text[50])
        {
            Caption = 'Description';
        }
        field(23; "Total Payment"; Decimal)
        {
            CalcFormula = Sum("Delegate Payment Line"."Amount Payable" WHERE(Code = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Delegates Payment"));
        }
        field(25; "Payment Frequency"; Option)
        {
            OptionCaption = ' ,Weekly,Monthly,Quartely,Semi Annual,Annual';
            OptionMembers = " ",Weekly,Monthly,Quartely,"Semi Annual",Annual;
        }
        field(26; "Period Ending Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                DelegatesPayments.Reset;
                DelegatesPayments.SetRange("Payment Frequency", "Payment Frequency");
                DelegatesPayments.SetRange("Electoral Zone", "Electoral Zone");
                DelegatesPayments.SetRange("Period Ending Date", "Period Ending Date");
                if DelegatesPayments.Find('-') then begin
                    Error('payment to has already been done using document %1', DelegatesPayments.Code);
                end;
            end;
        }
        field(27; "Payment Made To"; Text[50])
        {
        }
        field(28; "Minute No."; Code[30])
        {
            TableRelation = "Delegates Minutes Header".Code WHERE("Delegate Group" = FIELD("Delegate Group")/*,
                                                                   Posted = FILTER(true)*/);

            trigger OnValidate()
            var
                DMS: Record "Delegates Minutes Header";

            begin
                DMS.Reset();

                DMS.SetRange(Code, "Minute No.");
                if DMS.FindFirst() then
                    Validate(Destination, DMS.Destination);
            end;
        }
        field(29; "Approval Date"; Date)
        {
            Editable = false;
        }
        field(30; Destination; code[30])
        {

        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if Code = '' then begin
            MembNoSeries.Get;
            MembNoSeries.TestField(MembNoSeries."Delegate Payment Nos.");
            NoSeriesMgt.InitSeries(MembNoSeries."Delegate Payment Nos.", xRec."No. Series", 0D, Code, "No. Series");
            "Created By" := UserId;
            "Creation Date" := Today;
            "Document No." := Code;
        end;
    end;

    var
        ElectrolZonesAreaSvrCenter: Record "Electrol Zones/Area Svr Center";
        MembNoSeries: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SegmentCountyDividendSignat: Record "Segment/County/Dividend/Signat";
        DelegateGroupss: Record "Delegate Groupss";
        DelegateMemberss: Record "Delegate Memberss";
        DelegatePaymentLine: Record "Delegate Payment Line";
        DelegatePaymentLines: Record "Delegate Payment Line";
        MyRec2: Record "Delegate Payment Line";
        LineNo: Integer;
        DelegateGroups: Record "Delegate Groupss";
        DelegatesPayments: Record "Delegates Payment";
        DelegateGroup: Record "Delegate Groupss";
        DivTarriff: Record "Delegates Tariff";
}

