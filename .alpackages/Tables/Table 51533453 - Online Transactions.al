/// <summary>
/// Table Online Transactions (ID 51533453).
/// </summary>
table 51533453 "Online Transactions"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Online Fund Transfer Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Transaction Date"; DateTime)
        {
        }
        field(3; "Transfer Type"; Option)
        {
            OptionMembers = Self,Other;
        }
        field(4; "Transaction Type"; Option)
        {
            OptionMembers = ,"Fund Transfer","Loan Repayment";
        }
        field(5; "Member No"; Code[20])
        {
            trigger OnValidate()
            begin
                Members.Reset();
                Members.SetRange("No.", "Member No");
                IF NOT Members.FindFirst() then Error('Member Not Found.');

                if (Members.Status <> Members.Status::Active) AND (Members.Status <> Members.Status::Dormant) then
                    Error('Your Member Status [%1] does not allow you to perform this action.', Members.Status);

                if ("Transfer Type" = "Transfer Type"::Self) then
                    Validate("Destination Member No", "Member No");
            end;
        }
        field(6; "Source Account No."; Code[20])
        {
            TableRelation = "Savings Accounts"."No." WHERE("Member No." = FIELD("Member No"));
        }
        field(7; "Source Account Name"; Text[100])
        {
            CalcFormula = Lookup("Savings Accounts".Name where("No." = field("Source Account No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Destination Member No"; Code[20])
        {
        }
        field(9; "Destination Account"; Code[20])
        {
            ValidateTableRelation = false;
            TableRelation =
                IF ("Transaction Type" = CONST("Fund Transfer")) "Savings Accounts"."No."
                    WHERE("Member No." = FIELD("Destination Member No"))
            ELSE
            IF ("Transaction Type" = CONST("Loan Repayment")) Loans."Loan No."
                    WHERE("Member No." = FIELD("Destination Member No"));

            trigger OnValidate()
            begin
                if "Destination Account" = '' then exit;

                if "Transaction Type" = "Transaction Type"::"Fund Transfer" then begin
                    IF SavingsAccount.Get("Destination Account") then
                        "Destination Account Name" := SavingsAccount."Product Name" + ' - ' + SavingsAccount.Name;
                end else begin
                    if "Transaction Type" = "Transaction Type"::"Loan Repayment" then begin
                        if Loans.Get("Destination Account") then
                            "Destination Account Name" := Loans."Loan Product Type" + ' - ' + Loans."Member Name";
                    end
                end;
            end;
        }
        field(10; "Destination Account Name"; Text[100])
        {

        }
        field(11; Description; Text[220])
        {
        }
        field(12; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                if Amount <= 0 then Error(ErrZero);
            end;
        }
        field(13; Posted; Boolean)
        {
        }
        field(14; "Date Posted"; DateTime)
        {
        }
        field(15; Status; Option)
        {
            OptionMembers = Pending,Successful,Failed;
        }
        field(16; "No. Series"; Code[10])
        {
        }
        field(17; "Destination Member Name"; Text[100])
        {
            CalcFormula = Lookup(Members.Name where("No." = field("Destination Member No")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(18; "IP Address"; Code[20])
        {
        }
        field(19; "MAC Address"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Online Fund Transfer Nos");
            NoSeriesMgt.InitSeries(SeriesSetup."Online Fund Transfer Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Transaction Date" := CurrentDateTime;
    end;

    var
        SavingsAccount: Record "Savings Accounts";
        Loans: Record Loans;
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JOURNAL_TEMPLATE: Label 'INTERNET';
        JOURNAL_BATCH: Label 'INTERNETB';
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        //POSTJOURNAL: Codeunit "Journal Posting";
        OptionTransactionTypes: Option " ",Loan,Repayment,"Interest Due","Interest Paid",Bills;
        TextMsg: Text;
        //SendSmsToMember: Codeunit SendSms;
        OptionSMS: Option "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application","Loan Witness",PV;
        Documentno: Text;
        //PortalCodeUnit: Codeunit Internetbanking;
        AccountTypesEnum: Enum "Gen. Journal Account Type";
        Members: Record Members;
        TransferTo: Text;
        TransferFrom: Text;
        ErrZero: Label 'Amount must be greater than zero.';

    /// <summary>
    /// PostFundTransfer.
    /// </summary>
    procedure PostFundTransfer()
    var
        SourceAccName: Text;
    begin
        IF "Transaction Type" = "Transaction Type"::"Loan Repayment" THEN BEGIN
            PostLoanRepayment();
            EXIT;
        END;

        SavingsAccount.RESET;
        SavingsAccount.SETRANGE("No.", "Source Account No.");
        IF NOT SavingsAccount.FINDFIRST THEN ERROR('Source Account Not Found.');

        //DELETE LINES
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JOURNAL_TEMPLATE);
        GenJournalLine.SETRANGE("Journal Batch Name", JOURNAL_BATCH);
        GenJournalLine.DELETEALL;

        DocumentNo := "No.";

        Rec.CalcFields("Source Account Name", "Destination Member Name");
        TransferTo := 'OFT to ' + "Destination Member Name";
        TransferFrom := 'OFT from ' + "Source Account Name";

        //Account From
        LineNo := LineNo + 10000;
        //POSTJOURNAL.PostJournal(JOURNAL_TEMPLATE, JOURNAL_BATCH, LineNo, AccountTypesEnum::Savings, DocumentNo, TransferFrom,
        //Amount * -1, "Destination Account", Today, AccountTypesEnum::"G/L Account", '', 'Online Transfer', SavingsAccount."Global Dimension 1 Code",
        //SavingsAccount."Global Dimension 2 Code", OptionTransactionTypes::" ", '', '', '', 0, '', 0, false);

        //Account to
        LineNo := LineNo + 10000;
        //POSTJOURNAL.PostJournal(JOURNAL_TEMPLATE, JOURNAL_BATCH, LineNo, AccountTypesEnum::Savings, DocumentNo, TransferTo,
        //Amount, "Source Account No.", Today, AccountTypesEnum::"G/L Account", '', 'Online Transfer', SavingsAccount."Global Dimension 1 Code",
        //SavingsAccount."Global Dimension 2 Code", OptionTransactionTypes::" ", '', '', '', 0, '', 0, false);

        //POSTJOURNAL.CompletePosting(JOURNAL_TEMPLATE, JOURNAL_BATCH);

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JOURNAL_TEMPLATE);
        GenJournalLine.SETRANGE("Journal Batch Name", JOURNAL_BATCH);
        GenJournalLine.DELETEALL;

        Status := Status::Successful;
        Posted := TRUE;
        "Date Posted" := CURRENTDATETIME;
        MODIFY;

        SourceAccName := "Source Account No.";
        IF SavingsAccount.GET("Source Account No.") THEN SourceAccName := SavingsAccount."Product Name";

        //TextMsg := 'Transfer successful. Your new ' + SourceAccName + ' A/C Bal. is ' + FORMAT(PortalCodeUnit.GetAccountBalance("Source Account No."));
        //SendSmsToMember.SendSms(OptionSMS::"InterAccount Transfer", SavingsAccount."Mobile Phone No", TextMsg, DocumentNo, "Source Account No.", false, false);
    end;

    /// <summary>
    /// PostLoanRepayment.
    /// </summary>
    procedure PostLoanRepayment()
    var
        LoanAccount: Code[50];
        DisbursementAccount: Code[50];
        LoanNo: Text;
        AccountFrom: Text;
        MemberNo: Text;
        LoanOutstanding: Decimal;
        Interest: Decimal;
        RepaymentAmount: Decimal;
        InterestRepaymentAmount: Decimal;

    begin
        AccountFrom := "Source Account No.";
        LoanNo := "Destination Account";
        MemberNo := "Member No";

        SavingsAccount.RESET;
        SavingsAccount.SETRANGE("No.", AccountFrom);
        IF NOT SavingsAccount.FINDFIRST THEN EXIT;

        // IF Amount > PortalCodeUnit.GetAccountBalance(SavingsAccount."No.") THEN ERROR('You have insufficient funds in your account.');

        Documentno := "No.";

        Loans.RESET;
        Loans.SETRANGE("Loan No.", LoanNo);
        Loans.SETRANGE("Member No.", "Destination Member No");
        IF NOT Loans.FINDFIRST THEN ERROR('Loan Not Found');

        Loans.CALCFIELDS("Outstanding Balance", "Outstanding Interest");
        Interest := Loans."Outstanding Interest";
        LoanOutstanding := Loans."Outstanding Balance";
        DisbursementAccount := AccountFrom;

        IF Interest > 0 THEN BEGIN
            InterestRepaymentAmount := Amount;
            IF Amount > Interest THEN InterestRepaymentAmount := Interest;

            Rec.CalcFields("Source Account Name");
            TransferTo := LoanNo + ' Online Loan Interest Repayment';
            TransferFrom := 'OFT from ' + "Source Account Name";

            //Interest Repayment
            LineNo := LineNo + 10000;
            // POSTJOURNAL.PostJournal(JOURNAL_TEMPLATE, JOURNAL_BATCH, LineNo, AccountTypesEnum::Savings, Documentno, TransferTo,
            //InterestRepaymentAmount, DisbursementAccount, TODAY, AccountTypesEnum::"G/L Account", '', AccountFrom,
            //SavingsAccount."Global Dimension 1 Code", SavingsAccount."Global Dimension 2 Code", OptionTransactionTypes::" ", '', '', '', 0, '', 0, false);

            LineNo := LineNo + 10000;
            //POSTJOURNAL.PostJournal(JOURNAL_TEMPLATE, JOURNAL_BATCH, LineNo, AccountTypesEnum::Credit, Documentno, TransferFrom,
            //InterestRepaymentAmount * -1, Loans."Loan Account", TODAY, AccountTypesEnum::"G/L Account", '', AccountFrom,
            //SavingsAccount."Global Dimension 1 Code", SavingsAccount."Global Dimension 2 Code", OptionTransactionTypes::"Interest Paid", LoanNo, '', '', 0, '', 0, false);
        END;

        RepaymentAmount := Amount - InterestRepaymentAmount;
        IF RepaymentAmount > 0 THEN BEGIN
            IF LoanOutstanding < RepaymentAmount THEN RepaymentAmount := LoanOutstanding;

            Rec.CalcFields("Source Account Name");
            TransferTo := LoanNo + ' Online Loan Repayment';
            TransferFrom := 'OFT from ' + "Source Account Name";

            LineNo := LineNo + 10000;
            // Cr Member Loan Account - Principal Loan Repayment
            // POSTJOURNAL.PostJournal(JOURNAL_TEMPLATE, JOURNAL_BATCH, LineNo, AccountTypesEnum::Savings, Documentno, TransferTo,
            // RepaymentAmount, DisbursementAccount, TODAY, AccountTypesEnum::"G/L Account", '', AccountFrom,
            //SavingsAccount."Global Dimension 1 Code", SavingsAccount."Global Dimension 2 Code", OptionTransactionTypes::" ", '', '', '', 0, '', 0, false);

            LineNo := LineNo + 10000;
            //POSTJOURNAL.PostJournal(JOURNAL_TEMPLATE, JOURNAL_BATCH, LineNo, AccountTypesEnum::Credit, Documentno, TransferFrom,
            // RepaymentAmount * -1, Loans."Loan Account", TODAY, AccountTypesEnum::"G/L Account", '', AccountFrom,
            // SavingsAccount."Global Dimension 1 Code", SavingsAccount."Global Dimension 2 Code", OptionTransactionTypes::Repayment, LoanNo, '', '', 0, '', 0, false);
        END;


        // Complete Journal Posting
        //POSTJOURNAL.CompletePosting(JOURNAL_TEMPLATE, JOURNAL_BATCH);

        Loans.CALCFIELDS("Outstanding Balance", "Outstanding Interest");
        LoanOutstanding := Loans."Outstanding Balance" + Loans."Outstanding Interest";

        TextMsg := 'Dear Member, loan repayment of KES ' + FORMAT(Amount) + ' successful for Loan No: ' + LoanNo + ', Balance ' + FORMAT(LoanOutstanding);
        //SendSmsToMember.SendSms(OptionSMS::"InterAccount Transfer", SavingsAccount."Mobile Phone No", TextMsg, '', '', FALSE, FALSE);

        Posted := TRUE;
        Status := Status::Successful;
        "Date Posted" := CURRENTDATETIME;
        MODIFY;
    end;
}

