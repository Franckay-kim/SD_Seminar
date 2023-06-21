table 51532060 "Loan Product Charges"
{

    fields
    {
        field(1; "Charge Code"; Code[20])
        {
            TableRelation = "Loan Charges"."Charge Code";

            trigger OnValidate()
            begin
                if LoanChg.Get("Charge Code") then begin
                    "Charge Description" := LoanChg."Charge Description";
                    "Charge Amount" := LoanChg."Charge Amount";
                    "Charge Method" := LoanChg."Charge Method";
                    "Charge Type" := LoanChg."Charge Type";
                    Percentage := LoanChg.Percentage;
                    "Charging Option" := LoanChg."Charging Option";
                    "Effect Excise Duty" := LoanChg."Effect Excise Duty";
                    "Charges G_L Account" := LoanChg."G/L Account";
                end;
            end;
        }
        field(2; "Charge Description"; Text[70])
        {
        }
        field(3; "Charge Amount"; Decimal)
        {
        }
        field(4; "Use Percentage"; Boolean)
        {
            Enabled = false;
        }
        field(5; Percentage; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(6; "Charge Type"; Option)
        {
            OptionCaption = 'General,Top up,External Loan,Deposit Financing,Share Capital,Share Financing,Deposit Financing on Maximum,External Payment to Vendor,Rescheduling,CRB';
            OptionMembers = General,"Top up","External Loan","Deposit Financing","Share Capital","Share Financing","Deposit Financing on Maximum","External Payment to Vendor",Rescheduling,CRB;
        }
        field(7; "Charging Option"; Option)
        {
            OptionMembers = ,"On Approved Amount","On Net Amount","Base on Installments";
        }
        field(8; "Product Code"; Code[20])
        {
        }
        field(9; "Charges G_L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(10; Minimum; Decimal)
        {
        }
        field(11; Maximum; Decimal)
        {
        }
        field(12; "Additional Charge %"; Decimal)
        {
        }
        field(13; "Effect Excise Duty"; Option)
        {
            Editable = false;
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(14; Prorate; Option)
        {
            OptionCaption = ' ,Appraisal,Insurance,Pre-Earned Interest';
            OptionMembers = " ",Appraisal,Insurance,"Pre-Earned Interest";
        }
        field(15; "Charge Method"; Option)
        {
            OptionCaption = 'Flat Amount,% of Amount,Staggered,Unique Formula';
            OptionMembers = "Flat Amount","% of Amount",Staggered,"Unique Formula";
        }
        field(16; "Staggered Charge Code"; Code[20])
        {
            TableRelation = "Tiered Charges Header";
        }
        field(17; "Charge On"; Option)
        {
            OptionMembers = "On Disbursement","During Monthly Billing";
        }
        field(18; "Cutoff Amount"; Decimal)
        {

        }
        field(19; "Inclusive of Excise Duty"; Boolean)
        {

        }

    }

    keys
    {
        key(Key1; "Charge Code", "Product Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LoanChg: Record "Loan Charges";
}

