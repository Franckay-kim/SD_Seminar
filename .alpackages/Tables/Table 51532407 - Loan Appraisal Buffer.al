table 51532407 "Loan Appraisal Buffer"
{

    fields
    {
        field(1; "Loan No."; Code[30])
        {
            TableRelation = Loans;
        }
        field(2; "Member No."; Code[20])
        {
            Caption = 'Customer CID';
            TableRelation = Members;
        }
        field(3; "Loan Disbursement Account"; Code[20])
        {
            TableRelation = "Savings Accounts";
        }
        field(4; Name; Text[150])
        {
        }
        field(5; "Product Code"; Code[20])
        {
            TableRelation = "Product Factory";
        }
        field(6; "Requested Amount"; Decimal)
        {
        }
        field(7; "Approved Amount"; Decimal)
        {
        }
        field(8; "Class A Deposits"; Decimal)
        {
        }
        field(9; "Class B Deposits"; Decimal)
        {
        }
        field(10; "Total Deposits"; Decimal)
        {
        }
        field(11; "Existing Loans"; Decimal)
        {
        }
        field(12; Installments; Decimal)
        {
        }
        field(13; "Amount Guaranteed"; Decimal)
        {
        }
        field(14; "No. of Guarantors"; Decimal)
        {
        }
        field(15; "Salary Through Fosa"; Boolean)
        {
        }
        field(16; "Share Capital"; Decimal)
        {
        }
        field(17; "Branch Code"; Code[20])
        {
        }
        field(18; "Activity Code"; Code[20])
        {
        }
        field(19; "Previous Contribution"; Decimal)
        {
            Description = 'Deposits Analysis';
        }
        field(20; Deposits; Decimal)
        {
        }
        field(21; "Deposit Financing"; Decimal)
        {
        }
        field(22; "Deposit Multiplier"; Decimal)
        {
        }
        field(23; "Loan Outstanding"; Decimal)
        {
        }
        field(24; "Principle Top Up"; Decimal)
        {
        }
        field(25; "Maximum Credit"; Decimal)
        {
        }
        field(26; "Minimum Share Capital"; Decimal)
        {
            Description = 'Share Capital Analysis';
        }
        field(27; "Current Share Capital"; Decimal)
        {
        }
        field(28; "Deficit Share Capital"; Decimal)
        {
        }
        field(29; "Share Financing"; Decimal)
        {
        }
        field(30; "Average Income"; Decimal)
        {
            Description = 'Income Analysis';
        }
        field(31; Earnings; Decimal)
        {
        }
        field(32; Allowances; Decimal)
        {
        }
        field(33; Deductions; Decimal)
        {
        }
        field(34; "2/3 of Basic"; Decimal)
        {
        }
        field(35; "Net Salary"; Decimal)
        {
        }
        field(36; "External Effects"; Decimal)
        {
        }
        field(37; "Adjusted Net"; Decimal)
        {
        }
        field(38; "Current Loan Repayment"; Decimal)
        {
        }
        field(39; "Interest Top Up"; Decimal)
        {
            Description = 'Net Take Home Calculation';
        }
        field(40; "Top Up Commission"; Decimal)
        {
        }
        field(41; "External Commitment"; Decimal)
        {
        }
        field(42; "External Commitment Commission"; Decimal)
        {
        }
        field(43; "Total Charges"; Decimal)
        {
        }
        field(44; "Net Take Home"; Decimal)
        {
        }
        field(45; "Qualification As Per Deposits"; Decimal)
        {
        }
        field(46; "Qualification as Per Income"; Decimal)
        {
        }
        field(47; "Qualification as Per Guarantor"; Decimal)
        {
        }
        field(48; "Entrance Fee"; Decimal)
        {
        }
        field(49; Multiplier; Decimal)
        {
        }
        field(50; "Recommended Amount"; Decimal)
        {
        }
        field(51; "Expected Bonus"; Decimal)
        {
        }
        field(52; "Outstanding Tea Bills"; Decimal)
        {
        }
        field(53; "Rate on Expected Bonus"; Decimal)
        {
        }
        field(54; "Class C Deposits"; Decimal)
        {
        }
        field(55; "Total Financing"; Decimal)
        {
        }
        field(56; "Top Up Appraisal"; Decimal)
        {
        }
        field(57; "Top Up Penalty"; Decimal)
        {
        }
        field(58; "Excise Duty"; Decimal)
        {
        }
        field(59; "Exisiting Loan Repayment"; Decimal)
        {
        }
        field(60; "Available Deposits"; Decimal)
        {
        }
        field(61; "Committed Deposits"; Decimal)
        {
        }
        field(62; "New Total Repayment"; Decimal)
        {
        }
        field(63; "Qualified Maximum Repayment"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(64; "1/2 of Net"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(65; "New Sal Takehome After Loan"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(66; "1/3 of Basic"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(67; "Net Top Up"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(68; "Monthly Deductions"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(69; "Current Deposits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Total Refinanced"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(71; "ReInstated Deposits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(72; "Statutory Deductions"; Decimal)
        {

        }
        field(73; "Long Term Deductions"; Decimal)
        {

        }
        field(74; "Monthly Contribution"; Decimal)
        {

        }
        field(75; "Appraised By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Loan No.")
        {
        }
    }

    fieldgroups
    {
    }
}

