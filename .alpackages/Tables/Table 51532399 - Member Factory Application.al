/// <summary>
/// Table Member Factory Application (ID 51532399).
/// </summary>
table 51532399 "Member Factory Application"
{

    fields
    {
        field(1; "Application No"; Code[20])
        {
        }
        field(2; "Factory Code"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST(Factory));

            trigger OnValidate()
            begin
                "Factory Name" := '';
                Cat.SetRange(Type, Cat.Type::Factory);
                Cat.SetRange(Code, "Factory Code");
                if Cat.FindFirst then
                    "Factory Name" := Cat.Description;
            end;
        }
        field(3; "Factory Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Factory/Society No."; Code[20])
        {

            trigger OnValidate()
            begin

                if "Factory/Society No." <> '' then begin
                    Validate("Factory Code", CopyStr("Factory/Society No.", 1, 2));
                    Validate("Buying Center Code", CopyStr("Factory/Society No.", 3, 3));
                end;
            end;
        }
        field(5; "Buying Center Code"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Buying Centre"));

            trigger OnValidate()
            begin
                "Buying Center Name" := '';
                Cat.SetRange(Type, Cat.Type::"Buying Centre");
                Cat.SetRange(Code, "Buying Center Code");
                if Cat.FindFirst then
                    "Buying Center Name" := Cat.Description;
            end;
        }
        field(6; "Buying Center Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Exempt Deposit"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Application No", "Factory/Society No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cat: Record "Electrol Zones/Area Svr Center";
}

