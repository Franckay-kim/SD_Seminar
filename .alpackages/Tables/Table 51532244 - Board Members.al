/// <summary>
/// Table Board Members (ID 51532244).
/// </summary>
table 51532244 "Board Members"
{

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Member,"Non-Member";
        }
        field(3; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = FILTER(Member)) Members where("Account Category" = filter("Board Members" | Delegates));

            trigger OnValidate()
            begin

                "ID No." := '';
                Name := '';

                if Members.Get("Member No.") then begin
                    Name := Members.Name;
                    "ID No." := Members."ID No.";
                end;
            end;
        }
        field(4; Name; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Active,"Non-Active";

            trigger OnValidate()
            begin
                "Status Change Date" := Today;
                "Status Changed By" := UserId;
            end;
        }
        field(6; "Status Change Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Status Changed By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "ID No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Savings Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Savings Accounts" WHERE("Member No." = FIELD("Member No."));
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

    var
        Members: Record Members;
}

