table 51532128 "Delegate Members"
{


    fields
    {
        field(1; "Code"; Code[50])
        {
            Description = 'Lookup to Delegate groups';
            Editable = false;
            //TableRelation = "Delegate Groups".Code;
        }
        field(2; "Delegate MNO."; Code[50])
        {
            Description = 'Lookup to Member table';
            TableRelation = Members."No.";

            trigger OnValidate()
            begin
                GeneralSetUp.Get();
                Validate(Position);
                if Members.Get("Delegate MNO.") then begin
                    if (CalcDate(GeneralSetUp."Min.Delegate Membership Period", Members."Registration Date")) > Today then
                        Error(ErrMemb, GeneralSetUp."Min.Delegate Membership Period");
                    "Delegate Name" := Members.Name;
                end;
            end;
        }
        field(3; "Delegate Name"; Text[100])
        {
            Editable = false;
        }
        field(4; Position; Code[50])
        {
            Description = 'Lookup 39004358 filter type tittle';
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Position));

            trigger OnValidate()
            begin
                DelegateMembers.Reset;
                DelegateMembers.SetRange(Code, Code);
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
            Caption = 'Job Title';
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
        }
        field(6; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = Open,Pending,Approved;
        }
    }

    keys
    {
        key(Key1; "Code", "Delegate MNO.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Members: Record Members;
        DelegateMembers: Record "Delegate Members";
        ErrPosition: Label 'You cannot have the same position of %1 within the same group';
        GeneralSetUp: Record "General Set-Up";
        ErrMemb: Label 'This member has not met minimum membership period of %1';
}

