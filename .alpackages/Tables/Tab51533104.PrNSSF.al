table 51533104 PrNSSF
{
    Caption = 'PrNSSF';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tier Code"; Code[10])
        {
            SQLDataType = Integer;
        }
        field(2; "NSSF Tier"; Decimal)
        {
        }
        field(3; Amount; Decimal)
        {
        }
        field(4; "Lower Limit"; Decimal)
        {
        }
        field(5; "Upper Limit"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Tier Code")
        {
        }
    }

    fieldgroups
    {
    }
}
