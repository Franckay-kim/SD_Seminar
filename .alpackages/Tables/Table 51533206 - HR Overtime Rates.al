table 51533206 "HR Overtime Rates"
{

    fields
    {
        field(1;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Extra Hours Rate";Decimal)
        {
        }
        field(3;"Holiday Hours Rate";Decimal)
        {
        }
        field(4;"Weekend Hours Rate";Decimal)
        {
        }
        field(5;"Conversion Type";Option)
        {
            OptionCaption = ' ,Convert to Pay,Convert to Leave';
            OptionMembers = " ","Convert to Pay","Convert to Leave";
        }
    }

    keys
    {
        key(Key1;"Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

