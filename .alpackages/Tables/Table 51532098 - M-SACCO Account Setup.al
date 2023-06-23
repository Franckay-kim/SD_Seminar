/// <summary>
/// Table M-SACCO Account Setup (ID 51532098).
/// </summary>
table 51532098 "M-SACCO Account Setup"
{

    fields
    {
        field(1; "Account Type"; Code[30])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Bank Account No"; Code[50])
        {
            TableRelation = "Bank Account";
        }
        field(4; "Vendor No"; Code[10])
        {
            TableRelation = Vendor;
        }
        field(5; ChargeAmount; Decimal)
        {
        }
        field(6; "G/L Account"; Code[30])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(7; Type; Option)
        {
            OptionCaption = ' ,Coretec Account,Paybill Bank,Utility Bank,Invalid Paybill';
            OptionMembers = " ","Coretec Account","Paybill Bank","Utility Bank","Invalid Paybill";

            trigger OnValidate()
            begin
                //ccc
            end;
        }
        field(8; "Instant Loan Share (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Account Type")
        {
        }
    }

    fieldgroups
    {
    }
}

