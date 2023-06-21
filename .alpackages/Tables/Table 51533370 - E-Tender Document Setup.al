table 51533370 "E-Tender Document Setup"
{
    // version EProcurement


    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[250])
        {
        }
        field(3; Mandatory; Boolean)
        {
        }
        field(4; Category; Option)
        {
            OptionCaption = ',Financial,Supervisory,Business,Registration,Partners,Directors';
            OptionMembers = ,Financial,Supervisory,Business,Registration,Partners,Directors;
        }
        field(5; "Mandatory Category"; Option)
        {
            OptionCaption = ',AGPO Group,General,All';
            OptionMembers = ,"AGPO Group",General,All;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

