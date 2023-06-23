/// <summary>
/// Table E-Tender Company Document (ID 51533369).
/// </summary>
table 51533369 "E-Tender Company Document"
{
    // version EProcurement


    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Reference No"; Text[250])
        {
        }
        field(3; "Document Code"; Code[20])
        {
        }
        field(4; Description; Text[250])
        {
        }
        field(5; "Document Link"; Text[250])
        {
        }
        field(6; RecID; RecordID)
        {
        }
        field(7; Mandatory; Boolean)
        {
        }
        field(8; Category; Option)
        {
            OptionCaption = ',Financial,Supervisory,Business,Registration,Partners,Directors';
            OptionMembers = ,Financial,Supervisory,Business,Registration,Partners,Directors;
        }
        field(9; "Prof RecID"; RecordID)
        {
        }
        field(10; "Mandatory Category"; Option)
        {
            OptionCaption = ',AGPO,General,All';
            OptionMembers = ,"AGPO Group",General,All;
        }
        field(11; "Supplier ident"; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate();
            var
                IncomingDocument: Record "Incoming Document";
            begin
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        RecID := RECORDID;
    end;

    trigger OnModify();
    begin
        RecID := RECORDID;
    end;
}

