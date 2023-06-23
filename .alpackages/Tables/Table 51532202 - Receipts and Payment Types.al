/// <summary>
/// Table Receipts and Payment Types (ID 51532202).
/// </summary>
table 51532202 "Receipts and Payment Types"
{
    //DrillDownPageID = "Receipt and Payment Types List";
    //LookupPageID = "Receipt and Payment Types List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {

            trigger OnValidate()
            begin

                PayLine.Reset;
                PayLine.SetRange(PayLine.Type, Code);
                if PayLine.Find('-') then
                    Error('This Transaction Code Is Already in Use You cannot Modify');

                PayLine.Reset;
                PayLine.SetRange(PayLine.Type, Code);
                if PayLine.Find('-') then
                    Error('This Transaction Code Is Already in Use You Cannot Delete');
            end;
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Savings,Credit';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;

            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::"G/L Account" then
                    "Direct Expense" := true
                else
                    "Direct Expense" := false;

                PayLine.Reset;
                PayLine.SetRange(PayLine.Type, Code);
                if PayLine.Find('-') then
                    Error('This Transaction Code Is Already in Use You cannot Modify');
            end;
        }
        field(4; Type; Option)
        {
            NotBlank = true;
            OptionMembers = " ",Receipt,Payment,Imprest,Claim,Advance;
        }
        field(5; "VAT Chargeable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(6; "Withholding Tax Chargeable"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(7; "VAT Code"; Code[20])
        {
            TableRelation = "Tariff Code s";
        }
        field(8; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "Tariff Code s";
        }
        field(9; "Default Grouping"; Code[20])
        {
            /*TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group"
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account Posting Group"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "FA Posting Group"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST("G/L Account")) "Expense Code"
            ELSE
            IF ("Account Type" = FILTER(Credit)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = FILTER(Savings)) "Customer Posting Group";*/
        }
        field(10; "G/L Account"; Code[20])
        {
            //TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE("Expense Code" = FIELD("Default Grouping"));

            trigger OnValidate()
            begin
                GLAcc.Reset;
                if GLAcc.Get("G/L Account") then begin

                    /*if Type = Type::Payment then
                        GLAcc.TestField(GLAcc."Budget Controlled", true);*/

                    if GLAcc."Direct Posting" = false then begin
                        Error('Direct Posting must be True');
                    end;
                end;

                // PayLine.RESET;
                // PayLine.SETRANGE(PayLine.Type,Code);
                // IF PayLine.FIND('-') THEN
                //    ERROR('This Transaction Code Is Already in Use You Cannot Delete');
            end;
        }
        field(11; "Pending Voucher"; Boolean)
        {
        }
        field(12; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                if "Account Type" <> "Account Type"::"Bank Account" then begin
                    Error('You can only enter Bank No where Account Type is Bank Account');
                end;
            end;
        }
        field(13; "Transation Remarks"; Text[250])
        {
            NotBlank = true;
        }
        field(14; "Payment Reference"; Option)
        {
            OptionMembers = Normal,"Farmer Purchase",Grant,Investment;
        }
        field(15; "Customer Payment On Account"; Boolean)
        {
        }
        field(16; "Direct Expense"; Boolean)
        {
            Editable = false;
        }
        field(17; "Calculate Retention"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(18; "Retention Code"; Code[20])
        {
            TableRelation = "Tariff Code s";
        }
        field(19; Blocked; Boolean)
        {
        }
        field(20; "Based On Travel Rates Table"; Boolean)
        {
        }
        field(21; "VAT Withholding Code"; Code[10])
        {
            Editable = true;
            TableRelation = "Tariff Code s".Code;
        }
        field(22; "VAT Deductible"; Boolean)
        {
        }
        field(23; Amount; Decimal)
        {
        }
        field(24; "Daily Tax Exempt. Amount"; Decimal)
        {
        }
        field(25; "Is Medical Claim"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.Type, Code);
        if PayLine.Find('-') then
            Error('This Transaction Code Is Already in Use You Cannot Delete');
    end;

    trigger OnInsert()
    begin
        "Direct Expense" := true;
    end;

    var
        GLAcc: Record "G/L Account";
        PayLine: Record "Payment Line";
}

