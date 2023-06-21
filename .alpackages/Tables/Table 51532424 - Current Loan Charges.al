table 51532424 "Current Loan Charges"
{

    fields
    {
        field(1; "Loan No."; Code[30])
        {

        }
        field(2; "Charge Type"; Option)
        {

            OptionCaption = ' ,Product Charge,Other Charges';
            OptionMembers = " ","Product Charge","Other Charges";
        }
        field(3; "Charge Code"; Code[20])
        {
            TableRelation = "Loan Charges"."Charge Code" WHERE("Additional Loan Charge" = CONST(true));

            trigger OnValidate()
            begin
                "G/L Account" := '';
                Description := '';
                Amount := 0;

                if LCharge.Get("Charge Code") then begin
                    LCharge.TestField("G/L Account");
                    "G/L Account" := LCharge."G/L Account";
                    Description := LCharge."Charge Description";
                    Amount := LCharge."Charge Amount";
                    "Effect Excise Duty" := LCharge."Effect Excise Duty";
                end;
            end;
        }
        field(4; Description; Text[50])
        {
        }
        field(5; Amount; Decimal)
        {

        }
        field(6; "G/L Account"; Code[20])
        {

            Editable = false;
        }
        field(7; "Effect Excise Duty"; Option)
        {

            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Charge Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LCharge: Record "Loan Charges";
}

