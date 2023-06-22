/// <summary>
/// Table Application Documents (ID 51532052).
/// </summary>
table 51532052 "Application Documents"
{
    //LookupPageID = "Application Documents";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = ' ,Member,Account,Loan,BBF';
            OptionMembers = " ",Member,Account,Loan,BBF;
        }
        field(3; "Document No."; Code[10])
        {
            TableRelation = "Application Document Setup";

            trigger OnValidate()
            var
                ApplicationDocumentSetup: Record "Application Document Setup";
            begin
                if ApplicationDocumentSetup.Get("Document No.") then begin
                    "Document Type" := ApplicationDocumentSetup."Document Type";
                    Description := ApplicationDocumentSetup.Description;
                    "Single Party/Multiple" := ApplicationDocumentSetup."Single Party/Multiple";
                end;
            end;
        }
        field(4; Description; Text[250])
        {
            Editable = false;
        }
        field(5; "Single Party/Multiple"; Option)
        {
            OptionCaption = 'Single,Group,Corporate,Cell,Joint';
            OptionMembers = Single,Group,Business,Cell,Joint;
        }
        field(6; "Reference No."; Code[20])
        {
        }
        field(7; "Product ID"; Code[20])
        {
            Editable = false;
            TableRelation = "Product Factory";
        }
        field(8; "Product Name"; Text[100])
        {
            Editable = false;
        }
        field(12; Provided; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;

            trigger OnValidate()
            begin
                "Last Date Modified" := Today;
                "Last Modified By" := UserId;
            end;
        }
        field(13; "Last Modified By"; Code[50])
        {
            Editable = false;
        }
        field(14; "Last Date Modified"; Date)
        {
            Editable = false;
        }
        field(15; RecID; RecordId)
        {

        }
        field(16; "Document Link ID"; Integer)
        {

        }
        field(17; "Document Link"; Text[2048])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Record Link".URL1 where("Link ID" = field("Document Link ID")));
        }
    }

    keys
    {
        key(Key1; "Reference No.", "Product ID", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        RecID := RECORDID;
    end;

    trigger OnModify()
    begin
        RecID := RECORDID;
    end;

    trigger OnRename()
    begin
        RecID := RECORDID;
    end;
}

