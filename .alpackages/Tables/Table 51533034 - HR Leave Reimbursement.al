/// <summary>
/// Table HR Leave Reimbursement (ID 51533034).
/// </summary>
table 51533034 "HR Leave Reimbursement"
{
    //DrillDownPageID = "HR Leave Reimbursment List";
    //LookupPageID = "HR Leave Reimbursment List";

    fields
    {
        field(1; "Application Code"; Code[20])
        {
        }
        field(3; "Leave Type"; Code[20])
        {
            TableRelation = "HR Leave Types".Code;
        }
        field(4; "Days Applied"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(5; "Start Date"; Date)
        {
        }
        field(6; "Return Date"; Date)
        {
            Caption = 'Return Date';
            Editable = true;
        }
        field(7; "Application Date"; Date)
        {
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;

            trigger OnValidate()
            begin
                if Status = Status::Approved then
                    CreateLeaveLedgerEntries;
            end;
        }
        field(15; "Applicant Comments"; Text[250])
        {
        }
        field(17; "No series"; Code[30])
        {
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
        field(3900; "End Date"; Date)
        {
            Editable = false;
        }
        field(3901; "Total Taken"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(3921; "E-mail Address"; Text[60])
        {
            Editable = false;
            ExtendedDatatype = EMail;
        }
        field(3924; "Entry No"; Integer)
        {
        }
        field(3929; "Start Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(3936; "Cell Phone Number"; Text[50])
        {
            ExtendedDatatype = PhoneNo;
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
            //TableRelation = "HR Succession Job Rotation"."Line No.";
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
        field(3959; "User ID"; Code[50])
        {
        }
        field(3961; "Employee No"; Code[20])
        {
        }
        field(3962; Supervisor; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(3969; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility CenterBR".Code;
        }
        field(3970; "Leave Application No"; Code[20])
        {
            TableRelation = "HR Leave Application"."Application Code" WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                HRLeaveApp.Reset;
                if HRLeaveApp.Get("Leave Application No") then begin
                    "Leave Type" := HRLeaveApp."Leave Type";
                    "Start Date" := HRLeaveApp."Start Date";
                    "Return Date" := HRLeaveApp."Return Date";
                    "Days Applied" := HRLeaveApp."Days Applied";
                    "Employee No" := HRLeaveApp."Applicant Staff No.";
                    Names := HRLeaveApp.Names;
                    "Job Tittle" := HRLeaveApp."Job Tittle";
                end else begin
                    "Leave Type" := '';
                    "Start Date" := 0D;
                    "Return Date" := 0D;
                    "Days Applied" := 0;
                end;
            end;
        }
        field(3971; "Days to Reimburse"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Days to Reimburse" < 0 then
                    Error('Invalid Days');

                if "Days to Reimburse" > 0 then
                    if "Days to Reimburse" > "Days Applied" then
                        Error('Days to Reimburse cannot be greater than Days initially taken');
            end;
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
    }

    trigger OnInsert()
    begin
        //GENERATE NEW NUMBER FOR THE DOCUMENT
        if "Application Code" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Leave Reimbursment Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Leave Reimbursment Nos.", xRec."No series", 0D, "Application Code", "No series");
        end;
        /*
        //GET APPLICANT DETAILS FROM HR EMPLOYEES TABLE AND COPY THEM TO THE LEAVE APPLICATION TABLE
        HREmp.RESET;
        HREmp.SETRANGE(HREmp."User ID",USERID);
        IF HREmp.FIND('-') THEN
        BEGIN
            "Employee No":=HREmp."No.";
            "Job Tittle":=HREmp."Job Title";
            "User ID":=USERID;
        END ELSE
        BEGIN
            ERROR('User id'+' '+'['+USERID+']'+' has not been assigned to any employee. Please consult the HR officer for assistance')
        END;
        */
        //POPULATE FIELDS
        "Application Date" := Today;

    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HREmp: Record "HR Employees";
        TEXT001: Label 'Days Approved cannot be more than applied days';
        HRLeaveApp: Record "HR Leave Application";
        HRJournalLine: Record "HR Leave Journal Line";
        HRJournalBatch: Record "HR Leave Journal Batch";
        "LineNo.": Integer;
        HRLeaveCal: Record "HR Leave Calendar";

    /// <summary>
    /// DetermineLeaveReturnDate.
    /// </summary>
    /// <param name="fBeginDate">VAR Date.</param>
    /// <param name="fDays">VAR Decimal.</param>
    /// <returns>Return variable fReturnDate of type Date.</returns>
    procedure DetermineLeaveReturnDate(var fBeginDate: Date; var fDays: Decimal) fReturnDate: Date
    begin
    end;

    /// <summary>
    /// DetermineIfIncludesNonWorking.
    /// </summary>
    /// <param name="fLeaveCode">VAR Code[10].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure DetermineIfIncludesNonWorking(var fLeaveCode: Code[10]): Boolean
    begin
    end;

    /// <summary>
    /// DetermineIfIsNonWorking.
    /// </summary>
    /// <param name="bcDate">VAR Date.</param>
    /// <returns>Return variable Isnonworking of type Boolean.</returns>
    procedure DetermineIfIsNonWorking(var bcDate: Date) Isnonworking: Boolean
    begin
    end;

    /// <summary>
    /// DeterminethisLeaveEndDate.
    /// </summary>
    /// <param name="fDate">VAR Date.</param>
    /// <returns>Return variable fEndDate of type Date.</returns>
    procedure DeterminethisLeaveEndDate(var fDate: Date) fEndDate: Date
    begin
    end;

    /// <summary>
    /// CreateLeaveLedgerEntries.
    /// </summary>
    procedure CreateLeaveLedgerEntries()
    begin

        //GET OPEN LEAVE PERIOD
        HRLeaveCal.Reset;
        HRLeaveCal.SetRange(HRLeaveCal."Current Leave Calendar", true);
        HRLeaveCal.Find('-');

        HRJournalBatch.Reset;
        HRSetup.Get;
        HRSetup.TestField(HRSetup."Default Leave Posting Template");
        HRSetup.TestField(HRSetup."Positive Leave Posting Batch");

        HRJournalBatch.Get(HRSetup."Default Leave Posting Template", HRSetup."Positive Leave Posting Batch");

        //POPULATE JOURNAL LINES
        HRJournalLine.Reset;
        HRJournalLine.SetRange(HRJournalLine."Journal Template Name", HRSetup."Default Leave Posting Template");
        HRJournalLine.SetRange(HRJournalLine."Journal Batch Name", HRSetup."Negative Leave Posting Batch");
        if not HRJournalLine.Find('-') then
            HRJournalLine."Line No." := 1000
        else
            HRJournalLine.DeleteAll;
        HRJournalLine."Line No." := HRJournalLine."Line No." + 1000;

        "LineNo." := HRJournalLine."Line No.";

        HRJournalLine.Init;
        HRJournalLine."Journal Template Name" := HRSetup."Default Leave Posting Template";
        HRJournalLine."Journal Batch Name" := HRSetup."Positive Leave Posting Batch";
        HRJournalLine."Line No." := "LineNo.";
        HRJournalLine."Leave Calendar Code" := HRLeaveCal."Calendar Code";
        HRJournalLine."Document No." := "Application Code";
        HRJournalLine."Staff No." := "Employee No";
        HRJournalLine.Validate(HRJournalLine."Staff No.");
        HRJournalLine."Posting Date" := Today;
        HRJournalLine."Leave Entry Type" := HRJournalLine."Leave Entry Type"::Reimbursement;
        HRJournalLine."Leave Approval Date" := Today;
        HRJournalLine.Description := 'Reimbursement for Leave Application: ' + "Leave Application No";
        HRJournalLine."Leave Type" := "Leave Type";
        HRJournalLine."Leave Period Start Date" := HRLeaveCal."Start Date";
        HRJournalLine."Leave Period End Date" := HRLeaveCal."End Date";
        HRJournalLine."No. of Days" := "Days to Reimburse";

        //Mark document as posted
        Posted := true;
        "Posted By" := UserId;
        "Date Posted" := Today;
        "Time Posted" := Time;

        HRJournalLine.Insert(true);

        //Post Journal
        HRJournalLine.Reset;
        HRJournalLine.SetRange("Journal Template Name", HRSetup."Default Leave Posting Template");
        HRJournalLine.SetRange("Journal Batch Name", HRSetup."Positive Leave Posting Batch");
        if HRJournalLine.Find('-') then begin
            //  CODEUNIT.Run(CODEUNIT::"HR Leave Jnl.-Post",HRJournalLine);
            //Notify Leave Applicant
            //NotifyApplicant;
        end;
    end;

    /// <summary>
    /// NotifyApplicant.
    /// </summary>
    procedure NotifyApplicant()
    begin
    end;
}

