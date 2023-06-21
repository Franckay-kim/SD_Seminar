table 51532233 "Defaulted Loan Guarantors"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(2; "Defaulter No."; Code[20])
        {
        }
        field(3; "Defaulter Name"; Text[50])
        {
        }
        field(4; "Guarantor Account"; Code[20])
        {
        }
        field(5; "Guarantor Member No."; Code[20])
        {
        }
        field(6; "Guarantor Name"; Text[50])
        {
        }
        field(7; "Approved Amount"; Decimal)
        {
        }
        field(8; "Loan Balance"; Decimal)
        {
        }
        field(9; "Amount Defaulted"; Decimal)
        {
        }
        field(10; LineNo; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Guarantor Account", LineNo)
        {
        }
    }

    fieldgroups
    {
    }
}

