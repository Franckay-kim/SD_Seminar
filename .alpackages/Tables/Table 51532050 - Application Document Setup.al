table 51532050 "Application Document Setup"
{
    //DrillDownPageID = "Application Doc. Setup Card";
    //LookupPageID = "Application Doc. Setup Card";

    fields
    {
        field(1; "Document No."; Code[10])
        {
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = ' ,Member,Account,Loan,BBF';
            OptionMembers = " ",Member,Account,Loan,BBF;
        }
        field(3; Description; Text[250])
        {
        }
        field(4; "Single Party/Multiple"; Option)
        {
            OptionCaption = 'Single,Group,Corporate,Cell,Joint';
            OptionMembers = Single,Group,Business,Cell,Joint;
        }
        field(5; Mandatory; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
        }
    }

    fieldgroups
    {
    }
}

