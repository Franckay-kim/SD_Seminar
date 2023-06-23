/// <summary>
/// Table PR Payroll Periods (ID 51533106).
/// </summary>
table 51533106 "PR Payroll Periods"
{
    //LookupPageID = "PR Payroll Periods";

    fields
    {
        field(1; "Period Month"; Integer)
        {
        }
        field(2; "Period Year"; Integer)
        {
        }
        field(3; "Period Name"; Text[30])
        {
            Description = 'e.g November 2009';
        }
        field(4; "Date Opened"; Date)
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                "Date Opened" := CALCDATE('<-CM>', "Date Opened");
                "Period Name" := FORMAT("Date Opened", 0, '<Month Text> <Year4>');
                "Period Name" := UpperCase("Period Name");
                "Period Month" := DATE2DMY("Date Opened", 2);
                "Period Year" := DATE2DMY("Date Opened", 3);
            end;
        }
        field(5; "Date Closed"; Date)
        {
        }
        field(6; Closed; Boolean)
        {
            Description = 'A period is either closed or open';
        }
        field(7; "Closed By"; Code[100])
        {
        }
        field(8; "Opened By"; Code[100])
        {
        }
    }

    keys
    {
        key(Key1; "Date Opened")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Date Opened", "Period Name")
        {
        }
    }
}

