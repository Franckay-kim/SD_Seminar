/// <summary>
/// Table Education Campaign Schedule (ID 51533406).
/// </summary>
table 51533406 "Education Campaign Schedule"
{
    Caption = 'Education Campaign Schedule';
    DataClassification = ToBeClassified;
    //DrillDownPageId = "Campaign Schedule List";
    //LookupPageId = "Campaign Schedule List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(3; Branch; Code[20])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(4; Department; Code[20])
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(5; "Assigned UserID"; Code[50])
        {
            Caption = 'Assigned UserID';
            DataClassification = ToBeClassified;
        }
        field(6; "Contact Phone No"; Code[20])
        {
            Caption = 'Contact Phone No';
            DataClassification = ToBeClassified;
        }
        field(7; "Employer No"; Code[20])
        {
            Caption = 'Employer No';
            DataClassification = ToBeClassified;
            //TableRelation = Customer where("Account Type" = const(Employer));

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                Cust.reset;
                Cust.SetRange("No.", "Employer No");
                if Cust.FindFirst() then
                    "Employer Name" := Cust.Name;
                "Contact Phone No" := Cust."Phone No.";
            end;
        }
        field(8; "Employer Name"; Text[80])
        {

        }
        field(9; "Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
            DataClassification = ToBeClassified;
        }
        field(10; Status; option)
        {
            OptionMembers = Open,Pending,Approved;
        }
        field(11; "No Series"; Code[20])
        {

        }
        field(12; Diocese; code[20])
        {
            TableRelation = Diocese;
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
            CreditNoSeries.TestField("Campaign Schedule Nos");
            NoSeriesMgt.InitSeries(CreditNoSeries."Campaign Schedule Nos", xRec."No Series", 0D, "No.", "No Series");
        end;

    end;

    var
        CreditNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
