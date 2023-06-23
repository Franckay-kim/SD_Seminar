/// <summary>
/// Table Delegates Tariff (ID 51532349).
/// </summary>
table 51532349 "Delegates Tariff"
{
    //DrillDownPageID = "Delegate Tariffs";
    //LookupPageID = "Delegate Tariffs";

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
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
            IF ("Account Type" = CONST(Credit)) "Credit Accounts";
        }
        field(5; CalculationMethod; Option)
        {
            Caption = 'Description';
            OptionCaption = 'Amount,Milleage';
            OptionMembers = Amount,Milleage;
        }
        field(6; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(9; "Rate Per KM"; Decimal)
        {
        }
        field(15; "Payment Frequency"; Option)
        {
            OptionCaption = ' ,Weekly,Monthly,Quartely,Semi Annual,Annual';
            OptionMembers = " ",Weekly,Monthly,Quartely,"Semi Annual",Annual;
        }
        field(16; "Maximum No Paid"; Decimal)
        {
        }
        field(17; Taxable; Boolean)
        {

        }
        field(18; "Tax G/L"; code[20])
        {
            TableRelation = "G/L Account";
        }
        field(19; "Delegate Region"; Code[20])
        {
            TableRelation = "Delegate Groupss";
        }
        field(20; "Meeting Type"; Option)
        {
            OptionMembers = ,AGM,ADM,SGM,Education,Regional;
        }
        field(21; "Destination Code"; Code[30])
        {
            TableRelation = "Travel Destination"."Destination Code";
            trigger OnValidate()
            var
                TDest: Record "Travel Destination";
            begin
                TDest.Reset();
                TDest.SetRange("Destination Code", "Destination Code");
                if TDest.FindFirst() then
                    "Destination Name" := TDest."Destination Name";
            end;
        }
        field(22; "Destination Name"; Text[50])
        {

        }
        field(23; Diocese; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Diocese.Code;
            trigger OnValidate()

            begin
                Diocese := UpperCase(Diocese);
            end;
        }
        field(24; "Arch Diocese"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Parish.Code where("Diocese Code" = field(Diocese));
            trigger OnValidate()

            begin
                "Arch Diocese" := UpperCase("Arch Diocese");
            end;
        }
        field(25; County; Code[50])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
        }
        field(26; Town; Code[50])
        {
            Caption = 'Town';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Code", "Delegate Region")
        {
        }
    }

    fieldgroups
    {
    }
}

