table 51533180 "HR Job Interview"
{

    fields
    {
        field(2; "Applicant No"; Code[20])
        {
            //TableRelation = "HR Shortlisted Applicants"."Job Application No";
        }
        field(3; "Interview Code"; Code[80])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Interview Areas"));

            trigger OnValidate()
            begin
                HRLookupValues.Reset;
                HRLookupValues.SetRange(HRLookupValues.Code, "Interview Code");
                if HRLookupValues.Find('-') then begin
                    "Interview Description" := HRLookupValues.Description;

                end;
            end;
        }
        field(4; "Interview Description"; Text[250])
        {

            trigger OnValidate()
            begin

                //CALCFIELDS("Interview Description");
            end;
        }
        field(6; Score; Decimal)
        {
            MaxValue = 5;

            trigger OnValidate()
            begin
                Employee.Reset;
                Employee.SetRange(Employee."User ID", UserId);
                if Employee.Find('-') then begin
                    Interviewer := Employee."User ID";
                    "Interviewer Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                end else begin
                    Error('UserID: " %1 "has not been mapped to any Employee', UserId);
                end;
            end;
        }
        field(8; "Total Score"; Decimal)
        {
            CalcFormula = Sum("HR Job Interview".Score WHERE("Applicant No" = FIELD("Applicant No")));
            Editable = false;
            FieldClass = FlowField;
            MaxValue = 19;

            trigger OnValidate()
            begin
                //Cust.CALCFIELDS("Total Score");
                if cust."Total Score" > 5 then begin
                    Error('The allowable unaccounted balance of %1 has been exceeded');

                end;
            end;
        }
        field(10; Category; Option)
        {
            OptionMembers = "JOB SPECIFIC EVALUATION AREA","EMPLOYEE PERFORMANCE FACTOR";
        }
        field(11; "Sub Category"; Code[100])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Appraisal Sub Category"));
        }
        field(12; Group; Code[80])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Appraisal Group Item"));
        }
        field(14; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(15; Comments; Text[250])
        {
        }
        field(16; Interviewer; Code[50])
        {
            TableRelation = "HR Employees";
        }
        field(17; "Interviewer Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Applicant No", "Line No")
        {
        }
        key(Key2; "Interview Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRLookupValues: Record "HR Lookup Values";
        TotalScore: Integer;
        Employee: Record "HR Employees";
        cust: Record "HR Job Interview";
}

