table 51533403 "Tender Opening Log"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "User ID"; Code[50])
        {
        }
        field(3; "Purchase Quote No"; Code[20])
        {
        }
        field(4; "RFQ No"; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No." WHERE(Status = FILTER(Released));
        }
        field(5; "Tender Activity No"; Code[20])
        {
        }
        field(6; "Date Entered"; DateTime)
        {
        }
        field(7; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup("Purchase Header"."Pay-to Name" WHERE("No." = FIELD("Purchase Quote No")));
            FieldClass = FlowField;
        }
        field(8; "Email Sent"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

