table 51532442 "Appraisal Monthly Contribution"
{

    fields
    {
        field(1;"Loan No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Member No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Product ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Product Description";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Expected Contribution";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Current Contribution";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Boosting Limit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Acceptable Contribution";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Deposit Ratio";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Deposit Mulitplier";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Shares Transfered";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Loan No.",Date)
        {
        }
    }

    fieldgroups
    {
    }
}

