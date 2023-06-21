table 51533389 "JV Header"
{
    //DrillDownPageId = "JV List";
    //LookupPageId = "JV List";


    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnValidate();
            var
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                IF "Document No." <> xRec."Document No." THEN BEGIN

                    NoSeriesMgt.TestManual("No. Series");
                    "No. Series" := '';
                END;
            end;
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate();
            begin
                IF "Account Type" <> xRec."Account Type" THEN
                    "Account No." := '';
            end;
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            /*TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Account Type" = CONST(Credit)) "Credit Accounts"; */

            trigger OnValidate();
            begin
                IF "Account No." <> xRec."Account No." THEN
                    Description := GetAccountDescription;
            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(6; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(14; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(15; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(17; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance (LCY)';
            Editable = false;
        }
        field(18; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(35; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(36; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup();
            var
                PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
                AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
                AccNo: Code[20];
            begin
            end;

            trigger OnValidate();
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
                TempGenJnlLine: Record "Gen. Journal Line" temporary;
            begin
            end;
        }
        field(42; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(43; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(47; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(48; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
        }
        field(52; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(76; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(77; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";
        }
        field(39004240; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            Editable = false;
            OptionMembers = Pending,"Pending Approval",Approved,Posted,Cancelled;
        }
        field(39004241; "Net Amount"; Decimal)
        {
            CalcFormula = Sum("JV Lines".Amount WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004242; "User Id"; Code[50])
        {
        }
        field(39004243; "No. Series"; Code[20])
        {
        }
        field(39004244; "Expense Code"; Code[10])
        {
            TableRelation = "Expense Code".Code;
        }
        field(39004245; Posted; Boolean)
        {
            Editable = false;
        }
        field(39004246; "DateTime Posted"; DateTime)
        {
        }
        field(39004247; "Posted By"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Document No." = '' THEN BEGIN
            CashOfficeSetup.GET;
            TestNoSeries;
            NoSeriesMgt.InitSeries(CashOfficeSetup."Journal Voucher Nos", xRec."No. Series", 0D, "Document No.", "No. Series");
        END;
        "Posting Date" := TODAY;
        "Document Date" := TODAY;
        "User Id" := USERID;
    end;

    trigger OnModify();
    begin
        if Status = Status::"Pending Approval" then Error('Modification not allowed for this status');
    end;

    var
        CashOfficeSetup: Record "Cash Office Setup";
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure TestNoSeries(): Boolean;
    begin
        CashOfficeSetup.TESTFIELD("Journal Voucher Nos")
    end;

    local procedure GetNoSeriesCode(): Code[10];
    var
        NoSrsRel: Record "No. Series Line";
        NoSeriesCode: Code[20];
    begin
        NoSeriesCode := CashOfficeSetup."Journal Voucher Nos";

        /*
        NoSrsRel.SETRANGE(NoSrsRel.Code,NoSeriesCode);
        //NoSrsRel.SETRANGE(NoSrsRel."Responsibility Center","Responsibility Center");
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
        EXIT(GetNoSeriesRelCode(NoSeriesCode));

    end;

    procedure ShowDimensions();
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', 'Journal Vopucher', "Document No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure GetNoSeriesRelCode(NoSeriesCode: Code[20]): Code[10];
    var
        GenLedgerSetup: Record "General Ledger Setup";
        RespCenter: Record "Responsibility CenterBR";
        DimMgt: Codeunit DimensionManagement;
        NoSrsRel: Record "No. Series Line";
    begin
        /*
        //EXIT(GetNoSeriesRelCode(NoSeriesCode));
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
            NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 1 Code");
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
           //END;
           END;
          ELSE EXIT(NoSeriesCode);
        END;
        */

    end;

    procedure GetAccountDescription(): Text[50];
    var
        GlAcc: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        BankAcc: Record "Bank Account";
    begin
        IF "Account Type" = "Account Type"::"G/L Account" THEN
            IF GlAcc.GET("Account No.") THEN
                EXIT(GlAcc.Name)
            ELSE
                IF "Account Type" = "Account Type"::"Bank Account" THEN
                    IF BankAcc.GET("Account No.") THEN
                        EXIT(BankAcc.Name)
                    ELSE
                        IF "Account Type" = "Account Type"::Vendor THEN
                            IF Vendor.GET("Account No.") THEN
                                EXIT(Vendor.Name)
                            ELSE
                                IF "Account Type" = "Account Type"::Customer THEN
                                    IF Customer.GET("Account No.") THEN
                                        EXIT(Customer.Name)
                                    ELSE
                                        EXIT('Description');
    end;
}

