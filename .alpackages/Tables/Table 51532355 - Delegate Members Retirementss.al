/// <summary>
/// Table Delegate Members Retirementss (ID 51532355).
/// </summary>
table 51532355 "Delegate Members Retirementss"
{


    fields
    {
        field(1; "Code"; Code[50])
        {
            Description = 'Lookup to Delegate groups';
            Editable = false;
        }
        field(2; "Delegate MNO."; Code[50])
        {
            Description = 'Lookup to Member table';
            TableRelation = Members."No.";

            trigger OnValidate()
            begin
                DelegateMemberss.Reset;
                DelegateMemberss.SetRange(DelegateMemberss."Delegate MNO.", "Delegate MNO.");
                DelegateMemberss.SetRange(Retired, false);
                if DelegateMemberss.Find('-') then begin
                    Error('This member is already a member of %1', DelegateMemberss.Code);
                end;
                Validate(Position);
                if Members.Get("Delegate MNO.") then begin
                    "Delegate Name" := Members.Name;
                end;
            end;
        }
        field(3; "Delegate Name"; Text[100])
        {
        }
        field(4; Position; Code[50])
        {
            Description = 'Lookup 39004358 filter type tittle';
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Position));

            trigger OnValidate()
            begin
                DelegateMembers.Reset;
                DelegateMembers.SetRange(Code, Code);
                DelegateMembers.SetRange(Retired, false);
                DelegateMembers.SetRange(Position, Position);
                if DelegateMembers.Find('-') then begin
                    if Position <> '' then
                        Error(ErrPosition, Position);
                end;
            end;
        }
        field(5; "Job Tittle"; Code[50])
        {
            Description = '39004358';
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
        }
        field(6; Retired; Boolean)
        {
        }
        field(7; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = Open,Pending,Approved;
        }
        field(8; "Service Period"; Text[30])
        {
        }
        field(9; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Code", "Delegate MNO.", "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Members: Record Members;
        DelegateMembers: Record "Delegate Members Retirementss";
        ErrPosition: Label 'You cannot have the same position of %1 within the same group';
        DelegateMemberss: Record "Delegate Memberss";
}

