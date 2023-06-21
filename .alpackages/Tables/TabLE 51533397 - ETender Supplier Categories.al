table 51533397 "ETender Supplier Categories"
{
    Caption = 'ETender Supplier Categories';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Supplier No"; Code[40])
        {
            TableRelation = "E-Tender Company Information"."Primary Key";
            trigger OnValidate()
            var
                Supplier: Record "E-Tender Company Information";
            begin
                if Supplier.GET("Supplier No") then
                    "Vendor No" := Supplier."Vendor No";
            end;
        }
        field(3; "Vendor No"; Code[20])
        {

        }
        field(4; Category; Code[100])
        {

        }
        field(5; Description; Text[150])
        {

        }
        field(6; "Date Added"; Date)
        {

        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
