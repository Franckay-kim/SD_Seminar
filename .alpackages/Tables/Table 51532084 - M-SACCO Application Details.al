table 51532084 "M-SACCO Application Details"
{

    fields
    {
        field(1; "Application No"; Code[30])
        {
            NotBlank = true;
            TableRelation = "M-SACCO Applications";
        }
        field(2; "Account Type"; Option)
        {
            Caption = 'Account Type';
            NotBlank = true;
            OptionCaption = ',Member';
            OptionMembers = ,Member;
        }
        field(3; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            NotBlank = true;
            TableRelation = "Savings Accounts"."No." WHERE("Loan Disbursement Account" = CONST(true));

            trigger OnValidate()
            begin


                case "Account Type" of
                    /*"Account Type"::"":
                        begin
                            Cust.Get("Account No.");
                            Description := Cust.Name;
                        end;*/
                    "Account Type"::Member:
                        begin
                            Cust.Get("Account No.");
                            Description := Cust.Name;
                        end;
                end;
            end;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Application No", "Account Type", "Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cust: Record "Savings Accounts";
}

