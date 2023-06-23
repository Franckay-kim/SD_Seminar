/// <summary>
/// Table PR Vital Setup Info (ID 51533129).
/// </summary>
table 51533129 "PR Vital Setup Info"
{

    fields
    {
        field(1; "Setup Code"; Code[10])
        {
            Description = '[Relief]';
        }
        field(2; "Tax Relief"; Decimal)
        {
            Description = '[Relief]';
        }
        field(3; "Insurance Relief"; Decimal)
        {
            Description = '[Relief]';
        }
        field(4; "Max Relief"; Decimal)
        {
            Description = '[Relief]';
        }
        field(5; "Mortgage Relief"; Decimal)
        {
            Description = '[Relief]';
        }
        field(6; "Max Pension Contribution"; Decimal)
        {
            Description = '[Pension]';
        }
        field(7; "Tax On Excess Pension"; Decimal)
        {
            Description = '[Pension]';
        }
        field(8; "Loan Market Rate"; Decimal)
        {
            Description = '[Loans]';
        }
        field(9; "Loan Corporate Rate"; Decimal)
        {
            Description = '[Loans]';
        }
        field(10; "Taxable Pay (Normal)"; Decimal)
        {
            Description = '[Housing]';
        }
        field(11; "Taxable Pay (Agricultural)"; Decimal)
        {
            Description = '[Housing]';
        }
        field(12; "NHIF Based on"; Option)
        {
            Description = '[NHIF] - Gross,Basic,Taxable Pay';
            OptionMembers = Gross,Basic,"Taxable Pay";
        }
        field(13; "NSSF Employee"; Decimal)
        {
            Description = '[NSSF]';
        }
        field(14; "NSSF Employer Factor"; Decimal)
        {
            Description = '[NSSF]';
        }
        field(15; "OOI Deduction"; Decimal)
        {
            Description = '[OOI]';
        }
        field(16; "OOI December"; Decimal)
        {
            Description = '[OOI]';
        }
        field(17; "Security Day (U)"; Decimal)
        {
            Description = '[Servant]';
        }
        field(18; "Security Night (U)"; Decimal)
        {
            Description = '[Servant]';
        }
        field(19; "Ayah (U)"; Decimal)
        {
            Description = '[Servant]';
        }
        field(20; "Gardener (U)"; Decimal)
        {
            Description = '[Servant]';
        }
        field(21; "Security Day (R)"; Decimal)
        {
            Description = '[Servant]';
        }
        field(22; "Security Night (R)"; Decimal)
        {
            Description = '[Servant]';
        }
        field(23; "Ayah (R)"; Decimal)
        {
            Description = '[Servant]';
        }
        field(24; "Gardener (R)"; Decimal)
        {
            Description = '[Servant]';
        }
        field(25; "Benefit Threshold"; Decimal)
        {
            Description = '[Servant]';
        }
        field(26; "NSSF Based on"; Option)
        {
            Description = '[NSSF] - Gross,Basic,Taxable Pay';
            OptionMembers = Gross,Basic,"Taxable Pay";
        }
        field(27; "Value Posting"; Decimal)
        {
        }
        field(28; "Disbled Tax Limit"; Decimal)
        {
        }
        field(29; "Minimum Relief Amount"; Decimal)
        {
        }
        field(30; "Secondary Tax Percentage"; Decimal)
        {
        }
        field(31; "Mortgage Relief Percentage"; Decimal)
        {
        }
        field(32; "NHF - Maximum Age"; DateFormula)
        {
        }
        field(34; "Leave Allowance Percentage"; Decimal)
        {
        }
        field(35; "Incremental percentage"; Decimal)
        {
        }
        field(36; "Max. Leave Allowance"; Decimal)
        {
        }
        field(37; "Acting Allowance Percentage"; Decimal)
        {
        }
        field(38; "Acting Allowance Based On"; Option)
        {
            OptionCaption = ' ,Basic Pay,Gross Pay';
            OptionMembers = " ","Basic Pay","Gross Pay";
        }
        field(39; "Acting Allowance Duration"; DateFormula)
        {
        }
        field(41; "Leave Allowance Based On"; Option)
        {
            OptionMembers = " ","Basic Pay","Gross Pay","Net Pay";
        }
        field(42; "Training Deduction Percentage"; Decimal)
        {
        }
        field(43; "NHIF Relief"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '[Relief]';
        }
        field(39003942; "Based On Hours worked"; Option)
        {
            OptionCaption = ' ,BasedOnWorkedHrs';
            OptionMembers = " ",BasedOnWorkedHrs;

            trigger OnValidate()
            var
                i: Integer;
            begin
                /*
                HREmp.RESET;
                IF HREmp.FIND('-') THEN
                BEGIN
                    REPEAT
                         i:=i+1;
                        HREmp."Based On Hours worked":="Based On Hours worked";
                        HREmp.VALIDATE(HREmp."Based On Hours worked");
                         HREmp.MODIFY;
                    UNTIL HREmp.NEXT =0;
                    MESSAGE('%1 Employees Payroll will be calculated Based on attendance records',i);
                END;
                */

            end;
        }
        field(39003943; "Monthly Expected Work Hrs"; Decimal)
        {
        }
        field(39003944; prVitalSetup; Decimal)
        {
        }
        field(39003945; "Salary increment %"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Setup Code")
        {
        }
    }

    fieldgroups
    {
    }
}

