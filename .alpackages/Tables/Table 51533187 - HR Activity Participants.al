/// <summary>
/// Table HR Activity Participants (ID 51533187).
/// </summary>
table 51533187 "HR Activity Participants"
{
    Caption = 'HR Activity Participants';

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Participant; Code[20])
        {
            TableRelation = "HR Employees"."No." WHERE(Status = CONST(Active));

            trigger OnValidate()
            begin
                //IF Participant='' THEN BEGIN
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", Participant);
                if HREmp.Find('-') then begin
                    //"Participant Name":=HREmp."First Name"+ ' ' + HREmp."Middle Name"+ ' ' + HREmp."Last Name";
                    "Participant Name" := HREmp."Full Name";
                    "Participant E-Mail" := HREmp."Company E-Mail";

                end;
                //END;
                Validate("Participant Name");
                /*
                IF Participant<>'' THEN BEGIN
                HREmp.RESET;
                HREmp.SETRANGE(HREmp."No.", Participant);
                IF HREmp.FIND('-') THEN
                  BEGIN
                    "Participant Name":=HREmp."First Name"+ ' ' + HREmp."Middle Name"+ ' ' + HREmp."Last Name";
                    "Participant E-Mail":=HREmp."Company E-Mail";
                    MODIFY;
                END;
                END;
                */

            end;
        }
        field(4; "Participant Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Participant E-Mail"; Text[50])
        {
            Editable = false;
        }
        field(6; Notified; Boolean)
        {
            Editable = false;
        }
        field(7; "Participant Role"; Text[50])
        {
        }
        field(8; Contribution; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", Participant)
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRCompanyActivities: Record "HR Company Activities";
        HREmp: Record "HR Employees";
}

