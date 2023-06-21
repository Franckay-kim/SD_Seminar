table 51533256 "ATMTrans Completed"
{

    fields
    {
        field(1;ID;Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2;serviceName;Text[30])
        {
            Editable = false;
            NotBlank = true;
        }
        field(3;messageID;Text[100])
        {
            Editable = false;
            NotBlank = true;
        }
        field(4;OPTransactionDate;DateTime)
        {
            Editable = false;
        }
        field(5;OPTerminalID;Text[100])
        {
            Editable = false;
        }
        field(6;OPChannel;Text[30])
        {
            Editable = false;
        }
        field(7;OPTransactionType;Text[20])
        {
            Editable = false;
        }
        field(8;OPOriginalMessageID;Text[100])
        {
            Editable = false;
        }
        field(9;PostingDebitAccount;Text[50])
        {
            Editable = false;
        }
        field(10;PostingTotalAmount;Decimal)
        {
            Editable = false;
        }
        field(11;PostingCurrency;Text[10])
        {
            Editable = false;
        }
        field(12;PostingCreditAccount;Text[30])
        {
            Editable = false;
        }
        field(13;PostingChargeAmount;Decimal)
        {
            Editable = false;
        }
        field(14;PostingChargeCurrency;Text[10])
        {
            Editable = false;
        }
        field(15;PostingFeeAmount;Decimal)
        {
            Editable = false;
        }
        field(16;PostingFeeCurrency;Text[10])
        {
            Editable = false;
        }
        field(17;PostingNarrative1;Text[250])
        {
            Editable = false;
        }
        field(18;PostingNarrative2;Text[250])
        {
            Editable = false;
        }
        field(19;InstitutionInstitutionCode;Text[30])
        {
        }
        field(20;InstitutionIntitutionName;Text[100])
        {
        }
        field(21;PostedStatus;Option)
        {
            OptionCaption = 'Pending,Successful,Failed,Suspended';
            OptionMembers = Pending,Successful,Failed,Suspended;
        }
        field(22;PostingComments;Text[250])
        {
        }
        field(23;AccountDebitAccount;Text[30])
        {
        }
        field(24;AccountCreditAccount;Text[30])
        {
        }
        field(25;PostingNarrative;Text[250])
        {
        }
        field(26;SavingsAccountNumber;Text[30])
        {
        }
        field(27;"Field Location";Text[50])
        {
        }
        field(28;RecSource;Option)
        {
            OptionCaption = 'ATM,POS,VISA,BRANCH';
            OptionMembers = ATM,POS,VISA,BRANCH;
        }
        field(29;"Posting Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;ID)
        {
        }
    }

    fieldgroups
    {
    }
}

