/// <summary>
/// Table Other Commitements Clearance (ID 51532069).
/// </summary>
table 51532069 "Other Commitements Clearance"
{
    //DrillDownPageID = "Other Commitments Clearance";
    //LookupPageID = "Other Commitments Clearance";

    fields
    {
        field(1; "Loan No."; Code[30])
        {
            NotBlank = true;
            TableRelation = Loans."Loan No.";
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Payee; Text[50])
        {
            NotBlank = true;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(4; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if Amount < 0 then
                    Error('Amount cannot be less than 0');

                if LoanApp.Get("Loan No.") then begin
                    NetAmt := 0;
                    //NetAmt := LoansProcess.ComputeCharges(LoanApp."Approved Amount", LoanApp."Loan Product Type", LoanApp."Loan No.", 0);

                    //IF NetAmt-Amount<0 THEN
                    //ERROR(Text002);
                end;


                if Source = Source::Credit then begin
                    CalcFields("Total Loan Balance");

                    if Amount >= "Total Loan Balance" then begin
                        "Loan Clearance" := true;
                        Message('Loan Will be Fully Cleared');
                    end
                    else begin
                        "Loan Clearance" := false;
                        if not Confirm('Amount is not enough to clear the Loan. Only Current Loan Dues will be recovered. Continue?') then
                            Error('Aborted');
                    end;
                end;

                "Remaining Amount" := 0;
                if Type <> Type::"Internal Payment to Member" then
                    "Remaining Amount" := Amount;
            end;
        }
        field(5; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(6; "Bankers Cheque No"; Code[20])
        {
        }
        field(7; "Bankers Cheque No 2"; Code[20])
        {
        }
        field(8; "Bankers Cheque No 3"; Code[20])
        {
        }
        field(9; "Batch No."; Code[20])
        {
        }
        field(10; "Affects 2/3 Rule"; Boolean)
        {
            Editable = false;
        }
        field(11; "Monthly Deduction"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Monthly Deduction" > 0 then
                    "Affects 2/3 Rule" := true
                else
                    "Affects 2/3 Rule" := false;
            end;
        }
        field(12; "Account No."; Code[20])
        {
            TableRelation = IF (Type = FILTER("External Loan Clearance")) Vendor."No."
            ELSE
            IF (Type = FILTER("External Payment to Vendor")) Vendor."No."
            ELSE
            IF (Type = FILTER("Internal Payment to Member"),
                                     Source = CONST(Savings)) "Savings Accounts"."No."
            ELSE
            IF (Type = FILTER("Internal Payment to Member"),
                                              Source = CONST(Credit)) Members."No.";

            trigger OnValidate()
            begin

                "Loan Account" := '';
                "Member Loan No." := '';
                Description := '';
                "Account Name" := '';
                Amount := 0;


                if Type = Type::"Internal Payment to Member" then begin

                    if Source = Source::Savings then begin
                        if Account.Get("Account No.") then
                            "Account Name" := Account.Name;


                    end;

                    if Source = Source::Credit then
                        if Members.Get("Account No.") then
                            "Account Name" := Members.Name;


                end
                else begin

                    if Vend.Get("Account No.") then
                        "Account Name" := Vend.Name;

                end;

                Description := "Account Name";
            end;
        }
        field(13; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(14; Type; Option)
        {
            OptionCaption = 'External Loan Clearance,External Payment to Vendor/CASH,Internal Payment to Member';
            OptionMembers = "External Loan Clearance","External Payment to Vendor","Internal Payment to Member";
        }
        field(15; Source; Option)
        {
            OptionMembers = Savings,Credit;

            trigger OnValidate()
            begin
                if Source = Source::Credit then
                    if Type <> Type::"Internal Payment to Member" then
                        Error('This Option can only be used for Internal Payment to Member');


                "Account No." := '';
                "Loan Account" := '';
                "Member Loan No." := '';
                Description := '';
                "Account Name" := '';
                Amount := 0;
            end;
        }
        field(16; "Loan Account"; Code[20])
        {
            TableRelation = "Credit Accounts"."No." WHERE("Member No." = FIELD("Account No."));

            trigger OnValidate()
            begin

                "Member Loan No." := '';
                Amount := 0;
                if CreditAccounts.Get("Loan Account") then
                    Description := CreditAccounts."Product Name";
            end;
        }
        field(17; "Member Loan No."; Code[20])
        {
            TableRelation = Loans."Loan No." WHERE("Loan Account" = FIELD("Loan Account"));

            trigger OnValidate()
            begin

                Amount := 0;
            end;
        }
        field(18; "Loan Clearance"; Boolean)
        {
        }
        field(19; "Total Loan Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Customer No." = FIELD("Loan Account"),
                                                                  "Loan No" = FIELD("Member Loan No."),
                                                                  "Transaction Type" = FILTER(Loan | Repayment | "Interest Due" | "Interest Paid" | "Appraisal Due" | "Appraisal Paid" | "Penalty Due" | "Penalty Paid" | "Loan Registration Fee")));
            FieldClass = FlowField;
        }
        field(20; "PV Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(22; "Remaining Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Entry No.")
        {
            SumIndexFields = Amount;
        }
        key(Key2; Payee)
        {
        }
        key(Key3; "Batch No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) or (LoanApp.Posted) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    trigger OnInsert()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) or (LoanApp.Posted) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    trigger OnModify()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) or (LoanApp.Posted) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    trigger OnRename()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) or (LoanApp.Posted) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    var
        Text001: Label 'You cannot modify this since the loan is already %1';
        LoanApp: Record Loans;
        NetAmt: Decimal;
        //LoansProcess: Codeunit "Loans Process";
        Text002: Label 'The approved amount is not sufficient to offset commitments';
        Vend: Record Vendor;
        Account: Record "Savings Accounts";
        Members: Record Members;
        SavingsAccounts: Record "Savings Accounts";
        CreditAccounts: Record "Credit Accounts";
        ProductFactory: Record "Product Factory";
}

