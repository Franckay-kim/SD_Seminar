table 51532207 "Imprest Details-User"
{

    fields
    {
        field(1;No;Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2;"Account No:";Code[10])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                if GLAcc.Get("Account No:") then
                 "Account Name":=GLAcc.Name;
                /*
                IF Pay.GET(No) THEN BEGIN
                 IF Pay."Account No."<>'' THEN
                  BEGIN
                      "Imprest Holder":=Pay."Account No."
                  END
                 ELSE
                  BEGIN
                      ERROR('Please Enter the Customer/Account Number');
                  END;
                END;
                */

            end;
        }
        field(3;"Account Name";Text[30])
        {
        }
        field(4;Amount;Decimal)
        {
        }
        field(5;"Due Date";Date)
        {
        }
        field(6;"Imprest Holder";Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(7;"Actual Spent";Decimal)
        {
        }
        field(41;"Apply to";Code[20])
        {
        }
        field(42;"Apply to ID";Code[20])
        {
        }
        field(44;"Surrender Date";Date)
        {
        }
        field(45;Surrendered;Boolean)
        {
        }
        field(46;"M.R. No";Code[20])
        {
        }
        field(47;"Date Issued";Date)
        {
        }
        field(48;"Type of Surrender";Option)
        {
            OptionMembers = " ",Cash,Receipt;
        }
        field(49;"Dept. Vch. No.";Code[20])
        {
        }
        field(50;"Cash Surrender Amt";Decimal)
        {
        }
        field(51;"Bank/Petty Cash";Code[20])
        {
            TableRelation = "Bank Account";
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record "G/L Account";
        Pay: Record "Payment Line";
}

