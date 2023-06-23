/// <summary>
/// Table Receipts Header (ID 51532217).
/// </summary>
table 51532217 "Receipts Header"
{

    //LookupPageId = "Posted Receipt List";
    //DrillDownPageId = "Posted Receipt List";
    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the code of the receipt in the database';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    GenLedgerSetup.Get;
                    NoSeriesMgt.TestManual(GenLedgerSetup."Receipts No");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the receipt was entered into the system';

            trigger OnValidate()
            begin
                if Date > Today then Error('You can not post with a future date');
            end;
        }
        field(3; Cashier; Code[50])
        {
            Description = 'Stores the user id of the cashier';
        }
        field(4; "Date Posted"; Date)
        {
        }
        field(5; "Time Posted"; Time)
        {
        }
        field(6; Posted; Boolean)
        {
        }
        field(7; "No. Series"; Code[20])
        {
        }
        field(8; "Bank Code"; Code[20])
        {
            /* TableRelation = "Bank Account"."No." WHERE("Responsibility Center" = FIELD("Responsibility Center"),
                                                         "Currency Code" = FIELD("Currency Code"));*/

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Receipt lines before changing the Currency Code'
                    );
                end;
                if bank.Get("Bank Code") then
                    "Bank Name" := bank.Name;
            end;
        }
        field(9; "Received From"; Text[100])
        {
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; "Amount Recieved"; Decimal)
        {
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");

                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    Dim1 := DimVal.Name
            end;
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");

                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    Dim2 := DimVal.Name
            end;
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Receipt lines before changing the Currency Code'
                    );
                end else begin
                    "Bank Code" := '';
                end;
            end;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(38; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Receipt Line"."Total Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Posted By"; Code[50])
        {
        }
        field(40; "Print No."; Integer)
        {
        }
        field(41; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(42; "Cheque No."; Code[20])
        {
        }
        field(43; "No. Printed"; Integer)
        {
        }
        field(44; "Created By"; Code[50])
        {
        }
        field(45; "Created Date Time"; DateTime)
        {
        }
        field(46; "Register No."; Integer)
        {
        }
        field(47; "From Entry No."; Integer)
        {
        }
        field(48; "To Entry No."; Integer)
        {
        }
        field(49; "Document Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Document Date" > Today then Error('You can not post with a future date');
            end;
        }
        field(81; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Receipt lines before changing the Currency Code');
                end else begin
                    "Bank Code" := '';
                end;


                TestField(Status, Status::Open);
                /*if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
                /*
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(83; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(3, "Shortcut Dimension 3 Code");
                Validate("Shortcut Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(84; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(4, "Shortcut Dimension 4 Code");
                Validate("Shortcut Dimension 4 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(86; Dim3; Text[250])
        {
        }
        field(87; Dim4; Text[250])
        {
        }
        field(88; "Bank Name"; Text[250])
        {
        }
        field(89; "Receipt Type"; Option)
        {
            OptionCaption = 'Bank,Cash';
            OptionMembers = Bank,Cash;
        }
        field(90; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            // OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        }
        field(91; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            /*TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            //IF ("Account Type" = CONST("Bank Account"),
            //                                                                                       "Pay Mode" = CONST(Cash)) "Bank Account"."No." WHERE("Bank Type" = FILTER(Cashier | "Chq Collection" | Cash))
            //ELSE
            /*IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"

            ELSE
            //IF ("Account Type" = CONST("Bank Account"),
            //                                                                                                "Pay Mode" = FILTER(<> Cheque & <> MR & <> Cash & <> "Bank Deposits" & <> " ")) "Bank Account" WHERE("Bank Type" = FILTER(Normal | "Chq Collection"))
            //ELSE
            IF ("Account Type" = CONST("Bank Account"),
                                                                                                                     "Pay Mode" = FILTER(Cheque | "Bank Deposits")) "Bank Account" /*WHERE("Bank Type" = CONST("Chq Collection"))
            ELSE
            IF ("Account Type" = CONST("Bank Account"),
                                                                                                                             "Pay Mode" = CONST(MR)) "Bank Account" WHERE("Bank Type" = CONST(MR)); */

            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::"Bank Account" then begin
                    bank.Reset;
                    bank.SetRange("No.", "Account No.");
                    if bank.Find('-') then
                        //bank.GET("Account No.");
                        "Bank Account Name" := bank.Name;
                end;
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(481; Dim1; Text[250])
        {
        }
        field(482; Dim2; Text[250])
        {
        }
        field(483; "Group Code"; Code[20])
        {
            Description = '//To gather for Micro Credit Groups to filter its members';
            TableRelation = Members."No." WHERE("Group Account" = FILTER(true));

            trigger OnValidate()
            begin
                if Members.Get("Group Code") then
                    "Group Name" := Members.Name;
            end;
        }
        field(484; "Group Name"; Text[100])
        {
            Editable = false;
        }
        field(485; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members WHERE(Status = CONST(Active));

            trigger OnValidate()
            begin
                "Received From" := '';
                "Member Station" := '';
                Members.Get("Member No.");
                "Received From" := Members.Name;

                if Members.Status <> Members.Status::Active then
                    Error('Member is not Active');


                if "Member Station" = '' then begin
                    if Cust.Get(Members."Employer Code") then
                        "Member Station" := Cust.Name;
                end;
                if Members.Get("Member No.") then
                    "Global Dimension 1 Code" := Members."Global Dimension 1 Code";
                "Shortcut Dimension 2 Code" := Members."Global Dimension 2 Code";
            end;
        }
        field(486; "Pay Mode"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,MR,PayBill,"Bank Deposits";

            trigger OnValidate()
            begin
                GenLedgerSetup.Reset;
                GenLedgerSetup.Get();
                "Account No." := '';
                "Bank Account Name" := '';
                RLine.Reset;
                RLine.SetRange(No, Rec."No.");
                if RLine.FindFirst then begin
                    repeat
                        RLine."Pay Mode" := Rec."Pay Mode";
                        RLine."Cheque/Deposit Slip No" := Rec."Cheque No.";
                        RLine."Cheque/Deposit Slip Date" := Today;
                        RLine.Modify;
                    until RLine.Next = 0;
                end;
            end;
        }
        field(487; "Cheque/Deposit Slip No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(488; "Cheque/Deposit Slip Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*
                GenLedgerSetup.GET;
                IF CALCDATE(GenLedgerSetup."Cheque Reject Period","Cheque/Deposit Slip Date")<=TODAY THEN
                  BEGIN
                    ERROR('The cheque date is not within the allowed range.');
                  END;
                
                CheckSlipDetails();
                 */

            end;
        }
        field(489; "Cheque/Deposit Slip Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " "," Local","Up Country";
        }
        field(490; "Member Station"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(491; "Bank Account Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(39005483; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Member No." := '';
                "Member Station" := '';
                if "Staff No." = '' then begin
                    Members.Reset;
                    Members.SetRange("Payroll/Staff No.", "Staff No.");
                    if Members.FindFirst then
                        Validate("Member No.", Members."No.");
                end;



                if Members.Status = Members.Status::Active then
                    Error('Member is not Active');


                if "Member Station" = '' then begin
                    if Cust.Get(Members."Employer Code") then
                        "Member Station" := Cust.Name;
                end;
            end;
        }
        field(39005484; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39005485; Narration; Text[120])
        {
            DataClassification = ToBeClassified;
        }
        field(39005486; "Bank Ref No"; Code[20])
        {
            DataClassification = ToBeClassified;
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
        fieldgroup(Dropdown; "No.", "Received From")
        {

        }
    }

    trigger OnDelete()
    begin
        Error('You Cannot Delete this record');
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GenLedgerSetup.Get;
            TestNoSeries;
            //NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series",0D,"No.","No. Series");
            NoSeriesMgt.InitSeries(GenLedgerSetup."Receipts No", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        UserTemplate.Reset;
        UserTemplate.SetRange(UserTemplate.UserID, UserId);
        if UserTemplate.FindFirst then begin
            //"Bank Code":=UserTemplate."Default Receipts Bank";
            //VALIDATE("Bank Code");
            Cashier := UserId;
        end;
        //*****************************JACK**************************//
        "Created By" := UserId;
        "Created Date Time" := CreateDateTime(Today, Time);
        "Document Date" := Today;
        Date := Today;
        //*****************************END***************************//
        //STIMA
        //Usersetup.Reset;
        //Usersetup.SetRange("User ID", UserId);
        //if Usersetup.Find('-') then
        //"Responsibility Center" := Usersetup."Responsibility Centre";

        //Usersetup.TestField("Responsibility Centre");
        //Usersetup.TestField("Global Dimension 1 Code");
        //Usersetup.TestField("Global Dimension 2 Code");

        //"Global Dimension 1 Code" := Usersetup."Global Dimension 1 Code";
        //"Responsibility Center" := Usersetup."Responsibility Centre";
        //"Shortcut Dimension 2 Code" := Usersetup."Global Dimension 2 Code";
    end;

    trigger OnModify()
    begin
        RLine.Reset;
        RLine.SetRange(RLine.No, "No.");
        if RLine.FindFirst then begin
            repeat
                RLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                RLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                RLine."Dimension Set ID" := "Dimension Set ID";
                RLine.Modify;
            until RLine.Next = 0;
        end;
    end;

    var
        GenLedgerSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserTemplate: Record "Cash Office User Template";
        RLine: Record "Receipt Line";
        RespCenter: Record "Responsibility CenterBR";
        //UserMgt: Codeunit "User Setup Management BR";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        DimVal: Record "Dimension Value";
        bank: Record "Bank Account";
        DimMgt: Codeunit DimensionManagement;
        Members: Record Members;
        Usersetup: Record "User Setup";
        //Station: Record "Segment/County/Dividend/Signat";
        Cust: Record Customer;

    /// <summary>
    /// PayLinesExist.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure PayLinesExist(): Boolean
    begin
        RLine.Reset;
        RLine.SetRange(RLine.No, "No.");
        exit(RLine.FindFirst);
    end;

    local procedure TestNoSeries(): Boolean
    begin
        if "Receipt Type" = "Receipt Type"::Bank then
            GenLedgerSetup.TestField(GenLedgerSetup."Receipts No")
        else
            GenLedgerSetup.TestField(GenLedgerSetup."Cash Receipt Nos")
    end;

    local procedure GetNoSeriesCode(): Code[10]
    var
        NoSrsRel: Record "No. Series Relationship";
        NoSeriesCode: Code[20];
    begin
        if "Receipt Type" = "Receipt Type"::Bank then
            NoSeriesCode := GenLedgerSetup."Receipts No"
        else
            NoSeriesCode := GenLedgerSetup."Cash Receipt Nos";

        exit(GetNoSeriesRelCode(NoSeriesCode));
        /*
        NoSrsRel.SETRANGE(NoSrsRel.Code,NoSeriesCode);
        NoSrsRel.SETRANGE(NoSrsRel."Responsibility Center","Responsibility Center");
        
        IF NoSrsRel.FINDFIRST THEN
        EXIT(NoSrsRel."Series Code")
        ELSE
        EXIT(NoSeriesCode);
        
        IF NoSrsRel.FINDSET THEN BEGIN
          IF PAGE.RUNMODAL(458,NoSrsRel,NoSrsRel."Series Code") = ACTION::LookupOK THEN
          EXIT(NoSrsRel."Series Code")
        END
        ELSE
        EXIT(NoSeriesCode);
        */

    end;

    /// <summary>
    /// ShowDimensions.
    /// </summary>
    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Receipt', "No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    /// <summary>
    /// ValidateShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    /// <summary>
    /// LookupShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    /// <summary>
    /// ShowShortcutDimCode.
    /// </summary>
    /// <param name="ShortcutDimCode">VAR array[8] of Code[20].</param>
    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    /// <summary>
    /// GetNoSeriesRelCode.
    /// </summary>
    /// <param name="NoSeriesCode">Code[20].</param>
    /// <returns>Return value of type Code[10].</returns>
    procedure GetNoSeriesRelCode(NoSeriesCode: Code[20]): Code[10]
    var
        GenLedgerSetup: Record "General Ledger Setup";
        RespCenter: Record "Responsibility CenterBR";
        DimMgt: Codeunit DimensionManagement;
        NoSrsRel: Record "No. Series Relationship";
    begin
        exit(GetNoSeriesRelCode(NoSeriesCode));
        /*
        GenLedgerSetup.GET;
        CASE GenLedgerSetup."Base No. Series" OF
          GenLedgerSetup."Base No. Series"::"1":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Responsibility Center");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          GenLedgerSetup."Base No. Series"::"2":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Global Dimension 1 Code");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          GenLedgerSetup."Base No. Series"::"3":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 2 Code");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          GenLedgerSetup."Base No. Series"::"4":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 3 Code");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          GenLedgerSetup."Base No. Series"::"5":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 4 Code");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          ELSE EXIT(NoSeriesCode);
        END;
        */

    end;
}

