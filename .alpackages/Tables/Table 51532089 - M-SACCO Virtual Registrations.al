table 51532089 "M-SACCO Virtual Registrations"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Telephone No"; Text[30])
        {
        }
        field(3; "Id No"; Text[30])
        {
        }
        field(4; "Mpesa Names"; Text[100])
        {
        }
        field(5; "IPRS Names"; Text[100])
        {
        }
        field(6; "Date of Birth"; Date)
        {
        }
        field(7; Occupation; Text[50])
        {
        }
        field(8; Citizenship; Text[30])
        {
        }
        field(9; Gender; Text[30])
        {
        }
        field(10; "Place Birth"; Text[150])
        {
        }
        field(11; "Reg Office"; Text[150])
        {
        }
        field(12; Posted; Boolean)
        {
        }
        field(13; IDisValid; Boolean)
        {
        }
        field(14; "Postal Address"; Text[250])
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

