/// <summary>
/// Table Product Factory (ID 51532016).
/// </summary>
table 51532016 "Product Factory"
{
    fields
    {
        field(1; "Product ID"; Code[20])
        {
        }
        field(2; "Product Description"; Text[100])
        {
        }
        field(3; "Product Class Type"; Option)
        {
            Description = 'Whether Loan Accounts or Operational accounts';
            OptionCaption = ' ,Loan,Savings';
            OptionMembers = " ",Loan,Savings;
        }
        field(4; "Interest Rate (Min.)"; Decimal)
        {
        }
        field(5; "Interest Rate (Max.)"; Decimal)
        {
        }
        field(6; "Installment Repayment Interval"; DateFormula)
        {
        }
        field(7; Status; Option)
        {
            OptionCaption = 'Open,Active,Blocked';
            OptionMembers = Open,Active,Blocked;

            trigger OnValidate()
            begin
                case Status of
                    Status::Active:
                        begin
                            case "Product Class Type" of
                                "Product Class Type"::Savings:
                                    begin
                                        TestField("Product ID");
                                        TestField("Product Description");
                                        //TESTFIELD("Interest Rate (Min.)");
                                        TestField("Account No. Prefix");
                                        TestField("Product Posting Group");
                                    end;
                                "Product Class Type"::Loan:
                                    begin
                                        TestField("Product ID");
                                        TestField("Product Description");
                                        TestField("Account No. Prefix");
                                        TestField("Loan  Account [G/L]");
                                        TestField("Product Posting Group");
                                        if "Interest Rate (Min.)" > 0 then begin
                                            TestField("Loan Interest Account [G/L]");
                                            TestField("Loan Receivable Account[G/L]");
                                        end;
                                        TestField("Bill Account Due");
                                        TestField("Product Posting Group");
                                    end;
                            end;
                        end;
                end;
            end;
        }
        field(8; Currency; Code[10])
        {
            TableRelation = Currency.Code;
        }
        field(9; "Fixed Loan Term"; Boolean)
        {
        }
        field(10; "Withdrawal Interval"; DateFormula)
        {
            Description = 'Daily,Weekly,Monthly,Quoterly,Yearly';
        }
        field(11; "Maximum No. of Withdrawal"; Integer)
        {
        }
        field(12; "Product Ownership"; Option)
        {
            OptionCaption = 'Individual,Joint,Group/Business,Corporate';
            OptionMembers = Individual,Joint,"Group/Business",Corporate;
        }
        field(13; "Min. Customer Age"; DateFormula)
        {
        }
        field(14; "Max.Customer Age"; DateFormula)
        {
        }
        field(15; "Credit Limit(Overdraft)"; Decimal)
        {
        }
        field(16; "Minimum Balance"; Decimal)
        {
            Description = 'Operational deposit and withdrawable accounts- formely FOSA';

            trigger OnValidate()
            begin
                if "Minimum Balance" < 0 then Error('Minimum balance cannot be less than zero');
            end;
        }
        field(17; "Automatic Overdraft"; Boolean)
        {
            Description = 'Current & Savings account';
        }
        field(18; "Customer Segment"; Code[30])
        {
            Description = 'Lookup to the Customer Segmentation';
        }
        field(19; "Minimum Contribution"; Decimal)
        {
            Description = 'FDR Account';
        }
        field(20; "Product Insured"; Boolean)
        {
        }
        field(21; "Account Minimum Balance[%]"; Decimal)
        {
        }
        field(22; "Loan  Account [G/L]"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(23; "Loan Interest Account [G/L]"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(24; "Loan Receivable Account[G/L]"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(25; "Use Cycle"; Boolean)
        {
        }
        field(26; "Grace Period - Interest"; DateFormula)
        {
        }
        field(27; "Product Posting Group"; Code[10])
        {
            Description = 'LookUp to Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(28; "Closure Fee"; Code[10])
        {
            Description = 'Savings products';
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Member Withdrawal"));
        }
        field(29; "Dormancy Period"; DateFormula)
        {
            Description = 'Account no transactions';
        }
        field(30; "Account No. Prefix"; Code[4])
        {
        }
        field(31; "Maximum Guarantors"; Integer)
        {
        }
        field(32; "Minimum Guarantors"; Integer)
        {
        }
        field(33; "Min. Re-application Period"; DateFormula)
        {
        }
        field(34; "Minimum Loan Amount"; Decimal)
        {
        }
        field(35; "Maximum Loan Amount"; Decimal)
        {
        }
        field(36; "Product Category"; Option)
        {
            Description = 'Option to help identify type of savings accounts';
            OptionCaption = ' ,Share Capital,Main Shares,Fixed Deposit,Junior Savings,Registration Fee,Benevolent,Unallocated Fund,Micro Credit Deposits,NHIF,Corp,School Fee,Dividend,Joint,Redeemable,KUSCCO,Housing,Creditor,Prime';
            OptionMembers = " ","Share Capital","Deposit Contribution","Fixed Deposit","Junior Savings","Registration Fee",Benevolent,"Unallocated Fund","Micro Credit Deposits",NHIF,Corp,"School Fee",Dividend,Joint,Redeemable,KUSCCO,Housing,Creditor,Prime;
        }
        field(37; "Interest Calculation Method"; Option)
        {
            OptionCaption = 'Amortised,Reducing Balance,Straight Line,Reducing Flat,Zero Interest,Custom';
            OptionMembers = Amortised,"Reducing Balance","Straight Line","Reducing Flat","Zero Interest",Custom;
        }
        field(38; "Prefferential Default installm"; Integer)
        {
        }
        field(39; "Ordinary Default Intallments"; Integer)
        {
        }
        field(40; "Can Guarantee Loan"; Boolean)
        {
        }
        field(41; "Loan Disbursement Account"; Boolean)
        {
        }
        field(42; "Charge Closure Before Maturity"; Decimal)
        {
        }
        field(43; "Earns Interest"; Boolean)
        {
        }
        field(44; "Interest Expense Account"; Code[15])
        {
            TableRelation = "G/L Account";
        }
        field(45; "Interest Payable Account"; Code[15])
        {
            TableRelation = "G/L Account";
        }
        field(46; "External EFT Charges"; Decimal)
        {
        }
        field(47; "Interest Calc Min Balance"; Decimal)
        {
        }
        field(48; "Penalty Calculation Days"; DateFormula)
        {
        }
        field(49; "Penalty Charge Code"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Loan Penalty"));
        }
        field(50; "Penalty Calculation Method"; Option)
        {
            OptionMembers = "No Penalty","Principal in Arrears","Principal in Arrears+Interest in Arrears","Principal in Arrears+Interest in Arrears+Penalty in Arrears","Interest In Arrears";
        }
        field(51; "Penalty Paid Account"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(52; "Ordinary Deposits Multiplier"; Decimal)
        {
        }
        field(53; "Preferential Dep. Multiplier"; Integer)
        {
        }
        field(54; "Allow Multiple Running Loans"; Boolean)
        {
        }
        field(55; "Loan Security Inclination"; Option)
        {
            OptionCaption = ' ,Short Loan Security,Long Term Loan Security';
            OptionMembers = " ","Short Term Loan Security","Long Term Loan Security";
        }
        field(56; "Loan Span"; Option)
        {
            OptionCaption = ' ,Short Term,Long Term';
            OptionMembers = " ","Short Term","Long Term";
        }
        field(57; "Recovery Priority"; Integer)
        {
            trigger OnValidate()
            begin
                SavingsAccounts.Reset;
                SavingsAccounts.SetRange(SavingsAccounts."Product Type", "Product ID");
                if SavingsAccounts.Find('-') then begin
                    repeat
                        SavingsAccounts."Recovery Priority" := "Recovery Priority";
                        SavingsAccounts.Modify;
                    until SavingsAccounts.Next = 0;
                end;
                Loans.Reset;
                Loans.SetRange(Loans."Loan Product Type", "Product ID");
                if Loans.Find('-') then begin
                    repeat
                        Loans."Recovery Priority" := "Recovery Priority";
                        Loans.Modify;
                    until Loans.Next = 0;
                end;
            end;
        }
        field(58; "Membership Type"; Option)
        {
            OptionCaption = ',Ordinary,Preferential';
            OptionMembers = ,Ordinary,Preferential;
        }
        field(59; "Repay Mode"; Option)
        {
            OptionCaption = ' ,Salary,Milk,Tea,Staff Salary,Business,Check Off,Cash,Dividend';
            OptionMembers = " ",Salary,Milk,Tea,"Staff Salary",Business,"Check Off",Cash,Dividend;
            ValuesAllowed = " ", "Staff Salary", "Check Off", Cash, Dividend;
        }
        field(60; "Interest Calculation Type"; Option)
        {
            OptionCaption = ' ,Full Interest,Pro-rata';
            OptionMembers = " ","Full Interest","Pro-rata";
        }
        field(61; "Withholding Tax Account"; Code[15])
        {
            TableRelation = "G/L Account";
        }
        field(62; "WithHolding Tax"; Decimal)
        {
        }
        field(63; "Bill Account Due"; Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(false));
        }
        field(64; "Bill Account Paid"; Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(true));
        }
        field(65; "Auto Open Account"; Boolean)
        {
        }
        field(66; "Dividend Calc. Method"; Option)
        {
            OptionCaption = ' ,Flat Rate,Prorated';
            OptionMembers = " ","Flat Rate",Prorated;
        }
        field(67; "Allow Over Draft"; Boolean)
        {
        }
        field(68; "Over Draft Interest %"; Decimal)
        {
        }
        field(69; "Over Draft Interest Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(70; "Allow Multiple Over Draft"; Boolean)
        {
        }
        field(71; "Search Code"; Code[20])
        {
        }
        field(72; "Allow Multiple Accounts"; Boolean)
        {
        }
        field(73; "Maximum Deposit Contribution"; Decimal)
        {
        }
        field(74; "Minimum Deposit Balance"; Decimal)
        {
        }
        field(75; "Type of Discounting"; Option)
        {
            OptionCaption = ' ,Loan Discounting,Invoice Discounting,Cheque Discounting,Dividend Discounting';
            OptionMembers = " ","Loan Discounting","Invoice Discounting","Cheque Discounting","Dividend Discounting";
        }
        field(76; "Suspend Interest Account [G/L]"; Code[15])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = FILTER(true));
        }
        field(77; "Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Monthly,Quarterly,Bi-Annual,Yearly,Bonus';
            OptionMembers = Daily,Weekly,Monthly,Quarterly,"Bi-Annual",Yearly,Bonus;
        }
        field(78; "Grace Period - Principle"; DateFormula)
        {
        }
        field(79; "Nature of Loan Type"; Option)
        {
            OptionCaption = ' ,Normal,Defaulter,Property Sale';
            OptionMembers = " ",Normal,Defaulter,"Property Sale";
        }
        field(80; "Account No. Suffix"; Code[4])
        {
        }
        field(81; "No. Of Months for Appr. Saving"; Integer)
        {
        }
        field(82; "Loan Appraisal Income Acc."; Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = FILTER(true));
        }
        field(83; "Minimum Deposit Contribution"; Decimal)
        {
        }
        field(84; "Savings Duration"; DateFormula)
        {
        }
        field(85; "Savings Withdrawal penalty"; Decimal)
        {
        }
        field(86; "Savings Penalty Account"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                //TestNoEntriesExist(FIELDCAPTION("Savings Penalty Account"),"Savings Penalty Account")
            end;
        }
        field(89; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";
        }
        field(90; "Allowed Transaction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Withdraw Only,Deposit Only,Withdraw & Deposit,No Transactions';
            OptionMembers = "Withdraw Only","Deposit Only","Withdraw & Deposit","No Transactions";
        }
        field(50001; "Penalty Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                case "Penalty Type" of
                    "Penalty Type"::"Percentage Of Amount":
                        if "Penalty Amount" > 100 then
                            Error(ErrPenaltyAmount);
                    "Penalty Type"::"Percentage Of Interest":
                        if "Penalty Amount" > 100 then
                            Error(ErrPenaltyAmount);
                end;
            end;
        }
        field(50002; "Penalty Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Percentage Of Amount","Percentage Of Interest","Flat Amount";
        }
        field(50005; "Statement E-Mail Freq."; DateFormula)
        {
        }
        field(50006; "Discounting %"; Decimal)
        {
        }
        field(50007; "Computation %"; Decimal)
        {
        }
        field(50008; "Statement Charge"; Code[10])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST(Statement));
        }
        field(50050; "TopUp Expected Interest P. (M)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50051; "Mobile Transaction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Deposits Only","Withdrawals Only","Deposits & Withdrawals";
        }
        field(50052; "Mobile Loan Net %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50053; "USSD Product Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50054; "Interest Recovered Upfront"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50055; "Add Charges to Loan Amount"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50057; "Email Loan Schedule"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50058; "Topup Validation Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            var
                ErrLoanBalance: Label 'Loan Balance Type is Percentage and cannot go beyond 100%';
            begin
                case "Topup Validation Type" of
                    "Topup Validation Type"::"Principal Amount Paid":
                        if ("Topup Validation Value" > 100) then
                            Error(ErrLoanBalance);
                end;
            end;
        }
        field(50059; "Topup Validation Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Principal Amount Paid","Principal & Interest Amount Paid","Paid Installments","Loan Period";

            trigger OnValidate()
            begin
                Clear("Topup Validation Value");
            end;
        }
        field(50060; "Own Shares Loan"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50061; "Exempt Penalty"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004241; Notice; DateFormula)
        {
        }
        field(39004242; "Allow Mobile Applications"; Boolean)
        {
        }
        field(39004243; "Allow Self Guarantee"; Boolean)
        {
        }
        field(39004244; "No. of Salary Times"; Integer)
        {
        }
        field(39004245; "Salary Period"; DateFormula)
        {
        }
        field(39004248; "Minimum Dep. Contribution %"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(39004249; "Source of Funds"; Option)
        {
            OptionMembers = "Internal Fund","External Fund";
        }
        field(39004250; "Source Of Funds No."; Code[20])
        {
            // TableRelation = Vendor."No." WHERE ("Vendor Type"=CONST("Source of Funds"));
        }
        field(39004251; "Max. Member Age"; DateFormula)
        {
        }
        field(39004252; "Net Salary Multiplier %"; Decimal)
        {
        }
        field(39004253; "Appraisal Parameter Type"; Option)
        {
            OptionCaption = ' ,Bonus,Credits,Junior,Milk,Tea,KGs,Salary,Staff Salary,CheckOff';
            OptionMembers = " ",Bonus,Credits,Junior,Milk,Tea,KGs,Salary,"Staff Salary",CheckOff;
        }
        field(39004254; "Minimum Guarantors on Max Amt"; Integer)
        {
        }
        field(39004255; "Max Amt on Guarantors"; Decimal)
        {
        }
        field(39004256; "View Online"; Boolean)
        {
        }
        field(39004257; "Requires Salary Processing"; Boolean)
        {
        }
        field(39004258; "Mobile Loan"; Boolean)
        {
        }
        field(39004259; "Does not Require Batching"; Boolean)
        {
        }
        field(39004260; "Minimum Deposit Tiered"; Boolean)
        {
        }
        field(39004261; "Minimum Deposit Tiered Code"; Code[20])
        {
            TableRelation = "Tiered Charges Header".Code;

            trigger OnValidate()
            begin
                if "Minimum Deposit Tiered" = false then Error('Code must not be specified')
            end;
        }
        field(39004262; Target; Decimal)
        {
        }
        field(39004263; "Accrual Fee Acc. (Income)"; Code[20])
        {
            Description = '//Debit account and credit this GL with monthly accrual';
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = FILTER(true), "Income/Balance" = CONST("Income Statement"));
        }
        field(39004264; "Accrue Monthly"; Boolean)
        {
            Description = '//Does it charge on monthly basis';
        }
        field(39004265; "Monthly Charges"; Decimal)
        {
            Description = '//Amount to be charged on account every month';
        }
        field(39004266; "Loan Group"; Option)
        {
            OptionCaption = ' ,BOSA,FOSA';
            OptionMembers = " ",BOSA,FOSA;
        }
        field(39004267; "Loan Classification"; Option)
        {
            OptionCaption = 'Normal-SASRA,Production-SASRA';
            OptionMembers = "Normal-SASRA","Production-SASRA";
        }
        field(39004268; "% Recovery from Bonus"; Decimal)
        {
            trigger OnValidate()
            begin
                if "% Recovery from Bonus" > 100 then Error('Maximum allowed is 100 %');
            end;
        }
        field(39004269; "Loan Category"; Code[10])
        {
            //TableRelation = "Credit Product Categories".Code;
        }
        field(39004270; Gurantorship; Option)
        {
            OptionCaption = 'Normal Guarantorship,Co-Guarantorship';
            OptionMembers = "Normal Guarantorship","Co-Guarantorship";
        }
        field(39004271; "Autorecovery From Account"; Boolean)
        {
            Description = '//Does it autorecover from account peiodically';
        }
        field(39004272; "Share Capital Loan"; Boolean)
        {
            Description = '//At the point of loan disbursement does it recover share capital';
        }
        field(39004273; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(39004274; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(39004275; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(39004276; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(39004277; "Ledger Fee Due"; Code[20])
        {
            Caption = 'Loan Registration Due';
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(false));
        }
        field(39004278; "Ledger Fee Paid"; Code[20])
        {
            Caption = 'Loan Registration Paid';
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(true));
        }
        field(39004279; "Ledger Fee"; Decimal)
        {
            Caption = 'Loan Registration Fee';
        }
        field(39004280; "Charge Upfront Ledger"; Boolean)
        {
        }
        field(39004281; "Percentage of Recovery %"; Decimal)
        {
        }
        field(39004282; "Bridging Loan Interest %"; Decimal)
        {
        }
        field(39004283; "Disbursement Product"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Loan Disbursement Account" = CONST(true));
        }
        field(39004285; "Member Class"; Code[20])
        {
            TableRelation = "Member Category";
        }
        field(39004286; "Appraisal No. of Credits"; Integer)
        {
        }
        field(39004287; "Income Type"; Option)
        {
            OptionCaption = ' ,Salary,Milk,Tea,Staff Salary,Business,Periodic,Bonus,Mini-Bonus';
            OptionMembers = " ",Salary,Milk,Tea,"Staff Salary",Business,Periodic,Bonus,"Mini-Bonus";
        }
        field(39004288; "Appraisal Rate on KGs"; Decimal)
        {
        }
        field(39004289; "Appraised on Expected Bonus"; Boolean)
        {
        }
        field(39004290; "Appraisal % on Amount"; Decimal)
        {
        }
        field(39004291; "Cutoff Day"; Integer)
        {
        }
        field(39004292; "Pre-Earned Income [G/L]"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(39004293; "Pre-Earned Receivable [G/L]"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(39004294; "Loan Appraisal Receivable Acc."; Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = FILTER(true));
        }
        field(39004295; "Penalty Receivable Account"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(39004296; "Loan No. Grouping"; Option)
        {
            OptionCaption = ' ,Class A,Class B,Class C,Advances';
            OptionMembers = " ","Class A","Class B","Class C",Advances;
        }
        field(39004297; "Can Offset Loan"; Boolean)
        {
        }
        field(39004298; "Interest Due on Disbursement"; Boolean)
        {
        }
        field(39004299; "Bill on Disursement"; Boolean)
        {
        }
        field(39004300; "Auto Open Micro Group"; Boolean)
        {
        }
        field(39004301; "Appraisal-Check Repayments"; Boolean)
        {
        }
        field(39004302; "Pre-Earned Interest"; Boolean)
        {
        }
        field(39004303; "BBF Transfer Allowed"; Boolean)
        {
        }
        field(39004304; "Bonus Appraisal Start Date"; Date)
        {
        }
        field(39004305; "Minute Nos. Mandatory"; Boolean)
        {
        }
        field(39004306; "Loan Clients"; Option)
        {
            OptionCaption = 'Members,Staff,Directors';
            OptionMembers = Members,Staff,Directors;
        }
        field(39004307; "Can Boost Share Capital"; Boolean)
        {
        }
        field(39004308; "Can Boost Entrance Fee"; Boolean)
        {
        }
        field(39004309; "Auto Open Single/Group"; Option)
        {
            OptionCaption = 'Single,Group,Business';
            OptionMembers = Single,Group,Business;
        }
        field(39004310; "CRB Product Code"; Code[1])
        {
        }
        field(39004311; "Below Available Bal. Charge"; Decimal)
        {
        }
        field(39004312; "Below Available Bal. GL"; Code[15])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(39004313; "Guarantorship Type"; Option)
        {
            OptionCaption = 'Amount,Count';
            OptionMembers = Amount,"Count";
        }
        field(39004314; "Auto Recover Defaulter"; Boolean)
        {
        }
        field(39004315; "Interest Foreitted Account"; Code[15])
        {
            TableRelation = "G/L Account";
        }
        field(39004316; "%Deposit Boost on Disbursement"; Decimal)
        {
        }
        field(39004317; "Send Defaulter Reminder SMS"; Boolean)
        {
        }
        field(39004318; "TopUp Comm. Condition"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Commission on All Loans","Commission on Same Product Only";
        }
        field(39004319; "Appraisal Savings Product"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Factory"."Product ID" WHERE("Loan Disbursement Account" = CONST(false), "Product Class Type" = CONST(Savings));
        }
        field(39004320; "Acceptable Dep. Boosting Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(39004321; "Salary Rule"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "1/3 of Basic Rule","1/2 of Net Rule","Staff Loan Net Amount","Staff Loan 1/3 of Net";
        }
        field(39004322; "Change to CheckOff on Default"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004323; "Checkoff Trans. Def. Period(M)"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Checkoff Trans. Def. Period(M)" > 0 then
                    TestField("Change to CheckOff on Default", true)
                else
                    TestField("Change to CheckOff on Default", false);
            end;
        }
        field(39004324; "Staff Max. Basic Multipier"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(39004325; "Staf Employment Period(M)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(39004326; "Exempt on Checkoff Report"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004327; "Last Interest Check"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004328; "Check Interest Daily"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004329; "Dont Show on Statement"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004330; "Independent Top up Comm."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004331; "Minimum Loan App. period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(39004332; "Partial Disb. GL"; Code[15])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(39004333; "Last SMS Alert Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004334; "Savings based"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004335; "No Guarantors"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004336; "Recommend on Deposit"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004337; "Appraise On Deposits"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004338; "Appraise On Salary"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004339; "Appraise On Collateral"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004340; "Notify Next Due Date"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(39004341; "CheckOff Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(39004342; "Can Close Account"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004343; "Restructure Fee %"; Decimal)
        {
        }
        field(39004344; "Is Top Up Product"; Boolean)
        {
        }
        field(39004345; "Deposits Class"; Option)
        {
            OptionMembers = "Withdrawable","Non-Withdrawable";
        }
    }
    keys
    {
        key(Key1; "Product ID")
        {
        }
        key(Key2; "Product Class Type")
        {
        }
        key(Key3; "Product Category")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Product ID", "Product Description")
        {
        }
    }
    trigger OnDelete()
    begin
        //IF (Status = Status::Active) OR  (Status = Status::Blocked) THEN
        // ERROR(StatusError);
        StatusChangePermissions.Reset;
        StatusChangePermissions.SetRange("User ID", UserId);
        StatusChangePermissions.SetRange("Update Product Factory", true);
        if not StatusChangePermissions.FindFirst then Error('You do not have the following Status Change Permission: "Update Product Factory". Contact the System Administrator for Assistance');
    end;

    trigger OnInsert()
    begin
        /*StatusChangePermissions.Reset;
            StatusChangePermissions.SetRange("User ID", UserId);
            StatusChangePermissions.SetRange("Update Product Factory", true);
            if not StatusChangePermissions.FindFirst then
                Error('You do not have the following Status Change Permission: "Update Product Factory". Contact the System Administrator for Assistance');*/
    end;

    trigger OnModify()
    begin
        //IF Status = Status::Active THEN
        // ERROR(StatusError);
        /*StatusChangePermissions.Reset;
            StatusChangePermissions.SetRange("User ID", UserId);
            StatusChangePermissions.SetRange("Update Product Factory", true);
            if not StatusChangePermissions.FindFirst then
                Error('You do not have the following Status Change Permission: "Update Product Factory". Contact the System Administrator for Assistance');*/
    end;

    var
        StatusError: Label 'You can not make adjustments to product whose status is not open.';
        SavingsAccounts: Record "Savings Accounts";
        Loans: Record Loans;
        StatusChangePermissions: Record "Status Change Permissions";
        ErrPenaltyAmount: Label 'The Maximum Penalty Amount for Penalty Type (Percentage) is 100%';

    /// <summary>
    /// GetReceivablesAccount.
    /// </summary>
    /// <param name="ProductCode">Code[20].</param>
    /// <param name="TransactionType">Option " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Loan Registration Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid","Partial Disbursement","Suspended Interest Due","Suspended Interest Paid".</param>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetReceivablesAccount(ProductCode: Code[20];
    TransactionType: Option " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Loan Registration Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid","Partial Disbursement","Suspended Interest Due","Suspended Interest Paid"): Code[20]
    var
        LoanProductCharges: Record "Loan Product Charges";
    begin
        Get(ProductCode);
        if (TransactionType = TransactionType::Loan) or (TransactionType = TransactionType::Repayment) then begin
            exit("Loan  Account [G/L]");
        end
        else
            if (TransactionType = TransactionType::"Interest Due") or (TransactionType = TransactionType::"Interest Paid") then begin
                exit("Loan Receivable Account[G/L]");
            end
            else
                if TransactionType = TransactionType::Bills then begin
                    exit("Bill Account Due");
                end
                else
                    if (TransactionType = TransactionType::"Loan Registration Fee") then begin
                        exit("Ledger Fee Due");
                    end
                    else
                        if (TransactionType = TransactionType::"Partial Disbursement") then begin
                            exit("Partial Disb. GL");
                        end
                        else
                            if (TransactionType = TransactionType::"Pre-Earned Interest") then begin
                                exit("Pre-Earned Receivable [G/L]");
                            end
                            else
                                if (TransactionType = TransactionType::"Appraisal Due") or (TransactionType = TransactionType::"Appraisal Paid") then begin
                                    exit("Loan Appraisal Receivable Acc.");
                                end
                                else
                                    if (TransactionType = TransactionType::"Penalty Due") or (TransactionType = TransactionType::"Penalty Paid") then begin
                                        exit("Penalty Receivable Account");
                                    end
                                    else
                                        if (TransactionType = TransactionType::"Suspended Interest Due") or (TransactionType = TransactionType::"Suspended Interest Paid") then begin
                                            exit("Suspend Interest Account [G/L]")
                                        end;
    end;

    /// <summary>
    /// ValidateTopup.
    /// </summary>
    /// <param name="TheLoan">Record Loans.</param>
    /// <param name="TopUpDate">Date.</param>
    procedure ValidateTopup(TheLoan: Record Loans;
    TopUpDate: Date)
    var
        ErrTopupPeriod: Label 'Loan %1 does not meet the Minimum TopUp Period Required after Date of Disbusement in order to effect a Topup';
        ErrTopupBalance: Label 'In order to Effect Topup, The Outstanding Balance for Loan %1 Must be less than %2';
        BalanceThreshold: Decimal;
        IssueDate: Date;
        ErrIssueDate: Label 'Kindly ensure Loan %1 has a Disbursement Date and Issue Date';
    begin
        /* with TheLoan do begin
             CalcFields("Outstanding Balance");
             if "Topup Validation Value" <> 0 then begin
                 case "Topup Validation Type" of
                     "Topup Validation Type"::"Principal & Interest Amount Paid":
                         BalanceThreshold := (("Approved Amount" + "Schedule Interest") * ((100 - "Topup Validation Value") / 100));
                     "Topup Validation Type"::"Paid Installments":
                         BalanceThreshold := ("Approved Amount" - (Repayment * "Topup Validation Value"));
                     "Topup Validation Type"::"Principal Amount Paid":
                         BalanceThreshold := ("Approved Amount" * ((100 - "Topup Validation Value") / 100));
                 end;
                 If "TopUp Validation Type" <> "TopUp Validation Type"::"Loan Period" then
                     if "Outstanding Balance" > BalanceThreshold then
                         Error(ErrTopupBalance, "Loan No.", BalanceThreshold)
                     else
                         if Today < CalcDate(StrSubstNo('%-1M', Format("Topup Validation Value")), "Disbursement Date") then Error(ErrTopupPeriod);
             end; */
    end;
}
