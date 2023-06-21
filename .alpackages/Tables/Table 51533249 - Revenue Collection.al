table 51533249 "Revenue Collection"
{

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Type;Option)
        {
            OptionCaption = ' ,M-Sacco,Instant Loan,Agency';
            OptionMembers = " ","M-Sacco","Instant Loan",Agency;
        }
        field(3;"Account Type";Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit,Member';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit,Member;
        }
        field(4;"Account No";Code[20])
        {
            TableRelation = IF ("Account Type"=CONST("G/L Account")) "G/L Account" WHERE ("Account Type"=CONST(Posting),
                                                                                          Blocked=CONST(false))
                                                                                          ELSE IF ("Account Type"=CONST(Customer)) Customer
                                                                                          ELSE IF ("Account Type"=CONST(Vendor)) Vendor
                                                                                          ELSE IF ("Account Type"=CONST("Bank Account")) "Bank Account"
                                                                                          ELSE IF ("Account Type"=CONST("Fixed Asset")) "Fixed Asset"
                                                                                          ELSE IF ("Account Type"=CONST("IC Partner")) "IC Partner"
                                                                                          ELSE IF ("Account Type"=CONST(Savings)) "Savings Accounts"
                                                                                          ELSE IF ("Account Type"=CONST(Credit)) "Credit Accounts";
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

