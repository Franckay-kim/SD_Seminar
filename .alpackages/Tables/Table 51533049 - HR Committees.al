table 51533049 "HR Committees"
{
    //DrillDownPageID = "HR Committees";
    //LookupPageID = "HR Committees";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200])
        {
            NotBlank = true;
        }
        field(3; Roles; Text[200])
        {
        }
        field(4; "Transaction Amount"; Decimal)
        {
        }
        field(5; "Transaction Code"; Code[45])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code";
        }
        field(6; "Monetary Benefit?"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

