table 51532443 "Deposit Contribution Bands"
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
        field(4;"Qualifying Amount";Decimal)
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

