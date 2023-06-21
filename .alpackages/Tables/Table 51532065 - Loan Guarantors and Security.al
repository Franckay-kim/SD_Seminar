table 51532065 "Loan Guarantors and Security"
{


    fields
    {
        field(1; "Loan No"; Code[30])
        {
            NotBlank = true;
            TableRelation = Loans."Loan No.";

            trigger OnValidate()
            var
                Loans: Record Loans;
            begin
                "Savings Product" := '';
                Loans.Reset;
                Loans.SetRange(Loans."Loan No.", "Loan No");
                if Loans.FindFirst then begin
                    // with Loans do begin
                    if ProductFactory.Get(Loans."Loan Product Type") then
                        "Savings Product" := ProductFactory."Appraisal Savings Product";
                    Rec."Cell Group Code" := "Cell Group Code";
                end;
            end;
            // end;
        }
        field(2; "Savings Account No./Member No."; Code[20])
        {
            TableRelation = IF ("Guarantor Type" = CONST(Guarantor)) "Savings Accounts"."No." WHERE(Status = FILTER(Active | Dormant),
                                                                                                   "Balance (LCY)" = FILTER(> 0),
                                                                                                   "Product Type" = FIELD("Savings Product"),
                                                                                                   "Can Guarantee Loan" = FILTER(true),
                                                                                                   "Cell Group Code" = FIELD("Cell Group Code"))
            ELSE
            IF ("Guarantor Type" = CONST(Collateral)) Members."No." WHERE(Status = FILTER(Active | Dormant))
            ELSE
            IF ("Guarantor Type" = FILTER(Lien)) "Savings Accounts"."No."
            ELSE
            IF ("Guarantor Type" = FILTER(Institution)) Customer."No.";

            trigger OnValidate()
            var
                StaffLoan: Boolean;
                LoanG: Record "Loan Guarantors and Security";
                LoansG: Record "Loan Guarantors and Security";
                ShareCap: Record "Savings Accounts";
            begin

                GenSetUp.Get;

                "Self Guarantee" := false;
                SelfGuaranteedA := 0;
                Date := Today;
                LoaneeEmployer := '';
                StaffLoan := false;
                //Set Member Guaranteed
                if LoansR.Get("Loan No") then begin
                    "Member Guaranteed" := LoansR."Member No.";
                    "Loanee Name" := LoansR."Member Name";
                    ProductFactory.Get(LoansR."Loan Product Type");
                    if ProductFactory."Loan Clients" = ProductFactory."Loan Clients"::Staff then
                        StaffLoan := true;
                    Members.Get(LoansR."Member No.");
                    LoaneeEmployer := Members."Employer Code";
                end;

                if "Guarantor Type" = "Guarantor Type"::Guarantor then begin

                    //Evaluate guarantor basic info
                    if Cust.Get("Savings Account No./Member No.") then begin
                        Members.Get(Cust."Member No.");

                        if StaffLoan then
                            if Members."Account Category" <> Members."Account Category"::"Staff Members" then
                                Error('This Product can only be guaranteed by Staff');
                        LoanG.Reset();
                        LoanG.SetRange("Member No", Rec."Member No");
                        LoanG.SetRange("Self Guarantee", true);
                        LoanG.SetFilter("Outstanding Balance", '>0');
                        if LoanG.FindFirst() then
                            Message('Member has self guaranteed loan no: ' + LoanG."Loan No");
                        LoansR.Reset;
                        LoansR.SetRange("Member No.", Cust."Member No.");
                        LoansR.SetFilter("Outstanding Balance", '>0');
                        LoansR.SetFilter("Current Loans Category-SASRA", '<>%1&<>%2', LoansR."Current Loans Category-SASRA"::Perfoming, LoansR."Current Loans Category-SASRA"::Watch);
                        if LoansR.FindFirst then
                            Message('Member has defaulted loan %1', LoansR."Loan Product Type");

                        //        IF (Cust.Status<>Cust.Status::Active) OR (Cust.Status<>Cust.Status::Dormant) THEN
                        //            ERROR('Member No. %1 is not an Active Member',Cust."No.");

                        if Employer.Get(Cust."Employer Code") then begin

                            // if Employer.Guarantorship = Employer.Guarantorship::"Cannot Guarantee" then
                            //    Error(Text001,Employer.Name);

                        end;


                        "Guarantor Loan Balance" := 0;
                        LoansR.Reset;
                        LoansR.SetRange("Member No.", Cust."Member No.");
                        LoansR.SetFilter("Outstanding Balance", '>0');
                        if LoansR.FindFirst then begin
                            repeat
                                LoansR.CalcFields("Outstanding Balance");
                                "Guarantor Loan Balance" += LoansR."Outstanding Balance";
                                "Outstanding Balance Bal" += LoansR."Outstanding Balance";
                            until LoansR.Next = 0;
                        end;

                        "Outstanding Balance Bal" := 0;
                        if LoanApp.Get("Loan No") then begin
                            if LoanApp."Loan Group" = LoanApp."Loan Group"::BOSA then begin
                                LoansRR.Reset;
                                LoansRR.SetRange("Loan Group", LoansRR."Loan Group"::BOSA);
                                LoansRR.SetRange("Member No.", Cust."Member No.");
                                LoansRR.SetFilter("Outstanding Balance", '>0');
                                if LoansRR.FindFirst then begin
                                    repeat
                                        LoansRR.CalcFields("Outstanding Balance");
                                        "Outstanding Balance Bal" += LoansRR."Outstanding Balance";
                                    until LoansR.Next = 0;
                                end;
                            end;
                        end;

                        Cust.CalcFields(Cust."Balance (LCY)");
                        Name := Cust.Name;
                        "Staff/Payroll No." := Cust."Payroll/Staff No.";
                        "Deposits/Shares" := Cust."Balance (LCY)" * GenSetUp."Guarantors Multiplier";
                        "Qualifying Amount" := Cust."Balance (LCY)";
                        "ID No." := Cust."ID No.";
                        "Member No" := Cust."Member No.";
                        // "Application Amount Guaranteed" := LoanProcess.GetMemberCommittedDeposits("Savings Account No./Member No.", false);
                        //"Total Guarantor Commitment" := "Application Amount Guaranteed" + LoanProcess.GetMemberCommittedDeposits("Savings Account No./Member No.", true);
                        //"Current Committed" := LoanProcess.GetCommittedCollateral("Collateral Reg. No.", true);
                        //waumini 12th JUNE 2023
                        LoansG.Reset();
                        LoansG.SetRange("Member No", "Member No");
                        LoansG.SetRange("Guarantor Type", Rec."Guarantor Type");
                        LoansG.SetFilter("Loan No", '<>%1', Rec."Loan No");
                        LoansG.SetFilter("Outstanding Balance", '>0');
                        if LoansG.Find('-') then
                            repeat
                                "Current Committed" += LoansG."Amount Guaranteed";
                                "Total Guarantor Commitment" += LoansG."Amount Guaranteed";
                            until LoansG.next = 0;
                        "Available Guarantorship" := "Deposits/Shares" - "Total Guarantor Commitment";
                        "Amount Guaranteed" := Cust."Balance (LCY)";

                        if "Available Guarantorship" < 0 then
                            "Available Guarantorship" := 0;



                        if LoanApp.Get("Loan No") then begin
                            if LoanApp."Member No." = "Member No" then begin
                                if Cust.Get("Savings Account No./Member No.") then begin
                                    "Self Guarantee" := true;
                                    "Available Guarantorship" := 0;
                                    "Deposits/Shares" := 0;
                                    "Qualifying Amount" := 0;
                                    "Amount Guaranteed" := 0;
                                    "Available Guarantorship" := 0;
                                    Cust.CalcFields("Balance (LCY)");
                                    ShareCap.Reset();
                                    ShareCap.SetRange("Member No.", "Member No");
                                    ShareCap.SetRange("Product Category", ShareCap."Product Category"::"Share Capital");
                                    if ShareCap.FindFirst() then begin end;

                                    if Cust."Product Category" = Cust."Product Category"::"Deposit Contribution" then begin
                                        "Available Guarantorship" := ((Cust."Balance (LCY)" - ShareCap.GetDepositArreas() - GetAmountGuaranteed()) * GenSetUp."Self Guarantee %" * 0.01) - GetSelfLoanBalances();
                                        IF "Available Guarantorship" < 0 then
                                            "Available Guarantorship" := 0;
                                        "Deposits/Shares" := Cust."Balance (LCY)";
                                        IF "Deposits/Shares" < 0 then
                                            "Deposits/Shares" := 0;
                                        "Amount Guaranteed" := "Available Guarantorship";
                                        If "Amount Guaranteed" < 0 then
                                            "Amount Guaranteed" := 0;
                                        "Qualifying Amount" := "Available Guarantorship";

                                    end;
                                end;
                            end
                            else begin

                                if Employer.Get(Cust."Employer Code") then begin

                                    // if Employer.Guarantorship = Employer.Guarantorship::"Self Guarantee Only" then
                                    //    Error(Text001,Employer.Name);

                                end;

                            end;
                        end;
                        //Check if self gauarantee
                        Loans.Reset;
                        Loans.SetRange(Loans."Member No.", Cust."Member No.");
                        Loans.SetRange(Loans."Self Guarantee", true);
                        Loans.SetFilter("Recovery Mode", '<>%1', Loans."Recovery Mode"::Dividend);
                        Loans.SetFilter(Loans."Total Outstanding Balance", '>0');
                        if Loans.Find('-') then begin
                            Loans.CalcFields(Loans."Total Outstanding Balance");
                            Message(Text002, Loans."Total Outstanding Balance", "Deposits/Shares");
                        end;



                    end;
                    //notify when member has guaranteed other loans
                    LoanG.Reset();
                    LoanG.SetRange("Savings Account No./Member No.", "Savings Account No./Member No.");
                    LoanG.SetFilter("Loan No", '<>%1', "Loan No");
                    LoanG.SetFilter("Outstanding Balance", '>0');
                    if LoanG.Find('-') then begin
                        Message('Please note that the member has guaranteed %1 active loans', LoanG.Count);
                        if GenSetUp."Max Loans To Guarantee" > 0 then
                            if LoanG.Count > GenSetUp."Max Loans To Guarantee" then
                                Error('Please note that the member has reached the max loans to guarantee limit');
                    end;
                    //waumini control against defaulted loans

                    LoanApp.Reset;
                    LoanApp.SetRange(LoanApp."Member No.", "Member No");
                    LoanApp.SetRange(LoanApp.Posted, true);
                    LoanApp.SetFilter(LoanApp."Outstanding Balance", '>0');
                    if LoanApp.Find('-') then begin
                        repeat
                            LoanApp.calcfields("Current Loans Category-SASRA");
                            IF LoanApp."Current Loans Category-SASRA" IN
                            [LoanApp."Current Loans Category-SASRA"::Doubtful, LoanApp."Current Loans Category-SASRA"::Loss, LoanApp."Current Loans Category-SASRA"::SubStandard] then
                                Message('This member has a defaulted  loan no %1 in sasra category %1', LoanApp."Loan No.", Format(LoanApp."Current Loans Category-SASRA"));
                        until LoanApp.next = 0;
                    end;


                    //end of waumini controls against defaulted loans
                    //waumini control against a loanee having guaranteed a defaulted loan
                    LoansG.Reset;
                    LoansG.SetRange("Member No", "Member No");
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

                    //waumini sacco should'nt have guaranteed same member a loan of similar product type
                    /*CalcFields("Loan Type");
                    LoansG.Reset();
                    LoansG.SetRange("Member No", "Member No");
                    LoansG.SetRange("Member Guaranteed", "Member Guaranteed");
                    LoansG.SetFilter("Outstanding Balance", '>0');
                    if LoansG.Find('-') then
                        repeat

                            LoansG.CalcFields("Loan Type");
                            if LoansG."Loan Type" = "Loan Type" then
                                Error('Please note that this member has guaranteed this member an active loan no %1 of the same product type', Format("Loan Type"));
                        until LoansG.next = 0;*/
                    //control changed in UAT2
                    LoanApp.reset;
                    LoanApp.setrange("loan no.", "Loan No");
                    If LoanApp.findfirst then begin
                        IF (LoanApp.Installments > 12) and (LoanApp."Loan Process Type" <> LoanApp."Loan Process Type"::Restructuring) then begin
                            LoansG.Reset();
                            LoansG.SetRange("Member No", "Member No");
                            LoansG.SetRange("Member Guaranteed", "Member Guaranteed");
                            LoansG.SetFilter("Outstanding Balance", '>0');
                            if LoansG.Find('-') then
                                repeat
                                    LoanApp.reset;
                                    LoanApp.setrange("loan no.", LoansG."Loan No");
                                    If LoanApp.findfirst then begin
                                        IF LoanApp.Installments > 12 then
                                            Error('Please note that this guarantor has guaranteed the loanee another long term loan ');
                                    end;
                                until LoansG.Next() = 0;
                        end;
                    end;
                    //waumini 12th June 2023
                    "Current Committed" := 0;
                    "Total Guarantor Commitment" := 0;
                    LoansG.Reset();
                    LoansG.SetRange("Member No", "Member No");
                    LoansG.SetRange("Guarantor Type", Rec."Guarantor Type");
                    LoansG.SetFilter("Loan No", '<>%1', Rec."Loan No");
                    LoansG.SetFilter("Outstanding Balance", '>0');
                    if LoansG.Find('-') then
                        repeat
                            "Current Committed" += LoansG."Amount Guaranteed";
                            "Total Guarantor Commitment" += LoansG."Amount Guaranteed";
                        until LoansG.next = 0;


                end
                else
                    if "Guarantor Type" = "Guarantor Type"::Collateral then begin
                        if Members.Get("Savings Account No./Member No.") then begin

                            Name := Members.Name;
                            "Staff/Payroll No." := Members."Payroll/Staff No.";
                            "ID No." := Members."ID No.";
                            "Member No" := "Savings Account No./Member No.";

                        end;
                    end
                    else
                        if "Guarantor Type" = "Guarantor Type"::Institution then begin
                            if Employer.Get("Savings Account No./Member No.") then begin
                                if LoaneeEmployer <> Employer."No." then
                                    Error('Loanee is not under this employer. Current Value is %1', LoaneeEmployer);
                                Name := Employer.Name;
                                //"Staff/Payroll No." := Members."Payroll/Staff No.";
                                //"ID No.":=Members."ID No.";
                                //"Member No":="Savings Account No./Member No.";

                            end;
                        end
                        else begin
                            if Cust.Get("Savings Account No./Member No.") then begin
                                Cust.CalcFields("Balance (LCY)");
                                //        IF Cust.Status<>Cust.Status::Active THEN
                                //           ERROR('Member No. %1 is not an Active Member',Cust."No.");

                                Name := Cust.Name;
                                "Staff/Payroll No." := Cust."Payroll/Staff No.";
                                // "Deposits/Shares" := Periodic.GetAccountBalance(Cust."No.");
                                "ID No." := Cust."ID No.";
                                "Member No" := Cust."Member No.";
                                //"Application Amount Guaranteed" := LoanProcess.GetMemberCommittedLien("Savings Account No./Member No.", false);
                                // "Total Guarantor Commitment" := "Application Amount Guaranteed" + LoanProcess.GetMemberCommittedLien("Savings Account No./Member No.", true);
                                "Available Guarantorship" := "Deposits/Shares" - "Total Guarantor Commitment";
                                "Amount Guaranteed" := Cust."Balance (LCY)";

                                if "Available Guarantorship" < 0 then
                                    "Available Guarantorship" := 0;

                                //"Amount Guaranteed":=Cust."Lien Placed";

                            end;
                        end;

                if LoanApp."Loan Group" <> LoanApp."Loan Group"::MFI then
                    if "Member No" <> '' then begin
                        LoanW.Reset;
                        LoanW.SetRange("Loan No.", "Loan No");
                        LoanW.SetFilter("Member No.", '<>%1', '');
                        if LoanW.Find('-') then begin
                            repeat
                                if LoanW."Member No." = "Member No" then
                                    Error('Witness Cannot be a Guarantor');
                            until LoanW.Next = 0;
                        end;

                        LoanW.Reset;
                        LoanW.SetRange("Loan No.", "Loan No");
                        LoanW.SetFilter("Member No.", '');
                        LoanW.SetFilter("ID No.", '<>%1', '');
                        if LoanW.Find('-') then begin
                            repeat
                                Members.Reset;
                                Members.SetRange("ID No.", LoanW."ID No.");
                                if Members.FindFirst then begin
                                    repeat
                                        if Members."No." = "Member No" then
                                            Error('Witness Cannot be a Guarantor');
                                    until Members.Next = 0;

                                end;
                            until LoanW.Next = 0;
                        end;

                    end;

                //WAUMINI 9TH JUNE 2023
                Message('Qualified guarantorship: ' + Format("Qualifying Amount" * 10)
                + 'Amount Committed: ' + Format("Current Committed")
                + 'Available Guarantorship: ' + format(("Qualifying Amount" * 10) - "Current Committed"));
            end;
        }
        field(3; Name; Text[200])
        {
            Editable = false;
        }
        field(4; "Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(5; "Deposits/Shares"; Decimal)
        {
            Editable = false;
        }
        field(6; "Loans Guaranteed"; Integer)
        {
            CalcFormula = Count("Loan Guarantors and Security" WHERE("Savings Account No./Member No." = FIELD("Savings Account No./Member No."),
                                                                      Substituted = FILTER(false),
                                                                      "Outstanding Balance" = FILTER(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; Substituted; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                Date := Today;
            end;
        }
        field(8; Date; Date)
        {
        }
        field(9; "Shares Recovery"; Boolean)
        {
        }
        field(10; "New Upload"; Boolean)
        {
        }
        field(11; "Amount Guaranteed"; Decimal)
        {

            trigger OnValidate()
            begin
                Loans.Reset;
                Loans.SetRange("Loan No.", "Loan No");
                if Loans.FindFirst then begin
                    DepCollateral.Reset;
                    DepCollateral.SetRange("Loan Product", Loans."Loan Product Type");
                    DepCollateral.SetRange(Type, "Collateral Type");
                    if DepCollateral.FindFirst then begin
                        if "Guarantor Type" = "Guarantor Type"::Collateral then begin
                            if "Amount Guaranteed" < (DepCollateral."Collateral Ratio" * Loans."Requested Amount" / 100) then
                                exit;//ERROR('Collateral Ratio not met');
                        end else
                            if "Guarantor Type" = "Guarantor Type"::Guarantor then begin
                                if "Amount Guaranteed" < (DepCollateral."Deposit Ratio" * Loans."Requested Amount" / 100) then
                                    exit;//ERROR('Deposit Ratio not met');
                            end;
                    end;
                end;

                TotG := 0;
                /*if "Amount Guaranteed" > "Available Guarantorship" then
                    // ERROR('You cannot guarantee more than the available guarantorship of %1',"Available Guarantorship");

                    "Current Committed" := "Amount Guaranteed";*/

                //WAUMINI 9TH JUNE AMOUNT GUARANTEED MUST NOT EXCEED QUALIFYING AMOUNT
                if "Amount Guaranteed" > "Qualifying Amount" then
                    Error('You can guarantee a maximum of %1 per loan', Format("Qualifying Amount"));
            end;
        }
        field(12; "Staff/Payroll No."; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                Cust.RESET;
                Cust.SETRANGE(Cust."Payroll/Staff No.","Staff/Payroll No.");
                Cust.SETRANGE(Cust."Loan Security Inclination",Cust."Loan Security Inclination"::"Long Term Loan Security");
                IF Cust.FIND('-') THEN BEGIN
                "Savings Account No./Member No.":=Cust."No.";
                VALIDATE("Savings Account No./Member No.");
                END
                ELSE BEGIN
                "Savings Account No./Member No.":='';
                //**ERROR('Member deposits account not found.');
                END;
                */

            end;
        }
        field(13; "Account No."; Code[20])
        {
        }
        field(14; "Self Guarantee"; Boolean)
        {
        }
        field(15; "ID No."; Code[50])
        {
        }
        field(16; "Outstanding Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Loan No" = FIELD("Loan No"),
                                                                  "Transaction Type" = FILTER(Loan | Repayment)));
            FieldClass = FlowField;
        }
        field(17; "Member Guaranteed"; Code[50])
        {
        }
        field(18; "Percentage Guaranteed"; Decimal)
        {
        }
        field(19; "Total Guaranteed"; Decimal)
        {
        }
        field(20; "Available Guarantorship"; Decimal)
        {
        }
        field(21; Signature; BLOB)
        {
        }
        field(22; "Member No"; Code[20])
        {
        }
        field(23; "Loan Type"; Code[20])
        {
            CalcFormula = Lookup(Loans."Loan Product Type" WHERE("Loan No." = FIELD("Loan No")));
            FieldClass = FlowField;
        }
        field(24; "Guaranteed Balance"; Decimal)
        {
        }
        field(25; "Loanee Name"; Text[150])
        {
            Editable = false;
        }
        field(26; "Guarantor Type"; Option)
        {
            OptionCaption = 'Guarantor,Collateral,Lien,Institution';
            OptionMembers = Guarantor,Collateral,Lien,Institution;
        }
        field(27; "Collateral Reg. No."; Code[20])
        {
            TableRelation = "Securities Register"."No." WHERE("Account No." = FIELD("Savings Account No./Member No."),
                                                               Status = CONST(Approved),
                                                               "Inward/Outward" = CONST("In-Store"));

            trigger OnValidate()
            var
                CollCharges: Record "Collateral Reg Charges";
                CurrLoanCharges: Record "Current Loan Charges";
            begin
                if "Guarantor Type" = "Guarantor Type"::Guarantor then
                    Clear("Collateral Reg. No.");
                if SecReg.Get("Collateral Reg. No.") then begin
                    //"Deposits/Shares" := SecReg."Collateral Limit";
                    //"Deposits/Shares" := SecReg."Forced Sale Value";
                    //"Qualifying Amount" := SecReg."Forced Sale Value";
                    "Deposits/Shares" := SecReg."Collateral Limit";
                    "Qualifying Amount" := SecReg."Collateral Limit";
                    "Collateral Value" := SecReg."Collateral Value";
                    // "Application Amount Guaranteed" := LoanProcess.GetCommittedCollateral("Collateral Reg. No.", false);
                    // "Current Committed" := LoanProcess.GetCommittedCollateral("Collateral Reg. No.", true);
                    // "Total Guarantor Commitment" := "Application Amount Guaranteed" + LoanProcess.GetCommittedCollateral("Collateral Reg. No.", true);
                    "Available Guarantorship" := "Deposits/Shares" - "Total Guarantor Commitment";
                    "Collateral Type" := SecReg.Type;
                    "Amount Guaranteed" := "Available Guarantorship";
                    if "Amount Guaranteed" <= 0 then begin
                        LoanAttached := '';
                        LoanSecurity.Reset;
                        LoanSecurity.SetRange("Guarantor Type", LoanSecurity."Guarantor Type"::Collateral);
                        LoanSecurity.SetRange("Collateral Reg. No.", "Collateral Reg. No.");
                        LoanSecurity.SetRange(Substituted, false);
                        LoanSecurity.SetRange("Defaulter Release", false);
                        LoanSecurity.SetFilter("Amount Guaranteed", '>0');
                        if LoanSecurity.Find('-') then begin
                            repeat
                                LoanAttached := '//' + LoanSecurity."Loan No" + '\\';
                            until LoanSecurity.Next = 0;
                            Message('Collateral %1 has been attached to the following thus amount guaranteed is zero %2', "Collateral Reg. No.", LoanAttached);
                        end;
                    end;

                    if not SecReg."Legally Cleared" then
                        if not Confirm('This Collateral Has not been legally cleared. Do you want to continue?') then
                            Error('Process Stopped');

                    if "Available Guarantorship" < 0 then
                        "Available Guarantorship" := 0;

                    //    IF SecReg."Insurance Expiry Date" <>0D THEN BEGIN
                    //    IF SecReg."Insurance Expiry Date" <= TODAY THEN
                    //        ERROR('Collateral Insurance Date has passed');
                    //    END;
                    if SecReg."Valuation Type" = SecReg."Valuation Type"::Depreciating then begin
                        if SecReg."Next Valuation Date" <= Today then
                            Error('Next Valuation Date has passed. Kindly Revaluate');

                        /*
                        Loans.GET("Loan No");
                
                        IF Loans."Expected Date of Completion" = 0D THEN BEGIN
                            LoanProcess.GenerateRepaymentSchedule(Loans);
                            RSchedule.RESET;
                            RSchedule.SETRANGE("Loan No.",Loans."Loan No.");
                            IF RSchedule.FINDLAST THEN BEGIN
                                Loans."Expected Date of Completion":=RSchedule."Repayment Date";
                                Loans.MODIFY;
                            END;
                        END;
                
                        IF SecReg."Next Valuation Date" < Loans."Expected Date of Completion" THEN
                          MESSAGE('Note that the Expected Date of Loan Completion exceeds the Next Valuation Date');
                        */

                    end;

                end;

                /*
                LoanGuar.RESET;
                LoanGuar.SETFILTER("Outstanding Balance",'>0');
                LoanGuar.SETRANGE("Collateral Reg. No.","Collateral Reg. No.");
                IF LoanGuar.FIND('-') THEN BEGIN
                  LoanGuar.CALCFIELDS("Outstanding Balance");
                  ERROR(Text004,LoanGuar."Loan No",LoanGuar."Outstanding Balance");
                END;
                */
                Validate("Amount Guaranteed");

                //insert collateral charge if any into the current charges
                //felix 28th Feb
                CurrLoanCharges.Reset();
                CurrLoanCharges.SetRange("Loan No.", rec."Loan No");
                CurrLoanCharges.DeleteAll();

                CollCharges.Reset();
                CollCharges.SetRange("Collateral Reg No.", rec."Collateral Reg. No.");
                if CollCharges.Find('-') then
                    repeat
                        CurrLoanCharges.Init();
                        //CurrLoanCharges.TransferFields(CollCharges);
                        CurrLoanCharges."Loan No." := rec."Loan No";
                        CurrLoanCharges."Charge Code" := CollCharges."Charge Code";
                        CurrLoanCharges.Description := CollCharges."Charge Description";
                        CurrLoanCharges.Amount := CollCharges."Charge Amount";
                        CurrLoanCharges."Charge Type" := CollCharges."Charge Type";
                        CurrLoanCharges."Effect Excise Duty" := CollCharges."Effect Excise Duty";
                        CurrLoanCharges."G/L Account" := CollCharges."Charges G_L Account";
                        CurrLoanCharges.Insert(true);
                    until CollCharges.Next() = 0;

            end;
        }
        field(28; "Collateral Value"; Decimal)
        {
        }
        field(29; "SMS Sent"; Boolean)
        {
        }
        field(30; "Total Sum"; Decimal)
        {
        }
        field(31; "Substitute Account No"; Code[50])
        {
            /* TableRelation = IF ("Substitute Type" = CONST(Guarantor)) "Savings Accounts"."No." WHERE("Product Category" = FILTER("Deposit Contribution"))
             ELSE
             IF ("Substitute Type" = CONST(Collateral)) Members."No." WHERE(Status = CONST(Active))
             ELSE
             IF ("Substitute Type" = CONST(Lien)) "Savings Accounts"."No." WHERE("Lien Placed" = FILTER(<> 0))
             ELSE
             IF ("Substitute Type" = CONST("Micro Savings")) "Savings Accounts"."No." WHERE("Product Category" = FILTER("Micro Credit Deposits"));*/
        }
        field(32; "Substitute Name"; Text[30])
        {
        }
        field(33; "Current Committed"; Decimal)
        {
        }
        field(34; "Application Amount Guaranteed"; Decimal)
        {
        }
        field(35; "Total Guarantor Commitment"; Decimal)
        {
        }
        field(37; "Substitute Type"; Option)
        {
            OptionCaption = 'Guarantor,Collateral,Lien,Micro Savings';
            OptionMembers = Guarantor,Collateral,Lien,"Micro Savings";
        }
        field(38; "Defaulter Recovered"; Decimal)
        {
        }
        field(39; "Defaulter Release"; Boolean)
        {
        }
        field(40; "Total Loan Guarantorship"; Decimal)
        {
            CalcFormula = Sum("Loan Guarantors and Security"."Amount Guaranteed" WHERE("Loan No" = FIELD("Loan No"),
                                                                                        Substituted = CONST(false),
                                                                                        "Defaulter Release" = CONST(false)));
            FieldClass = FlowField;
        }
        field(41; "Loan Top Up"; Boolean)
        {
        }
        field(42; "Guarantor Loan Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Super Guarantor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Guarantor Count"; Integer)
        {
            CalcFormula = Count("Loan Guarantors and Security" WHERE("Loan No" = FIELD("Loan No"),
                                                                      Substituted = CONST(false),
                                                                      "Defaulter Release" = CONST(false),
                                                                      "Guarantor Status" = CONST(Active)));
            FieldClass = FlowField;
        }
        field(45; "Guarantor Status"; Option)
        {
            CalcFormula = Lookup(Members.Status WHERE("No." = FIELD("Member No")));
            FieldClass = FlowField;
            OptionCaption = ' ,New,Active,Dormant,Frozen,Withdrawal Application,Withdrawn,Deceased,Defaulter,Closed,Blocked';
            OptionMembers = " ",New,Active,Dormant,Frozen,"Withdrawal Application",Withdrawn,Deceased,Defaulter,Closed,Blocked;
        }
        field(46; "Cell Group Code"; Code[20])
        {
            CalcFormula = Lookup(Loans."Cell Group Code" WHERE("Loan No." = FIELD("Loan No")));
            FieldClass = FlowField;
        }
        field(47; "Collateral Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = New,Old,Land;
        }
        field(48; "Savings Product"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(49; "Outstanding Balance Bal"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Qualifying Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "E-Mail Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Date Substituted"; Date)
        {

        }
    }

    keys
    {
        key(Key1; "Loan No", "Staff/Payroll No.", "Savings Account No./Member No.", "Collateral Reg. No.")
        {
        }
        key(Key2; "Loan No", "Savings Account No./Member No.")
        {
            SumIndexFields = "Deposits/Shares";
        }
        key(Key3; "Total Sum")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        if LoanApp.Get("Loan No") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text003, LoanApp.Status);
        end;
    end;

    trigger OnInsert()
    begin
        IF LoanApp.GET("Loan No") THEN BEGIN
            IF (LoanApp.Status = LoanApp.Status::Appraisal) OR (LoanApp.Status = LoanApp.Status::Approved) THEN
                ERROR(Text003, LoanApp.Status);
        END;

        //CalcFields("Cell Group Code");

    end;

    trigger OnModify()
    begin
        if LoanApp.Get("Loan No") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text003, LoanApp.Status);
        end;
    end;

    trigger OnRename()
    begin
        if LoanApp.Get("Loan No") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text003, LoanApp.Status);
        end;
    end;

    var
        Cust: Record "Savings Accounts";
        LoanGuarantors: Record "Loan Guarantors and Security";
        Loans: Record Loans;
        LoansR: Record Loans;
        LoansG: Integer;
        GenSetUp: Record "General Set-Up";
        SelfGuaranteedA: Decimal;
        StatusPermissions: Record "Credit Ledger Entry";
        LoanProduct: Record "Loan Charges";
        TotalGuaranteed: Decimal;
        BalanceRemaining: Decimal;
        LoanGuar: Record "Loan Guarantors and Security";
        TotG: Decimal;
        Members: Record Members;
        SecReg: Record "Securities Register";
        Employer: Record Customer;
        Text001: Label '%1 Members are not allowed to guarantee loans';
        Text002: Label 'This member has self guaranteed %1 and has a balance of %2';
        LoanApp: Record Loans;
        Text003: Label 'This Loan is already %1 and cannot modify';
        Text004: Label 'This collateral has been used for loan no. %1 and has a outstanding balance of %2';
        LoanGs: Record "Loan Guarantors and Security";
        //LoanProcess: Codeunit "Loans Process";
        //Periodic: Codeunit "Periodic Activities";
        RSchedule: Record "Loan Repayment Schedule";
        LoanW: Record "Loan Witness";
        ProductFactory: Record "Product Factory";
        LoaneeEmployer: Code[20];
        DepCollateral: Record "Deposit Collateral Ratio";
        LoanSecurity: Record "Loan Guarantors and Security";
        LoanAttached: Text;
        LoansRR: Record Loans;

    local procedure GetAmountGuaranteed() GuaraAmt: Decimal
    var
        LoanGua: Record "Loan Guarantors And Security";
    begin
        LoanGua.Reset();
        LoanGua.SetRange("Savings Account No./Member No.", "Savings Account No./Member No.");
        LoanGua.SetRange(Substituted, false);
        LoanGua.SetFilter("Outstanding Balance", '>0');
        if LoanGua.Find('-') then
            repeat
                LoanGua.CalcFields("Outstanding Balance");
                GuaraAmt += LoanGua."Outstanding Balance";
            until LoanGua.Next() = 0;
    end;

    local procedure GetSelfLoanBalances() LoanBalance: Decimal
    var
        LoanPosted: Record Loans;
    begin
        LoanPosted.Reset();
        LoanPosted.SetRange("Member No.", "Member No");
        LoanPosted.SetFilter("Outstanding Balance", '>0');
        IF LoanPosted.Find('-') then
            repeat
                LoanPosted.CalcFields("Outstanding Balance");
                LoanBalance += LoanPosted."Outstanding Balance";
            until LoanPosted.Next() = 0;
    end;
}

