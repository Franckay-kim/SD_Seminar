/// <summary>
/// Table Delegates Meeting Attendees (ID 51532346).
/// </summary>
table 51532346 "Delegates Meeting Attendees"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Delegate No."; Code[10])
        {
            TableRelation = "Delegate Memberss"."Delegate MNO." WHERE(Retired = CONST(false));

            trigger OnValidate()
            var
                Memb: Record Members;
            begin
                DelegateMemberss.Reset;
                DelegateMemberss.SetRange("Delegate MNO.", "Delegate No.");
                if DelegateMemberss.Find('-') then begin
                    "Delegate Name" := DelegateMemberss."Delegate Name";
                    "Delegate Position" := DelegateMemberss.Position;

                    if Memb.Get("Delegate No.") then
                        "Delegate Email" := Memb."E-Mail";
                    "Delegate Phone" := Memb."Mobile Phone No";

                end;
            end;
        }
        field(3; "Delegate Name"; Text[100])
        {
        }
        field(4; "Delegate Email"; Text[100])
        {
        }
        field(5; "Delegate Phone"; Text[100])
        {
        }
        field(6; "Delegate Position"; Text[100])
        {
        }
        field(7; "Delegate Group"; Code[50])
        {
            TableRelation = "Delegate Groupss".Code;
        }
        field(8; "Badge No."; Code[30])
        {

        }
        field(9; "Attendance Confirmed"; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; "Code", "Delegate No.", "Delegate Group")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Options; "Delegate No.", "Delegate Name", "Delegate Position")
        {
        }
    }

    var
        DelegateMemberss: Record "Delegate Memberss";
}

