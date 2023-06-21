table 51532390 "Loan Products to Bridge"
{

    fields
    {
        field(1; "Product Code"; Code[20])
        {
        }
        field(2; "Product To Bridge"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Loan));

            trigger OnValidate()
            begin
                if ProdFac.Get("Product To Bridge") then
                    "Product Name" := ProdFac."Product Description";

            end;
        }
        field(3; "Product Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Product Code", "Product To Bridge")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ProdFac: Record "Product Factory";
}

