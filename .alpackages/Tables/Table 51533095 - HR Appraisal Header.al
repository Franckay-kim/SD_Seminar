table 51533095 "HR Appraisal Header"
{

    fields
    {
        field(1; "Appraisal No"; Code[30])
        {
        }
        field(2; "Supervisor Name"; Text[100])
        {
        }
        field(3; "Appraisal Type"; Code[30])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Appraisal Type"));
        }
        field(4; "Appraisal Period"; Code[30])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER("Appraisal Period"));

            trigger OnValidate()
            begin

                HRLookUpValues.Reset;
                HRLookUpValues.SetRange(HRLookUpValues.Type, HRLookUpValues.Type::"Appraisal Period");
                HRLookUpValues.SetRange(HRLookUpValues.Code, "Appraisal Period");
                if HRLookUpValues.Find('-') then begin
                    "Evaluation Period Start" := HRLookUpValues.From;
                    "Evaluation Period End" := HRLookUpValues."To";
                end
            end;
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved,Closed,Posted;
        }
        field(6; Recommendations; Text[250])
        {
        }
        field(7; "No Series"; Code[20])
        {
        }
        field(8; "Appraisal Stage"; Option)
        {
            OptionCaption = 'Target Setting,Target Approval,End Year Evalauation';
            OptionMembers = "Target Setting","Target Approval","End Year Evalauation";
        }
        field(9; Sent; Option)
        {
            OptionCaption = 'Appraisee,Supervisor,Completed,Rated';
            OptionMembers = Appraisee,Supervisor,Completed,Rated;
        }
        field(10; "User ID"; Code[100])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(11; Picture; BLOB)
        {
            SubType = Bitmap;
        }
        field(12; "Employee No"; Code[30])
        {
            Editable = true;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Employee No");
                if HREmp.Find('-') then begin
                    "Employee Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Job Title" := HREmp."Job Title";
                    "Date of Employment" := HREmp."Date Of Join";
                    "Global Dimension 1 Code" := HREmp."Department Code";
                    "Global Dimension 2 Code" := HREmp.Office;
                    "Job Title" := HREmp.Position;
                    //"Contract Type":= HREmp."Contract Type" ;
                    "User ID" := UserId;
                    HREmp.CalcFields(HREmp.Picture);
                    Picture := HREmp.Picture;
                end;
            end;
        }
        field(13; "Employee Name"; Text[60])
        {
            Editable = false;
        }
        field(14; "Date of Employment"; Date)
        {
        }
        field(15; "Job Title"; Code[30])
        {
            Editable = false;
            TableRelation = "HR Jobs"."Job ID";
        }
        field(16; Department; Code[20])
        {
            //TableRelation = "HR Appraisal Company Target".Code;

            trigger OnValidate()
            begin
                /*
   IF HRAppraisalRatings.GET(Department) THEN
   "Global Dimension 2 Code":=HRAppraisalRatings.Description;
   Recommendations:=HRAppraisalRatings.Recommendations;
                  */

            end;
        }
        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(19; "Comments Appraisee"; Text[250])
        {
        }
        field(20; "Comments Appraiser"; Text[250])
        {
        }
        field(21; "Appraisal Date"; Date)
        {
        }
        field(22; "Evaluation Period Start"; Date)
        {
        }
        field(23; "Evaluation Period End"; Date)
        {
        }
        field(24; "Target Type"; Option)
        {
            OptionCaption = ' ,Company Targets,Individual Targets,Peer Targets,Surbodinates Targets,Out Agencies Targets,Company Rating,Individual Rating,Peer Rating,Surbodinates Rating,Out Agencies Rating';
            OptionMembers = " ","Company Targets","Individual Targets","Peer Targets","Surbodinates Targets","Out Agencies Targets","Company Rating","Individual Rating","Peer Rating","Surbodinates Rating","Out Agencies Rating";
        }
        field(25; "Responsibility/Duties Agrd Sco"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER("Core Responsibilities/Duties")));
            Caption = 'Responsibility/Duties Agreed Score';
            ExtendedDatatype = Ratio;
            FieldClass = FlowField;
        }
        field(26; "Attendance&Punctuality Agr Sco"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER("Attendance&Punctuality")));
            Caption = 'Attendance & Punctuality Agreed Score';
            FieldClass = FlowField;
        }
        field(27; "Communication Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER(Communication)));
            ExtendedDatatype = Ratio;
            FieldClass = FlowField;
        }
        field(28; "Cooperation Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER(Cooperation)));
            FieldClass = FlowField;
        }
        field(29; "Customer Service Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER("Internal/External Clients")));
            FieldClass = FlowField;
        }
        field(30; "Initiative Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER(Initiative)));
            FieldClass = FlowField;
        }
        field(31; "Quality Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER(Quality)));
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
        }
        field(32; "Teamwork Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER("Team Work")));
            ExtendedDatatype = Ratio;
            FieldClass = FlowField;
        }
        field(33; "Sales Skills Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER("Sales Skills")));
            FieldClass = FlowField;
        }
        field(34; "Leadership Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER(Leadership)));
            FieldClass = FlowField;
        }
        field(35; "Performance Coaching Agreed Sc"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Agreed Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                          "Appraisal Period" = FIELD("Appraisal Period"),
                                                                          "Employee No" = FIELD("Employee No"),
                                                                          Sections = FILTER("Performance Coaching")));
            Caption = 'Performance Coaching Agreed Score';
            FieldClass = FlowField;
        }
        field(36; "Action Recomended"; Integer)
        {
        }
        field(37; "Job Specific Agreed Score"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Self Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                        "Appraisal Period" = FIELD("Appraisal Period"),
                                                                        "Employee No" = FIELD("Employee No")));
            FieldClass = FlowField;
        }
        field(38; "Employee Subordinates"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Weighted Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                            "Appraisal Period" = FIELD("Appraisal Period"),
                                                                            "Employee No" = FIELD("Employee No")));
            Caption = 'Employee Subordinates Agreed Score';
            FieldClass = FlowField;
        }
        field(39; "Employee Peers"; Decimal)
        {
            CalcFormula = Sum("HR Appraisal Lines"."Peer Rating" WHERE("Appraisal No" = FIELD("Appraisal No"),
                                                                        "Appraisal Period" = FIELD("Appraisal Period"),
                                                                        "Employee No" = FIELD("Employee No")));
            Caption = 'Employee Peers Agreed Score';
            FieldClass = FlowField;
        }
        field(40; "Job Description"; Text[250])
        {
            CalcFormula = Lookup("HR Jobs"."Job Description" WHERE("Job ID" = FIELD("Job Title")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Appraisal Method"; Option)
        {
            OptionCaption = ' ,Normal Appraisal,360 Appraisal';
            OptionMembers = " ","Normal Appraisal","360 Appraisal";
        }
        field(42; "Supervisor Employee No"; Code[20])
        {
            Editable = true;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Supervisor Employee No");
                if HREmp.Find('-') then begin
                    HREmp.TestField(HREmp."User ID");
                    "Supervisor Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Supervisor Job Title" := HREmp."Job Title";
                    "Supervisor UserID" := HREmp."User ID";
                end;
            end;
        }
        field(43; "Supervisor Job Title"; Text[50])
        {
            Editable = true;
        }
        field(50000; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR".Code;
        }
        field(50011; "Contract Type"; Option)
        {
            OptionMembers = Permanent,"Temporary",Voluntary,Probation,Contract;
        }
        field(50014; "Appraisal Approval Status"; Option)
        {
            OptionMembers = "Pending Approval",Approved;
        }
        field(50015; "Supervisor UserID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50020; "Prev Appraisal Code"; Code[50])
        {
        }
        field(50021; "Agreed Goals 1"; Text[30])
        {
            Description = 'Agreed goals for the year ahead';
        }
        field(50022; "Responsibility/Duties Comment"; Text[100])
        {
            Caption = 'Responsibility/Duties Agreed Score';
            FieldClass = Normal;
        }
        field(50023; "Attendance&Punctuality Comment"; Text[30])
        {
            Caption = 'Attendance & Punctuality Agreed Score';
            FieldClass = Normal;
        }
        field(50024; "Communication Agreed Comment"; Text[30])
        {
            FieldClass = Normal;
        }
        field(50025; "Cooperation Agreed Comment"; Text[30])
        {
            FieldClass = Normal;
        }
        field(50026; "Customer Service Agr Comment"; Text[30])
        {
            FieldClass = Normal;
        }
        field(50027; "Initiative Agreed Comment"; Text[30])
        {
            FieldClass = Normal;
        }
        field(50028; "Quality Agreed Comment"; Text[30])
        {
            FieldClass = Normal;
        }
        field(50029; "Teamwork Agreed Comment"; Text[30])
        {
            FieldClass = Normal;
        }
        field(50030; "Sales Skills Agreed Comment"; Text[30])
        {
            FieldClass = Normal;
        }
        field(50031; "Leadership Agreed Comment"; Text[30])
        {
            FieldClass = Normal;
        }
        field(50032; "Performance Coaching Comment"; Text[30])
        {
            Caption = 'Performance Coaching Agreed Score';
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Appraisal No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
        //Also delete lines
        HRGoalSettingL.Reset;
        HRGoalSettingL.SetRange(HRGoalSettingL."Appraisal No", "Appraisal No");
        if HRGoalSettingL.Find('-') then begin
            HRGoalSettingL.DeleteAll;
        end;
    end;

    trigger OnInsert()
    begin
        if "Appraisal No" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Appraisal Nos");
            NoSeriesMgt.InitSeries(HRSetup."Appraisal Nos", xRec."No Series", 0D, "Appraisal No", "No Series");
        end;
        "Appraisal Date" := Today;

        //GET APPLICANT DETAILS FROM HR EMPLOYEES TABLE AND COPY THEM TO THE GOAL SETTING TABLE
        HREmp.Reset;
        HREmp.SetRange(HREmp."User ID", UserId);
        if HREmp.Find('-') then begin

            "Appraisal Stage" := "Appraisal Stage"::"Target Setting";
            /*
            "Employee No":=HREmp."No.";
            "Employee Name":=HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            "Date of Employment":=HREmp."Date Of Join";
            "Global Dimension 1 Code":=HREmp."Dimension 1 Code";
            "Global Dimension 2 Code":=HREmp."Dimension 2 Code";
            "Job Title":=HREmp."Job ID";
            "Contract Type":= HREmp."Employment Type" ;
            "User ID":=USERID;
        
            //Supervisor:=HREmpCard.GetSupervisor("User ID");
        
            HREmp.CALCFIELDS(HREmp.Picture);
            Picture:=HREmp.Picture;
        
            //For 360
            HRSetup.RESET;
            IF HRSetup.GET THEN
            BEGIN
                HRSetup.TESTFIELD(HRSetup."Min. Leave App. Months");
            END;
        
            IF HREmp."Appraisal Method" = HREmp."Appraisal Method"::"0" THEN
            BEGIN
                //Default to value in HR Setup if not filled
                "Appraisal Method":=HRSetup."Min. Leave App. Months";
            END ELSE
            BEGIN
                //Select appraisal from Employee PIF
                "Appraisal Method":=HREmp."Appraisal Method";
            END;
            //End for 360
             */
        end else begin
            Error('User ID' + ' ' + UserId + ' ' + 'is not assigned to any employee. Consult the HR Officer so as to be setup as an employee')
        end;

        /*
        //Put the open appraisal period
        HRLookUpValues.RESET;
        HRLookUpValues.SETRANGE(HRLookUpValues.Type,HRLookUpValues.Type::"Appraisal Period");
        HRLookUpValues.SETRANGE(HRLookUpValues.Closed,FALSE);
        IF HRLookUpValues.FIND('-') THEN BEGIN
          "Appraisal Period":=HRLookUpValues.Code;
          "Appraisal Stage":=HRLookUpValues."Appraisal Stage";
          "Evaluation Period Start":=HRLookUpValues.From;
          "Evaluation Period End":=HRLookUpValues."To";
        END
        ELSE
        BEGIN
            ERROR('There are no open Appraisal Periods, Please define one in HR Lookup Values');
        END;
        */

    end;

    var
        HREmp: Record "HR Employees";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //HREmpCard: Page "HR Employee Card";
        //HRAppraisalRatings: Record "HR Appraisal Company Target";
        HRAppraisalGoalSettingH: Record "HR Appraisal Header";
        HRGoalSettingL: Record "HR Appraisal Lines";
        HRGoalSettingLNext: Record "HR Appraisal Lines";
        HRLookUpValues: Record "HR Lookup Values";
        LastAppraisal: Record "HR Appraisal Header";
        CompanyScoreAppraisee: Decimal;
        KPIScoreAppraisee: Decimal;
        PFScoreAppraisee: Decimal;
        PFBase: Decimal;
        //HrRatings: Record "HR Appraisal Company Target";
        UserSetup: Record "User Setup";
        Approver: Record "User Setup";
        KPIScoreAppraiser: Decimal;
        KPIScoreMgt: Decimal;
        PFScoreAppraiser: Decimal;
        PFScoreMgt: Decimal;
}

