/// <summary>
/// Table Loans (ID 51532055).
/// </summary>
/// <summary>
/// Table Loans (ID 51532055).
/// </summary>
table 51532055 Loans
{


    fields
    {
        field(1; "Loan No."; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Loan No." <> xRec."Loan No." then begin

                    MembNoSeries.Get;
                    NoSeriesMgt.TestManual(MembNoSeries."Loan Nos.");
                    "No. Series" := '';

                    //Check dimensions and responsibility centre

                    /*if UserSetup.Get(UpperCase(UserId)) then begin
                        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                        "Responsibility Centre" := UserSetup."Responsibility Centre";

                    end;*/

                end;
            end;
        }
        field(2; "Application Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin

                if "Application Date" > Today then
                    Error('Application date can not be in the future.');
            end;
        }
        field(3; "Loan Product Type"; Code[20])
        {

            TableRelation = /*IF ("Loan Group" = FILTER(MFI)) "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Loan),
                                                                                                 Status = CONST(Active),
                                                                                                 "Loan Group" = FILTER(MFI))
             ELSE*/
            IF ("Loan Group" = FILTER(BOSA)) "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Loan),
                                                                                                                                                                          Status = CONST(Active),
                                                                                                                                                                          "Loan Group" = FILTER(BOSA))
            ELSE
            IF ("Loan Group" = FILTER(FOSA)) "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Loan),
                                                                                                                                                                                                                                                    Status = CONST(Active),
                                                                                                                                                                                                                                                    "Loan Group" = FILTER(FOSA))
            /*ELSE
            IF ("Loan Group" = FILTER(BUSINESS)) "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Loan),
                                                                                                                                                                                                                                                                                                                                  Status = CONST(Active),
                                                                                                                                                                                                                                                                                                                                  "Loan Group" = FILTER(BUSINESS))
            */
            ELSE
            IF ("Loan Group" = FILTER(" ")) "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Loan),
                                                                                                                                                                                                                                                                                                                                                                                                           Status = CONST(Active));

            trigger OnValidate()
            var
                AccNo: Code[20];
                SProduct: Record "Product Factory";
                CheckDate: Date;
                NewInst: Integer;
                SavAcc1: Record "Savings Accounts";
                LoanApp1: Record Loans;
                SalaryLines: Record "Salary Lines";
                LoansBridge: Record "Loan Products to Bridge";
                PostedLoan: Record Loans;
                FoundBridgePro: Boolean;
                RemainingInst: Integer;
                //GenF: Codeunit "General Functions";
                Error0001: Label 'This member has not had salary processed through sacco for the required no of times';
            begin
                Clear(FoundBridgePro);
                // clearloandetails();
                if ProdFac.Get(Rec."Loan Product Type") then begin

                    "Interest Due on Disbursement" := ProdFac."Interest Due on Disbursement";

                    "Global Dimension 1 Code" := ProdFac."Global Dimension 1 Code";
                    if UserSetup.get(UserID) then begin
                        // "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                        // "Responsibility Centre" := UserSetup."Responsibility Centre";
                    end;
                    if ProdFac."Is Top Up Product" then begin
                        LoansBridge.RESET;
                        LoansBridge.setrange("Product Code", "Loan Product Type");
                        if LoansBridge.find('-') then
                            repeat
                                PostedLoan.Reset;
                                PostedLoan.setrange("Member No.", Rec."Member No.");
                                PostedLoan.setrange("Loan Product Type", LoansBridge."Product To Bridge");
                                PostedLoan.setfilter("Outstanding Balance", '>0');
                                if PostedLoan.findfirst then
                                    FoundBridgePro := true;
                            until LoansBridge.next = 0;
                        if FoundBridgePro = false then error('Member does not have any product that can be bridged');
                    end;
                end;
                "Bill on Disursement" := ProdFac."Interest Due on Disbursement";


                "Loan Product Type Name" := ProdFac."Product Description";
                "Grace Period" := ProdFac."Grace Period - Interest";
                Interest := ProdFac."Interest Rate (Min.)";
                "Monthly Interest" := Interest / 12;
                "Grace Period" := ProdFac."Grace Period - Interest";
                "Interest Calculation Method" := ProdFac."Interest Calculation Method";
                "Loan Span" := ProdFac."Loan Span";
                Installments := ProdFac."Ordinary Default Intallments";
                //waumini change on top up product
                if ProdFac."Is Top Up Product" then begin
                    RemainingInst := 0;
                    LoanApp1.Reset;
                    LoanApp1.Setrange("Member No.", "Member No.");
                    LoanApp1.SetFilter("Outstanding Balance", '>0');
                    if LoanApp1.Find('-') then begin
                        Repeat
                            if LoanApp1.Installments > 12 then begin
                                // if GenF.CalculateMonthBetweenTwoDate(LoanApp1."Repayment Start Date", LoanApp1."Expected Date of Completion") > RemainingInst then
                                //    RemainingInst := GenF.CalculateMonthBetweenTwoDate(LoanApp1."Repayment Start Date", LoanApp1."Expected Date of Completion");
                            end;
                        until LoanApp1.next = 0;
                        Installments := RemainingInst;
                        "Max. Installments" := RemainingInst;
                    end;
                end;
                "Compute Interest Due on Postin" := ProdFac."Interest Calculation Type";
                "Repayment Frequency" := ProdFac."Repayment Frequency";
                "Recovery Mode" := ProdFac."Repay Mode";
                "Appraisal Parameter Type" := ProdFac."Appraisal Parameter Type";
                "Loan Group" := ProdFac."Loan Group";
                "Loan Category" := ProdFac."Loan Category";
                "Share Capital Loan" := ProdFac."Share Capital Loan";
                TestField("Member No.");
                Validate("Cell Group Code");
                "Requested Amount" := 0;
                "Approved Amount" := 0;
                "Loan Account" := '';
                "Loan Group" := "Loan Group"::" ";
                Multiplier := 0;


                if ProdFac.Get("Loan Product Type") then begin
                    if ProdFac."Minimum Loan App. period" <> DefaultDF then begin
                        Members.Get("Member No.");
                        if CalcDate(ProdFac."Minimum Loan App. period", Members."Registration Date") > Today then
                            Error('Member Must be %1 Old in the Sacco to Apply for this Product', ProdFac."Minimum Loan App. period");
                    end;
                    if ProdFac."Loan Clients" = ProdFac."Loan Clients"::Staff then begin
                        if Members.Get("Member No.") then
                            if Members."Account Category" <> Members."Account Category"::"Staff Members" then
                                Error('This loan is only applicable to Staff');

                        Members.TestField("Payroll/Staff No.");
                        HREmployees.Get(Members."Payroll/Staff No.");
                        if ProdFac."Staf Employment Period(M)" > 0 then begin
                            HREmployees.TestField("Date Of Join");
                            if Round((Today - HREmployees."Date Of Join") / 30) < ProdFac."Staf Employment Period(M)" then
                                Error('Member does not qualify for this Product. Member must have been in employment for %1 Months', ProdFac."Staf Employment Period(M)");
                        end;
                    end
                    else begin
                        if ProdFac."No Guarantors" = false then
                            ProdFac.TestField("Appraisal Savings Product");
                        DepProduct.Get(ProdFac."Appraisal Savings Product");

                        AccNo := '';
                        SavAcc.Reset;
                        SavAcc.SetRange(SavAcc."Member No.", "Member No.");
                        SavAcc.SetFilter("Product Type", DepProduct."Product ID");
                        if SavAcc.Find('-') then begin
                            SavAcc.CalcFields("First Transaction Date");
                            AccNo := SavAcc."No.";





                        end;

                    end;


                    "Expected Loan Reg. Fee" := ProdFac."Ledger Fee";


                    if ProdFac."Loan Clients" <> ProdFac."Loan Clients"::Staff then
                        if AccNo = '' then
                            Message('Kindly Note that this Member Does not have a %1 Account', DepProduct."Product Description");

                    if (ProdFac."Loan Group" = ProdFac."Loan Group"::FOSA) and (ProdFac."No Guarantors" = false) then begin //dont insert gua for ADVANCE product
                        LoanGuara.Reset;
                        LoanGuara.SetRange("Loan No", "Loan No.");
                        if LoanGuara.Find('-') then
                            LoanGuara.DeleteAll;

                        SavAcc.Reset;
                        SavAcc.SetAutoCalcFields("Balance (LCY)");
                        SavAcc.SetRange(SavAcc."No.", AccNo);
                        SavAcc.SetFilter("Balance (LCY)", '>%1', 0);
                        if SavAcc.Find('-') then begin
                            LoanGuara.Init;
                            LoanGuara."Loan No" := "Loan No.";
                            LoanGuara.Validate("Loan No");
                            LoanGuara."Member No" := SavAcc."Member No.";
                            ;
                            LoanGuara."Savings Account No./Member No." := SavAcc."No.";
                            LoanGuara.Name := SavAcc.Name;
                            LoanGuara."ID No." := SavAcc."ID No.";
                            LoanGuara."Savings Product" := ProdFac."Appraisal Savings Product";
                            LoanGuara.Validate(LoanGuara."Member No");
                            LoanGuara."Amount Guaranteed" := SavAcc."Balance (LCY)";
                            //LoanGuara."Available Guarantorship":=(LoanGuara."Available Guarantorship"*GenSetup."Self Guarantee %"*0.01);
                            GuarLoan.Reset;
                            GuarLoan.SetAutoCalcFields("Outstanding Balance");
                            GuarLoan.SetRange("Member No.", SavAcc."Member No.");
                            GuarLoan.SetRange("Loan Product Type", 'L16');
                            GuarLoan.SetFilter("Outstanding Balance", '>%1', 0);
                            if GuarLoan.FindFirst then begin
                                repeat
                                    GuarLoan.CalcFields("Outstanding Balance");
                                    LoanGuara."Guarantor Loan Balance" += GuarLoan."Outstanding Balance";
                                //LoanGuara."Outstanding Balance Bal" += GuarLoan."Outstanding Balance";
                                until GuarLoan.Next = 0;
                            end;
                            //LoanGuara.VALIDATE("Outstanding Balance Bal");
                            LoanGuara.Insert(true);
                        end;
                        //FOR COLLATERAL
                        Colla.Reset;
                        Colla.SetRange(Colla."Account No.", "Member No.");
                        Colla.SetRange(Colla.Status, Colla.Status::Approved);
                        Colla.SetRange(Colla."Inward/Outward", Colla."Inward/Outward"::"In-Store");
                        if Colla.Find('-') then begin
                            repeat
                                LoanGuara2.Reset;
                                LoanGuara2.SetRange("Savings Account No./Member No.", Colla."Account No.");
                                LoanGuara2.SetRange("Collateral Reg. No.", Colla."No.");
                                if not LoanGuara2.Find('-') then begin
                                    LoanGuara.Init;
                                    LoanGuara."Loan No" := "Loan No.";
                                    LoanGuara."Guarantor Type" := LoanGuara."Guarantor Type"::Collateral;
                                    LoanGuara.Validate("Guarantor Type");
                                    LoanGuara."Member No" := "Member No.";
                                    LoanGuara."Savings Account No./Member No." := "Member No.";
                                    LoanGuara.Name := "Member Name";
                                    LoanGuara."ID No." := "ID No.";
                                    LoanGuara."Collateral Reg. No." := Colla."No.";
                                    LoanGuara.Validate(LoanGuara."Savings Account No./Member No.");
                                    LoanGuara.Validate(LoanGuara."Member No");
                                    LoanGuara.Validate(LoanGuara."Collateral Reg. No.");

                                    LoanGuara."Amount Guaranteed" := Colla."Collateral Limit";
                                    LoanGuara.Insert(true);
                                end;
                            until Colla.Next = 0;
                        end;
                    end;

                    SavAcc.Reset;
                    SavAcc.SetRange(SavAcc."Member No.", "Member No.");
                    SavAcc.SetFilter(SavAcc."Product Category", '%1', SavAcc."Product Category"::"Share Capital");
                    if not SavAcc.Find('-') then
                        Message('Kindly Note that this Member Does not have a Share Capital Account');








                    "Non-Active Guarantor Allowed" := false;
                    MicroDef := '';
                    if "Loan Group" = "Loan Group"::MFI then begin
                        if "Group Code" <> '' then begin
                            Cust.Reset;
                            Cust.SetRange("Group Code", "Group Code");
                            if Cust.FindFirst then begin
                                if Cust.Count + 1 < 5 then
                                    Error('Group Members Must be More than 5');

                                Loan.Reset;
                                Loan.SetRange("Group Code", "Group Code");
                                Loan.SetFilter("Outstanding Balance", '>0');
                                Loan.SetRange("Loan Group", Loan."Loan Group"::MFI);
                                Loan.SetFilter("Current Loans Category-SASRA", '<>%1&<>%2', Loan."Current Loans Category-SASRA"::Perfoming, Loan."Current Loans Category-SASRA"::Watch);
                                if Loan.Find('-') then begin
                                    repeat
                                        MicroDef += '\ - ' + Loan."Member No." + ' - ' + Loan."Member Name" + '-' + Format(Loan."Current Loans Category-SASRA");
                                    until Loan.Next = 0;
                                end;

                            end;
                        end;

                        if MicroDef <> '' then begin
                            Message('The following Group Members are Defaulters: \' + MicroDef);
                            if not Confirm('Do you want to send this for Authorization?') then
                                Error('Cancelled');
                        end;

                    end;



                    Members.Get("Member No.");
                    if ProdFac."Loan Clients" <> ProdFac."Loan Clients"::Members then begin
                        if ProdFac."Loan Clients" = ProdFac."Loan Clients"::Staff then
                            if Members."Account Category" <> Members."Account Category"::"Staff Members" then
                                Error('This Loan is Limited to STAFF only');

                        if ProdFac."Loan Clients" = ProdFac."Loan Clients"::Directors then
                            if Members."Account Category" <> Members."Account Category"::"Board Members" then
                                Error('This Loan is Limited to Board Members only');

                    end;

                    // "Global Dimension 1 Code":=ProdFac."Global Dimension 1 Code";

                    if ProdFac."Type of Discounting" <> ProdFac."Type of Discounting"::"Loan Discounting" then begin


                        if ProdFac."Nature of Loan Type" <> ProdFac."Nature of Loan Type"::"Property Sale" then
                            if "Mode of Disbursement" = "Mode of Disbursement"::"Savings Account" then
                                ProdFac.TestField("Disbursement Product");



                        DisbProducts.Reset;
                        DisbProducts.SetRange("Product ID", ProdFac."Disbursement Product");
                        if DisbProducts.FindFirst then begin

                            if "Mode of Disbursement" = "Mode of Disbursement"::"Savings Account" then begin
                                SavAcc.Reset;
                                SavAcc.SetRange("Member No.", "Member No.");
                                SavAcc.SetRange("Product Type", DisbProducts."Product ID");
                                if not SavAcc.Find('-') then
                                    //ERROR();
                                    //Reg.CreateSavingsAccount(DisbProducts, "Member No.", 0);



                                SavAcc.Reset;
                                SavAcc.SetRange("Member No.", "Member No.");
                                SavAcc.SetRange("Product Type", DisbProducts."Product ID");
                                SavAcc.SetRange("Loan Disbursement Account", true);
                                if SavAcc.Find('-') then begin
                                    if not SavAcc."Loan Disbursement Account" then begin
                                        SavAcc."Loan Disbursement Account" := true;
                                        SavAcc.Modify;
                                    end;
                                end;
                            end;

                            if ProdFac."Nature of Loan Type" <> ProdFac."Nature of Loan Type"::"Property Sale" then begin
                                if "Mode of Disbursement" = "Mode of Disbursement"::"Savings Account" then begin
                                    SavAcc.Reset;
                                    SavAcc.SetRange("Member No.", "Member No.");
                                    SavAcc.SetRange("Product Type", DisbProducts."Product ID");
                                    SavAcc.SetRange("Loan Disbursement Account", true);
                                    if SavAcc.Find('-') then begin
                                        Validate("Disbursement Account No", SavAcc."No.")
                                    end
                                    else
                                        Message('This member does not have a %1 loan disbursement savings account', DisbProducts."Product ID");
                                end;
                            end;

                        end;
                    end;


                    TestField("Member No.");
                    GenSetup.Get();

                    //CAPITAL=== CHECK IF SHARE CAPITAL PRODUCT IS APPLIED AND MEMBER HAS ALREADY MET THE MINIMUM SHARECAPITAL REQUIRED
                    if ProdFac."Share Capital Loan" = true then begin
                        ShareCapAcc.Reset;
                        ShareCapAcc.SetRange(ShareCapAcc."Member No.", "Member No.");
                        ShareCapAcc.SetRange(ShareCapAcc."Product Category", ShareCapAcc."Product Category"::"Share Capital");
                        if ShareCapAcc.Find('-') then begin
                            ShareCapAcc.CalcFields(ShareCapAcc."Balance (LCY)");
                            if ShareCapAcc."Balance (LCY)" > GenSetup."Minimum Share Capital" then
                                Error('Member no. %1 has share capital of %2 and maximum required share capital is %3', LoanApp."Member No.", ShareCapAcc."Balance (LCY)", GenSetup."Minimum Share Capital");

                        end
                        else
                            Error('Member doesn''t have share capital account');
                    end;


                    //Get age of the client
                    if Mem.Get("Member No.") then begin
                        //if from another sacco
                        //Mem.TESTFIELD(Mem."Date of Birth");
                        if Mem."Date of Birth" <> 0D then begin
                            if Mem.Type <> Mem.Type::"From Other Sacco" then begin
                                if Mem."Group Account" = false then begin


                                    // ClientAge := HRDates.DetermineAge(Mem."Date of Birth", Today);

                                    ClientAgePart := CopyStr(ClientAge, 1, 2);

                                    ClientAgePart := CopyStr(ClientAge, 1, 2);

                                    Evaluate(ClientAgeValue, ClientAgePart);
                                    ProdFac.TestField(ProdFac."Min. Customer Age");
                                    ProdMinAgeText := DelChr(Format(ProdFac."Min. Customer Age"), '=', 'Y|M');

                                    Evaluate(ProdMinAge, ProdMinAgeText);
                                end;


                                if ProdMinAge > ClientAgeValue then
                                    Error(Text005, ProdFac."Min. Customer Age");
                            end
                            else
                                Message(Text010);
                        end;

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
                                if ProdFac."Allow Multiple Running Loans" = false then begin

                                    TopUp.Reset;
                                    TopUp.SetRange("Loan No.", "Loan No.");
                                    TopUp.SetRange("Loan Top Up", LoanApp."Loan No.");
                                    if not TopUp.FindFirst then
                                        Message('Member already has an existing Loan %1 of same product which needs bridging', LoanApp."Loan No.");
                                end
                                else
                                    Message('Member already has an existing Loan %1 of same product', LoanApp."Loan No.");
                            end;
                        until LoanApp.Next = 0;
                    end;





                    "Interest Due on Disbursement" := ProdFac."Interest Due on Disbursement";
                    "Bill on Disursement" := ProdFac."Interest Due on Disbursement";


                    "Loan Product Type Name" := ProdFac."Product Description";
                    "Grace Period" := ProdFac."Grace Period - Interest";
                    Interest := ProdFac."Interest Rate (Min.)";
                    "Monthly Interest" := Interest / 12;
                    "Grace Period" := ProdFac."Grace Period - Interest";
                    "Interest Calculation Method" := ProdFac."Interest Calculation Method";
                    "Loan Span" := ProdFac."Loan Span";
                    Installments := ProdFac."Ordinary Default Intallments";
                    "Compute Interest Due on Postin" := ProdFac."Interest Calculation Type";
                    "Repayment Frequency" := ProdFac."Repayment Frequency";
                    "Recovery Mode" := ProdFac."Repay Mode";
                    "Appraisal Parameter Type" := ProdFac."Appraisal Parameter Type";
                    "Loan Group" := ProdFac."Loan Group";
                    "Loan Category" := ProdFac."Loan Category";
                    "Share Capital Loan" := ProdFac."Share Capital Loan";
                end;

                //Avoid multiple loan applications pending
                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Member No.", "Member No.");
                LoanApp.SetRange(LoanApp.Posted, false);
                LoanApp.SetFilter("Loan No.", '<>%1', "Loan No.");
                if LoanApp.Find('-') then begin
                    repeat
                        if LoanApp.Status <> LoanApp.Status::Rejected then begin
                            if ProdFac.Get(LoanApp."Loan Product Type") then begin
                                if ProdFac."Type of Discounting" = ProdFac."Type of Discounting"::" " then begin
                                    //IF LoanApp."Loan No." <> "Loan No." THEN
                                    //ERROR('Member already has an existing %1 application: %2 - %3',LoanApp."Loan Product Type Name","Loan Account",LoanApp."Loan No.");
                                end;
                            end;
                        end;
                    until LoanApp.Next = 0;
                end;



                //Update required documents

                LoanReqDocs.Reset;
                LoanReqDocs.SetRange(LoanReqDocs."Loan No.", "Loan No.");
                if LoanReqDocs.Find('-') then begin
                    LoanReqDocs.DeleteAll;
                end;

                ApplDocs.Reset;
                ApplDocs.SetRange(ApplDocs."Product ID", "Loan Product Type");
                if ApplDocs.Find('-') then begin
                    repeat
                        LoanReqDocs.Init;
                        LoanReqDocs."Loan No." := "Loan No.";
                        LoanReqDocs.Description := ApplDocs.Description;
                        LoanReqDocs."Document No." := ApplDocs."Document No.";
                        LoanReqDocs."Document Type" := ApplDocs."Document Type";
                        LoanReqDocs."Entry No." := LoanReqDocs."Entry No." + 100;
                        LoanReqDocs."Product ID" := "Loan Product Type";
                        LoanReqDocs."Product Name" := "Loan Product Type Name";
                        LoanReqDocs.Insert;
                    until ApplDocs.Next = 0;
                end;


                //Revalidate installments
                if "Approved Amount" > 0 then
                    Validate(Installments);
                Validate("Loan Category");




                Validate("Disbursement Date");

                if "Disbursement Account No" <> '' then begin
                    if ProdFac."Type of Discounting" <> ProdFac."Type of Discounting"::"Loan Discounting" then begin
                        UpdatePeriodicIncome;
                        UpdateIncomeAnalysis;
                    end;
                end;


                GetStaffInstallment;


                SetSalaryDetails;


                if Multiplier = 0.0 then Multiplier := ProdFac."Ordinary Deposits Multiplier";

                GetCPV;
                //validate no of salary times
                ProdFac.Get("Loan Product Type");
                if ProdFac."No. of Salary Times" > 0 then begin
                    ProdFac.testfield("Salary Period");
                    SalaryLines.Reset;
                    SalaryLines.SetRange("Member No.", "Member No.");
                    SalaryLines.SetRange(Posted, True);
                    SalaryLines.SetRange("Posting Date", Calcdate(StrSubstNo('-%1', ProdFac."Salary Period"), Today), Today);
                    IF SalaryLines.FINDSET then begin
                        If SalaryLines.Count < ProdFac."No. of Salary Times" then
                            Error(Error0001);
                    end else
                        Error(Error0001);

                end;

            end;
        }
        field(4; "Member No."; Code[20])
        {
            TableRelation = Members."No." WHERE("Customer Type" = FILTER(Single | "group"), Status = const(Active));

            trigger OnValidate()
            var
                LoansG: Record "Loan Guarantors and Security";
                ImageData: Record "Image Data";
                SigFound: Boolean;
                PictureFound: Boolean;
            begin
                if "Member No." <> '' then begin
                    if "Loan No." <> '' then
                        ClearLoanDetails;
                    Validate("Cell Group Code");
                    if ProdFac.Get("Loan Product Type") then
                        "Disbursement Account No" := '';
                    "Loan Account" := '';



                    GenSetup.Get;






                    Unpaid := '';
                    LArrears := '';
                    Ldefaulted := '';

                    LoanApp.Reset;
                    LoanApp.SetRange(LoanApp."Member No.", "Member No.");
                    LoanApp.SetRange(LoanApp.Posted, true);
                    LoanApp.SetFilter(LoanApp."Outstanding Balance", '>0');
                    if LoanApp.Find('-') then begin
                        repeat
                            LoanApp.CalcFields(LoanApp."Outstanding Bills", "Outstanding Balance");
                            if LoanApp."Approved Amount" = LoanApp."Outstanding Balance" then
                                Unpaid += '\ - ' + LoanApp."Loan Product Type";

                            if LoanApp."Outstanding Bills" > 0 then
                                LArrears += '\ - ' + LoanApp."Loan Product Type Name";

                            if LoanApp."Expected Date of Completion" <= Today then
                                Ldefaulted += '\ -' + LoanApp."Loan Product Type Name";


                        until LoanApp.Next = 0;
                        /*
                        IF Unpaid<>'' THEN
                            MESSAGE(Text003+Unpaid);
                            */
                        if LArrears <> '' then
                            Message(Text004 + LArrears);
                        if LoanApp."Expected Date of Completion" <= Today then begin
                            if Ldefaulted <> '' then
                                Message(Text020 + Ldefaulted);

                        end;
                    end;

                    if Mem.Get("Member No.") then begin
                        if Mem."Customer Type" in [Mem."Customer Type"::Joint, Mem."Customer Type"::Microfinance] then
                            Error('Please note that this Customer type %1 is not eligible for a loan', Mem."Customer Type");
                        If Mem.status <> Mem.Status::Active then
                            Error('Please note that only active members can apply for a loan');
                        //"Global Dimension 1 Code" := Mem."Global Dimension 1 Code";
                        //"Global Dimension 2 Code" := Mem."Global Dimension 2 Code";
                        if Mem.Status <> Mem.Status::Active then
                            if Confirm('This member is not active. Do you wish to continue with application ?', true) = false then
                                Error("InactiveErr:");
                        LoansG.Reset;
                        LoansG.SetRange("Member No", "Member No.");
                        LoansG.setfilter("Outstanding Balance", '>0');
                        IF LoansG.Find('-') then
                            repeat
                                LoanApp.reset;
                                LoanApp.setrange("loan no.", LoansG."Loan No");
                                If LoanApp.findfirst then begin
                                    LoanApp.Calcfields("Current Loans Category-SASRA", "Outstanding Balance");
                                    If LoanApp."outstanding Balance" > 0 then
                                        IF LoanApp."Current Loans Category-SASRA" IN
                                       [LoanApp."Current Loans Category-SASRA"::Doubtful, LoanApp."Current Loans Category-SASRA"::Loss, LoanApp."Current Loans Category-SASRA"::SubStandard] then
                                            Error('This member has guaranteed a defaulted  loan no %1 in sasra category %1', LoanApp."Loan No.", Format(LoanApp."Current Loans Category-SASRA"));

                                end;
                            until LoansG.next = 0;
                        LoansG.Reset;
                        LoansG.SetRange("Member No", "Member No.");
                        LoansG.setfilter("Outstanding Balance", '>0');
                        LoansG.Setrange("Member Guaranteed", "Member No.");
                        IF LoansG.Find('-') then begin

                        end;

                        "Staff No" := Mem."Payroll/Staff No.";
                        "Member Name" := Mem.Name;
                        "Application Date" := Today;
                        "ID No." := Mem."ID No.";

                        "Group Code" := Mem."Group Code";
                        Mem.TestField("Registration Date");
                        Mem.TestField("Mobile Phone No");

                        "Customer CID" := Mem."Form No.";
                        "Old Member No." := Mem."Old Member No.";
                        PictureFound := false;
                        SigFound := False;
                        ImageData.Reset;
                        ImageData.setrange("Member No", "Member No.");
                        If ImageData.FIND('-') then begin
                            ImageData.CalcFields(Picture, Signature);
                            if ImageData.Picture.HasValue then
                                Picturefound := true;
                        end;
                        //signature check
                        begin
                            ImageData.Reset;
                            ImageData.setrange("Member No", "Member No.");
                            If ImageData.FIND('-') then begin
                                ImageData.CalcFields(Picture, Signature);
                                if ImageData.Signature.HasValue then
                                    Sigfound := true;
                            end;
                        end;

                        If PictureFound = false then
                            Error('This member does not have a picture');
                        If SigFound = false then
                            Error('This member does not have a Signature');



                        "Employer Code" := Mem."Employer Code";
                        // "Global Dimension 1 Code":=Mem."Global Dimension 1 Code";
                        //"Global Dimension 2 Code":=Mem."Global Dimension 2 Code";
                        if Mem."ID No." = '' then
                            Error('Kindly update the ID No for this member before proceeding');

                    end
                    else
                        Error('Member does not exist');

                    if ("Member No." <> '') and ("Member No." <> xRec."Member No.") then begin
                        "Loan Account" := '';
                        "Disbursement Account No" := '';
                    end;


                    //Check share capital requirement
                    SavAcc.Reset;
                    SavAcc.SetRange(SavAcc."Member No.", "Member No.");
                    SavAcc.SetRange(SavAcc."Product Category", SavAcc."Product Category"::"Share Capital");
                    if SavAcc.Find('-') then begin
                        SavAcc.CalcFields(SavAcc."Balance (LCY)");
                        //Check Minimum savings per product
                        if SavAcc."Balance (LCY)" < GenSetup."Minimum Share Capital" then
                            Message(Text019, SavAcc."Balance (LCY)", GenSetup."Minimum Share Capital");
                    end
                    else
                        Message(Text019, SavAcc."Balance (LCY)", GenSetup."Minimum Share Capital");

                    //Check minimum deposits
                    SavAcc.Reset;
                    SavAcc.SetRange(SavAcc."Member No.", "Member No.");
                    SavAcc.SetRange(SavAcc."Product Category", SavAcc."Product Category"::"Deposit Contribution");
                    if SavAcc.Find('-') then begin
                        SavAcc.CalcFields(SavAcc."Balance (LCY)");
                        //Check Minimum savings per product
                        if SavAcc."Balance (LCY)" < ProdFac."Minimum Deposit Balance" then
                            Message(Text011, SavAcc."Balance (LCY)", ProdFac."Minimum Deposit Balance");


                        if GenSetup."Boosting Shares %" > 0 then begin
                            ShareBoostComm := 0;
                            SavLedger.Reset;
                            SavLedger.SetRange(SavLedger."Customer No.", SavAcc."No.");
                            if SavLedger.Find('-') then begin
                                repeat
                                    // MESSAGE('Amount %1 Boost Mat %2 Boost %3 Post date %4',SavLedger.Amount,GenSetup."Boosting Maturity",GenSetup."Boosting Shares %",SavLedger."Posting Date");
                                    if SavLedger."Posting Date" > CalcDate('-' + Format(GenSetup."Boosting Maturity"), "Application Date") then begin
                                        if SavLedger.Amount * -1 > SavAcc."Monthly Contribution" * GenSetup."Boosting Shares %" * 0.01 then begin
                                            "Share Boosted Amount" := "Share Boosted Amount" + SavLedger.Amount;
                                            NoOfDays := "Application Date" - SavLedger."Posting Date";
                                            NoOfMonths := Round(NoOfDays / 30, 1, '>');

                                            if NoOfMonths = 0 then
                                                ShareBoostComm := ShareBoostComm + (Abs(SavLedger.Amount) * 0.03)
                                            else
                                                if NoOfMonths = 1 then
                                                    ShareBoostComm := ShareBoostComm + (Abs(SavLedger.Amount) * 0.03)
                                                else
                                                    if NoOfMonths = 2 then
                                                        ShareBoostComm := ShareBoostComm + (Abs(SavLedger.Amount) * 0.02)
                                                    else
                                                        ShareBoostComm := ShareBoostComm + (Abs(SavLedger.Amount) * 0.01);
                                            //MESSAGE('Amount %1 pdate %2 Months %3 ShareBoost %4',SavLedger.Amount,SavLedger."Posting Date",NoOfMonths,ShareBoostComm );
                                        end;
                                    end;
                                until SavLedger.Next = 0;
                            end;

                            "Share Boosted Amount" := ShareBoostComm;
                        end;
                    end;
                    if not Posted then begin
                        LoanHistory.Reset;
                        LoanHistory.SetRange(LoanHistory."Loan Application No.", "Loan No.");
                        if LoanHistory.Find('-') then begin
                            LoanHistory.DeleteAll;
                        end;
                    end;

                    LoanApp.Reset;
                    LoanApp.SetRange(LoanApp."Member No.", "Member No.");
                    LoanApp.SetRange(Posted, true);
                    if LoanApp.Find('-') then begin
                        repeat
                            LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Outstanding Bills", LoanApp."Outstanding Interest");
                            LoanHistory.Init;
                            LoanHistory."Loan Application No." := "Loan No.";
                            LoanHistory."Loan No." := LoanApp."Loan No.";
                            LoanHistory."Loan Expiry Date" := LoanApp."Expected Date of Completion";
                            LoanHistory."Loan Issued Date" := LoanApp."Disbursement Date";
                            LoanHistory."Outanding Bill" := LoanApp."Outstanding Bills";
                            LoanHistory."Outstanding Balance" := LoanApp."Outstanding Balance";
                            LoanHistory."Outstanding Interest" := LoanApp."Outstanding Interest";
                            LoanHistory."Loan Status" := LoanApp."Current Loans Category-SASRA";
                            LoanHistory."Loan Product Type" := LoanApp."Loan Product Type";
                            LoanHistory.Insert;
                        until LoanApp.Next = 0;
                    end;




                    LoanApp.Reset;
                    LoanApp.SetAutoCalcFields("Outstanding Balance", "Outstanding Interest");
                    LoanApp.SetRange("Member No.", "Member No.");
                    LoanApp.SetRange(Posted, true);
                    LoanApp.SetRange("Outstanding Balance", 0);
                    LoanApp.SetFilter("Outstanding Interest", '>%1', 0);
                    if LoanApp.Find('-') then begin
                        repeat
                            Message('Member has outstanding interest on loan %1', LoanApp."Loan No.");

                        until LoanApp.Next = 0;
                    end;


                    if "Loan Product Type" <> '' then begin
                        Validate("Loan Product Type");
                    end;


                end;
            end;
        }
        field(5; "Requested Amount"; Decimal)
        {

            trigger OnValidate()
            var
                CreditAccounts: Record "Credit Accounts";
                // LoanProcess: CodeUnit "Loans Process";
                k: Array[10] of Decimal;
            begin
                "Recommended Amount" := 0.0;
                IF "Requested Amount" <= 0 then
                    "Requested Amount" := 0;
                "Approved Amount" := "Requested Amount";


                "Amount to DisBurse" := "Requested Amount";
                "Mode of Disbursement" := "Mode of Disbursement"::"Savings Account";
                if Mem.Get("Member No.") then begin
                    "Max".Reset;
                    "Max".SetRange("Loan Product", "Loan Product Type");
                    if "Max".FindFirst then begin
                        if Mem."Customer Type" = Mem."Customer Type"::Single then begin
                            if "Requested Amount" > "Max"."Individual Qulification" then Error('Applied amount exceed allowable maximum');
                        end else
                            if Mem."Customer Type" = Mem."Customer Type"::Group then
                                if "Requested Amount" > "Max"."Group Qualification" then Error('Applied amount exceed allowable maximum');

                    end;
                end;
                if ProdFac.Get("Loan Product Type") then begin
                    if ProdFac."Loan Clients" <> ProdFac."Loan Clients"::Staff then begin
                        ProdFac.TESTFIELD("Appraisal Savings Product");
                        DepProduct.Get(ProdFac."Appraisal Savings Product");
                        DepAcc.Reset;
                        DepAcc.SetRange(DepAcc."Member No.", "Member No.");
                        DepAcc.SetRange("Product Type", ProdFac."Appraisal Savings Product");
                        if DepAcc.FindFirst then begin
                            DepAcc.CalcFields("Last Transaction Date");
                            //LastAmt := GetLastContribution(DepProduct, "Member No.");
                            //  Message(lastcont, LastAmt, DepAcc."Last Transaction Date");
                        end;
                    end;
                end;
                Loan.Reset;
                //Loan.SetRange(Loan."Loan Product Type", "Loan Product Type");
                Loan.SetRange(Loan."Member No.", "Member No.");
                Loan.SetRange(Posted, true);
                Loan.Setfilter("Outstanding Balance", '>0');
                if Loan.FindFirst then begin
                    clear(k);
                    Repeat
                        Loan.calcfields("Current Loans Category-SASRA");
                        k[6] += 1;
                        Case Loan."Current Loans Category-SASRA" of
                            Loan."Current Loans Category-SASRA"::Perfoming:
                                k[1] += 1;
                            Loan."Current Loans Category-SASRA"::Watch:
                                k[2] += 1;
                            Loan."Current Loans Category-SASRA"::Doubtful:
                                k[4] += 1;
                            Loan."Current Loans Category-SASRA"::SubStandard:
                                k[3] += 1;
                            Loan."Current Loans Category-SASRA"::Loss:
                                k[5] += 1;

                        End;
                    Until Loan.next = 0;
                    message(strsubstno('Member has %1 running loans: %2 under perfoming , %3 under watch , %4 Substandard, %5 Doubtful,%6 Loss', k[6], k[1], k[2], k[3], k[4], k[5]));
                end;
                //Validate(Installments);
                Loan.Reset;
                Loan.SetRange(Loan."Loan Product Type", "Loan Product Type");
                Loan.SetRange(Loan."Member No.", "Member No.");
                Loan.SetRange(Posted, true);
                if Loan.FindFirst then begin
                    QualifyingBands.Reset;
                    QualifyingBands.SetRange("Loan Product", "Loan Product Type");
                    QualifyingBands.SetRange("Loan No", (Loan.Count + 1));
                    if QualifyingBands.FindFirst then begin
                        if ("Requested Amount" >= QualifyingBands."Upper Limit") then Error(ErrLoanCount);
                    end;
                end;
                IF "Loan Account" = '' THEN
                    // "Loan Account" := LoanProcess."CreateLoan Account"("Member No.", "Loan Product Type");
                    if rec."Disbursement Account No" = '' then begin
                        if "Mode of Disbursement" = "Mode of Disbursement"::"Savings Account" then begin
                            DepAcc.reset;
                            DepAcc.SetRange(DepAcc."Member No.", "Member No.");
                            DepAcc.SetRange("Loan Disbursement Account", true);
                            if DepAcc.FindFirst then begin
                                "Disbursement Account No" := depacc."No.";
                            end;
                        end;
                    end;




                //ERROR('This member does not have a loan account. Please create before you proceed');


                ProdFac.Get("Loan Product Type");
                if ProdFac."Nature of Loan Type" <> ProdFac."Nature of Loan Type"::"Property Sale" then
                    if "Mode of Disbursement" = "Mode of Disbursement"::"Savings Account" then
                        if "Disbursement Account No" = '' then
                            Error('This member does not have a disbursement account. Please create before you proceed');



                //"Approved Amount":="Requested Amount";
                //"Amount To Disburse":="Requested Amount";
                //VALIDATE("Approved Amount");
                "Application Date" := Today;

                //Check maximum and minimum loan amounts

                if ProdFac.Get("Loan Product Type") then begin
                    //CAPITAL=== CHECK IF SHARE CAPITAL PRODUCT IS APPLIED AND MEMBER HAS ALREADY MET THE MINIMUM SHARECAPITAL REQUIRED
                    if ProdFac."Share Capital Loan" = true then begin
                        ShareCapAcc.Reset;
                        ShareCapAcc.SetRange(ShareCapAcc."Member No.", "Member No.");
                        ShareCapAcc.SetRange(ShareCapAcc."Product Category", ShareCapAcc."Product Category"::"Share Capital");
                        if ShareCapAcc.Find('-') then begin
                            ShareCapAcc.CalcFields(ShareCapAcc."Balance (LCY)");
                            if ShareCapAcc."Balance (LCY)" > GenSetup."Minimum Share Capital" then
                                Error('Member no. %1 has share capital of %2 and maximum required share capital is %3', LoanApp."Member No.", ShareCapAcc."Balance (LCY)", GenSetup."Minimum Share Capital");
                        end else
                            Error('Member donnot have a share capital account');
                    end;


                    if (ProdFac."Nature of Loan Type" = ProdFac."Nature of Loan Type"::Normal) or (ProdFac."Nature of Loan Type" = ProdFac."Nature of Loan Type"::" ") then begin
                        if ("Requested Amount" > ProdFac."Maximum Loan Amount") or ("Requested Amount" < ProdFac."Minimum Loan Amount") then
                            Error(LoanAmountErr, ProdFac."Minimum Loan Amount", ProdFac."Maximum Loan Amount", "Loan Product Type", "Requested Amount");
                    end;
                end;

                if ProdFac."No. Of Months for Appr. Saving" > 0 then begin




                    LastMonthDate := CalcDate('<-1M>', Today);


                    for i := 1 to ProdFac."No. Of Months for Appr. Saving" do begin
                        LowerDateLimit := CalcDate('<-CM>', LastMonthDate);
                        UpperDateLimit := CalcDate('<CM>', LastMonthDate);

                        SavLedger.SetCurrentKey(SavLedger."Customer No.", SavLedger."Posting Date");
                        SavLedger.SetRange(SavLedger."Customer No.", "Disbursement Account No");
                        SavLedger.SetRange(SavLedger."Posting Date", LowerDateLimit, UpperDateLimit);
                        SavLedger.CalcSums(SavLedger."Amount (LCY)");
                        SavLedger.CalcSums(SavLedger."Debit Amount (LCY)");
                        SavLedger.CalcSums(SavLedger."Credit Amount (LCY)");


                    end;
                end;



                if "Loan Process Type" = "Loan Process Type"::Restructuring then begin
                    if "Restructure Charge Type" = "Restructure Charge Type"::Upfront then begin
                        SavingsAccounts.Reset;
                        SavingsAccounts.SetRange(SavingsAccounts."Member No.", "Member No.");
                        SavingsAccounts.SetRange(SavingsAccounts."Loan Disbursement Account", true);
                        if SavingsAccounts.Find('-') then begin
                            SavingsAccounts.CalcFields("Balance (LCY)");
                            if SavingsAccounts."Balance (LCY)" < ("Requested Amount" * 0.01) then
                                Error('There is no sufficient amount in the current account');
                        end;
                    end;
                end;

                if "Loan Process Type" = "Loan Process Type"::Restructuring then begin
                    if "Restructure Charge Type" = "Restructure Charge Type"::"Attach to loan" then begin
                        "Requested Amount" := "Requested Amount" + ("Requested Amount" * 0.01);
                    end;
                end;


                GenSetup.Get;
                if ProdFac."Own Shares Loan" = true then begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."Member No.", "Member No.");
                    SavingsAccounts.SetRange(SavingsAccounts."Product Type", ProdFac."Appraisal Savings Product");
                    if SavingsAccounts.Find('-') then begin
                        SavingsAccounts.CalcFields("Balance (LCY)");
                        if "Requested Amount" > (GenSetup."Self Guarantee %" * SavingsAccounts."Balance (LCY)") then
                            Error(Err009);
                    end;
                end;
                UpdateRepayments("Requested Amount");
            end;
        }
        field(6; "Approved Amount"; Decimal)
        {

            trigger OnValidate()
            var
                LoanCreditScore: Record "Loan Credit Score";
            begin
                //IF "Approved Amount" > "Requested Amount" THEN
                // ERROR('Amount cannot be Greater than requested amount');
                IF "Approved Amount" <= 0 then
                    "Approved Amount" := 0;

                GetStaffInstallment;
                GenSetup.Get();
                if ProdFac.Get("Loan Product Type") then begin

                    "Expected Loan Reg. Fee" := ProdFac."Ledger Fee";


                    QualifiedAmnt := 0;
                    /*    IF ProdFac."Loan Clients" <> ProdFac."Loan Clients"::Staff THEN BEGIN
                            DepProduct.GET(ProdFac."Appraisal Savings Product");
                                DepAcc.RESET;
                                DepAcc.SETRANGE(DepAcc."Member No.","Member No.");
                                DepAcc.SETRANGE("Product Type",ProdFac."Appraisal Savings Product");
                                IF DepAcc.FINDFIRST THEN BEGIN
                                LastAmt := GetLastContribution(DepProduct,"Member No.");
                    //        DepositBands.RESET;
                    //        DepositBands.SETRANGE(Product,"Loan Product Type");
                    //        IF DepositBands.FINDFIRST THEN BEGIN
                    //        REPEAT
                    //            IF (LastAmt>=DepositBands."Lower Limit") AND (LastAmt<=DepositBands."Upper Limit") THEN BEGIN
                    //                QualifiedAmnt:=DepositBands."Qualifying Amount";
                    //                IF DepositBands."Qualifying Amount">="Requested Amount" THEN
                    //                QualifiedAmnt:="Requested Amount";
                    //
                    //                      IF "Approved Amount" >QualifiedAmnt THEN BEGIN
                    //                      ERROR('Please NOTE that Member''s Monthly Contribution (%1) is not enough to Qualify for this Amount of Loan.',LastAmt);
                    //                  END;
                    //        END;
                    //         UNTIL DepositBands.NEXT=0;
                    //        END;
                            END;

                            END;*/


                    if ProdFac."Share Capital Loan" = true then begin
                        ShareCapAcc.Reset;
                        ShareCapAcc.SetRange(ShareCapAcc."Member No.", "Member No.");
                        ShareCapAcc.SetRange(ShareCapAcc."Product Category", ShareCapAcc."Product Category"::"Share Capital");
                        if ShareCapAcc.Find('-') then begin
                            ShareCapAcc.CalcFields(ShareCapAcc."Balance (LCY)");
                            if (ShareCapAcc."Balance (LCY)" + "Approved Amount") > GenSetup."Minimum Share Capital" then
                                Error('Member no. %1 will have share capital of %2 and maximum required share capital is %3', LoanApp."Member No.", (ShareCapAcc."Balance (LCY)" + "Approved Amount"), GenSetup."Minimum Share Capital");
                        end else
                            Error('Member donnot have a share capital account');
                    end;
                    if (ProdFac."Nature of Loan Type" = ProdFac."Nature of Loan Type"::Normal) or (ProdFac."Nature of Loan Type" = ProdFac."Nature of Loan Type"::" ") then begin
                        if ("Requested Amount" > ProdFac."Maximum Loan Amount") or ("Requested Amount" < ProdFac."Minimum Loan Amount") then
                            Error(LoanAmountErr, ProdFac."Minimum Loan Amount", ProdFac."Maximum Loan Amount", "Loan Product Type", "Requested Amount");
                    end;
                end;

                if Installments <= 0 then
                    Error(InstallmentsErr);

                if "Approved Amount" > "Requested Amount" then begin
                    Error(ApprovedAmtErr);
                end;
                "Amount To Disburse" := "Approved Amount";

                //
                TotalMRepay := 0;
                LPrincipal := 0;
                LInterest := 0;
                InterestRate := Interest;
                LoanAmount := "Approved Amount";
                RepayPeriod := Installments;
                LBalance := "Approved Amount";

                UpdateRepayments(LoanAmount);



                //Validate loan credit score




                "Appraisal Fee" := GetAppraisalFee("Approved Amount");
                //   "Amount To Disburse" := 0;

            end;
        }
        field(7; Interest; Decimal)
        {
            Caption = 'Annual Interest';

            trigger OnValidate()
            begin
                TestField("Charge Upfront Interest", false);
                TestField("Loan Product Type");
                if ProdFac.Get("Loan Product Type") then begin
                    if (Interest < ProdFac."Interest Rate (Min.)") or (Interest > ProdFac."Interest Rate (Max.)") then
                        Error(InterestErrorTxt);
                end;

                if "Approved Amount" > 0 then
                    Validate("Approved Amount");

                GetCPV;
            end;
        }
        field(8; "Member Name"; Text[50])
        {
        }
        field(9; "Approval Date"; Date)
        {
        }
        field(10; Installments; Integer)
        {

            trigger OnValidate()
            var
                LTermInstallments: Integer;
            begin
                //Control
                if ProdFac.Get("Loan Product Type") then begin
                    if Installments > ProdFac."Ordinary Default Intallments" then
                        Error(Text006);
                end;


                if "Approved Amount" > 0 then
                    Validate("Approved Amount");


                Validate("Disbursement Date");
                if "Loan Process Type" = "Loan Process Type"::Normal then begin
                    LTermInstallments := 0;

                    //GetCPV;
                    //  if Installments > LTermInstallments then
                    //      Installments := LTermInstallments;
                end;
            end;
        }
        field(11; "Disbursement Date"; Date)
        {

            trigger OnValidate()
            begin

                if not Posted then
                    if "Disbursement Date" = 0D then
                        "Disbursement Date" := Today;

                ProdFac.Get("Loan Product Type");
                //"Repayment Frequency":=ProdFac."Repayment Frequency";

                if "Repayment Frequency" = "Repayment Frequency"::Daily then
                    "Repayment Start Date" := CalcDate('1D', "Disbursement Date")
                else
                    if "Repayment Frequency" = "Repayment Frequency"::Weekly then
                        "Repayment Start Date" := CalcDate('1W', "Disbursement Date")
                    else
                        if "Repayment Frequency" = "Repayment Frequency"::Monthly then begin
                            // "Repayment Start Date" := CalcDate('1M', "Disbursement Date");
                            if date2dmy("Disbursement Date", 1) > 15 then
                                "Repayment Start Date" := Calcdate('CM', calcdate('1M', "Disbursement Date"))
                            else
                                "Repayment Start Date" := Calcdate('CM', "Disbursement Date");
                        end

                        else
                            if "Repayment Frequency" = "Repayment Frequency"::Quarterly then
                                "Repayment Start Date" := CalcDate('1Q', "Disbursement Date")
                            else
                                if "Repayment Frequency" = "Repayment Frequency"::"Bi-Annual" then
                                    "Repayment Start Date" := CalcDate('6M', "Disbursement Date")
                                else
                                    if "Repayment Frequency" = "Repayment Frequency"::Yearly then
                                        "Repayment Start Date" := CalcDate('1Y', "Disbursement Date")
                                    else
                                        if "Repayment Frequency" = "Repayment Frequency"::Bonus then begin

                                            BonusDate := DMY2Date(31, 10, Date2DMY("Disbursement Date", 3));

                                            if Date2DMY(BonusDate, 3) = 2017 then
                                                BonusDate := DMY2Date(25, 10, 2017);

                                            if Date2DMY(BonusDate, 3) = 2016 then
                                                BonusDate := DMY2Date(25, 10, 2016);

                                            //MESSAGE('%1',BonusDate);
                                            if BonusDate > "Disbursement Date" then
                                                "Repayment Start Date" := BonusDate
                                            else
                                                "Repayment Start Date" := CalcDate('1Y', BonusDate);
                                        end;


                //IF ProdFac."Cutoff Day" > 0 THEN BEGIN
                /*    IF DATE2DMY("Disbursement Date",1) > ProdFac."Cutoff Day" THEN
                        "Repayment Start Date" := CALCDATE('1M+CM',"Disbursement Date")
                    ELSE
                        "Repayment Start Date" := CALCDATE('CM',"Disbursement Date");*/
                //END;



                "Schedule Start Date" := "Repayment Start Date";
                Validate("Schedule Start Date");

                //COMMIT;

                /*
                IF "Disbursement Date"<>0D THEN BEGIN
                    LoansApp.GET("Loan No.");
                    LoanProcess.GenerateRepaymentSchedule(LoansApp);
                    RSchedule.RESET;
                    RSchedule.SETRANGE("Loan No.","Loan No.");
                    IF RSchedule.FINDLAST THEN
                        "Expected Date of Completion":=RSchedule."Repayment Date";
                
                END;
                */


                if ProdFac.Get("Loan Product Type") then begin
                    if Format(ProdFac."Grace Period - Principle") <> '' then begin
                        "Repayment Start Date" := CalcDate(ProdFac."Grace Period - Principle", "Disbursement Date");
                        //"Repayment Start Date":=CALCDATE('CM',"Repayment Start Date");
                        IntstallMentPeriodText := Format(Installments) + 'M';
                        Evaluate(InstalmentPeriods, IntstallMentPeriodText);
                        "Expected Date of Completion" := CalcDate(InstalmentPeriods, "Repayment Start Date");
                    end else begin
                        //"Repayment Start Date":=CALCDATE('CM',"Disbursement Date");
                        IntstallMentPeriodText := Format(Installments) + 'M';
                        Evaluate(InstalmentPeriods, IntstallMentPeriodText);
                        "Expected Date of Completion" := CalcDate(InstalmentPeriods, "Repayment Start Date");
                    end;
                end;

            end;
        }
        field(12; "Type of Disbursement"; Option)
        {
            Editable = false;
            OptionCaption = 'Full Disbursement,Partial Disbursement';
            OptionMembers = "Full Disbursement","Partial Disbursement";

            trigger OnValidate()
            begin

                if "Type of Disbursement" = "Type of Disbursement"::"Partial Disbursement" then begin
                    if "Approved Amount" >= "Amount To Disburse" then
                        Error(DisbErr);
                end else begin
                    if "Approved Amount" <> "Amount To Disburse" then
                        Error(Text002);
                end;

                Validate("Approved Amount");
            end;
        }
        field(13; "Grace Period"; DateFormula)
        {
        }
        field(14; "Installment Period"; DateFormula)
        {
        }
        field(15; Repayment; Decimal)
        {

            trigger OnValidate()
            begin
                //GetPreviosRec(xRec.Repayment);
                // CheckoffAdvice.LoanCheckoffAdvice(Rec, Repayment, xRec.Repayment);
            end;
        }
        field(16; "Loan Product Type Name"; Text[50])
        {
            Editable = false;
        }
        field(17; Posted; Boolean)
        {
        }
        field(18; "Amount To Disburse"; Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            var
                //MngExemptionsDocApprvls: Codeunit "Mngt. Routine Processes";
                VarVariant: Variant;
                //CustomApprovals: Codeunit "Custom Approvals Codeunit";
                CompInfo: Record "Company Information";
            //DocExemptionsApprvls: Record "Document Exemptions Auth.";
            begin
                /*
                IF "Amount To Disburse" > "Recommended Amount" THEN BEGIN
                TESTFIELD("Comment for Exemptions");
                MngExemptionsDocApprvls.PerformExemptionsOnLoanApplic(Rec);
                AvailableCreditLimit();
                PassDocumentNo();
                EXIT;
                END;
                */

                if ("Amount To Disburse" < "Approved Amount") then begin
                    "Type of Disbursement" := "Type of Disbursement"::"Partial Disbursement";
                end
                else begin
                    if ("Amount To Disburse" > "Approved Amount") then
                        Error('Cannot be greater than Approved Amount');

                    "Type of Disbursement" := "Type of Disbursement"::"Full Disbursement";
                end;


                //UpdateAppraisal;
                "Partial Balance" := 0;
                if "Type of Disbursement" = "Type of Disbursement"::"Partial Disbursement" then
                    "Partial Balance" := "Net Disbursed" - "Amount To Disburse";

            end;
        }
        field(19; "Fully Disbursed"; Boolean)
        {
        }
        field(20; "Prev. Interest Rate"; Decimal)
        {
        }
        field(21; "Prev.  No. of Installment"; Integer)
        {
        }
        field(22; "Prev. Grace Period"; DateFormula)
        {
        }
        field(23; "Prev. Installment Period"; DateFormula)
        {
        }
        field(24; "Loan Balance at Rescheduling"; Decimal)
        {
        }
        field(25; "Loan Rescheduled"; Boolean)
        {
        }
        field(26; "Date Rescheduled"; Date)
        {
        }
        field(27; "Reschedule by"; Code[50])
        {
        }
        field(28; "Interest Calculation Method"; Option)
        {
            OptionCaption = 'Amortised,Reducing Balance,Straight Line,Reducing Flat,Zero Interest,Custom';
            OptionMembers = Amortised,"Reducing Balance","Straight Line","Reducing Flat","Zero Interest",Custom;
        }
        field(29; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(30; "Max. Installments"; Integer)
        {
        }
        field(31; "Max. Loan Amount"; Decimal)
        {
        }
        field(32; "Loan Cycle"; Integer)
        {
        }
        field(33; "Total Disbursed"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER(Loan)));
            FieldClass = FlowField;
        }
        field(34; "Repayment Start Date"; Date)
        {
        }
        field(35; "Disbursement Account No"; Code[20])
        {
            Editable = true;
            TableRelation = IF ("Mode of Disbursement" = CONST("Cheque/EFT")) "Bank Account"."No."
            ELSE
            IF ("Mode of Disbursement" = CONST("Savings Account")) "Savings Accounts" WHERE("Member No." = FIELD("Member No."),
                                                                                                                "Loan Disbursement Account" = CONST(true));

            trigger OnValidate()
            begin
                if "Disbursement Account No" <> '' then begin
                    if not Posted then begin
                        ProdFac.Get("Loan Product Type");
                        if ProdFac."Type of Discounting" <> ProdFac."Type of Discounting"::"Loan Discounting" then begin
                            UpdatePeriodicIncome;
                            UpdateIncomeAnalysis;
                        end;

                        SavAcc.Reset;
                        SavAcc.SetRange("No.", "Disbursement Account No");
                        if SavAcc.Find('-') then begin
                            if SavAcc.Status <> SavAcc.Status::Active then
                                Message('Please Note that the disbursement Account is not Active');
                            if SavAcc.Blocked <> SavAcc.Blocked::" " then
                                Message('Please Note that the disbursement Account is Blocked with type: %1', SavAcc.Blocked);

                        end;
                    end;
                end;
                "Mode of Disbursement" := "Mode of Disbursement"::"Savings Account";
                if "Disbursement Account No" = '' then
                    "Mode of Disbursement" := "Mode of Disbursement"::" ";
            end;
        }
        field(36; "Staff No"; Code[20])
        {
        }
        field(37; Source; Option)
        {
            OptionCaption = 'CREDIT,BANKING,MICRO,BUSINESS';
            OptionMembers = BOSA,FOSA,MICRO,BUSINESS;
        }
        field(38; Remarks; Text[100])
        {
        }
        field(39; Advice; Boolean)
        {
        }
        field(40; Defaulted; Boolean)
        {
        }
        field(41; "Captured By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(42; "Last Advice Date"; Date)
        {
        }
        field(43; "Advice Type"; Option)
        {
            OptionCaption = ' ,Fresh Loan,Adjustment,Reintroduction,Stoppage';
            OptionMembers = " ","Fresh Loan",Adjustment,Reintroduction,Stoppage;
        }
        field(44; "Current Loans Category-SASRA"; Option)
        {
            CalcFormula = Lookup("SASRA Categorization"."Loans Category-SASRA" WHERE("Loan No." = FIELD("Loan No.")));
            FieldClass = FlowField;
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = Perfoming,Watch,Substandard,Doubtful,Loss;
        }
        field(45; "Currency Code"; Code[20])
        {
        }
        field(46; "Currency Filter"; Code[10])
        {
        }
        field(47; "Top Up Type"; Option)
        {
            OptionMembers = " ","Offset Existing","Add to Existing Loan";
        }
        field(48; "Expected Date of Completion"; Date)
        {
        }
        field(49; "Recovery Mode"; Option)
        {
            OptionCaption = ' ,Salary,Milk,Tea,Staff Salary,Business,Check Off,Cash,Dividend';
            OptionMembers = " ",Salary,Milk,Tea,"Staff Salary",Business,"Check Off",Cash,Dividend;
            ValuesAllowed = " ", "Staff Salary", "Check Off", Cash, Dividend;
        }
        field(50; "Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Monthly,Quarterly,Bi-Annual,Yearly,Bonus';
            OptionMembers = Daily,Weekly,Monthly,Quarterly,"Bi-Annual",Yearly,Bonus;

            trigger OnValidate()
            begin

                //COMMIT;
            end;
        }
        field(51; Status; Option)
        {
            OptionCaption = 'Application,Appraisal,Approved,Rejected,Deffered';
            OptionMembers = Application,Appraisal,Approved,Rejected,Deffered;

            trigger OnValidate()
            var
                LoanRejRes: Record "Rejection Reason";
            begin
                ProdFac.Get("Loan Product Type");

                if ProdFac."Nature of Loan Type" <> ProdFac."Nature of Loan Type"::"Property Sale" then begin
                    if Status = Status::Approved then begin
                        if "Loan Process Type" = "Loan Process Type"::Normal then begin
                            if "Type of Disbursement" = "Type of Disbursement"::"Full Disbursement" then begin

                            end;
                        end;

                        /*if SaccoTrans.SubscribedSMS("Member No.", SourceType::"Loan Account Approval") then begin
                            if Mem.Get("Member No.") then begin

                                SendSMS.SendSms(SourceType::"Loan Account Approval", Mem."Mobile Phone No", 'Your ' + "Loan Product Type Name" + ' of KES ' + Format("Approved Amount") + ' ' +
                                'has been Approved', "Loan No.", "Disbursement Account No", true, false);
                            end;
                        end;*/

                    end;


                    if Status = Status::Rejected then begin
                        Testfield("Loan Rejection Reason");
                        LoanRejRes.Get("Loan Rejection Reason");
                        /*if SaccoTrans.SubscribedSMS("Member No.", SourceType::"Loan Rejected") then begin
                            if Mem.Get("Member No.") then begin
                                SendSMS.SendSms(SourceType::"Loan Rejected", Mem."Mobile Phone No", 'Your ' + "Loan Product Type Name" + ' of KES ' + Format("Approved Amount") + ' ' +
                                'has been Rejected due to ' + LoanRejRes."Rejection Reason", "Loan No.", "Disbursement Account No", true, false);
                            end;
                        end; */


                    end;

                end;
            end;
        }
        field(52; "Loan Rejection Reason"; Code[50])
        {
            TableRelation = "Rejection Reason";
        }
        field(53; "Recommended Amount"; Decimal)
        {
        }
        field(54; "Responsibility Center"; Code[20])
        {
        }
        field(55; "Loan Account"; Code[20])
        {
            Editable = true;
        }
        field(56; "Loan Span"; Option)
        {
            OptionCaption = ' ,Short Term,Long Term';
            OptionMembers = " ","Short Term","Long Term";
        }
        field(57; "No. Series"; Code[20])
        {
        }
        field(58; "Outstanding Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER(Loan | Repayment),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Document No." = FIELD("Document No. Filter")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //GetPreviosRec(xRec."Outstanding Balance");
            end;
        }
        field(59; "Outstanding Interest"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER("Interest Due" | "Interest Paid"),
                                                                          "Posting Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Outstanding Bills"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER(Bills),
                                                                          "Posting Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "All Posting through Savings Ac"; Boolean)
        {
        }
        field(62; "Loan Principle Repayment"; Decimal)
        {
        }
        field(63; "Loan Interest Repayment"; Decimal)
        {
        }
        field(64; "Employer Code"; Code[20])
        {
            // TableRelation = Customer WHERE("Account Type" = CONST(Employer));
        }
        field(65; "Compute Interest Due on Postin"; Option)
        {
            OptionCaption = ' ,Full Interest,Pro-rata';
            OptionMembers = " ","Full Interest","Pro-rata";
        }
        field(66; "Discounted Loan No."; Code[20])
        {
        }
        field(67; "Discounted Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF xRec."Discounted Amount">0 THEN
                //  ERROR("DiscErr:" ,xRec."Discounted Amount");

                GenSetup.Get;
                TotalDisc := 0;
                NetAmt := 0;
                ProdFac.Reset;
                ProdFac.SetRange(ProdFac."Type of Discounting", ProdFac."Type of Discounting"::"Loan Discounting");
                if ProdFac.Find('-') then begin
                    LoanApp.Reset;
                    LoanApp.SetRange(LoanApp."Member No.", "Member No.");
                    LoanApp.SetRange(LoanApp."Loan Product Type", ProdFac."Product ID");
                    LoanApp.SetFilter(LoanApp."Outstanding Balance", '>0');
                    if LoanApp.Find('-') then begin
                        repeat
                            LoanApp.CalcFields("Outstanding Balance");
                            TotalDisc := TotalDisc + LoanApp."Outstanding Balance";
                        until LoanApp.Next = 0;
                    end;
                end;

                if GenSetup."Maximum Discounting %" <= 0 then
                    Error(Text016);
                // NetAmt := LoansProcess.ComputeCharges("Approved Amount", "Loan Product Type", "Loan No.", 0);
                //MESSAGE('Appr %1 Dis Amt %2 NetAmt %3 Total Disc %4',"Approved Amount","Discounted Amount",NetAmt,TotalDisc);
                if TotalDisc + "Discounted Amount" > NetAmt * GenSetup."Maximum Discounting %" * 0.01 then
                    Error(Text008, GenSetup."Maximum Discounting %");
            end;
        }
        field(68; "Share Boosted Amount"; Decimal)
        {
        }
        field(69; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(70; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(71; "Mode of Disbursement"; Option)
        {
            OptionCaption = ' ,Savings Account,Cheque/EFT';
            OptionMembers = " ","Savings Account","Cheque/EFT";

            trigger OnLookup()
            begin
                if "Mode of Disbursement" = "Mode of Disbursement"::"Savings Account" then
                    "All Posting through Savings Ac" := false;
            end;
        }
        field(72; "Already Suggested"; Boolean)
        {
        }
        field(73; "Responsibility Centre"; Code[20])
        {
            Description = 'LookUp to Responsibility Center BR';
            TableRelation = "Responsibility Center";
        }
        field(74; "Recovered Loan"; Code[20])
        {
            Description = 'To link loan recovered from Guarantors';
        }
        field(75; "Batch No."; Code[20])
        {
            TableRelation = "Loan Disbursement Header"."No." WHERE(Status = FILTER(Open),
                                                                    Posted = CONST(false));

            trigger OnValidate()
            begin
                IF ProdFac.GET("Loan Product Type") THEN BEGIN
                    IF ProdFac."Does not Require Batching" = TRUE THEN
                        ERROR(Text018);
                    if Status <> Status::Approved then
                        Error(Text017);
                END;
            end;
        }
        field(76; "Self Guarantee"; Boolean)
        {

            trigger OnValidate()

            begin

                if "Self Guarantee" = true then begin
                    LoanGuara.Reset;
                    LoanGuara.SetRange(LoanGuara."Loan No", "Loan No.");
                    if LoanGuara.Find('-') then begin
                        LoanGuara.DeleteAll;
                    end;

                    GenSetup.Get;


                    SavAcc.Reset;
                    SavAcc.SetRange(SavAcc."Member No.", "Member No.");
                    SavAcc.SetRange(SavAcc."Product Category", SavAcc."Product Category"::"Deposit Contribution");
                    if SavAcc.Find('-') then begin
                        SavAcc.CalcFields(SavAcc."Balance (LCY)");

                        LoanGuara.Init;
                        LoanGuara."Loan No" := "Loan No.";
                        LoanGuara.Validate("Loan No");
                        LoanGuara."Member No" := "Member No.";
                        LoanGuara."Savings Account No./Member No." := SavAcc."No.";
                        LoanGuara.Validate(LoanGuara."Savings Account No./Member No.");
                        LoanGuara.Validate(LoanGuara."Member No");
                        if LoanGuara."Amount Guaranteed" > "Requested Amount" then
                            LoanGuara."Amount Guaranteed" := "Requested Amount";
                        //LoanGuara."Available Guarantorship":=(LoanGuara."Available Guarantorship"*GenSetup."Self Guarantee %"*0.01);
                        LoanGuara.Insert(true);
                    end;
                end;
            end;
        }
        field(77; "Appraisal Fee"; Decimal)
        {
        }
        field(78; "Recovery Priority"; Integer)
        {
        }
        field(79; "Outstanding Loan Reg. Fee"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER("Loan Registration Fee"),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Document No." = FIELD("Document No. Filter")));
            Caption = 'Outstanding Registration Fee';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //GetPreviosRec(xRec."Outstanding Balance");
            end;
        }
        field(50001; "CRB Charge Run Times"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "CRB Charge Run Times" <= 0 then
                    "CRB Charge Run Times" := 1;
            end;
        }
        field(50004; "Relationship Manager"; Code[20])
        {
            TableRelation = "HR Employees" WHERE(Status = FILTER(Active));
        }
        field(50005; "Appraisal Parameter Type"; Option)
        {
            OptionCaption = 'Long Term,Salary,Corporate';
            OptionMembers = "Check Off",Salary,"Corporate or Business";
        }
        field(50006; "Employer Loan No."; Code[20])
        {
        }
        field(50007; "Loan Process Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Normal,Restructuring';
            OptionMembers = Normal,Restructuring;

            trigger OnValidate()
            begin
                TestField("Member No.");
                TestField("Loan Product Type");
                "Requested Amount" := 0;
                "Approved Amount" := 0;
                /*TopUp.Reset;
                TopUp.SetRange("Loan No.", Rec."Loan No.");
                TopUp.DeleteAll;*/
                if "Loan Process Type" = "Loan Process Type"::Restructuring then begin
                    Calcfields("Top Up Amount");
                    if "Top Up Amount" <= 0 then begin
                        LoanApp.Reset;
                        LoanApp.SetRange("Member No.", "Member No.");
                        LoanApp.SetFilter("Outstanding Balance", '>%1', 0);
                        //LoanApp.SetRange(LoanApp."Loan Product Type", "Loan Product Type");
                        if LoanApp.Find('-') then begin
                            repeat
                                LoanApp.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Penalty", "Top Up Amount");
                                if LoanApp."Outstanding Interest" < 0 then LoanApp."Outstanding Interest" := 0;
                                if LoanApp."Outstanding Penalty" < 0 then LoanApp."Outstanding Penalty" := 0;
                                NetAmt := 0;
                                //NetAmt := LoansProcess.ComputeChargesrgesRestructu((LoanApp."Outstanding Balance" + LoanApp."Outstanding Interest" + LoanApp."Outstanding Penalty"), Rec."Loan Product Type"/*LoanApp."Loan Product Type"*/, Rec."Loan No.", '');

                                //MESSAGE(FORMAT(NetAmt));
                                "Requested Amount" := NetAmt;


                                TopUp.Init;
                                TopUp."Loan No." := Rec."Loan No.";
                                TopUp."Client Code" := Rec."Member No.";
                                TopUp."Loan Top Up" := LoanApp."Loan No.";
                                TopUp."Loan Type" := LoanApp."Loan Product Type";
                                TopUp."Principle Top Up" := LoanApp."Outstanding Balance";
                                TopUp."Interest Top Up" := LoanApp."Outstanding Interest";
                                TopUp."Penalty Top UP" := LoanApp."Outstanding Penalty";
                                TopUp."Appraisal Top Up" := LoanApp."Outstanding Appraisal";
                                TopUp."Monthly Repayment" := LoansApp.Repayment;
                                TopUp."Interest Rate" := LoansApp.Interest;
                                TopUp."Outstanding Bill" := LoanApp."Outstanding Bills";
                                TopUp."Outstanding Balance" := LoansApp."Outstanding Balance";
                                TopUp."Loan Span" := LoansApp."Loan Span";
                                TopUp."Total Top Up" := LoanApp."Outstanding Balance" + LoanApp."Outstanding Interest" + LoanApp."Outstanding Penalty" + LoanApp."Outstanding Appraisal";
                                //TopUp.VALIDATE("Loan Top Up");
                                TopUp.Insert;
                            /*
                            LoanGuara.Reset;
                            LoanGuara.SetRange(LoanGuara."Loan No", LoanApp."Loan No.");
                            LoanGuara.SetRange("Guarantor Type", LoanGuara."Guarantor Type"::Collateral);
                            if LoanGuara.FindFirst then begin
                                repeat
                                    Guarantors.Init;
                                    // Guarantors."Loan No" := LoanGuara."Loan No";
                                    Guarantors."Loan No" := Rec."Loan No.";
                                    Guarantors."Member No" := LoanGuara."Member No";
                                    Guarantors."Savings Account No./Member No." := LoanGuara."Savings Account No./Member No.";
                                    Guarantors."Available Guarantorship" := LoanGuara."Available Guarantorship";
                                    Guarantors."Amount Guaranteed" := LoanGuara."Amount Guaranteed";
                                    Guarantors.Insert(true);
                                until LoanGuara.Next = 0;
                            end;*/


                            until LoanApp.Next = 0;
                        end;
                    end else begin
                        NetAmt := "Top Up Amount";
                        "Requested Amount" := "Top Up Amount";
                    end;


                    IF "Loan Product Type" = 'RLN' then
                        "Requested Amount" := "Requested Amount" / (1 - 0.00625);
                    if 0.00625 * "Requested Amount" > 6250 then
                        "Requested Amount" := NetAmt + 6250;
                    Validate("Requested Amount");
                end;
            end;
        }
        field(50008; Multiplier; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Restructure Charge Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Upfront,"Attach to loan";

            trigger OnValidate()
            begin
                Validate("Requested Amount");
            end;
        }
        field(50050; "Mobile Loan"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50051; "Source Defalter Loan"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50052; "Source Defalter Staff No"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50053; "Cell Group Code"; Code[20])
        {
            FieldClass = Normal;

            trigger OnValidate()
            var
                GuarLoan: Record Loans;
                Loan1: Record Loans;
            begin
                if "Loan Group" <> "Loan Group"::FOSA then begin
                    LoanGuara.Reset;
                    LoanGuara.SetRange(LoanGuara."Loan No", "Loan No.");
                    if LoanGuara.Find('-') then begin
                        LoanGuara.DeleteAll;
                    end;

                end;

                if "Loan No." <> '' then begin
                    //FOR COLLATERAL
                    Colla.Reset;
                    Colla.SetRange(Colla."Account No.", "Member No.");
                    Colla.SetRange(Colla.Status, Colla.Status::Approved);
                    Colla.SetRange(Colla."Inward/Outward", Colla."Inward/Outward"::"In-Store");
                    if Colla.Find('-') then begin
                        repeat
                            LoanGuara2.Reset;
                            LoanGuara2.SetRange("Savings Account No./Member No.", Colla."Account No.");
                            LoanGuara2.SetRange("Collateral Reg. No.", Colla."No.");
                            if not LoanGuara2.Find('-') then begin
                                LoanGuara.Init;
                                LoanGuara."Loan No" := "Loan No.";
                                LoanGuara."Guarantor Type" := LoanGuara."Guarantor Type"::Collateral;
                                LoanGuara."Member No" := "Member No.";
                                LoanGuara."Savings Account No./Member No." := "Member No.";
                                LoanGuara.Name := "Member Name";
                                LoanGuara."ID No." := "ID No.";
                                LoanGuara."Collateral Reg. No." := Colla."No.";
                                LoanGuara.Validate(LoanGuara."Savings Account No./Member No.");
                                LoanGuara.Validate(LoanGuara."Member No");
                                LoanGuara.Validate(LoanGuara."Collateral Reg. No.");
                                LoanGuara."Amount Guaranteed" := Colla."Collateral Limit";
                                LoanGuara.Insert(true);
                            end;
                        until Colla.Next = 0;
                    end;
                end;
            end;
        }
        field(39004241; "Bank Transfer Mode"; Code[20])
        {
            //TableRelation = "Bank Transfer Modes";
        }
        field(39004242; "Sales Agent"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(39004243; "Top Up Loan No."; Code[30])
        {
            TableRelation = Loans where("Member No." = field("Member No."), posted = const(true));
        }
        field(39004244; "Sent Online"; Boolean)
        {
        }
        field(39004245; "CRB Rating"; Integer)
        {
        }
        field(39004246; "Purpose of Loan"; Code[20])
        {
            // TableRelation = "Loan Purpose".Code;
        }
        field(39004247; "Loan Appraised By"; Code[50])
        {
        }
        field(39004248; "Loan Recovery No."; Code[20])
        {
        }
        field(39004249; "SMS Sent"; Boolean)
        {
        }
        field(39004250; "Available Credit Limit"; Decimal)
        {
        }
        field(39004251; "Loan Appl.form No."; Code[50])
        {
            Editable = false;
        }
        field(39004252; "CRM Application No."; Code[50])
        {
            TableRelation = "CRM Application"."No." WHERE("Application Type" = CONST("Loan Application"),
                                                           Created = CONST(false),
                                                           Case360_Docs = CONST(1),
                                                           "Approval Status" = FILTER(Open | Deffered));

            trigger OnValidate()
            begin
                LoansApp.Reset;
                LoansApp.SetRange(LoansApp."CRM Application No.", "CRM Application No.");
                //LoansApp.SETRANGE(LoansApp.Posted,FALSE);
                if LoansApp.Find('-') then begin
                    if "CRM Application No." <> '' then
                        Error(Err002, LoansApp."Loan No.");
                end;

                CRMLoanApplication.Reset;
                CRMLoanApplication.SetRange(CRMLoanApplication."No.", "CRM Application No.");
                if CRMLoanApplication.Find('-') then begin
                    "Loan Appl.form No." := CRMLoanApplication."Application Form No.";
                    "CRM Captured by" := CRMLoanApplication."Captured By";
                    //"CRM Date":=CRMLoanApplication.Date;
                    "CRM Captured Time" := CRMLoanApplication.Date;
                    "Member No." := CRMLoanApplication."Member No.";
                    "Requested Amount" := CRMLoanApplication."Requested Amount";
                    "Loan Product Type" := CRMLoanApplication."Product Factory";
                    Validate("Member No.");
                    Validate("Loan Product Type");
                end;
            end;
        }
        field(39004253; "CRM Captured by"; Code[100])
        {
            Editable = false;
        }
        field(39004254; "CRM Date"; Date)
        {
            Editable = false;
        }
        field(39004255; "CRM Created"; Boolean)
        {
            Editable = false;
        }
        field(39004256; "Comment for Exemptions"; Text[250])
        {
        }
        field(39004257; "Total Charges and Commissions"; Decimal)
        {
        }
        field(39004258; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(39004259; "Loans - Deposit Purchase"; Decimal)
        {
            Caption = '<Share Boosting- Purchase>';

        }
        field(39004260; "CRM Captured Time"; DateTime)
        {
        }
        field(39004261; "Member Segment"; Text[50])
        {
        }
        field(39004262; "Loan BDE"; Code[50])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = IF ("BDE Type" = FILTER(BDE)) "HR Employees"."No."
            ELSE
            "Salesperson/Purchaser".Code;
        }
        field(39004263; "Loan BDE Paid"; Boolean)
        {
        }
        field(39004264; "BDE Type"; Option)
        {
            OptionCaption = 'BDE,Others';
            OptionMembers = BDE,Others;
        }
        field(39004265; "Loan Group"; Option)
        {
            OptionCaption = ' ,BOSA,FOSA,MFI,BUSINESS';
            OptionMembers = " ",BOSA,FOSA,MFI,BUSINESS;
        }
        field(39004266; "Loan Category"; Code[20])
        {
            // TableRelation = "Credit Product Categories".Code;

            trigger OnValidate()
            begin

            end;
        }
        field(39004267; "Share Capital Loan"; Boolean)
        {
        }
        field(39004268; "Charge Upfront Interest"; Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Member No.");
                TestField("Loan Product Type");
                if "Charge Upfront Interest" = true then begin
                    Interest := 0
                end else begin
                    ProdFac.Get("Loan Product Type");
                    Interest := ProdFac."Interest Rate (Min.)";
                end;
            end;
        }
        field(39004269; "Form Serial No"; Code[20])
        {

            trigger OnValidate()
            begin
                Mem.Reset;
                Mem.SetRange("Form No.", "Form Serial No");
                if Mem.Find('-') then begin
                    "Member No." := Mem."No.";
                    Validate("Member No.");
                end;
            end;
        }
        field(39004270; "Group Code"; Code[20])
        {
            TableRelation = Members."No." WHERE("Group Account" = CONST(true));
        }
        field(39004271; "Old Interest Rate"; Decimal)
        {
        }
        field(39004272; "Society Code"; Code[20])
        {
        }
        field(39004273; "Dummy Appraisal"; Boolean)
        {
        }
        field(39004274; "ID No."; Code[40])
        {
        }
        field(39004275; "Customer CID"; Code[20])
        {
        }
        field(39004276; "Old Member No."; Code[20])
        {
        }
        field(39004277; "KRA PIN"; Code[20])
        {
        }
        field(39004278; "Main Guarantor ID"; Code[10])
        {
        }
        field(39004279; "Main Guarantor Name"; Text[100])
        {
        }
        field(39004280; "Main Guarantor Phone"; Text[15])
        {
        }
        field(39004281; "Main Guarator Sign"; Boolean)
        {
        }
        field(39004282; "Share Capital Boosting"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Share Capital Boosting" >= "Approved Amount" then
                    Error('This amount should be less than %1', "Approved Amount");
            end;
        }
        field(39004283; "No. Changed"; Boolean)
        {
        }
        field(39004284; "Minute Nos."; Code[20])
        {
        }
        field(39004285; "Deposit Boosting Option"; Option)
        {
            OptionMembers = " ","Normal Boosting","Boosting on Maximum";
        }
        field(39004286; "Entrance Fee"; Decimal)
        {
        }
        field(39004287; "Recommended By."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin

                "Recommended By Name." := '';
                if Emp.Get("Recommended By.") then begin
                    "Recommended By Name." := Emp."First Name" + ' ' + Emp."Last Name";
                end;
            end;
        }
        field(39004288; "Recommended By Name."; Text[150])
        {
        }
        field(39004289; "Destination Account"; Code[20])
        {
            Editable = false;
        }
        field(39004290; "Monthly Pre-Earned Interest"; Decimal)
        {
        }
        field(39004291; "Outstanding Penalty"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER("Penalty Due" | "Penalty Paid"),
                                                                          "Posting Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004292; "Outstanding Appraisal"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER("Appraisal Due" | "Appraisal Paid"),
                                                                          "Posting Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004293; "Outstanding Pre-Earned Int"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER("Pre-Earned Interest"),
                                                                          "Posting Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004294; "Interest Due on Disbursement"; Boolean)
        {
        }
        field(39004295; "Bill on Disursement"; Boolean)
        {
        }
        field(39004296; "Schedule Interest"; Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Monthly Interest" WHERE("Loan No." = FIELD("Loan No."),
                                                                                  "Repayment Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(39004297; "Schedule Principle Repayment"; Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Principal Repayment" WHERE("Loan No." = FIELD("Loan No."),
                                                                                     "Repayment Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(39004298; "Appraisal Fee Paid"; Decimal)
        {
            CalcFormula = - Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                           "Transaction Type" = FILTER("Appraisal Paid"),
                                                                           "Posting Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004299; "Recommended by Type"; Option)
        {
            OptionCaption = 'Member,Marketer,Office,Staff,Board Member';
            OptionMembers = Member,Marketer,Office,Staff,"Board Member";

            trigger OnValidate()
            begin
                "Recommended By" := '';
                "Recommended By Name" := '';
            end;
        }
        field(39004300; "Recommended By"; Code[20])
        {
            TableRelation = IF ("Recommended by Type" = FILTER(Marketer)) "Salesperson/Purchaser".Code
            ELSE
            IF ("Recommended by Type" = FILTER(Staff)) "HR Employees"
            ELSE
            IF ("Recommended by Type" = FILTER("Board Member")) Members WHERE("Account Category" = FILTER("Board Members"))
            ELSE
            IF ("Recommended by Type" = FILTER(Member)) Members WHERE("Account Category" = FILTER(Member));

            trigger OnValidate()
            begin
                if "Recommended by Type" = "Recommended by Type"::Marketer then begin
                    SalespersonPurchaser.Reset;
                    SalespersonPurchaser.SetRange(Code, "Recommended By");
                    if SalespersonPurchaser.Find('-') then begin
                        "Recommended By Name" := SalespersonPurchaser.Name;
                    end;
                end else
                    if "Recommended by Type" = "Recommended by Type"::"Board Member" then begin
                        Members.Reset;
                        Members.SetRange("No.", "Recommended By");
                        if Members.Find('-') then begin
                            "Recommended By Name" := Members.Name;
                        end;
                    end else
                        if "Recommended by Type" = "Recommended by Type"::Staff then begin
                            HREmployees.Reset;
                            HREmployees.SetRange("No.", "Recommended By");
                            if HREmployees.Find('-') then begin
                                "Recommended By Name" := HREmployees."Full Name";
                            end;
                        end else
                            if "Recommended by Type" = "Recommended by Type"::Member then begin
                                Members.Reset;
                                Members.SetRange("No.", "Recommended By");
                                if Members.Find('-') then begin
                                    "Recommended By Name" := Members.Name;
                                end;
                            end else begin
                                //  HREmployees.RESET;
                                //  HREmployees.SETRANGE("No.","Recruited By");
                                //  IF HREmployees.FIND('-') THEN
                                //    BEGIN
                                "Recommended By Name" := "Recommended By";
                                // END;
                            end;
            end;
        }
        field(39004301; "Recommended By Name"; Text[100])
        {
            Editable = false;
        }
        field(39004302; "Monthly Interest"; Decimal)
        {
        }
        field(39004303; "Interest Paid"; Decimal)
        {
            CalcFormula = - Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                           "Transaction Type" = FILTER("Interest Paid"),
                                                                           "Posting Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004304; "Date of Affidavit"; Date)
        {
        }
        field(39004305; "No. of Meetings"; Integer)
        {
        }
        field(39004306; "Last Principal Pay Date"; Date)
        {
            CalcFormula = Max("Credit Ledger Entry"."Posting Date" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER(Repayment),
                                                                          "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(39004307; "Current Repayments"; Decimal)
        {
            CalcFormula = - Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                           "Transaction Type" = FILTER(Repayment),
                                                                           "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(39004308; "Schedule Appraisal"; Decimal)
        {
            CalcFormula = Sum("Loan Repayment Schedule"."Appraisal Fee" WHERE("Loan No." = FIELD("Loan No."),
                                                                               "Repayment Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(39004309; "Last Interest Pay Date"; Date)
        {
            CalcFormula = Max("Credit Ledger Entry"."Posting Date" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER("Interest Paid"),
                                                                          "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(39004310; "Expected Loan Reg. Fee"; Decimal)
        {
            Caption = 'Expected Registration Fee';
        }
        field(39004311; Insurance; Decimal)
        {
        }
        field(39004312; "Total Guaranteed"; Decimal)
        {
            CalcFormula = Sum("Loan Guarantors and Security"."Amount Guaranteed" WHERE("Member No" = FIELD("Member No."),
                                                                                        Substituted = CONST(false)));
            FieldClass = FlowField;
        }
        field(39004313; "Total Outstanding Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER(Loan | Repayment | "Interest Due" | "Interest Paid" | "Appraisal Due" | "Appraisal Paid" | "Penalty Due" | "Penalty Paid" | "Loan Registration Fee" | "Suspended Interest Due" | "Suspended Interest Paid"),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Document No." = FIELD("Document No. Filter")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //GetPreviosRec(xRec."Outstanding Balance");
            end;
        }
        field(39004314; "Loan Calculator"; Boolean)
        {
        }
        field(39004315; "Non-Active Guarantor Allowed"; Boolean)
        {
        }
        field(39004316; "Schedule Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Schedule Start Date" < "Repayment Start Date" then
                    Error('Schedule Start Date cannot be less than repayment start date');

                if "Repayment Frequency" = "Repayment Frequency"::Monthly then begin
                    if "Schedule Start Date" > CalcDate('1M+CM', "Disbursement Date") then
                        Error('Start Date cannot be greater than %1', CalcDate('1M+CM', "Disbursement Date"));
                end;
            end;
        }
        field(39004317; "Allow Defaulter Loanee"; Boolean)
        {
        }
        field(39004318; "Recovered from Savings"; Boolean)
        {
        }
        field(39004319; "Recovered from Guarantors"; Boolean)
        {
        }
        field(39004320; "Interest Due"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER("Interest Due"),
                                                                          "Posting Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004321; "Allow 2 Business Loans"; Boolean)
        {
        }
        field(39004322; "Varied Loans Category-SASRA"; Option)
        {
            CalcFormula = Lookup("SASRA Categorization Manual"."Loans Category-SASRA" WHERE("Loan No." = FIELD("Loan No.")));
            FieldClass = FlowField;
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = Perfoming,Watch,Substandard,Doubtful,Loss;
        }
        field(39004323; "Stubborn Unflagged"; Boolean)
        {
        }
        field(39004324; "Guar. Exemption Date"; Date)
        {
        }
        field(39004325; "Special Account"; Boolean)
        {
            CalcFormula = Lookup(Members."Special Member" WHERE("No." = FIELD("Member No.")));
            FieldClass = FlowField;
        }
        field(39004326; "Plot Allotment"; Code[20])
        {
            /*TableRelation = "Plot Allotment".Allotment WHERE(Issued = FILTER(false),
                                                              "Plot Code" = FIELD("Loan Product Type"));*/

            trigger OnValidate()
            begin

                if "Plot Allotment" <> '' then begin

                    ProdFac.Get("Loan Product Type");
                    if ProdFac."Nature of Loan Type" <> ProdFac."Nature of Loan Type"::"Property Sale" then
                        Error('Only applicable to Investment Product');

                    LoansApp.Reset;
                    LoansApp.SetRange("Plot Allotment", "Plot Allotment");
                    LoansApp.SetRange("Loan Product Type", "Loan Product Type");
                    LoansApp.SetFilter("Loan No.", '<>%1', "Loan No.");
                    if LoansApp.FindFirst then
                        Error('This Plot (%1) has already been linked to Plot No. %2', LoansApp."Plot Allotment", LoansApp."Loan No.");

                end;
            end;
        }
        field(39004327; "Send Repayment Schedule"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004328; "Cumulative Present Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 3 : 3;
        }
        field(39004329; "External Clearance Pending"; Integer)
        {
            CalcFormula = Count("Other Commitements Clearance" WHERE("PV Posted" = CONST(false),
                                                                      "Loan No." = FIELD("Loan No."),
                                                                      Type = FILTER("External Loan Clearance" | "External Payment to Vendor")));
            FieldClass = FlowField;
        }
        field(39004330; "Msacco Penalty Charged"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004331; "Msacco SMS Alerts"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Seven Days Prior,Two days Prior,One day Overdue,Two days Overdue,Three Days Overdue,Seven Days Prior (II),Two days Prior (II),One day Overdue (II),Two days Overdue (II),Three Days Overdue (II)';
            OptionMembers = " ","Seven Days Prior","Two days Prior","One day Overdue","Two days Overdue","Three Days Overdue","Seven Days Prior (II)","Two days Prior (II)","One day Overdue (II)","Two days Overdue (II)","Three Days Overdue (II)";
        }
        field(39004332; "Loan Due Alert Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004333; "7 Days Alert Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004334; "Defaulter Loan No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(39004335; "Appraised By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(39004336; "Old Last Pay Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004337; "Partial Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(39004338; "Net Disbursed"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(39004339; "Outstanding Partial"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Loan No" = FIELD("Loan No."),
                                                                          "Transaction Type" = FILTER("Partial Disbursement"),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Document No." = FIELD("Document No. Filter")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //GetPreviosRec(xRec."Outstanding Balance");
            end;
        }
        field(39004340; "Last Contribution and Date"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(39004341; "Phone No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(39004342; "Picked Mobile Loan"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004343; "Main Sector"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "SASRA Main Sector."."Main Code";
        }
        field(39004344; "Sub Sector Level 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "SASRA Sub Sector I."."Sub Code" WHERE("Main Code" = FIELD("Main Sector"));
        }
        field(39004345; "Sub Sector Level 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sectoral Classification."."Sub Sector Level2";
            // TableRelation = "SASRA Sub Sector II."."Pre Code" WHERE("Main Code" = FIELD("Main Sector"),
            //"Sub Code" = FIELD("Sub Sector Level 1"));

            trigger OnValidate()
            var
                SectoralClassification: Record "Sectoral Classification.";


            begin
                SectoralClassification.RESET;
                SectoralClassification.SETRANGE("Sub Sector Level2", "Sub Sector Level 2");
                IF SectoralClassification.FIND('-') THEN BEGIN
                    "Main Sector" := SectoralClassification."Main Sector";
                    //"Main Sector Description" := SectoralClassification."Main Sector Description";
                    "Sub Sector Level 1" := SectoralClassification."Sub Sector Level1";
                    //"Sub Sector Level1 Description" := SectoralClassification."Sub Sector Level1 Description";
                    // "Sub Sector Level2 Description" := SectoralClassification."Sub Sector Level2 Description";

                END ELSE BEGIN
                    "Main Sector" := '';
                    "Main Sector Description" := '';
                    "Sub Sector Level 1" := '';
                    "Sub Sector Level1 Description" := '';
                    "Sub Sector Level2 Description" := '';
                END;

            end;
        }
        field(39004346; "Main Sector Description"; Text[140])
        {
            DataClassification = ToBeClassified;
        }
        field(39004347; "Sub Sector Level1 Description"; Text[140])
        {
            DataClassification = ToBeClassified;
        }
        field(39004348; "Sub Sector Level2 Description"; Text[140])
        {
            DataClassification = ToBeClassified;
        }
        field(39004349; "Cheque No."; Code[36])
        {
            DataClassification = ToBeClassified;
        }
        field(39004350; "Cheque Charge"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004351; "Suspend Interest"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004352; "Suspend Penalty"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004353; "Loan Balance As At"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(39004354; "Mode Of Application"; Option)
        {
            OptionMembers = Mobile,Physical,"Internet Banking";
            DataClassification = ToBeClassified;
        }
        field(39004355; "ReInstated Deposits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(39004356; "Top Up Amount"; Decimal)
        {
            fieldclass = Flowfield;
            CalcFormula = sum("Loans Top Up"."Total Top Up" where("Loan No." = field("Loan No.")));

        }
        field(39004357; "Interest Suspended"; Decimal)
        {
            fieldclass = Flowfield;
            Calcformula = Sum("Credit Ledger Entry".Amount where("Loan No" = field("Loan No."), "Transaction Type" = filter("Suspended Interest Due" | "Suspended Interest Paid")));
            //CalcFormula = sum("Suspended Interest Accounts"."Interest Amount" where("Loan No." = field("Loan No.")));

        }
        field(39004358; "Debt Collector"; Code[50])
        {

        }






    }

    keys
    {
        key(Key1; "Loan No.")
        {
        }

        key(Key3; "Disbursement Date")
        {
        }
        key(Key4; "Expected Date of Completion")
        {
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "Loan No.", "Loan Product Type", "Outstanding Balance", "Outstanding Interest", "Outstanding Penalty", "Outstanding Loan Reg. Fee")
        {
        }
    }

    trigger OnDelete()
    begin
        if Status = Status::Approved then
            Error('A loan cannot be deleted once it has been approved');
    end;

    /* trigger OnInsert()
     var
         StandardDialog: Page "Loan Standard Dialog";
         DialogType: Option DebtCollectorr,LoanApp;
         LoanType: Option FOSA,BOSA;
     begin
         UserSetup.Get(UserId);

         if "Loan No." = '' then begin

             MembNoSeries.Get;
             StandardDialog.SetDialogType(DialogType::LoanApp);
             if StandardDialog.RunModal() = Action::OK then begin
                 LoanType := StandardDialog.GetLoanType();
                 CASE LoanType of
                     LoanType::BOSA:
                         begin
                             MembNoSeries.TestField(MembNoSeries."Bosa Loan Nos.");
                             NoSeriesMgt.InitSeries(MembNoSeries."Bosa Loan Nos.", xRec."No. Series", 0D, "Loan No.", "No. Series");
                             "Global Dimension 1 Code" := 'BOSA';
                             "Loan Group" := "Loan Group"::BOSA;
                         end;
                     LoanType::FOSA:
                         begin
                             MembNoSeries.TestField(MembNoSeries."Loan Nos.");
                             NoSeriesMgt.InitSeries(MembNoSeries."Loan Nos.", xRec."No. Series", 0D, "Loan No.", "No. Series");
                             "Global Dimension 1 Code" := 'FOSA';
                             "Loan Group" := "Loan Group"::FOSA;
                         end;
                 END;
             end else begin
                 Error('Please specify loan application type BOSA/FOSA');

             end;

         end;
         //end;

         "Application Date" := Today;

         Advice := true;
         "All Posting through Savings Ac" := true;

         "Captured By" := UpperCase(UserId);
         "CRB Charge Run Times" := 1;

         if UserSetup.Get(UpperCase(UserId)) then begin
             // "Global Dimension 1 Code":=UserSetup."Global Dimension 1 Code";
             // "Global Dimension 2 Code":=UserSetup."Global Dimension 2 Code";
             "Responsibility Centre" := UserSetup."Responsibility Centre";
         end;
     end; */

    trigger OnModify()
    begin
        // IF ("Discounted Amount"=xRec."Discounted Amount") AND ("Batch No."=xRec."Batch No.")THEN BEGIN
        if Posted then begin
            StatusChangePermissions.Reset;
            StatusChangePermissions.SetRange("User ID", UserId);
            StatusChangePermissions.SetRange("Update Loan Recommended By", true);
            if not StatusChangePermissions.FindFirst then
                Error('A loan cannot be modified once it has been posted');
        end;

        //
        //IF (Status=Status::Approved) OR (Status=Status::Appraisal) THEN
        //     ERROR('Loan is not open for modification');
        //
    end;

    trigger OnRename()
    begin
        if Status = Status::Approved then
            Error('A loan cannot be renamed once it has been approved');
    end;

    var
        RejectionReason: Record "Rejection Reason";
        MembNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ProdFac: Record "Product Factory";
        SavAcc: Record "Savings Accounts";
        ShareCapAcc: Record "Savings Accounts";
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
        // DCSUpdate: Codeunit "DCS Management";
        //CheckoffAdvice: Codeunit "Periodic Activities";
        ErrLoanCount: Label 'The requested loan exceeds amount allowable';
        "DiscErr:": Label 'Loan is already discounted by %1';
        ShareBoostComm: Decimal;
        "Shares Boosted": Boolean;
        DimMgt: Codeunit DimensionManagement;
        "InactiveErr:": Label 'This member account is not active';
        LoanAmountErr: Label 'The loan applied is not within allowed margins Max Loan %1 and Max Loan %2 for product %3. Requested amount is %4';
        InstallmentsErr: Label 'Number of installments must be greater than Zero.';
        DateErr: Label 'The date is invalid. It should not be in the past';
        DisbErr: Label 'The amount to disburse cannot be greater than or equal to approved amount';
        ApprovedAmtErr: Label 'The approved amount cannot be greater than requested amount';
        AmountToDisb: Label 'Amount to disburse cannot be greater than approved amount';
        Text002: Label 'Amount to disburse must be equal to amount approved';
        CreditLedger: Record "Credit Ledger Entry";
        Text004: Label 'This member has a loan in arrears %1';
        ClientAge: Text;
        //HRDates: Codeunit "HR Dates";
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
        // ProdReq: Record "Product Checklist";
        // LoanReq: Record "Loan Mandatory Requirements";
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
        LoanHistory: Record "Loan History";
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
        // LoansProcess: Codeunit "Loans Process";
        //"Max": Record "Maximum Application Amount";
        //QualifyingBands: Record "Loan Qualification Bands";
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
        // SendSMS: Codeunit SendSms;
        SourceType: Option "New Member","New Account","Loan Account Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit"," Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes";
        LoansApp: Record Loans;
        CRMLoanApplication: Record "CRM Application";
        Err002: Label 'CRM application is already in use by Loan No. %1';
        AmortisedInt: Decimal;
        //LoanProcess: Codeunit "Loans Process";
        TotalLoans: Decimal;
        CreditProductCategories: Record "Credit Product Categories";
        ProductRecoveryModes: Record "Product Recovery Modes";
        LoanRecoveryModes: Record "Loan Recovery Modes";
        Text018: Label 'This product does not require batching';
        Text019: Label 'This member does not have sufficient share capital: %1 Expected minimum is %2 ';
        Unpaid: Text;
        LArrears: Text;
        DisbProducts: Record "Product Factory";
        // Reg: Codeunit "Registration Process";
        Emp: Record Employee;
        RSchedule: Record "Loan Repayment Schedule";
        BonusDate: Date;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Members: Record Members;
        HREmployees: Record "HR Employees";
        //Appraisal: Record "Loan Appraisal Buffer";
        TariffDetails: Record "Tiered Charges Lines";
        Cust: Record Members;
        // SaccoTrans: Codeunit "Sacco Transactions";
        MicroDef: Text;
        StatusChangePermissions: Record "Status Change Permissions";
        TopUp: Record "Loans Top up";
        PartialDisbursementSchedule: Record "Partial Disbursement Schedule";
        LoanWitness: Record "Loan Witness";
        //ScheduleofProperties: Record "Schedule of Properties";
        //CurrentLoanCharges: Record "Current Loan Charges";
        OtherCommitementsClearance: Record "Other Commitements Clearance";
        DepProduct: Record "Product Factory";
        //Mutliplier: Record "Deposit Multiplier Banding";
        SDate: Date;
        EDate: Date;
        DefaultDF: DateFormula;
        CheckDate: Date;
        //DepositBands: Record "Deposit Contribution Bands";
        DepAcc: Record "Savings Accounts";
        //MCont: Record "Appraisal Monthly Contribution";
        LastAmt: Decimal;
        //InterestRatesPerPeriod: Record "Interest Rates Per Period";
        MinimumAgeError: Label 'Member must has been active for the last %1';
        //LastPay: Record "Last Pay Dates";
        QualifiedAmnt: Decimal;
        lastcont: Label 'Member last Contribution is %1 done on Date %2';
        Text0018: Label 'This member has  defaulted %1';
        Text003: Label 'This member has a loan which has not be repaid %1';
        Ldefaulted: Text;
        Text020: Label 'This member has defaulted %1';
        LoanTerms: Record "Loan Terms";
        QualifyingBands: Record "Loan Qualification Bands";
        //Cellmember: Record "Cell Group Members";
        Err009: Label 'You cannot apply more than allowed limit';
        "Max": Record "Maximum Application Amount";
        Guarantors: Record "Loan Guarantors and Security";
        GuarLoan: Record Loans;
        Colla: Record "Securities Register";
        DepCollateral: Record "Deposit Collateral Ratio";
        LoanGuara2: Record "Loan Guarantors and Security";
        // SectoralClassification: Record "Sectoral Classification";
        LoanGuara22: Record "Loan Guarantors and Security";

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Loans, "Loan No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    local procedure AvailableCreditLimit()
    begin
        "Amount To Disburse" := xRec."Amount To Disburse";
    end;



    /// <summary>
    /// UpdatePeriodicIncome.
    /// </summary>
    /// <summary>
    /// UpdatePeriodicIncome.
    /// </summary>
    procedure UpdatePeriodicIncome()
    var
        PIncome: Record "Periodic Income Entries";
        CProduct: Record "Product Factory";
        SProduct: Record "Product Factory";
        Savings: Record "Savings Accounts";
        Salary: Record "PR Employee Transactions";
        ENo: Integer;
        SalLines: Record "Salary Lines";
        Bonus: Record "Bonus Payment History";
        SalHeader: Record "Salary Header";
        JuniorSav: Record "Savings Accounts";
        JuniorBalance: Decimal;
        SLedger: Record "Savings Ledger Entry";
    begin

        PIncome.Reset;
        PIncome.SetRange("Loan No.", "Loan No.");
        if PIncome.FindFirst then
            PIncome.DeleteAll;


        CProduct.Get("Loan Product Type");
        if CProduct."Member Class" <> 'CLASS C' then
            if CProduct."Type of Discounting" <> CProduct."Type of Discounting"::"Loan Discounting" then
                if CProduct."Appraisal Parameter Type" = CProduct."Appraisal Parameter Type"::" " then
                    Error('Appraisal Parameter Type Must Have a value for this product');

        if "Mode of Disbursement" = "Mode of Disbursement"::"Savings Account" then
            Savings.Get("Disbursement Account No");

        case CProduct."Appraisal Parameter Type" of


            CProduct."Appraisal Parameter Type"::Bonus:
                begin
                    SProduct.Reset; //MESSAGE('T1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        if Savings."Product Type" = SProduct."Product ID" then begin








                            Bonus.RESET;
                            Bonus.SETRANGE("Account No.", "Disbursement Account No");
                            Bonus.SETRANGE(Date, CALCDATE('-CY', CProduct."Bonus Appraisal Start Date"), CALCDATE('+CY', CProduct."Bonus Appraisal Start Date"));
                            IF Bonus.FIND('-') THEN BEGIN
                                ENo := 0;
                                REPEAT
                                    PIncome.RESET;
                                    PIncome.SETRANGE("Loan No.", "Loan No.");
                                    ENo := PIncome.COUNT;


                                    IF (Bonus.Date > CALCDATE('-3Y-CY', "Application Date")) AND ((Bonus.Date < CALCDATE('-3Y+CY', "Application Date"))) THEN BEGIN
                                        PIncome.RESET;
                                        PIncome.SETRANGE(Date, CALCDATE('-3Y-CY', "Application Date"), CALCDATE('-3Y+CY', "Application Date"));
                                        PIncome.SETRANGE("Loan No.", "Loan No.");
                                        IF PIncome.FINDFIRST THEN BEGIN
                                            PIncome.Amount += Bonus."Bonus Amount";
                                            PIncome.Date := Bonus.Date;
                                            PIncome.MODIFY;
                                        END
                                        ELSE BEGIN
                                            ENo += 1;
                                            PIncome.INIT;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := Bonus.Date;
                                            PIncome.Description := 'Bonus';
                                            PIncome.Amount := Bonus."Bonus Amount";
                                            PIncome."Entry No." := ENo;
                                            PIncome.INSERT;

                                        END;
                                    END;
                                    IF (Bonus.Date > CALCDATE('-2Y-CY', "Application Date")) AND ((Bonus.Date < CALCDATE('-2Y+CY', "Application Date"))) THEN BEGIN
                                        PIncome.RESET;
                                        PIncome.SETRANGE(Date, CALCDATE('-2Y-CY', "Application Date"), CALCDATE('-2Y+CY', "Application Date"));
                                        PIncome.SETRANGE("Loan No.", "Loan No.");
                                        IF PIncome.FINDFIRST THEN BEGIN
                                            PIncome.Amount += Bonus."Bonus Amount";
                                            PIncome.Date := Bonus.Date;
                                            PIncome.MODIFY;
                                        END
                                        ELSE BEGIN
                                            ENo += 1;
                                            PIncome.INIT;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := Bonus.Date;
                                            PIncome.Description := 'Bonus';
                                            PIncome.Amount := Bonus."Bonus Amount";
                                            PIncome."Entry No." := ENo;
                                            PIncome.INSERT;

                                        END;
                                    END;
                                    IF (Bonus.Date > CALCDATE('-1Y-CY', "Application Date")) AND ((Bonus.Date < CALCDATE('-1Y+CY', "Application Date"))) THEN BEGIN
                                        PIncome.RESET;
                                        PIncome.SETRANGE(Date, CALCDATE('-1Y-CY', "Application Date"), CALCDATE('-1Y+CY', "Application Date"));
                                        PIncome.SETRANGE("Loan No.", "Loan No.");
                                        IF PIncome.FINDFIRST THEN BEGIN
                                            PIncome.Amount += Bonus."Bonus Amount";
                                            PIncome.Date := Bonus.Date;
                                            PIncome.MODIFY;
                                        END
                                        ELSE BEGIN
                                            ENo += 1;
                                            PIncome.INIT;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := Bonus.Date;
                                            PIncome.Description := 'Bonus';
                                            PIncome.Amount := Bonus."Bonus Amount";
                                            PIncome."Entry No." := ENo;
                                            PIncome.INSERT;

                                        END;
                                    END;
                                UNTIL Bonus.NEXT = 0;
                            END;


                        end;
                    end;
                end;


            CProduct."Appraisal Parameter Type"::Tea:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        if Savings."Product Type" = SProduct."Product ID" then begin

                            SalLines.Reset;
                            SalLines.SetRange("Posting Date", CalcDate('-3M-CM', "Application Date"), "Application Date");
                            SalLines.SetRange(Posted, true);
                            SalLines.SetRange("Account No.", "Disbursement Account No");
                            if SalLines.Find('-') then begin
                                ENo := 0;
                                repeat



                                    PIncome.Reset;
                                    PIncome.SetRange("Loan No.", "Loan No.");
                                    ENo := PIncome.Count;

                                    SalHeader.Reset;
                                    SalHeader.SetRange(No, SalLines."Salary Header No.");
                                    SalHeader.SetRange(Posted, true);
                                    SalHeader.SetRange("Posting date", CalcDate('-3M-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                    SalHeader.SetRange("Income Type", SalHeader."Income Type"::Tea);
                                    if SalHeader.Find('-') then begin

                                        if (SalHeader."Posting date" >= CalcDate('-3M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-3M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-3M-CM', "Application Date"), CalcDate('-3M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-2M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-2M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-2M-CM', "Application Date"), CalcDate('-2M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-1M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-1M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-1M-CM', "Application Date"), CalcDate('-1M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                    end;

                                until SalLines.Next = 0;
                            end;
                        end;
                    end;
                end;



            CProduct."Appraisal Parameter Type"::Milk:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Milk);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');
                            SalLines.Reset;
                            SalLines.SetRange("Posting Date", CalcDate('-3M-CM', "Application Date"), "Application Date");
                            SalLines.SetRange(Posted, true);
                            SalLines.SetRange("Account No.", "Disbursement Account No");
                            if SalLines.Find('-') then begin
                                ENo := 0;
                                repeat


                                    //MESSAGE('T2');
                                    PIncome.Reset;
                                    PIncome.SetRange("Loan No.", "Loan No.");
                                    ENo := PIncome.Count;

                                    SalHeader.Reset;
                                    SalHeader.SetRange(No, SalLines."Salary Header No.");
                                    SalHeader.SetRange(Posted, true);
                                    SalHeader.SetRange("Posting date", CalcDate('-3M-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                    SalHeader.SetRange("Income Type", SalHeader."Income Type"::Milk);
                                    if SalHeader.Find('-') then begin
                                        //MESSAGE('T3');
                                        if (SalHeader."Posting date" >= CalcDate('-3M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-3M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-3M-CM', "Application Date"), CalcDate('-3M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-2M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-2M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-2M-CM', "Application Date"), CalcDate('-2M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-1M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-1M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-1M-CM', "Application Date"), CalcDate('-1M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                    end;

                                until SalLines.Next = 0;
                            end;
                        end;
                    end;
                end;


            CProduct."Appraisal Parameter Type"::Salary:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Salary);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');
                            SalLines.Reset;
                            SalLines.SetRange("Posting Date", CalcDate('-3M-CM', "Application Date"), "Application Date");
                            SalLines.SetRange(Posted, true);
                            SalLines.SetRange("Account No.", "Disbursement Account No");
                            if SalLines.Find('-') then begin
                                ENo := 0;
                                repeat


                                    //MESSAGE('T2');
                                    PIncome.Reset;
                                    PIncome.SetRange("Loan No.", "Loan No.");
                                    ENo := PIncome.Count;

                                    SalHeader.Reset;
                                    SalHeader.SetRange(No, SalLines."Salary Header No.");
                                    SalHeader.SetRange(Posted, true);
                                    SalHeader.SetRange("Posting date", CalcDate('-3M-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                    SalHeader.SetRange("Income Type", SalHeader."Income Type"::Salary);
                                    if SalHeader.Find('-') then begin
                                        //MESSAGE('T3');
                                        if (SalHeader."Posting date" >= CalcDate('-3M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-3M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-3M-CM', "Application Date"), CalcDate('-3M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-2M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-2M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-2M-CM', "Application Date"), CalcDate('-2M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-1M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-1M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-1M-CM', "Application Date"), CalcDate('-1M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                    end;

                                until SalLines.Next = 0;
                            end;
                        end;
                    end;
                end;






            CProduct."Appraisal Parameter Type"::"Staff Salary":
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::"Staff Salary");
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');


                        end;
                    end;
                end;




            CProduct."Appraisal Parameter Type"::KGs:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');

                        end;
                    end;
                end;





            CProduct."Appraisal Parameter Type"::Junior:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');
                            JuniorBalance := 0;
                            JuniorSav.Reset;
                            JuniorSav.SetRange("Member No.", "Member No.");
                            JuniorSav.SetRange("Product Category", JuniorSav."Product Category"::"Junior Savings");
                            JuniorSav.SetFilter("Balance (LCY)", '>0');
                            if JuniorSav.Find('-') then begin
                                repeat

                                    JuniorSav.CalcFields("Balance (LCY)");
                                    JuniorBalance += JuniorSav."Balance (LCY)";

                                    ENo += 1;
                                    PIncome.Init;
                                    PIncome."Loan No." := "Loan No.";
                                    PIncome."Member No." := "Member No.";
                                    PIncome.Name := "Member Name";
                                    PIncome.Date := Today;
                                    PIncome.Description := 'Junior Savings - ' + JuniorSav."No.";
                                    PIncome.Amount := JuniorSav."Balance (LCY)";
                                    PIncome."Entry No." := ENo;
                                    PIncome.Insert;

                                until JuniorSav.Next = 0;

                            end;



                        end;
                    end;
                end;




            CProduct."Appraisal Parameter Type"::Credits:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Business);
                    //SProduct.SETRANGE("Product ID",CProduct."Disbursement Product");
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        if (Savings."Product Type" = SProduct."Product ID") or (Savings."Product Type" <> '') then begin


                            SLedger.Reset;
                            SLedger.SetRange("Customer No.", "Disbursement Account No");
                            SLedger.SetRange("Loan Disbursement", false);
                            SLedger.SetRange("Posting Date", CalcDate('-3M-CM', "Application Date"), CalcDate('CM', "Application Date"));
                            SLedger.SetFilter(Amount, '<0');
                            if SLedger.Find('-') then begin
                                ENo := 0;
                                if CProduct."Appraisal No. of Credits" > 0 then begin
                                    if SLedger.Count <= CProduct."Appraisal No. of Credits" then
                                        Error('Credit Transactions are Less the required limit of %1', CProduct."Appraisal No. of Credits");
                                end;
                                repeat
                                    PIncome.Reset;
                                    PIncome.SetRange("Loan No.", "Loan No.");
                                    ENo := PIncome.Count;


                                    if (SLedger."Posting Date" >= CalcDate('-3M-CM', "Application Date")) and ((SLedger."Posting Date" <= CalcDate('-3M+CM', "Application Date"))) then begin
                                        PIncome.Reset;
                                        PIncome.SetRange(Date, CalcDate('-3M-CM', "Application Date"), CalcDate('-3M+CM', "Application Date"));
                                        PIncome.SetRange("Loan No.", "Loan No.");
                                        if PIncome.FindFirst then begin
                                            PIncome.Amount += (SLedger.Amount * -1);
                                            if PIncome.Amount < 0 then
                                                PIncome.Amount := 0;
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Modify;
                                        end
                                        else begin
                                            ENo += 1;
                                            PIncome.Init;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Description := SLedger.Description;
                                            PIncome.Amount := (SLedger.Amount * -1);
                                            PIncome."Entry No." := ENo;
                                            PIncome.Insert;

                                        end;
                                    end;
                                    if (SLedger."Posting Date" >= CalcDate('-2M-CM', "Application Date")) and ((SLedger."Posting Date" <= CalcDate('-2M+CM', "Application Date"))) then begin
                                        PIncome.Reset;
                                        PIncome.SetRange(Date, CalcDate('-2M-CM', "Application Date"), CalcDate('-2M+CM', "Application Date"));
                                        PIncome.SetRange("Loan No.", "Loan No.");
                                        if PIncome.FindFirst then begin
                                            PIncome.Amount += (SLedger.Amount * -1);
                                            if PIncome.Amount < 0 then
                                                PIncome.Amount := 0;
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Modify;
                                        end
                                        else begin
                                            ENo += 1;
                                            PIncome.Init;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Description := SLedger.Description;
                                            PIncome.Amount := (SLedger.Amount * -1);
                                            PIncome."Entry No." := ENo;
                                            PIncome.Insert;

                                        end;
                                    end;
                                    if (SLedger."Posting Date" >= CalcDate('-1M-CM', "Application Date")) and ((SLedger."Posting Date" <= CalcDate('-1M+CM', "Application Date"))) then begin
                                        PIncome.Reset;
                                        PIncome.SetRange(Date, CalcDate('-1M-CM', "Application Date"), CalcDate('-1M+CM', "Application Date"));
                                        PIncome.SetRange("Loan No.", "Loan No.");
                                        if PIncome.FindFirst then begin
                                            PIncome.Amount += (SLedger.Amount * -1);
                                            if PIncome.Amount < 0 then
                                                PIncome.Amount := 0;
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Modify;
                                        end
                                        else begin
                                            ENo += 1;
                                            PIncome.Init;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Description := SLedger.Description;
                                            PIncome.Amount := (SLedger.Amount * -1);
                                            PIncome."Entry No." := ENo;
                                            PIncome.Insert;

                                        end;
                                    end;
                                    if (SLedger."Posting Date" >= CalcDate('-CM', "Application Date")) and ((SLedger."Posting Date" <= CalcDate('CM', "Application Date"))) then begin
                                        PIncome.Reset;
                                        PIncome.SetRange(Date, CalcDate('-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                        PIncome.SetRange("Loan No.", "Loan No.");
                                        if PIncome.FindFirst then begin
                                            PIncome.Amount += (SLedger.Amount * -1);
                                            if PIncome.Amount < 0 then
                                                PIncome.Amount := 0;
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Modify;
                                        end
                                        else begin
                                            ENo += 1;
                                            PIncome.Init;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Description := SLedger.Description;
                                            PIncome.Amount := (SLedger.Amount * -1);
                                            PIncome."Entry No." := ENo;
                                            PIncome.Insert;

                                        end;
                                    end;


                                until SLedger.Next = 0;
                            end
                            else begin

                                if CProduct."Appraisal No. of Credits" > 0 then begin
                                    Error('Credit Transactions are Less the required limit of %1', CProduct."Appraisal No. of Credits");
                                end;
                            end;

                        end;
                    end;
                end;












        end;

    end;

    /// <summary>
    /// UpdateIncomeAnalysis.
    /// </summary>
    /// <summary>
    /// UpdateIncomeAnalysis.
    /// </summary>
    procedure UpdateIncomeAnalysis()
    var
        PIncome: Record "Periodic Income Entries";
        CProduct: Record "Product Factory";
        SProduct: Record "Product Factory";
        Savings: Record "Savings Accounts";
        IncomeDetails: Record "Appraisal Salary Details";
        ENo: Integer;
        AvgIncome: Decimal;
    begin


        IncomeDetails.Reset;
        IncomeDetails.SetRange("Loan No", "Loan No.");
        if IncomeDetails.FindFirst then
            IncomeDetails.DeleteAll;

        CProduct.Get("Loan Product Type");
        if CProduct."Member Class" <> 'CLASS C' then
            if CProduct."Appraisal Parameter Type" = CProduct."Appraisal Parameter Type"::" " then
                Error('Appraisal Parameter Type Must Have a value for this product');

        if "Mode of Disbursement" = "Mode of Disbursement"::"Savings Account" then
            Savings.Get("Disbursement Account No");

        case CProduct."Appraisal Parameter Type" of
            CProduct."Appraisal Parameter Type"::Bonus,
            CProduct."Appraisal Parameter Type"::Tea:
                begin
                    SProduct.Reset; //MESSAGE('T1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1   -  SProduct."Product ID"  %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            AvgIncome := 0;
                            PIncome.Reset;
                            PIncome.SetRange("Loan No.", "Loan No.");
                            if CProduct."Appraisal Parameter Type" = CProduct."Appraisal Parameter Type"::Bonus then begin
                                CProduct.TestField("Bonus Appraisal Start Date");
                                PIncome.SetFilter(Date, '>%1', CProduct."Bonus Appraisal Start Date");
                            end;
                            if PIncome.FindFirst then begin
                                PIncome.CalcSums(Amount);
                                AvgIncome := Round(PIncome.Amount / PIncome.Count, 1, '<');
                            end;
                            //MESSAGE('AvgIncome - %1',AvgIncome);

                            if AvgIncome > 0 then begin
                                IncomeDetails.Init;
                                IncomeDetails.Validate("Loan No", "Loan No.");
                                IncomeDetails.Validate("Client Code", "Member No.");

                                if CProduct."Appraisal Parameter Type" = CProduct."Appraisal Parameter Type"::Bonus then begin
                                    if CProduct."Appraised on Expected Bonus" then begin
                                        IncomeDetails.Validate(Code, 'BASIC');
                                        IncomeDetails.Validate(Type, IncomeDetails.Type::"Current Bonus");
                                        IncomeDetails.Validate(Amount, 0);
                                    end
                                    else begin
                                        IncomeDetails.Validate(Code, 'BASIC');
                                        IncomeDetails.Validate(Type, IncomeDetails.Type::"Previous Bonus");
                                        IncomeDetails.Validate(Amount, AvgIncome);
                                    end;
                                end
                                else begin
                                    IncomeDetails.Validate(Code, 'BASIC');
                                    IncomeDetails.Validate(Type, IncomeDetails.Type::Basic);
                                    IncomeDetails.Validate(Amount, AvgIncome);
                                end;
                                IncomeDetails.Insert(true);
                            end;

                        end;
                    end;
                end;


            CProduct."Appraisal Parameter Type"::Milk:
                begin
                    SProduct.Reset; //MESSAGE('T1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Milk);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1   -  SProduct."Product ID"  %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            AvgIncome := 0;
                            PIncome.Reset;
                            PIncome.SetRange("Loan No.", "Loan No.");
                            if PIncome.FindFirst then begin
                                PIncome.CalcSums(Amount);
                                AvgIncome := Round(PIncome.Amount / PIncome.Count, 1, '<');
                            end;
                            //MESSAGE('AvgIncome - %1',AvgIncome);

                            if AvgIncome > 0 then begin
                                IncomeDetails.Init;
                                IncomeDetails.Validate("Loan No", "Loan No.");
                                IncomeDetails.Validate("Client Code", "Member No.");
                                IncomeDetails.Validate(Code, 'BASIC');
                                IncomeDetails.Validate(Type, IncomeDetails.Type::Basic);
                                IncomeDetails.Validate(Amount, AvgIncome);
                                IncomeDetails.Insert(true);
                            end;

                        end;
                    end;
                end;


            CProduct."Appraisal Parameter Type"::Salary:
                begin
                    SProduct.Reset; //MESSAGE('xxT1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Salary);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('xxSavings."Product Type" %1   -  SProduct."Product ID"  %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            AvgIncome := 0;
                            PIncome.Reset;
                            PIncome.SetRange("Loan No.", "Loan No.");
                            if PIncome.FindFirst then begin
                                PIncome.CalcSums(Amount);
                                AvgIncome := Round(PIncome.Amount / PIncome.Count, 1, '<');
                            end;
                            //MESSAGE('AvgIncome : %1',AvgIncome);

                            if AvgIncome > 0 then begin
                                IncomeDetails.Init;
                                IncomeDetails.Validate("Loan No", "Loan No.");
                                IncomeDetails.Validate("Client Code", "Member No.");
                                IncomeDetails.Validate(Code, 'BASIC');
                                IncomeDetails.Validate(Type, IncomeDetails.Type::Basic);
                                IncomeDetails.Validate(Amount, AvgIncome);
                                IncomeDetails.Insert(true);
                                //MESSAGE('%1',IncomeDetails);
                            end;

                        end;
                    end;
                end;



            CProduct."Appraisal Parameter Type"::"Staff Salary":
                begin
                    SProduct.Reset; //MESSAGE('xxT1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::"Staff Salary");
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('xxSavings."Product Type" %1   -  SProduct."Product ID"  %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            AvgIncome := 0;
                            PIncome.Reset;
                            PIncome.SetRange("Loan No.", "Loan No.");
                            if PIncome.FindFirst then begin
                                PIncome.CalcSums(Amount);
                                AvgIncome := Round(PIncome.Amount / PIncome.Count, 1, '<');
                            end;
                            //MESSAGE('AvgIncome : %1',AvgIncome);

                            if AvgIncome > 0 then begin
                                IncomeDetails.Init;
                                IncomeDetails.Validate("Loan No", "Loan No.");
                                IncomeDetails.Validate("Client Code", "Member No.");
                                IncomeDetails.Validate(Code, 'BASIC');
                                IncomeDetails.Validate(Type, IncomeDetails.Type::Basic);
                                IncomeDetails.Validate(Amount, AvgIncome);
                                IncomeDetails.Insert(true);
                                //MESSAGE('%1',IncomeDetails);
                            end;

                        end;
                    end;
                end;



            CProduct."Appraisal Parameter Type"::KGs:
                begin
                    SProduct.Reset; //MESSAGE('xxT1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('xxSavings."Product Type" %1   -  SProduct."Product ID"  %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            CProduct.TestField("Appraisal Rate on KGs");
                            AvgIncome := CProduct."Appraisal Rate on KGs";

                            if AvgIncome > 0 then begin
                                IncomeDetails.Init;
                                IncomeDetails.Validate("Loan No", "Loan No.");
                                IncomeDetails.Validate("Amount Calculation Method", IncomeDetails."Amount Calculation Method"::"Based On Rate");
                                IncomeDetails.Validate("Client Code", "Member No.");
                                IncomeDetails.Validate(Code, 'KGS');
                                IncomeDetails.Validate(Type, IncomeDetails.Type::Basic);
                                IncomeDetails.Validate("Rate Per unit", AvgIncome);
                                IncomeDetails.Insert(true);
                                //MESSAGE('%1',IncomeDetails);
                            end;

                        end;
                    end;
                end;




            CProduct."Appraisal Parameter Type"::Junior:
                begin
                    SProduct.Reset; //MESSAGE('xxT1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('xxSavings."Product Type" %1   -  SProduct."Product ID"  %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            AvgIncome := 0;
                            PIncome.Reset;
                            PIncome.SetRange("Loan No.", "Loan No.");
                            if PIncome.FindFirst then begin
                                PIncome.CalcSums(Amount);
                                AvgIncome := Round(PIncome.Amount, 1, '<');
                            end;
                            //MESSAGE('AvgIncome : %1',AvgIncome);

                            if AvgIncome > 0 then begin
                                IncomeDetails.Init;
                                IncomeDetails.Validate("Loan No", "Loan No.");
                                IncomeDetails.Validate("Client Code", "Member No.");
                                IncomeDetails.Validate(Code, 'BASIC');
                                IncomeDetails.Validate(Type, IncomeDetails.Type::Junior);
                                IncomeDetails.Validate(Amount, AvgIncome);
                                IncomeDetails.Insert(true);
                                //MESSAGE('%1',IncomeDetails);
                            end;

                        end;
                    end;
                end;


            CProduct."Appraisal Parameter Type"::Credits:
                begin
                    SProduct.Reset; //MESSAGE('T1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Business);
                    //SProduct.SETRANGE("Product ID",CProduct."Disbursement Product");
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1   -  SProduct."Product ID"  %2',Savings."Product Type", SProduct."Product ID");
                        if (Savings."Product Type" = SProduct."Product ID") or (Savings."Product Type" <> '') then begin
                            AvgIncome := 0;
                            PIncome.Reset;
                            PIncome.SetRange("Loan No.", "Loan No.");
                            if PIncome.FindFirst then begin
                                PIncome.CalcSums(Amount);
                                AvgIncome := Round(PIncome.Amount / PIncome.Count, 1, '<');
                            end;
                            //MESSAGE('AvgIncome - %1',AvgIncome);

                            if AvgIncome > 0 then begin
                                IncomeDetails.Init;
                                IncomeDetails.Validate("Loan No", "Loan No.");
                                IncomeDetails.Validate("Client Code", "Member No.");
                                IncomeDetails.Validate(Code, 'BASIC');
                                IncomeDetails.Validate(Type, IncomeDetails.Type::Basic);
                                IncomeDetails.Validate(Amount, AvgIncome);
                                IncomeDetails.Insert(true);
                            end;

                        end;
                    end;
                end;





        end;
    end;

    /// <summary>
    /// GetAppraisalFee.
    /// </summary>
    /// <param name="ApprovedAmount">Decimal.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetAppraisalFee(ApprovedAmount: Decimal): Decimal
    var
        PCharges: Record "Loan Product Charges";
        Amt: Decimal;
        AppraisalFee: Decimal;
    begin


        AppraisalFee := 0;
        PCharges.Reset;
        PCharges.SetRange(PCharges."Product Code", "Loan Product Type");
        PCharges.SetRange(PCharges."Charge Type", PCharges."Charge Type"::General);
        PCharges.SetRange(Prorate, PCharges.Prorate::Appraisal);
        if PCharges.Find('-') then begin
            repeat
                if PCharges.Prorate = PCharges.Prorate::Appraisal then begin

                    if (PCharges."Charge Method" = PCharges."Charge Method"::"% of Amount") then
                        Amt := (ApprovedAmount * (PCharges.Percentage / 100))
                    else
                        if PCharges."Charge Method" = PCharges."Charge Method"::"Flat Amount" then
                            Amt := PCharges."Charge Amount"
                        else
                            if PCharges."Charge Method" = PCharges."Charge Method"::Staggered then begin

                                PCharges.TestField(PCharges."Staggered Charge Code");

                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, PCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if (ApprovedAmount >= TariffDetails."Lower Limit") and (ApprovedAmount <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" = true then begin
                                                Amt := ApprovedAmount * TariffDetails.Percentage * 0.01;
                                            end
                                            else begin
                                                Amt := TariffDetails."Charge Amount";
                                            end;
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;


                    if Amt < PCharges.Minimum then
                        Amt := PCharges.Minimum;
                    if Amt > PCharges.Maximum then
                        Amt := PCharges.Maximum;

                    AppraisalFee += Round(Amt / Installments, 0.01, '>');

                end;

            until PCharges.Next = 0;

        end;

        Repayment := "Loan Principle Repayment" + "Loan Interest Repayment" + AppraisalFee;

        exit(AppraisalFee);
    end;

    /// <summary>
    /// ClearLoanDetails.
    /// </summary>
    procedure ClearLoanDetails()
    var
    // LoanGuara: Record "Loan Guarantors and Security"
    begin

        if "Loan No." <> '' then begin

            LoanGuara.Reset;
            LoanGuara.SetRange("Loan No", "Loan No.");
            if LoanGuara.FindFirst then
                LoanGuara.DeleteAll;

            TopUp.Reset;
            TopUp.SetRange("Loan No.", "Loan No.");
            if TopUp.FindFirst then
                TopUp.DeleteAll;

            PartialDisbursementSchedule.Reset;
            PartialDisbursementSchedule.SetRange("Loan No.", "Loan No.");
            if PartialDisbursementSchedule.FindFirst then
                PartialDisbursementSchedule.DeleteAll;


            LoanWitness.Reset;
            LoanWitness.SetRange("Loan No.", "Loan No.");
            if LoanWitness.FindFirst then
                LoanWitness.DeleteAll;




            OtherCommitementsClearance.Reset;
            OtherCommitementsClearance.SetRange("Loan No.", "Loan No.");
            if OtherCommitementsClearance.FindFirst then
                OtherCommitementsClearance.DeleteAll;





            //xxx

            /// <summary>
            /// UpdatePeriodicIncomeTEST.
            /// </summary>
        end;
    end;

    procedure UpdatePeriodicIncomeTEST()
    var
        PIncome: Record "Periodic Income Entries";
        CProduct: Record "Product Factory";
        SProduct: Record "Product Factory";
        Savings: Record "Savings Accounts";
        Salary: Record "PR Employee Transactions";
        ENo: Integer;
        SalLines: Record "Salary Lines";
        Bonus: Record "Bonus Payment History";
        SalHeader: Record "Salary Header";
        JuniorSav: Record "Savings Accounts";
        JuniorBalance: Decimal;
        SLedger: Record "Savings Ledger Entry";
    begin

        PIncome.Reset;
        PIncome.SetRange("Loan No.", "Loan No.");
        if PIncome.FindFirst then
            PIncome.DeleteAll;


        CProduct.Get("Loan Product Type");
        if CProduct."Member Class" <> 'CLASS C' then
            if CProduct."Type of Discounting" <> CProduct."Type of Discounting"::"Loan Discounting" then
                if CProduct."Appraisal Parameter Type" = CProduct."Appraisal Parameter Type"::" " then
                    Error('Appraisal Parameter Type Must Have a value for this product');


        Savings.Get("Disbursement Account No");

        case CProduct."Appraisal Parameter Type" of


            CProduct."Appraisal Parameter Type"::Bonus:
                begin
                    SProduct.Reset; //MESSAGE('T1');
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        if Savings."Product Type" = SProduct."Product ID" then begin

                        end;
                    end;
                end;


            CProduct."Appraisal Parameter Type"::Tea:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        if Savings."Product Type" = SProduct."Product ID" then begin

                            SalLines.Reset;
                            SalLines.SetRange("Posting Date", CalcDate('-3M-CM', "Application Date"), "Application Date");
                            SalLines.SetRange(Posted, true);
                            SalLines.SetRange("Account No.", "Disbursement Account No");
                            if SalLines.Find('-') then begin
                                ENo := 0;
                                repeat



                                    PIncome.Reset;
                                    PIncome.SetRange("Loan No.", "Loan No.");
                                    ENo := PIncome.Count;

                                    SalHeader.Reset;
                                    SalHeader.SetRange(No, SalLines."Salary Header No.");
                                    SalHeader.SetRange(Posted, true);
                                    SalHeader.SetRange("Posting date", CalcDate('-3M-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                    SalHeader.SetRange("Income Type", SalHeader."Income Type"::Tea);
                                    if SalHeader.Find('-') then begin

                                        if (SalHeader."Posting date" >= CalcDate('-3M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-3M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-3M-CM', "Application Date"), CalcDate('-3M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-2M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-2M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-2M-CM', "Application Date"), CalcDate('-2M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-1M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-1M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-1M-CM', "Application Date"), CalcDate('-1M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                    end;

                                until SalLines.Next = 0;
                            end;
                        end;
                    end;
                end;



            CProduct."Appraisal Parameter Type"::Milk:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Milk);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');
                            SalLines.Reset;
                            SalLines.SetRange("Posting Date", CalcDate('-3M-CM', "Application Date"), "Application Date");
                            SalLines.SetRange(Posted, true);
                            SalLines.SetRange("Account No.", "Disbursement Account No");
                            if SalLines.Find('-') then begin
                                ENo := 0;
                                repeat


                                    //MESSAGE('T2');
                                    PIncome.Reset;
                                    PIncome.SetRange("Loan No.", "Loan No.");
                                    ENo := PIncome.Count;

                                    SalHeader.Reset;
                                    SalHeader.SetRange(No, SalLines."Salary Header No.");
                                    SalHeader.SetRange(Posted, true);
                                    SalHeader.SetRange("Posting date", CalcDate('-3M-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                    SalHeader.SetRange("Income Type", SalHeader."Income Type"::Milk);
                                    if SalHeader.Find('-') then begin
                                        //MESSAGE('T3');
                                        if (SalHeader."Posting date" >= CalcDate('-3M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-3M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-3M-CM', "Application Date"), CalcDate('-3M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-2M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-2M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-2M-CM', "Application Date"), CalcDate('-2M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-1M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-1M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-1M-CM', "Application Date"), CalcDate('-1M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                    end;

                                until SalLines.Next = 0;
                            end;
                        end;
                    end;
                end;


            CProduct."Appraisal Parameter Type"::Salary:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Salary);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');
                            SalLines.Reset;
                            SalLines.SetRange("Posting Date", CalcDate('-3M-CM', "Application Date"), "Application Date");
                            SalLines.SetRange(Posted, true);
                            SalLines.SetRange("Account No.", "Disbursement Account No");
                            if SalLines.Find('-') then begin
                                ENo := 0;
                                repeat


                                    //MESSAGE('T2');
                                    PIncome.Reset;
                                    PIncome.SetRange("Loan No.", "Loan No.");
                                    ENo := PIncome.Count;

                                    SalHeader.Reset;
                                    SalHeader.SetRange(No, SalLines."Salary Header No.");
                                    SalHeader.SetRange(Posted, true);
                                    SalHeader.SetRange("Posting date", CalcDate('-3M-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                    SalHeader.SetRange("Income Type", SalHeader."Income Type"::Salary);
                                    if SalHeader.Find('-') then begin
                                        //MESSAGE('T3');
                                        if (SalHeader."Posting date" >= CalcDate('-3M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-3M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-3M-CM', "Application Date"), CalcDate('-3M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-2M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-2M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-2M-CM', "Application Date"), CalcDate('-2M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-1M-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('-1M+CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-1M-CM', "Application Date"), CalcDate('-1M+CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                        if (SalHeader."Posting date" >= CalcDate('-CM', "Application Date")) and ((SalHeader."Posting date" <= CalcDate('CM', "Application Date"))) then begin
                                            PIncome.Reset;
                                            PIncome.SetRange(Date, CalcDate('-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                            PIncome.SetRange("Loan No.", "Loan No.");
                                            if PIncome.FindFirst then begin
                                                PIncome.Amount += SalLines.Amount;
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Modify;
                                            end
                                            else begin
                                                ENo += 1;
                                                PIncome.Init;
                                                PIncome."Loan No." := "Loan No.";
                                                PIncome."Member No." := "Member No.";
                                                PIncome.Name := "Member Name";
                                                PIncome.Date := SalLines."Posting Date";
                                                PIncome.Description := SalHeader.Remarks;
                                                PIncome.Amount := SalLines.Amount;
                                                PIncome."Entry No." := ENo;
                                                PIncome.Insert;

                                            end;
                                        end;
                                    end;

                                until SalLines.Next = 0;
                            end;
                        end;
                    end;
                end;






            CProduct."Appraisal Parameter Type"::"Staff Salary":
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::"Staff Salary");
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');

                            /*Salary.Reset;
                            Salary.SetRange("Employee Code", "Staff No");
                            Salary.SetRange("Transaction Code", 'BPAY');
                            Salary.SetRange("Payroll Period", CalcDate('-1M-CM', "Application Date"), "Application Date");
                            if Salary.Find('+') then begin
                                ENo += 1;
                                PIncome.Init;
                                PIncome."Loan No." := "Loan No.";
                                PIncome."Member No." := "Member No.";
                                PIncome.Name := "Member Name";
                                PIncome.Date := Salary."Payroll Period";
                                PIncome.Description := Salary."Transaction Name";
                                PIncome.Amount := Salary.Amount;
                                PIncome."Entry No." := ENo;
                                PIncome.Insert;
                            end;*/
                        end;
                    end;
                end;




            CProduct."Appraisal Parameter Type"::KGs:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');

                        end;
                    end;
                end;





            CProduct."Appraisal Parameter Type"::Junior:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Tea);
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        //MESSAGE('Savings."Product Type" %1 SProduct."Product ID" %2',Savings."Product Type", SProduct."Product ID");
                        if Savings."Product Type" = SProduct."Product ID" then begin
                            //MESSAGE('T1');
                            JuniorBalance := 0;
                            JuniorSav.Reset;
                            JuniorSav.SetRange("Member No.", "Member No.");
                            JuniorSav.SetRange("Product Category", JuniorSav."Product Category"::"Junior Savings");
                            JuniorSav.SetFilter("Balance (LCY)", '>0');
                            if JuniorSav.Find('-') then begin
                                repeat

                                    JuniorSav.CalcFields("Balance (LCY)");
                                    JuniorBalance += JuniorSav."Balance (LCY)";

                                    ENo += 1;
                                    PIncome.Init;
                                    PIncome."Loan No." := "Loan No.";
                                    PIncome."Member No." := "Member No.";
                                    PIncome.Name := "Member Name";
                                    PIncome.Date := Today;
                                    PIncome.Description := 'Junior Savings - ' + JuniorSav."No.";
                                    PIncome.Amount := JuniorSav."Balance (LCY)";
                                    PIncome."Entry No." := ENo;
                                    PIncome.Insert;

                                until JuniorSav.Next = 0;

                            end;



                        end;
                    end;
                end;




            CProduct."Appraisal Parameter Type"::Credits:
                begin
                    SProduct.Reset;
                    SProduct.SetRange("Income Type", SProduct."Income Type"::Business);
                    SProduct.SetRange("Product ID", CProduct."Disbursement Product");
                    SProduct.SetRange("Product Class Type", SProduct."Product Class Type"::Savings);
                    if SProduct.FindFirst then begin
                        if Savings."Product Type" = SProduct."Product ID" then begin


                            SLedger.Reset;
                            SLedger.SetRange("Customer No.", "Disbursement Account No");
                            SLedger.SetRange("Loan Disbursement", false);
                            SLedger.SetRange("Posting Date", CalcDate('-3M-CM', "Application Date"), CalcDate('CM', "Application Date"));
                            SLedger.SetFilter(Amount, '<0');
                            if SLedger.Find('-') then begin
                                ENo := 0;
                                if CProduct."Appraisal No. of Credits" > 0 then begin
                                    if SLedger.Count <= CProduct."Appraisal No. of Credits" then
                                        Error('Credit Transactions are Less the required limit of %1', CProduct."Appraisal No. of Credits");
                                end;
                                repeat
                                    PIncome.Reset;
                                    PIncome.SetRange("Loan No.", "Loan No.");
                                    ENo := PIncome.Count;


                                    if (SLedger."Posting Date" >= CalcDate('-3M-CM', "Application Date")) and ((SLedger."Posting Date" <= CalcDate('-3M+CM', "Application Date"))) then begin
                                        PIncome.Reset;
                                        PIncome.SetRange(Date, CalcDate('-3M-CM', "Application Date"), CalcDate('-3M+CM', "Application Date"));
                                        PIncome.SetRange("Loan No.", "Loan No.");
                                        if PIncome.FindFirst then begin
                                            PIncome.Amount += (SLedger.Amount * -1);
                                            if PIncome.Amount < 0 then
                                                PIncome.Amount := 0;
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Modify;
                                        end
                                        else begin
                                            ENo += 1;
                                            PIncome.Init;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Description := SLedger.Description;
                                            PIncome.Amount := (SLedger.Amount * -1);
                                            PIncome."Entry No." := ENo;
                                            PIncome.Insert;

                                        end;
                                    end;
                                    if (SLedger."Posting Date" >= CalcDate('-2M-CM', "Application Date")) and ((SLedger."Posting Date" <= CalcDate('-2M+CM', "Application Date"))) then begin
                                        PIncome.Reset;
                                        PIncome.SetRange(Date, CalcDate('-2M-CM', "Application Date"), CalcDate('-2M+CM', "Application Date"));
                                        PIncome.SetRange("Loan No.", "Loan No.");
                                        if PIncome.FindFirst then begin
                                            PIncome.Amount += (SLedger.Amount * -1);
                                            if PIncome.Amount < 0 then
                                                PIncome.Amount := 0;
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Modify;
                                        end
                                        else begin
                                            ENo += 1;
                                            PIncome.Init;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Description := SLedger.Description;
                                            PIncome.Amount := (SLedger.Amount * -1);
                                            PIncome."Entry No." := ENo;
                                            PIncome.Insert;

                                        end;
                                    end;
                                    if (SLedger."Posting Date" >= CalcDate('-1M-CM', "Application Date")) and ((SLedger."Posting Date" <= CalcDate('-1M+CM', "Application Date"))) then begin
                                        PIncome.Reset;
                                        PIncome.SetRange(Date, CalcDate('-1M-CM', "Application Date"), CalcDate('-1M+CM', "Application Date"));
                                        PIncome.SetRange("Loan No.", "Loan No.");
                                        if PIncome.FindFirst then begin
                                            PIncome.Amount += (SLedger.Amount * -1);
                                            if PIncome.Amount < 0 then
                                                PIncome.Amount := 0;
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Modify;
                                        end
                                        else begin
                                            ENo += 1;
                                            PIncome.Init;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Description := SLedger.Description;
                                            PIncome.Amount := (SLedger.Amount * -1);
                                            PIncome."Entry No." := ENo;
                                            PIncome.Insert;

                                        end;
                                    end;
                                    if (SLedger."Posting Date" >= CalcDate('-CM', "Application Date")) and ((SLedger."Posting Date" <= CalcDate('CM', "Application Date"))) then begin
                                        PIncome.Reset;
                                        PIncome.SetRange(Date, CalcDate('-CM', "Application Date"), CalcDate('CM', "Application Date"));
                                        PIncome.SetRange("Loan No.", "Loan No.");
                                        if PIncome.FindFirst then begin
                                            PIncome.Amount += (SLedger.Amount * -1);
                                            if PIncome.Amount < 0 then
                                                PIncome.Amount := 0;
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Modify;
                                        end
                                        else begin
                                            ENo += 1;
                                            PIncome.Init;
                                            PIncome."Loan No." := "Loan No.";
                                            PIncome."Member No." := "Member No.";
                                            PIncome.Name := "Member Name";
                                            PIncome.Date := SLedger."Posting Date";
                                            PIncome.Description := SLedger.Description;
                                            PIncome.Amount := (SLedger.Amount * -1);
                                            PIncome."Entry No." := ENo;
                                            PIncome.Insert;

                                        end;
                                    end;


                                until SLedger.Next = 0;
                            end
                            else begin

                                if CProduct."Appraisal No. of Credits" > 0 then begin
                                    Error('Credit Transactions are Less the required limit of %1', CProduct."Appraisal No. of Credits");
                                end;
                            end;

                        end;
                    end;
                end;












        end;
    end;

    /// <summary>
    /// CreateLoanAccount.
    /// </summary>
    /// <returns>Return variable LoanAccount of type Code[20].</returns>
    /// <summary>
    /// CreateLoanAccount.
    /// </summary>
    /// <returns>Return variable LoanAccount of type Code[20].</returns>
    procedure CreateLoanAccount() LoanAccount: Code[20]
    begin
        LoanAccount := '';
        ProdFac.Get("Loan Product Type");
        /*if Credit.Get(ProdFac."Account No. Prefix" + "Member No." + ProdFac."Account No. Suffix") then
            LoanAccount := ProdFac."Account No. Prefix" + "Member No." + ProdFac."Account No. Suffix"
        else
            LoanAccount := LoansProcess."CreateLoan Account"("Member No.", "Loan Product Type"); */
    end;

    /// <summary>
    /// SetMonthlyContributions.
    /// </summary>
    /// <summary>
    /// SetMonthlyContributions.
    /// </summary>
    procedure SetMonthlyContributions()
    var
        Cust: Record Customer;
    begin

        Members.Get("Member No.");
        Cust.Get("Employer Code");



        TestField("Loan Product Type");
        ProdFac.Get("Loan Product Type");
        ProdFac.TestField("Appraisal Savings Product");
        DepProduct.Get(ProdFac."Appraisal Savings Product");

        SDate := CalcDate('-CM', Today);
        EDate := CalcDate('CM', SDate);

        SavAcc.Reset;
        SavAcc.SetRange(SavAcc."Member No.", "Member No.");
        SavAcc.SetFilter("Product Type", DepProduct."Product ID");
        if SavAcc.Find('-') then begin
            SavAcc.SetFilter("Date Filter", '%1..%2', SDate, EDate);
            SavAcc.CalcFields("Balance (LCY)");
            if SavAcc."Balance (LCY)" <= 0 then
                SDate := CalcDate('-1M-CM', SDate);

            EDate := CalcDate('CM', SDate);


            for i := 1 to 4 do begin



                if (i = 4) or (EDate = 20191231D) then
                    SavAcc.SetFilter("Date Filter", '..%1', EDate)
                else
                    SavAcc.SetFilter("Date Filter", '%1..%2', SDate, EDate);


                SavAcc.CalcFields("Balance (LCY)");

                if SavAcc."Balance (LCY)" < 0 then
                    SavAcc."Balance (LCY)" := 0;



                SDate := CalcDate('-1M-CM', SDate);
                EDate := CalcDate('CM', SDate);

            end;
        end
        else
            Error('Member Does not have a %1 Account', DepProduct."Product Description");
    end;

    local procedure SetSalaryDetails()
    var
        SalarySetup: Record "Prod. Appraisal Salary Set-up";
        SalaryDetails: Record "Appraisal Salary Details";
        SalaryLines: Record "Salary Lines";
        ProdFactor: Record "Product Factory";
    begin

        SalaryDetails.Reset;
        SalaryDetails.SetRange("Loan No", "Loan No.");
        if SalaryDetails.FindFirst then
            SalaryDetails.DeleteAll;
        SalarySetup.Reset;
        SalarySetup.SetRange("Product ID", "Loan Product Type");
        if SalarySetup.FindFirst then begin
            repeat
                SalaryDetails.Init;
                SalaryDetails."Loan No" := "Loan No.";
                SalaryDetails."Client Code" := "Member No.";
                SalaryDetails.Validate(Code, SalarySetup.Code);
                SalaryDetails.Validate(Type, SalarySetup.Type);
                salaryDetails.Validate("Deduction Type", SalarySetup."Deduction Type");
                SalaryDetails.Insert;

            until SalarySetup.Next = 0;
        end;
        ProdFactor.Reset;
        ProdFactor.Setrange("Product ID", "Loan Product Type");
        IF ProdFactor.FIND('-') then begin
            IF ProdFactor."No. of Salary Times" > 0 then begin
                ProdFactor.TestField("Salary Period");
                SalaryLines.Reset;
                SalaryLines.SetRange("Member No.", "Member No.");
                SalaryLines.SetRange(Posted, True);
                SalaryLines.SetRange("Posting Date", Calcdate(StrSubstNo('-%1', ProdFactor."Salary Period"), Today), Today);
                If SalaryLines.Findset then begin
                    SalaryLines.Calcsums(Amount);
                    SalaryDetails.Reset;
                    SalaryDetails.SetRange("Loan No", "Loan No.");
                    SalaryDetails.SetRange(Type, SalarySetup.Type::Basic);
                    IF SalaryDetails.Find('-') then begin
                        SalaryDetails.Validate(Amount, ProdFactor."Net Salary Multiplier %" * 0.01 * (SalaryLines.Amount / SalaryLines.Count));
                        SalaryDetails.Modify;
                    end;

                    /*SalaryDetails.Init;
                    SalaryDetails."Loan No" := "Loan No.";
                    SalaryDetails."Client Code" := "Member No.";
                    SalaryDetails.Validate(Amount, ProdFactor."Net Salary Multiplier %" * (SalaryLines.Amount / SalaryLines.Count));
                    SalaryDetails.Validate(Code, '001');
                    SalaryDetails.Validate(Type, SalarySetup.Type::Basic);
                    SalaryDetails.Insert;*/
                end;

            end;



        end;



    end;

    local procedure GetBoughtShares(AccNo: Code[20]; CheckDate: Date) SharesTr: Decimal
    var
        //SharePurchaseandTransfer: Record "Share Purchase and Transfer";
        SLedger: Record "Savings Ledger Entry";
    begin

    end;

    /*procedure GetLastContribution(DepProduct: Record "Product Factory"; MNo: Code[20]) Cont: Decimal
    var
        Emp: Record Customer;
        AccNo: Code[20];
        Continue: Boolean;
        CheckoffLines: Record "Checkoff Lines";
        DFIlter: Text;
    begin

        Cont := 0;
        DFIlter := Format(CalcDate('-30D', Today)) + '..' + Format(Today);

        Members.Get(MNo);
        if Members."Customer Type" = Members."Customer Type"::Single then begin

            Members.TestField("Employer Code");
            Emp.Get(Members."Employer Code");
            if (Emp."Checkoff Type" = Emp."Checkoff Type"::" ") or (Emp."Self Employed") or (Emp."Employer Type" = Emp."Employer Type"::Pensioner) then
                Continue := true;
            Continue := false;

        end;


         if Continue then 
        begin

            SavAcc.Reset;
            SavAcc.SetRange(SavAcc."Member No.", MNo);
            SavAcc.SetFilter("Product Type", DepProduct."Product ID");
            SavAcc.SetFilter("Date Filter", DFIlter);
            if SavAcc.Find('-') then begin
                SavAcc.CalcFields("Balance (LCY)", "Last Transaction Date");
                Cont := SavAcc."Balance (LCY)";
                //MESSAGE('Last Cont Amount %1',Cont);
                if Round(Cont, 1, '>') < SavAcc."Monthly Contribution" then Message('Last Cont Amount is less than  %1', SavAcc."Monthly Contribution");
            end;
        end;
        //END;
        //(lastcont,Cont,SavAcc."Last Transaction Date");

        "Last Contribution and Date" := 'Amount-' + Format(Cont) + '  Date-' + Format(SavAcc."Last Transaction Date");
    end; */

    local procedure GetStaffInstallment()
    var
        NewInst: Integer;
    begin

        if ProdFac.Get("Loan Product Type") then begin
            if ProdFac."Loan Clients" = ProdFac."Loan Clients"::Staff then begin
                Members.Get("Member No.");
                Members.TestField("Payroll/Staff No.");
                HREmployees.Get(Members."Payroll/Staff No.");
                HREmployees.TestField("Retirement date");
                NewInst := 1;
                CheckDate := CalcDate('1M+CM', Today);
                while CheckDate <= HREmployees."Retirement date" do begin
                    CheckDate := CalcDate('1M', CheckDate);
                    NewInst += 1;
                end;
                if Installments > NewInst then
                    Installments := NewInst;

            end;
        end;
    end;

    procedure ShareCapitalQualified(MNo: Code[20]): Boolean
    var
        Members: Record Members;
        SavingsAccounts: Record "Savings Accounts";
    begin

        SavingsAccounts.Reset;
        SavingsAccounts.SetRange("Member No.", MNo);
        SavingsAccounts.SetRange("Product Category", SavingsAccounts."Product Category"::"Share Capital");
        if SavingsAccounts.FindFirst then begin
            SavingsAccounts.CalcFields("Balance (LCY)");
            GenSetup.Get;
            if SavingsAccounts."Balance (LCY)" >= GenSetup."Minimum Share Capital" then
                exit(true);
        end;

        exit(false);
    end;

    procedure UpdateRepayments(Amt: Decimal)
    var
        //PAct: Codeunit "Periodic Activities";
        Stage: Option "Disbursement","Monthly Billing";
    begin
        GetCPV;

        //
        TotalMRepay := 0;
        LPrincipal := 0;
        LInterest := 0;

        //InterestRate := Interest + PAct.GetInsurancePercent("Loan Product Type", Rec);
        LoanAmount := Amt;
        RepayPeriod := Installments;
        LBalance := Amt;


        if InterestRate <> 0 then begin
            if "Interest Calculation Method" = "Interest Calculation Method"::Amortised then begin
                TestField(Interest);
                TestField(Installments);

                TotalMRepay := Round((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -RepayPeriod)) * LoanAmount, 1, '>');
                TotalMRepay := TotalMRepay;
                LInterest := Round(LBalance / 100 / 12 * InterestRate, 1, '>');

                Repayment := TotalMRepay;
                LPrincipal := TotalMRepay - LInterest;
                "Loan Principle Repayment" := LPrincipal;
                "Loan Interest Repayment" := LInterest;
                Repayment := TotalMRepay;
                //"Qualifying Repayment" :=TotalMRepay;

            end;


            if "Interest Calculation Method" = "Interest Calculation Method"::"Straight Line" then begin
                //TESTFIELD(Interest);
                TestField(Installments);
                LPrincipal := Round(LoanAmount / RepayPeriod, 1, '>');
                LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '>');
                Repayment := LPrincipal + LInterest;
                "Loan Principle Repayment" := LPrincipal;
                "Loan Interest Repayment" := LInterest;
            end;

            if "Interest Calculation Method" = "Interest Calculation Method"::"Reducing Balance" then begin
                //TESTFIELD(Interest);
                TestField(Installments);
                LPrincipal := Round(LoanAmount / RepayPeriod, 1, '>');
                LInterest := Round((InterestRate / 12 / 100) * LBalance, 1, '>');
                Repayment := LPrincipal + LInterest;
                "Loan Principle Repayment" := LPrincipal;
                "Loan Interest Repayment" := LInterest;

            end;

            if "Interest Calculation Method" = "Interest Calculation Method"::"Reducing Flat" then begin
                //TESTFIELD(Interest);
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

            if "Interest Calculation Method" = "Interest Calculation Method"::Custom then begin
                TestField(Interest);
                TestField(Installments);
                TestField("Cumulative Present Value");



                Repayment := Round(LoanAmount / "Cumulative Present Value" / 12, 1, '>');
                "Loan Principle Repayment" := Round(LoanAmount / RepayPeriod, 1, '>');
                "Loan Interest Repayment" := Repayment - "Loan Principle Repayment";

            end;

        end else
            if ("Interest Calculation Method" = "Interest Calculation Method"::"Zero Interest") or (InterestRate <= 0) then begin
                LPrincipal := Round(LoanAmount / RepayPeriod, 1, '>');
                Repayment := LPrincipal;
                LInterest := 0;

                Repayment := LPrincipal + LInterest;
                "Loan Principle Repayment" := LPrincipal;
                "Loan Interest Repayment" := LInterest;
            end;
    end;

    procedure GetCPV()
    begin
        "Cumulative Present Value" := 0;

        if "Interest Calculation Method" = "Interest Calculation Method"::Custom then
            if Interest > 0 then
                if Installments > 0 then
                    "Cumulative Present Value" := Round((1 - (Power((1 + (Interest / 100)), (Installments / 12) * -1))) / (Interest / 100), 0.001, '=');
    end;

    procedure UpdateAppraisal()
    begin

        ProdFac.Get("Loan Product Type");
        /* if (ProdFac."Loan Clients" = ProdFac."Loan Clients"::Staff) then
             LoanProcess.SetStaffLoanAppraisal("Loan No.")
         else
             if "Recovery Mode" = "Recovery Mode"::Dividend then
                 LoanProcess.SetDividendLoanAppraisal("Loan No.")
             else
                 LoanProcess.SetLoanAppraisal("Loan No."); */
    end;

    procedure RejectLoan()
    var
        MemberEmail: Text;
        MobileNo: Text;
        MemberDetails: Record Members;
        LoanDetails: Record Loans;
        TextMessage: Text;
        TextSuffix: Text;
        SmsTemplate: Label 'Dear Member, The Loan you applied for of Amount %1 has been %2.';
        RejectSuffix: Label 'Reason: %1';
    begin
        if LoanDetails.Get("Loan No.") then begin
            ;

            if not MemberDetails.Get(LoanDetails."Member No.") then exit;

            MobileNo := MemberDetails."Mobile Phone No";
            /*with LoanDetails do begin

                TextMessage := StrSubstNo(SmsTemplate, "Requested Amount", Status);

                case LoanDetails.Status of
                    LoanDetails.Status::Rejected:
                        begin
                            TextSuffix := StrSubstNo(RejectSuffix, "Loan Rejection Reason");
                        end;
                end;
            end;*/
            //SendSMS.SendSms(SourceType::"Loan Rejected", MobileNo, TextMessage + TextSuffix, LoanDetails."Loan No.", LoanDetails."Member No.", true, false);
        end;
    end;


}

