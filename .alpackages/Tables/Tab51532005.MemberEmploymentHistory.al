table 51532005 "Member Employment History"
{
    Caption = 'Member Employment History';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Member No."; Code[30])
        {
            Caption = 'Member No.';
            TableRelation = Members."No.";
            DataClassification = ToBeClassified;
        }
        field(3; "Employer Code"; Code[50])
        {
            Caption = 'Employer Code';
            TableRelation = Customer."No.";
            DataClassification = ToBeClassified;
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Change Document No."; Code[50])
        {
            Caption = 'Change Document No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Change UserID"; Code[50])
        {
            Caption = 'Change UserID';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }

    procedure InitEntry(MemberNo: Code[30]; EmpCode: Code[50]; ChangeDocNo: Code[50])
    begin
        Init();
        "Entry No" := 0;
        validate("Member No.", MemberNo);
        validate("Employer Code", EmpCode);
        validate("Start Date", Today);
        Validate("Change UserID", UserId);
        Validate("Change Document No.", ChangeDocNo);
        Insert(true);

    end;
}
