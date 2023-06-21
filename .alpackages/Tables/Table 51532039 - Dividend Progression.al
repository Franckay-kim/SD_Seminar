table 51532039 "Dividend Progression"
{
    //LookupPageID = 39004269;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Account No"; Code[20])
        {
            TableRelation = "Savings Accounts";
        }
        field(3; "Processing Date"; Date)
        {
        }
        field(4; "Dividend Calc. Method"; Option)
        {
            OptionCaption = ' ,Flat Rate,Prorated';
            OptionMembers = " ","Flat Rate",Prorated;
        }
        field(5; "Product Type"; Code[10])
        {
        }
        field(6; "Product Name"; Text[30])
        {
        }
        field(7; "Member No"; Code[20])
        {
            TableRelation = Members;
        }
        field(8; "Qualifying Shares"; Decimal)
        {
        }
        field(9; Shares; Decimal)
        {
        }
        field(10; "Gross Dividends"; Decimal)
        {
        }
        field(11; "Witholding Tax"; Decimal)
        {
        }
        field(12; "Net Dividends"; Decimal)
        {
        }
        field(13; "Start Date"; Date)
        {
        }
        field(14; "End Date"; Date)
        {
        }
        field(15; "Payment Mode"; Code[20])
        {
        }
        field(16; "Dividend Account"; Code[20])
        {
            CalcFormula = Lookup(Members."Dividend Account" WHERE("No." = FIELD("Member No")));
            FieldClass = FlowField;
        }
        field(17; "Staff No."; Code[20])
        {
            CalcFormula = Lookup(Members."Payroll/Staff No." WHERE("No." = FIELD("Member No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Account No", "Product Type", "Entry No.", "Start Date")
        {
        }
        key(Key2; "Member No")
        {
        }
    }

    fieldgroups
    {
    }
}

