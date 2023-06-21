table 51532114 "Cheques Register"
{

    fields
    {
        field(1;"Cheque No.";Code[10])
        {
        }
        field(2;"Account No.";Code[20])
        {
        }
        field(3;Status;Option)
        {
            OptionCaption = 'Pending,Approved,Cancelled,stopped,Dishonoured';
            OptionMembers = Pending,Approved,Cancelled,stopped,Dishonoured;
        }
        field(4;"Approval Date";Date)
        {
        }
        field(5;"Application No.";Code[10])
        {
        }
        field(6;"Cancelled/Stopped By";Code[50])
        {
        }
    }

    keys
    {
        key(Key1;"Cheque No.","Account No.","Application No.")
        {
        }
    }

    fieldgroups
    {
    }
}

