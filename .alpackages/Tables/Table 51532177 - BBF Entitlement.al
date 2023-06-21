table 51532177 "BBF Entitlement"
{

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Sacco Amount";Decimal)
        {
        }
        field(4;"Max No.";Integer)
        {
        }
        field(5;Minor;Boolean)
        {
        }
        field(6;Self;Boolean)
        {
        }
        field(7;Entitlement;Text[80])
        {
            TableRelation = "Relationship Types";

            trigger OnValidate()
            begin
                if Relations.Get(Entitlement) then
                  Description:=Relations.Description;
            end;
        }
        field(50050;"Insurance Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Relations: Record "Relationship Types";
}

