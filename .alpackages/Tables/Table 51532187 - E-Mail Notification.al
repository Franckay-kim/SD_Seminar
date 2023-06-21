table 51532187 "E-Mail Notification"
{

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = ' ,Account Statement';
            OptionMembers = " ","Account Statement";
        }
        field(2;"Path To Save Report";Text[250])
        {
        }
        field(3;"Sender Name";Text[100])
        {
        }
        field(4;"Sender E-Mail";Text[100])
        {
        }
        field(5;"Send To CC";Text[250])
        {
        }
        field(6;"Send To BCC";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type")
        {
        }
    }

    fieldgroups
    {
    }
}

