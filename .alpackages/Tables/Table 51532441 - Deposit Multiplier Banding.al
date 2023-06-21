table 51532441 "Deposit Multiplier Banding"
{

    fields
    {
        field(1;Product;Code[20])
        {
        }
        field(2;"Lower Limit";Decimal)
        {
        }
        field(3;"Upper Limit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4;Multiplier;Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;Product,"Lower Limit")
        {
        }
    }

    fieldgroups
    {
    }
}

