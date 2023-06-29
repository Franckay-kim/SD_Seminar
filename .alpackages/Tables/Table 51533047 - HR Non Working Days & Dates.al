/// <summary>
/// Table HR Non Working Days_Dates (ID 51533047).
/// </summary>
table 51533047 "HR Non Working Days & Dates"
{

    fields
    {
        field(1; Date; Date)
        {
        }
        field(2; Reason; Text[100])
        {
        }
        field(3; Recurring; Boolean)
        {
        }
        field(4; "Non-Working"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                if not "Non-Working" then
                    Reason := ''
                else
                    TestField(Reason);

                HRCalendarList.Reset;
                HRCalendarList.SetRange(Date, Date);
                if HRCalendarList.FindFirst then begin
                    HRCalendarList."Non Working" := "Non-Working";
                    HRCalendarList.Reason := Reason;
                    HRCalendarList.Modify;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; Date)
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRCalendarList: Record "HR Leave Calendar Lines";
}

