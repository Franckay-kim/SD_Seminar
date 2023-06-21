table 51532170 "ATM Linking  Statistics"
{
    // DrillDownPageID = "ATM Linking Statistics";
    //LookupPageID = "ATM Linking Statistics";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "ATM Application No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Account No."; Code[20])
        {
            Editable = false;
        }
        field(4; "Linking Type"; Option)
        {
            Editable = false;
            OptionCaption = ',Linking,Delinking';
            OptionMembers = ,Linking,Delinking;
        }
        field(5; "User ID"; Code[30])
        {
            Editable = false;
        }
        field(6; "Activity Date"; Date)
        {
            Editable = false;
        }
        field(7; "Activity Time"; Time)
        {
            Editable = false;
        }
        field(8; "Reason for change"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

