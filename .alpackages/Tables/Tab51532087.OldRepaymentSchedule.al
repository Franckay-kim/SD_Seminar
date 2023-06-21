table 51532087 "Old Repayment Schedule"
{
    Caption = 'Old Repayment Schedule';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(2; "Member No."; Code[20])
        {
        }
        field(3; "Loan Category"; Code[20])
        {
        }
        field(8; "Closed Date"; Date)
        {
        }
        field(9; "Loan Amount"; Decimal)
        {
        }
        field(14; "Interest Rate"; Decimal)
        {
        }
        field(15; "Monthly Repayment"; Decimal)
        {
        }
        field(17; "Member Name"; Text[30])
        {
        }
        field(21; "Monthly Interest"; Decimal)
        {
        }
        field(25; "Amount Repayed"; Decimal)
        {
            FieldClass = Normal;
        }
        field(26; "Repayment Date"; Date)
        {
        }
        field(27; "Principal Repayment"; Decimal)
        {
        }
        field(28; Paid; Boolean)
        {
        }
        field(29; "Remaining Debt"; Decimal)
        {
            Editable = false;
        }
        field(30; "Instalment No"; Integer)
        {
        }
        field(45; "Actual Loan Repayment Date"; Date)
        {
        }
        field(46; "Repayment Code"; Code[20])
        {
        }
        field(47; "Group Code"; Code[20])
        {
        }
        field(48; "Loan Application No"; Code[20])
        {
        }
        field(49; "Actual Principal Paid"; Decimal)
        {
        }
        field(50; "Actual Interest Paid"; Decimal)
        {
        }
        field(51; "Actual Installment Paid"; Decimal)
        {
        }
        field(52; "Repayment Adjustment"; Decimal)
        {
        }
        field(53; "Reset Schedule"; Boolean)
        {
        }
        field(54; "Reset Doc No."; Code[10])
        {
        }
        field(55; "Appraisal Fee"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Member No.", "Repayment Date")
        {
            SumIndexFields = "Monthly Interest", "Principal Repayment", "Monthly Repayment";
        }
        key(Key2; "Member No.")
        {
        }
        key(Key3; Paid)
        {
        }
        key(Key4; "Loan No.", "Member No.", Paid)
        {
        }
        key(Key5; "Loan Category")
        {
        }
        key(Key6; "Loan No.", "Member No.", Paid, "Loan Category")
        {
        }
    }

    fieldgroups
    {
    }

}
