table 51533462 "Loan Deposit Contribution"
{
    Caption = 'Loan Deposit Contribution';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Lower Limit"; Decimal)
        {
            Caption = 'Lower Limit';
            DataClassification = ToBeClassified;
        }
        field(2; "Upper Limit"; Decimal)
        {
            Caption = 'Upper Limit';
            DataClassification = ToBeClassified;
        }
        field(3; "Monthly Contribution"; Decimal)
        {
            Caption = 'Monthly Contribution';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Lower Limit")
        {
            Clustered = true;
        }
    }
}
