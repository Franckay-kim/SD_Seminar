table 51532289 "Deposit Collateral Ratio"
{

    fields
    {
        field(1;"Line No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"Loan Product";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Factory";

            trigger OnValidate()
            var
                ErrLoanThreshold: Label 'The Loan Debt Threshold Type for Loan %1 Must Be Tiered in the Product Factory.';
            begin
            end;
        }
        field(3;"Deposit Ratio";Decimal)
        {
            Caption = 'Deposit Ratio';
            DataClassification = ToBeClassified;
        }
        field(4;"Collateral Ratio";Decimal)
        {
            Caption = 'Collateral Ratio';
            DataClassification = ToBeClassified;
        }
        field(5;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = New,Old,Land;
        }
    }

    keys
    {
        key(Key1;"Loan Product","Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ErrLimits: Label 'The Lower Limit cannot be more than the Upper Limit';
}

