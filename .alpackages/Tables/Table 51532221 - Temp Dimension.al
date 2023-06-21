table 51532221 "Temp Dimension"
{
    Caption = 'Temp Dimensions';

    fields
    {
        field(1;"Dimension Code";Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(2;"Dimension Value Code";Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Dimension Code"));
        }
    }

    keys
    {
        key(Key1;"Dimension Code","Dimension Value Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'You can''t rename a %1.';
}

