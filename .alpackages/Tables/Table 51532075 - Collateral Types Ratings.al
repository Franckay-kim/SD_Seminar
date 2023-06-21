table 51532075 "Collateral Types Ratings"
{

    fields
    {
        field(1;"Collateral Type";Option)
        {
            OptionCaption = ' ,Land,Motor Vehicles,Buildings,Chattels,Bonds and Stocks,Insurance Policies,Lien';
            OptionMembers = " ",Land,"Motor Vehicles",Buildings,Chattels,"Bonds and Stocks","Insurance Policies",Lien;
        }
        field(2;"Collateral % Applicable";Decimal)
        {
            MaxValue = 100;
            MinValue = 1;
        }
    }

    keys
    {
        key(Key1;"Collateral Type")
        {
        }
    }

    fieldgroups
    {
    }
}

