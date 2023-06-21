table 51532366 "STO Recovery Modes"
{
    //DrillDownPageID = "STO Recovery Modes";
    //LookupPageID = "STO Recovery Modes";

    fields
    {
        field(1; "Code"; Code[10])
        {
            TableRelation = "Credit Product Categories".Code;

            trigger OnValidate()
            begin
                CreditProductCategories.Get(Code);
                Description := CreditProductCategories.Description;
            end;
        }
        field(2; Description; Text[100])
        {
        }
        field(5; "STO No."; Code[10])
        {
            TableRelation = "Standing Order Header"."No.";
        }
    }

    keys
    {
        key(Key1; "Code", "STO No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CreditProductCategories: Record "Credit Product Categories";
}

