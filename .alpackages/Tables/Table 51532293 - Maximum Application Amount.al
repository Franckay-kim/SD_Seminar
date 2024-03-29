/// <summary>
/// Table Maximum Application Amount (ID 51532293).
/// </summary>
table 51532293 "Maximum Application Amount"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Loan Product"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Factory";


            trigger OnValidate()
            var
                ErrLoanThreshold: Label 'The Loan Debt Threshold Type for Loan %1 Must Be Tiered in the Product Factory.';
            begin
            end;
        }
        field(3; "Individual Qulification"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Group Qualification"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Loan Product", "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ErrLimits: Label 'The Lower Limit cannot be more than the Upper Limit';
}

