/// <summary>
/// Table File Movement Tracker (ID 51533254).
/// </summary>
table 51533254 "File Movement Tracker"
{

    fields
    {
        field(1; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members."No.";
        }
        field(2; "Approval Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Loans,Special Loans,Personal Loans,Refunds,Funeral Expenses,Withdrawals - Resignation,Withdrawals - Death,Branch Loans';
            OptionMembers = Loans,"Special Loans","Personal Loans",Refunds,"Funeral Expenses","Withdrawals - Resignation","Withdrawals - Death","Branch Loans";
        }
        field(3; Stage; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Remarks; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Being Processed,Approved,Rejected';
            OptionMembers = "Being Processed",Approved,Rejected;
        }
        field(6; "Current Location"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Date/Time In"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Date/Time Out"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "USER ID"; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(11; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Station; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Related Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Securities Register"."No.";
        }
        field(14; "Document Type"; Option)
        {
            OptionMembers = " ","Collateral";
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Member No.", "Related Doc No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    /// <summary>
    /// InitFile.
    /// </summary>
    /// <param name="MemNo">Code[20].</param>
    /// <param name="RelatedDoc">Code[20].</param>
    /// <param name="Doctype">option " ","Collateral".</param>
    /// <param name="Stage">Code[30].</param>
    /// <param name="Station">Code[50].</param>
    /// <param name="Description">Text[50].</param>
    /// <param name="Current Location">Boolean.</param>
    /// <param name="Date/Time In">DateTime.</param>
    /// <param name="Date/Time Out">DateTime.</param>
    /// <param name="UserC">Code[50].</param>
    procedure InitFile(MemNo: Code[20]; RelatedDoc: Code[20]; Doctype: option " ","Collateral"; Stage: Code[30]; Station: Code[50]; Description: Text[50]; "Current Location": Boolean; "Date/Time In": DateTime; "Date/Time Out": DateTime; UserC: Code[50])
    begin
        Init();
        "Entry No." := 0;
        "Member No." := MemNo;
        "Related Doc No." := RelatedDoc;
        "Document Type" := Doctype;
        Rec.Stage := Stage;
        Rec.Station := Station;
        Rec.Description := Description;
        Rec."Current Location" := "Current Location";
        Rec."Date/Time In" := "Date/Time In";
        Rec."Date/Time Out" := "Date/Time Out";
        Rec."USER ID" := UserC;
        Insert(true);

    end;
}

