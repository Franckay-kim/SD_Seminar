/// <summary>
/// Table Checkoff Lines (ID 51532146).
/// </summary>
table 51532146 "Checkoff Lines"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Checkoff Header"; Code[20])
        {
        }
        field(3; "Member No."; Code[20])
        {
        }
        field(4; "Account No."; Code[20])
        {
        }
        field(5; "Payroll No."; Code[20])
        {
        }
        field(6; Amount; Decimal)
        {
        }
        field(7; "Loan No."; Code[20])
        {

            trigger OnValidate()
            var
                ChLines: Record "Checkoff Lines";
                ChBuffer: Record "Checkoff Buffer";
            begin
                ChBuffer.Reset();
                ChBuffer.SetRange("Member No.", "Member No.");
                ChBuffer.SetRange("Checkoff No", "Checkoff Header");
                if ChBuffer.FindSet() then begin
                    ChBuffer.CalcSums(Amount);
                end;
                ChLines.Reset();
                ChLines.SetRange("Member No.", "Member No.");
                ChLines.SetRange("Checkoff Header", "Checkoff Header");
                if ChLines.Find('-') then
                    ChLines.CalcSums(Amount);

                if ChLines.Amount > ChBuffer.Amount then
                    Error('Checkoff Amount exceeds Buffer Amount');

            end;
        }
        field(8; Multiple; Boolean)
        {
        }
        field(9; "Credit Account"; Boolean)
        {
        }
        field(10; Name; Text[50])
        {
        }
        field(11; "Savings Account"; Boolean)
        {
        }
        field(12; "ID Number"; Code[11])
        {
        }
        field(13; Posted; Boolean)
        {
        }
        field(14; Type; Option)
        {
            OptionCaption = ' ,sInterest,sLoan,sShare,wCont';
            OptionMembers = " ",sInterest,sLoan,sShare,wCont;
        }
        field(15; "Product ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Factory";
        }
        field(16; "Excess Amount"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50000; "Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal Due,Loan Registration Fee,Appraisal Paid,Pre-Earned Interest,Penalty Due,Penalty Paid';
            OptionMembers = " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Loan Registration Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid";

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
        field(50001; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Product Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No", "Checkoff Header", "Account No.")
        {
        }
    }

    fieldgroups
    {
    }
}

