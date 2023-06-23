/// <summary>
/// Table Tiered Charges Lines (ID 51532103).
/// </summary>
table 51532103 "Tiered Charges Lines"
{


    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Lower Limit"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Lower Limit" < 0 then
                    Error('Lower Limit cannot be less than Zero');

                if "Upper Limit" <> 0 then begin
                    if "Lower Limit" > "Upper Limit" then
                        Error('Lower limit cannot be greater than the upper limit');
                end;
            end;
        }
        field(3; "Upper Limit"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Upper Limit" < 0 then
                    Error('Upper Limit cannot be less than Zero');
                if "Lower Limit" <> 0 then begin
                    if "Upper Limit" < "Lower Limit" then
                        Error('Upper limit cannot be less than the lower limit amount');
                end;
            end;
        }
        field(4; "Charge Amount"; Decimal)
        {
        }
        field(5; "Use Percentage"; Boolean)
        {
        }
        field(6; Percentage; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Lower Limit")
        {
        }
    }

    fieldgroups
    {
    }
}

