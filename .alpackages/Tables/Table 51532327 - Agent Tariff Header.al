table 51532327 "Agent Tariff Header"
{

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Transaction Type";Option)
        {
            OptionCaption = 'Deposit,Withdrawal';
            OptionMembers = Deposit,Withdrawal;
        }
        field(4;"Trans Type Agents";Option)
        {
            OptionCaption = ' ,LoanApplication,Withdrawal,Deposit,LoanRepayment,Transfer,ShareDeposit,BioRegistration,Balance,MiniStatement,Paybill, MemberActivation,MemberRegistration,Micro-Group';
            OptionMembers = " ",LoanApplication,Withdrawal,Deposit,LoanRepayment,Transfer,ShareDeposit,BioRegistration,Balance,MiniStatement,Paybill," MemberActivation",MemberRegistration,"Micro-Group";
        }
        field(5;"Charge Excise Duty";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

