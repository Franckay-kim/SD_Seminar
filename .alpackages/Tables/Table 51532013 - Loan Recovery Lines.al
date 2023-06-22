/// <summary>
/// Table Loan Recovery Lines (ID 51532013).
/// </summary>
table 51532013 "Loan Recovery Lines"
{

    fields
    {
        field(1; "Header No."; Code[50])
        {
        }
        field(2; "Guarantor Savings Account"; Code[20])
        {
            Editable = false;
        }
        field(3; "Guarantor Name"; Code[100])
        {
            Editable = false;
        }
        field(4; "Withdrawable Savings"; Decimal)
        {
            Editable = false;
        }
        field(5; "Non-Withdrable Savings"; Decimal)
        {
            Editable = false;
        }
        field(6; "Amount Guaranteed"; Decimal)
        {
            Editable = false;
        }
        field(7; "Loan Allocation"; Decimal)
        {
            Editable = false;
        }
        field(8; "Amount to Recover"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF "Amount to Recover" <> "Loan Allocation" THEN
                // ERROR('This Amount MUST be equal to the Loan Allocation');
            end;
        }
        field(9; "Amount Recovered"; Decimal)
        {
            Editable = false;
        }
        field(10; "Loan No."; Code[20])
        {
            TableRelation = Loans;
        }
        field(11; "Guarantor Member No."; Code[20])
        {
        }
        field(12; "Loan Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Guarantor Count"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Loan Type"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Loanee Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Guarantor Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Remaining Installments"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Recovery Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Savings,Loan;
        }
    }

    keys
    {
        key(Key1; "Header No.", "Loan No.", "Guarantor Savings Account")
        {
        }
    }

    fieldgroups
    {
    }
}

