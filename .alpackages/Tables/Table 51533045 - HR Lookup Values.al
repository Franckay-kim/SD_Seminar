/// <summary>
/// Table HR Lookup Values (ID 51533045).
/// </summary>
table 51533045 "HR Lookup Values"
{
    //DrillDownPageID = "HR Lookup Values List";
    //LookupPageID = "HR Lookup Values List";

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = ' ,Religion,Language,Contract Type,Qualification Type,Grade,Tribe,Training Cost Item,Institution,Appraisal Type,Appraisal Period,Urgency,Succession,Security,Disciplinary Case Rating,Disciplinary Case,Disciplinary Action,Next of Kin,Country,Checklist Item,Appraisal Sub Category,Appraisal Group Item,Transport Type,Grievance Cause,Grievance Outcome,Appraiser Recom,Job Group,Ethnic Origin,Interview Areas,Competency,Qualification Code,County';
            OptionMembers = " ",Religion,Language,"Contract Type","Qualification Type",Grade,Tribe,"Training Cost Item",Institution,"Appraisal Type","Appraisal Period",Urgency,Succession,Security,"Disciplinary Case Rating","Disciplinary Case","Disciplinary Action","Next of Kin",Country,"Checklist Item","Appraisal Sub Category","Appraisal Group Item","Transport Type","Grievance Cause","Grievance Outcome","Appraiser Recom","Job Group","Ethnic Origin","Interview Areas",Competency,"Qualification Code",County;
        }
        field(2; "Code"; Code[70])
        {
        }
        field(3; Description; Text[80])
        {
        }
        field(4; Remarks; Text[250])
        {
        }
        field(5; "Notice Period"; Date)
        {
        }
        field(6; Closed; Boolean)
        {
        }
        field(7; "Contract Length"; Integer)
        {
        }
        field(8; "Current Appraisal Period"; Boolean)
        {
        }
        field(9; "Disciplinary Case Rating"; Text[30])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Disciplinary Case"));
        }
        field(10; "Disciplinary Action"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Next of Kin"));
        }
        field(14; From; Date)
        {
        }
        field(15; "To"; Date)
        {
        }
        field(16; Score; Decimal)
        {
        }
        field(17; "Basic Salary"; Decimal)
        {
        }
        field(18; "To be cleared by"; Code[10])
        {
            TableRelation = "HR Lookup Values".Remarks;
        }
        field(19; "Last Date Modified"; Date)
        {
        }
        field(20; "Supervisor Only"; Boolean)
        {
        }
        field(21; "Appraisal Stage"; Option)
        {
            OptionMembers = "Target Setting",FirstQuarter,SecondQuarter,ThirdQuarter,EndYearEvaluation;
        }
        field(22; "Previous Appraisal Code"; Code[70])
        {
        }
        field(23; "Minimum Pay"; Decimal)
        {
        }
        field(24; "Maximum Pay"; Decimal)
        {
        }
        field(25; "Suspend Payment"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; Type, "Code", Description)
        {
        }

    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
        IF Type=Type::"Appraisal Period" THEN BEGIN
          HrLookupValues.RESET;
          HrLookupValues.SETRANGE(HrLookupValues.Type,HrLookupValues.Type::"Appraisal Period");
          HrLookupValues.SETRANGE(HrLookupValues.Closed,FALSE);
          IF HrLookupValues.FINDFIRST THEN
            ERROR('Close the Appraisal Period %1',HrLookupValues.Code);
        END
        */

    end;

    var
        HrLookupValues: Record "HR Lookup Values";
}

