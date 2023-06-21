table 51532341 "Interest Rates Per Period"
{

    fields
    {
        field(1; Product; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Loan Period Limit"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Interest Rate (Annual)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Product, "Loan Period Limit")
        {
        }
    }

    fieldgroups
    {
    }
}

