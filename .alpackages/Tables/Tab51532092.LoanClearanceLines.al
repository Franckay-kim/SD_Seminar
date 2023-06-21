table 51532092 "Loan Clearance Lines"
{
    Caption = 'Loan Clearance Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Clearance Header No."; Code[20])
        {
            Caption = 'Clearance Header No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Loan No."; Code[30])
        {
            Caption = 'Loan No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Amount Guaranteed"; Decimal)
        {
            Caption = 'Amount Guaranteed';
            DataClassification = ToBeClassified;
        }
        field(5; "Amount Committed"; Decimal)
        {
            Caption = 'Amount Committed';
            DataClassification = ToBeClassified;
        }
        field(6; "Amount to Recover"; Decimal)
        {
            Caption = 'Loan Allocation';
            DataClassification = ToBeClassified;
        }
        field(7; Recovered; Boolean)
        {
            Caption = 'Recovered';
            DataClassification = ToBeClassified;
        }
        field(8; "Recovery Type"; Option)
        {
            Caption = 'Recovery Type';
            OptionMembers = "Savings","Guarantor Loan";
            DataClassification = ToBeClassified;
        }
        field(9; "Guarantor Member No."; Code[20])
        {

        }
        field(10; Posted; Boolean)
        {

        }
    }
    keys
    {
        key(PK; "Clearance Header No.", "Account No.")
        {
            Clustered = true;
        }
    }
}
