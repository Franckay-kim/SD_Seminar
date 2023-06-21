table 51532375 "POS Transactions"
{


    fields
    {
        field(1; TraceID; Code[20])
        {
            Editable = true;
        }
        field(2; "Unit ID"; Code[10])
        {
        }
        field(3; MerchantID; Code[20])
        {
        }
        field(4; TellerID; Code[10])
        {
            TableRelation = "POS Transactions";
        }
        field(5; "Transaction Type"; Code[30])
        {
        }
        field(6; "Posting S"; Code[20])
        {
        }
        field(7; "Posting Date"; DateTime)
        {
        }
        field(8; "Account No"; Code[30])
        {
        }
        field(9; Description; Text[50])
        {
        }
        field(10; Amount; Decimal)
        {
        }
        field(11; Posted; Boolean)
        {
            Editable = false;
        }
        field(12; "Trans Time"; Code[50])
        {
        }
        field(13; "Transaction Time"; DateTime)
        {
        }
        field(14; RetRefID; Integer)
        {
            AutoIncrement = true;
        }
        field(15; TransactionPoint; Text[50])
        {
        }
        field(16; DataElements; Text[50])
        {
        }
        field(17; IsReversal; Boolean)
        {
        }
        field(18; "Transaction Date"; DateTime)
        {
        }
        field(19; Part_Tran; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; TraceID, "Unit ID", "Transaction Type", "Posting S", TellerID, Part_Tran)
        {
        }
        key(Key2; IsReversal, Posted, "Account No")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }
}

