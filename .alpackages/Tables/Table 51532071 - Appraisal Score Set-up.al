table 51532071 "Appraisal Score Set-up"
{
    //DrillDownPageID = "Appraisal Salary Set-up";
    //LookupPageID = "Appraisal Salary Set-up";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = 'Character,Capital,Capability,Collateral,Condition Risk';
            OptionMembers = Character,Capital,Capability,Collateral,"Condition Risk";
        }
        field(4; "Amount Calculation Method"; Option)
        {
            OptionCaption = 'General,Based On Rate';
            OptionMembers = General,"Based On Rate";
        }
        field(5; "Rate Per unit"; Decimal)
        {
        }
        field(6; "Loan Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
        }
        field(7; "Multiplier Qualification"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

