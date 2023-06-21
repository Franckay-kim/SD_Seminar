table 51533399 "Etendering Directors"
{
    Caption = 'Etendering Directors';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "First Name"; Text[20])
        {

        }
        field(3; "Middle Name"; Text[20])
        {

        }
        field(4; "Last Name"; Text[20])
        {

        }
        field(5; "Supplier No"; Code[40])
        {
            TableRelation = "E-Tender Company Information";
            trigger OnValidate()
            var
                Supplier: Record "E-Tender Company Information";
            begin
                if Supplier.GET("Supplier No") then
                    "Vendor No" := Supplier."Vendor No";
            end;
        }
        field(6; "ID/Passport"; Text[10])
        {

        }
        field(7; "Telephone No"; Text[20])
        {

        }
        field(8; Email; Text[80])
        {

        }
        field(9; "Shares Percentage"; Decimal)
        {
            trigger OnValidate()
            var
                Total: Decimal;
                Directors: Record "Etendering Directors";
            begin
                Total := 0;

                Directors.Reset;
                Directors.SetRange("Supplier No", "Supplier No");
                Directors.SetFilter(No, '<>%1', No);
                if Directors.FindFirst() then begin
                    repeat
                        Total := Total + Directors."Shares Percentage";
                    until Directors.Next = 0;
                end;
                Total := Total + "Shares Percentage";
                if Total > 100 then
                    Error('Total share percentage cannot be more than 100%.');
            end;
        }
        field(10; "Vendor No"; Code[40])
        {

        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
}
