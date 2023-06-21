table 51532138 "Teller Translines"
{

    fields
    {
        field(1; "Teller Translines No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(3; "Transaction Date"; Date)
        {
        }
        field(4; "Entry No"; Integer)
        {
        }
        field(5; Posted; Boolean)
        {
        }
        field(6; Name; Text[200])
        {
        }
        field(7; Description; Text[60])
        {
        }
        field(8; User; Code[20])
        {
        }
        field(9; "Batch No."; Code[30])
        {
        }
        field(10; "Account No"; Code[20])
        {
            TableRelation = "Savings Accounts"."No.";

            trigger OnValidate()
            begin
                Acc.Reset;
                Acc.SetRange(Acc."No.", "Account No");
                if Acc.Find('-') then begin
                    Name := Acc.Name;
                    Description := 'Cash Deposit';
                end;
            end;
        }
        field(11; "ID No."; Code[20])
        {
        }
        field(12; "Teller Transheader No"; Code[20])
        {
            TableRelation = "Teller Transheader";
        }
        field(13; "Account Name"; Code[30])
        {
        }
        field(14; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Teller Translines No", "Teller Transheader No")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {

    }

    var
        Acc: Record Vendor;
    // loans: Record EDMS;
}

