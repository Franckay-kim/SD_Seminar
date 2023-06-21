table 51532334 "Agent Sent Sms"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            Editable = false;
            InitValue = 0;
        }
        field(2;"Agent Code";Code[20])
        {
            Editable = false;
        }
        field(3;"Document No";Code[20])
        {
            Editable = false;
        }
        field(4;"ID Number";Text[20])
        {
            Editable = false;
        }
        field(5;DateTime;DateTime)
        {
            Editable = false;
        }
        field(6;"Text Message";Text[250])
        {
            Editable = false;
        }
        field(7;"Source Transaction";Option)
        {
            Editable = false;
            OptionCaption = ' ,LoanApplication,Withdrawal,Deposit,LoanRepayment,Transfer,ShareDeposit,BioRegistration,Balance,MiniStatement,Paybill,MemberActivation,MemberRegistration,Micro-Group,Account-Opening';
            OptionMembers = " ",LoanApplication,Withdrawal,Deposit,LoanRepayment,Transfer,ShareDeposit,BioRegistration,Balance,MiniStatement,Paybill,MemberActivation,MemberRegistration,"Micro-Group","Account-Opening";
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

