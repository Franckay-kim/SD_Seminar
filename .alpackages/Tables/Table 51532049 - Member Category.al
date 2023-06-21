table 51532049 "Member Category"
{
    //LookupPageID = "Member Category";

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(5; "Registration Fee"; Decimal)
        {
        }
        field(6; "Minimum Share Capital"; Decimal)
        {
        }
        field(7; "Max. Installment"; Integer)
        {
        }
        field(8; "Monthly Share Capital"; Decimal)
        {
        }
        field(9; "Monthly Share Deposit"; Decimal)
        {
        }
        field(10; Checkoff; Boolean)
        {
        }
        field(11; "Can Take Loan"; Boolean)
        {
        }
        field(12; "Auto Generate Staff No"; Boolean)
        {
        }
        field(13; Acronym; Code[10])
        {
        }
        field(14; Remarks; Text[100])
        {
        }
        field(15; "Premier Club Min.Deposits"; Decimal)
        {
        }
        field(16; "Member No. Series"; Code[20])
        {
        }
        field(17; "Member Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "Product ID"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class Type" = FILTER(Savings));
        }
        field(19; "Minimum Benevolent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Monthly Benevolent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Employer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

