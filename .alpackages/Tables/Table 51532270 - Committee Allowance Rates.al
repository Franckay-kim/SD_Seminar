table 51532270 "Committee Allowance Rates"
{

    fields
    {
        field(1;Committee;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Allowance;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;Position;Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Member,Chairperson,"Ass. Chairperson",Secretary,Treasurer;
        }
        field(4;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;Committee,Allowance,Position)
        {
        }
    }

    fieldgroups
    {
    }

    var
        BoardMembers: Record "Board Members";
}

