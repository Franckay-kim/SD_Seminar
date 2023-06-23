/// <summary>
/// Table HR Job Training Needs (ID 51533006).
/// </summary>
table 51533006 "HR Job Training Needs"
{

    fields
    {
        field(1; "CODE"; Code[50])
        {
            Description = 'Primary Key';

            trigger OnValidate()
            begin
                /*
                HrJobs.RESET;
                IF HrJobs.GET(CODE) THEN BEGIN
                Description:=HrJobs.Description;
                 END;
                */

            end;
        }
        field(2; "Job ID"; Code[50])
        {
            TableRelation = "HR Jobs"."Job ID";
        }
        field(3; Description; Text[250])
        {
        }
        field(4; "Training Group"; Code[50])
        {

        }
        field(5; "No of Participants"; Code[10])
        {

        }
    }

    keys
    {
        key(Key1; "CODE", "Job ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HrJobs: Record "HR Jobs";
}

