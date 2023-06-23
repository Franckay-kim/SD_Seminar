/// <summary>
/// Table Online Loan Application (ID 51533451).
/// </summary>
table 51533451 "Online Loan Application"
{
    Caption = 'Online Loan Application';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Application No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Application Date"; DateTime)
        {
        }
        field(3; "Member No"; Text[20])
        {
            trigger OnValidate()
            begin
                Members.Get("Member No");
                "Employment No" := Members."Payroll/Staff No.";
                "Id No" := Members."ID No.";
                "Member Name" := Members.Name;
                Telephone := Members."Mobile Phone No";
                Email := Members."E-Mail";
                "Member Branch" := Members."Global Dimension 1 Code";
                "Employer Code" := Members."Employer Code";

                if (Members.Status <> Members.Status::Active) AND (Members.Status <> Members.Status::Dormant) then
                    Error('Your Member Status [%1] does not allow you to perform this action.', Members.Status);
            end;
        }
        field(4; "Member Name"; Text[100])
        {
        }
        field(5; "Employment No"; Text[10])
        {
        }
        field(6; Telephone; Text[30])
        {
        }
        field(7; Email; Text[30])
        {
        }
        field(8; "Loan Type"; Text[20])
        {
            trigger OnValidate()
            begin
                if not ProductFactory.Get("Loan Type") then exit;
                "Loan Type Name" := ProductFactory."Product Description";
                "Interest Rate" := ProductFactory."Interest Rate (Min.)";
            end;
        }
        field(9; "Loan Type Name"; Text[100])
        {
        }
        field(10; "Loan Amount"; Decimal)
        {
        }
        field(11; "Repayment Period"; Integer)
        {

        }
        field(12; "Basic Pay"; Decimal)
        {
        }
        field(13; "Total Allowances"; Decimal)
        {
        }
        field(14; "Total Deduction"; Decimal)
        {
        }
        field(15; "Interest Rate"; Decimal)
        {
        }
        field(16; Topup; Boolean)
        {
        }
        field(17; "Topup Ref"; Text[30])
        {
        }
        field(18; "Date Submitted"; DateTime)
        {

        }
        field(19; "Id No"; Text[30])
        {
        }
        field(20; Posted; Boolean)
        {
        }
        field(21; "Posted By"; Code[30])
        {
        }
        field(22; "Date Posted"; DateTime)
        {
        }
        field(23; "Loan No"; Code[100])
        {
        }
        field(24; "Member Branch"; Code[30])
        {

        }
        field(25; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pending,Submitted,Appraisal,Rejected,Cancelled;
        }
        field(26; "Employer Code"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "IP Address"; Code[20])
        {
        }
        field(28; "MAC Address"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Application No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Application Date" := CurrentDateTime;
    end;

    var
        Members: Record Members;
        ProductFactory: Record "Product Factory";
        Loans: Record Loans;


    /// <summary>
    /// CopySalaryDetails.
    /// </summary>
    /// <param name="LoanNo">Code[20].</param>
    procedure CopySalaryDetails(LoanNo: Code[20])
    var
        AppraisalSalaryDetails: Record "Appraisal Salary Details";
    begin
        AppraisalSalaryDetails.RESET;
        AppraisalSalaryDetails.VALIDATE("Loan No", LoanNo);
        AppraisalSalaryDetails.VALIDATE(Code, 'BASIC');
        AppraisalSalaryDetails.Description := 'Basic';
        AppraisalSalaryDetails.Type := AppraisalSalaryDetails.Type::Basic;
        AppraisalSalaryDetails.Amount := Rec."Basic Pay";
        AppraisalSalaryDetails.INSERT;

        AppraisalSalaryDetails.RESET;
        AppraisalSalaryDetails.VALIDATE("Loan No", LoanNo);
        AppraisalSalaryDetails.Code := 'ALLOWANCES';
        AppraisalSalaryDetails.Description := 'Allowances';
        AppraisalSalaryDetails.Type := AppraisalSalaryDetails.Type::"Other Allowances";
        AppraisalSalaryDetails.Amount := Rec."Total Allowances";
        AppraisalSalaryDetails.INSERT;

        AppraisalSalaryDetails.RESET;
        AppraisalSalaryDetails.VALIDATE("Loan No", LoanNo);
        AppraisalSalaryDetails.Code := 'DEDUCTIONS';
        AppraisalSalaryDetails.Description := 'Deductions';
        AppraisalSalaryDetails.Type := AppraisalSalaryDetails.Type::Deductions;
        AppraisalSalaryDetails.Amount := Rec."Total Deduction";
        AppraisalSalaryDetails.INSERT;
    end;

    /// <summary>
    /// CopyDocuments.
    /// </summary>
    /// <param name="LoanNo">Code[20].</param>
    procedure CopyDocuments(LoanNo: Code[20])
    var
        OnlineLoans: Record "Online Loan Application";
    begin
        Loans.GET(LoanNo);

        OnlineLoans.GET(Rec."Application No");
        IF OnlineLoans.HASLINKS THEN Loans.COPYLINKS(OnlineLoans);
    end;

    /// <summary>
    /// CopyTopup.
    /// </summary>
    /// <param name="LoanNo">Code[20].</param>
    procedure CopyTopup(LoanNo: Code[20])
    var
        LoansTopup: Record "Loans Top up";
    begin
        LoansTopup.RESET;
        LoansTopup."Loan No." := LoanNo;
        LoansTopup."Client Code" := Rec."Member No";
        LoansTopup.VALIDATE("Loan Top Up", Rec."Topup Ref");
        LoansTopup.INSERT(TRUE);
    end;

    /// <summary>
    /// CopyGuarantors.
    /// </summary>
    /// <param name="LoanNo">Code[20].</param>
    procedure CopyGuarantors(LoanNo: Code[20])
    var
        OnlineGuarantors: Record "Online Loan Guarantors";
        LoansGuarantors: Record "Loan Guarantors and Security";
        SavingsAccounts: Record "Savings Accounts";
    begin
        OnlineGuarantors.RESET;
        OnlineGuarantors.SETRANGE("Loan Application No", Rec."Application No");
        OnlineGuarantors.SETRANGE("Approval Status", OnlineGuarantors."Approval Status"::Approved);
        IF NOT OnlineGuarantors.FINDFIRST THEN EXIT;

        REPEAT
            SavingsAccounts.RESET;
            SavingsAccounts.SETRANGE("Member No.", OnlineGuarantors."Guarantor No.");
            SavingsAccounts.SETAUTOCALCFIELDS("Balance (LCY)");
            SavingsAccounts.SETFILTER("Balance (LCY)", '>%1', 0);
            SavingsAccounts.SETRANGE("Product Type", 'DEPOSITS');
            IF SavingsAccounts.FINDFIRST THEN BEGIN

                LoansGuarantors.RESET; //Reset variables
                LoansGuarantors.INIT;
                LoansGuarantors."Loan No" := LoanNo;
                LoansGuarantors."Guarantor Type" := LoansGuarantors."Guarantor Type"::Guarantor;
                LoansGuarantors.VALIDATE("Savings Account No./Member No.", SavingsAccounts."No.");
                LoansGuarantors.VALIDATE("Amount Guaranteed", OnlineGuarantors."Guarantor Amount");
                LoansGuarantors.INSERT(TRUE);

            END;
        UNTIL OnlineGuarantors.NEXT = 0;
    end;
}
