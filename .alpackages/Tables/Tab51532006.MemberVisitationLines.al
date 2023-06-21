table 51532006 "Member Visitation Lines"
{
    Caption = 'Member Visitation Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
            TableRelation = Members;

            trigger OnValidate()
            var
                Memb: Record Members;
            begin
                Memb.Reset();
                Memb.SetRange("No.", "Member No");
                if Memb.FindFirst() then begin
                    "Member Name" := Memb.Name;
                    "ID No" := Memb."ID No.";
                    "Phone No" := Memb."Mobile Phone No";
                    "E-mail" := Memb."E-Mail";
                    Department := Memb."Global Dimension 2 Code";
                end;
            end;
        }
        field(3; "Member Name"; Text[100])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(4; "ID No"; Code[20])
        {
            Caption = 'ID No';
            DataClassification = ToBeClassified;
        }
        field(5; "E-mail"; Text[50])
        {
            Caption = 'E-mail';
            DataClassification = ToBeClassified;
        }
        field(6; "Phone No"; Code[20])
        {
            Caption = 'Phone No';
            DataClassification = ToBeClassified;
        }
        field(7; Department; Code[20])
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
        }
        field(8; EntryNo; Integer)
        {
            AutoIncrement = true;
        }
    }
    keys
    {
        key(PK; "No.", EntryNo)
        {
            Clustered = true;
        }
        key(Key1; EntryNo)
        {

        }
    }
}
