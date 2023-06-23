/// <summary>
/// Table PR Transaction Codes (ID 51533107).
/// </summary>
table 51533107 "PR Transaction Codes"
{
    //DrillDownPageID = "PR Transaction Codes List";
    //LookupPageID = "PR Transaction Codes List";

    fields
    {
        field(1; "Transaction Code"; Code[20])
        {
            Description = 'Unique Trans line code';
        }
        field(3; "Transaction Name"; Text[100])
        {
            Description = 'Description';
        }
        field(4; "Balance Type"; Option)
        {
            Description = 'None,Increasing,Reducing';
            OptionMembers = "None",Increasing,Reducing;
        }
        field(5; "Transaction Type"; Option)
        {
            Description = 'Income,Deduction';
            OptionMembers = Income,Deduction;
        }
        field(6; Frequency; Option)
        {
            Description = 'Fixed,Varied';
            OptionMembers = "Fixed",Varied;
        }
        field(7; "Is Cash"; Boolean)
        {
            Description = 'Does staff receive cash for this transaction';
        }
        field(8; Taxable; Boolean)
        {
            Description = 'Is it taxable or not';

            trigger OnValidate()
            begin

                TestField("Transaction Type", "Transaction Type"::Income);
            end;
        }
        field(9; "Is Formula"; Boolean)
        {
            Description = 'Is the transaction based on a formula';
        }
        field(10; Formula; Text[200])
        {
            Description = '[Formula] If the above field is "Yes", give the formula';
        }
        field(16; "Amount Preference"; Option)
        {
            Description = 'Either (Posted Amount), (Take Higher) or (Take Lower)';
            OptionMembers = "Posted Amount","Take Higher","Take Lower ";
        }
        field(18; "Special Transactions"; Option)
        {
            Description = 'Represents all Special Transactions';
            OptionMembers = "None","Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan (Non-Sacco)","Value of Quarters",Mortgage,Pension,"Mortgage Relief","Staff Loan (Sacco)","Leave Allowance";
        }
        field(21; "Deduct Premium"; Boolean)
        {
            Description = '[Insurance] Should the Premium be treated as a payroll deduction?';
        }
        field(26; "Interest Rate"; Decimal)
        {
            Description = '[Loan] If above is "Yes", give the interest rate';
        }
        field(28; "Repayment Method"; Option)
        {
            Description = '[Loan] Reducing,Straight line';
            OptionMembers = Reducing,"Straight line",Amortized;
        }
        field(29; "Fringe Benefit"; Boolean)
        {
            Description = '[Loan] should the loan be treated as a Fringe Benefit?';
        }
        field(30; "Employer Deduction"; Boolean)
        {
            Description = 'Caters for Employer Deductions';
        }
        field(31; isHouseAllowance; Boolean)
        {
            Description = 'Flags if its house allowance - Dennis';
        }
        field(32; "Include Employer Deduction"; Boolean)
        {
            Description = 'Is the transaction to include the employer deduction? - Dennis';
        }
        field(33; "Is Formula for employer"; Text[200])
        {
            Description = '[Is Formula for employer] If the above field is "Yes", give the Formula for employer Dennis';
        }
        field(34; "Transaction Code old"; Code[50])
        {
            Description = 'Old Unique Trans line code - Dennis';
        }
        field(35; "GL Account"; Code[50])
        {
            Description = '"G/L Account".No.';
            TableRelation = "G/L Account"."No.";
        }
        field(36; "GL Employee Account"; Code[50])
        {
            Description = 'to post to GLemployee  account - Dennis';
        }
        field(37; "coop parameters"; Option)
        {
            Caption = 'Other Categorization';
            Description = 'to be able to report the different coop contributions -Dennis';
            OptionMembers = "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,NSSF,Overtime,NHIF;
        }
        field(38; "IsCoop/LnRep"; Boolean)
        {
            Description = 'to be able to report the different coop contributions -Dennis';
        }
        field(39; "Deduct Mortgage"; Boolean)
        {
        }
        field(40; Subledger; Option)
        {
            OptionMembers = " ",Customer,Vendor,Credit,Savings;
        }
        field(41; Welfare; Boolean)
        {
        }
        field(42; CustomerPostingGroup; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(210; "Previous Month Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(211; "Current Month Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(212; "Prev. Amount"; Decimal)
        {
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Payroll Period" = FIELD("Previous Month Filter"),
                                                                     "Transaction Code" = FIELD("Transaction Code"),
                                                                     "Employee Code" = FIELD("Employee Code Filter")));
            FieldClass = FlowField;
        }
        field(213; "Curr. Amount"; Decimal)
        {
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Payroll Period" = FIELD("Current Month Filter"),
                                                                     "Transaction Code" = FIELD("Transaction Code"),
                                                                     "Employee Code" = FIELD("Employee Code Filter")));
            FieldClass = FlowField;
        }
        field(219; "Transaction Category"; Option)
        {
            OptionCaption = ' ,Housing,Transport,Other Allowances,NHF,Pension,Company Loan,Housing Deduction,Personal Loan,Inconvinience,Bonus Special,Other Deductions,Overtime,Entertainment,Leave,Utility,Other Co-deductions,Car Loan,Call Duty,Co-op,Lunch,Compassionate Loan';
            OptionMembers = " ",Housing,Transport,"Other Allowances",NHF,Pension,"Company Loan","Housing Deduction","Personal Loan",Inconvinience,"Bonus Special","Other Deductions",Overtime,Entertainment,Leave,Utility,"Other Co-deductions","Car Loan","Call Duty","Co-op",Lunch,"Compassionate Loan";
        }
        field(220; "Employee Code Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR Employees"."No.";
        }
        field(221; Suspended; Boolean)
        {
        }
        field(222; "Include in Net"; Boolean)
        {
        }
        field(223; "Taxable Percentage"; Decimal)
        {
        }
        field(224; "No. Series"; Code[20])
        {
        }
        field(225; "IsTraining Deduction"; Boolean)
        {
        }
        field(226; "Is Salary Advance"; Boolean)
        {
        }
        field(227; "Is Income/Deduction"; Boolean)
        {
        }
        field(228; "iTax Grouping"; Option)
        {
            OptionMembers = " ","Housing Allowances","Transport Allowance",OT,"Directors Fees";
        }
        field(229; "Is HR Loan"; Boolean)
        {
        }
        field(39003900; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                "Global Dimension 1 Name" := '';
                DimensionValue.Reset;
                DimensionValue.SetRange(DimensionValue.Code, "Global Dimension 1 Code");
                if DimensionValue.Find('-') then begin
                    "Global Dimension 1 Name" := DimensionValue.Name;
                end;
            end;
        }
        field(39003901; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                "Global Dimension 2 Name" := '';
                DimensionValue.Reset;
                DimensionValue.SetRange(DimensionValue.Code, "Global Dimension 2 Code");
                if DimensionValue.Find('-') then begin
                    "Global Dimension 2 Name" := DimensionValue.Name;
                end;
            end;
        }
        field(39003930; "Global Dimension 1 Name"; Text[60])
        {
            Editable = false;
        }
        field(39003931; "Global Dimension 2 Name"; Text[60])
        {
            Editable = false;
        }
        field(39003933; "IsTransfer Allowance"; Boolean)
        {
        }
        field(39003934; "IsLeave Allowance"; Boolean)
        {
        }
        field(39003935; "IsActing Allowance"; Boolean)
        {
        }
        field(39003940; "Group Code"; Code[20])
        {
        }
        field(39003941; "Group Description"; Text[50])
        {
        }
        field(39003942; "Loan Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
        }
        field(39003943; "Based on Loans"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Transaction Code")
        {
        }
        key(Key2; "Transaction Name")
        {
        }
        key(Key3; "Transaction Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Transaction Code", "Transaction Name")
        {
        }
    }

    trigger OnInsert()
    begin
        /*
        IF "Transaction Type" = "Transaction Type"::Deduction THEN
        BEGIN
          IF "Transaction Code" = '' THEN
          BEGIN
              HRSetup.GET;
              HRSetup.TESTFIELD(HRSetup."PR Deduction Nos.");
              NoSeriesMgt.InitSeries(HRSetup."PR Deduction Nos.",xRec."No. Series",0D,"Transaction Code","No. Series");
          END;
        END;
        
        IF "Transaction Type" = "Transaction Type"::Income THEN
        BEGIN
          IF "Transaction Code" = '' THEN
          BEGIN
              HRSetup.GET;
              HRSetup.TESTFIELD(HRSetup."PR Allowances Nos.");
              NoSeriesMgt.InitSeries(HRSetup."PR Allowances Nos.",xRec."No. Series",0D,"Transaction Code","No. Series");
          END;
        END;
        */

    end;

    var
        PRTransCodes: Record "PR Transaction Codes";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimensionValue: Record "Dimension Value";
}

