table 51532278 "Checkoff Control"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Loan Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Loan Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Loan No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(10; "Posting Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(11; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

