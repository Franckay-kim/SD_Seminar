/// <summary>
/// Table Loan Calculator (ID 51532361).
/// </summary>
table 51532361 "Loan Calculator"
{


    fields
    {
        field(1; "Loan No."; Code[30])
        {
        }
        field(2; "Application Date"; Date)
        {
            Editable = false;
        }
        field(3; "Loan Product Type"; Code[30])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Loan),
                                                                  Status = CONST(Active));

            trigger OnValidate()
            begin
                if ProdFac.Get("Loan Product Type") then begin

                    TestField("Member No.");
                    //Get age of the client
                    "Deposits Multiplied" := ProdFac."Ordinary Deposits Multiplier" * "Deposit Contribution";
                    if Mem.Get("Member No.") then begin
                        //if from another sacco
                        if Mem.Type <> Mem.Type::"From Other Sacco" then begin
                            if Mem."Group Account" = false then begin
                                //ClientAge:=HRDates.DetermineAge(Mem."Date of Birth",TODAY);
                                ClientAgePart := CopyStr(ClientAge, 1, 2);
                                ClientAgePart := CopyStr(ClientAge, 1, 2);
                                Evaluate(ClientAgeValue, ClientAgePart);
                                ProdMinAgeText := DelChr(Format(ProdFac."Min. Customer Age"), '=', 'Y|M');
                                Evaluate(ProdMinAge, ProdMinAgeText);
                            end;
                            if ProdMinAge > ClientAgeValue then
                                Message(Text005, ProdFac."Min. Customer Age");
                        end else
                            Message(Text010);
                    end;

                    //confirm if loan exist of same type
                    LoanApp.Reset;
                    LoanApp.SetRange("Member No.", "Member No.");
                    LoanApp.SetRange(Posted, true);
                    LoanApp.SetRange("Loan Product Type", "Loan Product Type");
                    LoanApp.SetFilter("Outstanding Balance", '>0');
                    if LoanApp.Find('-') then begin
                        repeat
                            if ProdFac.Get("Loan Product Type") then begin
                                if ProdFac."Allow Multiple Running Loans" = false then
                                    Message('Member already has an existing Loan %1 of same product which needs bridging', LoanApp."Loan No.")
                                else
                                    Message('Member already has an existing Loan %1 of same product', LoanApp."Loan No.");
                            end;
                        until LoanApp.Next = 0;
                    end;
                    "Loan Product Type Name" := ProdFac."Product Description";
                    "Grace Period" := ProdFac."Grace Period - Interest";
                    Interest := ProdFac."Interest Rate (Min.)";
                    "Grace Period" := ProdFac."Grace Period - Interest";
                    //"Interest Calculation Method":=ProdFac."Interest Calculation Method";
                    //"Loan Span":=ProdFac."Loan Span";
                    Installments := ProdFac."Ordinary Default Intallments";
                    "Repayment Frequency" := ProdFac."Repayment Frequency";
                    //"Recovery Mode":=ProdFac."Repay Mode";
                    //"Appraisal Parameter Type":=ProdFac."Appraisal Parameter Type";
                    //Avoid multiple loan applications pending
                    LoanApp.Reset;
                    LoanApp.SetRange(LoanApp."Member No.", "Member No.");
                    LoanApp.SetRange(LoanApp.Posted, false);
                    if LoanApp.Find('-') then begin
                        repeat
                            if LoanApp.Status <> LoanApp.Status::Rejected then begin
                                if ProdFac.Get("Loan Product Type") then begin
                                    if ProdFac."Type of Discounting" <> ProdFac."Type of Discounting"::"Loan Discounting" then begin
                                        if LoanApp."Loan No." <> "Loan No." then
                                            Message('Member already has an existing %1 application: %2 - %3', LoanApp."Loan Product Type Name", LoanApp."Loan No.");
                                    end;
                                end;
                            end;
                        until LoanApp.Next = 0;
                    end;

                    //Revalidate installments
                    if "Approved Amount" > 0 then
                        Validate(Installments);
                end;
                CalcFields("Total Loan Balance");
                "Maximum Credit" := "Deposits Multiplied" - "Total Loan Balance";
            end;
        }
        field(4; "Member No."; Code[30])
        {
            TableRelation = Members."No.";

            trigger OnValidate()
            begin

                if ProdFac.Get("Loan Product Type") then
                    GenSetup.Get;
                //Check loan recovered from guarantor
                LoanRec.Reset;
                LoanRec.SetRange("Member No.", "Member No.");
                //LoanRec.SETRANGE("Application Date",TRUE);
                if LoanRec.Find('-') then begin
                    Message(Text012, LoanRec."No.");
                end;

                //Check if there is a loan never paid or is in arrears
                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Member No.", "Member No.");
                LoanApp.SetRange(LoanApp.Posted, true);
                LoanApp.SetFilter(LoanApp."Outstanding Balance", '>0');
                if LoanApp.Find('-') then begin
                    repeat

                        //Check status - sasra
                        LoanApp.CalcFields("Current Loans Category-SASRA");
                        if LoanApp."Current Loans Category-SASRA" > GenSetup."Allowed Loan Categories" then
                            Message(Text012, LoanApp."Loan No.");

                        CreditLedger.Reset;
                        CreditLedger.SetRange(CreditLedger."Member No.", "Member No.");
                        CreditLedger.SetRange(CreditLedger."Transaction Type", CreditLedger."Transaction Type"::Repayment);
                        CreditLedger.SetRange(CreditLedger."Loan No", LoanApp."Loan No.");
                        if not CreditLedger.Find('-') then
                            Message(Text003, LoanApp."Loan No.");

                        LoanApp.CalcFields(LoanApp."Outstanding Bills");
                        if LoanApp."Outstanding Bills" > 0 then
                            Message(Text004, LoanApp."Loan No.");
                    until LoanApp.Next = 0;
                end;

                if Mem.Get("Member No.") then begin

                    if Mem.Status <> Mem.Status::Active then
                        if Confirm('This member is not active. Do you wish to continue with application ?', true) = false then
                            Error("InactiveErr:");
                    "Staff No" := Mem."Payroll/Staff No.";
                    "Member Name" := Mem.Name;
                    "Application Date" := Today;
                    //"Employer Code":=Mem."Employer Code";
                end else
                    Error('Member does not exist');

                SavAcc.Reset;
                SavAcc.SetRange(SavAcc."Member No.", "Member No.");
                SavAcc.SetRange(SavAcc."Product Category", SavAcc."Product Category"::"Deposit Contribution");
                if SavAcc.Find('-') then begin
                    SavAcc.CalcFields(SavAcc."Balance (LCY)");
                    "Deposit Contribution" := SavAcc."Balance (LCY)";
                    //Check Minimum savings per product
                    if SavAcc."Balance (LCY)" < ProdFac."Minimum Deposit Balance" then
                        Message(Text011, SavAcc."Balance (LCY)", ProdFac."Minimum Deposit Balance");
                end;
                Validate("Loan Product Type");
            end;
        }
        field(5; "Requested Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                "Approved Amount" := "Requested Amount";
                Validate("Approved Amount");
                "Application Date" := Today;
                //Check maximum and minimum loan amounts
                if ProdFac.Get("Loan Product Type") then begin
                    if (ProdFac."Nature of Loan Type" = ProdFac."Nature of Loan Type"::Normal) or (ProdFac."Nature of Loan Type" = ProdFac."Nature of Loan Type"::" ") then begin
                        if ("Requested Amount" > ProdFac."Maximum Loan Amount") or ("Requested Amount" < ProdFac."Minimum Loan Amount") then
                            Message(LoanAmountErr);
                    end;
                end;
            end;
        }
        field(6; "Approved Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                if ProdFac.Get("Loan Product Type") then begin
                    if (ProdFac."Nature of Loan Type" = ProdFac."Nature of Loan Type"::Normal) or (ProdFac."Nature of Loan Type" = ProdFac."Nature of Loan Type"::" ") then begin
                        if ("Requested Amount" > ProdFac."Maximum Loan Amount") or ("Requested Amount" < ProdFac."Minimum Loan Amount") then
                            Error(LoanAmountErr);
                    end;
                end;

                if Installments <= 0 then
                    Error(InstallmentsErr);

                if "Approved Amount" > "Requested Amount" then
                    Error(ApprovedAmtErr);
                //
                TotalMRepay := 0;
                LPrincipal := 0;
                LInterest := 0;
                InterestRate := Interest;
                LoanAmount := "Approved Amount";
                RepayPeriod := Installments;
                LBalance := "Approved Amount";

                if InterestRate <> 0 then begin
                    if "Interest Calculation Method" = "Interest Calculation Method"::Amortised then begin
                        //TESTFIELD(Interest);
                        //TESTFIELD(Installments);

                        TotalMRepay := Round((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -RepayPeriod)) * LoanAmount, 1, '>');
                        LInterest := Round(LBalance / 100 / 12 * InterestRate, 0.05, '>');

                        Repayment := TotalMRepay;
                        LPrincipal := TotalMRepay - LInterest;
                        "Loan Principle Repayment" := LPrincipal;
                        "Loan Interest Repayment" := LInterest;
                        "Loan Principle Repayment" := TotalMRepay;
                        //"Qualifying Repayment" :=TotalMRepay;

                    end;


                    if "Interest Calculation Method" = "Interest Calculation Method"::"Straight Line" then begin
                        TestField(Interest);
                        TestField(Installments);
                        LPrincipal := Round(LoanAmount / RepayPeriod, 1, '>');
                        LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '>');
                        Repayment := LPrincipal + LInterest;
                        "Loan Principle Repayment" := LPrincipal;
                        "Loan Interest Repayment" := LInterest;
                    end;

                    if "Interest Calculation Method" = "Interest Calculation Method"::"Reducing Balance" then begin
                        TestField(Interest);
                        TestField(Installments);
                        LPrincipal := LoanAmount / RepayPeriod;
                        LInterest := (InterestRate / 12 / 100) * LBalance;
                        Repayment := LPrincipal;
                        "Loan Principle Repayment" := LPrincipal;
                        "Loan Interest Repayment" := LInterest;

                    end;

                    if "Interest Calculation Method" = "Interest Calculation Method"::"Reducing Flat" then begin
                        TestField(Interest);
                        TestField(Installments);
                        //TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,1,'>');
                        LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '>');
                        //AmortisedInt:=TotalMRepay*Installments-"Approved Amount";
                        LInterest := Round(((LoanAmount * Interest / 12 / 100) + (LPrincipal * Interest / 12 / 100)) / 2, 1.0, '>');
                        //LInterest:=AmortisedInt/Installments;
                        Repayment := LPrincipal + LInterest;
                        "Loan Principle Repayment" := LPrincipal;
                        "Loan Interest Repayment" := LInterest;

                    end;
                end else begin
                    LPrincipal := LoanAmount / RepayPeriod;
                    Repayment := LPrincipal;
                end;
            end;
        }
        field(7; Interest; Decimal)
        {

            trigger OnValidate()
            begin
                TestField("Loan Product Type");
                if ProdFac.Get("Loan Product Type") then begin
                    if (Interest < ProdFac."Interest Rate (Min.)") or (Interest > ProdFac."Interest Rate (Max.)") then
                        Error(InterestErrorTxt);
                end;

                if "Approved Amount" > 0 then
                    Validate("Approved Amount");


                //compute expected end date based on application date
                if ProdFac.Get("Loan Product Type") then begin
                    if Format(ProdFac."Grace Period - Principle") <> '' then begin
                        "Repayment Start Date" := CalcDate(ProdFac."Grace Period - Principle", "Application Date");
                        "Repayment Start Date" := CalcDate('CM', "Repayment Start Date");
                        IntstallMentPeriodText := Format(Installments) + 'M';
                        Evaluate(InstalmentPeriods, IntstallMentPeriodText);
                        //  "Expected Date of Completion":=CALCDATE(InstalmentPeriods,"Repayment Start Date");
                    end else begin
                        "Repayment Start Date" := CalcDate('CM', "Application Date");
                        IntstallMentPeriodText := Format(Installments) + 'M';
                        Evaluate(InstalmentPeriods, IntstallMentPeriodText);
                        "Expected Date of Completion" := CalcDate(InstalmentPeriods, "Repayment Start Date");
                    end;
                end;
            end;
        }
        field(8; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(10; Installments; Integer)
        {

            trigger OnValidate()
            begin
                //Control
                if ProdFac.Get("Loan Product Type") then begin
                    if Installments > ProdFac."Ordinary Default Intallments" then
                        Error(Text006);
                end;

                if "Approved Amount" > 0 then
                    Validate("Approved Amount");
            end;
        }
        field(12; "Mode of Disbursement"; Option)
        {
            OptionCaption = 'Full Disbursement,Partial Disbursement';
            OptionMembers = "Full Disbursement","Partial Disbursement";
        }
        field(13; "Grace Period"; DateFormula)
        {
        }
        field(14; "Installment Period"; DateFormula)
        {
        }
        field(15; Repayment; Decimal)
        {
        }
        field(16; "Loan Product Type Name"; Text[50])
        {
            Editable = false;
        }
        field(28; "Interest Calculation Method"; Option)
        {
            OptionCaption = 'Amortised,Reducing Balance,Straight Line,Reducing Flat,Zero Interest';
            OptionMembers = Amortised,"Reducing Balance","Straight Line","Reducing Flat","Zero Interest";
        }
        field(34; "Repayment Start Date"; Date)
        {
        }
        field(36; "Staff No"; Code[30])
        {
        }
        field(48; "Expected Date of Completion"; Date)
        {
        }
        field(50; "Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Monthly,Quarterly,Bi-Annual,Yearly';
            OptionMembers = Daily,Weekly,Monthly,Quarterly,"Bi-Annual",Yearly;
        }
        field(53; "Recommended Amount"; Decimal)
        {
        }
        field(56; "Loan Span"; Option)
        {
            OptionCaption = ' ,Short Term,Long Term';
            OptionMembers = " ","Short Term","Long Term";
        }
        field(62; "Loan Principle Repayment"; Decimal)
        {
        }
        field(63; "Loan Interest Repayment"; Decimal)
        {
        }
        field(64; "Employer Code"; Code[30])
        {
            //TableRelation = Customer WHERE("Account Type" = CONST(Employer));
        }
        field(65; "Disbursement Date"; Date)
        {
        }
        field(66; "Total Loan Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Member No." = FIELD("Member No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "Deposit Contribution"; Decimal)
        {
            Editable = false;
        }
        field(68; "Deposits Multiplied"; Decimal)
        {
            Editable = false;
        }
        field(69; "Basic Salary"; Decimal)
        {
        }
        field(70; "Total Earnings"; Decimal)
        {
        }
        field(71; "Total Deductions"; Decimal)
        {
        }
        field(72; "Maximum Credit"; Decimal)
        {
            Editable = false;
        }
        field(73; "User ID"; Code[30])
        {
            TableRelation = "Loan Calculator";
        }
        field(74; "User Name"; Text[30])
        {
        }
        field(75; "Appraised by"; Text[50])
        {
        }
        field(76; "Captured by"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Disbursement Date" := Today;
    end;

    var
        //RejectionReason: Record "Rejection Reason";
        MembNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ProdFac: Record "Product Factory";
        SavAcc: Record "Savings Accounts";
        LoanApp: Record Loans;
        Mem: Record Members;
        Credit: Record "Credit Accounts";
        TotalMRepay: Decimal;
        LPrincipal: Decimal;
        LInterest: Decimal;
        InterestRate: Decimal;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        //DCSUpdate: Codeunit "DCS Management";
        //CheckoffAdvice: Codeunit "Periodic Activities";
        "DiscErr:": Label 'Loan is already discounted by %1';
        ShareBoostComm: Decimal;
        "Shares Boosted": Boolean;
        DimMgt: Codeunit DimensionManagement;
        "InactiveErr:": Label 'This member account is not active';
        LoanAmountErr: Label 'The loan applied is not within allowed margins';
        InstallmentsErr: Label 'Number of installments must be greater than Zero.';
        DateErr: Label 'The date is invalid. It should not be in the past';
        DisbErr: Label 'The amount to disburse cannot be greater than or equal to approved amount';
        ApprovedAmtErr: Label 'The approved amount cannot be greater than requested amount';
        AmountToDisb: Label 'Amount to disburse cannot be greater than approved amount';
        Text002: Label 'Amount to disburse must be equal to amount approved';
        CreditLedger: Record "Credit Ledger Entry";
        Text003: Label 'This member has a loan which has not be repaid %1';
        Text004: Label 'This member has a loan in arrears %1';
        ClientAge: Text;
        Text005: Label 'This Member age is less than the limit of %1';
        ClientAgeValue: Integer;
        ClientAgePart: Text;
        ProdMinAgeText: Text;
        ProdMinAge: Integer;
        UserSetup: Record "User Setup";
        SavLedger: Record "Savings Ledger Entry";
        GenSetup: Record "General Set-Up";
        NoOfDays: Integer;
        NoOfMonths: Decimal;
        Text006: Label 'You cannot exceed the maximum installments';
        InstalmentPeriods: DateFormula;
        IntstallMentPeriodText: Text;
        //ProdReq: Record "Product Checklist";
        //LoanReq: Record "Loan Mandatory Requirements";
        i: Integer;
        PeriodStartDate: array[6] of Date;
        StartDate: Date;
        BusinessIncome: Record "Business Income";
        BusDateFilter: Text;
        LowerDateLimit: Date;
        UpperDateLimit: Date;
        LastMonthDate: Date;
        ApplDocs: Record "Product Documents";
        LoanReqDocs: Record "Loan Required Documents";
        SavingsAccounts: Record "Savings Accounts";
        Text007: Label 'You cannot apply this product without an active Fixed Deposit';
        Err008: Label 'You cannot apply more than Amount Fixed';
        //LoanHistory: Record "Loan History";
        LoanGuara: Record "Loan Guarantors and Security";
        ErrGua: Label 'You cannot self guarantee where you have guaranteed running loans';
        TotalDisc: Decimal;
        Text008: Label 'You cannot discount above %1 Percent of the approved amount';
        SalProc: Record "Salary Lines";
        EndDateSalo: Date;
        Text009: Label 'Salary Must be through the SACCO to get this loan';
        Text010: Label 'This member is from another sacco excempted from minimum membership limit';
        Text011: Label 'This member has lower deposits of %1 than expected of deposits of %2 ';
        InterestErrorTxt: Label 'Interest Rate is not within allowed range.';
        //LoansProcess: Codeunit "Loans Process";
        NetAmt: Decimal;
        Text012: Label 'The applicant is a defaulter - Loan No. %1';
        LoanRec: Record "Loan Recovery Header";
        Text013: Label 'The member has a loan recocered from guarantors refference %1';
        CheckOffLines: Record "Checkoff Buffer";
        Text014: Label 'The member must be remmitting checkoff to the organization to qualify';
        Loan: Record Loans;
        BalGuara: Decimal;
        SelfGuaBal: Decimal;
        Text015: Label 'The requested amount is more than availabe deposit balance for self guarantee';
        MaxSelfGuar: Decimal;
        Text016: Label 'Maximum discounting percentage allowable must be defined';
        Text017: Label 'The loan must be approved before assigning a batch';
        //SendSMS: Codeunit SendSms;
        SourceType: Option "New Member","New Account","Loan Account Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit"," Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes";
        LoansApp: Record Loans;
        CRMLoanApplication: Record "CRM Application";
        Err002: Label 'CRM application is already in use by Loan No. %1';
        AmortisedInt: Decimal;
    //LoanProcess: Codeunit "Loans Process";

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Loans, "Loan No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    local procedure AvailableCreditLimit()
    begin
    end;

    local procedure PassDocumentNo()
    var
        DocExemptionsApprvls: Record "Document Exemptions Auth.";
    begin
        /*
        DocExemptionsApprvls.RESET;
        DocExemptionsApprvls.SETRANGE("Document No.","Loan No.");
        IF DocExemptionsApprvls.FIND('-') THEN
          DocExemptionsApprvls.VALIDATE("Document No.");
          */

    end;
}

