table 51532105 Coinage
{


    fields
    {
        field(1; No; Code[20])
        {
            TableRelation = "Treasury Cashier Transactions".No;
        }
        field(2; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Denominations;
        }
        field(3; Description; Text[50])
        {
        }
        field(4; Type; Option)
        {
            OptionMembers = Note,Coin;
        }
        field(5; Value; Decimal)
        {
        }
        field(6; Quantity; Integer)
        {

            trigger OnValidate()
            begin

                if Quantity <> 0 then
                    "Total Amount" := Quantity * Value
                else
                    "Total Amount" := 0;
            end;
        }
        field(7; "Total Amount"; Decimal)
        {

            trigger OnValidate()
            begin

                Quantity := "Total Amount" / Value;


                Validate(Quantity);
            end;
        }
    }

    keys
    {
        key(Key1; No, "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

