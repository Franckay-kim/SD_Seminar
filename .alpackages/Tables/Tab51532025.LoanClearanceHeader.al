/// <summary>
/// Table Loan Clearance Header (ID 51532025).
/// </summary>
table 51532025 "Loan Clearance Header"
{
    Caption = 'Loan Clearance Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Loan Clearance Nos.");
                    "No. Series" := '';
                    "No." := UpperCase("No.");
                end;
            end;
        }
        field(2; "Member No."; Code[30])
        {
            Caption = 'Member No.';
            TableRelation = Members."No." where(Status = filter(<> Deceased));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Members: Record Members;
            begin
                Members.reset;
                Members.SetRange("No.", "Member No.");
                if Members.Find('-') then
                    "Member Name" := Members.Name;
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Loan Product Type"; Code[30])
        {
            Caption = 'Loan Product Type';
            TableRelation = "Product Factory"."Product ID" where("Product Class Type" = const(loan));
            DataClassification = ToBeClassified;
        }
        field(5; "Loan No"; Code[30])
        {
            Caption = 'Loan No';
            TableRelation = Loans."Loan No." where("Member No." = field("Member No."), "Outstanding Balance" = filter(> 0));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Loans: Record Loans;
                //LoansProcess: Codeunit "Loans Process";
                MDef: Integer;
                Pdef: Decimal;
                IntPaid: Decimal;
                IntDue: Decimal;
                LoanApps: Record Loans;
            begin
                Clear(IntDue);
                Clear(IntPaid);
                Loans.Reset();
                Loans.SetRange("Loan No.", "Loan No");
                if Loans.Find('-') then begin
                    Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Interest Paid", "Interest Suspended");
                    "Outstanding Balance" := Loans."Outstanding Balance";
                    "Outstanding Interest" := Loans."Outstanding Interest";
                    "Total Loan Balance" := Loans."Outstanding Balance" + Loans."Outstanding Interest";
                    "Suspended Interest" := Loans."Interest Suspended";
                    // LoansProcess.GetLoanDefaulterNew(Loans."Loan No.", MDef, Pdef, Today);
                    "Principal Arrears" := pdef;
                    IntPaid := Loans."Interest Paid";
                    Loans.SetFilter("Date Filter", '..%1', CalcDate('-1M+CM', Today));
                    Loans.CalcFields("Outstanding Interest", "Interest Paid", "Interest Due");
                    IntDue := Loans."Interest Due";
                    "Interest Arrears" := IntDue - IntPaid;
                    if "Interest Arrears" < 0 then
                        "Interest Arrears" := 0;
                end;

            end;
        }
        field(6; "Savings Balance"; Decimal)
        {
            Caption = 'Savings Balance';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(7; "Total Loan Balance"; Decimal)
        {
            Caption = 'Total Loan Balance';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(8; "Outstanding Balance"; Decimal)
        {
            Caption = 'Outstanding Balance';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(9; "Outstanding Interest"; Decimal)
        {
            Caption = 'Outstanding Interest';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(10; "Savings Account No."; Code[30])
        {
            Caption = 'Savings Account No.';
            // TableRelation = "Savings Accounts"."No." where("Member No." = field("Member No."), "Global Dimension 1 Code" = field("Global Dimension 1 Code"));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                SavingsAccounts: Record "Savings Accounts";
            // Periodic: Codeunit "Periodic Activities";
            begin
                SavingsAccounts.reset;
                SavingsAccounts.SetRange("No.", "Savings Account No.");
                if SavingsAccounts.Find('-') then begin
                    SavingsAccounts.CalcFields(Balance, "Balance (LCY)");
                    "Savings Balance" := GetAccountBalance("Savings Account No.");

                    if SavingsAccounts."Global Dimension 1 Code" <> "Global Dimension 1 Code" then
                        Error('You can only choose savings accounts related to your activity code ' + "Global Dimension 1 Code");
                end;
            end;
        }
        field(12; "Amount to Recover"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                // Periodic: Codeunit "Periodic Activities";
                Savings: Record "Savings Accounts";
                Loans: Record Loans;
            begin
                If "Amount to Recover" < 0 then
                    Error('Amount to recover');
                // IF "Amount to Recover" > Periodic.GetAccountBalance("Savings Account No.") then
                //Error('Amount to recover cannot exceed available abalance');
                if "Amount to Recover" > "Total Loan Balance" then
                    Error('Amount to Recover cannot exceed total loan balance');
                Loans.Get("Loan No");
                Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Total Outstanding Balance", "Interest Suspended");
                if "Amount to Recover" > (Loans."Total Outstanding Balance" + Loans."Interest Suspended") then
                    Error('Amount to Recover cannot exceed total loan balance');

            end;
        }
        field(11; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(13; "Posted"; Boolean)
        {
            Editable = false;
        }
        field(14; Status; Option)
        {
            OptionMembers = Open,Pending,Approved,Rejected;
            Editable = false;
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(1));
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,2,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2));
        }
        field(17; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(18; "Principal Arrears"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Interest Arrears"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Suspended Interest"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Recovered From Loanee"; Boolean)
        {

        }
        field(22; "Recovered From Guarantors"; Boolean)
        {

        }




    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        USetup: Record "User Setup";
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Loan Clearance Nos.");
            NoSeriesMgt.InitSeries(SeriesSetup."Loan Clearance Nos.", xRec."No. Series", 0D, "No.", "No. Series");

        end;
        USetup.Get(UserId);
        //"Global Dimension 1 Code" := USetup."Global Dimension 1 Code";
        //"Global Dimension 2 Code" := USetup."Global Dimension 2 Code";
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    /// <summary>
    /// GetAccountBalance.
    /// </summary>
    /// <param name="AcctNo">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetAccountBalance(AcctNo: Code[20]): Decimal
    var
        SavingsAccounts: Record "Savings Accounts";
        ProductFactory: Record "Product Factory";
        Bal: Decimal;
    begin

        Bal := 0;
        SavingsAccounts.Reset;
        SavingsAccounts.SetRange("No.", AcctNo);
        if SavingsAccounts.Find('-') then begin
            SavingsAccounts.CalcFields("Balance (LCY)", "Uncleared Cheques", "Loan Held Cheques", "ATM Transactions", "Lien Placed", "Lien Guaranteed", "Authorised Over Draft");
            if ProductFactory.Get(SavingsAccounts."Product Type") then begin
                Bal := (SavingsAccounts."Balance (LCY)") -
                       SavingsAccounts."Uncleared Cheques" - SavingsAccounts."Loan Held Cheques" -
                      SavingsAccounts."Lien Placed" - SavingsAccounts."ATM Transactions" - SavingsAccounts."Lien Guaranteed";
            end;
        end;
        exit(Bal);
    end;

    /// <summary>
    /// RecoverFromLoanee.
    /// </summary>
    /*  procedure RecoverFromLoanee()

      var
          //JournalPosting: Codeunit "Journal Posting";
          //Periodic: Codeunit "Periodic Activities";
          //SaccoTrans: Codeunit "Sacco Transactions";
          Loans: Record Loans;
          GeneralSetUp: Record "General Set-Up";
          BankingUserTemplate: Record "Banking User Template";
          Jtemplate: Code[20];
          JBatch: Code[20];
          AcctType: Enum "Gen. Journal Account Type";
          LineNo: Integer;
          RunBal: Decimal;
          Amt: Decimal;
          AmtRecv: Decimal;
          BalAccType: Enum "Gen. Journal Account Type";
          BalAccNo: Code[20];
          Members: Record Members;
          TransType: Option " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Ledger Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid","Suspended Interest Due","Suspended Interest Paid";
      begin
          Rec.TestField(Status, Rec.Status::Approved);
          Rec.TestField(Posted, false);
          Rec.TestField("Recovered From Loanee", false);
          Rec.TestField("Recovered From Guarantors", false);
          /*If Rec."Amount to Recover" > Periodic.GetAccountBalance(Rec."Savings Account No.") then begin
              Error('Amount to recover cannot exceed available balance'); 

      end;
          Clear(RunBal);
          Clear(Amt);
          Clear(AmtRecv);
          BankingUserTemplate.Get(UserId);
          BankingUserTemplate.TestField("Check Off Template");
          BankingUserTemplate.TestField("Check Off Batch");
          Jtemplate := BankingUserTemplate."Check Off Template";
          JBatch := BankingUserTemplate."Check Off Batch";
          Loans.Get(Rec."Loan No");
          Loans.CalcFields("Total Outstanding Balance", "Outstanding Balance", "Outstanding Interest");

          if Rec."Amount to Recover" > Loans."Total Outstanding Balance" then
              Error('Amount to recover cannot exceed total outstanding balance');
          JournalPosting.ClearJournalLines(Jtemplate, JBatch);
          RunBal := Rec."Amount to Recover";




          IF Loans."Outstanding Interest" > 0 then begin
              Amt := 0;
              IF Loans."Outstanding Interest" > RunBal then
                  Amt := RunBal
              else
                  Amt := Loans."Outstanding Interest";
              LineNo := 1000;
              JournalPosting.PostJournal(Jtemplate, JBatch, LineNo, AcctType::Credit, Rec."No.",
                  Rec.Description, -Amt, Loans."Loan Account", Today, BalAccType,
                  BalAccNo, Loans."Loan No.", BankingUserTemplate."Shortcut Dimension 1 Code", BankingUserTemplate."Shortcut Dimension 2 Code", TransType::"Interest Paid", Loans."Loan No.", '', '', 0, '', 0, false);
              RunBal -= Amt;
              AmtRecv += Amt;
          end;
          IF Loans."Interest Suspended" > 0 then begin
              Amt := 0;
              IF Loans."Interest Suspended" > RunBal then
                  Amt := RunBal
              else
                  Amt := Loans."Interest Suspended";
              LineNo := 1000;
              JournalPosting.PostJournal(Jtemplate, JBatch, LineNo, AcctType::Credit, Rec."No.",
                  Rec.Description, -Amt, Loans."Loan Account", Today, BalAccType,
                  BalAccNo, Loans."Loan No.", BankingUserTemplate."Shortcut Dimension 1 Code", BankingUserTemplate."Shortcut Dimension 2 Code", TransType::"Suspended Interest Paid", Loans."Loan No.", '', '', 0, '', 0, false);
              RunBal -= Amt;
              AmtRecv += Amt;
          end;

          IF Loans."Outstanding Balance" > 0 then begin
              Amt := 0;
              IF Loans."Outstanding Balance" > RunBal then
                  Amt := RunBal
              else
                  Amt := Loans."Outstanding Balance";
              LineNo += 1000;
              JournalPosting.PostJournal(Jtemplate, JBatch, LineNo, AcctType::Credit, Rec."No.",
                  Rec.Description, -Amt, Loans."Loan Account", Today, BalAccType,
                  BalAccNo, Loans."Loan No.", BankingUserTemplate."Shortcut Dimension 1 Code", BankingUserTemplate."Shortcut Dimension 2 Code", TransType::Repayment, Loans."Loan No.", '', '', 0, '', 0, false);
              RunBal -= Amt;
              AmtRecv += Amt;
          end;
          IF AmtRecv > 0 then begin
              LineNo += 1000;
              JournalPosting.PostJournal(Jtemplate, JBatch, LineNo, AcctType::Savings, Rec."No.",
                  Rec.Description, AmtRecv, Rec."Savings Account No.", Today, BalAccType,
                  BalAccNo, Loans."Loan No.", BankingUserTemplate."Shortcut Dimension 1 Code", BankingUserTemplate."Shortcut Dimension 2 Code", TransType, Loans."Loan No.", '', '', 0, '', 0, false);
              if JournalPosting.CompletePosting(Jtemplate, JBatch) then begin
                  Members.Get(Rec."Member No.");
                  Members.Validate(Status, Members.Status::Defaulter);
                  Members.Modify;
                  //  Rec."Recovered From Guarantors" := true;
                  Rec.Posted := true;
                  Rec.Modify;

              end;
          end;

          Rec."Recovered From Loanee" := true;
          Rec.Modify(true);

      end; */

    /// <summary>
    /// RecoverFromGuarantors.
    /// </summary>
    /*procedure RecoverFromGuarantors()
    var

        ClearanceLines: Record "Loan Clearance Lines";
        //JournalPosting: Codeunit "Journal Posting";
        Loans: Record Loans;
        TotalLoansovery: Decimal;
        Loanee: Record Members;
        //SendSms: Codeunit SendSms;
        Dim1: Code[20];
        Dim2: Code[20];
        Temp: Record "Banking User Template";
        Jtemplate: Code[20];
        JBatch: Code[20];
        UserSetup: Record "User Setup";
        GuarantorAmount: Decimal;
        Members: Record Members;
        AmountRecovered: Decimal;
        //SaccoTrans: Codeunit "Sacco Transactions";
        AmountToRecover: Decimal;
        Desc: Text[50];
        AcctType: Enum "Gen. Journal Account Type";
        TransType: Option " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Ledger Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid","Suspended Interest Due","Suspended Interest Paid";
        BalAccType: Enum "Gen. Journal Account Type";
        SourceType: Option "New Member","New Account","Loan Account Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit"," Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued";

    begin
        Temp.Get(UserId);
        UserSetup.Get(UserId);
        Jtemplate := Temp."Check Off Template";
        JBatch := Temp."Check Off Batch";
        //JournalPosting.ClearJournalLines(Jtemplate, JBatch);
        UserSetup.Get(UserId);
        //Dim1 := UserSetup."Global Dimension 1 Code";
        //Dim2 := UserSetup."Global Dimension 2 Code";
        Loans.Get("Loan No");
        Loans.CalcFields("Outstanding Appraisal", "Outstanding Balance", "Outstanding Interest", "Outstanding Loan Reg. Fee", "Outstanding Penalty", "Interest Suspended");
        if Loans."Outstanding Appraisal" < 0 then
            Loans."Outstanding Appraisal" := 0;
        if Loans."Outstanding Penalty" < 0 then
            Loans."Outstanding Penalty" := 0;
        if Loans."Outstanding Interest" < 0 then
            Loans."Outstanding Interest" := 0;
        if Loans."Outstanding Balance" < 0 then
            Loans."Outstanding Balance" := 0;
        if Loans."Outstanding Loan Reg. Fee" < 0 then
            Loans."Outstanding Loan Reg. Fee" := 0;
        TotalLoansovery := Loans."Outstanding Appraisal" + Loans."Outstanding Penalty" + Loans."Outstanding Interest" + Loans."Outstanding Balance" + Loans."Outstanding Loan Reg. Fee" + Loans."Interest Suspended";
        Rec.TestField(Status, Rec.Status::Approved);
        Rec.TestField(Posted, false);
        Rec.TestField("Recovered From Loanee", true);
        Rec.TestField("Recovered From Guarantors", false);
        Loanee.Get(Loans."Member No.");
        //Loanee."Recovered Guarantors" := true;
        Loanee.Modify;
        /*SendSMS.SendSms(SourceType::"Loan defaulted", Loanee."Mobile Phone No", 'Your loan of ' + Format(TotalLoansovery) + 'has been attached to your guarantors'
                , Loans."Loan No.", Loans."Disbursement Account No", true, true); 
        //Loans."Recovered from Guarantors" := true;
        Loans.Modify;
        ClearanceLines.Reset();
        ClearanceLines.SetRange("Clearance Header No.", Rec."No.");
        ClearanceLines.SetFilter("Amount to Recover", '<=0');
        if ClearanceLines.Find('-') then
            Error('Loan Allocation MUST be Greater than Zero');
        ClearanceLines.Reset();
        ClearanceLines.SetRange("Clearance Header No.", Rec."No.");
        ClearanceLines.SetFilter("Amount to Recover", '<=0');
        if not ClearanceLines.Find('-') then
            Error('Guarantor Lines Do not Exist');
        IF TotalLoansovery > 0 then begin
            ClearanceLines.Reset();
            ClearanceLines.SetRange("Clearance Header No.", Rec."No.");
            ClearanceLines.SetFilter("Amount to Recover", '>0');
            ClearanceLines.SetRange(Posted, false);
            if ClearanceLines.Find('-') then
                repeat
                    GuarantorAmount := ClearanceLines."Amount to Recover";
                    AmountRecovered := 0;
                    Members.Reset;
                    Members.SetRange("No.", ClearanceLines."Guarantor Member No.");
                    //Members.SETRANGE(Status,Members.Status::Active);
                    if Members.FindFirst then begin

                        AmountToRecover := Round(Loans."Outstanding Loan Reg. Fee" / TotalLoansovery * GuarantorAmount, 0.01, '>');
                        Desc := CopyStr('Loan Reg. Fee Defaulter Recovery - ' + Loans."Member No." + Members."No.", 1, 50);
                        SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Credit, Loans."Loan Account", Desc, BalAccType::"G/L Account", '', -AmountToRecover, "Member No.", Loans."Loan No.", TransType::"Ledger Fee", Dim1, Dim2, true);
                        IF ClearanceLines."Recovery Type" = ClearanceLines."Recovery Type"::Savings then
                            SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Savings, ClearanceLines."Account No.", Desc, BalAccType::"G/L Account", '', AmountToRecover, "Member No.", '', TransType::" ", Dim1, Dim2, true)
                        else
                            CreateDefaulterLoan(Members."No.", Loans, Rec, AmountToRecover);

                        AmountRecovered += AmountToRecover;

                        AmountToRecover := Round(Loans."Outstanding Appraisal" / TotalLoansovery * GuarantorAmount, 0.01, '>');
                        Desc := CopyStr('Appraisal Fee Defaulter Recovery - ' + Loans."Member No." + Members."No.", 1, 50);
                        SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Credit, Loans."Loan Account", Desc, BalAccType::"G/L Account", '', -AmountToRecover, "Member No.", Loans."Loan No.", TransType::"Appraisal Paid", Dim1, Dim2, true);
                        IF ClearanceLines."Recovery Type" = ClearanceLines."Recovery Type"::Savings then
                            SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Savings, ClearanceLines."Account No.", Desc, BalAccType::"G/L Account", '', AmountToRecover, "Member No.", '', TransType::" ", Dim1, Dim2, true)
                        else
                            CreateDefaulterLoan(Members."No.", Loans, Rec, AmountToRecover);

                        AmountRecovered += AmountToRecover;

                        AmountToRecover := Round(Loans."Outstanding Penalty" / TotalLoansovery * GuarantorAmount, 0.01, '>');
                        Desc := CopyStr('Penalty Defaulter Recovery - ' + Loans."Member No." + Members."No.", 1, 50);
                        SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Credit, Loans."Loan Account", Desc, BalAccType::"G/L Account", '', -AmountToRecover, "Member No.", Loans."Loan No.", TransType::"Penalty Paid", Dim1, Dim2, true);
                        IF ClearanceLines."Recovery Type" = ClearanceLines."Recovery Type"::Savings then
                            SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Savings, ClearanceLines."Account No.", Desc, BalAccType::"G/L Account", '', AmountToRecover, "Member No.", '', TransType::" ", Dim1, Dim2, true)
                        else
                            CreateDefaulterLoan(Members."No.", Loans, Rec, AmountToRecover);
                        AmountRecovered += AmountToRecover;

                        AmountToRecover := Round(Loans."Outstanding Interest" / TotalLoansovery * GuarantorAmount, 0.01, '>');
                        Desc := CopyStr('Loan Interest Defaulter Recovery - ' + Loans."Member No." + Members."No.", 1, 50);
                        SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Credit, Loans."Loan Account", Desc, BalAccType::"G/L Account", '', -AmountToRecover, "Member No.", Loans."Loan No.", TransType::"Interest Paid", Dim1, Dim2, true);
                        IF ClearanceLines."Recovery Type" = ClearanceLines."Recovery Type"::Savings then
                            SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Savings, ClearanceLines."Account No.", Desc, BalAccType::"G/L Account", '', AmountToRecover, "Member No.", '', TransType::" ", Dim1, Dim2, true)
                        else
                            CreateDefaulterLoan(Members."No.", Loans, Rec, AmountToRecover);
                        AmountRecovered += AmountToRecover;
                        //Suspended Interest
                        AmountToRecover := Round(Loans."Interest Suspended" / TotalLoansovery * GuarantorAmount, 0.01, '>');
                        Desc := CopyStr('Loan Suspended Interest  Recovery - ' + Loans."Member No." + Members."No.", 1, 50);
                        SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Credit, Loans."Loan Account", Desc, BalAccType::"G/L Account", '', -AmountToRecover, "Member No.", Loans."Loan No.", TransType::"Suspended Interest Paid", Dim1, Dim2, true);
                        IF ClearanceLines."Recovery Type" = ClearanceLines."Recovery Type"::Savings then
                            SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Savings, ClearanceLines."Account No.", Desc, BalAccType::"G/L Account", '', AmountToRecover, "Member No.", '', TransType::" ", Dim1, Dim2, true)
                        else
                            CreateDefaulterLoan(Members."No.", Loans, Rec, AmountToRecover);
                        AmountRecovered += AmountToRecover;
                        AmountToRecover := Round(Loans."Outstanding Balance" / TotalLoansovery * GuarantorAmount, 0.01, '>');
                        Desc := CopyStr('Loan Principal Defaulter Recovery - ' + Loans."Member No." + Members."No.", 1, 50);
                        SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Credit, Loans."Loan Account", Desc, BalAccType::"G/L Account", '', -AmountToRecover, "Member No.", Loans."Loan No.", TransType::Repayment, Dim1, Dim2, true);
                        IF ClearanceLines."Recovery Type" = ClearanceLines."Recovery Type"::Savings then
                            SaccoTrans.JournalInsert(Jtemplate, JBatch, "No.", WorkDate(), AcctType::Savings, ClearanceLines."Account No.", Desc, BalAccType::"G/L Account", '', AmountToRecover, "Member No.", '', TransType::" ", Dim1, Dim2, true)
                        else
                            CreateDefaulterLoan(Members."No.", Loans, Rec, AmountToRecover);
                        AmountRecovered += AmountToRecover;




                        ClearanceLines.Posted := true;
                        ClearanceLines.Modify;

                    end;
                until ClearanceLines.Next() = 0;

            //now also post any defaulter loans created
            Loans.reset;
            Loans.Setrange("Loan Recovery No.", Rec."No.");
            Loans.setrange(Posted, false);
            If Loans.find('-') then
                repeat
                    Desc := CopyStr('Loan Defaulter Recovery - ' + Rec."Member No." + Loans."Member No.", 1, 50);
                    SaccoTrans.JournalInsert(Jtemplate, JBatch, Rec."No.", WorkDate(), AcctType::Credit, Loans."Loan Account", Desc, BalAccType::"G/L Account", '', Loans."Approved Amount", "Member No.", Loans."Loan No.", TransType::"Loan", Dim1, Dim2, true);
                until Loans.next() = 0;
            if JournalPosting.CompletePosting(Jtemplate, JBatch) then begin
                Members.Get(Rec."Member No.");
                Members.Validate(Status, Members.Status::Defaulter);
                Members.Modify;
                Rec."Recovered From Guarantors" := true;
                Rec.Posted := true;
                Rec.Modify;

            end;
            Loans.reset;
            Loans.Setrange("Loan Recovery No.", Rec."No.");
            Loans.setrange(Posted, false);
            If Loans.find('-') then
                repeat
                    Loans.Posted := true;
                    Loans.modify();
                until Loans.next() = 0;
            Message('Recovered Successfully');
        end;

    end; */


    /// <summary>
    /// CreateDefaulterLoan.
    /// </summary>
    /// <param name="MemNo">Code[20].</param>
    /// <param name="Loans">Record Loans.</param>
    /// <param name="Rec">Record "Loan Clearance Header".</param>
    /// <param name="LoanAllocation">Decimal.</param>
    procedure CreateDefaulterLoan(MemNo: Code[20]; Loans: Record Loans; Rec: Record "Loan Clearance Header"; LoanAllocation: Decimal)
    var
        ProductFactory: Record "Product Factory";
        CreditAccounts: Record "Credit Accounts";
        ExistPac: Boolean;
        NewLoans: Record Loans;
        Members: Record Members;
        MonthRepay: Decimal;
        LoanSched: Record "Loan Repayment Schedule";
        Install: integer;
        CreditAcc: Code[20];
        ProdFac: Record "Product Factory";
    // LoanProcess: Codeunit "Loans Process";
    begin
        ProductFactory.RESET;
        ProductFactory.SETCURRENTKEY(ProductFactory."Product ID");
        ProductFactory.SETRANGE(ProductFactory."Product Class Type", ProductFactory."Product Class Type"::Loan);
        ProductFactory.SETRANGE(ProductFactory."Nature of Loan Type", ProductFactory."Nature of Loan Type"::Defaulter);
        //ProductFactory.SETRANGE("Product ID",Loans."Loan Product Type");
        IF ProductFactory.FIND('-') THEN BEGIN
            REPEAT

                CreditAcc := ProductFactory."Account No. Prefix" + MemNo;
                IF CreditAccounts.GET(CreditAcc) THEN BEGIN
                    CreditAccounts.CALCFIELDS(CreditAccounts."Balance (LCY)");
                    IF CreditAccounts."Balance (LCY)" = 0 THEN BEGIN
                        ExistPac := TRUE;
                        //EXIT;
                    END;
                END ELSE BEGIN

                    //CreditAcc := LoanProcess."CreateLoan Account"(MemNo, ProductFactory."Product ID");
                    ExistPac := TRUE;
                END;

            UNTIL (ProductFactory.NEXT = 0) OR (ExistPac = TRUE);
        END;
        //End of Get Defauter Loan type

        NewLoans.RESET;
        NewLoans.SETRANGE(NewLoans."Member No.", MemNo);
        NewLoans.SETRANGE(NewLoans."Loan Product Type", ProductFactory."Product ID");
        NewLoans.SETFILTER(NewLoans."Loan Recovery No.", '<>%1', Rec."No.");
        NewLoans.SETRANGE(NewLoans.Posted, FALSE);
        IF NewLoans.FIND('-') THEN
            NewLoans.DELETEALL;
        //ERROR('%1 ANND %2',Loans."Loan Account",IntBalance+PrinBalance);
        NewLoans.RESET;
        NewLoans.setrange(NewLoans."Loan Recovery No.", Rec."No.");
        NewLoans.Setrange(NewLoans.Posted, FALSE);
        NewLoans.SETRANGE(NewLoans."Member No.", MemNo);
        NewLoans.SETRANGE(NewLoans."Loan Product Type", ProductFactory."Product ID");
        If NewLoans.FIND('-') THEN begin
            NewLoans."Requested Amount" += LoanAllocation;
            NewLoans."Approved Amount" += LoanAllocation;
            NewLoans.VALIDATE(NewLoans."Approved Amount");
            NewLoans.MODIFY();
        end else begin


            NewLoans.INIT;
            NewLoans."Loan No." := '';
            NewLoans."Member No." := MemNo;//LGurantors."Member No"
            IF Members.GET(MemNo) THEN BEGIN
                NewLoans."Member Name" := Members.Name;
                NewLoans."Staff No" := Members."Payroll/Staff No.";
                NewLoans."Employer Code" := Members."Employer Code";
                NewLoans."Application Date" := TODAY;
            END;
            //NewLoans.VALIDATE(NewLoans."Member No.");
            NewLoans."Loan Product Type" := ProductFactory."Product ID";
            //NewLoans.VALIDATE(NewLoans."Loan Product Type");
            IF ProdFac.GET(ProductFactory."Product ID") THEN BEGIN
                NewLoans."Loan Product Type Name" := ProdFac."Product Description";
                NewLoans."Grace Period" := ProdFac."Grace Period - Interest";
                NewLoans.Interest := ProdFac."Interest Rate (Min.)";
                NewLoans."Grace Period" := ProdFac."Grace Period - Interest";
                NewLoans."Interest Calculation Method" := ProdFac."Interest Calculation Method";
                NewLoans."Loan Span" := ProdFac."Loan Span";
                // Check schedule details
                LoanSched.RESET;
                LoanSched.SETRANGE(LoanSched."Loan No.", Loans."Loan No.");
                IF LoanSched.FIND('-') THEN BEGIN
                    REPEAT
                        IF MonthRepay <= Loans."Outstanding Balance" THEN BEGIN
                            MonthRepay += LoanSched."Monthly Repayment";
                            Install += 1;
                        END;
                    UNTIL LoanSched.NEXT = 0;
                END;

                NewLoans.Installments := Loans.Installments - Install;

                // NewLoans."Compute Interest Due on Postin" :WorkDate();= ProdFac."Compute Interest Due on Postin";
                NewLoans."Repayment Frequency" := ProdFac."Repayment Frequency";
                NewLoans."Recovery Mode" := ProdFac."Repay Mode";
                NewLoans."Appraisal Parameter Type" := ProdFac."Appraisal Parameter Type";
                NewLoans."Recovery Priority" := ProdFac."Recovery Priority";
            END;
            NewLoans."Application Date" := WorkDate();
            IF (Loans."Approved Amount" > 0) AND (Loans.Installments > 0) THEN
                NewLoans.Installments := ROUND((Loans."Outstanding Balance")
                                          / (Loans."Approved Amount" / Loans.Installments), 1, '>');
            NewLoans."Requested Amount" := LoanAllocation;
            NewLoans."Approved Amount" := LoanAllocation;
            NewLoans.VALIDATE(NewLoans."Approved Amount");
            NewLoans.Status := NewLoans.Status::Approved;
            NewLoans."Disbursement Date" := WorkDate();
            NewLoans."Repayment Start Date" := WorkDate();
            //NewLoans.batch"Batch No.":="Batch No.";
            NewLoans."Recovered Loan" := Loans."Loan No.";

            NewLoans."Loan Account" := CreditAcc;
            NewLoans."Loan Recovery No." := Rec."No.";
            NewLoans.Advice := TRUE;
            NewLoans."Advice Type" := NewLoans."Advice Type"::"Fresh Loan";
            NewLoans.INSERT(TRUE);
        end;
        /*NewLoans.RESET;
        NewLoans.SETRANGE(NewLoans."Member No.", MemNo);
        NewLoans.SETRANGE(NewLoans."Loan Product Type", ProductFactory."Product ID");
        NewLoans.SETRANGE(NewLoans.Posted, FALSE);
        IF NewLoans.FIND('-') THEN begin

        end;*/

    end;

    /// <summary>
    /// SetClearanceLines.
    /// </summary>
    procedure SetClearanceLines()
    var
        LoanBalance: Decimal;
        Loans: Record Loans;
        RemInst: Integer;
        Rschedule: Record "Loan Repayment Schedule";
        //LoansProcess: Codeunit "Loans Process";
        ClearanceLines: Record "Loan Clearance Lines";
        LoanGuarantor: Record "Loan Guarantors And Security";
        SavingsAccounts: Record "Savings Accounts";
        ProductF: Record "Product Factory";
        AvailAmount: Decimal;
    // Periodic: Codeunit "Periodic Activities";
    begin


        ClearanceLines.Reset;
        ClearanceLines.SetRange(ClearanceLines."Clearance Header No.", Rec."No.");
        ClearanceLines.SetRange(Posted, true);
        if ClearanceLines.FindFirst then
            Error('Operation Not Acceptable. One or more lines have already been posted');



        ClearanceLines.Reset;
        ClearanceLines.SetRange("Clearance Header No.", Rec."No.");
        if ClearanceLines.FindFirst then
            ClearanceLines.DeleteAll;

        Loans.Reset;
        Loans.SetRange("Member No.", Rec."Member No.");
        /* IF Rec."Recover From FOSA" and (Rec."Global Dimension 1 Code" <> 'FOSA') then
             Loans.SetRange("Global Dimension 1 Code", 'FOSA')
         else
             Loans.SetFilter("Global Dimension 1 Code", '<>%1', 'FOSA');*/
        Loans.SetRange("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
        Loans.SetFilter("Outstanding Balance", '>0');
        if Loans.Find('-') then begin
            repeat
                Loans.CalcFields("Outstanding Appraisal", "Outstanding Balance", "Outstanding Interest", "Outstanding Penalty", "Outstanding Loan Reg. Fee");

                if Loans."Outstanding Interest" < 0 then
                    Loans."Outstanding Interest" := 0;
                if Loans."Outstanding Appraisal" < 0 then
                    Loans."Outstanding Appraisal" := 0;
                if Loans."Outstanding Penalty" < 0 then
                    Loans."Outstanding Penalty" := 0;
                if Loans."Outstanding Loan Reg. Fee" < 0 then
                    Loans."Outstanding Loan Reg. Fee" := 0;

                LoanBalance := Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Outstanding Appraisal" + Loans."Outstanding Penalty" + Loans."Outstanding Loan Reg. Fee";
                //MESSAGE('%1',LoanBalance);

                RemInst := 0;

                Rschedule.Reset;
                Rschedule.SetRange("Loan No.", Loans."Loan No.");
                if not Rschedule.FindFirst then
                    //  LoansProcess.GenerateRepaymentSchedule(Loans);

                    Rschedule.Reset;
                Rschedule.SetRange("Loan No.", Loans."Loan No.");
                Rschedule.SetFilter("Repayment Date", '%1..', Today);
                if Rschedule.FindFirst then begin
                    RemInst := Rschedule.Count;
                end;

                if RemInst <= 0 then
                    RemInst := 0;

                LoanGuarantor.Reset;
                LoanGuarantor.SetRange("Loan No", Loans."Loan No.");
                LoanGuarantor.SetRange("Guarantor Type", LoanGuarantor."Guarantor Type"::Guarantor);
                LoanGuarantor.SetRange(Substituted, false);
                LoanGuarantor.SetRange("Defaulter Release", false);
                LoanGuarantor.SetFilter("Savings Account No./Member No.", '<>%1', '');
                LoanGuarantor.SetFilter("Guarantor Status", '%1', LoanGuarantor."Guarantor Status"::Active);
                if LoanGuarantor.Find('-') then begin
                    repeat

                        LoanGuarantor.CalcFields("Total Loan Guarantorship", "Guarantor Count");
                        ClearanceLines.Init;
                        ClearanceLines."Clearance Header No." := Rec."No.";
                        ClearanceLines."Loan No." := Loans."Loan No.";

                        ClearanceLines."Account No." := LoanGuarantor."Savings Account No./Member No.";

                        if LoanGuarantor."Guarantor Count" > 0 then
                            ClearanceLines."Amount to Recover" := Round(LoanBalance / LoanGuarantor."Guarantor Count", 0.01, '<');
                        ClearanceLines."Amount to Recover" := ClearanceLines."Amount to Recover";
                        if LoanGuarantor."Member No" = '' then begin
                            if SavingsAccounts.Get(LoanGuarantor."Savings Account No./Member No.") then
                                LoanGuarantor."Member No" := SavingsAccounts."Member No.";
                        end;
                        LoanGuarantor.TestField("Member No");
                        ClearanceLines."Guarantor Member No." := LoanGuarantor."Member No";

                        AvailAmount := 0;
                        ProductF.Reset;
                        ProductF.SetRange("Product Class Type", ProductF."Product Class Type"::Savings);
                        ProductF.SetFilter("Product Category", '<>%1&<>%2', ProductF."Product Category"::"Deposit Contribution", ProductF."Product Category"::"Micro Credit Deposits");
                        ProductF.SetRange("Can Offset Loan", true);
                        if ProductF.Find('-') then begin
                            repeat
                                SavingsAccounts.Reset;
                                SavingsAccounts.SetRange(SavingsAccounts."Member No.", LoanGuarantor."Member No");
                                SavingsAccounts.SetRange(SavingsAccounts."Product Type", ProductF."Product ID");
                                if SavingsAccounts.Find('-') then begin
                                    repeat
                                    // AvailAmount += Periodic.GetAccountBalance(SavingsAccounts."No.");
                                    until SavingsAccounts.Next = 0;
                                end;
                            until ProductF.Next = 0;
                        end;



                        AvailAmount := 0;
                        ProductF.Reset;
                        ProductF.SetRange("Product Class Type", ProductF."Product Class Type"::Savings);
                        ProductF.SetRange("Product Category", ProductF."Product Category"::"Deposit Contribution");
                        // ProductF.SETRANGE("Can Offset Loan",TRUE);
                        if ProductF.Find('-') then begin
                            repeat
                                SavingsAccounts.Reset;
                                SavingsAccounts.SetRange(SavingsAccounts."Member No.", LoanGuarantor."Member No");
                                SavingsAccounts.SetRange(SavingsAccounts."Product Type", ProductF."Product ID");
                                if SavingsAccounts.Find('-') then begin
                                    repeat
                                    //AvailAmount += Periodic.GetAccountBalance(SavingsAccounts."No.");
                                    until SavingsAccounts.Next = 0;
                                end;
                            until ProductF.Next = 0;
                        end;

                        ClearanceLines."Amount Guaranteed" := AvailAmount;

                        ClearanceLines.Insert;

                    until LoanGuarantor.Next = 0;
                end;
            until Loans.Next = 0;
        end;
    end;

    /// <summary>
    /// EmailClearanceCert.
    /// </summary>
    procedure EmailClearanceCert()
    var
        //LoansProcess: Codeunit "Loans Process";
        Loans: Record Loans;
    begin
        Loans.RESET;
        Loans.SetRange("Loan No.", Rec."Loan No");
        If Loans.Find('-') then begin
            Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Interest Suspended");
            /*   IF (Loans."Outstanding Balance" + Loans."Outstanding Interest" + Loans."Interest Suspended") <= 0 then
                  LoansProcess.EmailClearanceCert(Loans."Member No."); */
        end;

    end;

    /// <summary>
    /// SendClearanceSMS.
    /// </summary>
    procedure SendClearanceSMS()
    var
        //SendSMS: Codeunit SendSms;
        Member: Record Members;
        LoanII: Record Loans;
        Source: Option "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application","Loan Witness",PV,"Insurance Expiry",Delegate;
    begin
        Member.reset;
        Member.SetRange("No.", rec."Member No.");
        if member.FindFirst() then begin
            LoanII.Reset();
            LoanII.SetRange("Loan No.", rec."Loan No");
            if LoanII.FindFirst() then begin
                LoanII.CalcFields("Outstanding Balance", "Outstanding Interest");
                /* SendSMS.SendSms(Source::"Loan defaulted", Member."Mobile Phone No"
                 , 'Dear ' + Member."First Name" + ', your ' + LoanII."Loan Product Type Name" + ' ' + "Loan No" + ', of Kshs '
                 + Format("Amount to Recover") + ' has been recovered from your deposits', rec."No.", LoanII."Loan No.", false, false); */
            end;
        end;
    end;

    /// <summary>
    /// SendClearanceSMSGua.
    /// </summary>
    procedure SendClearanceSMSGua()
    var
        // SendSMS: Codeunit SendSms;
        Member: Record Members;
        LoanII: Record Loans;
        Source: Option "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application","Loan Witness",PV,"Insurance Expiry",Delegate;
    begin
        Member.reset;
        Member.SetRange("No.", rec."Member No.");
        if member.FindFirst() then begin
            LoanII.Reset();
            LoanII.SetRange("Loan No.", rec."Loan No");
            if LoanII.FindFirst() then begin
                LoanII.CalcFields("Outstanding Balance", "Outstanding Interest");
                /* SendSMS.SendSms(Source::"Loan defaulted", Member."Mobile Phone No"
                 , 'Dear ' + Member."First Name" + ', your loan ' + "Loan No" + ', of Kshs '
                 + Format(LoanII."Approved Amount") + ' has been recovered from your guarantors deposits', rec."No.", LoanII."Loan No.", false, false);*/
            end;
        end;
    end;
}
