/// <summary>
/// Table Payment Methods (ID 51532414).
/// </summary>
table 51532414 "Payment Methods"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(2; "Member No."; Code[20])
        {
        }
        field(3; "Payment Method"; Option)
        {
            OptionCaption = 'Salary,Standing Order(Internal),Checkoff,Standing Order(External)';
            OptionMembers = Salary,"Standing Order(Internal)",Checkoff,"Standing Order(External)";

            trigger OnValidate()
            begin
                if "Payment Method" = "Payment Method"::"Standing Order(Internal)" then begin
                    if LoanApp.Get("Loan No.") then begin
                        StandingOrderLines.Reset;
                        StandingOrderLines.SetRange("Loan No.", "Loan No.");
                        if StandingOrderLines.Find('-') then begin
                            StandingOrderH.Reset;
                            StandingOrderH.SetRange("No.", StandingOrderLines."Document No.");
                            if StandingOrderH.Find('-') then begin
                                if StandingOrderH.Status <> StandingOrderH.Status::Approved then
                                    Error(Text002);
                            end;


                        end else
                            Error(Text003);
                    end;

                end;
            end;
        }
        field(4; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                Loans.Get("Loan No.");
                CurrValue := 0;
                RepMethod.Reset;
                RepMethod.SetRange("Loan No.", "Loan No.");
                if RepMethod.Find('-') then begin
                    RepMethod.CalcSums(Amount);
                    CurrValue := RepMethod.Amount;

                    CurrValue := CurrValue - xRec.Amount;


                    if CurrValue + Amount > Loans.Repayment then
                        Error(ErrMessge);

                end;
            end;
        }
        field(5; "Other STO Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Member No.", "Payment Method")
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
        Loans: Record Loans;
        ErrMessge: Label 'Amount specified is grater then the loan repayment';
        LoanApp: Record Loans;
        Text001: Label 'The loan is already %1 and cannot modify';
        StandingOrderLines: Record "Standing Order Lines";
        StandingOrderH: Record "Standing Order Header";
        Text002: Label 'The standing order attached to the loan is not approved';
        Text003: Label 'There is no standing order placed for this loan';
        RepMethod: Record "Payment Methods";
        CurrValue: Decimal;
}

