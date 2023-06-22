/// <summary>
/// Table Member Visitation (ID 51532003).
/// </summary>
table 51532003 "Member Visitation"
{
    Caption = 'Member Visitation';
    DataClassification = ToBeClassified;
    //LookupPageId = "Member Visitation List";
    //DrillDownPageId = "Member Visitation List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Visitation Date"; Date)
        {
            Caption = 'Visitation Date';
            DataClassification = ToBeClassified;
        }
        field(3; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Unit Visited"; text[150])
        {
            Caption = 'Unit Visited';
            DataClassification = ToBeClassified;
        }
        field(6; "Imprest Request Doc No."; Code[20])
        {
            Caption = 'Imprest Request Doc No.';
            DataClassification = ToBeClassified;
            TableRelation = "Imprest Header";
        }
        field(7; "C.E.O Recommendations"; Text[250])
        {
            Caption = 'C.E.O Recommendations';
            DataClassification = ToBeClassified;
        }
        field(8; "No. Series"; Code[20])
        {

        }
        field(9; "Contact Unit Card"; Code[20])
        {
            TableRelation = "Contact Unit";
        }
        field(10; "Marketing Manager remarks"; Text[250])
        {

        }
        field(11; Status; option)
        {
            OptionMembers = Open,Pending,Approved;
        }
        field(12; "Unit To Be Visited"; Text[150])
        {

        }
        field(13; Reason; text[150])
        {

        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            CreditNoSeries.Get();
            CreditNoSeries.TestField("Member Visistation No");
            NoSeriesMgt.InitSeries(CreditNoSeries."Member Visistation No", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        CreditNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
