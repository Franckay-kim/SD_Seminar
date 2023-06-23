/// <summary>
/// Table Loan Credit Score (ID 51532391).
/// </summary>
table 51532391 "Loan Credit Score"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(2; Classification; Option)
        {
            OptionCaption = ' ,Character,Capital,Capability,Conditional Risk,Collateral';
            OptionMembers = " ",Character,Capital,Capability,"Conditional Risk",Collateral;

            trigger OnValidate()
            begin
                TotalDeposits := 0;
                TotalLoans := 0;
                Totalsal := 0;
                GuarAmt := 0;
                Loans.Get("Loan No.");
                Members.Get(Loans."Member No.");
                if Classification = Classification::Capital then begin
                    Members.Reset;
                    Members.SetRange("No.", Loans."Member No.");
                    if Members.Find('-') then begin
                        // Deposit Summation
                        SavAcc.Reset;
                        SavAcc.SetRange(SavAcc."Member No.", Members."No.");
                        //SavAcc.SETRANGE(SavAcc."Product Category",SavAcc."Product Category"::"Deposit Contribution");
                        if SavAcc.Find('-') then begin
                            repeat
                                if (SavAcc."Product Category" = SavAcc."Product Category"::"Deposit Contribution") or
                                (SavAcc."Product Category" = SavAcc."Product Category"::"Fixed Deposit") then begin
                                    SavAcc.CalcFields(SavAcc."Balance (LCY)");
                                    TotalDeposits += SavAcc."Balance (LCY)";
                                end;
                            until SavAcc.Next = 0;
                        end;
                        //Get Total Loans
                        LoanApp.Reset;
                        LoanApp.SetRange("Member No.", Loans."Member No.");
                        if LoanApp.Find('-') then begin
                            repeat
                                LoanApp.CalcFields("Outstanding Balance");
                                TotalLoans += LoanApp."Outstanding Balance";
                            until LoanApp.Next = 0;
                        end;
                    end;





                    TotalLoans := TotalLoans + Loans."Requested Amount";
                    Rating := (TotalDeposits / TotalLoans) * 100;
                    Description := Format(Classification);
                    "Base Value" := TotalDeposits;
                end else
                    if Classification = Classification::Capability then begin
                        ProdFac.Get(Loans."Loan Product Type");
                        //MESSAGE(ProdFac."Product ID");
                        // MESSAGE(FORMAT(ProdFac."Salary Period"));
                        EndDateSalo := CalcDate('-' + Format(ProdFac."Salary Period"), Today);//+FORMAT(ProdFac."No. of Salary Times")
                        //MESSAGE(Members."No.");
                        SalProc.Reset;
                        SalProc.SetRange(SalProc."Member No.", Members."No.");
                        SalProc.SetRange(SalProc.Posted, true);
                        SalProc.SetRange("Posting Date", EndDateSalo, Today);
                        SalProc.SetRange(Posted, true);
                        if SalProc.Find('-') then begin
                            SalProc.CalcSums(Amount);
                            Totalsal := SalProc.Amount;
                            // MESSAGE(FORMAT(Totalsal));
                            if SalProc.Count < ProdFac."No. of Salary Times" then
                                Message(Text009);

                        end else
                            Message(Text009);
                        ProdFac.Get(Loans."Loan Product Type");
                        "Base Value" := (Totalsal / ProdFac."No. of Salary Times");
                        Description := Format(Classification);
                        Rating := (("Base Value") / (Loans.Repayment)) * 100;
                    end else
                        if Classification = Classification::Collateral then begin

                            //Guarantors
                            LoanGuarantorsandSecurity.Reset;
                            LoanGuarantorsandSecurity.SetRange("Loan No", Loans."Loan No.");
                            if LoanGuarantorsandSecurity.Find('-') then begin
                                LoanGuarantorsandSecurity.CalcSums("Deposits/Shares");
                                GuarAmt := LoanGuarantorsandSecurity."Deposits/Shares";
                            end;
                            SecuritiesRegister.Reset;
                            SecuritiesRegister.SetRange("Account No.", Members."No.");
                            if SecuritiesRegister.Find('-') then begin
                                "Base Value" := SecuritiesRegister."Forced Sale Value";
                            end;
                            "Base Value" := "Base Value" + GuarAmt;
                            Description := Format(Classification);
                            Rating := (("Base Value") / (Loans."Requested Amount")) * 100;
                        end;
                if Rating > 100 then
                    Evaluation := 100 else
                    if
Rating < 0 then
                        Evaluation := 0 else
                        Evaluation := Rating;
                Description := Format(Classification);
            end;
        }
        field(3; Rating; Decimal)
        {

            trigger OnValidate()
            begin
                if Rating > 100 then
                    Evaluation := 100 else
                    if
Rating < 0 then
                        Evaluation := 0 else
                        Evaluation := Rating;
            end;
        }
        field(4; "Line No."; Integer)
        {
        }
        field(5; Description; Text[50])
        {
        }
        field(6; "Base Value"; Decimal)
        {
        }
        field(7; Evaluation; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Line No.", Description)
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
                Error(Text002, LoanApp.Status);
        end;
    end;

    trigger OnInsert()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text002, LoanApp.Status);
        end;
    end;

    trigger OnModify()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text002, LoanApp.Status);
        end;
    end;

    var
        Loans: Record Loans;
        Members: Record Members;
        SavAcc: Record "Savings Accounts";
        TotalLoans: Decimal;
        TotalDeposits: Decimal;
        LoanApp: Record Loans;
        SavAccFD: Record "Savings Accounts";
        TotalDepositsFD: Decimal;
        SalProc: Record "Salary Lines";
        EndDateSalo: Date;
        ProdFac: Record "Product Factory";
        Text009: Label 'Salary Must be through the SACCO to get this loan';
        Totalsal: Decimal;
        SecuritiesRegister: Record "Securities Register";
        LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
        GuarAmt: Decimal;
        Text002: Label 'Loan is already %1 and cannot modify';
}

