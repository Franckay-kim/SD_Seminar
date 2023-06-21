table 51533077 "HR Training Bonding Conditions"
{

    fields
    {
        field(1;"Code";Code[10])
        {
            Editable = false;
        }
        field(2;"Condition Type";Option)
        {
            OptionMembers = " ","Percentage of Training Cost","Total Training Cost",Duration;
        }
        field(3;"Minimum Amount";Decimal)
        {
        }
        field(4;"Maximum Amount";Decimal)
        {
        }
        field(5;"Condition Description";Text[100])
        {
        }
        field(6;"Training Bonding Code";Code[20])
        {
        }
        field(7;"Line No.";Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Code","Training Bonding Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRTrainingNeeds: Record "HR Training Needs";
}

