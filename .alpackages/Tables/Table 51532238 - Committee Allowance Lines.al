table 51532238 "Committee Allowance Lines"
{

    fields
    {
        field(1;"Header Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Allowance Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Board Allowance";

            trigger OnValidate()
            begin
                "Allowance Description" := '';
                "Tax %" := 0;
                "Tax GL" := '';
                "Minimum Taxable Amount" := 0;
                "Minimum Tax" :=0;
                "Maximum Taxable Amount" := 0;
                "Maximum Tax" :=0;

                if "Allowance Code" <> '' then begin
                    BoardAllowance.Get("Allowance Code");
                    "Allowance Description" := BoardAllowance.Description;
                    "Tax %" := BoardAllowance."Tax %";
                    "Tax GL" := BoardAllowance."Tax GL";
                    "Minimum Taxable Amount" := BoardAllowance."Minimum Taxable Amount";
                    "Minimum Tax" := BoardAllowance."Minimum Tax";
                    "Maximum Taxable Amount" := BoardAllowance."Maximum Taxable Amount";
                    "Maximum Tax" :=BoardAllowance."Maximum Tax";
                    "Allowance GL" := BoardAllowance."Allowance GL";
                end;
            end;
        }
        field(3;"Allowance Description";Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Tax %";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Tax GL";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(6;"Minimum Taxable Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Maximum Taxable Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Minimum Tax";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Maximum Tax";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Allowance GL";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(11;"Pay to Savings Account";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Header Code","Allowance Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        BoardAllowance: Record "Board Allowance";
}

