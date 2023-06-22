/// <summary>
/// Table Dividend Instructions - Member (ID 51532038).
/// </summary>
table 51532038 "Dividend Instructions - Member"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Enabled = false;
        }
        field(2; "Member No."; Code[10])
        {
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            ValidateTableRelation = false;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Savings)) "Savings Accounts" WHERE("Member No." = FIELD("Member No."),
                                                                                                                                                            Blocked = FILTER(" "),
                                                                                                                                                            "Product Category" = FILTER(<> "Fixed Deposit"))
            ELSE
            IF ("Account Type" = CONST(Credit)) "Credit Accounts" WHERE("Member No." = FIELD("Member No."),
                                                                                                                                                                                                                            Blocked = FILTER(" "));

            trigger OnValidate()
            begin
                case "Account Type" of
                    "Account Type"::Savings:
                        begin
                            if SavingsAccounts.Get("Account No.") then
                                "Product Type" := SavingsAccounts."Product Type";
                        end;

                    "Account Type"::Credit:
                        begin
                            if CreditAccounts.Get("Account No.") then
                                "Product Type" := CreditAccounts."Product Type"
                        end;
                end;
            end;
        }
        field(5; "Loan No."; Code[10])
        {
            TableRelation = Loans WHERE("Member No." = FIELD("Member No."),
                                         "Loan Account" = FIELD("Account No."));
        }
        field(6; "Recovery Type"; Option)
        {
            OptionCaption = ' ,Based on Amount,Based on (%)';
            OptionMembers = " ","Based on Amount","Based on (%)";
        }
        field(7; Amount; Decimal)
        {
        }
        field(8; "Product Type"; Code[10])
        {
        }
        field(9; "Sent Online"; Boolean)
        {
        }
        field(10; Priority; Integer)
        {
        }
        field(11; "Recurrent Over Years"; Boolean)
        {
        }
        field(12; "Last Modified Date"; Date)
        {
        }
        field(13; "Bank Branch Code"; Code[50])
        {
            TableRelation = IF ("Account Type" = CONST("Bank Account")) "Bank Code Structure"."Branch Code" WHERE("Bank Code" = FIELD("Account No."));
        }
        field(14; "MPesa/Account No."; Code[80])
        {
        }
        field(15; "Account Name"; Code[80])
        {
        }
    }

    keys
    {
        key(Key1; "Member No.", "Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Modified Date" := Today;

        DividendInstructionsMember.Reset;
        DividendInstructionsMember.SetRange("Recovery Type", DividendInstructionsMember."Recovery Type"::"Based on (%)");
        DividendInstructionsMember.SetRange("Member No.", DividendInstructionsMember."Member No.");
        if DividendInstructionsMember.Find('-') then begin
            DividendInstructionsMember.CalcSums(Amount);
            if Amount > 100 then
                Error(Err001);
        end;
    end;

    var
        CreditAccounts: Record "Credit Accounts";
        SavingsAccounts: Record "Savings Accounts";
        DividendInstructionsMember: Record "Dividend Instructions - Member";
        Err001: Label 'Percentage cannot be more than 100';
}

