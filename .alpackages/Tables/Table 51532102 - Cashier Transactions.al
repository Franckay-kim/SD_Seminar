table 51532102 "Cashier Transactions"
{
    //DrillDownPageID = "Cashier Transactions List";
    //LookupPageID = "Cashier Transactions List";

    fields
    {
        field(1; No; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin

                if No <> xRec.No then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Cashier Transaction Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Account No"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Account)) "Savings Accounts"."No."
            ELSE
            IF ("Account Type" = CONST("Non-Member")) "Bank Account"."No."
            ELSE
            IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE("Direct Posting" = CONST(true),
                                                                                                     "Income/Balance" = CONST("Income Statement"),
                                                                                                     "Account Category" = CONST(Income));

            trigger OnValidate()
            var
                InfoBase: Record "Information Base";
                Members: Record Members;
                AccountSig: Record "Account Signatories";
                JointMem: Record "Joint Members";
                ImageDat: Record "Image Data";
                ProdApp: Record "Product Applicable Categories";
                AccountCat: Option Single,Group,Business,Cell,Joint;
            begin
                //TESTFIELD("Member No.");

                Remarks := '';

                InfoBase.Reset();
                InfoBase.SetRange("Account No.", "Account No");
                If InfoBase.Find('-') then begin
                    repeat
                        Message(InfoBase.Info);
                    until InfoBase.Next = 0;
                end;
                ATMLinkingApplications.Reset;
                ATMLinkingApplications.SetRange("Account No", "Account No");
                ATMLinkingApplications.SetRange("Card Issued", false);
                if ATMLinkingApplications.Find('-') then begin
                    if ATMLinkingApplications."ATM Application No." <> '' then
                        Message('The ATM card is ready for collection');
                end;
                Amount := 0;
                "Available Balance" := 0;


                Account.Reset;
                if Account.Get("Account No") then begin
                    if (Account.Status <> Account.Status::New) and (Account.Status <> Account.Status::Active) and (Account.Status <> Account.Status::Dormant) then
                        Error(Text0001);
                    Account.CalcFields(Account.Balance);
                    "Global Dimension 1 Code" := Account."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Account."Global Dimension 2 Code";
                    "Account Status" := Account.Status;
                    "Mobile Phone No." := Account."Mobile Phone No";

                    "Account Name" := Account.Name;
                    Remarks := Account.Name;
                    Payee := Account.Name;
                    "Product Type" := Account."Product Type";
                    "Currency Code" := Account."Currency Code";
                    "ID No" := Account."ID No.";
                    "Member No." := Account."Member No.";
                    "Group Account" := false;
                    if Members.Get("Member No.") then begin
                        if Members."Customer Type" = Members."Customer Type"::Group then
                            "Group Account" := Members."Group Account";
                    end;

                    "Book Balance" := Account.Balance;
                    "Signing Instructions" := Account."Signing Instructions";
                    "Product Category" := Account."Product Category";
                    "Employer Code" := Account."Employer Code";


                    "Loan Defaulted" := 0;
                    Loans.Reset;
                    Loans.SetRange("Member No.", "Member No.");
                    Loans.SetFilter("Current Loans Category-SASRA", '<>%1&<>%2', Loans."Current Loans Category-SASRA"::Perfoming, Loans."Current Loans Category-SASRA"::Watch);
                    if Loans.FindFirst then begin
                        repeat
                            Loans.CalcFields("Outstanding Bills");
                            "Loan Defaulted" += Loans."Outstanding Bills";
                        until Loans.Next = 0;
                    end;

                end;


                if Members.Get("Member No.") then begin
                    case Members."Customer Type" of
                        Members."Customer Type"::Single:
                            AccountCat := AccountCat::Single;
                        Members."Customer Type"::Group:
                            AccountCat := AccountCat::Group;
                        Members."Customer Type"::Joint:
                            AccountCat := AccountCat::Joint;

                    end;
                    if Members."Customer Type" <> Members."Customer Type"::Joint then begin
                        ProdFact.Reset;
                        ProdFact.SetRange("Product Category", ProdFact."Product Category"::"Registration Fee");
                        ProdFact.SetFilter("Minimum Contribution", '>0');
                        if ProdFact.FindFirst then begin
                            Savings.Reset;
                            Savings.SetRange("Member No.", "Member No.");
                            Savings.SetRange("Product Type", ProdFact."Product ID");
                            if Savings.FindFirst then begin
                                Savings.CalcFields("Balance (LCY)");
                                if Savings."Balance (LCY)" < ProdApp.GetMinimumContribution(AccountCat, ProdFact."Product ID") /*ProdFact."Minimum Contribution"*/ then
                                    Message('Member has contributed entrance Fee of KES %1 instead of %2', Savings."Balance (LCY)", ProdApp.GetMinimumContribution(AccountCat, ProdFact."Product ID"));
                            end
                            else
                                Message('Member does not have an Entrance Fee Account. Kindly inform the System Administrator');
                        end;
                    end;

                end;


                ProdFact.Reset;
                ProdFact.SetRange("Product Category", ProdFact."Product Category"::"Share Capital");
                ProdFact.SetFilter("Minimum Contribution", '>0');
                if ProdFact.FindFirst then begin
                    Savings.Reset;
                    Savings.SetRange("Member No.", "Member No.");
                    Savings.SetRange("Product Type", ProdFact."Product ID");
                    if Savings.FindFirst then begin
                        Savings.CalcFields("Balance (LCY)");
                        if Savings."Balance (LCY)" < ProdFact."Minimum Contribution" then
                            Message('Member has contributed Share Capital of KES %1 instead of %2', Savings."Balance (LCY)", ProdFact."Minimum Contribution");
                    end
                    else
                        Message('Member does not have an Share Capital Account. Kindly inform the System Administrator');
                end;


                CalcAvailableBal;
                if "Account Type" = "Account Type"::"G/L Account" then begin
                    "Account Name" := '';
                    if GL.Get("Account No") then
                        "Account Name" := GL.Name;
                end;
                Modify;
                //waumini validations requested
                if Members.Get("Member No.") then begin

                    case Members."Customer Type" of
                        Members."Customer Type"::Single:
                            begin
                                if Rec."ID No" = '' then
                                    Error('This member does not have an ID No.');
                                if rec."Mobile Phone No." = '' then
                                    Error('This member does not have a mobile phone no');
                                // Rec.TestField("ID No");
                                //Rec.TestField("Mobile Phone No.");
                                ImageDat.Reset();
                                ImageDat.SetRange("Member No", "Member No.");
                                if ImageDat.Find('-') then begin
                                    ImageDat.CalcFields(Picture, Signature);
                                    if ImageDat.Signature.HasValue = false then
                                        Error('This member does not have a signature. Define one to proceed');
                                    if ImageDat.Picture.HasValue = false then
                                        Error('This member does not have a picture. Define one to proceed');
                                end else begin
                                    Error('This member does not have photo and signature');
                                end;

                            end;
                        Members."Customer Type"::Joint:
                            begin
                                JointMem.Reset();
                                JointMem.SetRange("Account No", "Member No.");
                                IF JointMem.Find('-') = false then
                                    Error('This joint account does not have joint members specified');
                            end;
                        Members."Customer Type"::"Group":
                            begin
                                AccountSig.Reset();
                                AccountSig.SetRange("Account No", "Member No.");
                                if AccountSig.Find('-') = false then
                                    Error('This group account does not have signatories defined');
                            end;

                    end;
                end;
            end;
        }
        field(3; "Account Name"; Text[150])
        {
        }
        field(4; "Transaction Type"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Account),
                                "Mobile Transaction" = CONST(false)) "Transaction Types".Code WHERE("Product Type" = FIELD("Product Type"),
                                                                                                   Category = CONST(Cashier),
                                                                                                   "Default Mode" = FIELD("Transaction Mode"))
            ELSE
            IF ("Account Type" = CONST("Non-Member")) "Transaction Types".Code WHERE(Type = FILTER("Bankers Cheque"),
                                                                                                                                                                                "Product Type" = FILTER(''),
                                                                                                                                                                                "Default Mode" = FIELD("Transaction Mode"))
            ELSE
            IF ("Account Type" = CONST("G/L Account")) "Transaction Types".Code WHERE(Type = FILTER("Income Transactions" | "Cheque Deposit"),
                                                                                                                                                                                                                                                              "Product Type" = FILTER(''),
                                                                                                                                                                                                                                                              "Default Mode" = FIELD("Transaction Mode"))
            ELSE
            IF ("Account Type" = CONST(Account),
                                                                                                                                                                                                                                                                       "Mobile Transaction" = CONST(true)) "Transaction Types".Code WHERE(Type = CONST("Mobile Transaction"));

            trigger OnValidate()
            begin

                if TransactionTypes.Get("Transaction Type") then begin
                    "Transaction Description" := TransactionTypes.Description;
                    Type := TransactionTypes.Type;
                    Remarks := Format(Type);

                end;


                if (Type = Type::"Credit Cheque") or (Type = Type::"Cheque Deposit") then begin

                    Members.Reset;
                    Members.SetRange("No.", "Member No.");
                    Members.SetFilter("Cheques Bounced", '>0');
                    if Members.FindFirst then begin
                        Members.CalcFields("Cheques Bounced");
                        Message('Please NOTE that this Member Deposited %1 Cheques that bounced ', Members."Cheques Bounced");
                    end;

                    BUserSetup.Reset;
                    BUserSetup.SetRange(BUserSetup.UserID, UserId);
                    if BUserSetup.Find('-') then begin
                        BUserSetup.TestField("Default  Cheque Bank");
                        "Bank Account" := BUserSetup."Default  Cheque Bank";
                    end;
                end;

                CalcAvailableBal;
            end;
        }
        field(5; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if Amount < 0 then
                    Error('Amount cannot be less than zero');
                CalcAvailableBal;
                if (Type = Type::"Cash Withdrawal") then begin
                    if "New Account Balance" < 0 then Error('Transaction will result in overdrawing of acount');
                end;
                if TransactionTypes.Get("Transaction Type") then begin
                    IF TransactionTypes."Upper Limit" > 0 then
                        IF Amount > TransactionTypes."Upper Limit" then
                            Error('Amount Exceeds Transaction Type Upper Limit');

                end;
            end;
        }
        field(6; Cashier; Code[50])
        {
            Editable = false;
        }
        field(7; "Transaction Date"; Date)
        {
            Editable = false;
        }
        field(8; "Transaction Time"; Time)
        {
            Editable = false;
        }
        field(9; Posted; Boolean)
        {
        }
        field(10; "No. Series"; Code[20])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(11; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class Type" = CONST(Savings));
        }
        field(12; "Cheque Type"; Code[20])
        {
            TableRelation = "Cheque Types";

            trigger OnValidate()
            begin
                TestField(Amount);
                if ChequeTypes.Get("Cheque Type") then begin
                    //Added by ckigen
                    if (ChequeTypes."Cheque Limit" <> 0) and (Amount > ChequeTypes."Cheque Limit") then
                        Error(Text0003, ChequeTypes."Cheque Limit");
                    //Remarks:=ChequeTypes.Description;
                    CDays := ChequeTypes."Clearing  Days";

                    EMaturity := "Transaction Date";
                    if i < CDays then begin
                        repeat
                            EMaturity := CalcDate('1D', EMaturity);
                            if (Date2DWY(EMaturity, 1) <> 6) and (Date2DWY(EMaturity, 1) <> 7) then
                                i := i + 1;

                        until i = CDays;
                    end;

                    "Expected Maturity Date" := EMaturity;

                    "Cheque Status" := "Cheque Status"::Pending;
                end;
            end;
        }
        field(13; "Cheque No"; Code[6])
        {

            trigger OnValidate()
            begin
                /*//Commented for ukristo, for reusing of cheques
                CashierTransactions.RESET;
                CashierTransactions.SETRANGE("Account No","Account No");
                CashierTransactions.SETRANGE("Bank Account","Bank Account");
                CashierTransactions.SETRANGE("Cheque No","Cheque No");
                CashierTransactions.SETRANGE("Cheque Category",CashierTransactions."Cheque Category"::"Customer Cheque");
                IF CashierTransactions.FIND('-') THEN
                  BEGIN
                    ERROR('The cheque No. %1 has already been posted to %2 on %3',CashierTransactions."Cheque No",CashierTransactions."Account No",CashierTransactions."Transaction Date");
                    END;
                    */
                if StrLen("Cheque No") <> 6 then
                    Error('Cheque No must be equal to 6 digits');

                if "Cheque No" = '000000' then
                    Error('Invalid Cheque No.');

            end;
        }
        field(14; "Cheque Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Cheque Date" > Today then
                    Error('Post dating not allowed');
                CashOfficeSetup.Get;
                if "Cheque Date" < CalcDate('-' + Format(CashOfficeSetup."Cheque Reject Period"), Today) then
                    if not Confirm(Text0002 + 'Do you want to continue?') then
                        Error('Cancelled');
            end;
        }
        field(15; Payee; Text[100])
        {
        }
        field(16; Remarks; Text[100])
        {
        }
        field(17; Type; Option)
        {
            OptionCaption = 'Cash Deposit,Cash Withdrawal,Credit Receipt,Credit Cheque,Bankers Cheque,Cheque Deposit,Cheque Withdrawal,Salary Processing,EFT,RTGS,Overdraft,Standing Order,Dividend,Msacco Balance Enquiry,Msacco Deposit,Msacco Ministatement,Msacco Transfer,Msacco Withdrawal,Msacco Registration,Msacco Charge,Transfers,ATM Applications,Member Withdrawal,ATM Replacement,Statement,Bounced Cheque,Lien,Cheque Application,Bank Transfer Mode,Sacco_Co-op Charge,Savings Penalty,Delegates Payment,Msacco Sms,Income Transactions,Cheque Unpay,Inhouse Cheque Transfer,Mobile Transaction';
            OptionMembers = "Cash Deposit","Cash Withdrawal","Credit Receipt","Credit Cheque","Bankers Cheque","Cheque Deposit","Cheque Withdrawal","Salary Processing",EFT,RTGS,Overdraft,"Standing Order",Dividend,"Msacco Balance Enquiry","Msacco Deposit","Msacco Ministatement","Msacco Transfer","Msacco Withdrawal","Msacco Registration","Msacco Charge",Transfers,"ATM Applications","Member Withdrawal","ATM Replacement",Statement,"Bounced Cheque",Lien,"Cheque Application","Bank Transfer Mode","Sacco_Co-op Charge","Savings Penalty","Delegates Payment","Msacco Sms","Income Transactions","Cheque Unpay","Inhouse Cheque Transfer","Mobile Transaction";
        }
        field(18; "Transaction Description"; Text[50])
        {
        }
        field(19; Status; Option)
        {
            Caption = 'Transaction Status';
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(20; "Date Posted"; Date)
        {
        }
        field(21; "Time Posted"; Time)
        {
        }
        field(22; "Posted By"; Code[50])
        {
        }
        field(23; "Expected Maturity Date"; Date)
        {
        }
        field(24; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(25; "Post Dated"; Boolean)
        {
        }
        field(26; "Book Balance"; Decimal)
        {
            Editable = false;
        }
        field(27; Overdraft; Boolean)
        {
        }
        field(28; "Protected Account"; Boolean)
        {
        }
        field(29; "Member No."; Code[20])
        {
            TableRelation = Members."No." WHERE("Customer Type" = FILTER(<> Cell));

            trigger OnValidate()
            begin
                "Account No" := '';
            end;
        }
        field(30; "Banked By"; Code[50])
        {
        }
        field(31; "Date Banked"; Date)
        {
        }
        field(32; "Time Banked"; Time)
        {
        }
        field(33; "Cleared By"; Code[50])
        {
        }
        field(34; "Date Cleared"; Date)
        {
        }
        field(35; "Time Cleared"; Time)
        {
        }
        field(36; "ID No"; Code[50])
        {
        }
        field(37; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                // VALIDATE("Cheque No");
                // IF BankAccount.GET("Bank Account") THEN MESSAGE('here');
                //  "Cheque Issueing Bank":=BankAccount.Name;
            end;
        }
        field(38; Printed; Boolean)
        {
        }
        field(39; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(40; "Available Balance"; Decimal)
        {
        }
        field(41; "Attempted Self Transaction"; Boolean)
        {
        }
        field(42; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility CenterBR";
        }
        field(43; "Change Log"; Integer)
        {
        }
        field(44; "Cheque Status"; Option)
        {
            OptionCaption = 'Pending,Stopped,Bounced,Honoured,Matured,Reversed';
            OptionMembers = Pending,Stopped,Bounced,Honoured,Matured,Reversed;
        }
        field(45; "Bankers Cheque No"; Code[6])
        {
            TableRelation = "Bankers Cheques Register"."Cheque No." where(Status = const(Pending), "Global Dimension 2 Code" = field("Global Dimension 2 Code"));
        }
        field(46; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(47; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(48; "Allocated Amount"; Decimal)
        {
            CalcFormula = Sum("Cashier Transaction Lines".Amount WHERE("Transaction No" = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "FingerPrint Verified"; Boolean)
        {
            Editable = false;
        }
        field(50002; SystemGeneratedGuid; Guid)
        {
        }
        field(50003; Select; Boolean)
        {
        }
        field(50004; "Discounting Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Cheque Status" <> "Cheque Status"::Pending then
                    Error('You can only discount a pending cheque');

                if "Discounting Amount" < 0 then
                    Error('Amount must be greater than zero');


                ProdF.Reset;
                ProdF.SetRange(ProdF."Type of Discounting", ProdF."Type of Discounting"::"Cheque Discounting");
                ProdF.SetRange(ProdF."Product Class Type", ProdF."Product Class Type"::Loan);
                if ProdF.Find('-') then begin
                    ProdF.TestField(ProdF."Discounting %");
                    ProdF.TestField(ProdF."Interest Rate (Min.)");
                    ProdF.TestField(ProdF."Maximum Loan Amount");

                    if "Discounting Amount" > ProdF."Maximum Loan Amount" then
                        Error('The amount cannot be more than %1', ProdF."Maximum Loan Amount");
                end else
                    Error('Discounting loan product not found.');


                if (Amount * ProdF."Discounting %" / 100) < ("Discounted Amount" + "Discounting Amount") then
                    Error('You can only discount upto %1.', (Amount * ProdF."Discounting %" / 100) - "Discounted Amount");


                "Cheque Discounting" := true;
            end;
        }
        field(50005; "Discounted Amount"; Decimal)
        {
        }
        field(50006; "Expiry Date"; Date)
        {
        }
        field(50007; "Signing Instructions"; Option)
        {
            OptionMembers = "Any Two","Any Three",All;
        }
        field(50008; "Till Name"; Code[50])
        {
            Editable = false;
        }
        field(50009; "Product Category"; Option)
        {
            OptionCaption = ' ,Share Capital,Deposit Contribution,Fixed Deposit,Junior Savings,Registration Fee';
            OptionMembers = " ","Share Capital","Deposit Contribution","Fixed Deposit","Junior Savings","Registration Fee";
        }
        field(50010; "Till Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                bankacc.Reset;
                bankacc.SetRange("No.", "Till Code");
                if bankacc.Find('-') then begin
                    "Till Name" := PadStr("Till Code" + ' ' + bankacc.Name, 50)
                end;
            end;
        }
        field(50011; "New Account Balance"; Decimal)
        {
        }
        field(50012; "Employer Code"; Code[20])
        {
        }
        field(50013; Dublicate; Boolean)
        {
        }
        field(50014; "Cheque Issuing Bank"; Text[100])
        {
        }
        field(50015; "Info Base Area"; Text[250])
        {

        }
        field(50016; "Drawer Name"; Text[100])
        {
        }
        field(50017; "Account Type"; Option)
        {
            OptionCaption = 'Account,Non-Member,G/L Account,Multiple,Deposit Slip';
            OptionMembers = Account,"Non-Member","G/L Account",Multiple,"Deposit Slip";

            trigger OnValidate()
            begin
                ClearAll;
                if "Account Type" = "Account Type"::"Non-Member" then begin
                    BUserSetup.Reset;
                    BUserSetup.SetRange(BUserSetup.UserID, UserId);
                    if BUserSetup.Find('-') then begin
                        "Till Code" := BUserSetup."Default  Bank";
                        bankacc.Reset;
                        bankacc.SetRange("No.", BUserSetup."Default  Bank");
                        if bankacc.Find('-') then begin
                            "Account No" := bankacc."No.";
                            "Till Name" := PadStr(BUserSetup."Default  Bank" + ' ' + bankacc.Name, 50)
                        end;
                    end;
                end;

                if "Account Type" = "Account Type"::"Non-Member" then
                    "Account Name" := Format("Account Type");
                if "Account Type" = "Account Type"::"G/L Account" then begin
                    Type := Type::"Income Transactions";
                    Remarks := Format(Type);
                end;
                if "Account Type" = "Account Type"::"Deposit Slip" then begin
                    "Till Code" := '';
                    "Till Name" := '';
                end;
                if "Account Type" = "Account Type"::Account then begin

                    BUserSetup.Reset;
                    BUserSetup.SetRange(BUserSetup.UserID, UserId);
                    if BUserSetup.Find('-') then begin
                        "Till Code" := BUserSetup."Default  Bank";

                        //BUserSetup.TESTFIELD(Type,BUserSetup.Type::Cashier);
                        bankacc.Reset;
                        bankacc.SetRange("No.", BUserSetup."Default  Bank");
                        if bankacc.Find('-') then begin
                            "Till Name" := PadStr(BUserSetup."Default  Bank" + ' ' + bankacc.Name, 50)
                        end;

                    end;
                end;

                if "Account Type" <> "Account Type"::"Deposit Slip" then begin
                    "Reference No" := '';
                    TransLines.Reset;
                    TransLines.SetRange("Transaction No", No);
                    TransLines.SetFilter("Deposit Slip Ref No", '<>%1', '');
                    if TransLines.FindFirst then begin
                        TransLines.DeleteAll;
                    end;
                end;
            end;
        }
        field(50018; "Lien Loan No."; Code[30])
        {
            TableRelation = Loans;
        }
        field(50019; "Special Cheque Charge"; Decimal)
        {
        }
        field(50020; "Cheque Location"; Option)
        {
            OptionCaption = 'Teller,Chief Cashier 1,Accountant,Awaiting Clearance,Cleared,Chief Cashier 2';
            OptionMembers = Teller,"Chief Cashier 1",Accountant,"Awaiting Clearance",Cleared,"Chief Cashier 2";
        }
        field(50021; "Chief Cashier Select"; Boolean)
        {
        }
        field(50022; "Bankers Cheque Type"; Option)
        {
            OptionCaption = 'Co-op Bankers Cheque,Customer Service Cheques';
            OptionMembers = "Co-op Bankers Cheque","Customer Service Cheques";
        }
        field(50023; "Transaction Mode"; Option)
        {
            OptionCaption = 'Cash,Cheque';
            OptionMembers = Cash,Cheque;

            trigger OnValidate()
            begin

                "Cheque Category" := "Cheque Category"::" ";

                if "Transaction Mode" = "Transaction Mode"::Cheque then begin
                    BUserSetup.Reset;
                    BUserSetup.SetRange(BUserSetup.UserID, UserId);
                    if BUserSetup.Find('-') then begin
                        if BUserSetup.Type = BUserSetup.Type::Cashier then
                            "Cheque Category" := "Cheque Category"::"Customer Cheque"
                        else
                            if BUserSetup.Type = BUserSetup.Type::Treasury then
                                "Cheque Category" := "Cheque Category"::"Sacco Cheque";
                    end;
                end;
            end;
        }
        field(50024; "Account Status"; Option)
        {
            OptionCaption = ' ,New,Active,Dormant,Frozen,Withdrawal Application,Withdrawn,Deceased,Defaulter,Closed,Blocked';
            OptionMembers = " ",New,Active,Dormant,Frozen,"Withdrawal Application",Withdrawn,Deceased,Defaulter,Closed,Blocked;
        }
        field(50025; "Mobile Phone No."; Code[30])
        {
        }
        field(50026; "Bouncing Charge"; Code[20])
        {
            //TableRelation = "Cheque Return Codes"."Return Code";
        }
        field(50027; Mpesa; Boolean)
        {
        }
        field(50028; "Mpesa/Agent Transaction"; Option)
        {
            OptionCaption = ' ,Deposit,Withdrawal';
            OptionMembers = " ",Deposit,Withdrawal;

            trigger OnValidate()
            begin
                Amount := 0;
                if "Agent Transaction" = "Agent Transaction"::MPESA then
                    TestField("Mpesa/Agent Transaction");
            end;
        }
        field(50029; "Source Account No."; Code[20])
        {
            TableRelation = "Savings Accounts";
        }
        field(50030; "Cheques Issued"; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(50031; "Cheques Received"; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(50032; "Issueing Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                Validate("Cheque No");
                if BankAccount.Get("Bank Account") then
                    "Cheque Issuing Bank" := BankAccount.Name;
                if "Account Type" = "Account Type"::Multiple then
                    if BankAccount.Get("Issueing Bank Account") then "Cheque Issuing Bank" := BankAccount.Name;
            end;
        }
        field(50033; "Loan Defaulted"; Decimal)
        {
        }
        field(50034; "Mobile Transaction"; Boolean)
        {
        }
        field(50035; "Total Deposits"; Decimal)
        {
            CalcFormula = Sum("Cashier Transaction Lines".Amount WHERE("Transaction No" = FIELD(No),
                                                                        Transaction = CONST(Deposit)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50036; "Total Withdrawals"; Decimal)
        {
            CalcFormula = Sum("Cashier Transaction Lines".Amount WHERE("Transaction No" = FIELD(No),
                                                                        Transaction = CONST(Withdrawal)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50037; "Deposits Count"; Integer)
        {
            CalcFormula = Count("Cashier Transaction Lines" WHERE("Transaction No" = FIELD(No),
                                                                   Transaction = CONST(Deposit)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50038; "Withdrawals Count"; Integer)
        {
            CalcFormula = Count("Cashier Transaction Lines" WHERE("Transaction No" = FIELD(No),
                                                                   Transaction = CONST(Withdrawal)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50039; "Total Charge Amount"; Decimal)
        {
        }
        field(50040; "Date Reversed"; Date)
        {
        }
        field(50041; "Reversed By"; Code[50])
        {
        }
        field(50042; "Cheque Category"; Option)
        {
            OptionCaption = ' ,Customer Cheque,Sacco Cheque';
            OptionMembers = " ","Customer Cheque","Sacco Cheque";

            trigger OnValidate()
            begin

                if "Transaction Mode" = "Transaction Mode"::Cheque then begin
                    BUserSetup.Reset;
                    BUserSetup.SetRange(BUserSetup.UserID, UserId);
                    if BUserSetup.Find('-') then begin
                        if BUserSetup.Type = BUserSetup.Type::Cashier then
                            if "Cheque Category" <> "Cheque Category"::"Customer Cheque" then
                                if not Confirm('Applicable to Cashiers only. Do you want to continue?') then
                                    Error('Aborted');

                        if BUserSetup.Type = BUserSetup.Type::Treasury then
                            if "Cheque Category" <> "Cheque Category"::"Sacco Cheque" then
                                if not Confirm('Applicable to Treasury only. Do you want to continue?') then
                                    Error('Aborted');

                    end;
                end;
            end;
        }
        field(50043; "Selected By"; Code[50])
        {
        }
        field(50044; "Group Account"; Boolean)
        {
        }
        field(50045; "Cheque Discounting"; Boolean)
        {
        }
        field(50046; "Cheque Clearing Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(50047; "Cheque Clearing Date"; Date)
        {
        }
        field(50048; "Agent Transaction"; Option)
        {
            OptionCaption = ' ,MPESA,Coop Jirani';
            OptionMembers = " ",MPESA,"Coop Jirani";

            trigger OnValidate()
            begin

                "Till Code" := '';
                "Account No" := '';
                "Account Name" := '';
                "Till Name" := '';

                if "Agent Transaction" = "Agent Transaction"::MPESA then begin
                    BUserSetup.Get(UserId);
                    if "Agent Transaction" = "Agent Transaction"::MPESA then begin
                        BUserSetup.TestField("MPesa Bank Account");
                        BUserSetup.TestField("MPesa Customer Account");
                        "Till Code" := BUserSetup."MPesa Bank Account";
                        //          "Account No":=BUserSetup."MPesa Customer Account";
                        //          Cust.GET("Account No");
                        //          "Account Name":=Cust.Name;
                        bankacc.Get(BUserSetup."MPesa Bank Account");
                        bankacc.CalcFields("Balance (LCY)");
                        "Till Name" := bankacc.Name;
                        "Book Balance" := bankacc."Balance (LCY)";
                    end;
                    if "Agent Transaction" = "Agent Transaction"::"Coop Jirani" then begin
                        BUserSetup.TestField("Co-op Jirani Bank Account");
                        BUserSetup.TestField("Co-op Jirani Customer Account");
                        "Till Code" := BUserSetup."Co-op Jirani Bank Account";
                        "Account No" := BUserSetup."Co-op Jirani Customer Account";
                        Cust.Get("Account No");
                        "Account Name" := Cust.Name;
                        bankacc.Get(BUserSetup."Co-op Jirani Bank Account");
                        "Till Name" := bankacc.Name;
                    end;

                end;
            end;
        }
        field(50049; "MPESA Transaction No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Drawer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50051; "Drawer Bank"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PR Bank Accounts"."Bank Code";

            trigger OnValidate()
            begin
                PrBank.Reset;
                PrBank.SetRange("Bank Code", "Drawer Bank");
                if PrBank.FindFirst then
                    "Drawer Bank Name" := PrBank."Bank Name";
            end;
        }
        field(50052; Banked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50053; "Reference No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Deposit Slip"."Document No" WHERE(Processed = CONST(false),
                                                                "Generated By" = FILTER(''));

            trigger OnValidate()
            begin
                TransLines.Reset;
                TransLines.SetRange("Transaction No", No);
                if TransLines.FindFirst then begin
                    TransLines.DeleteAll;
                end;
                DepSlip.Reset;
                DepSlip.SetRange(DepSlip."Document No", "Reference No");
                DepSlip.SetRange(Processed, false);
                if DepSlip.FindFirst then begin
                    repeat
                        TransLines.Init;
                        TransLines."Transaction No" := No;
                        TransLines.Amount := DepSlip.Amount;
                        TransLines.Description := DepSlip.Description;
                        TransLines."Deposit Slip Ref No" := DepSlip."Reference No";
                        TransLines.Insert;
                        DepSlip."Generated By" := UserId;
                        DepSlip."Date generated" := Today;
                        DepSlip."Transaction No" := No;
                        DepSlip.Modify;
                    until DepSlip.Next = 0;
                end;
            end;
        }
        field(50054; "Drawer Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50055; "Stop Cheque Reason"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50056; "Deposit By"; Text[100])
        {

        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('You cannot delete this transaction');
    end;

    trigger OnInsert()
    begin

        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Cashier Transaction Nos.");
            NoSeriesMgt.InitSeries(NoSetup."Cashier Transaction Nos.", xRec."No. Series", 0D, No, "No. Series");
        end;

        Cashier := UpperCase(UserId);
        "Transaction Date" := Today;
        "Transaction Time" := Time;


        BUserSetup.Reset;
        BUserSetup.SetRange(BUserSetup.UserID, UserId);
        if BUserSetup.Find('-') then begin
            "Till Code" := BUserSetup."Default  Bank";

            //BUserSetup.TESTFIELD(Type,BUserSetup.Type::Cashier);
            bankacc.Reset;
            bankacc.SetRange("No.", BUserSetup."Default  Bank");
            if bankacc.Find('-') then begin
                "Till Name" := PadStr(BUserSetup."Default  Bank" + ' ' + bankacc.Name, 50)
            end;


        end;

        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        if UserSetup.Find('-') then begin
            // UserSetup.TestField(UserSetup."Global Dimension 1 Code");
            // UserSetup.TestField(UserSetup."Global Dimension 2 Code");


            //"Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            // "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
            // "Responsibility Center" := UserSetup."Responsibility Centre";
        end;
        i := 0;
        CashierTrans.Reset;
        CashierTrans.SetRange(Cashier, UserId);
        CashierTrans.SetFilter(Posted, '%1', false);
        CashierTrans.SetRange(Mpesa, false);
        if CashierTrans.Find('-') then begin
            repeat
                i += 1;
                OPenrecords := CashierTrans.No;
            until CashierTrans.Next = 0;
        end;

        BUserSetup.Get(UserId);
        if i > BUserSetup."No of Open Transactions" then Error('You are not allowed to open multiple applications.Complete %1 first.', OPenrecords);
    end;

    var
        NoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Account: Record "Savings Accounts";
        TransactionTypes: Record "Transaction Types";
        Text0001: Label 'The account is not active and therefore cannot be transacted upon.';
        ChequeTypes: Record "Cheque Types";
        CDays: Integer;
        EMaturity: Date;
        i: Integer;
        UserSetup: Record "User Setup";
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charges";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Lines";
        Trans: Record "Cashier Transactions";
        TChargeAmount: Decimal;
        GenSetup: Record "General Set-Up";
        AccountTypes: Record "Product Factory";
        TransType: Record "Transaction Types";
        BUserSetup: Record "Banking User Template";
        ProdF: Record "Product Factory";
        bankacc: Record "Bank Account";
        CashOfficeSetup: Record "Cash Office Setup";
        Text0002: Label 'The cheque has expired';
        Text0003: Label 'The cheque limit should not exceed the cheque amount limit of %1';
        BankAccount: Record "Bank Account";
        CashierTransactions: Record "Cashier Transactions";
        ATMLinkingApplications: Record "ATM Linking Applications";
        CashierTrans: Record "Cashier Transactions";
        OPenrecords: Code[20];
        GL: Record "G/L Account";
        // PeriodicActivities: Codeunit "Periodic Activities";
        Cust: Record Customer;
        ProdFact: Record "Product Factory";
        Savings: Record "Savings Accounts";
        Members: Record Members;
        Loans: Record Loans;
        DepSlip: Record "Deposit Slip";
        TransLines: Record "Cashier Transaction Lines";
        PrBank: Record "PR Bank Accounts";

    local procedure CalcAvailableBal()
    var
        TCharges: Decimal;
        AvailableBalance: Decimal;
        MinBalance: Decimal;
        Account: Record "Savings Accounts";
        ProdType: Record "Product Factory";
    // PeriodicActivities: Codeunit "Periodic Activities";
    begin



        "Available Balance" := 0;
        MinBalance := 0;

        if Account.Get("Account No") then begin
            Account.CALCFIELDS(Account.Balance, Account."Uncleared Cheques", Account."Authorised Over Draft", Account."Lien Placed");

            ProdType.Reset;
            ProdType.SetRange(ProdType."Product ID", "Product Type");
            if ProdType.Find('-') then begin
                MinBalance := ProdType."Minimum Balance";

                "Available Balance" := (Account.Balance + Account."Authorised Over Draft") - (MinBalance + Account."Uncleared Cheques" + Account."Lien Placed");

                // "Available Balance" := PeriodicActivities.GetAccountBalance(Account."No.");

                if Amount = 0 then
                    CalcCharges("Available Balance")
                else
                    CalcCharges(Amount);

                "Available Balance" -= TChargeAmount;

                "Total Charge Amount" := TChargeAmount;
                if Type = Type::"Cash Withdrawal" then
                    "New Account Balance" := "Available Balance" - Amount
                else
                    if Type = Type::"Cash Deposit" then
                        "New Account Balance" := "Available Balance" + Amount
                    else
                        if Type = Type::"Bankers Cheque" then
                            "New Account Balance" := "Available Balance" - Amount;

            end;
        end;
    end;

    local procedure CalcCharges(TransAmount: Decimal)
    begin

        GenSetup.Get;

        TChargeAmount := 0;



        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");
        if TransactionCharges.Find('-') then begin
            repeat

                ChargeAmount := 0;

                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin


                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (TransAmount * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (TransAmount >= TariffDetails."Lower Limit") and (TransAmount <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := Amount * TariffDetails.Percentage * 0.01;
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;

                    TChargeAmount := TChargeAmount + ChargeAmount;

                    if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin

                        //Excise Duty

                        TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                        ;
                    end;
                end;
            until TransactionCharges.Next = 0;
        end;



        //Charge withdrawal Frequency
        if Type = Type::"Cash Withdrawal" then begin
            if Account.Get("Account No") then begin
                if AccountTypes.Get(Account."Product Type") then begin
                    if Account."Last Withdrawal Date" <> 0D then begin
                        if CalcDate(AccountTypes."Withdrawal Interval", Account."Last Withdrawal Date") > Today then begin
                            //IF CALCDATE(AccountTypes."Withdrawal Interval",Account."Last Withdrawal Date") <= CALCDATE('1D',TODAY) THEN BEGIN



                            TransactionCharges.Reset;
                            TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");
                            if TransactionCharges.Find('-') then begin
                                repeat

                                    if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Withdrawal Frequency") then begin



                                        ChargeAmount := 0;
                                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                            ChargeAmount := (TransAmount * TransactionCharges."Percentage of Amount") * 0.01
                                        else
                                            ChargeAmount := TransactionCharges."Charge Amount";

                                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                                            TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                            TariffDetails.Reset;
                                            TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                            if TariffDetails.Find('-') then begin
                                                repeat
                                                    if (TransAmount >= TariffDetails."Lower Limit") and (TransAmount <= TariffDetails."Upper Limit") then begin
                                                        if TariffDetails."Use Percentage" = true then begin
                                                            ChargeAmount := TransAmount * TariffDetails.Percentage * 0.01;
                                                        end else begin
                                                            ChargeAmount := TariffDetails."Charge Amount";
                                                        end;
                                                    end;
                                                until TariffDetails.Next = 0;
                                            end;
                                        end;


                                        TChargeAmount := TChargeAmount + ChargeAmount;


                                        if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin

                                            //Excise Duty


                                            TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                                        end;
                                    end;
                                until TransactionCharges.Next = 0;
                            end;

                        end;


                    end;
                end;
            end;
        end;
        //Charge withdrawal Frequency



        //Penalty of maximum amount on transaction
        if Type = Type::"Cash Withdrawal" then begin
            if TransType.Get("Transaction Type") then begin

                Trans.Reset;
                Trans.SetRange(Trans."Transaction Date", Today);
                Trans.SetRange(Trans."Account No", "Account No");
                Trans.SetRange(Posted, true);
                Trans.SetRange(Trans.Type, Trans.Type::"Cash Withdrawal");
                if Trans.FindSet then begin
                    Trans.CalcSums(Trans.Amount);


                end;
            end;

            if Trans.Amount > TransType."Upper Limit" then begin


                //Charges
                TCharges := 0;

                TransactionCharges.Reset;
                TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");
                if TransactionCharges.Find('-') then begin
                    repeat

                        if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Withdrawn Amount") then begin



                            ChargeAmount := 0;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                ChargeAmount := (TransAmount * TransactionCharges."Percentage of Amount") * 0.01
                            else
                                ChargeAmount := TransactionCharges."Charge Amount";

                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                                TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if (TransAmount >= TariffDetails."Lower Limit") and (TransAmount <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" = true then begin
                                                ChargeAmount := TransAmount * TariffDetails.Percentage * 0.01;
                                            end else begin
                                                ChargeAmount := TariffDetails."Charge Amount";
                                            end;
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;

                            TChargeAmount := TChargeAmount + ChargeAmount;

                            if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin

                                //Excise Duty

                                TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                            end;
                        end;
                    until TransactionCharges.Next = 0;
                end;
            end;
        end;

        //Penalty of maximum amount on transaction
    end;

    procedure ClearAll()
    begin
        "Account No" := '';
        "Member No." := '';
        "Account Name" := '';
        "Info Base Area" := '';
        Amount := 0;
        "Transaction Type" := '';
        //Type:=Type::" ";
        "ID No" := '';
        "Book Balance" := 0;
        "Available Balance" := 0;
        "New Account Balance" := 0;
        Remarks := '';
        "Signing Instructions" := "Signing Instructions"::"Any Two";
        "Cheque Date" := 0D;
        "Cheque No" := '';
        "Product Type" := '';
    end;

    /// <summary>
    /// PostCredit.
    /// </summary>
    /// <param name="CashierTrans">Record "Cashier Transactions".</param>
    /// <param name="JTemplate">Text.</param>
    /// <param name="JBatch">Text.</param>
    /// <param name="TillNumber">Text.</param>
    /// <param name="DBranch">Text.</param>
    /// <param name="DActivity">Text.</param>
    /// <param name="Isposted">VAR Boolean.</param>
    procedure PostCredit(CashierTrans: Record "Cashier Transactions"; JTemplate: Text; JBatch: Text; TillNumber: Text; DBranch: Text; DActivity: Text; var Isposted: Boolean)
    var
        CTransLines: Record "Cashier Transaction Lines";
        GenJournalLine: Record "Gen. Journal Line";
        TotalCharges: Decimal;
        LineNo: Integer;
        TransType: Option " ","Loan","Repayment","Interest Due","Interest Paid","Bills","Appraisal Due","Loan Registration Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid","Partial Disbursement";

    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Batch Name", JBatch);
        GenJournalLine.SETRANGE("Journal Template Name", JTemplate);
        IF GenJournalLine.FINDFIRST THEN GenJournalLine.DELETEALL;

        LineNo := LineNo + 10000;

        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JTemplate;
        GenJournalLine."Journal Batch Name" := JBatch;
        GenJournalLine."Document No." := CashierTrans.No;
        GenJournalLine."External Document No." := CashierTrans."Cheque No";
        GenJournalLine."Line No." := LineNo;

        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine."Account No." := TillNumber;

        IF CashierTrans.Type = CashierTrans.Type::"Credit Cheque" THEN BEGIN
            //GenJournalLine."Account Type" := GenJournalLine."Account Type"::Savings;
            GenJournalLine."Account No." := CashierTrans."Account No";
        END;

        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Posting Date" := CashierTrans."Transaction Date";
        GenJournalLine.Description := CashierTrans.Payee;
        GenJournalLine."Currency Code" := CashierTrans."Currency Code";
        GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
        GenJournalLine.Amount := CashierTrans.Amount;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
        IF GenJournalLine.Amount <> 0 THEN GenJournalLine.INSERT;

        CashierCharges(TotalCharges, JTemplate, JBatch, LineNo);

        CTransLines.RESET;
        CTransLines.SETRANGE(CTransLines."Transaction No", CashierTrans.No);
        IF CTransLines.FIND('-') THEN
            REPEAT

                LineNo := LineNo + 1;

                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := JTemplate;
                GenJournalLine."Journal Batch Name" := JBatch;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Document No." := CashierTrans.No;
                GenJournalLine."External Document No." := CashierTrans."Cheque No";
                GenJournalLine."Posting Date" := CashierTrans."Transaction Date";

                /*IF CTransLines.Type = CTransLines.Type::Credit THEN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Credit
                ELSE
                    IF CTransLines.Type = CTransLines.Type::Savings THEN
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Savings
                    else
                        if CTransLines.Type = CTransLines.Type::"G/L Account" then
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";

                GenJournalLine.Description := STRSUBSTNO('%1: %2', Type, CTransLines."Transaction Type");

                GenJournalLine."Account No." := CTransLines."Account No";
                GenJournalLine.Amount := -CTransLines.Amount;
                GenJournalLine.VALIDATE(GenJournalLine.Amount);
                GenJournalLine."Currency Code" := CashierTrans."Currency Code";
                GenJournalLine.VALIDATE(GenJournalLine."Currency Code");*/

                CASE CTransLines."Transaction Type" OF
                    CTransLines."Transaction Type"::" ":
                        TransType := TransType::" ";
                    CTransLines."Transaction Type"::Repayment:
                        TransType := TransType::Repayment;
                    CTransLines."Transaction Type"::"Penalty Paid":
                        TransType := TransType::"Penalty Paid";
                    CTransLines."Transaction Type"::"Interest Paid":
                        TransType := TransType::"Interest Paid";
                END;

            /* GenJournalLine."Transaction Type" := TransType;
             GenJournalLine."Loan No" := CTransLines."Loan No";
             GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
             GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
             GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
             IF GenJournalLine.Amount <> 0 THEN GenJournalLine.INSERT;*/

            UNTIL CTransLines.NEXT = 0;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JTemplate);
        GenJournalLine.SETRANGE("Journal Batch Name", JBatch);
        IF GenJournalLine.FINDFIRST THEN BEGIN

            //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post New", GenJournalLine);

            Posted := TRUE;
            Isposted := true;
            "Date Posted" := TODAY;
            "Time Posted" := TIME;
            "Posted By" := Cashier;
            MODIFY;

        END;

    end;

    /// <summary>
    /// CashierCharges.
    /// </summary>
    /// <param name="TotalChargeAmount">VAR Decimal.</param>
    /// <param name="TemplateName">Text.</param>
    /// <param name="BatchName">Text.</param>
    /// <param name="LineNumber">VAR Integer.</param>
    procedure CashierCharges(var TotalChargeAmount: Decimal; TemplateName: Text; BatchName: Text; var LineNumber: Integer)
    var
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charges";
        TieredChargesLines: Record "Tiered Charges Lines";
        ChargeAmount: Decimal;
        Employer: Record Customer;
        HasIntervalCharge: Boolean;
        HasNoticeCharge: Boolean;
        GenJournalLine: Record "Gen. Journal Line";
        SavingsAccounts: Record "Savings Accounts";
        ProductFactory: Record "Product Factory";

        ExciseDutyAmount: Decimal;

    begin
        Clear(HasIntervalCharge);
        Clear(HasNoticeCharge);

        TransactionTypes.Get("Transaction Type");

        TransactionCharges.Reset;
        TransactionCharges.SetRange("Transaction Type", "Transaction Type");
        if TransactionCharges.FindFirst() then
            repeat

                ChargeAmount := TransactionCharges.GetChargeAmount(Amount, 0);
                case TransactionCharges."Transaction Charge Category" of
                    TransactionCharges."Transaction Charge Category"::"Withdrawal Frequency":
                        if not HasIntervalCharge then
                            ChargeAmount := 0;
                    TransactionCharges."Transaction Charge Category"::"Withdrawn Amount":
                        if not HasNoticeCharge then
                            ChargeAmount := 0;
                end;

                If SavingsAccounts.Get("Account No") then begin
                    if Employer.Get(SavingsAccounts."Employer Code") then begin
                        // if Employer."Dont Charge Transactions" then ChargeAmount := 0;
                    end;
                end;

                if ChargeAmount > 0 then begin
                    LineNumber := LineNumber + 10000;

                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := TemplateName;
                    GenJournalLine."Journal Batch Name" := BatchName;
                    GenJournalLine."Document No." := No;
                    GenJournalLine."Line No." := LineNumber;

                    /* CASE "Account Type" OF
                         "Account Type"::Account:
                             GenJournalLine."Account Type" := GenJournalLine."Account Type"::Savings;
                         "Account Type"::"G/L Account":
                             GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                         else
                             GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account"
                     END; */

                    GenJournalLine."Account No." := "Account No";
                    GenJournalLine."External Document No." := "ID No";
                    GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date" := "Transaction Date";
                    GenJournalLine.Description := TransactionCharges.Description;
                    GenJournalLine."Currency Code" := "Currency Code";
                    GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                    GenJournalLine.Amount := ChargeAmount;
                    GenJournalLine.VALIDATE(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                    GenJournalLine."Bal. Account No." := TransactionCharges."G/L Account";
                    GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                    GenJournalLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                    IF GenJournalLine.Amount <> 0 THEN GenJournalLine.INSERT;

                    IF (TransactionCharges.HasExciseDuty) THEN begin

                        //Excise Duty
                        GenSetup.GET;
                        LineNumber := LineNumber + 10000;
                        ExciseDutyAmount := TransactionCharges.ExciseDutyAmount(ChargeAmount);

                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := TemplateName;
                        GenJournalLine."Journal Batch Name" := BatchName;
                        GenJournalLine."Document No." := No;
                        GenJournalLine."Line No." := LineNumber;
                        /* CASE "Account Type" OF
                            "Account Type"::Account:
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Savings;
                            "Account Type"::"G/L Account":
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                            else
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account"
                        END; */
                        GenJournalLine."Account No." := "Account No";
                        GenJournalLine.VALIDATE("Account No.");
                        GenJournalLine."Posting Date" := "Transaction Date";
                        GenJournalLine.Description := 'Excise Duty';
                        GenJournalLine."Currency Code" := "Currency Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
                        GenJournalLine.Amount := ExciseDutyAmount;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := GenSetup."Excise Duty G/L";
                        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                        GenJournalLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount <> 0 THEN GenJournalLine.INSERT;

                    end;
                    TotalChargeAmount += (ExciseDutyAmount + ChargeAmount);
                end

            until TransactionCharges.Next = 0;

    end;

}

