table 51533096 "HR Appraisal Lines"
{
    //               HRAppraisalGoalSettingH.GET("Appraisal No");
    //                 "Employee No":=HRAppraisalGoalSettingH."Employee No";
    //                 HRAppraisalGoalSettingH.TESTFIELD(HRAppraisalGoalSettingH."Appraisal Period");
    //                 "Appraisal Period":=HRAppraisalGoalSettingH."Appraisal Period"


    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal No"; Code[30])
        {
            TableRelation = "HR Appraisal Header"."Appraisal No";
        }
        field(3; "Appraisal Period"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER("Appraisal Period"),
                                                           Closed = CONST(false));
        }
        field(4; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Employees"."No.";
        }
        field(5; Sections; Option)
        {
            OptionCaption = 'Objectives,Core Responsibilities/Duties,Last year''s goals,Things learnt From Training,Value Added From Training,Attendance&Punctuality,Communication,Cooperation,Internal/External Clients,Initiative,Planning & Organization,Quality,Team Work,Sales Skills,Leadership,Performance Coaching';
            OptionMembers = Objectives,"Core Responsibilities/Duties","Last year's goals","Things learnt From Training","Value Added From Training","Attendance&Punctuality",Communication,Cooperation,"Internal/External Clients",Initiative,"Planning & Organization",Quality,"Team Work","Sales Skills",Leadership,"Performance Coaching";
        }
        field(6; "Perfomance Goals and Targets"; Text[250])
        {
        }
        field(7; "Self Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                if "Self Rating" > maxRating then Error('[%1 %2] should have a Maximum Score of [%3]', FieldCaption("Self Rating"), "Self Rating", maxRating);
            end;
        }
        field(8; "Peer Rating"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Peer Rating" > maxRating then Error('The score %1 should have a max Score of %2', "Peer Rating", maxRating);
            end;
        }
        field(9; "Supervisor Rating"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Supervisor Rating" > maxRating then Error('The score %1 should have a max Score of %2', "Supervisor Rating", maxRating);
            end;
        }
        field(10; "Weighted Rating"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Weighted Rating" > maxRating then Error('The score %1 should have a max Score of %2', "Weighted Rating", maxRating);
            end;
        }
        field(11; "Performance Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                if "Performance Rating" > maxRating then Error('The score %1 should have a max Score of %2', "Performance Rating", maxRating);
            end;
        }
        field(17; "Agreed Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                if "Agreed Rating" > maxRating then Error('The score %1 should have a max Score of %2', "Agreed Rating", maxRating);
            end;
        }
        field(18; "Weight%"; Decimal)
        {
        }
        field(19; "Employee Comments"; Text[250])
        {
        }
        field(21; "Measurement Criteria"; Text[250])
        {
        }
        field(22; "Supervisor Comments"; Text[250])
        {
        }
        field(23; "Actual performance"; Text[200])
        {
        }
        field(25; "Approval Status"; Option)
        {
            OptionMembers = "Pending Approval",Approved;
        }
        field(26; "Categorize As"; Option)
        {
            OptionCaption = ' ,Employee''s Subordinates,Employee''s Peers,External Sources,Job Specific,Self Evaluation,Personal Goals/Objectives';
            OptionMembers = " ","Employee's Subordinates","Employee's Peers","External Sources","Job Specific","Self Evaluation","Personal Goals/Objectives";
        }
        field(27; "Sub Category"; Option)
        {
            OptionCaption = ' ,Objectives,Core Responsibilities / Duties,Attendance & Punctuality,Communication,Cooperation,Planning & Organization,Quality,Team Work,Sales Skills,Leadership,Performance Coaching,Personal Goals';
            OptionMembers = " ",Objectives,"Core Responsibilities / Duties","Attendance & Punctuality",Communication,Cooperation,"Planning & Organization",Quality,"Team Work","Sales Skills",Leadership,"Performance Coaching","Personal Goals";
        }
        field(28; "External Source Rating"; Decimal)
        {
        }
        field(29; Remarks; Text[250])
        {
        }
        field(30; "Min. Target Score"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Min. Target Score" > maxRating then Error('The score %1 should have a max Score of %2', "Min. Target Score", maxRating);
            end;
        }
        field(31; "Max Target Score"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Max Target Score" > maxRating then Error('The score %1 should have a max Score of %2', "Max Target Score", maxRating);
            end;
        }
        field(32; "Unit of Measure"; Code[20])
        {
            TableRelation = "Human Resource Unit of Measure".Code;
        }
        field(50000; "Key Performance Indicator"; Code[20])
        {
            //TableRelation = "HR Appraisal Company Target".Code;
        }
    }

    keys
    {
        key(Key1; "Line No", "Appraisal No", "Appraisal Period", "Employee No")
        {
        }
        key(Key2; Sections)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record "HR Employees";
        HRAppraisalGoalSettingH: Record "HR Appraisal Header";
        AppraisalScores: Record "HR Appraisal Lines";
        mycurrStatus: Boolean;
        objHRSetup: Record "HR Setup";
        Vendor: Record Vendor;
        Customer: Record Customer;

    procedure maxRating() maxRating: Decimal
    begin
        maxRating := 0;
        objHRSetup.Reset;
        objHRSetup.SetRange(objHRSetup."Primary Key");
        if objHRSetup.Find('-') then
            maxRating := objHRSetup."Max Appraisal Rating";
    end;
}

