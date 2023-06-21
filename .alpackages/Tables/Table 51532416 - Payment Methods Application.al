table 51532416 "Payment Methods Application"
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
                if Loans.Get("Loan No.") then begin

                    PaymentMethodsApplication.Reset;
                    PaymentMethodsApplication.SetRange("Loan No.", "Loan No.");
                    if PaymentMethodsApplication.Find('-') then begin
                        if LoanRescheduling.Get("Reschedule No") then begin
                            if LoanRescheduling."New Amount" = 0 then begin


                                PaymentMethodsApplication.CalcSums(Amount);
                                if PaymentMethodsApplication.Amount + Amount > LoanRescheduling."New Amount" then
                                    Error(ErrMessge);

                            end;
                        end else begin
                            RepMethod.Reset;
                            RepMethod.SetRange("Loan No.", "Loan No.");
                            if RepMethod.Find('-') then begin
                                RepMethod.CalcSums(Amount);
                                if RepMethod.Amount + Amount > Loans.Repayment then
                                    Error(ErrMessge);
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(5; "Reschedule No"; Code[20])
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
        /*IF LoanApp.GET("Loan No.") THEN BEGIN
          IF (LoanApp.Status=LoanApp.Status::Pending) OR (LoanApp.Status=LoanApp.Status::Approved) THEN
            ERROR(Text001,LoanApp.Status);
        END;
        */

    end;

    trigger OnInsert()
    begin
        /*IF LoanApp.GET("Loan No.") THEN BEGIN
          IF (LoanApp.Status=LoanApp.Status::Pending) OR (LoanApp.Status=LoanApp.Status::Approved) THEN
            ERROR(Text001,LoanApp.Status);
        END;
        */

    end;

    trigger OnModify()
    begin
        /*IF LoanApp.GET("Loan No.") THEN BEGIN
          IF (LoanApp.Status=LoanApp.Status::Pending) OR (LoanApp.Status=LoanApp.Status::Approved) THEN
            ERROR(Text001,LoanApp.Status);
        END;
        */

    end;

    trigger OnRename()
    begin
        /*IF LoanApp.GET("Loan No.") THEN BEGIN
          IF (LoanApp.Status=LoanApp.Status::Pending) OR (LoanApp.Status=LoanApp.Status::Approved) THEN
            ERROR(Text001,LoanApp.Status);
        END;
        */

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
        PaymentMethodsApplication: Record "Payment Methods Application";
        LoanRescheduling: Record "Loan Rescheduling";
}

