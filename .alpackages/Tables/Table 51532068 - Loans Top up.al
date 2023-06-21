table 51532068 "Loans Top up"
{


    fields
    {
        field(1; "Loan No."; Code[30])
        {
            TableRelation = Loans."Loan No.";
        }
        field(2; "Loan Top Up"; Code[30])
        {
            TableRelation = Loans."Loan No." WHERE("Member No." = FIELD("Client Code"),
                                                    Posted = CONST(true),
                                                    "Total Outstanding Balance" = FILTER(> 0));

            trigger OnValidate()
            begin
                GenSetup.Get;
                RepaymentMade := 0;

                if xRec."Loan Top Up" <> "Loan Top Up" then begin
                    LoanG.Reset;
                    LoanG.SetRange("Loan No", xRec."Loan Top Up");
                    LoanG.SetRange("Guarantor Type", LoanG."Guarantor Type"::Lien);
                    if LoanG.FindFirst then begin
                        LoanG.ModifyAll("Loan Top Up", false);

                        LoanG.Reset;
                        LoanG.SetRange("Loan No", "Loan No.");
                        LoanG.SetRange("Guarantor Type", LoanG."Guarantor Type"::Lien);
                        if LoanG.FindFirst then
                            LoanG.DeleteAll;

                    end;
                end;



                if Loans.Get("Loan Top Up") then begin

                    CLedger.Reset;
                    CLedger.SetRange("Loan No", Loans."Loan No.");
                    CLedger.SetRange("Transaction Type", CLedger."Transaction Type"::"Interest Due");
                    CLedger.SetRange(Reversed, false);
                    if not CLedger.FindFirst then begin
                        if not Confirm('Interest has never been charged on this Loan. You cannot proceed without charging this interest. Do you want to charge interest?') then
                            Error('Aborted');

                        // PeriodicActivities.PostInterestDue(Loans, Today, false);
                    end;
                end;

                if Loans.Get("Loan Top Up") then begin


                    LoanG.Reset;
                    LoanG.SetRange("Loan No", "Loan Top Up");
                    LoanG.SetRange("Guarantor Type", LoanG."Guarantor Type"::Lien);
                    if LoanG.FindFirst then begin
                        LoanG.ModifyAll("Loan Top Up", true);
                    end;


                    Loantypes.Get(Loans."Loan Product Type");


                    Loans.CalcFields("Interest Due");

                    "Expected Interest Due" := 0;
                    if Loantypes.Get(Loans."Loan Product Type") then begin
                        if Loantypes."TopUp Expected Interest P. (M)" > 0 then begin
                            M := Loantypes."TopUp Expected Interest P. (M)";
                            ExpIntDue := 0;
                            RepaymentSchedule.Reset;
                            RepaymentSchedule.SetRange("Loan No.", "Loan Top Up");
                            RepaymentSchedule.SetFilter("Monthly Interest", '>0');
                            if RepaymentSchedule.Find('-') then begin
                                repeat
                                    M -= 1;
                                    ExpIntDue += RepaymentSchedule."Monthly Interest";
                                until (RepaymentSchedule.Next = 0) or (M = 0);
                            end;
                            "Expected Interest Due" := ExpIntDue;

                            if "Expected Interest Due" > Loans."Interest Due" then begin
                                RemIntDue := "Expected Interest Due" - Loans."Interest Due";
                                if Confirm(Format(Loantypes."TopUp Expected Interest P. (M)") + 'M Interest has not been fully charged on this loan. ' +
                                  Format(RemIntDue) + ' will now be charged. Continue?') then begin
                                    ChargeInterest(Loans, RemIntDue);
                                end
                                else
                                    Error('Aborted');
                            end;
                        end;
                    end;
                    Loantypes.Get(Loans."Loan Product Type");
                    Loantypes.ValidateTopup(Loans, LoanApp."Application Date");

                    Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bills", "Outstanding Appraisal", "Outstanding Penalty", "Interest Due");

                    if Loans."Outstanding Interest" < 0 then
                        Loans."Outstanding Interest" := 0;
                    if Loans."Outstanding Penalty" < 0 then
                        Loans."Outstanding Penalty" := 0;
                    if Loans."Outstanding Appraisal" < 0 then
                        Loans."Outstanding Appraisal" := 0;

                    "Loan Type" := Loans."Loan Product Type";
                    "Principle Top Up" := Loans."Outstanding Balance";//-(Loans.Repayment-(Loans."Outstanding Balance"*Loans.Interest*0.01/12));
                    "Interest Top Up" := Loans."Outstanding Interest";//-(Loans."Outstanding Balance"*Loans.Interest*0.01/12));
                    "Penalty Top UP" := Loans."Outstanding Penalty";
                    "Appraisal Top Up" := Loans."Outstanding Appraisal";

                    "Monthly Repayment" := Loans.Repayment;//-(Loans."Outstanding Balance"*Loans.Interest*0.01/12);
                    "Interest Rate" := Loans.Interest;


                    "Outstanding Bill" := Loans."Outstanding Bills";
                    "Outstanding Balance" := Loans."Outstanding Balance";

                    "Loan Span" := Loans."Loan Span";



                    /* //Check re-application period
                    IF FORMAT(Loantypes."Min. Re-application Period")<>'' THEN
                        EndDate:=CALCDATE(Loantypes."Min. Re-application Period",Loans."Repayment Start Date");
                
                
                    RepaymentSchedule.RESET;
                    RepaymentSchedule.SETRANGE(RepaymentSchedule."Loan No.","Loan Top Up");
                    RepaymentSchedule.SETRANGE(RepaymentSchedule."Repayment Date",0D,EndDate);
                    IF RepaymentSchedule.FIND('-') THEN BEGIN
                      RepaymentSchedule.CALCSUMS(RepaymentSchedule."Principal Repayment");
                    END;
                
                    //Get the difference if past schedule
                    RepaymentMade:=Loans."Approved Amount"-Loans."Outstanding Balance";
                    IF RepaymentMade<RepaymentSchedule."Principal Repayment" THEN
                        "Additional Top Up Commission":=TRUE; */





                    Commision := 0;
                    Validate("Principle Top Up");
                    if GenSetup."Loan Top Up Commission Type" = GenSetup."Loan Top Up Commission Type"::Single then
                        Commision := GetCommission;

                    "Total Top Up" := "Principle Top Up" + "Interest Top Up" + "Penalty Top UP" + "Appraisal Top Up";//+Commision;
                    "Monthly Repayment" := Loans.Repayment;
                    "Loan Account" := Loans."Loan Account";
                end;

            end;
        }
        field(3; "Client Code"; Code[20])
        {
        }
        field(4; "Loan Type"; Code[20])
        {
        }
        field(5; "Principle Top Up"; Decimal)
        {

            trigger OnValidate()
            var
                TopUp: Record "Loans Top up";
                PCharges: Record "Loan Product Charges";
                TariffDetails: Record "Tiered Charges Lines";
                ChargeExtraComms: Boolean;
                TotalComputedCharges: Decimal;
            begin

                Commision := GetCommission;
                if LoanApp.Get("Loan No.") then begin
                    "Total Top Up" := "Principle Top Up" + "Interest Top Up" + "Penalty Top UP" + "Appraisal Top Up";//+Commision;
                end;
            end;
        }
        field(6; "Interest Top Up"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Top Up" := "Principle Top Up" + "Interest Top Up" + "Penalty Top UP" + "Appraisal Top Up";//+Commision;
            end;
        }
        field(7; "Total Top Up"; Decimal)
        {
        }
        field(8; "Monthly Repayment"; Decimal)
        {
        }
        field(9; "Interest Paid"; Decimal)
        {
        }
        field(10; "Outstanding Balance"; Decimal)
        {
            FieldClass = Normal;
        }
        field(11; "Interest Rate"; Decimal)
        {
        }
        field(12; "ID. NO"; Code[20])
        {
        }
        field(13; Commision; Decimal)
        {
        }
        field(14; "One Month Interest"; Decimal)
        {
        }
        field(15; "Insurance rebate"; Decimal)
        {
        }
        field(16; "Loan Account"; Code[20])
        {
        }
        field(17; "Outstanding Bill"; Decimal)
        {
        }
        field(18; "Additional Top Up Commission"; Boolean)
        {
        }
        field(19; "Loan Span"; Option)
        {
            OptionCaption = ' ,Short Term,Long Term';
            OptionMembers = " ","Short Term","Long Term";
        }
        field(20; "Untransfered Interest"; Decimal)
        {
        }
        field(21; "Additional Interest"; Decimal)
        {
        }
        field(22; "Appraisal Top Up"; Decimal)
        {
        }
        field(23; "Penalty Top UP"; Decimal)
        {
        }
        field(24; "Expected Interest Due"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Client Code", "Loan Top Up")
        {
            SumIndexFields = "Total Top Up", "Principle Top Up";
        }
        key(Key2; "Principle Top Up")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Loan Top Up", "Client Code", "Principle Top Up", "Interest Top Up", Commision)
        {
        }
    }

    trigger OnDelete()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text002, LoanApp.Status);
        end;

        LoanG.Reset;
        LoanG.SetRange("Loan No", "Loan Top Up");
        LoanG.SetRange("Guarantor Type", LoanG."Guarantor Type"::Lien);
        if LoanG.FindFirst then begin
            LoanG.ModifyAll("Loan Top Up", false);

            LoanG.Reset;
            LoanG.SetRange("Loan No", "Loan No.");
            LoanG.SetRange("Guarantor Type", LoanG."Guarantor Type"::Lien);
            if LoanG.FindFirst then
                LoanG.DeleteAll;

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

    trigger OnRename()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text002, LoanApp.Status);
        end;
    end;

    var
        Loans: Record Loans;
        Loantypes: Record "Product Factory";
        Interest: Decimal;
        Cust: Record Members;
        RepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedRepayment: Decimal;
        RepaymentMade: Decimal;
        ExpectedInterest: Decimal;
        InterestPaid: Decimal;
        InterestArrears: Decimal;
        Count1: Integer;
        GenSetup: Record "General Set-Up";
        RemainingPeriod: Decimal;
        IntBal: Decimal;
        LoanApp: Record Loans;
        DateFilter: Text;
        InstallPaid: Integer;
        InsureReabate: Decimal;
        NoOfMonths: Integer;
        NoOfInstallments: Integer;
        HalfNoOfInstallments: Decimal;
        TotalExpeInt: Decimal;
        Insurance: Decimal;
        LoanServ: Record Loans;
        ProdCharges: Record "Loan Product Charges";
        EndDate: Date;
        // DailyLoansInterestBuffer: Record "Daily Loans Interest Buffer";
        LoanTypes2: Record "Product Factory";
        //LoanToBridge: Record "Loan Products to Bridge";
        Text001: Label 'This product %1 is not allowed for offset by %2';
        Text002: Label 'Loan is already %1 and cannot modify';
        NetAmt: Decimal;
        //LoansProcess: Codeunit "Loans Process";
        Text003: Label 'The approved amount is not sufficient to clear this loan';
        LoanG: Record "Loan Guarantors and Security";
        M: Integer;
        ExpIntDue: Decimal;
        RemIntDue: Decimal;
        BUser: Record "Banking User Template";
        JBatch: Code[10];
        JTemplate: Code[10];
        // SaccoTrans: Codeunit "Sacco Transactions";
        AcctType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        TransType: Option " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,Appraisal,"Ledger Fee";
        CLedger: Record "Credit Ledger Entry";
    // PeriodicActivities: Codeunit "Periodic Activities";

    local procedure GetCommission(): Decimal
    var
        PCharges: Record "Loan Product Charges";
        Amt: Decimal;
        MainProduct: Record "Product Factory";
        MainLoan: Record Loans;
    begin



        Amt := 0;
        GenSetup.Get;

        if GenSetup."Loan Top Up Commission Type" = GenSetup."Loan Top Up Commission Type"::Single then begin

            Loans.Get("Loan Top Up");
            Loantypes.Get(Loans."Loan Product Type");
            MainLoan.Get("Loan No.");
            MainProduct.Get(MainLoan."Loan Product Type");

            if MainProduct."TopUp Comm. Condition" = MainProduct."TopUp Comm. Condition"::"Commission on Same Product Only" then
                if MainProduct."Product ID" <> Loantypes."Product ID" then
                    exit(0);

            PCharges.Reset;
            PCharges.SetRange(PCharges."Product Code", Loantypes."Product ID");
            PCharges.SetRange(PCharges."Charge Type", PCharges."Charge Type"::"Top up");
            if PCharges.Find('-') then begin
                repeat
                    PCharges.TestField(PCharges."Charges G_L Account");

                    if (PCharges."Charge Method" = PCharges."Charge Method"::"% of Amount") and (PCharges."Charging Option" = PCharges."Charging Option"::"On Approved Amount") then begin
                        Amt := (Loans."Approved Amount" * (PCharges.Percentage / 100));
                    end else
                        if (PCharges."Charge Method" = PCharges."Charge Method"::"% of Amount") and (PCharges."Charging Option" = PCharges."Charging Option"::"On Net Amount") then begin
                            Amt := (("Principle Top Up" + "Interest Top Up" + "Penalty Top UP" + "Appraisal Top Up") * (PCharges.Percentage / 100))
                        end else
                            Amt := PCharges."Charge Amount";

                /*
                IF Amt< PCharges.Minimum THEN
                Amt:= PCharges.Minimum;
        
                IF Amt > PCharges.Maximum THEN
                Amt := PCharges.Maximum;
                */
                //If excise duty involved
                // IF PCharges."Effect Excise Duty"=PCharges."Effect Excise Duty"::Yes THEN BEGIN
                //   Amt:=Amt*GenSetup."Excise Duty (%)"*0.01;
                //END;

                until PCharges.Next = 0;
            end;

            Amt := Round(Amt, 0.05, '=');
        end;

        exit(Amt);

    end;

    local procedure ChargeInterest(LoanRec: Record Loans; Amt: Decimal)
    begin

        BUser.Get(UserId);
        BUser.TestField("Interest Account Template");
        BUser.TestField("Interest Account Batch");
        JTemplate := BUser."Interest Account Template";
        JBatch := BUser."Interest Account Batch";

        if Loantypes.Get(Loans."Loan Product Type") then begin
            /*SaccoTrans.InitJournal(JTemplate, JBatch);

            SaccoTrans.JournalInsert(JTemplate, JBatch, LoanRec."Loan No.", Today, AcctType::Credit, LoanRec."Loan Account", 'Top Up Interest Due',
                    AcctType::"G/L Account", Loantypes."Loan Interest Account [G/L]", Amt, "Loan No.", LoanRec."Loan No.", TransType::"Interest Due",
                    LoanRec."Global Dimension 1 Code", LoanRec."Global Dimension 2 Code", true);
            SaccoTrans.PostJournal(JTemplate, JBatch);*/
        end;
    end;
}

