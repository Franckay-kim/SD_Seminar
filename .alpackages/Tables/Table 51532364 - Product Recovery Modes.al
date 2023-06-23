/// <summary>
/// Table Product Recovery Modes (ID 51532364).
/// </summary>
table 51532364 "Product Recovery Modes"
{
    //DrillDownPageID = 52018563;
    //LookupPageID = 52018563;

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
        field(3; "Maximum Concurrent Loans"; Integer)
        {
        }
        field(4; "Product ID"; Code[20])
        {
            TableRelation = "Product Factory";
        }
    }

    keys
    {
        key(Key1; "Code", "Product ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CreditProductCategories: Record "Credit Product Categories";
}

