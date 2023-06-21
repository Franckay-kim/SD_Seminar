table 51532034 "Dividend Setup"
{

    fields
    {
        field(1;"No.";Code[10])
        {
        }
        field(2;Status;Option)
        {
            OptionMembers = "On Hold",Ready;
        }
        field(4;"Loan Arrears Recovery";Boolean)
        {
        }
        field(5;"Defaulter Recovery";Boolean)
        {
        }
        field(6;"Minimum Shares Recovery";Boolean)
        {

            trigger OnValidate()
            begin
                if not "Minimum Shares Recovery" then
                  "Minimum Shares Account":='';
            end;
        }
        field(7;"Minimum Shares Account";Code[10])
        {
            TableRelation = "Product Factory" WHERE ("Product Class Type"=CONST(Savings));
        }
        field(8;"Min. Capitalized Method";Option)
        {
            OptionCaption = ' ,Amount,Status,Both';
            OptionMembers = " ",Amount,Status,Both;
        }
        field(9;"Status Filter";Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = New,Active,Frozen,Closed,Dormant,Deceased;
        }
        field(10;"Minimum Capitalized";Decimal)
        {
            Description = 'if Dividend is less than or equal to that amount then system to capitalize earned dividend.';
        }
        field(11;"Dividend Discounting";Boolean)
        {
        }
        field(12;"Dividend Instructions";Boolean)
        {
        }
        field(15;"Start Date";Date)
        {
        }
        field(16;"End Date";Date)
        {
        }
        field(17;"Transaction Type";Code[10])
        {
            TableRelation = "Transaction Types" WHERE (Type=CONST(Dividend));
        }
        field(18;"Dividend Period";Integer)
        {
        }
        field(19;"Rebate Capitalized %";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }
}

