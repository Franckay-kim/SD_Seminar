table 51532183 "Daily Loans Interest Buffer"
{

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Loan No."; Code[50])
        {
            Editable = false;
            TableRelation = Loans;
        }
        field(3; "Interest Date"; Date)
        {
        }
        field(4; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(5; "Account No"; Code[20])
        {
            Editable = false;
        }
        field(6; "Loan Product type"; Code[10])
        {
            Editable = false;
            TableRelation = "Product Factory";
        }
        field(7; "Interest Amount"; Decimal)
        {
        }
        field(8; "User ID"; Code[20])
        {
        }
        field(10; Transferred; Boolean)
        {
        }
        field(11; Posted; Boolean)
        {
        }
        field(12; "Repayment Amount"; Decimal)
        {
        }
        field(13; "Monthly Repayment"; Decimal)
        {
        }
        field(14; "Interest Matured"; Boolean)
        {
        }
        field(15; "Late Interest"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Interest Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        NoSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

