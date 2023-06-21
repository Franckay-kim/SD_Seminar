table 51532130 "Cheque Return Codes"
{
    //DrillDownPageID = "Cheque Return Codes";
    //LookupPageID = "Cheque Return Codes";

    fields
    {
        field(1; "Return Code"; Code[2])
        {
        }
        field(2; "Code Interpretation"; Text[100])
        {
        }
        field(3; Charges; Decimal)
        {
        }
        field(4; "Bounced Charges GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Charge Code"; Code[20])
        {
            TableRelation = "Transaction Types" WHERE(Type = CONST("Cheque Unpay"));
        }
    }

    keys
    {
        key(Key1; "Return Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Return Code", "Code Interpretation")
        {
        }
    }
}

