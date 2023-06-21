table 51532352 "Delegate Memberss"
{
    //DrillDownPageID = "Delegate Memberss";
    //LookupPageID = "Delegate Memberss";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Description = 'Lookup to Delegate groups';
            Editable = false;
            TableRelation = "Delegate Groupss".Code;
        }
        field(2; "Delegate MNO."; Code[50])
        {
            Description = 'Lookup to Member table';
            TableRelation = Members."No." where("Account Category" = filter(Delegates));

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
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
        }
        field(6; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = Open,Pending,Approved;
        }
        field(7; Retired; Boolean)
        {
            Editable = false;
        }
        field(8; "Retire Date"; Date)
        {
            Editable = false;
        }
        field(10; "Service Period"; Text[30])
        {
            Editable = false;
        }
        field(11; "Retired By"; Code[50])
        {
            Editable = false;
        }
        field(12; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(19; "Reason for retirement"; Option)
        {
            OptionCaption = ',Death,Transfer,Resignation,Election,Impeachment';
            OptionMembers = ,Death,Transfer,Resignation,Election,Impeachment;
        }
        field(20; "Electoral Zone"; Code[50])
        {
            Description = 'lookup Electrol Zones/Area Svr Center (52018626) (Type=FILTER(Electral Zone))';
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = FILTER("Electral Zone"));
        }
        field(21; "Electoral Zone Name"; Text[100])
        {
            Editable = false;
        }
        field(22; "Appointment Date"; Date)
        {
        }
        field(23; "Expiry Date"; Date)
        {
        }
        field(24; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Global Dimension 1 Name"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code Name';
            Editable = false;
        }
        field(26; "ID No."; Code[20])
        {
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
        fieldgroup(Groups; "Delegate MNO.", "Delegate Name", Position)
        {
        }
    }

    var
        Members: Record Members;
        DelegateMembers: Record "Delegate Members Applicationss";
        ErrPosition: Label 'You cannot have the same position of %1 within the same group';
        GeneralSetUp: Record "General Set-Up";
        ErrMemb: Label 'This member has not met minimum membership period of %1';
}

