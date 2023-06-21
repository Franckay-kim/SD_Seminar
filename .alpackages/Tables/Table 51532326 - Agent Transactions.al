table 51532326 "Agent Transactions"
{

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Transaction Date";Date)
        {
        }
        field(3;"Account No.";Code[50])
        {
        }
        field(4;Description;Text[220])
        {
        }
        field(5;Amount;Decimal)
        {
        }
        field(6;Posted;Boolean)
        {
        }
        field(7;"Transaction Type";Option)
        {
            OptionCaption = ' ,LoanApplication,Withdrawal,Deposit,LoanRepayment,Transfer,ShareDeposit,BioRegistration,Balance,MiniStatement,Paybill,MemberActivation,MemberRegistration,Micro-Group,Account-Opening,Loan-Statement';
            OptionMembers = " ",LoanApplication,Withdrawal,Deposit,LoanRepayment,Transfer,ShareDeposit,BioRegistration,Balance,MiniStatement,Paybill,MemberActivation,MemberRegistration,"Micro-Group","Account-Opening","Loan-Statement";
        }
        field(8;"Transaction Time";DateTime)
        {
        }
        field(9;"Bal. Account No.";Code[30])
        {
        }
        field(10;"Document Date";Date)
        {
        }
        field(11;"Date Posted";Date)
        {
        }
        field(12;"Time Posted";Time)
        {
        }
        field(13;"Account Status";Text[30])
        {
        }
        field(14;Messages;Text[200])
        {
        }
        field(15;"Needs Change";Boolean)
        {
        }
        field(16;"Change Transaction No";Code[20])
        {
        }
        field(17;"Old Account No";Code[50])
        {
        }
        field(18;Changed;Boolean)
        {
        }
        field(19;"Date Changed";Date)
        {
        }
        field(20;"Time Changed";Time)
        {
        }
        field(21;"Changed By";Code[10])
        {
        }
        field(22;"Approved By";Code[10])
        {
        }
        field(23;"Original Account No";Code[50])
        {
        }
        field(24;"Account Balance";Decimal)
        {
        }
        field(25;"Branch Code";Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(26;"Activity Code";Code[30])
        {
        }
        field(27;"Global Dimension 1 Filter";Code[20])
        {
        }
        field(28;"Global Dimension 2 Filter";Code[20])
        {
        }
        field(29;"Account No 2";Code[50])
        {
        }
        field(30;OTTN;Text[30])
        {
        }
        field(31;"Transaction Location";Text[30])
        {
        }
        field(32;"Transaction By";Text[30])
        {
        }
        field(33;"Agent Code";Text[30])
        {
        }
        field(34;"Loan No";Code[30])
        {
        }
        field(35;"Account Name";Text[100])
        {
        }
        field(36;Telephone;Text[30])
        {
        }
        field(37;"Id No";Text[30])
        {
        }
        field(38;Society;Code[10])
        {
        }
        field(39;"Member No";Code[10])
        {
        }
        field(40;"Approval Status";Option)
        {
            OptionCaption = 'Open,Pending,Appoved,Rejected';
            OptionMembers = Open,Pending,Appoved,Rejected;
        }
        field(41;DeviceID;Text[30])
        {
        }
        field(42;Latitude;Decimal)
        {
        }
        field(43;Longitude;Decimal)
        {
        }
        field(44;Gender;Option)
        {
            OptionCaption = '  ,Male,Female';
            OptionMembers = "  ",Male,Female;
        }
        field(45;"Date Of Birth";Date)
        {
        }
        field(46;Salutation;Text[10])
        {
        }
        field(47;"Marital Status";Option)
        {
            OptionCaption = ' ,Single,Married,Divorced,Widower,Widow';
            OptionMembers = " ",Single,Married,Divorced,Widower,Widow;
        }
        field(48;Locality;Text[100])
        {
        }
        field(49;"Nearest Market";Text[100])
        {
        }
        field(50;"Product Type";Code[20])
        {
        }
        field(51;"Group Code";Code[20])
        {
        }
        field(52;"Junior Acc Date Of Birth";Date)
        {
        }
        field(53;"Junior Acc Name";Text[100])
        {
        }
        field(54;"Destination Account No";Code[20])
        {
        }
        field(55;"E-Mail";Text[100])
        {
        }
        field(56;"Payroll Number";Code[50])
        {
        }
        field(57;"Employer Code";Code[20])
        {
        }
        field(58;"Field 1";Code[50])
        {
        }
        field(59;"Field 2";Code[50])
        {
        }
        field(60;"Field 3";Code[50])
        {
        }
        field(61;"Field 4";Code[50])
        {
        }
        field(62;"Field 5";Code[50])
        {
        }
    }

    keys
    {
        key(Key1;"Document No.",Description)
        {
        }
        key(Key2;"Transaction Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('You cannot delete Agent transactions.');
    end;

    trigger OnInsert()
    begin
        //"Transaction Date":=TODAY;
        Posted:=false;
        //"Transaction Time":=CREATEDATETIME(TODAY,TIME);
        "Document Date":=Today;
    end;

    trigger OnModify()
    begin

        if Posted=true then begin
        Error('You cannot modify posted Agent transactions.');
        end;
    end;
}

