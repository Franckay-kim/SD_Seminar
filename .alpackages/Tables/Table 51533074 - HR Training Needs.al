table 51533074 "HR Training Needs"
{
    DataCaptionFields = "Code", Description;

    LinkedObject = false;


    fields
    {
        field(1; "Code"; Code[20])
        {
            Editable = false;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                //IF "Start Date" < TODAY THEN ERROR('Invalid Start Date specified [%1]',"Start Date");
            end;
        }
        field(4; "End Date"; Date)
        {
            Editable = true;

            trigger OnValidate()
            begin
                TestField("Start Date");
                if ("End Date" < Today) or ("End Date" < "Start Date") then Error('Invalid End Date specified [%1]', "End Date");
                "Re-Assessment Date" := 0D;
            end;
        }
        field(5; Duration1; DateFormula)
        {
        }
        field(6; "Total Costs"; Decimal)
        {
            CalcFormula = Sum("HR Training Cost".Cost WHERE("Training ID" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; Location; Code[50])
        {
        }
        field(8; "Re-Assessment Date"; Date)
        {

            trigger OnValidate()
            begin
                TestField("Start Date");
                TestField("End Date");
                if "Re-Assessment Date" <= "End Date" then Error('Re-Assesment date should be greater than the start date and the end date');
            end;
        }
        field(9; "Need Source"; Option)
        {
            OptionCaption = '  ,Appraisal,Succesion,Training,Employee,Employee Skill Plan,Competency Profiling';
            OptionMembers = "  ",Appraisal,Succesion,Training,Employee,"Employee Skill Plan","Competency Profiling";
        }
        field(10; "Provider Name"; Text[100])
        {
            TableRelation = Vendor;
        }
        field(11; Posted; Boolean)
        {
            Editable = false;
        }
        field(12; Closed; Boolean)
        {
            Editable = false;
        }
        field(13; "Qualification Code"; Code[20])
        {
            TableRelation = "HR Job Qualifications".Code WHERE("Qualification Type" = FIELD("Qualification Type"));

            trigger OnValidate()
            begin
                HRQualifications.Reset;
                if HRQualifications.Get("Qualification Type", "Qualification Code") then
                    "Qualification Description" := HRQualifications.Description;
            end;
        }
        field(14; "Qualification Type"; Code[30])
        {
            NotBlank = false;
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Qualification Type"));
        }
        field(15; "Qualification Description"; Text[80])
        {
        }
        field(16; "External Provider Name"; Text[50])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(17; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(18; "Bondage Start Date"; Date)
        {
            Editable = false;
        }
        field(19; "Bondage Duration"; DateFormula)
        {

            trigger OnValidate()
            begin
                "Bondage Release Date" := CalcDate("Bondage Duration", "Bondage Start Date");
            end;
        }
        field(20; "Bondage Release Date"; Date)
        {
            Editable = false;
        }
        field(21; "Inclusive of Non Working Days"; Boolean)
        {
        }
        field(22; "Bondage Required?"; Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Start Date");
                TestField("End Date");

                Clear("Bondage Start Date");
                Clear("Bondage Duration");
                Clear("Bondage Release Date");

                if "Bondage Required?" then begin
                    "Bondage Start Date" := "End Date";
                    Validate("Bondage Duration");
                end;
            end;
        }
        field(23; "No. of Training Cost Items"; Integer)
        {
        }
        field(24; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved';
            OptionMembers = New,"Pending Approval",Approved;
        }
        field(25; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(26; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(27; "Currency Code"; Code[20])
        {
            TableRelation = Currency.Code;
        }
        field(28; "Allow Early Exit if Bonded?"; Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Bondage Required?", true);
                TestField("Bondage Duration");
            end;
        }
        field(29; "Employee No"; Code[20])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(30; "No. Series"; Code[20])
        {
        }
        field(31; Duration; Duration)
        {
        }
        field(32; "Training Category"; Option)
        {
            OptionMembers = " ",Staff,Interns,Board;
        }
        field(33; "Training Type"; Option)
        {
            OptionMembers = " ",Conference,Seminar,Workshop,"Study Tour","Self Sponsored",Other,"Company Sponsorship";
        }
        field(34; Provider; Code[50])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin

                Vendor.Reset;
                Vendor.SetRange(Vendor."No.", Provider);
                if Vendor.Find('-') then
                    "Provider Name" := Vendor.Name;
            end;
        }
        field(35; "Other Provider"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if Code = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Traning Needs Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Traning Needs Nos.", xRec."No. Series", 0D, Code, "No. Series");
        end;
    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //HRCodeunit: Codeunit "HR Codeunit.";
        HRQualifications: Record "HR Job Qualifications";
        Vendor: Record Vendor;

    local procedure calcDuration()
    begin
    end;
}

