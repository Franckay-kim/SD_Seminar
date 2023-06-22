/// <summary>
/// Table Product Documents (ID 51532051).
/// </summary>
table 51532051 "Product Documents"
{
    //DrillDownPageID = "Product Document";
    //LookupPageID = "Product Document";

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = ' ,Member,Account,Loan';
            OptionMembers = " ",Member,Account,Loan;
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
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = Single,Multiple,Business;
        }
        field(6; "Product ID"; Code[20])
        {
            TableRelation = "Product Factory";
        }
        field(7; "Product Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Product ID", "Document No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

