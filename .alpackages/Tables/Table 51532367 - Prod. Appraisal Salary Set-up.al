/// <summary>
/// Table Prod. Appraisal Salary Set-up (ID 51532367).
/// </summary>
table 51532367 "Prod. Appraisal Salary Set-up"
{
    //DrillDownPageID = "Appraisal Salary Set-up";
    //LookupPageID = "Appraisal Salary Set-up";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Appraisal Score Set-up".Code;

            trigger OnValidate()
            begin
                if AppraisalSalarySetup.Get(Code) then begin
                    Description := AppraisalSalarySetup.Description;

                    Type := AppraisalSalarySetup.Type;
                    "Amount Calculation Method" := AppraisalSalarySetup."Amount Calculation Method";
                    "Rate Per unit" := AppraisalSalarySetup."Rate Per unit";
                end;
            end;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Type"; Option)
        {
            OptionCaption = ' ,Earnings,Deductions,Basic,Other Allowances,Cleared Effects,Voluntary Deductions,Gross Pay,Net Pay,Bonus';
            OptionMembers = " ",Earnings,Deductions,Basic,"Other Allowances","Cleared Effects","Voluntary Deductions","Gross Pay","Net Pay",Bonus;
        }
        field(4; "Amount Calculation Method"; Option)
        {
            OptionCaption = 'General,Based On Rate';
            OptionMembers = General,"Based On Rate";
        }
        field(5; "Rate Per unit"; Decimal)
        {
        }
        field(6; "Product ID"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
        }
        field(7; "Multiplier Qualification"; Decimal)
        {
        }
        field(8; "Deduction Type"; Option)
        {
            OptionMembers = " ","Statutory","Long Term";
        }
    }

    keys
    {
        key(Key1; "Code", "Product ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AppraisalSalarySetup: Record "Appraisal Score Set-up";
}

