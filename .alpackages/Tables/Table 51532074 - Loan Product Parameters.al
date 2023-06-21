table 51532074 "Loan Product Parameters"
{

    fields
    {
        field(1; "Loan Product Code"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
        }
        field(2; "Parameter Code"; Code[20])
        {
            // TableRelation = "DCS Parameter".Code;
        }
        field(3; "Parameter Desc"; Text[100])
        {
        }
        field(4; Factor; Decimal)
        {
        }
        field(5; "Computation Method"; Option)
        {
            OptionCaption = 'Formula,Flat Rate,Range,Ceiling,Multiplier,Divisor,Frequency,Sum,Difference,Graduated Range,Exponential,Terminate';
            OptionMembers = Formula,"Flat Rate",Range,Ceiling,Multiplier,Divisor,Frequency,"Sum",Difference,"Graduated Range",Exponential,Terminate;
        }
        field(6; "Parameter Base"; Option)
        {
            OptionCaption = ',Basic Pay,Earnings,Deductions,Net Pay,Deposits,Loan Balance - Long Term,Loan Balance - Short Term,Curr. Repayment - Short Term,Curr. Repayment - Long Term,Guarantors Amt,Collateral Amt,Net Income';
            OptionMembers = ,"Basic Pay",Earnings,Deductions,"Net Pay",Deposits,"Loan Balance - Long Term","Loan Balance - Short Term","Curr. Repayment - Short Term","Curr. Repayment - Long Term","Guarantors Amt","Collateral Amt","Net Income";
        }
        field(7; "Application Priority"; Integer)
        {
        }
        field(8; Formula; Text[30])
        {
        }
        field(9; "Parameter Base Unit"; Option)
        {
            OptionCaption = 'Value,Transaction date';
            OptionMembers = Value,"Transaction date";
        }
        field(10; "Success Default Value"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan Product Code", "Parameter Base")
        {
        }
    }

    fieldgroups
    {
    }
}

