table 51532331 "Agent Next Of Kin Details"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Document No";Code[20])
        {
        }
        field(3;"Next Of Kin Name";Text[100])
        {
        }
        field(4;"Next Of Kin RelationShip";Code[10])
        {
            TableRelation = "Relationship Types";
        }
        field(5;"Next Of Kin ID";Text[30])
        {
        }
        field(6;"Next Of Kin Phone";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

