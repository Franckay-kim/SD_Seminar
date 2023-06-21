table 51532011 "Loan Charges"
{
    // DrillDownPageID = "Loan Charges";
    // LookupPageID = "Loan Charges";

    fields
    {
        field(1; "Charge Code"; Code[20])
        {
        }
        field(2; "Charge Description"; Text[70])
        {
        }
        field(3; "Charge Amount"; Decimal)
        {
        }
        field(4; "Use Percentage"; Boolean)
        {
        }
        field(5; Percentage; Decimal)
        {
        }
        field(6; "Charge Type"; Option)
        {
            OptionCaption = 'General,Top up,External Loan,Deposit Financing,Share Capital,Share Financing,Deposit Financing on Maximum,External Payment to Vendor,Rescheduling';
            OptionMembers = General,"Top up","External Loan","Deposit Financing","Share Capital","Share Financing","Deposit Financing on Maximum","External Payment to Vendor",Rescheduling;
        }
        field(7; "Charging Option"; Option)
        {
            OptionMembers = ,"On Approved Amount","On Net Amount";
        }
        field(8; "Effect Excise Duty"; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(9; "Charge Method"; Option)
        {
            OptionCaption = 'Flat Amount,% of Amount,Staggered,Unique Formula';
            OptionMembers = "Flat Amount","% of Amount",Staggered,"Unique Formula";
        }
        field(10; "Staggered Charge Code"; Code[20])
        {
            TableRelation = "Tiered Charges Header";
        }
        field(11; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(12; "Additional Loan Charge"; Boolean)
        {
        }
        field(13; "Ledger Fee"; Boolean)
        {
        }
        field(14; Insurance; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Charge Code")
        {
        }
    }

    fieldgroups
    {
    }

}

