table 51533191 "HR Disciplinary Cases NCA"
{
    //DrillDownPageID = "HR Disciplinary Cases List N";
    //LookupPageID = "HR Disciplinary Cases List N";

    fields
    {
        field(1; "Case Number"; Code[20])
        {
        }
        field(3; "Date of Complaint"; Date)
        {
        }
        field(4; "Type Complaint"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Disciplinary Case"));
        }
        field(5; "Recommended Action"; Code[20])
        {
            TableRelation = "HR Disciplinary Actions"."Action Code";

            trigger OnValidate()
            begin
                DisciActions.Reset;
                DisciActions.SetRange(DisciActions."Action Code", "Recommended Action");
                if DisciActions.Find('-') then
                    "Recommended Action Description" := DisciActions."Recommended Action";

                //IF ("Disciplinary Stage Status"="Disciplinary Stage Status"::Reported) AND ("Disciplinary Stage Status"="Disciplinary Stage Status"::"Under Investigation") THEN
                //  ERROR('You cannot fill the recommended action if the Disciplinary stage status is not after investigation')
                if "Disciplinary Stage Status" <> "Disciplinary Stage Status"::"In progress" then
                    Error('Dsciplinary stage status must be in progress');
            end;
        }
        field(6; "Description of Complaint"; Text[250])
        {
        }
        field(7; Reporter; Code[10])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                if "Accused Employee" = Reporter then
                    Error('An employee cannot accuse his/her self');

                Emp.Reset;
                Emp.SetRange(Emp."No.", Reporter);
                if Emp.Find('-') then
                    "Reporter Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";

                if "Accussed By" = "Accussed By"::"Non-Employee" then
                    Error('You are not allowed to Type Name if accused is an Non Employee');
            end;
        }
        field(8; "Witness #1"; Code[20])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                Emp.Reset;
                Emp.SetRange(Emp."No.", "Witness #1");
                if Emp.Find('-') then
                    "Witness #1 Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                if "Witness #1" = "Accused Employee" then
                    Error('Accused employee cannot be a witness');
            end;
        }
        field(9; "Witness #2"; Code[20])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                Emp.Reset;
                Emp.SetRange(Emp."No.", "Witness #2");
                if Emp.Find('-') then
                    "Witness #2  Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                if "Witness #2" = "Accused Employee" then
                    Error('Accused employee cannot  be a witness');
            end;
        }
        field(10; "Action Taken"; Option)
        {
            OptionCaption = ' ,Verbal Warning,1st Letter Warning,2nd Letter Warning,3rd Letter Warning,Final Letter Warning,Interdiction,Suspension';
            OptionMembers = " ","Verbal Warning","1st Letter Warning","2nd Letter Warning","3rd Letter Warning","Final Letter Warning",Interdiction,Suspension;

            trigger OnValidate()
            begin
                DisciActions.Reset;
                //DisciActions.SETRANGE(DisciActions."Action Code","Action Taken");
                if DisciActions.Find('-') then
                    "Taken Action Description" := DisciActions."Recommended Action";
            end;
        }
        field(11; "Date To Discuss Case"; Date)
        {

            trigger OnValidate()
            begin
                if "Date To Discuss Case" < "Date of Complaint" then
                    Error('Date To Discuss Case cannot be less than Date of complaint')
            end;
        }
        field(12; "Document Link"; Text[200])
        {
        }
        field(13; "Disciplinary Remarks"; Text[30])
        {
        }
        field(14; Comments; Text[250])
        {
        }
        field(15; "Case Discussion"; Boolean)
        {
        }
        field(16; "Body Handling The Complaint"; Code[100])
        {
            TableRelation = "HR Committees".Code;

            trigger OnValidate()
            begin
                Committees.Reset;
                Committees.SetRange(Committees.Code, "Body Handling The Complaint");
                if Committees.Find('-') then
                    "Body Handling Name" := Committees.Description;
            end;
        }
        field(17; Recomendations; Code[10])
        {
        }
        field(18; "HR/Payroll Implications"; Integer)
        {
        }
        field(19; "Support Documents"; Option)
        {
            OptionMembers = Yes,No;
        }
        field(20; "Policy Guidlines In Effect"; Code[10])
        {
            TableRelation = "HR Policies".Code;

            trigger OnValidate()
            begin
                Policies.Reset;
                Policies.SetRange(Policies.Code, "Policy Guidlines In Effect");
                if Policies.Find('-') then
                    "Policy Description" := Policies."Document Description";
            end;
        }
        field(21; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved';
            OptionMembers = New,"Pending Approval",Approved;
        }
        field(22; "Mode of Lodging the Complaint"; Text[30])
        {
        }
        field(23; "No. Series"; Code[20])
        {
        }
        field(24; "Accused Employee"; Code[30])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                Emp.Reset;
                Emp.SetRange(Emp."No.", "Accused Employee");
                if Emp.Find('-') then begin
                    "Accused Employee Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                    "Head of Department Name" := Emp."Supervisor Name";


                    //get HOD
                    /*HOD.Reset;
                     HOD.SetRange(HOD."Global Dimension 1 Code", Emp."Global Dimension 1 Code");
                     HOD.SetRange(HOD."Global Dimension 2 Code", Emp."Global Dimension 2 Code");
                     if HOD.Find('-') then begin
                         "Head of Department" := HOD."Employee No.";
                         Validate("Head of Department");
                     end else
                         Message('No HOD has been set this Employee');*/
                end;
            end;
        }
        field(25; Selected; Boolean)
        {
        }
        field(26; "Closed By"; Code[20])
        {
        }
        field(27; "Body Handling Name"; Text[50])
        {
        }
        field(28; "Policy Description"; Text[50])
        {
        }
        field(29; "Taken Action Description"; Text[50])
        {
        }
        field(30; "Recommended Action Description"; Text[50])
        {
        }
        field(3963; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(3964; "Reporter Name"; Text[40])
        {
        }
        field(3965; "Witness #1 Name"; Text[50])
        {
        }
        field(3966; "Witness #2  Name"; Text[50])
        {
        }
        field(3967; "Disciplinary Stage Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Reported,Under Investigation,In progress,Closed,Under review,court case,closed by court,Withdrawn';
            OptionMembers = Reported,"Under Investigation","In progress",Closed,"Under review","court case","closed by court",Withdrawn;
        }
        field(3968; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,Receipt,Staff Claim,Staff Advance,AdvanceSurrender,Store Requisition,Employee Requisition,Leave Application,Transport Requisition,Training Requisition,Job Approval,Induction Approval,Disciplinary Approvals,Activity Approval';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval";
        }
        field(3969; "User ID"; Code[50])
        {
        }
        field(3970; "Accused Employee Name"; Text[100])
        {
        }
        field(3971; "Accussed By"; Option)
        {
            OptionMembers = Employee,"Non-Employee";
        }
        field(3972; "Non Employee Reporter"; Text[100])
        {

            trigger OnValidate()
            begin
                if "Accussed By" = "Accussed By"::Employee then
                    Error('You are not allowed to Type Name if accused is an employee');
            end;
        }
        field(3973; Appealed; Boolean)
        {
        }
        field(50000; "Date of Complaint was Reported"; Date)
        {

            trigger OnValidate()
            begin
                if "Date of Complaint was Reported" > "Date of Complaint" then
                    Error('Date of Complaint was Reported cannot  greater than Date of complaint');
                if "Date of Complaint was Reported" < CalcDate('-3M', Today) then
                    Error('You cannot report a case is 3 months on')
            end;
        }
        field(50001; "Severity Of the Complain"; Option)
        {
            OptionMembers = Major,Minor;
        }
        field(50002; "Review Findings"; Text[250])
        {
        }
        field(50003; "Action Duration Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Action Duration Start Date" <> 0D then begin
                    if "Action Duration End  Date" < "Action Duration Start Date" then
                        Error('Can not have a date later than ' + Format("Action Duration Start Date"));
                end;
            end;
        }
        field(50004; "Action Duration End  Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Action Duration End  Date" < "Action Duration Start Date" then
                    Error('Can not have a date later than ' + Format("Action Duration Start Date"));
            end;
        }
        field(50005; "Head of Department"; Code[20])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                Emp.Reset;
                if Emp.Get("Head of Department") then
                    "Head of Department Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name"
                else
                    "Head of Department Name" := '';
            end;
        }
        field(50006; "Head of Department Name"; Text[100])
        {
        }
        field(50007; "Interdict Employee"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Interdict Employee" = false then
                    Question := 'Are you sure you want to post this to payroll?';
                Answer := DIALOG.Confirm(Question, false);
                if Answer = true then begin
                    salCard.Reset;
                    salCard.SetRange(salCard."Employee Code", "Accused Employee");
                    if salCard.Find('-') then begin
                        salCard."Basic Pay" := salCard."Basic Pay" * 2;
                        //ERROR(FORMAT(salCard."Basic Pay"));
                        salCard.Modify
                    end
                end
            end;
        }
        field(50008; "Interdiction Duration"; Text[50])
        {
        }
        field(50009; "Court Decision"; Text[100])
        {
        }
        field(50010; "Court Decision Date"; Date)
        {
        }
        field(50011; "Appeal Finding"; Text[100])
        {
        }
        field(50012; "Appeal Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Appeal Date" < "Date of Complaint" then
                    Error('Appeal DAte cannot less than date of Complaint');
            end;
        }
        field(50013; "Appeal Decision"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Case Number")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //GENERATE NEW NUMBER FOR THE DOCUMENT
        if "Case Number" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Disciplinary Cases Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Disciplinary Cases Nos.", xRec."No. Series", 0D, "Case Number", "No. Series");
        end;

        "User ID" := UserId;
        "Date of Complaint" := Today;
    end;

    trigger OnModify()
    begin
        /*IF Status=Status::"" THEN
        ERROR('You cannot modify a case Under Investigation');
         */

    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Emp: Record "HR Employees";
        Committees: Record "HR Committees";
        Policies: Record "HR Policies";
        LookUp: Record "HR Lookup Values";
        DisciActions: Record "HR Disciplinary Actions";
        //HOD: Record "HR Heads of Departments";
        DOC: Integer;
        salCard: Record "PR Salary Card";
        Question: Text[250];
        Answer: Boolean;
}

