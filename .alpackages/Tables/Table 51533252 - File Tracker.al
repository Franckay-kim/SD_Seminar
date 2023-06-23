/// <summary>
/// Table File Tracker (ID 51533252).
/// </summary>
table 51533252 "File Tracker"
{
    //DrillDownPageID = "File Request List";
    //LookupPageID = "File Request List";

    fields
    {
        field(1; "Request Number"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "File Number"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members."No.";

            trigger OnValidate()
            begin
                if cust.Get("File Number") then begin
                    "Member Name" := cust.Name;
                    "ID No." := cust."ID No.";
                    "Staff No" := cust."Payroll/Staff No.";

                end;
            end;
        }
        field(3; "Folio Number"; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Move to"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "File Stages".Stage;

            trigger OnValidate()
            begin
                APPSET.Reset;
                APPSET.SetRange(APPSET.Stage, "Move to");
                if APPSET.Find('-') then begin
                    "Office Name" := APPSET.Station;
                end;


                //FileMovementTracker.RESET;
                //FileMovementTracker.SETRANGE(FileMovementTracker."Member No.","File Number");
                //IF FileMovementTracker.FIND('+') THEN BEGIN
                //IF FileMovementTracker.Stage = "Current File Location" THEN // "Move to" THEN
                //ERROR('File already in %1',FileMovementTracker.Station);
                //END;
            end;
        }
        field(5; "File Movement Remarks"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Reconciliation purposes,Auditing purposes,Refunds,Loans,Withdrawal,BBF,payments,Custody,Document Filing,Passbook,Complaint Letters,Defaulters,Dividends,Termination,New Members Details,New Members Verification,Share Transfer,Deposit Adjustments,Guarantorship,FOSA';
            OptionMembers = " ","Reconciliation purposes","Auditing purposes",Refunds,Loans,Withdrawal,BBF,payments,Custody,"Document Filing",Passbook,"Complaint Letters",Defaulters,Dividends,Termination,"New Members Details","New Members Verification","Share Transfer","Deposit Adjustments",Guarantorship,FOSA;

            trigger OnValidate()
            begin
                FileT.Reset;
                FileT.SetRange(FileT."File Number", "File Number");
                FileT.SetRange(FileT."File Movement Remarks", "File Movement Remarks");
                if FileT.Find('-') then
                    Error('Record already exists please modify The Existing record for transfer');

                Remark := Format("File Movement Remarks");

                FileMovementTracker.Reset;
                FileMovementTracker.SetRange(FileMovementTracker."Member No.", "File Number");
                FileMovementTracker.SetRange(FileMovementTracker.Remarks, Remark);
                if FileMovementTracker.Find('+') then begin
                    if FileMovementTracker.Stage = "Current File Location" then // "Move to" THEN
                        Error('File already in %1', FileMovementTracker.Station);
                end;
            end;
        }
        field(6; "File MVT User ID"; Code[60])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(7; "File MVT Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Current File Location"; Code[20])
        {
            CalcFormula = Max("File Movement Tracker".Stage WHERE("Member No." = FIELD("File Number"),
                                                                   "Current Location" = CONST(true),
                                                                   Stage = FIELD("Move to")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "File MVT Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "File received date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "File received Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "File Received by"; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "File Received"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Action"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open ,Issued,Received';
            OptionMembers = "Open ",Issued,Received;
        }
        field(15; "Member Name"; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Office Name"; Code[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Sent To"; Code[60])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18; "File Recalled"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "ID No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; Overdue; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Loan No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Loans."Loan No." WHERE("Member No." = FIELD("File Number"));

            trigger OnValidate()
            begin
                //MEMBER WITH AN EXISTING APPLICATION
                FileT.Reset;
                FileT.SetRange(FileT."File Number", "File Number");
                FileT.SetRange(FileT."Loan No", "Loan No");
                //MESSAGE('%1',"Loan No");
                FileT.SetRange(FileT."File Received by", '');

                if FileT.Find('-') then begin
                    repeat
                        if FileT."Request Number" <> "Request Number" then
                            Error('File already has an existing application. Let the previous file be received before proceeding.');
                    until FileT.Next = 0;
                end;
                //MEMBER WITH AN EXISTING LOAN APPLICATION
            end;
        }
        field(24; "Staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Other  Doc  No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "File  Forwarded"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Request Number")
        {
        }
    }

    fieldgroups
    {
    }

    var
        FileMovementTracker: Record "File Movement Tracker";
        cust: Record Members;
        APPSET: Record "File Stages";
        FileT: Record "File Tracker";
        Loanapp: Record Loans;
        FileTrack: Record "File Tracker";
        Remark: Text;
}

