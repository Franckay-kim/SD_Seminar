table 51532015 "General Set-Up"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(3; "Max. Member Age"; DateFormula)
        {
        }
        field(4; "Registration Fee"; Decimal)
        {
        }
        field(5; "Min. Member Age"; DateFormula)
        {
        }
        field(6; "Rejoining Fees Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Days for Checkoff"; DateFormula)
        {

        }
        field(8; "Guarantors Multiplier"; Decimal)
        {
        }
        field(9; "Excise Duty G/L"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(10; "Rejoining Fee"; Decimal)
        {
        }
        field(11; "Excise Duty (%)"; Decimal)
        {
        }
        field(12; "Max Loans To Guarantee"; Integer)
        {
        }
        field(13; "Bill Account"; Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(true));
        }
        field(14; "Funeral Expense Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(15; "Funeral Amount"; Decimal)
        {
        }
        field(16; "Unloged Claims Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(17; "Insurance Name"; Text[30])
        {
        }
        field(18; "Withdrawal Notice period"; DateFormula)
        {
        }
        field(19; Reference; Text[30])
        {
            Description = 'Use to define Client Code for Electronic Find transfer';
        }
        field(20; "Withdrawal Fee"; Code[10])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Member Withdrawal"));
        }
        field(21; "Boosting Maturity"; DateFormula)
        {
        }
        field(22; "Boosting Shares %"; Decimal)
        {
        }
        field(23; "Share Boost GL"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(24; "Charge Type"; Code[10])
        {
        }
        field(29; "Transaction Type [Statement]"; Code[20])
        {
            TableRelation = "Transaction Types" WHERE(Type = FILTER(Statement));
        }
        field(30; "External STO Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(31; "Withdrawal Fee Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(32; "Self Guarantee %"; Decimal)
        {
        }
        field(33; "Maximum Discounting %"; Decimal)
        {
        }
        field(34; "Special Charge on Loans GL"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(35; "BBF Claim %"; Decimal)
        {
        }
        field(37; "Enforce Picture & Signature"; Option)
        {
            Description = 'Enforce Picture & Signature';
            OptionCaption = ' ,Picture,Signature,Both';
            OptionMembers = " ",Picture,Signature,Both;
        }
        field(38; "Allowed Loan Categories"; Option)
        {
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = Perfoming,Watch,Substandard,Doubtful,Loss;
        }
        field(39; "Benevolent Sacco Claim Account"; Code[10])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(40; "Maximum Valuation Period"; DateFormula)
        {
        }
        field(41; "Maximum ATM Limit"; Decimal)
        {
        }
        field(42; "Dividend Payable Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(43; "Withholding Tax Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(44; "Min. Delegates deposit"; Decimal)
        {
        }
        field(45; "Min.Delegate Membership Period"; DateFormula)
        {
        }
        field(46; "Min. Delegates Share Capital"; Decimal)
        {
        }
        field(47; "ATM Card No Characters"; Integer)
        {
        }
        field(48; "Self Deposits(As Guarantor)"; Boolean)
        {
        }
        field(49; "Max. Member Age - Disabled"; DateFormula)
        {
        }
        field(50; "BDE Loan Comission"; Decimal)
        {
        }
        field(51; "BDE Loan Above Target"; Decimal)
        {
        }
        field(52; "BDE ATM Comission"; Decimal)
        {
        }
        field(53; "BDE New Member Comission"; Decimal)
        {
        }
        field(54; "BDE Salary Account Commision"; Decimal)
        {
        }
        field(55; "Block Account for Ext.  Loan"; Boolean)
        {
        }
        field(56; "Society No."; Code[20])
        {
        }
        field(57; "Minimum Share Capital"; Decimal)
        {
        }
        field(58; "BaseMember Nos. on MemberClass"; Boolean)
        {
        }
        field(59; "Default Activity"; Code[20])
        {
            Caption = 'Default Activity';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(60; "Default Branch"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Default Branch';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(61; "Loan Recovery Option"; Option)
        {
            OptionCaption = 'Use Income Type,User Loan Group';
            OptionMembers = "Use Income Type","User Loan Group";
        }
        field(62; "Cheque Clearance GL"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(63; "Bonus Income  Deposit%"; Decimal)
        {
        }
        field(64; "Tea Income Deposit %"; Decimal)
        {
        }
        field(65; "Tea Income Loan %"; Decimal)
        {
        }
        field(66; "BBF Principle Entitlement"; Decimal)
        {
        }
        field(67; "ID Character Limit"; Integer)
        {
        }
        field(68; "Bouncing Cheque Bank Acc"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(69; "NHIF Start Date"; Date)
        {
        }
        field(70; "NHIF GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(71; "Pass Book Charge GL"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(72; "Full Withdrawal Fee"; Code[10])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Member Withdrawal"));
        }
        field(73; "Premature Withdrawal Fee"; Code[10])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Member Withdrawal"));
        }
        field(74; "Micro Entrance Charge GL"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(75; "Income Control Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(76; "Stubborn Defaulter Period"; DateFormula)
        {
            Description = '//Period after Loan Completion to flag Defaulters';
        }
        field(77; "Last Loan Reminder Date"; Date)
        {
        }
        field(78; "Send Loan Billing SMS"; Boolean)
        {
        }
        field(79; "Send Loan Defaulter SMS"; Boolean)
        {
        }
        field(80; "Posting Date Limit"; DateFormula)
        {
        }
        field(81; "Overdraft Start Date"; Date)
        {
        }
        field(82; "Minimum Transactional Shares"; Decimal)
        {
        }
        field(83; "Prevent Double Posting"; Boolean)
        {
        }
        field(84; "Pause Msacco"; Boolean)
        {
        }
        field(85; "Benevolent Insurance Claim GL"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(86; "Share Cap. Contr. Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(87; "Split Deposit -> Shares Rcpt %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(88; "Maximum Loan Book Multiplier"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(89; "Loans Bank Disb. Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Total Batch Amount to Bank","Single Loan Amount to Bank";
        }
        field(90; "Closure Loan Offset Fee %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(91; "Closure Loan Offsete GL"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(92; "Creditor Transfer Period (M)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(93; "Membership Fees Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(94; "Loan Cash Payments Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(95; "Loan Top Up Commission Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Single,Combined;
        }
        field(96; "Combined Top-Up Commission"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Top Up"));
        }
        field(97; "Partial Loan Disb. Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Post Partial Amount to Loan","Post Full Amount to Loan";
        }
        field(98; "Agency Posting Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch";
        }
        field(99; "Agency Posting Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(100; "Sacco Commission Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(101; "Vendor Commission Account"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(102; "Agency Control Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(103; "Agency Expense Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(104; "UnAllocated Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account","Vendor","Customer";
        }
        field(105; "UnAllocated Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("UnAllocated Account Type" = const("G/L Account"))
             "G/L Account"."No." where("Direct Posting" = const(true))
            else
            IF ("UnAllocated Account Type" = const(Vendor))
            Vendor."No."
            else
            if ("UnAllocated Account Type" = const(Customer))
            Customer."No.";




        }
        field(106; "Allow PreMature Withdrawal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(107; "Closure Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Posting Group"."Code";
        }
        field(108; "BBF Expense Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = filter(true));
        }
        field(109; "Loan Provisioning Account"; Code[20])
        {

            TableRelation = "G/L Account" where("Direct Posting" = filter(true));
        }
        field(110; "Stop Interest (Months)"; Integer)
        {

        }
        field(111; "ATM GL Comm Acc"; code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = filter(true));
        }
        field(112; "ATM Settlement Acc"; code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = filter(true));
        }
        field(113; "ATM Bank Charge Code"; code[20])
        {

        }
        field(114; "ATM POS GL Comm Acc"; code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = filter(true));
        }
        field(115; "ATM POS Settlement Acc"; code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = filter(true));
        }
        field(116; "ATM POS Bank Charge Code"; code[20])
        {

        }
        field(117; "ATM VISA Bank Charge Code"; code[20])
        {

        }
        field(118; "ATM VISA Settlement Acc"; code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = filter(true));
        }
        field(119; "ATM VISA GL Comm Acc"; code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = filter(true));
        }
        field(120; "Min Signatory Group"; Decimal)
        {

        }
        field(121; "Min Signatory Joint"; Decimal)
        {

        }



    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

