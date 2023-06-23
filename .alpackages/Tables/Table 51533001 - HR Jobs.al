/// <summary>
/// Table HR Jobs (ID 51533001).
/// </summary>
table 51533001 "HR Jobs"
{


    fields
    {
        field(1; "Job ID"; Code[60])
        {
            Editable = true;
        }
        field(2; "Job Description"; Text[250])
        {
            NotBlank = true;
        }
        field(3; "No of Posts"; Integer)
        {

            trigger OnValidate()
            begin
                if "No of Posts" <> xRec."No of Posts" then
                    "Vacant Positions" := "No of Posts" - "Occupied Positions";

                if "No of Posts" <= 0 then
                    Error('No of posts cannot be less than 1');
            end;
        }
        field(4; "Position Reporting to"; Code[20])
        {
            TableRelation = "HR Jobs"."Job ID" WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                "Position Reporting Name" := '';

                HRJobs.Reset;
                if HRJobs.Get("Position Reporting to") then begin
                    "Position Reporting Name" := HRJobs."Job Description";
                end;
            end;
        }
        field(5; "Occupied Positions"; Integer)
        {
            CalcFormula = Count("HR Employees" WHERE("Job ID" = FIELD("Job ID"),
                                                      Status = CONST(Active)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Vacant Positions"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Editable = false;

            trigger OnValidate()
            begin
                "Vacant Positions" := "No of Posts" - "Occupied Positions";
            end;
        }
        field(7; "Score code"; Code[20])
        {
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                "Global Dimension 1 Name" := '';
                DimensionValue.Reset;
                DimensionValue.SetRange(DimensionValue.Code, "Global Dimension 1 Code");
                if DimensionValue.Find('-') then begin
                    "Global Dimension 1 Name" := DimensionValue.Name;
                end;
            end;
        }
        field(9; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                "Global Dimension 2 Name" := '';
                DimensionValue.Reset;
                DimensionValue.SetRange(DimensionValue.Code, "Global Dimension 2 Code");
                if DimensionValue.Find('-') then begin
                    "Global Dimension 2 Name" := DimensionValue.Name;
                end;
            end;
        }
        field(17; "Total Score"; Decimal)
        {
            Editable = false;
        }
        field(19; "Main Objective"; Text[250])
        {
        }
        field(21; "Key Position"; Boolean)
        {
        }
        field(22; Category; Code[20])
        {
        }
        field(23; Grade; Code[20])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Job Group"));
        }
        field(24; "Employee Requisitions"; Integer)
        {
            //CalcFormula = Count("HR Employee Requisitions" WHERE("Job ID" = FIELD("Job ID")));
            //FieldClass = FlowField;
        }
        field(27; "User ID"; Code[50])
        {
        }
        field(28; "Supervisor/Manager"; Code[50])
        {
            TableRelation = "HR Jobs"."Job ID";

            trigger OnValidate()
            begin
                HREmp.Get("Supervisor/Manager");
                "Supervisor Name" := HREmp.FullName;
            end;
        }
        field(29; "Supervisor Name"; Text[60])
        {
            Editable = false;
        }
        field(30; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Canceled,Rejected,Approved';
            OptionMembers = Open,"Pending Approval",Canceled,Rejected,Approved;
        }
        field(32; "Date Created"; Date)
        {
        }
        field(33; "No. of Requirements"; Integer)
        {
            CalcFormula = Count("HR Job Requirements" WHERE("Job ID" = FIELD("Job ID")));
            FieldClass = FlowField;
        }
        field(34; "No. of Responsibilities"; Integer)
        {
            CalcFormula = Count("HR Job Responsiblities" WHERE("Job ID" = FIELD("Job ID")));
            FieldClass = FlowField;
        }
        field(44; "Is Supervisor"; Boolean)
        {
        }
        field(45; "G/L Account"; Code[50])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(46; "Global Dimension 1 Name"; Text[100])
        {
            Editable = false;
        }
        field(47; "Global Dimension 2 Name"; Text[100])
        {
            Editable = false;
        }
        field(49; "Position Reporting Name"; Text[100])
        {
            Editable = false;
        }
        field(50; "No. Series"; Code[20])
        {
        }
        field(50000; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility CenterBR".Code;

            trigger OnValidate()
            begin
                "Responsibility Center Name" := '';

                RespCenter.Reset;
                if RespCenter.Get("Responsibility Center") then begin
                    "Responsibility Center Name" := RespCenter.Name;
                end;
            end;
        }
        field(50001; "Responsibility Center Name"; Text[100])
        {
            Editable = false;
        }
        field(50002; "Marked for Succession"; Boolean)
        {
        }
        field(50003; "Date Modified"; Date)
        {
        }
        field(50004; "Modified By UserID"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Job ID")
        {
        }
        key(Key2; "Job Description")
        {
        }
        key(Key3; Status)
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
        if Status <> Status::Open then Error('You cannot delete record when status is %1', Status);

        /*HRJobRequirements.Reset;
        HRJobRequirements.SetRange(HRJobRequirements."Job ID", "Job ID");
        HRJobRequirements.DeleteAll(true);

        HRJobResponsiblities.Reset;
        HRJobResponsiblities.SetRange(HRJobResponsiblities."Job ID", "Job ID");
        HRJobResponsiblities.DeleteAll(true);*/
    end;

    trigger OnInsert()
    begin
        if "Job ID" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Job ID Nos");
            NoSeriesMgt.InitSeries(HRSetup."Job ID Nos", xRec."No. Series", 0D, "Job ID", "No. Series");
        end;

        Usersetup.Reset;
        Usersetup.SetRange(Usersetup."User ID", UserId);
        if Usersetup.Find('-') then begin
            //"Responsibility Center" := Usersetup."Responsibility Centre";
        end;

        "Responsibility Center Name" := '';

        RespCenter.Reset;
        if RespCenter.Get("Responsibility Center") then begin
            "Responsibility Center Name" := RespCenter.Name;
        end;


        "Date Created" := Today;
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        //    "Vacant Positions" := "No of Posts" - "Occupied Positions";
        //    IF Status <> Status::Open THEN ERROR('You cannot Modify record when status is %1',Status);
    end;

    var
        NoOfPosts: Decimal;
        HREmp: Record "HR Employees";
        DimensionValue: Record "Dimension Value";
        RespCenter: Record "Responsibility CenterBR";
        HRJobs: Record "HR Jobs";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //HRJobResponsiblities: Record "HR Job Responsiblities";
        //HRJobRequirements: Record "HR Job Requirements";
        Usersetup: Record "User Setup";
}

