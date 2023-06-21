table 51533102 "PR Bank Branches"
{

    fields
    {
        field(1; "Branch Code"; Code[10])
        {
        }
        field(2; "Branch Name"; Text[250])
        {
        }
        field(3; "Bank Code"; Code[10])
        {
            TableRelation = "PR Bank Accounts"."Bank Code";
        }
        field(4; "Bank Name"; Text[250])
        {
            CalcFormula = Lookup("PR Bank Accounts"."Bank Name" WHERE("Bank Code" = FIELD("Bank Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Branch Code", "Bank Code")
        {
        }
        key(Key2; "Branch Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Branch Code", "Branch Name")
        {
        }
    }
}

