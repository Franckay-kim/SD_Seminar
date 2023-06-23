/// <summary>
/// Table Committee Members (ID 51532269).
/// </summary>
table 51532269 "Committee Members"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Board Members" WHERE(Status = CONST(Active));

            trigger OnValidate()
            begin

                Name := '';

                if BoardMembers.Get("No.") then begin
                    Name := BoardMembers.Name;
                    "Member No." := BoardMembers."Member No.";
                end;
            end;
        }
        field(2; Name; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Position; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Member,Chairperson,"Ass. Chairperson",Secretary,Treasurer;
        }
        field(4; "Header Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "Header Code", "Member No.")
        {
        }
        key(Key2; "Member No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        BoardMembers: Record "Board Members";
}

