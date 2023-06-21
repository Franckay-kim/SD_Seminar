table 51533400 "Field Officer Form"
{
    Caption = 'Field Officer Form';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Officer Name"; Text[100])
        {
            Caption = 'Officer Name';
            DataClassification = ToBeClassified;
        }
        field(4; "No Series"; Code[20])
        {

        }
        field(5; "Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
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
        field(9; "Sent to HOD"; Boolean)
        {

        }
        field(10; Type; Option)
        {
            OptionMembers = ,New,Existing;
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
            CreditNoSeries.TestField("Field Officer Form No");
            NoSeriesMgt.InitSeries(CreditNoSeries."Field Officer Form No", xRec."No Series", 0D, "No.", "No Series");
        end;

    end;

    var
        CreditNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
