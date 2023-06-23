/// <summary>
/// Table Partial Disbursement Schedule (ID 51532077).
/// </summary>
table 51532077 "Partial Disbursement Schedule"
{

    fields
    {
        field(1; "Loan No."; Code[30])
        {
        }
        field(2; "Scheduled Disbursement Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Scheduled Disbursement Date" < Today then
                    Error(DateErr);

                /*
                IF LoanApp.GET("Loan No.") THEN BEGIN
                  IF (LoanApp.Status=LoanApp.Status::Appraisal) OR (LoanApp.Status=LoanApp.Status::Approved) THEN BEGIN
                      IF "Scheduled Disbursement Date"<TODAY THEN
                        ERROR(DateErr);
                  END
                  ELSE BEGIN
                    IF "Scheduled Disbursement Date"<TODAY THEN
                      ERROR(DateErr);
                  END;
                END;
                */

            end;
        }
        field(3; Amount; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                StatusChangePermissions.Reset;
                StatusChangePermissions.SetRange("User ID", UserId);
                StatusChangePermissions.SetRange("Update Partial Disbursement", true);
                if not StatusChangePermissions.FindFirst then
                    if LoanApp.Get("Loan No.") then begin
                        if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then begin
                            Error('You cannot Modify This Once the loan has been posted or approved');
                        end;
                    end;
                Partial.Reset;
                Partial.SetRange(Partial."Loan No.", Rec."Loan No.");
                if Partial.FindFirst then
                    Partial.CalcSums(Amount);

                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Loan No.", "Loan No.");
                if LoanApp.FindFirst then begin
                    if (Partial.Amount + LoanApp."Amount To Disburse") > LoanApp."Approved Amount" then Error('Amount distributed cannot be greater thatn amount approved');
                end;
            end;
        }
        field(4; Posted; Boolean)
        {
            Editable = false;
        }
        field(5; "Entry No"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(6; "Disbursement Destination"; Option)
        {
            OptionCaption = 'Front Office,Cheque,MPesa,Bank Transfer';
            OptionMembers = "Front Office",Cheque,MPesa,"Bank Transfer";

            trigger OnValidate()
            begin
                StatusChangePermissions.Reset;
                StatusChangePermissions.SetRange("User ID", UserId);
                StatusChangePermissions.SetRange("Update Partial Disbursement", true);
                if not StatusChangePermissions.FindFirst then
                    if LoanApp.Get("Loan No.") then begin
                        if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then begin
                            Error('You cannot Modify This Once the loan has been posted or approved');
                        end;
                    end;
            end;
        }
        field(7; "Suggested for Disbursement"; Boolean)
        {
        }
        field(8; Remarks; Text[150])
        {

            trigger OnValidate()
            begin
                StatusChangePermissions.Reset;
                StatusChangePermissions.SetRange("User ID", UserId);
                StatusChangePermissions.SetRange("Update Partial Disbursement", true);
                if not StatusChangePermissions.FindFirst then
                    if LoanApp.Get("Loan No.") then begin
                        if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then begin
                            Error('You cannot Modify This Once the loan has been posted or approved');
                        end;
                    end;
            end;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        if Posted then
            Error(PostedErr);

        StatusChangePermissions.Reset;
        StatusChangePermissions.SetRange("User ID", UserId);
        StatusChangePermissions.SetRange("Update Partial Disbursement", true);
        if not StatusChangePermissions.FindFirst then
            if LoanApp.Get("Loan No.") then begin
                if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                    Error(Text001, LoanApp.Status);
            end;
    end;

    trigger OnInsert()
    begin
        StatusChangePermissions.Reset;
        StatusChangePermissions.SetRange("User ID", UserId);
        StatusChangePermissions.SetRange("Update Partial Disbursement", true);
        if not StatusChangePermissions.FindFirst then
            if LoanApp.Get("Loan No.") then begin
                if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                    Error(Text001, LoanApp.Status);
            end;
    end;

    trigger OnModify()
    begin
        if Posted then
            Error(PostedErr);
    end;

    trigger OnRename()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    var
        DateErr: Label 'Scheduled disbursement date MUST be earlier than today';
        PostedErr: Label 'You cannot modify a posted disbursement';
        Text001: Label 'Loan is already %1 and cannot be Modified';
        LoanApp: Record Loans;
        StatusChangePermissions: Record "Status Change Permissions";
        Partial: Record "Partial Disbursement Schedule";
}

