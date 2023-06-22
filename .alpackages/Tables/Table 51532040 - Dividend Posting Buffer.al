/// <summary>
/// Table Dividend Posting Buffer (ID 51532040).
/// </summary>
table 51532040 "Dividend Posting Buffer"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Account Type" = CONST(Credit)) "Credit Accounts";
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "Member No."; Code[50])
        {
            Caption = 'Customer CID';
        }
        field(8; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(9; "Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(10; "Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(11; "Transaction Type"; Option)
        {
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal Due,Ledger Fee,Appraisal Paid,Pre-Earned Interest,Penalty Due,Penalty Paid';
            OptionMembers = " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Ledger Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid";

            trigger OnValidate()
            begin
                /*IF "Transaction Type"="Transaction Type"::"Registration Fee" THEN
                  Description:='Registration Fee';
                IF "Transaction Type"="Transaction Type"::Loan THEN
                  Description:='Loan';
                IF "Transaction Type"="Transaction Type"::Repayment THEN
                  Description:='Loan Repayment';
                IF "Transaction Type"="Transaction Type"::Withdrawal THEN
                  Description:='Withdrawal';
                IF "Transaction Type"="Transaction Type"::"Interest Due" THEN
                  Description:='Interest Due';
                IF "Transaction Type"="Transaction Type"::"Interest Paid" THEN
                  Description:='Interest Paid';
                IF "Transaction Type"="Transaction Type"::"Benevolent Fund" THEN
                  Description:='ABF Fund';
                IF "Transaction Type"="Transaction Type"::"Deposit Contribution" THEN
                  Description:='Shares Contribution';
                IF "Transaction Type"="Transaction Type"::"Appraisal Fee" THEN
                  Description:='Appraisal Fee';
                IF "Transaction Type"="Transaction Type"::"Application` Fee" THEN
                  Description:='Application Fee';
                IF "Transaction Type"="Transaction Type"::"Unallocated Funds" THEN
                  Description:='Unallocated Funds';
                         */


                //GenSet.GET;
                /*
                IF "Account Type"="Account Type"::Member THEN BEGIN
                CustMember.RESET;
                CustMember.SETRANGE(CustMember."No.","Account No.");
                IF CustMember.FIND('-') THEN BEGIN
                IF "Transaction Type"="Transaction Type"::Bills THEN
                "Bal. Account No.":=GenSet."Bill Account"
                ELSE
                "Bal. Account No.":='';
                END;
                END;
                
                
                
                PartOfAcc:='';
                
                PartOfAcc:=COPYSTR("Account No.",1,3);
                
                IF ((PartOfAcc='S01') OR (PartOfAcc='S02') OR (PartOfAcc='S06') OR (PartOfAcc='S09')  ) AND ("Transaction Type"<>"Transaction Type"::"Deposit Contribution") THEN
                ERROR('The chosen transaction type should be deposit contribution');
                
                IF ((PartOfAcc='S03') OR (PartOfAcc='S04')) AND ("Transaction Type"<>"Transaction Type"::"Share Capital") THEN
                ERROR('The chosen transaction type should be share Capital');
                
                IF ((PartOfAcc='L01') OR (PartOfAcc='L04') OR (PartOfAcc='L05')) AND ("Transaction Type"<>"Transaction Type"::" ") THEN
                ERROR('The transaction type should be blank');
                */

            end;
        }
        field(12; "Loan No"; Code[20])
        {
            TableRelation = Loans."Loan No." WHERE("Loan Account" = FIELD("Account No."));

            trigger OnValidate()
            begin
                //PKK

                /*IF Loans.GET("Loan No") THEN BEGIN
                  Loans.CALCFIELDS(Loans."Outstanding Balance");
                  IF Loans."Outstanding Balance"+Amount<=0 THEN BEGIN
                     Loans."Last Advice Date":=TODAY;
                     Loans."Advice Type":=Loans."Advice Type"::Stoppage;
                     Loans.MODIFY;
                   END;
                 END;
                 */
                /*
                Loans.RESET;
                Loans.SETRANGE(Loans."Loan  No.","Loan No");
                IF Loans.FIND('-') THEN BEGIN
                IF LType.GET(Loans."Loan Product Type") THEN BEGIN
                //"Shortcut Dimension 1 Code":=LType."Source of Financing";
                //VALIDATE("Shortcut Dimension 1 Code");
                END;
                
                Loans.CALCFIELDS(Loans."Outstanding Balance");
                InterestRate:=Loans.Interest;
                RepayPeriod:=Loans.Installments;
                LBalance:=Loans."Outstanding Balance";
                LoanAmount:=Loans."Approved Amount";
                
                
                IF "Transaction Type" = "Transaction Type"::"Application Fee" THEN BEGIN
                PCharges.RESET;
                PCharges.SETRANGE(PCharges."Product Code",Loans."Loan Product Type");
                PCharges.SETRANGE(PCharges.Code,'APP');
                IF PCharges.FIND('-') THEN BEGIN
                IF PCharges."Use Perc" = TRUE THEN
                Amount:=-1*(Loans."Approved Amount"*(PCharges.Percentage/100))
                ELSE
                Amount:=-1*PCharges.Amount;
                END;
                
                VALIDATE(Amount);
                
                EXIT;
                END;
                
                
                IF "Transaction Type" = "Transaction Type"::"Appraisal Fee" THEN BEGIN
                PCharges.RESET;
                PCharges.SETRANGE(PCharges."Product Code",Loans."Loan Product Type");
                PCharges.SETRANGE(PCharges.Code,'APPR');
                IF PCharges.FIND('-') THEN BEGIN
                IF PCharges."Use Perc" = TRUE THEN
                Amount:=-1*(Loans."Approved Amount"*(PCharges.Percentage/100))
                ELSE
                Amount:=-1*PCharges.Amount;
                END;
                
                VALIDATE(Amount);
                
                EXIT;
                END;
                
                
                
                
                
                IF Loans."Repayment Method"=Loans."Repayment Method"::Amortised THEN BEGIN
                Loans.TESTFIELD(Loans.Interest);
                Loans.TESTFIELD(Loans.Installments);
                
                TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.05,'>');
                LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
                LPrincipal:=TotalMRepay-LInterest;
                END;
                
                IF Loans."Repayment Method"=Loans."Repayment Method"::"Straight Line" THEN BEGIN
                Loans.TESTFIELD(Interest);
                Loans.TESTFIELD(Installments);
                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                LInterest:=ROUND((InterestRate/12/100)*LoanAmount,0.05,'>');
                //Grace Period
                LInterest:=ROUND((LInterest*(Loans.Installments+Loans."Grace Period - Principle (M)"))
                                /((Loans.Installments+Loans."Grace Period - Principle (M)")-Loans."Grace Period - Interest (M)"),0.05,'>');
                
                END;
                
                IF Loans."Repayment Method"=Loans."Repayment Method"::"Reducing Balance" THEN BEGIN
                Loans.TESTFIELD(Interest);
                Loans.TESTFIELD(Installments);
                LPrincipal:=ROUND(LoanAmount/RepayPeriod,0.05,'>');
                LInterest:=ROUND((InterestRate/12/100)*LBalance,0.05,'>');
                END;
                
                IF Loans."Repayment Method"=Loans."Repayment Method"::Constants THEN BEGIN
                Loans.TESTFIELD(Repayment);
                IF LBalance < Loans.Repayment THEN
                LPrincipal:=LBalance
                ELSE
                LPrincipal:=Loans.Repayment;
                LInterest:=Interest;
                END;
                
                
                END;
                
                IF "Transaction Type" = "Transaction Type"::Repayment THEN
                Amount:=-1*LPrincipal
                ELSE IF "Transaction Type" = "Transaction Type"::"Interest Paid" THEN
                Amount:=-1*LInterest;
                
                VALIDATE(Amount);
                */


                //PKK

            end;
        }
        field(13; "Product Type Name"; Code[20])
        {
        }
        field(14; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(15; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(16; "External Document No."; Code[20])
        {
        }
        field(17; "Product Type"; Code[50])
        {
        }
        field(18; "Bal. Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        }
        field(19; "Bal. Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Bal. Account Type" = CONST(Credit)) "Credit Accounts";
        }
        field(20; Blocked; Option)
        {
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ",Credit,Debit,All;
        }
        field(21; Posted; Boolean)
        {
        }
        field(22; "Loan Product"; Code[20])
        {
            CalcFormula = Lookup(Loans."Loan Product Type" WHERE("Loan No." = FIELD("Loan No")));
            FieldClass = FlowField;
        }
        field(23; Transaction; Option)
        {
            OptionCaption = ' ,Gross,Tax,Processing Fee,Duty on Processing Fee,Loan,SMS';
            OptionMembers = " ",Gross,Tax,"Processing Fee","Duty on Processing Fee",Loan,SMS;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

