/// <summary>
/// Table Business Income (ID 51532389).
/// </summary>
table 51532389 "Business Income"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(2; "Loan No."; Code[20])
        {
        }
        field(3; "First Day of Current Month"; Date)
        {
        }
        field(4; "Average Amount (Internal)"; Decimal)
        {
            Editable = false;
        }
        field(5; "Average Amount (External)"; Decimal)
        {
        }
        field(6; "Total Credits (Internal)"; Decimal)
        {
        }
        field(7; "Total Debits (Internal)"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    trigger OnInsert()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    trigger OnModify()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    trigger OnRename()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    var
        Text001: Label 'The loan is already %1 and cannot modify';
        LoanApp: Record Loans;
}

