/// <summary>
/// Table Delegate Members Applicationss (ID 51532350).
/// </summary>
table 51532350 "Delegate Members Applicationss"
{
    //DrillDownPageID = "Delegate Members Applications";
    //LookupPageID = "Delegate Members Applications";

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
            TableRelation = Members."No." where("Account Category" = filter(Delegates));

            trigger OnValidate()
            begin
                GeneralSetUp.Get();
                DelegateMemberss.Reset;
                DelegateMemberss.SetRange(DelegateMemberss."Delegate MNO.", "Delegate MNO.");
                DelegateMemberss.SetRange(Retired, false);
                if DelegateMemberss.Find('-') then begin
                    Error('This member is already a member of %1', DelegateMemberss.Code);
                end;
                Validate(Position);
                if Members.Get("Delegate MNO.") then begin
                    "Employer Code" := Members."Employer Code";
                    if Members.Status <> Members.Status::Active then Error('THis member is not active');
                    if (CalcDate(GeneralSetUp."Min.Delegate Membership Period", Members."Registration Date")) > Today then
                        Error(ErrMemb, GeneralSetUp."Min.Delegate Membership Period");
                    DelegateGroupsApplicationss.Reset;
                    DelegateGroupsApplicationss.SetRange(DelegateGroupsApplicationss.Code, Code);
                    if DelegateGroupsApplicationss.Find('-') then begin
                        // IF DelegateGroupsApplicationss."Global Dimension 2 Code"<>Members."Global Dimension 2 Code" THEN
                        //  ERROR('Member No.: %1 belong to Branch: %2 and therefore cannot represent  Branch: %3',Members."No.",Members."Global Dimension 2 Code",DelegateGroupsApplicationss."Global Dimension 2 Code");
                    end;
                    "Global Dimension 2 Code" := Members."Global Dimension 2 Code";
                    Validate("Global Dimension 2 Code");
                    "Delegate Name" := Members.Name;
                    "ID No." := Members."ID No.";
                    "Appointment Date" := Today;

                    Loans.Reset();
                    Loans.SetAutoCalcFields("Outstanding Balance", "Outstanding Interest");
                    Loans.SetFilter("Outstanding Balance", '>%1', 0);
                    Loans.SetRange("Member No.", "Delegate MNO.");
                    Loans.SetRange(Posted, true);
                    if loans.FindFirst() then begin
                        repeat
                            if Loans."Current Loans Category-SASRA" <> Loans."Current Loans Category-SASRA"::Perfoming
                            then
                                Error('Member has a non-performing loan %1', Loans."Loan No.");
                        until Loans.Next() = 0;
                    end;

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
        field(7; Address; Text[100])
        {
        }
        field(8; "Appointment Date"; Date)
        {
        }
        field(9; "Expiry Date"; Date)
        {
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Branch Code.';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                DimensionValue.Reset;
                DimensionValue.SetRange(Code, "Global Dimension 2 Code");
                if DimensionValue.Find('-') then begin
                    "Global Dimension 2 Name" := DimensionValue.Name;
                end;
            end;
        }
        field(11; "Global Dimension 2 Name"; Code[20])
        {
            Caption = 'Branch Name';
            Editable = false;
        }
        field(12; "ID No."; Code[20])
        {
        }
        field(13; "Employer Code"; code[20])
        {

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
        DelegateMembers: Record "Delegate Members Applicationss";
        ErrPosition: Label 'You cannot have the same position of %1 within the same group';
        GeneralSetUp: Record "General Set-Up";
        ErrMemb: Label 'This member has not met minimum membership period of %1';
        DelegateMemberss: Record "Delegate Memberss";
        DelegateGroupsApplicationss: Record "Delegate Groups Applicationss";
        DimensionValue: Record "Dimension Value";
        Loans: Record Loans;
}

