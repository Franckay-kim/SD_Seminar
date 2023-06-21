table 51533039 "HR Applicant Referees"
{

    fields
    {
        field(1; "Job Application No"; Code[20])
        {
            TableRelation = "HR Job Applications"."Job Application No.";
        }
        field(2; Names; Text[200])
        {
        }
        field(3; Designation; Text[100])
        {
        }
        field(4; Institution; Text[100])
        {
        }
        field(5; Address; Text[200])
        {
        }
        field(6; "Telephone No"; Text[100])
        {
        }
        field(7; "E-Mail"; Text[100])
        {
        }
        field(8; "Employee No"; Code[30])
        {
        }
        field(9; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(10; JobID; Code[30])
        {
        }
        field(11; "Online Application No"; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Job Application No", Names, "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

