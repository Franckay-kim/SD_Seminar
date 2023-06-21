table 51532097 "M-SACCO Paybill Keywords"
{

    fields
    {
        field(1; Keyword; Text[50])
        {
            NotBlank = true;
        }
        field(2; "Loan Code"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
        }
        field(3; "Destination Type"; Option)
        {
            OptionMembers = "None","Loan Repayment","Shares Capital","Deposit Contribution","Benevolent Funds";
        }
    }

    keys
    {
        key(Key1; Keyword)
        {
        }
    }

    fieldgroups
    {
    }
}

