/// <summary>
/// Table Tariff Code s (ID 51532204).
/// </summary>
table 51532204 "Tariff Code s"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Percentage; Decimal)
        {
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No.";
        }
        field(5; Type; Option)
        {
            OptionMembers = " ","W/Tax",VAT,Excise,Others,Retention,PAYE,"W/Rent";
        }
        field(12; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            var
                PayLines: Record "Payment Line";
            begin
            end;
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

    trigger OnDelete()
    begin
        /*
        PaymentLine.RESET;
        PaymentLine.SETRANGE(PaymentLine."VAT Code",Code);
        IF PaymentLine.FIND('-') THEN
           ERROR('You cannot delete the %1 Code its already used',Type);

        PaymentLine.RESET;
        PaymentLine.SETRANGE(PaymentLine."Withholding Tax Code",Code);
        IF PaymentLine.FIND('-') THEN
           ERROR('You cannot delete the %1 Code its already used',Type);
           */

    end;

    var
        PaymentLine: Record "Payment Line";
}

