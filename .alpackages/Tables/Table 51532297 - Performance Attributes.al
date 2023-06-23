/// <summary>
/// Table Performance Attributes (ID 51532297).
/// </summary>
table 51532297 "Performance Attributes"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal No"; Code[50])
        {
        }
        field(3; Attribute; Code[50])
        {
            /*TableRelation = Attributes.Attribute;

            trigger OnValidate()
            begin
                Attributes.Reset;
                Attributes.SetRange(Attributes.Attribute,Attribute);
                if Attributes.Find('-') then
                  Description:=Attributes.Description;
            end;*/
        }
        field(4; Description; Text[250])
        {
            Editable = false;
        }
        field(5; Target; Decimal)
        {
        }
        field(6; Weight; Decimal)
        {
        }
        field(7; "Additional Comments"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Line No.", "Appraisal No")
        {
        }
    }

    fieldgroups
    {
    }

    var
    //Attributes: Record Attributes;
}

