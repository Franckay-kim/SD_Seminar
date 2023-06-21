table 51532150 "Membership closure"
{


    fields
    {
        field(1; "No."; Code[30])
        {
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Members WHERE(Status = CONST("Withdrawal Application"));

            trigger OnValidate()
            var
                WithdrawalNotice: Record "Member withdrawal Notice";
            begin
                if "Member No." <> '' then begin
                    WithdrawalNotice.Reset();
                    WithdrawalNotice.SetRange("Member No.", "Member No.");
                    WithdrawalNotice.SetRange(Status, WithdrawalNotice.Status::Approved);
                    if WithdrawalNotice.Find('-') = false then
                        Error('Please note that this member does not have an approved withdrawal application');
                end;

                if Members.Get("Member No.") then begin
                    if "Liability Report" = false then begin
                        Membershipclosure.Reset;
                        Membershipclosure.SetRange("Member No.", "Member No.");
                        Membershipclosure.SetFilter("No.", '<>%1', "No.");
                        Membershipclosure.SetRange("Liability Report", false);
                        Membershipclosure.SetFilter(Status, '%1|%2', Membershipclosure.Status::Open, Membershipclosure.Status::Pending);
                        if Membershipclosure.FindFirst then
                            Error('There is an existing closure document no %1 for this Member.', Membershipclosure."No.");
                    end;
                    /*
                    MemberCategory.GET(Members."Member Category");
                
                    SavingsAccounts.RESET;
                    SavingsAccounts.SETRANGE("Member No.","Member No.");
                    SavingsAccounts.SETRANGE("Product Category",SavingsAccounts."Product Category"::"Share Capital");
                    IF SavingsAccounts.FINDFIRST THEN BEGIN
                        SavingsAccounts.CALCFIELDS("Balance (LCY)");
                        IF SavingsAccounts."Balance (LCY)" < MemberCategory."Minimum Share Capital" THEN
                          ERROR('Member has only Contributed %1 Share Capital instead of %2',SavingsAccounts."Balance (LCY)",MemberCategory."Minimum Share Capital");
                    END;
                
                
                
                    SavingsAccounts.RESET;
                    SavingsAccounts.SETRANGE("Member No.","Member No.");
                    SavingsAccounts.SETRANGE("Product Category",SavingsAccounts."Product Category"::Benevolent);
                    IF SavingsAccounts.FINDFIRST THEN BEGIN
                        SavingsAccounts.CALCFIELDS("Balance (LCY)");
                        IF SavingsAccounts."Balance (LCY)" < MemberCategory."Minimum Benevolent" THEN
                          ERROR('Member has only Contributed %1 Share Capital instead of %2',SavingsAccounts."Balance (LCY)",MemberCategory."Minimum Benevolent");
                    END;
                    */


                    LoansG := 0;
                    LoanGuarantors.Reset;
                    LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No.");
                    LoanGuarantors.SetRange(Substituted, false);
                    //LoanGuarantors.SETRANGE(LoanGuarantors."Guarantor Type",LoanGuarantors."Guarantor Type"::Guarantor);
                    if LoanGuarantors.Find('-') then begin

                        repeat
                            if Loans.Get(LoanGuarantors."Loan No") then begin
                                Loans.CalcFields(Loans."Outstanding Balance");
                                if Loans."Outstanding Balance" > 0 then begin
                                    LoansG += 1;
                                end;
                            end;
                        until LoanGuarantors.Next = 0;

                        if LoansG > 0 then
                            Error('Member is Guaranteeing %1 Active Loans', LoansG);
                    end;




                    "Member Name" := Members.Name;
                    "ID No." := Members."ID No.";
                    "Staff No." := Members."Payroll/Staff No.";
                    "Global Dimension 1 Code" := Members."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Members."Global Dimension 2 Code";

                    "Application Date" := Today;
                    "Closure Type" := "Closure Type"::" ";
                    "Savings Scheme" := "Savings Scheme"::" ";
                    "Loans Option" := "Loans Option"::" ";
                    "Total Interest" := 0;
                    "Total Loan" := 0;
                    TotalSaving := 0;

                end;
                Validate("Savings Scheme");
                //create vendor account

            end;
        }
        field(3; "Member Name"; Text[50])
        {
        }
        field(4; "Closing Date"; Date)
        {
        }
        field(5; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(6; Posted; Boolean)
        {
        }
        field(7; "Total Loan"; Decimal)
        {
        }
        field(8; "Total Interest"; Decimal)
        {
        }
        field(9; "Member Savings"; Decimal)
        {
        }
        field(10; "No. Series"; Code[10])
        {
        }
        field(11; "Closure Type"; Option)
        {
            OptionCaption = ' ,Withdrawal - Normal,Withdrawal - Death,Withdrawal - Rejoining';
            OptionMembers = " ","Withdrawal - Normal","Withdrawal - Death","Withdrawal - Rejoining";

            trigger OnValidate()
            begin


                AccLine.Reset;
                AccLine.SetRange(AccLine."No.", "No.");
                if AccLine.Find('-') then
                    AccLine.DeleteAll;
                MemberwithdrawalNotice.Reset;
                MemberwithdrawalNotice.SetRange(MemberwithdrawalNotice."Member No.", "Member No.");
                MemberwithdrawalNotice.SetRange(MemberwithdrawalNotice.Status, MemberwithdrawalNotice.Status::Approved);
                if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then
                    if MemberwithdrawalNotice.Find('+') then begin
                        "Notice Maturity Date" := MemberwithdrawalNotice."Maturity Date";
                        if MemberwithdrawalNotice."Maturity Date" > "Closing Date" then begin

                            GenSetup.Get();
                            if not GenSetup."Allow PreMature Withdrawal" then
                                Error('Premature withdrawal is not allowed');
                        end;
                    end;

                "Insurance Amount" := 0;
                if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then begin
                    LoansG := 0;
                    LoanGuarantors.Reset;
                    LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No.");
                    //LoanGuarantors.SETRANGE(LoanGuarantors."Guarantor Type",LoanGuarantors."Guarantor Type"::Guarantor);
                    if LoanGuarantors.Find('-') then begin

                        repeat
                            if Loans.Get(LoanGuarantors."Loan No") then begin
                                Loans.CalcFields(Loans."Outstanding Balance");
                                if Loans."Outstanding Balance" > 0 then begin
                                    LoansG += 1;
                                end;
                            end;
                        until LoanGuarantors.Next = 0;

                        if LoansG > 0 then
                            Message('Member is Guaranteeing %1 Active Loans', LoansG);
                    end;
                end;


                "Member Savings" := 0;
                "Deposit Refundable" := 0;


                GenSetup.Get;
                SavingsAccounts.Reset;
                SavingsAccounts.SetRange(SavingsAccounts."Member No.", "Member No.");
                SavingsAccounts.SetFilter("Product Category", '<>%1', ProductFactory."Product Category"::Housing);
                if SavingsAccounts.Find('-') then begin
                    repeat
                        //IF SavingsAccounts."Loan Disbursement Account"=FALSE THEN BEGIN
                        SavingsAccounts.CalcFields("Balance (LCY)");
                        if ProductFactory.Get(SavingsAccounts."Product Type") then begin
                            if ProductFactory."Product Class Type" = ProductFactory."Product Class Type"::Savings then begin
                                if ProductFactory."Product Category" <> ProductFactory."Product Category"::"Share Capital" then begin
                                    if ProductFactory."Product Category" <> ProductFactory."Product Category"::"Registration Fee" then begin
                                        if ProductFactory."Can Close Account" = true then begin
                                            if ProductFactory."Product Category" <> ProductFactory."Product Category"::Benevolent then begin


                                                AccLine.Init;
                                                AccLine."No." := "No.";
                                                AccLine."Account No." := SavingsAccounts."No.";
                                                AccLine.Name := SavingsAccounts.Name;
                                                AccLine."Product Type" := SavingsAccounts."Product Type";
                                                AccLine."Product Category" := SavingsAccounts."Product Category";
                                                AccLine.Balance := SavingsAccounts."Balance (LCY)";
                                                if "Savings Scheme" = "Savings Scheme"::All then
                                                    AccLine.Close := true;
                                                AccLine.Blocked := SavingsAccounts.Blocked;
                                                AccLine."Member No." := SavingsAccounts."Member No.";


                                                DisbAcc.Reset;
                                                DisbAcc.SetRange("Member No.", "Member No.");
                                                DisbAcc.SetRange("Loan Disbursement Account", true);
                                                if DisbAcc.FindFirst then
                                                    if "Savings Scheme" = "Savings Scheme"::All then
                                                        AccLine."Transfer Account" := DisbAcc."No.";

                                                AccLine.Insert;

                                                //CLosure Fee
                                                //*Oketch AccountClosureFee:=ProdutFactory."Closure Fee";
                                                AccountClosureFee := 0;
                                                TransactionCharges.Reset;
                                                TransactionCharges.SetRange(TransactionCharges."Transaction Type", ProductFactory."Closure Fee");
                                                if TransactionCharges.Find('-') then begin
                                                    repeat
                                                        Amount[1] := 0;
                                                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then
                                                            Amount[1] := ("Member Savings" * TransactionCharges."Percentage of Amount") * 0.01
                                                        else
                                                            Amount[1] := TransactionCharges."Charge Amount";

                                                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                                            TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                                            TariffDetails.Reset;
                                                            TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                                            if TariffDetails.Find('-') then begin
                                                                repeat
                                                                    if ("Member Savings" >= TariffDetails."Lower Limit") and ("Member Savings" <= TariffDetails."Upper Limit") then begin
                                                                        if TariffDetails."Use Percentage" then
                                                                            Amount[1] := "Member Savings" * TariffDetails.Percentage * 0.01
                                                                        else
                                                                            Amount[1] := TariffDetails."Charge Amount";
                                                                    end;
                                                                until TariffDetails.Next = 0;
                                                            end;
                                                        end;
                                                        Amount[2] += Amount[1];
                                                    until TransactionCharges.Next = 0;
                                                end;

                                                AccountClosureFee := Amount[2];
                                                TotalSaving := TotalSaving + (AccLine.Balance - AccountClosureFee);
                                            end
                                            else begin
                                                if ProductFactory."Product Category" <> ProductFactory."Product Category"::Benevolent then begin
                                                    AccLine.Init;
                                                    AccLine."No." := "No.";
                                                    AccLine."Account No." := SavingsAccounts."No.";
                                                    AccLine.Name := SavingsAccounts.Name;
                                                    AccLine."Product Type" := SavingsAccounts."Product Type";
                                                    AccLine.Balance := SavingsAccounts."Balance (LCY)";
                                                    if "Savings Scheme" = "Savings Scheme"::All then
                                                        AccLine.Close := true;
                                                    AccLine.Blocked := SavingsAccounts.Blocked;
                                                    AccLine."Member No." := SavingsAccounts."Member No.";
                                                    AccLine.Insert;

                                                    BBF := BBF + (SavingsAccounts."Balance (LCY)" * (GenSetup."BBF Claim %" / 100));
                                                end;

                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    //END;
                    until SavingsAccounts.Next = 0;
                end;

                ValidateAmounts;

                /*
                "Member Savings":=TotalSaving;
                
                IF "Closure Type"="Closure Type"::"Withdrawal - Death" THEN BEGIN
                    "Deposit Refundable":="Member Savings";
                END
                ELSE BEGIN
                    IF ("Member Savings"-(LoanTotal+IntTotal))<0 THEN
                        "Deposit Refundable":=0
                    ELSE
                        "Deposit Refundable":="Member Savings"-(LoanTotal+IntTotal+GenSetup."Withdrawal Fee");
                
                    "Benevolent Fund":=BBF;
                END;
                VALIDATE("Loans Option");
                */

            end;
        }
        field(12; "Application Date"; Date)
        {
        }
        field(13; "Deposit Refundable"; Decimal)
        {
        }
        field(14; Remarks; Text[50])
        {
        }
        field(15; "Savings Scheme"; Option)
        {
            OptionCaption = ' ,All,Specific';
            OptionMembers = " ",All,Specific;

            trigger OnValidate()
            begin
                "Loans Option" := "Loans Option"::" ";
                if "Savings Scheme" <> "Savings Scheme"::" " then
                    "Loans Option" := "Loans Option"::All;

                Validate("Closure Type");
            end;
        }
        field(16; "Loans Option"; Option)
        {
            OptionCaption = ' ,Short Term,Long Term,All';
            OptionMembers = " ","Short Term","Long Term",All;

            trigger OnValidate()
            begin

                LoansG := 0;
                LoanGuarantors.Reset;
                LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No.");
                if LoanGuarantors.Find('-') then begin

                    repeat
                        if Loans.Get(LoanGuarantors."Loan No") then begin
                            Loans.CalcFields(Loans."Outstanding Balance");
                            if Loans."Outstanding Balance" > 0 then begin
                                LoansG += 1;
                            end;
                        end;
                    until LoanGuarantors.Next = 0;

                    if LoansG > 0 then
                        Message('Member is Guaranteeing %1 Active Loans', LoansG);
                end;


                //VALIDATE("Closure Type");

                ValidateAmounts;
            end;
        }
        field(17; "Entered By"; Code[30])
        {
        }
        field(18; Transaction; Option)
        {
            OptionCaption = 'Member Withdrawal';
            OptionMembers = "Member Withdrawal";
        }
        field(19; "ID No."; Code[50])
        {
        }
        field(20; "Benevolent Fund"; Decimal)
        {
        }
        field(21; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(22; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(23; "Insurance Amount"; Decimal)
        {

            trigger OnValidate()
            begin

                if "Insurance Amount" > 0 then
                    TestField("Closure Type", "Closure Type"::"Withdrawal - Death");

                ValidateAmounts;
            end;
        }
        field(24; "Transfer Account"; Code[20])
        {
            TableRelation = "Savings Accounts";

            trigger OnValidate()
            begin
                "Transfer Account Name" := '';
                if SavingsAccounts.Get("Transfer Account") then
                    "Transfer Account Name" := SavingsAccounts.Name;
            end;
        }
        field(25; "Transfer Account Name"; Text[150])
        {
        }
        field(26; "Total Penalty"; Decimal)
        {
        }
        field(27; "Total Appraisal"; Decimal)
        {
        }
        field(28; "Total Savings"; Decimal)
        {
            CalcFormula = Sum("Account Closure Line".Balance WHERE("No." = FIELD("No."),
                                                                    Close = FILTER(true)));
            FieldClass = FlowField;
        }
        field(29; "Total Charges"; Decimal)
        {
        }
        field(30; "Minute Nos."; Code[20])
        {
        }
        field(31; "Charge Rejoining Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Defaulter Loan"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Charge Offset Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Charge Membership Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Loan Registration Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Liability Report"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Notice Maturity Date"; Date)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Status <> Status::Open then
            Error(Txt0000);
    end;

    trigger OnInsert()
    begin
        NoSetup.Get();
        NoSetup.TestField(NoSetup."Member Closure Nos.");
        NoSeriesMgt.InitSeries(NoSetup."Member Closure Nos.", xRec."No. Series", 0D, "No.", "No. Series");

        //"Date Entered":=TODAY;
        "Entered By" := UserId;
    end;

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Members: Record Members;
        AccLine: Record "Account Closure Line";
        SavingsAccounts: Record "Savings Accounts";
        ProductFactory: Record "Product Factory";
        TotalSaving: Decimal;
        GenSetup: Record "General Set-Up";
        LoanTotal: Decimal;
        IntTotal: Decimal;
        Loans: Record Loans;
        LoansG: Decimal;
        LoanGuarantors: Record "Loan Guarantors and Security";
        Txt0000: Label 'You cannot delete when status is not open';
        BBF: Decimal;
        AccountClosureFee: Decimal;
        Amount: array[2] of Integer;
        TransactionCharges: Record "Transaction Charges";
        TariffDetails: Record "Tiered Charges Lines";
        //Periodic: Codeunit "Periodic Activities";
        Penalty: Decimal;
        Appraisal: Decimal;
        ClosureAccounts: Record "Account Closure Line";
        PFactory: Record "Product Factory";
        MemberwithdrawalNotice: Record "Member withdrawal Notice";
        TransactionTypes: Record "Transaction Types";
        TCharges: Decimal;
        Duty: Decimal;
        DisbAcc: Record "Savings Accounts";
        MemberCategory: Record "Member Category";
        LoanType: Record "Product Factory";
        AccountType: Record "Product Factory";
        TrAcc: Code[20];
        Membershipclosure: Record "Membership closure";

    procedure ValidateAmounts()
    var
        LType: Record "Product Factory";
    begin

        GenSetup.Get;
        IntTotal := 0;
        LoanTotal := 0;
        Appraisal := 0;
        Penalty := 0;
        "Loan Registration Fee" := 0;
        "Total Loan" := LoanTotal;
        "Total Interest" := IntTotal;
        "Total Penalty" := Penalty;
        "Total Appraisal" := Appraisal;

        "Defaulter Loan" := 0;

        if "Loans Option" <> "Loans Option"::" " then begin

            ClosureAccounts.Reset;
            ClosureAccounts.SetRange(ClosureAccounts."No.", "No.");
            ClosureAccounts.SetRange(ClosureAccounts.Close, true);
            if ClosureAccounts.Find('-') then begin
                repeat
                    SavingsAccounts.Get(ClosureAccounts."Account No.");
                    AccountType.Get(SavingsAccounts."Product Type");
                    LoanType.Reset;
                    LoanType.SetRange("Product Class Type", LoanType."Product Class Type"::Loan);
                    LoanType.SetRange("Appraisal Savings Product", AccountType."Product ID");
                    if LoanType.FindFirst then begin
                        repeat

                            Loans.Reset;
                            Loans.SetRange(Loans."Member No.", "Member No.");
                            Loans.SetRange("Loan Product Type", LoanType."Product ID");
                            Loans.SetFilter(Loans."Outstanding Balance", '>0');
                            if "Loans Option" = "Loans Option"::"Long Term" then
                                Loans.SetRange(Loans."Loan Span", Loans."Loan Span"::"Long Term")
                            else
                                if "Loans Option" = "Loans Option"::"Short Term" then
                                    Loans.SetRange(Loans."Loan Span", Loans."Loan Span"::"Short Term");
                            if Loans.Find('-') then begin
                                repeat
                                    Loans.CalcFields(Loans."Outstanding Balance", Loans."Outstanding Interest", "Outstanding Appraisal", "Outstanding Penalty", "Outstanding Loan Reg. Fee");
                                    IntTotal := IntTotal + Loans."Outstanding Interest";
                                    LoanTotal := LoanTotal + Loans."Outstanding Balance";
                                    Appraisal += Loans."Outstanding Appraisal";
                                    Penalty += Loans."Outstanding Penalty";
                                    "Loan Registration Fee" += Loans."Outstanding Loan Reg. Fee";
                                    if LType.Get(Loans."Loan Product Type") then
                                        if LType."Nature of Loan Type" = LType."Nature of Loan Type"::Defaulter then
                                            "Defaulter Loan" += (Loans."Outstanding Interest" + Loans."Outstanding Balance");

                                until Loans.Next = 0;
                            end;
                        until LoanType.Next = 0;
                    end;
                until ClosureAccounts.Next = 0
            end
            else begin
                //ERROR('Kindly update Which Accounts to Close First');
            end;


            "Total Loan" := LoanTotal;
            "Total Interest" := IntTotal;
            "Total Penalty" := Penalty;
            "Total Appraisal" := Appraisal;
        end;


        CalcFields("Total Savings");
        "Member Savings" := "Total Savings";
        "Total Charges" := GetCharges + GetWithdrawalFee();
        if "Charge Offset Fee" then
            "Total Charges" += Round(("Total Loan" + "Total Interest" - "Defaulter Loan") * GenSetup."Closure Loan Offset Fee %" / 100);
        if "Charge Rejoining Fee" then
            "Total Charges" += GenSetup."Rejoining Fee" + GetWithdrawalFee();
        if "Charge Membership Fee" then
            "Total Charges" += GenSetup."Registration Fee" + GetWithdrawalFee();
        if "Closure Type" = "Closure Type"::"Withdrawal - Death" then begin
            "Deposit Refundable" := "Member Savings" + "Insurance Amount" - "Total Charges" - "Total Loan" - "Total Interest" - "Total Appraisal" - "Total Penalty" - "Loan Registration Fee";
        end else begin
            "Deposit Refundable" := "Member Savings" - "Total Charges" - "Total Loan" - "Total Interest" - "Total Appraisal" - "Total Penalty" - "Loan Registration Fee";
        end;
    end;

    procedure GetWithdrawalFee(): Decimal
    var
        ChargeAmount: Decimal;
    begin
        If GenSetUp."Withdrawal Fee" <> '' then begin
            GenSetUp.TestField("Withdrawal Fee");

            TransactionTypes.Reset;
            TransactionTypes.SetRange(TransactionTypes."Code", GenSetUp."Withdrawal Fee");
            if TransactionTypes.Find('-') then begin
                //Charges
                TCharges := 0;
                TransactionCharges.Reset;
                TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionTypes."Code");
                if TransactionCharges.Find('-') then begin
                    //repeat


                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (Rec."Member Savings" * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Rec."Member Savings" >= TariffDetails."Lower Limit") and (Rec."Member Savings" <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then
                                        ChargeAmount := Rec."Member Savings" * TariffDetails.Percentage * 0.01
                                    else
                                        ChargeAmount := TariffDetails."Charge Amount"
                                end;

                            until TariffDetails.Next = 0;
                        end;
                    end;

                    if ChargeAmount < TransactionCharges."Minimum Amount" then
                        ChargeAmount := TransactionCharges."Minimum Amount";


                    if ChargeAmount > TransactionCharges."Maximum Amount" then
                        ChargeAmount := TransactionCharges."Maximum Amount";
                end;
            end;
        end;
        exit(ChargeAmount);
    end;




    procedure GetCharges(): Decimal
    var
        DepPresent: Boolean;
    begin

        TCharges := 0;
        DepPresent := false;
        ClosureAccounts.Reset;
        ClosureAccounts.SetRange(ClosureAccounts."No.", "No.");
        ClosureAccounts.SetRange(ClosureAccounts.Close, true);
        if ClosureAccounts.Find('-') then begin
            repeat
                if PFactory.Get(ClosureAccounts."Product Type") then
                    if PFactory."Product Category" = PFactory."Product Category"::"Deposit Contribution" then
                        DepPresent := true;
            until ClosureAccounts.Next = 0;
        end;

        AccountClosureFee := 0;
        ClosureAccounts.Reset;
        ClosureAccounts.SetRange(ClosureAccounts."No.", "No.");
        ClosureAccounts.SetRange(ClosureAccounts.Close, true);
        if ClosureAccounts.Find('-') then begin
            repeat
                PFactory.Reset;
                PFactory.SetRange("Product ID", ClosureAccounts."Product Type");
                if DepPresent then
                    PFactory.SetRange("Product Category", PFactory."Product Category"::"Deposit Contribution");
                if PFactory.FindFirst then begin
                    //IF ProdutFactory."Account Type"<>ProdutFactory."Account Type"::"Share Deposit Account" THEN BEGIN

                    Amount[2] := 0;
                    //CLosure Fee

                    TransactionCharges.Reset;
                    TransactionCharges.SetRange(TransactionCharges."Transaction Type", PFactory."Closure Fee");
                    if TransactionCharges.Find('-') then begin
                        repeat
                            Amount[1] := 0;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then
                                Amount[1] := ("Member Savings" * TransactionCharges."Percentage of Amount") * 0.01
                            else
                                Amount[1] := TransactionCharges."Charge Amount";

                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if ("Member Savings" >= TariffDetails."Lower Limit") and ("Member Savings" <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" then
                                                Amount[1] := "Member Savings" * TariffDetails.Percentage * 0.01
                                            else
                                                Amount[1] := TariffDetails."Charge Amount";
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;

                            Amount[2] += Amount[1];
                        until TransactionCharges.Next = 0;


                        if Amount[2] < TransactionCharges."Minimum Amount" then
                            Amount[2] := TransactionCharges."Minimum Amount";


                        if Amount[2] > TransactionCharges."Maximum Amount" then
                            Amount[2] := TransactionCharges."Maximum Amount";

                    end;

                    if ClosureAccounts.Balance <= 0 then
                        Amount[2] := 0;


                    AccountClosureFee += Amount[2];


                    //            MESSAGE('%1',AccountClosureFee);

                    //IF "Close Account"="Close Account"::All THEN
                    //  AccountClosureFee:=0;


                    if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                        //Excise Duty
                        AccountClosureFee += (Amount[2] * GenSetup."Excise Duty (%)" * 0.01);

                    end;

                end;


            until ClosureAccounts.Next = 0;

        end;
        //End of Close Accounts
        TCharges += AccountClosureFee;
        AccountClosureFee := 0;


        //*********************Premature Withdrawal
        MemberwithdrawalNotice.Reset;
        MemberwithdrawalNotice.SetRange(MemberwithdrawalNotice."Member No.", "Member No.");
        MemberwithdrawalNotice.SetRange(MemberwithdrawalNotice.Status, MemberwithdrawalNotice.Status::Approved);
        if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then
            if MemberwithdrawalNotice.Find('+') then begin
                if MemberwithdrawalNotice."Maturity Date" > "Closing Date" then begin
                    //GenSetup.TESTFIELD("Premature Withdrawal Fee");

                    TransactionTypes.Reset;
                    TransactionTypes.SetRange(Code, GenSetup."Premature Withdrawal Fee");
                    if TransactionTypes.Find('-') then begin

                        //Charges
                        TCharges := 0;

                        TransactionCharges.Reset;
                        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionTypes.Code);
                        if TransactionCharges.Find('-') then begin
                            repeat

                                AccountClosureFee := 0;
                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                    AccountClosureFee := ("Member Savings" * TransactionCharges."Percentage of Amount") * 0.01
                                else
                                    AccountClosureFee := TransactionCharges."Charge Amount";

                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                                    TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                    TariffDetails.Reset;
                                    TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                    if TariffDetails.Find('-') then begin
                                        repeat
                                            if ("Member Savings" >= TariffDetails."Lower Limit") and ("Member Savings" <= TariffDetails."Upper Limit") then begin
                                                if TariffDetails."Use Percentage" = true then
                                                    AccountClosureFee := "Member Savings" * TariffDetails.Percentage * 0.01
                                                else
                                                    AccountClosureFee := TariffDetails."Charge Amount"
                                            end;

                                        until TariffDetails.Next = 0;
                                    end;
                                end;

                                if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                                    //Excise Duty
                                    AccountClosureFee += (AccountClosureFee * GenSetup."Excise Duty (%)" * 0.01);

                                end;
                            until TransactionCharges.Next = 0;
                        end;
                    end;
                end;
            end;
        //^^
        TCharges += AccountClosureFee;
        AccountClosureFee := 0;





        /*
        IF "Close Account"="Close Account"::All THEN BEGIN
        
        
            GenSetup.TESTFIELD("Full Withdrawal Fee");
            Amount[2]:=0;
            //CLosure Fee
            AccountClosureFee:=0;
            TransactionCharges.RESET;
            TransactionCharges.SETRANGE(TransactionCharges."Transaction Type",GenSetup."Full Withdrawal Fee");
            IF TransactionCharges.FIND('-') THEN BEGIN
                REPEAT
                    Amount[1]:=0;
                    IF TransactionCharges."Charge Type"=TransactionCharges."Charge Type"::"% of Amount" THEN
                        Amount[1]:=("Member Savings"*TransactionCharges."Percentage of Amount")*0.01
                    ELSE
                        Amount[1]:=TransactionCharges."Charge Amount";
        
                    IF TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered THEN BEGIN
                        TransactionCharges.TESTFIELD(TransactionCharges."Staggered Charge Code");
                        TariffDetails.RESET;
                        TariffDetails.SETRANGE(TariffDetails.Code,TransactionCharges."Staggered Charge Code");
                        IF TariffDetails.FIND('-') THEN BEGIN
                            REPEAT
                                IF ("Member Savings" >= TariffDetails."Lower Limit") AND ("Member Savings"<= TariffDetails."Upper Limit") THEN BEGIN
                                    IF TariffDetails."Use Percentage" THEN
                                      Amount[1]:="Member Savings"*TariffDetails.Percentage*0.01
                                    ELSE
                                      Amount[1]:= TariffDetails."Charge Amount";
                                END;
                            UNTIL TariffDetails.NEXT =0;
                        END;
                    END;
        
                    IF Amount[1]<TransactionCharges."Minimum Amount" THEN
                    Amount[1]:=TransactionCharges."Minimum Amount";
        
        
                    IF Amount[1]>TransactionCharges."Maximum Amount" THEN
                    Amount[1]:=TransactionCharges."Maximum Amount";
        
        
                    Amount[2]+=Amount[1];
        
                    AccountClosureFee:=Amount[2];
        
                    Duty:=0;
                    IF TransactionCharges."Transaction Charge Category"<>TransactionCharges."Transaction Charge Category"::"Stamp Duty" THEN BEGIN
                        //Excise Duty
                        Duty:=(AccountClosureFee*GenSetup."Excise Duty (%)")*0.01;
                    END;
        
                    AccountClosureFee+=Duty;
        
                UNTIL TransactionCharges.NEXT = 0;
        
        
            END;
        END;
        
        TCharges+=AccountClosureFee;
        */


        exit(TCharges);

    end;
}

