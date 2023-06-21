table 51532001 "Procurement Committees"
{
    Caption = 'Procurement Committees';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "RFQ No"; Code[20])
        {
            Caption = 'RFQ No';
            DataClassification = ToBeClassified;
        }
        field(3; "RFQ Description"; Text[250])
        {
            Caption = 'RFQ Description';
            DataClassification = ToBeClassified;
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Responsible Employee"; Code[20])
        {
            Caption = 'Responsible Employee';
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                Emp.Reset();
                Emp.SetRange("No.", Rec."Responsible Employee");
                if Emp.FindFirst() then
                    Rec."Employee Name" := Emp."Full Name";

            end;

        }
        field(6; Venue; Text[100])
        {
            Caption = 'Venue';
            DataClassification = ToBeClassified;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(8; "Committee Type"; Option)
        {
            OptionMembers = ,Opening,Evaluation;
        }
        field(9; "Employee Name"; Text[100])
        {

            DataClassification = ToBeClassified;
        }
        field(10; "No. Series"; Code[20])
        {

        }
    }
    keys
    {
        key(PK;
        "Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if code = '' then begin
            PurchPayables.Get();
            // PurchPayables.TestField("Procurement Committee No.");
            // NoSeriesMgt.InitSeries(PurchPayables."Procurement Committee No.", xRec."No. Series", 0D, Code, "No. Series");
        end;
    end;

    var
        Emp: Record "HR Employees";
        PurchPayables: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
