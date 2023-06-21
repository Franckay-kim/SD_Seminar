table 51532402 "Member Class"
{

    fields
    {
        field(1;"Application No";Code[20])
        {
        }
        field(2;"Member Class";Code[20])
        {
            TableRelation = "Member Category"."No.";

            trigger OnValidate()
            begin

                "Product ID":='';
                Cat.Get("Member Class");
                Cat.TestField("Product ID");
                "Product ID":=Cat."Product ID";
            end;
        }
        field(3;"Product ID";Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Application No","Member Class")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cat: Record "Member Category";
}

