table 51533025 "HR Leave Application"
{
    //DrillDownPageID = "HR Leave Applications List";
    //LookupPageID = "HR Leave Applications List";

    fields
    {
        field(1; "Application Code"; Code[20])
        {

            trigger OnValidate()
            begin
                //TEST IF MANUAL NOs ARE ALLOWED
                if "Application Code" <> xRec."Application Code" then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Leave Application Nos.");
                    "No series" := '';
                end;
            end;
        }
        field(3; "Leave Type"; Code[30])
        {
            TableRelation = "HR Leave Types".Code;

            trigger OnValidate()
            begin
                HRLeaveTypes.Reset;
                HRLeaveTypes.SetRange(HRLeaveTypes.Code, "Leave Type");
                if HRLeaveTypes.Find('-') then begin

                    if HRLeaveTypes.Gender <> HRLeaveTypes.Gender::Both then begin
                        HREmp.Reset;
                        HREmp.SetRange(HREmp."No.", "Applicant Staff No.");
                        if HREmp.Find('-') then begin
                            if HRLeaveTypes."Is Annual Leave" then begin

                                //  if HRLeaveTypes."Employee Category" <> HREmp."Employee Category" then
                                //    Error('You cannot choose Category %1 because you are in Category %2', HRLeaveTypes."Employee Category", HREmp."Employee Category");
                            end;
                            if HRLeaveTypes.Gender = HRLeaveTypes.Gender::Female then
                                if HREmp.Gender = HREmp.Gender::Male then
                                    Error('This leave type is restricted to the ' + Format(HRLeaveTypes.Gender) + ' gender');

                            if HRLeaveTypes.Gender = HRLeaveTypes.Gender::Male then
                                if HREmp.Gender = HREmp.Gender::Female then
                                    Error('This leave type is restricted to the ' + Format(HRLeaveTypes.Gender) + ' gender');

                        end;
                    end
                    else begin
                        HREmp.Reset;
                        HREmp.SetRange(HREmp."No.", "Applicant Staff No.");
                        if HREmp.Find('-') then begin
                            if HRLeaveTypes."Is Annual Leave" then begin
                                //  if HRLeaveTypes."Employee Category" <> HREmp."Employee Category" then
                                //      Error('You cannot choose Category %1 because you are in Category %2', HRLeaveTypes."Employee Category", HREmp."Employee Category");
                            end;

                        end;
                    end;


                end;
            end;
        }
        field(4; "Days Applied"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin


                TestField("Leave Type");



                //Calc. Ret/End Dates
                if ("Days Applied" <> 0) and ("Start Date" <> 0D) then begin
                    "Return Date" := DetermineLeaveReturnDate("Start Date", "Days Applied");
                    "End Date" := DeterminethisLeaveEndDate("Return Date");
                    Modify;
                end;
                if "Days Applied" >= 10 then "Request Leave Allowance" := true;
                if "Days Applied" < 10 then "Request Leave Allowance" := false;
                //check for overlap
                HRLeaveApp.Reset;
                HRLeaveApp.SetRange(HRLeaveApp."Applicant Staff No.", "Applicant Staff No.");
                HRLeaveApp.SetRange(HRLeaveApp.Status, HRLeaveApp.Status::Approved);
                if HRLeaveApp.Find('-') then begin
                    repeat
                    //IF "Start Date"<HRLeaveApp."Return Date" THEN
                    //ERROR('You already an active leave application!');
                    until HRLeaveApp.Next = 0;
                end;


                if "Days Applied" < 1 then Error('Days applied cannot be less than 1')
            end;
        }
        field(5; "Start Date"; Date)
        {

            trigger OnValidate()
            begin

                if "Start Date" = 0D then begin
                    if GuiAllowed then begin
                        "Return Date" := 0D;
                        "End Date" := 0D;
                    end;
                end else begin
                    if DetermineIfIsNonWorking("Start Date") = true then begin
                        Error('Start date must be a working day');
                    end;
                    Validate("Days Applied");
                end;
            end;
        }
        field(6; "Return Date"; Date)
        {
            Caption = 'Return Date';
        }
        field(7; "Application Date"; Date)
        {
        }
        field(12; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;

            trigger OnValidate()
            begin
                /*if Status = Status::Approved then begin
                    intEntryNo := 0;
                    HRLeaveCal.Reset;
                    HRLeaveCal.SetRange(HRLeaveCal."Current Leave Calendar", true);
                    HRLeaveCal.Find('-');

                    HRLeaveEntries.Reset;
                    if HRLeaveEntries.Findlast then intEntryNo := HRLeaveEntries."Entry No.";

                    intEntryNo := intEntryNo + 1;

                    HRLeaveEntries.Init;
                    HRLeaveEntries."Entry No." := intEntryNo;
                    HRLeaveEntries."Staff No." := "Applicant Staff No.";
                    HRLeaveEntries."Leave Calendar Code" := HRLeaveCal."Calendar Code";
                    HRLeaveEntries."Staff Name" := Names;
                    HRLeaveEntries."Posting Date" := Today;
                    HRLeaveEntries."Leave Entry Type" := HRLeaveEntries."Leave Entry Type"::Negative;
                    HRLeaveEntries."Leave Approval Date" := "Application Date";
                    HRLeaveEntries."Document No." := "Application Code";
                    HRLeaveEntries."External Document No." := "Applicant Staff No.";
                    HRLeaveEntries."Job ID" := "Job Tittle";
                    HRLeaveEntries."No. of days" := "Days Applied";
                    HRLeaveEntries."Leave Start Date" := "Start Date";
                    HRLeaveEntries."Leave Posting Description" := 'Leave';
                    HRLeaveEntries."Leave End Date" := "End Date";
                    HRLeaveEntries."Leave Return Date" := "Return Date";
                    HRLeaveEntries."User ID" := "Applicant User ID";
                    HRLeaveEntries."Leave Type" := "Leave Type";
                    HRLeaveEntries.Insert;
                end;*/

            end;
        }
        field(15; "Applicant Comments"; Text[250])
        {
        }
        field(17; "No series"; Code[30])
        {
        }
        field(18; Gender; Option)
        {
            Editable = false;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(28; Selected; Boolean)
        {
        }
        field(31; "Current Balance"; Decimal)
        {
            FieldClass = Normal;
        }
        field(32; Posted; Boolean)
        {
        }
        field(33; "Posted By"; Text[250])
        {
        }
        field(34; "Date Posted"; Date)
        {
        }
        field(35; "Time Posted"; Time)
        {
        }
        field(36; Reimbursed; Boolean)
        {
        }
        field(37; "Days Reimbursed"; Decimal)
        {
        }
        field(3900; "End Date"; Date)
        {
        }
        field(3901; "Total Taken"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(3921; "E-mail Address"; Text[60])
        {
            ExtendedDatatype = EMail;
        }
        field(3924; "Entry No"; Integer)
        {
        }
        field(3929; "Start Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(3936; "Cell Phone Number"; Code[20])
        {
            ExtendedDatatype = PhoneNo;
            NotBlank = true;
        }
        field(3937; "Request Leave Allowance"; Boolean)
        {
        }
        field(3939; Picture; BLOB)
        {
        }
        field(3940; Names; Text[100])
        {
        }
        field(3942; "Leave Allowance Entittlement"; Boolean)
        {
        }
        field(3943; "Leave Allowance Amount"; Decimal)
        {
        }
        field(3945; "Details of Examination"; Text[200])
        {
        }
        field(3947; "Date of Exam"; Date)
        {
        }
        field(3949; Reliever; Code[50])
        {
            TableRelation = "HR Employees"."No." WHERE(Status = CONST(Active));

            trigger OnValidate()
            begin
                if Reliever = "Applicant Staff No." then
                    Error('Employee cannot relieve him/herself');

                if HREmp.Get(Reliever) then begin
                    "Reliever Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                end else begin
                    "Reliever Name" := '';
                end;
            end;
        }
        field(3950; "Reliever Name"; Text[100])
        {
        }
        field(3952; Description; Text[30])
        {
        }
        field(3955; "Supervisor Email"; Text[50])
        {
        }
        field(3956; "Number of Previous Attempts"; Text[200])
        {
        }
        field(3958; "Job Tittle"; Text[50])
        {
        }
        field(3959; "Applicant User ID"; Code[50])
        {
        }
        field(3961; "Applicant Staff No."; Code[20])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(3962; "Applicant Supervisor"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(3969; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";

            trigger OnValidate()
            begin
                /*
                TESTFIELD(Status,Status::Pending);
                IF NOT UserMgt.CheckRespCenter(1,"Responsibility Center") THEN
                  ERROR(
                    Text001,
                    RespCenter.TABLECAPTION,UserMgt.GetPurchasesFilter);
                 {
                "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
                IF "Location Code" = '' THEN BEGIN
                  IF InvtSetup.GET THEN
                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                END ELSE BEGIN
                  IF Location.GET("Location Code") THEN;
                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                END;
                
                UpdateShipToAddress;
                   }
                   {
                CreateDim(
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::Vendor,"Pay-to Vendor No.",
                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                  DATABASE::Campaign,"Campaign No.");
                
                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                  RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                  "Assigned User ID" := '';
                END;
                  }
                   */

            end;
        }
        field(3970; "Approved days"; Integer)
        {

            trigger OnValidate()
            begin
                if "Approved days" > "Days Applied" then
                    Error(TEXT001);
            end;
        }
        field(3971; Attachments; Integer)
        {
            Editable = false;
        }
        field(3972; Emergency; Boolean)
        {
            Description = 'This is used to ensure one can apply annual leave which is emergency';
        }
        field(3973; "Approver Comments"; Text[200])
        {
        }
        field(3974; "Employee Name"; Text[100])
        {
        }
        field(3975; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                "Global Dimension 1 Name" := '';
                DimValue.Reset;
                DimValue.SetRange(DimValue.Code, "Global Dimension 1 Code");
                if DimValue.Find('-') then begin
                    "Global Dimension 1 Name" := DimValue.Name;
                end;
            end;
        }
        field(3976; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                "Global Dimension 2 Name" := '';
                DimValue.Reset;
                DimValue.SetRange(DimValue.Code, "Global Dimension 2 Code");
                if DimValue.Find('-') then begin
                    "Global Dimension 2 Name" := DimValue.Name;
                end;
            end;
        }
        field(3977; "Global Dimension 1 Name"; Text[60])
        {
            Editable = false;
        }
        field(3978; "Global Dimension 2 Name"; Text[60])
        {
            Editable = false;
        }
        field(3979; Address; Code[50])
        {
        }
        field(3980; "Alternative CellPhone No."; Integer)
        {
        }
        field(3981; "Leave Code"; Code[20])
        {
        }
        field(3982; Designation; Code[50])
        {
        }
        field(3983; "Leave Rejection Reason"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3984; "Handover Note"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3990; RecID; RecordID)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Application Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Application Code", Names)
        {
        }
    }

    trigger OnDelete()
    begin
        //ERROR('Please edit document instead of deleting');
    end;

    trigger OnInsert()
    begin
        if GuiAllowed then begin

            HREmp.Reset;
            HREmp.SetRange(HREmp."User ID", UserId);
            if HREmp.Find('-') then
                if HREmp.Status <> HREmp.Status::Active then begin
                    Error('You cannot apply Leave while inactive');
                end;
        end;

        //No. Series
        if "Application Code" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Leave Application Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Leave Application Nos.", xRec."No series", 0D, "Application Code", "No series");
        end;

        if GuiAllowed then begin
            HREmp.Reset;
            HREmp.SetRange(HREmp."User ID", UserId);
            if HREmp.Find('-') then begin
                HREmp.TestField(HREmp."Date Of Join");

                Calendar.Reset;
                Calendar.SetRange("Period Type", Calendar."Period Type"::Month);
                Calendar.SetRange("Period Start", HREmp."Date Of Join", Today);
                empMonths := Calendar.Count;


                //Populate fields
                "Applicant Staff No." := HREmp."No.";
                Names := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                Gender := HREmp.Gender;
                "Application Date" := Today;
                "Applicant User ID" := UserId;
                "Job Tittle" := HREmp."Job Title";
                HREmp.CalcFields(HREmp.Picture);
                "Applicant Supervisor" := HREmp."Supervisor Code";


                Picture := HREmp.Picture;
                //"Responsibility Center":=HREmp."Responsibility Center";
                //Approver details
                //GetApplicantSupervisor(USERID);

            end else begin
                Error('UserID' + ' ' + '[' + UserId + ']' + ' has not been assigned to any employee. Please consult the HR officer for assistance')
            end;

            if UserSetup.Get(UserId) then
                // "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                //"Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                RecID := rec.RecordId;

        end;

        HRLeaveCal.Reset;
        HRLeaveCal.SetRange(HRLeaveCal."Calendar Code", HRLeaveCal."Calendar Code");
        HRLeaveCal.SetRange(HRLeaveCal."Current Leave Calendar", true);
        if HRLeaveCal.Get then begin
            "Leave Code" := HRLeaveCal."Calendar Code";
        end;
    end;

    var
        Hrleavecalender: Record "HR Leave Calendar";
        UserSetup: Record "User Setup";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HREmp: Record "HR Employees";
        varDaysApplied: Integer;
        HRLeaveTypes: Record "HR Leave Types";
        BaseCalendarChange: Record "Base Calendar Change";
        ReturnDateLoop: Boolean;
        mSubject: Text[250];
        ApplicantsEmail: Text[30];
        SMTP: Codeunit "Mail Management";
        HRJournalLine: Record "HR Leave Journal Line";
        "LineNo.": Integer;
        ApprovalComments: Record "Approval Comment Line";
        URL: Text[500];
        sDate: Record Date;
        HRLeaveCal: Record "HR Leave Calendar";
        Customized: Record "HR Leave Calendar Lines";
        //HREmailParameters: Record "HR E-Mail Parameters";
        HRJournalBatch: Record "HR Leave Journal Batch";
        TEXT001: Label 'Days Approved cannot be more than applied days';
        HRLeaveEntries: Record "HR Leave Ledger Entries";
        LeaveEntries: record "HR Leave Ledger Entries";
        LeaveCalendar: Record "HR Leave Calendar";
        intEntryNo: Integer;
        Calendar: Record Date;
        empMonths: Integer;
        HRLeaveApp: Record "HR Leave Application";
        mWeekDay: Integer;
        empGender: Option Female;
        mMinDays: Integer;
        Text002: Label 'You cannot apply for leave until your are over [%1] months old in the company';
        Text003: Label 'UserID [%1] does not exist in [%2]';
        DimValue: Record "Dimension Value";
        //LeaveAllowances: Record "Leave Allowances";
        prVitalSetup: Record "PR Vital Setup Info";
        PRSalCard: Record "PR Salary Card";
        LeaveEMail: Text[100];
        //SendSMS: Codeunit SendSms;
        SourceType: Option "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application","Loan Witness";
        Members: Record Members;
        objPeriod: Record "PR Payroll Periods";
        PRTransactionCodes: Record "PR Transaction Codes";
        PREmployeeTrans: Record "PR Employee Transactions";
        Transcode: Record "PR Transaction Codes";
        CurrentYr: Integer;
    // PRAllowances: Record "PR Employee Allowances";
    //SalaryGrades: Record "Salary Grades";

    procedure DetermineLeaveReturnDate(var fBeginDate: Date; var fDays: Decimal) fReturnDate: Date
    begin
        varDaysApplied := fDays;
        fReturnDate := fBeginDate;
        repeat
            if DetermineIfIncludesNonWorking("Leave Type") = false then begin
                fReturnDate := CalcDate('1D', fReturnDate);
                if DetermineIfIsNonWorking(fReturnDate) then
                    varDaysApplied := varDaysApplied + 1
                else
                    varDaysApplied := varDaysApplied;
                varDaysApplied := varDaysApplied - 1
            end
            else begin
                fReturnDate := CalcDate('1D', fReturnDate);
                varDaysApplied := varDaysApplied - 1;
            end;
        until varDaysApplied = 0;
        exit(fReturnDate);
    end;

    procedure DetermineIfIncludesNonWorking(var fLeaveCode: Code[35]): Boolean
    begin
        if HRLeaveTypes.Get(fLeaveCode) then begin
            if HRLeaveTypes."Inclusive of Non Working Days" = true then
                exit(true);
        end;
    end;

    procedure DetermineIfIsNonWorking(var bcDate: Date) Isnonworking: Boolean
    begin

        Customized.Reset;
        Customized.SetRange(Customized.Date, bcDate);
        if Customized.Find('-') then begin
            if Customized."Non Working" = true then
                exit(true)
            else
                exit(false);
        end;
    end;

    procedure DeterminethisLeaveEndDate(var fDate: Date) fEndDate: Date
    begin
        ReturnDateLoop := true;
        fEndDate := fDate;
        if fEndDate <> 0D then begin
            fEndDate := CalcDate('-1D', fEndDate);
            while (ReturnDateLoop) do begin
                if DetermineIfIsNonWorking(fEndDate) then
                    fEndDate := CalcDate('-1D', fEndDate)
                else
                    ReturnDateLoop := false;
            end
        end;
        exit(fEndDate);
    end;

    procedure CreateLeaveLedgerEntries(AppNo: Code[20])
    begin

        //GET OPEN LEAVE PERIOD
        HRLeaveCal.Reset;
        HRLeaveCal.SetRange(HRLeaveCal."Current Leave Calendar", true);
        HRLeaveCal.Find('-');

        LeaveEntries.Reset;
        if LeaveEntries.Findlast then intEntryNo := LeaveEntries."Entry No.";


        HRLeaveEntries.Init;
        HRLeaveEntries."Entry No." := intEntryNo;
        HRLeaveEntries."Staff No." := "Applicant Staff No.";
        HRLeaveEntries."Leave Calendar Code" := HRLeaveCal."Calendar Code";
        HRLeaveEntries."Staff Name" := Names;
        HRLeaveEntries."Posting Date" := Today;
        HRLeaveEntries."Leave Entry Type" := HRLeaveEntries."Leave Entry Type"::Negative;
        HRLeaveEntries."Leave Approval Date" := "Application Date";
        HRLeaveEntries."Document No." := AppNo;
        HRLeaveEntries."External Document No." := "Applicant Staff No.";
        HRLeaveEntries."Job ID" := "Job Tittle";
        HRLeaveEntries."No. of days" := "Days Applied";
        HRLeaveEntries."Leave Start Date" := "Start Date";
        HRLeaveEntries."Leave Posting Description" := 'Leave';
        HRLeaveEntries."Leave End Date" := "End Date";
        HRLeaveEntries."Leave Return Date" := "Return Date";
        HRLeaveEntries."User ID" := "Applicant User ID";
        HRLeaveEntries."Leave Type" := "Leave Type";
        HRLeaveEntries.Insert;

        //Mark document as posted
        Posted := true;
        "Posted By" := UserId;
        "Date Posted" := Today;
        "Time Posted" := Time;
        Modify;
    end;

    procedure postLeave()
    var
        intEntryNo: Integer;
        HRLeaveEntries: Record "HR Leave Ledger Entries";
        HRLeaveEntries1: Record "HR Leave Ledger Entries";


    begin
        intEntryNo := 0;

        //GET OPEN LEAVE PERIOD
        LeaveCalendar.RESET;
        LeaveCalendar.SETRANGE(LeaveCalendar."Current Leave Calendar", TRUE);
        IF NOT LeaveCalendar.FINDFIRST THEN ERROR('Set Current Leave Calendar');

        HRLeaveEntries1.Reset;
        if HRLeaveEntries1.FindLast() then intEntryNo := HRLeaveEntries1."Entry No.";

        intEntryNo := intEntryNo + 1;

        HRLeaveEntries.Init;
        HRLeaveEntries."Entry No." := intEntryNo;
        HRLeaveEntries."Leave Calendar Code" := LeaveCalendar."Calendar Code";
        HRLeaveEntries."Staff No." := Rec."Applicant Staff No.";
        HRLeaveEntries."Staff Name" := Rec.Names;
        HRLeaveEntries."Posting Date" := Today;
        HRLeaveEntries."Leave Entry Type" := HRLeaveEntries."Leave Entry Type"::Negative;
        HRLeaveEntries."Document No." := Rec."Application Code";
        HRLeaveEntries."External Document No." := Rec."Application Code";
        HRLeaveEntries."No. of days" := Rec."Days Applied";
        HRLeaveEntries."Leave Posting Description" := Rec.Description;
        HRLeaveEntries."User ID" := USERID;
        HRLeaveEntries."Leave Type" := Rec."Leave Type";
        HRLeaveEntries.Insert;
        Message('Entries posted successfully');

    end;

    procedure NotifyApplicant()
    begin


        if "Cell Phone Number" <> '' then begin
            //SendSMS.SendSms(SourceType::"Leave Application", "Cell Phone Number", 'Your leave Application No. ' + "Application Code" + ' of ' + Format("Days Applied") + ' ' +
            //'has been Approved', "Application Code", '', false, false);
        end;


        LeaveEMail := HRSetup."Leave Notification Email";
        HREmp.Get("Applicant Staff No.");
        if HREmp."Company E-Mail" <> '' then begin

            /*SMTP.CreateMessage(
                                LeaveEMail,
                                '',
                                HREmp."Company E-Mail",
                                'Leave Approval Notification',
                                'Dear' + '<br>' + HREmp."First Name"+
                                'Your leave application no.'+"Application Code"+ '  '+'has been fully approved:<br><br>'+
                                '<br>Employee No. ' + "Applicant Staff No." + ' - '+ UpperCase(Names) +
                                '<br>Application No - ' + "Application Code"+
                                '<br>Start Date - ' + Format("Start Date") +
                                '<br>End Date - ' + Format("End Date") +
                                '<br>Return Date - ' + Format("Return Date") +
                                '<br>Days Applied - ' + Format("Days Applied")+
                                '<br><br>Kind Regards',
                                true
                              );

                             //SMTP.AddCC("Supervisor Email");
                             //SMTP.AddCC('fdgdgd');
                             //SMTP.AddAttachment('C:\Leave\'+"Application Code"+'.pdf',"Application Code");


            SMTP.TrySend();*/
            Message('Leave applicant has been notified successfully');

        end;
    end;

    local procedure GetApplicantSupervisor(EmpUserID: Code[50]) SupervisorID: Code[10]
    var
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        HREmp2: Record "HR Employees";
    begin
        SupervisorID := '';

        UserSetup.Reset;
        if UserSetup.Get(EmpUserID) then begin
            UserSetup.TestField(UserSetup."Approver ID");

            //Get supervisor e-mail
            UserSetup2.Reset;
            if UserSetup2.Get(UserSetup."Approver ID") then begin
                //UserSetup2.TESTFIELD(UserSetup2."E-Mail");
                //"Applicant Supervisor":=UserSetup."Approver ID";
                //"Supervisor Email":=UserSetup2."E-Mail";
            end;

        end else begin
            Error(Text003, EmpUserID, UserSetup.TableCaption);
        end;
    end;

    procedure NotifyReliever()
    begin
        HREmp.Get(Reliever);
        if HREmp."Company E-Mail" <> '' then begin

            /*HREmailParameters.Reset;
            HREmailParameters.Get(HREmailParameters."Associate With"::"Leave Notifications");
            SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HREmp."Company E-Mail",

            'Leave Reliever Notification','Dear' + '<br>' + HREmp."First Name"+
            'You are here notified that you''ve'+' '+'been selected as a Leave Reliever for'+' ' +Names+ ' '+'for a period of'+' '+Format("Days Applied")+
            ' '+'days'+' '+'from'+' '+Format("Start Date")+'to'+Format("End Date")+'.'+' '+'Please ensure that you understand the responsibilities given to you for that duration.',true);
            SMTP.TrySend();*/
            Message('Leave Reliever has been notified successfully');

        end;
    end;

    procedure AddLeaveAllowance()
    begin

        /*
        Members.RESET;
        Members.SETRANGE("Payroll/Staff No.","Applicant Staff No.");
        Members.SETRANGE("Account Category",Members."Account Category"::"Staff Members");
        IF Members.FINDFIRST THEN
            "Member No" := Members."No.";
        */


        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed, false);
        if objPeriod.Find('-') then begin


            PRTransactionCodes.Reset;
            PRTransactionCodes.SetRange("Special Transactions", PRTransactionCodes."Special Transactions"::"Leave Allowance");
            PRTransactionCodes.SetRange("Transaction Type", PRTransactionCodes."Transaction Type"::Income);
            if PRTransactionCodes.FindFirst then begin

                PREmployeeTrans.Reset;
                PREmployeeTrans.SetRange("Employee Code", "Applicant Staff No.");
                PREmployeeTrans.SetRange("Transaction Code", PRTransactionCodes."Transaction Code");
                PREmployeeTrans.SetRange("Period Month", objPeriod."Period Month");
                PREmployeeTrans.SetRange("Period Year", objPeriod."Period Year");
                PREmployeeTrans.SetRange("Payroll Period", objPeriod."Date Opened");
                if PREmployeeTrans.FindFirst then
                    PREmployeeTrans.Delete;

                PREmployeeTrans.Init;
                PREmployeeTrans."Employee Code" := ("Applicant Staff No.");
                PREmployeeTrans."Transaction Code" := (PRTransactionCodes."Transaction Code");
                PREmployeeTrans."Period Month" := (objPeriod."Period Month");
                PREmployeeTrans."Period Year" := (objPeriod."Period Year");
                PREmployeeTrans."Payroll Period" := (objPeriod."Date Opened");
                PREmployeeTrans."Member No" := Members."No.";
                PREmployeeTrans.Validate("Transaction Code", PRTransactionCodes."Transaction Code");
                PREmployeeTrans.Insert(true);
                "Leave Allowance Amount" := PREmployeeTrans.Amount;
                Message('Leave Allowance Attached to Payroll');
                HREmp.Get("Applicant Staff No.");
                HREmp."Leave Allowance Date" := Today;
                HREmp.Modify;
            end;
            //objEmpTrans.RESET;
            //objEmpTrans.SETRANGE("Payroll Period",SelectedPeriod);
        end;

    end;

    local procedure InsertLeaveAllowance()
    begin

        /*HREmp.Reset;
        HREmp.SetRange("No.","Applicant Staff No.");
        if HREmp.FindFirst then begin
          SalaryGrades.Reset;
          SalaryGrades.SetRange("Salary Grade",HREmp."Salary Grade");
          if SalaryGrades.FindFirst then begin
        Transcode.Reset;
        Transcode.SetFilter("Special Transactions",'%1',Transcode."Special Transactions"::"Leave Allowance");
        if Transcode.Find('-') then begin
                objPeriod.Reset;
              objPeriod.SetRange(objPeriod.Closed,false);
              if objPeriod.FindFirst then begin
                    PREmployeeTrans.Reset;
                    PREmployeeTrans.SetRange("Employee Code","Applicant Staff No.");
                    PREmployeeTrans.SetRange("Transaction Code",Transcode."Transaction Code");
                    PREmployeeTrans.SetRange("Period Year",objPeriod."Period Year");
                    if  not PREmployeeTrans.FindFirst then begin

            PRTransactionCodes.Reset;
            PRTransactionCodes.SetRange("Transaction Type",PRTransactionCodes."Transaction Type"::Income);
            PRTransactionCodes.SetFilter("Special Transactions",'%1',PRTransactionCodes."Special Transactions"::"Leave Allowance");
            if PRTransactionCodes.FindFirst then begin
                repeat
                    PREmployeeTrans.Init;
                    PREmployeeTrans."Employee Code":=("Applicant Staff No.");
                    PREmployeeTrans."Transaction Code":=(PRTransactionCodes."Transaction Code");
                    PREmployeeTrans."Transaction Name":=PRTransactionCodes."Transaction Name";
                    PREmployeeTrans."Period Month":=(objPeriod."Period Month");
                    PREmployeeTrans."Period Year":=(objPeriod."Period Year");
                    PREmployeeTrans.Amount:=SalaryGrades."Leave Allowance";
                    PREmployeeTrans."Payroll Period":=(objPeriod."Date Opened");
                    PREmployeeTrans."Member No":=Members."No.";
                   // PREmployeeTrans.VALIDATE("Transaction Code",PRTransactionCodes."Transaction Code");
                    PREmployeeTrans.Insert(true);
                until PRTransactionCodes.Next=0;
                Message('Generation Completed');
                end;
            end;
            end;
            end;
            end;
            end;*/
    end;

    procedure DetermineLeaveReturnDate_Portal(var fBeginDate: Date; var fDays: Decimal; var LeaveType: Code[30]) fReturnDate: Date
    begin
        varDaysApplied := fDays;
        fReturnDate := fBeginDate;
        repeat
            if DetermineIfIncludesNonWorking(LeaveType) = false then begin
                fReturnDate := CalcDate('1D', fReturnDate);
                if DetermineIfIsNonWorking(fReturnDate) then
                    varDaysApplied := varDaysApplied + 1
                else
                    varDaysApplied := varDaysApplied;
                varDaysApplied := varDaysApplied - 1
            end
            else begin
                fReturnDate := CalcDate('1D', fReturnDate);
                varDaysApplied := varDaysApplied - 1;
            end;
        until varDaysApplied = 0;
        exit(fReturnDate);
    end;
}

