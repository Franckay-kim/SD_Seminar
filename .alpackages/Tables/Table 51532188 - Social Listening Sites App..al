table 51532188 "Social Listening Sites App."
{
    //DrillDownPageID = "Social Listening Sites App.";
    //LookupPageID = "Social Listening Sites App.";

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Account No."; Code[20])
        {
        }
        field(3; Address; Text[150])
        {
        }
    }

    keys
    {
        key(Key1; "Account No.", Address)
        {
        }
    }

    fieldgroups
    {
    }
}

