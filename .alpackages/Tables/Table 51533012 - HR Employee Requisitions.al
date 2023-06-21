table 51533012 "HR Employee Requisitions"
{
    //DrillDownPageID = "HR Employee Requisitions List";
    //LookupPageID = "HR Employee Requisitions List";

    fields
    {
        field(2; "Job ID"; Code[20])
        {
            TableRelation = "HR Jobs"."Job ID" WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                HRJobs.Reset;
                if HRJobs.Get("Job ID") then begin
                    "Job Description" := HRJobs."Job Description";
                    "Vacant Positions" := HRJobs."Vacant Positions";
                    "Job Grade" := HRJobs.Grade;

                end;

                HRJobReq.Reset;
                HRJobReq.SetRange(HRJobReq."Job ID", "Job ID");
                if HRJobReq.Find('-') then begin
                    if HRJobReq.Count <= 0 then Error('Job requirements for Job ID [ %1 ] not defined', "Job ID");
                end;
            end;
        }
        field(3; "Requisition Date"; Date)
        {

            trigger OnValidate()
            begin
                if (Rec."Requisition Date" - Today) < 0 then
                    Message('Days in the past are not allowed');
            end;
        }
        field(4; Priority; Option)
        {
            OptionCaption = ' ,High,Medium,Low';
            OptionMembers = " ",High,Medium,Low;
        }
        field(5; Positions; Integer)
        {
        }
        field(6; Approved; Boolean)
        {

            trigger OnValidate()
            begin
                "Date Approved" := Today;
            end;
        }
        field(7; "Date Approved"; Date)
        {
        }
        field(8; "Job Description"; Text[200])
        {

        }
        field(9; Stage; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(10; Score; Decimal)
        {
            FieldClass = Normal;
        }
        field(11; "Stage Code"; Code[20])
        {
        }
        field(12; Qualified; Boolean)
        {
            FieldClass = Normal;
        }
        field(13; "Job Supervisor/Manager"; Code[20])
        {
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(17; "Turn Around Time"; Integer)
        {

        }
        field(21; "Grace Period"; Integer)
        {
        }
        field(25; Closed; Boolean)
        {
        }
        field(26; "Requisition Type"; Option)
        {
            OptionCaption = ' ,Internal,External,Both';
            OptionMembers = " ",Internal,External,Both;
        }
        field(27; "Closing Date"; Date)
        {
        }
        field(28; "Approval Status"; Option)
        {
            OptionCaption = 'Open,Pending Approval,Canceled,Rejected,Approved';
            OptionMembers = Open,"Pending Approval",Canceled,Rejected,Approved;
        }

        field(38; "Required Positions"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Required Positions" > "Vacant Positions" then begin
                    Error('Required positions exceed the total  no of Vacant Positions');
                end;

                if "Required Positions" <= 0 then begin
                    Error('Required positions cannot be Less Than or Equal to Zero');
                end;
            end;
        }
        field(39; "Vacant Positions"; Decimal)
        {
        }
        field(40; "Employment Type"; Option)
        {
            Caption = 'Employment Type';
            OptionMembers = Permanent,"Temporary",Voluntary,Contract,Interns,Casuals;
        }
        field(3949; "Reason for Request(Other)"; Text[100])
        {
        }
        field(3950; "Any Additional Information"; Text[100])
        {
        }
        field(3958; "Job Grade"; Text[100])
        {
            ValidateTableRelation = false;
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Checklist Item"));
        }
        field(3964; "Type of Contract Required"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER("Qualification Type"));
        }
        field(3965; "Reason For Request"; Option)
        {
            OptionMembers = "New Vacancy",Replacement,Retirement,Retrenchment,Demise,Other;
        }
        field(3966; Requestor; Code[50])
        {
        }
        field(3967; "No. Series"; Code[10])
        {
        }
        field(3968; "Requisition No."; Code[20])
        {

        }
        field(3969; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility CenterBR".Code;
        }
        field(3970; "Shortlisting Comittee"; Code[20])
        {
        }
        field(3971; Advertised; Boolean)
        {
        }
        field(3972; "No. of Job Applications"; Integer)
        {
            CalcFormula = Count("HR Job Applications" WHERE("Job Applied For" = FIELD("Job ID")));
            FieldClass = FlowField;
        }
        field(3973; "Completion Status"; Option)
        {
            OptionMembers = Open,Closed;
        }
        field(3974; MyRecId; RecordId)
        {
            Caption = 'MyRecId';
            DataClassification = ToBeClassified;
        }
        field(3975; Remarks; Text[150])
        {

        }
    }

    keys
    {
        key(Key1; "Requisition No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Job ID", "Job Description")
        {
        }
    }

    trigger OnDelete()
    begin

        if "Approval Status" <> "Approval Status"::Open then
            Error('You cannot delete this record if its status is' + ' ' + Format("Approval Status"));
    end;

    trigger OnInsert()
    begin
        UpdateControls();
        //GENERATE DOCUMENT NUMBER
        if "Requisition No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Employee Requisition Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Employee Requisition Nos.", xRec."No. Series", 0D, "Requisition No.", "No. Series");
        end;

        userSetup.Reset;
        userSetup.SetRange(userSetup."User ID", UserId);
        if userSetup.Find('-') then begin
            //mDivision:=userSetup."Global Dimension 2 Code";
            //mResponsibility:=userSetup."Responsibility Center";
        end;

        //POPULATE FIELDS
        IF (GuiAllowed) then Requestor := UserId;
        "Requisition Date" := Today;
        "Responsibility Center" := mResponsibility;
        "Global Dimension 2 Code" := mDivision;
    end;

    trigger OnModify()
    begin
        userSetup.Reset;
        userSetup.SetRange(userSetup."User ID", UserId);
        if userSetup.Find('-') then begin
            //mDivision:=userSetup."Global Dimension 1 Code";
            //mResponsibility:=userSetup."Responsibility Center";
        end;
    end;

    local procedure UpdateControls()
    begin
        if (GuiAllowed) then
            EditAllowed := false
        else
            EditAllowed := true
    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRJobs: Record "HR Jobs";
        HREmployeeReq: Record "HR Employee Requisitions";
        userSetup: Record "User Setup";
        mDivision: Code[50];
        mResponsibility: Code[50];
        HRJobReq: Record "HR Job Requirements";
        EditAllowed: Boolean;

}

