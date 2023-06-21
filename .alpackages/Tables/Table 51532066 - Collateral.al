table 51532066 Collateral
{

    fields
    {
        field(1;"No.";Code[20])
        {
        }
        field(2;"Member No";Code[20])
        {
        }
        field(3;"Member Name";Text[70])
        {
        }
        field(4;"Date Collateralised";Date)
        {
        }
        field(5;"Collateral Value";Decimal)
        {
        }
        field(6;"Collateral Type";Option)
        {
            OptionCaption = ' ,Land,Motor Vehicles,Buildings,Chattels,Bonds and Stocks,Insurance Policies,Lien';
            OptionMembers = " ",Land,"Motor Vehicles",Buildings,Chattels,"Bonds and Stocks","Insurance Policies",Lien;
        }
        field(7;"Registration/Certificate No.";Code[20])
        {
        }
        field(8;"Internal Account(Lien)";Code[20])
        {
            TableRelation = "Savings Accounts"."No." WHERE ("No."=FIELD("No."));
        }
        field(9;Serial;Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Member No",Serial)
        {
        }
    }

    fieldgroups
    {
    }
}

