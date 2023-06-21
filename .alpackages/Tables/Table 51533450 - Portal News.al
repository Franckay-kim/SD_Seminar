table 51533450 "Portal News"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
            MinValue = 1;
        }
        field(2; Title; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Desctription; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Date Added"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Added By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; Display; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Portal; Option)
        {
            OptionMembers = "Internet Banking",Employers;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Date Added" := Today;
        "Added By" := UserId;
        Display := true;
    end;
}

