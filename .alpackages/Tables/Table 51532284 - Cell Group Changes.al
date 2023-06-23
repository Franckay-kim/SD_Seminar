/// <summary>
/// Table Cell Group Changes (ID 51532284).
/// </summary>
table 51532284 "Cell Group Changes"
{


    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if xRec."No." <> xRec."No." then begin
                    CreditNosSeries.Get;
                    NoSeriesMgt.TestManual(CreditNosSeries."Cell Group Changes");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Loan Account No."; Code[20])
        {
            TableRelation = "Credit Accounts";
        }
        field(3; Name; Text[50])
        {
            Editable = false;
        }
        field(4; "Account Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter,Apportioned,Suspended,Awaiting Verdict';
            OptionMembers = Active,"Non-Active",Blocked,Dormant,"Re-instated",Deceased,Withdrawal,Retired,Termination,Resigned,"Ex-Company",Casuals,"Family Member",Defaulter,Apportioned,Suspended,"Awaiting Verdict";
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(6; "Current Savings"; Decimal)
        {
            Editable = false;
            Enabled = false;
        }
        field(7; "FOSA Account"; Code[20])
        {
            Editable = false;
            Enabled = false;
        }
        field(8; "Business Loan No."; Code[20])
        {
            Editable = false;
            Enabled = false;
        }
        field(9; "Business Loan Shares"; Decimal)
        {
            Editable = false;
        }
        field(10; "Posted By"; Code[30])
        {
            Editable = false;
        }
        field(11; "Captured By"; Code[30])
        {
            Editable = false;
        }
        field(12; "Responsibility Centre"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility CenterBR";
        }
        field(13; "Activity Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14; "Branch Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Document No."; Code[20])
        {
            Enabled = false;
        }
        field(16; Date; Date)
        {
            Editable = false;
        }
        field(17; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18; "ID/Passport"; Code[10])
        {
            Enabled = false;
        }
        field(19; "Cell No"; Code[20])
        {
            TableRelation = Members."No." WHERE("Customer Type" = FILTER(Cell));

            trigger OnValidate()
            begin
                Members.Reset;
                Members.SetRange("No.", "Cell No");
                if Members.FindFirst then begin
                    Name := Members.Name;
                    "Meeting Days" := Members."Meeting Days";
                    "Meeting Time" := Members."Meeting Time";
                    "Meeting Venue" := Members."Meeting Venue";
                    Validate("No.");
                    GenerateCellMembers();
                end;
            end;
        }
        field(20; Posted; Boolean)
        {
            Editable = false;
        }
        field(21; "Class A"; Decimal)
        {
            Enabled = false;
        }
        field(22; "Class B"; Decimal)
        {
            Enabled = false;
        }
        field(23; "Class C"; Decimal)
        {
            Enabled = false;
        }
        field(24; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(25; "Meeting Days"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Meeting Time"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Meeting Venue"; Text[30])
        {
            DataClassification = ToBeClassified;
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

        if "No." = '' then begin
            CreditNosSeries.Get;
            CreditNosSeries.TestField(CreditNosSeries."Cell Group Changes");
            NoSeriesMgt.InitSeries(CreditNosSeries."Cell Group Changes", xRec."No. Series", 0D, "No.", "No. Series");
            Message("No.");
        end;
        "Captured By" := UserId;
        Date := Today;
        UserSetup.Get(UserId);
        //BEGIN
        //UserSetup.TestField("Global Dimension 1 Code");
        //UserSetup.TestField("Global Dimension 2 Code");
        //UserSetup.TestField("Responsibility Centre");


        //"Activity Code" := UserSetup."Global Dimension 1 Code";
        //"Branch Code" := UserSetup."Global Dimension 2 Code";
        //"Responsibility Centre" := UserSetup."Responsibility Centre";
    end;

    var
        CreditNosSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CellMembers: Record "Cell Group Members";
        Txt001: Label 'This loan does not have a balance';
        UserSetup: Record "User Setup";
        Members: Record Members;
        DocMustbeApproved: Label 'Document must be approved before posting';
        Error1: Label 'This document is already posted';

    /// <summary>
    /// GenerateCellMembers.
    /// </summary>
    procedure GenerateCellMembers()
    var
        CellChangesLines: Record "Cell Group Changes Lines";
        EntryNo: Integer;
        Err0001: Label 'There are no cell members found for cell %1 ';
    begin

        CellChangesLines.Reset;
        CellChangesLines.SetRange("Header No", "No.");
        if CellChangesLines.FindFirst then
            CellChangesLines.DeleteAll;

        CellMembers.Reset;
        CellMembers.SetRange(CellMembers."Account No", "Cell No");
        CellMembers.SetRange(CellMembers.Substituted, false);
        if CellMembers.FindFirst then begin
            if "No." = '' then begin
                CreditNosSeries.Get;
                CreditNosSeries.TestField(CreditNosSeries."Cell Group Changes");
                NoSeriesMgt.InitSeries(CreditNosSeries."Cell Group Changes", xRec."No. Series", 0D, "No.", "No. Series");

            end;
            repeat
                EntryNo += 1;
                CellChangesLines.Init;
                CellChangesLines."Entry No" := EntryNo;
                CellChangesLines."Header No" := "No.";

                CellChangesLines."Account No" := CellMembers."Account No";
                CellChangesLines.Names := CellMembers.Names;
                CellChangesLines."Date Of Birth" := CellMembers."Date Of Birth";
                CellChangesLines."Staff/Payroll" := CellMembers."Staff/Payroll";
                CellChangesLines."ID Number" := CellMembers."ID Number";
                CellChangesLines."Member No." := CellMembers."Member No.";
                CellChangesLines.Substituted := CellMembers.Substituted;
                CellChangesLines."F Name" := CellMembers."F Name";
                CellChangesLines."S Name" := CellMembers."S Name";
                CellChangesLines."L Name" := CellMembers."L Name";
                CellChangesLines.Gender := CellMembers.Gender;
                CellChangesLines."Phone No." := CellMembers."Phone No.";
                CellChangesLines.Type := CellMembers.Type;
                CellChangesLines.Insert;

            until CellMembers.Next = 0;
        end;
    end;

    /// <summary>
    /// UpdateCellChanges.
    /// </summary>
    procedure UpdateCellChanges()
    var
        CellChangeLines: Record "Cell Group Changes Lines";
        CellMembers: Record "Cell Group Members";
        EntryNo: Integer;
        Members: Record Members;
    begin
        if Status <> Status::Approved then
            Error(DocMustbeApproved);

        if Posted = true then
            Error(Error1);
        CellMembers.Reset;
        CellMembers.SetRange("Account No", "Cell No");
        if CellMembers.FindFirst then begin
            repeat
                CellMembers.Delete;
            until CellMembers.Next = 0;
        end;
        Members.Reset;
        Members.SetRange("No.", "Cell No");
        if Members.FindFirst then begin
            Members."Meeting Days" := "Meeting Days";
            Members."Meeting Time" := "Meeting Time";
            Members."Meeting Venue" := "Meeting Venue";
            Members.Modify;
        end;
        CellChangeLines.Reset;
        CellChangeLines.SetRange(CellChangeLines."Header No", "No.");
        CellChangeLines.SetRange(CellChangeLines."Account No", Rec."Cell No");
        if CellChangeLines.Find('-') then begin
            repeat

                CellMembers.Init;
                CellMembers."Account No" := CellChangeLines."Account No";
                CellMembers.Substituted := CellChangeLines.Substituted;
                CellMembers.Names := CellChangeLines.Names;
                CellMembers."Date Of Birth" := CellChangeLines."Date Of Birth";
                CellMembers."Staff/Payroll" := CellChangeLines."Staff/Payroll";
                CellMembers."ID Number" := CellChangeLines."ID Number";
                CellMembers."Member No." := CellChangeLines."Member No.";
                CellMembers."F Name" := CellChangeLines."F Name";
                CellMembers."S Name" := CellChangeLines."S Name";
                CellMembers."L Name" := CellChangeLines."L Name";
                CellMembers.Designation := CellChangeLines.Designation;
                CellMembers.Gender := CellChangeLines.Gender;
                CellMembers.Type := CellChangeLines.Type;
                CellMembers.Insert;

            until CellChangeLines.Next = 0;


            "Posted By" := UserId;
            Posted := true;

            Modify;
            Message('Changes successfully updated');


        end;
    end;
}

