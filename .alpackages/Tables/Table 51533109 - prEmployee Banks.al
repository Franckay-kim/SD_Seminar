table 51533109 "prEmployee Banks"
{


    fields
    {
        field(1; "Employee Code"; Code[10])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(2; "Bank Code"; Code[10])
        {
            TableRelation = "PR Bank Branches"."Branch Code";
        }
        field(3; "Branch Code"; Code[10])
        {
            TableRelation = "PR Bank Branches"."Branch Name" WHERE("Branch Code" = FIELD("Bank Code"));
        }
        field(4; Default; Boolean)
        {
            InitValue = true;
        }
        field(5; "Account No"; Text[50])
        {
        }
        field(6; Percentage; Decimal)
        {
            Description = 'Refers to %of Net to be transfered to this A/C';
            InitValue = 100;
        }
        field(7; Amount; Decimal)
        {
            Description = 'Refers to Amount to be transfered to this A/C';
            InitValue = 0;
        }
        field(8; Currency; Code[10])
        {
            TableRelation = Currency.Code;
        }
        field(9; AmountLCY; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Bank Code", "Branch Code")
        {
        }
        key(Key2; "Employee Code", Amount)
        {
        }
    }

    fieldgroups
    {
    }
}

