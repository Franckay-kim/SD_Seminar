table 51532131 "BoardRoom Attendees"
{
    Caption = 'BoardRoom Attendees';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Member No."; Code[30])
        {
            Caption = 'Member No.';
            TableRelation = Members;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Mem: record Members;
            begin
                Mem.Reset();
                Mem.SetRange("No.", Rec."Member No.");
                if Mem.FindFirst() then begin
                    "Member Name" := Mem.Name;
                    "E-Mail" := Mem."E-Mail";
                end;
            end;
        }
        field(2; "Booking No."; Code[20])
        {
            Caption = 'Booking No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Member Name"; Text[150])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(4; "E-Mail"; Code[50])
        {

        }
    }
    keys
    {
        key(PK; "Member No.", "Booking No.")
        {
            Clustered = true;
        }
    }
}
