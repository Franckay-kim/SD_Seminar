table 51532031 "Fixed Deposit Type"
{
    // DrillDownPageID = "Fixed Deposit Type List";
    // LookupPageID = "Fixed Deposit Type List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Duration; DateFormula)
        {

        }
        field(3; Description; Text[50])
        {
        }
        field(4; "No. of Months"; Integer)
        {
        }
        field(5; "Interest Method"; Option)
        {
            OptionCaption = ' ,Compound,Simple';
            OptionMembers = " ",Compound,Simple;
        }
        field(6; "Call Deposit"; Boolean)
        {
        }
        field(7; Notification; Option)
        {
            Description = 'Blank,Email,Notification,SMS';
            OptionCaption = ' ,Email,Notification,SMS';
            OptionMembers = " ",Email,Notification,SMS;
        }
        field(8; "Notification Period"; Integer)
        {
            Caption = 'Notification Period(Days)';
            Description = 'How many days before maturing';
        }
        field(9; Blocked; Boolean)
        {
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

