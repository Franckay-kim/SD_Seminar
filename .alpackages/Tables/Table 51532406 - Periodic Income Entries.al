table 51532406 "Periodic Income Entries"
{

    fields
    {
        field(1; "Loan No."; Code[30])
        {
        }
        field(2; "Entry No."; Integer)
        {
        }
        field(3; "Member No."; Code[20])
        {
            Caption = 'Customer CID';

            trigger OnValidate()
            begin
                Cust.Get("Member No.");
                Name := Cust.Name;
            end;
        }
        field(4; Name; Text[100])
        {
        }
        field(5; Date; Date)
        {
        }
        field(6; Description; Text[50])
        {
        }
        field(7; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cust: Record Members;
}

