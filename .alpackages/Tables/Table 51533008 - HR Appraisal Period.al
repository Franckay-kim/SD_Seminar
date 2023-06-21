table 51533008 "HR Appraisal Period"
{

    fields
    {
        field(1; "Appraisal Period"; Code[20])
        {
        }
        field(2; "Appraisal Period Description"; Text[100])
        {
        }
        field(3; "Appraisal Type"; Option)
        {
            OptionCaption = 'Appraisal Review,Target Setting,End Year Appraisal';
            OptionMembers = "Appraisal Review","Target Setting","End Year Appraisal";
        }
        field(4; Closed; Boolean)
        {
        }
        field(5; "Date opened"; Date)
        {
        }
        field(6; "Date closed"; Date)
        {
        }
        field(7; "Appraisal Month"; Integer)
        {
        }
        field(8; "Appraisal Year"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Appraisal Period")
        {
        }
    }

    fieldgroups
    {
    }
}

