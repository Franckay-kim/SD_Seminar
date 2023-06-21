table 51532009 "Employer Salary/Checkoff Head"
{
    Caption = 'Employer Salary/Checkoff Head';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Employer Gross Salary Nos");
                    "No. Series" := '';
                    "No." := UpperCase("No.");
                end;
            end;
        }
        field(2; "Generation Date"; Date)
        {
            Caption = 'Generation Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Employer Code"; Code[30])
        {
            Caption = 'Employer Code';
            DataClassification = ToBeClassified;
            //TableRelation = Customer."No." where("Account Type" = const(Employer));

            trigger OnValidate()
            var
                Emp: Record Customer;
            begin
                Emp.Reset();
                Emp.SetRange("No.", "Employer Code");
                if Emp.Find('-') then begin
                    "Employer Name" := Emp.Name;
                end;
            end;
        }
        field(4; "Employer Name"; Text[150])
        {
            Caption = 'Employer Name';
            DataClassification = ToBeClassified;
        }
        field(5; "Created By"; Code[30])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(6; "Global Dimension 1"; Code[30])
        {
            Caption = 'Global Dimension 1';
            DataClassification = ToBeClassified;
        }
        field(7; "Global Dimension 2"; Code[30])
        {
            Caption = 'Global Dimension 2';
            DataClassification = ToBeClassified;
        }
        field(8; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            DataClassification = ToBeClassified;
        }
        field(9; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = ToBeClassified;
        }
        field(10; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(11; Generated; Boolean)
        {
            trigger OnValidate()

            begin
                "Generation Date" := Today;
            end;

        }

        field(12; Status; Option)
        {
            OptionMembers = Open,Pending,Approved,Rejected;
            Editable = false;
        }
        field(13; "Loan CutOff Date"; Date)
        {

        }
        field(14; "Total Salary"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Employer Salary/Checkoff Lines".Amount where("Header No." = field("No."), "Receipt Class" = const(Salary)));
        }
        field(15; "Total CheckOff"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Employer Salary/Checkoff Lines".Amount where("Header No." = field("No."), "Receipt Class" = const(Checkoff)));
        }
        field(16; "Salary Generated"; Boolean)
        {

        }
        field(17; "Checkoff Generated"; Boolean)
        {

        }
        field(18; "Checkoff No."; Code[30])
        {

        }
        field(19; "Salary Header No."; Code[30])
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
            SeriesSetup.TestField(SeriesSetup."Employer Gross Salary Nos");
            NoSeriesMgt.InitSeries(SeriesSetup."Employer Gross Salary Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        USetup.Reset();
        USetup.SetRange("User ID", UserId);
        /*  if USetup.FindFirst() then begin
             "Global Dimension 1" := USetup."Global Dimension 1 Code";
             "Global Dimension 2" := USetup."Global Dimension 2 Code";
         end; */
        "Created By" := UserId;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure ValidateBuffer()
    var
        EmployerBuff: Record "Employer Salary/Checkoff Buffe";
        EmployerLines: Record "Employer Salary/Checkoff Lines";
        ProdFact: Record "Product Factory";
        Loans: Record Loans;
        Savings: Record "Savings Accounts";
        RunBal: Decimal;
        TotBosaLoans: Decimal;
    begin
        TestField(Generated, false);
        IF "Period Start Date" = 0D then
            "Period Start Date" := CalcDate('-CM', Today);
        IF "Period End Date" = 0D then
            "Period End Date" := CalcDate('CM', Today);
        RunBal := 0;
        EmployerLines.Reset();
        EmployerLines.SetRange("Header No.", "No.");
        EmployerLines.SetRange("Period Start Date", "Period Start Date");
        EmployerLines.SetRange("Period End Date", "Period End Date");
        EmployerLines.DeleteAll();
        EmployerBuff.Reset();
        EmployerBuff.SetRange("Header No.", "No.");
        EmployerBuff.SetFilter(Amount, '>0');
        EmployerBuff.SetRange("Period Start Date", "Period Start Date");
        EmployerBuff.SetRange("Period End Date", "Period End Date");
        if EmployerBuff.Find('-') then
            repeat
                EmployerBuff.Validate("Employer Code", "Employer Code");
                if EmployerBuff."Staff No." <> '' then
                    EmployerBuff.Validate("Staff No.", EmployerBuff."Staff No.");
                if EmployerBuff."Member No." <> '' then
                    EmployerBuff.Validate("Member No.", EmployerBuff."Member No.");
                Clear(TotBosaLoans);
                Loans.Reset();
                // Loans.SetRange("Global Dimension 1 Code", 'BOSA');
                Loans.SetRange("Recovery Mode", Loans."Recovery Mode"::"Check Off");
                Loans.SetRange("Member No.", EmployerBuff."Member No.");
                Loans.SetFilter("Disbursement Date", '..%1', "Loan CutOff Date");
                Loans.SetFilter("Outstanding Balance", '>0');
                if Loans.Find('-') then
                    TotBosaLoans := 0;
                repeat

                    Loans.CalcFields("Outstanding Interest", "Outstanding Balance");
                    if Loans."Outstanding Balance" > Loans."Loan Principle Repayment" then
                        TotBosaLoans += Loans."Loan Principle Repayment" + Loans."Outstanding Interest"
                    else
                        TotBosaLoans += Loans."Outstanding Balance" + Loans."Outstanding Interest";

                until Loans.Next() = 0;
                //add savings due in month
                Savings.Reset();
                Savings.SetRange("Member No.", EmployerBuff."Member No.");
                Savings.SetFilter("Monthly Contribution", '>0');
                Savings.SetFilter("Date Filter", '%1..%2', EmployerBuff."Period Start Date", EmployerBuff."Period End Date");
                if Savings.Find('-') then
                    repeat
                        Savings.CalcFields(Balance);
                        if Savings.Balance < Savings."Monthly Contribution" then
                            TotBosaLoans += Savings."Monthly Contribution" - Savings.Balance;

                    until Savings.Next() = 0;

                //create employer lines
                if TotBosaLoans > 0 then begin
                    EmployerLines.Reset();
                    EmployerLines.Init();
                    EmployerLines."Line No." := 0;
                    EmployerLines."Header No." := "No.";
                    EmployerLines.Validate("Member No.", EmployerBuff."Member No.");
                    if EmployerBuff.Amount > TotBosaLoans then
                        EmployerLines.Validate(Amount, TotBosaLoans)
                    else
                        EmployerLines.Validate(Amount, EmployerBuff.Amount);
                    EmployerLines.Validate("Employer Code", "Employer Code");
                    EmployerLines.Validate("Period Start Date", "Period Start Date");
                    EmployerLines.Validate("Period End Date", "Period End Date");
                    EmployerLines.Validate("Receipt Class", EmployerLines."Receipt Class"::Checkoff);
                    IF EmployerLines.Amount > 0 then
                        EmployerLines.Insert(true);
                end;
                if EmployerBuff.Amount > TotBosaLoans then begin
                    EmployerLines.Reset();
                    EmployerLines.Init();
                    EmployerLines."Line No." := 0;
                    EmployerLines."Header No." := "No.";
                    EmployerLines.Validate("Member No.", EmployerBuff."Member No.");

                    EmployerLines.Validate(Amount, (EmployerBuff.Amount - TotBosaLoans));
                    EmployerLines.Validate("Employer Code", "Employer Code");
                    EmployerLines.Validate("Period Start Date", "Period Start Date");
                    EmployerLines.Validate("Period End Date", "Period End Date");
                    EmployerLines.Validate("Receipt Class", EmployerLines."Receipt Class"::Salary);
                    IF EmployerLines.Amount > 0 then
                        EmployerLines.Insert(true);
                end;
                EmployerBuff.Modify(true);
            until EmployerBuff.Next() = 0;

    end;

    procedure CreateNetPayoffLines(): Code[20]
    var
        SalaryH: Record "Salary Header";
        SalaryL: Record "Salary Lines";
        EmpLines: Record "Employer Salary/Checkoff Lines";
        SavingsAcc: Record "Savings Accounts";
        LineNo: Integer;
    begin
        CalcFields("Total Salary");
        Clear(LineNo);
        //TestField(Status, Status::Approved);
        TestField("Salary Generated", false);
        //create salary header
        SalaryH.Reset();
        SalaryH.Init();
        SalaryH.No := '';
        SalaryH.Validate("Account Type", SalaryH."Account Type"::Customer);
        SalaryH.Validate("Account No", Rec."Employer Code");
        SalaryH.Validate(Amount, Rec."Total Salary");
        SalaryH.Validate("Income Type", SalaryH."Income Type"::Salary);
        SalaryH.Validate(Remarks, Rec."No.");
        SalaryH.Insert(true);
        //create salary lines
        EmpLines.Reset();
        EmpLines.SetRange("Header No.", Rec."No.");
        EmpLines.SetRange("Receipt Class", EmpLines."Receipt Class"::Salary);
        if EmpLines.Find('-') then
            repeat
                SavingsAcc.Reset();
                SavingsAcc.SetRange("Member No.", EmpLines."Member No.");
                SavingsAcc.SetRange("Product Category", SavingsAcc."Product Category"::Prime);
                if SavingsAcc.FindFirst() then begin
                    SalaryL.Init();
                    LineNo += 100;
                    SalaryL.Validate("Salary Header No.", SalaryH.No);
                    SalaryL.Validate("No.", LineNo);
                    SalaryL.Validate("Account No.", SavingsAcc."No.");
                    SalaryL.Validate(Amount, EmpLines.Amount);
                    SalaryL.Validate("Member No.", SavingsAcc."Member No.");
                    SalaryL.Validate("ID No.", SavingsAcc."ID No.");
                    SalaryL.Insert(true);
                end;

            until EmpLines.Next() = 0;
        Validate("Salary Generated", true);
        Validate("Salary Header No.", SalaryH.No);
        Modify(true);
        exit(SalaryH.No);
    end;

    procedure CreateCheckoffLines(): Code[20]
    var
        CheckOffHead: Record "Checkoff Header";
        CheckoffLines: Record "Checkoff Lines";
        CheckoffBuffer: Record "Checkoff Buffer";
        EmpLines: Record "Employer Salary/Checkoff Lines";
        SavingsAcc: Record "Savings Accounts";
        LineNo: Integer;
    begin
        //TestField(Status, Status::Approved);
        TestField("Checkoff Generated", false);
        //create checkoffhead
        Clear(LineNo);
        CalcFields("Total CheckOff");
        CheckOffHead.Reset();
        CheckOffHead.Init();
        CheckOffHead."No." := '';
        CheckOffHead.Validate("Account Type", CheckOffHead."Account Type"::Customer);
        CheckOffHead.Validate("Account No.", Rec."Employer Code");
        CheckOffHead.Validate(Amount, Rec."Total CheckOff");
        CheckOffHead.Validate("Employer Code", Rec."Employer Code");
        CheckOffHead.Validate("CheckOff Type", CheckOffHead."CheckOff Type"::Block);
        CheckOffHead.Insert(true);
        //create checkoff buffer
        EmpLines.Reset();
        EmpLines.SetRange("Header No.", Rec."No.");
        EmpLines.SetRange("Receipt Class", EmpLines."Receipt Class"::Checkoff);
        if EmpLines.Find('-') then
            repeat
                LineNo += 1;
                CheckoffBuffer.Reset();

                CheckoffBuffer.Init();

                CheckoffBuffer.Validate("Checkoff No", CheckOffHead."No.");
                CheckoffBuffer.Validate(No, LineNo);
                CheckoffBuffer.Validate("Upload No.", EmpLines."Member No.");
                CheckoffBuffer.Validate("Upload Response", 2);
                CheckoffBuffer.Validate(Amount, EmpLines.Amount);
                CheckoffBuffer.Validate("Employer Code", "Employer Code");
                CheckoffBuffer.Insert(true);
            until EmpLines.Next() = 0;

        Validate("Checkoff Generated", true);
        Validate("Checkoff No.", CheckOffHead."No.");
        Modify(true);

        exit(CheckOffHead."No.");
    end;

}
