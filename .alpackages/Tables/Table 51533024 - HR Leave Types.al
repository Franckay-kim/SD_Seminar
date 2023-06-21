table 51533024 "HR Leave Types"
{
    //LookupPageID = "HR Leave Types";
    //DrillDownPageId = "HR Leave Types";

    fields
    {
        field(1; "Code"; Code[40])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200])
        {
        }
        field(3; Days; Decimal)
        {
        }
        field(4; "Acrue Days"; Boolean)
        {
        }
        field(5; "Unlimited Days"; Boolean)
        {
        }
        field(6; Gender; Option)
        {
            OptionCaption = 'Both,Male,Female';
            OptionMembers = Both,Male,Female;
        }
        field(7; Balance; Option)
        {
            OptionMembers = Ignore,"Carry Forward","Convert to Cash";
        }
        field(8; "Inclusive of Holidays"; Boolean)
        {
        }
        field(9; "Inclusive of Saturday"; Boolean)
        {
        }
        field(10; "Inclusive of Sunday"; Boolean)
        {
        }
        field(11; "Off/Holidays Days Leave"; Boolean)
        {
        }
        field(12; "Max Carry Forward Days"; Decimal)
        {
        }
        field(13; "Inclusive of Non Working Days"; Boolean)
        {
        }
        field(14; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(15; "Carry Forward Allowed"; Boolean)
        {
        }
        field(16; "Fixed Days"; Boolean)
        {
        }
        field(17; "Minimum Months"; DateFormula)
        {
            Caption = 'Minimum Months of Service (e.g. 3M)';
        }
        field(18; "Is Annual Leave"; Boolean)
        {
        }
        field(19; "Employee Category"; Option)
        {
            OptionCaption = ' ,Class A,Class B,Class C,Class D,Class E,Class F,Class G';
            OptionMembers = " ","Class A","Class B","Class C","Class D","Class E","Class F","Class G";
        }
        field(20; "Is Study Leave"; Boolean)
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

