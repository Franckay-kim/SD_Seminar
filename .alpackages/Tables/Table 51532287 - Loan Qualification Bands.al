/// <summary>
/// Table Loan Qualification Bands (ID 51532287).
/// </summary>
table 51532287 "Loan Qualification Bands"
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
            Caption = 'Lower Base Limit';
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
            Caption = 'Upper Base Limit';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Lower Limit");
            end;
        }
        field(5; "Loan No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Customer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Individual,Group;
        }
        field(7; Multiplier; Decimal)
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

