table 51532333 "Agent Error Messages"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            InitValue = 0;
        }
        field(2;"Agent Code";Code[20])
        {
        }
        field(3;"Document No";Code[20])
        {
        }
        field(4;"Transaction Description";Text[50])
        {
        }
        field(5;DateTime;DateTime)
        {
        }
        field(6;"Error Message";Text[250])
        {
        }
        field(7;Source;Option)
        {
            OptionCaption = 'API,Loan Appraisal';
            OptionMembers = API,"Loan Appraisal";
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

