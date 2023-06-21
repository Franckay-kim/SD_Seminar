table 51532237 "Board Allowance"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Description;Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Tax %";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Tax GL";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(5;"Minimum Taxable Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Maximum Taxable Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Minimum Tax";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Maximum Tax";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Allowance GL";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

