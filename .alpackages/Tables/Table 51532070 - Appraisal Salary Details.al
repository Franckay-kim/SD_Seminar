/// <summary>
/// Table Appraisal Salary Details (ID 51532070).
/// </summary>
table 51532070 "Appraisal Salary Details"
{

    fields
    {
        field(1; "Client Code"; Code[20])
        {
        }
        field(2; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Appraisal Score Set-up".Code;

            trigger OnValidate()
            begin
                if "SalarySet-up".Get(Code) then begin
                    Description := "SalarySet-up".Description;
                    Type := "SalarySet-up".Type;
                end;
            end;
        }
        field(3; Description; Text[30])
        {
        }
        field(4; Type; Option)
        {
            OptionCaption = ' ,Earnings,Deductions,Basic,Other Allowances,Cleared Effects,Voluntary Deductions,Gross Pay,Net Pay,Previous Bonus,Current Bonus,Junior';
            OptionMembers = " ",Earnings,Deductions,Basic,"Other Allowances","Cleared Effects","Voluntary Deductions","Gross Pay","Net Pay","Previous Bonus","Current Bonus",Junior;
        }
        field(5; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                //IF (Type=Type::"Net Pay") OR (Type=Type::"Gross Pay") THEN
                //ERROR(Text002);
                if (Type = Type::"Gross Pay") then
                    Error(Text002);

                if Type = Type::Basic then begin
                    ApprDetails.Reset;
                    ApprDetails.SetRange(Type, Type::"Net Pay");
                    ApprDetails.SetRange("Loan No", "Loan No");
                    if ApprDetails.Find('-') then begin
                        ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                        ApprDetails.Modify;
                    end;
                    ApprDetails.Reset;
                    ApprDetails.SetRange(Type, Type::"Gross Pay");
                    ApprDetails.SetRange("Loan No", "Loan No");
                    if ApprDetails.Find('-') then begin
                        ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                        ApprDetails.Modify;
                    end;
                end else
                    if Type = Type::"Cleared Effects" then begin
                        ApprDetails.Reset;
                        ApprDetails.SetRange(Type, Type::"Net Pay");
                        ApprDetails.SetRange("Loan No", "Loan No");
                        if ApprDetails.Find('-') then begin
                            ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                            ApprDetails.Modify;
                        end;
                        //Type::

                    end else
                        if Type = Type::Deductions then begin
                            ApprDetails.Reset;
                            ApprDetails.SetRange(Type, Type::"Net Pay");
                            ApprDetails.SetRange("Loan No", "Loan No");
                            if ApprDetails.Find('-') then begin
                                ApprDetails.Amount := ApprDetails.Amount - Amount + xRec.Amount;
                                ApprDetails.Modify;
                            end;

                        end else
                            if Type = Type::Earnings then begin
                                ApprDetails.Reset;
                                ApprDetails.SetRange(Type, Type::"Net Pay");
                                ApprDetails.SetRange("Loan No", "Loan No");
                                if ApprDetails.Find('-') then begin
                                    ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                                    ApprDetails.Modify;
                                end;
                                ApprDetails.Reset;
                                ApprDetails.SetRange(Type, Type::"Gross Pay");
                                ApprDetails.SetRange("Loan No", "Loan No");
                                if ApprDetails.Find('-') then begin
                                    ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                                    ApprDetails.Modify;
                                end;
                            end else
                                if Type = Type::"Other Allowances" then begin
                                    ApprDetails.Reset;
                                    ApprDetails.SetRange(Type, Type::"Net Pay");
                                    ApprDetails.SetRange("Loan No", "Loan No");
                                    if ApprDetails.Find('-') then begin
                                        ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                                        ApprDetails.Modify;
                                    end;
                                    ApprDetails.Reset;
                                    ApprDetails.SetRange(Type, Type::"Gross Pay");
                                    ApprDetails.SetRange("Loan No", "Loan No");
                                    if ApprDetails.Find('-') then begin
                                        ApprDetails.Amount := ApprDetails.Amount + Amount - xRec.Amount;
                                        ApprDetails.Modify;
                                    end;
                                end;
            end;
        }
        field(6; "Loan No"; Code[30])
        {
            TableRelation = Loans;

            trigger OnValidate()
            begin
                if LoanApp.Get("Loan No") then
                    "Client Code" := LoanApp."Member No.";
            end;
        }
        field(7; "Amount Calculation Method"; Option)
        {
            OptionCaption = 'General,Based On Rate';
            OptionMembers = General,"Based On Rate";

            trigger OnValidate()
            begin
                Amount := 0;
            end;
        }
        field(8; "Rate Per unit"; Decimal)
        {

            trigger OnValidate()
            begin
                TestField("Amount Calculation Method");
            end;
        }
        field(9; "No Of Units"; Decimal)
        {

            trigger OnValidate()
            begin
                TestField("Amount Calculation Method");
                TestField("Rate Per unit");
                Amount := "Rate Per unit" * "No Of Units";
            end;
        }
        field(10; "Multiplier Qualification"; Decimal)
        {
        }
        field(11; "Deduction Type"; Option)
        {
            OptionMembers = " ","Statutory","Long Term";

        }

    }

    keys
    {
        key(Key1; "Loan No", "Client Code", "Code")
        {
        }
        key(Key2; "Code", "Client Code", Type)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if LoanApp.Get("Loan No") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    trigger OnInsert()
    begin
        if LoanApp.Get("Loan No") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    trigger OnModify()
    var
        Text001: Label 'Loan is already %1 thus cannot modify';
    begin
        if LoanApp.Get("Loan No") then begin
            if (LoanApp.Status = LoanApp.Status::Appraisal) or (LoanApp.Status = LoanApp.Status::Approved) then
                Error(Text001, LoanApp.Status);
        end;
    end;

    var
        "SalarySet-up": Record "Appraisal Score Set-up";
        LoanApp: Record Loans;
        Text002: Label 'Do not capture anything here';
        ApprDetails: Record "Appraisal Salary Details";
        Text001: Label 'Loan is already %1 and cannot modify';
}

