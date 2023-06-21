table 51533390 "JV Lines"
{
    // version FundsV1.1


    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            /* TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
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

            trigger OnValidate();
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    GetCurrency;
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       ("Posting Date" <> xRec."Posting Date") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                VALIDATE("Currency Factor");
            end;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate();
            begin
                IF Amount > 0 THEN BEGIN
                    "Debit Amount" := Amount;
                    "Credit Amount" := 0;
                END
                ELSE BEGIN
                    "Debit Amount" := 0;
                    "Credit Amount" := -Amount;
                END;

                IF "Currency Factor" <> 0 THEN
                    "Amount (LCY)" := Amount * 1 / "Currency Factor" ELSE
                    "Amount (LCY)" := Amount;
            end;
        }
        field(14; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';

            trigger OnValidate();
            begin
                Amount := "Debit Amount";
                "Credit Amount" := 0;
                VALIDATE(Amount);
            end;
        }
        field(15; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';

            trigger OnValidate();
            begin
                Amount := -"Credit Amount";
                "Debit Amount" := 0;
                VALIDATE(Amount);
            end;
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
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

            trigger OnValidate();
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
            end;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
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
        field(39004244; "Expense Code"; Code[10])
        {
            TableRelation = "Expense Code".Code;
        }
        field(39004245; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {

        }
        field(39004246; "Bal Account No."; Code[20])
        {
            Caption = 'Bal Account No.';
            /* TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Bal. Account Type" = CONST(Credit)) "Credit Accounts"; */

            trigger OnValidate();
            begin

            end;
        }

    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        /*Header.GET("Document No.");
        "Shortcut Dimension 1 Code" := Header."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Header."Shortcut Dimension 2 Code";*/
    end;

    trigger OnDelete();
    var
        PHead: Record "JV Header";
    begin
        PHead.Reset;
        PHead.SetRange(PHead."Document No.", Rec."Document No.");
        if PHead.FindFirst then begin
            if
            (PHead.Status = PHead.Status::Approved) or
             (PHead.Status = PHead.Status::Posted) or
            (PHead.Status = PHead.Status::"Pending Approval") or (PHead.Status = PHead.Status::Cancelled) then
                Error('You Cannot Delete this record its already approved/posted/Send for Approval');
        end;
    end;

    var
        Header: Record "JV Header";
        DimMgt: Codeunit DimensionManagement;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[10];
        Text002: Label 'cannot be specified without %1';

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

    local procedure GetCurrency();
    begin
        /*
        IF "Additional-Currency Posting" =
           "Additional-Currency Posting"::"Additional-Currency Amount Only"
        THEN BEGIN
          IF GLSetup."Additional Reporting Currency" = '' THEN
            ReadGLSetup;
          CurrencyCode := GLSetup."Additional Reporting Currency";
        END ELSE
          */
        CurrencyCode := "Currency Code";

        IF CurrencyCode = '' THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision
        END ELSE
            IF CurrencyCode <> Currency.Code THEN BEGIN
                Currency.GET(CurrencyCode);
                Currency.TESTFIELD("Amount Rounding Precision");
            END;

    end;
}

