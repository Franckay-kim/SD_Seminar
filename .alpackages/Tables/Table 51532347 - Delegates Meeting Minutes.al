table 51532347 "Delegates Meeting Minutes"
{

    fields
    {
        field(1; "Meeting No."; Code[10])
        {
        }
        field(2; Category; Text[30])
        {
        }
        field(3; Subject; Text[30])
        {
        }
        field(4; Details; Text[250])
        {
        }
        field(5; Feedback; Text[250])
        {
        }
        field(6; "Feedback By"; Code[50])
        {
        }
        field(7; "Feedback Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Meeting No.", Category, Subject)
        {
        }
    }


}

