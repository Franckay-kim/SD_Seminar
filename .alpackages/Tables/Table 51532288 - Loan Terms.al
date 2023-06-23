/// <summary>
/// Table Loan Terms (ID 51532288).
/// </summary>
table 51532288 "Loan Terms"
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
        field(3; "Lower Limit"; Decimal)
        {
            Caption = 'Lower Limit';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Lower Limit" > "Upper Limit" then begin
                    if "Upper Limit" > 0 then Error(ErrLimits);
                end;
            end;
        }
        field(4; "Upper Limit"; Decimal)
        {
            Caption = 'Upper Limit';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Lower Limit");
            end;
        }
        field(5; Installments; Decimal)
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

