/// <summary>
/// Table Etendering Partners (ID 51533398).
/// </summary>
table 51533398 "Etendering Partners"
{
    Caption = 'Etendering Partners';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Supplier No"; Code[40])
        {
            TableRelation = "E-Tender Company Information";
        }
        field(3; "Partner Name"; Text[100])
        {

        }
        field(4; "Partner Nationality"; Text[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(5; "Partner Shares"; Decimal)
        {
            Caption = 'Partner Shares in %';

            trigger OnValidate()
            var
                Total: Decimal;
                Partners: Record "Etendering Partners";
            begin
                Total := 0;

                Partners.Reset;
                Partners.SetRange("Supplier No", "Supplier No");
                Partners.SetFilter(No, '<>%1', No);
                if Partners.FindFirst() then begin
                    repeat
                        Total := Total + Partners."Partner Shares";
                    until Partners.Next = 0;
                end;
                Total := Total + "Partner Shares";
                if Total > 100 then
                    Error('Total share percentage cannot be more than 100%.');
            end;
        }
        field(6; "Citizenship Details"; Text[100])
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
