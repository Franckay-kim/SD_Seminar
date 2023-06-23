/// <summary>
/// Table Bulk Loan Rescheduling (ID 51532426).
/// </summary>
table 51532426 "Bulk Loan Rescheduling"
{
    // DrillDownPageID = 39004382;
    // LookupPageID = 39004382;

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Members."No.";

            trigger OnValidate()
            begin
                if Mem.Get("Member No.") then begin
                    "Member Name" := Mem.Name;//Mem."First Name"+' '+Mem."Second Name"+' '+Mem."Last Name";
                    "Payroll No" := Mem."Payroll/Staff No.";
                end;
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Loan No."; Code[20])
        {
            TableRelation = Loans."Loan No." WHERE("Member No." = FIELD("Member No."),
                                                    "Outstanding Balance" = FILTER(> 0));

            trigger OnValidate()
            begin
                RemInstallments := 0;
                if Loan.Get("Loan No.") then begin

                    Loan.CalcFields(Loan."Outstanding Balance", Loan."Outstanding Interest");
                    "Outstanding Balance" := Loan."Outstanding Balance";
                    "Outstanding Interest" := Loan."Outstanding Interest";

                    "Old Amount" := Loan.Repayment;
                    "Account No." := Loan."Loan Account";
                    "Recovery Mode" := Loan."Recovery Mode";
                    "Original Installments" := Loan.Installments;
                    "Interest Rate" := Loan.Interest;
                    "Rescheduling Date" := Today;
                    "Recovery Mode" := Loan."Recovery Mode";
                    "Old Principal Repayment" := Loan."Loan Principle Repayment";



                    if ProdF.Get(Loan."Loan Product Type") then
                        //"Maximun Installments":=Loan.Installments;
                        "Maximun Installments" := ProdF."Ordinary Default Intallments";


                    PaymentMethodsApplication.Reset;
                    PaymentMethodsApplication.SetRange("Loan No.", Loan."Loan No.");
                    if PaymentMethodsApplication.Find('-') then
                        PaymentMethodsApplication.DeleteAll;

                    PaymentMethods.Reset;
                    PaymentMethods.SetRange("Loan No.", Loan."Loan No.");
                    if PaymentMethods.Find('-') then begin
                        repeat
                            PaymentMethodsApplication.Init;
                            PaymentMethodsApplication."Loan No." := PaymentMethods."Loan No.";
                            PaymentMethodsApplication."Payment Method" := PaymentMethods."Payment Method";
                            PaymentMethodsApplication."Member No." := "Member No.";
                            PaymentMethodsApplication.Amount := PaymentMethods.Amount;
                            PaymentMethodsApplication."Reschedule No" := "No.";
                            PaymentMethodsApplication.Insert;
                        until PaymentMethods.Next = 0;
                    end else begin
                        /*PaymentMethodsApplication.INIT;
                        PaymentMethodsApplication."Loan No.":=PaymentMethods."Loan No.";
                        PaymentMethodsApplication."Payment Method":=PaymentMethods."Payment Method";
                        PaymentMethodsApplication."Member No.":="Member No.";
                        PaymentMethodsApplication.Amount:=PaymentMethods.Amount;
                        PaymentMethodsApplication."Reschedule No":="No.";
                        PaymentMethodsApplication.INSERT;*/
                    end;

                    // Check schedule details
                    LoanSched.Reset;
                    LoanSched.SetRange(LoanSched."Loan No.", "Loan No.");
                    LoanSched.SetRange(LoanSched."Repayment Date", Today, 99991230D);
                    if LoanSched.Find('-') then begin
                        RemInstallments := LoanSched.Count;
                        "Remaining Installments" := RemInstallments;
                    end;
                end else begin
                end;

            end;
        }
        field(5; "Outstanding Balance"; Decimal)
        {
            Editable = false;
        }
        field(6; "Outstanding Interest"; Decimal)
        {
            Editable = false;
        }
        field(7; Rescheduled; Boolean)
        {
        }
        field(8; "Remaining Installments"; Integer)
        {
            Editable = false;
        }
        field(9; "New Installments"; Integer)
        {
            Enabled = true;

            trigger OnValidate()
            begin

                PastInstallments := 0;
                if "Original Installments" = "Maximun Installments" then begin
                    if "New Installments" > "Remaining Installments" then
                        Error(Txt0001);
                end else begin
                    PastInstallments := "Original Installments" - "Remaining Installments";
                    if "New Installments" + PastInstallments > "Maximun Installments" then
                        Error(Txt0002);
                end;

                GetRepayment;
            end;
        }
        field(10; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(11; "Old Amount"; Decimal)
        {
            Editable = false;
        }
        field(12; "New Amount"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin

                TestField("Rescheduling Date");
                GetInstallments;
            end;
        }
        field(13; "Account No."; Code[20])
        {
            Editable = false;
        }
        field(14; "Original Installments"; Integer)
        {
            Editable = false;
        }
        field(15; "Maximun Installments"; Integer)
        {
            Editable = false;
        }
        field(16; "Rescheduling Date"; Date)
        {
        }
        field(17; "No. Series"; Code[10])
        {
        }
        field(45; "Responsibility Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility CenterBR";
        }
        field(46; "Requested Repaymet"; Decimal)
        {
        }
        field(49; "Recovery Mode"; Option)
        {
            OptionCaption = ' ,Salary,Milk,Tea,Staff Salary,Business,Check Off';
            OptionMembers = " ",Salary,Milk,Tea,"Staff Salary",Business,"Check Off";
        }
        field(50; "Interest Rate"; Decimal)
        {
        }
        field(51; Remarks; Text[100])
        {
        }
        field(52; "New Interest Rate"; Decimal)
        {
        }
        field(53; "Rescheduling Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Top-up","Non-Top-up";
        }
        field(54; "Top Up Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55; "New Loan Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Requested Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                TestField("Rescheduling Date");
                GetInstallments;
            end;
        }
        field(57; "Payroll No"; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //IF Mem.GET("Payroll No") THEN BEGIN
                Mem.Reset;
                Mem.SetRange("Payroll/Staff No.", "Payroll No");
                if Mem.Find('-') then begin
                    "Member Name" := Mem.Name;
                    "Member No." := Mem."No.";
                end;
            end;
        }
        field(58; "Old Principal Repayment"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(59; "New Principal Repayment"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Loan No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Mem: Record Members;
        RemInstallments: Integer;
        Loan: Record Loans;
        ProdF: Record "Product Factory";
        LoanSched: Record "Loan Repayment Schedule";
        PastInstallments: Integer;
        Txt0001: Label 'It cannot exceed the maximum installments defined for this product';
        Txt0002: Label 'It cannot exceed the maximum installments defined for this product';
        Loans: Record Loans;
        InstallmentsNew: Decimal;
        LoansR: Record Loans;
        LoanAmount: Decimal;
        InterestRate: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Decimal;
        RepayInterval: DateFormula;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[40];
        GrPrinciple: Integer;
        GrInterest: Integer;
        QPrinciple: Decimal;
        QCounter: Integer;
        InPeriod: DateFormula;
        InitialInstal: Integer;
        InitialGraceInt: Integer;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanApp: Record Loans;
        PartialSched: Record "Partial Disbursement Schedule";
        Text0003: Label 'You can not reschedule more than the initial insatllment';
        UserSet: Record "User Setup";
        PaymentMethodsApplication: Record "Payment Methods Application";
        PaymentMethods: Record "Payment Methods";
        CreditAccounts: Record "Credit Accounts";
    //LoansProcess: Codeunit "Loans Process";

    local procedure GetInstallments()
    begin
        Loans.Reset;
        Loans.SetRange("Loan No.", "Loan No.");
        if Loans.Find('-') then begin
            Message('"Requested Amount" %1\Loans."Interest Calculation Method" %2', "Requested Amount", Loans."Interest Calculation Method");
            /*
            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Repayment Date",TODAY,12309999D);
            LoanRepaymentSchedule.SETRANGE("Loan No.",Loans."Loan No.");
            LoanRepaymentSchedule.SETRANGE("Reset Schedule",TRUE);
            IF LoanRepaymentSchedule.FIND('-') THEN
              LoanRepaymentSchedule.DELETEALL;
            */



            Loans.CalcFields("Outstanding Balance", "Outstanding Interest");
            LoanAmount := Loans."Outstanding Balance";
            InterestRate := Loans.Interest;
            LBalance := Loans."Outstanding Balance";//LoansR."Approved Amount";
            RunDate := "Rescheduling Date";
            InstalNo := 0;

            repeat

                if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::Amortised then begin
                    if Loans.Interest = 0 then
                        Loans."Interest Calculation Method" := Loans."Interest Calculation Method"::"Reducing Balance"

                end;
                //kma
                if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::Amortised then begin
                    Loans.TestField(Loans.Interest);
                    TotalMRepay := "Requested Amount";
                    LInterest := Round(LBalance / 100 / 12 * InterestRate, 0.0001, '>');
                    LPrincipal := TotalMRepay - LInterest;
                end;

                if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::"Straight Line" then begin
                    LPrincipal := "Requested Amount";
                    TotalMRepay := LPrincipal + LInterest;
                end;

                if (Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::"Reducing Balance") or (Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::"Reducing Flat") then begin
                    LPrincipal := "Requested Amount";
                    TotalMRepay := LPrincipal + LInterest;
                end;


                if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::Custom then begin
                    LPrincipal := "Requested Amount";
                    TotalMRepay := LPrincipal + LInterest;
                end;

                if LBalance >= LPrincipal then
                    InstalNo += 1;

                LBalance -= LPrincipal;

                //MESSAGE('InstalNo %1\LBalance %2\LPrincipal %3',InstalNo,LBalance,LPrincipal);

                //Repayment Frequency
                if Loans."Repayment Frequency" = Loans."Repayment Frequency"::Daily then
                    RunDate := CalcDate('1D', RunDate)
                else
                    if Loans."Repayment Frequency" = Loans."Repayment Frequency"::Weekly then
                        RunDate := CalcDate('1W', RunDate)
                    else
                        if Loans."Repayment Frequency" = Loans."Repayment Frequency"::Monthly then
                            RunDate := CalcDate('1M', RunDate)
                        else
                            if Loans."Repayment Frequency" = Loans."Repayment Frequency"::Quarterly then
                                RunDate := CalcDate('1Q', RunDate)
                            else
                                if Loans."Repayment Frequency" = Loans."Repayment Frequency"::"Bi-Annual" then
                                    RunDate := CalcDate('6M', RunDate)
                                else
                                    if Loans."Repayment Frequency" = Loans."Repayment Frequency"::Yearly then
                                        RunDate := CalcDate('1Y', RunDate)
                                    else
                                        if Loans."Repayment Frequency" = Loans."Repayment Frequency"::Bonus then begin
                                            RunDate := CalcDate('1Y', RunDate);
                                        end;


            until LBalance < 1;


            if InstalNo < 0 then
                InstalNo := 1;

            if CreditAccounts.Get(Loans."Loan Account") then begin
                if ProdF.Get(CreditAccounts."Product Type") then begin
                    if ProdF."Nature of Loan Type" <> ProdF."Nature of Loan Type"::Defaulter then
                        if "Original Installments" < InstalNo then
                            Error(Text0003);
                end;
            end;

            "New Installments" := InstalNo;

            //Loans."New No. of Installment":=InstalNo;

            if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::Amortised then begin
                "New Amount" := "Requested Repaymet";
                "New Principal Repayment" := LPrincipal;
            end
            else
                "New Amount" := Round("Outstanding Balance" / "New Installments");
            "New Principal Repayment" := LPrincipal;
            //MESSAGE('%1',InstalNo);

            Modify;
        end;

    end;

    local procedure GetRepayment()
    begin

        Loans.Get("Loan No.");


        LoanAmount := "Outstanding Balance";
        InterestRate := Loans.Interest;
        RepayPeriod := "New Installments";
        InitialInstal := "New Installments";
        LBalance := "Outstanding Balance";
        RunDate := "Rescheduling Date";


        InstalNo := InstalNo + 1;
        if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::Amortised then begin
            if Loans.Interest = 0 then
                Loans."Interest Calculation Method" := Loans."Interest Calculation Method"::"Reducing Balance"

        end;
        //kma
        if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::Amortised then begin

            TotalMRepay := Round((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 0.0001, '>');
            LInterest := Round(LBalance / 100 / 12 * InterestRate, 0.0001, '>');
            LPrincipal := TotalMRepay - LInterest;
        end;

        if Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::"Straight Line" then begin
            LPrincipal := LoanAmount / RepayPeriod;
            LInterest := (InterestRate / 12 / 100) * LoanAmount;
            TotalMRepay := LPrincipal + LInterest
        end;

        if (Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::"Reducing Balance") or (Loans."Interest Calculation Method" = Loans."Interest Calculation Method"::"Reducing Flat") then begin
            LPrincipal := LoanAmount / RepayPeriod;
            LInterest := Round((InterestRate / 12 / 100) * LBalance, 1.0, '>');
            TotalMRepay := LPrincipal + LInterest;

        end;

        "New Amount" := TotalMRepay;
        "New Principal Repayment" := LPrincipal;
    end;
}

