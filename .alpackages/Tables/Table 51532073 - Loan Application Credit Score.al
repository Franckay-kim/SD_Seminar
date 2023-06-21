table 51532073 "Loan Application Credit Score"
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
        }
        field(2; "Product Code"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
        }
        field(3; "Parameter Code"; Code[20])
        {
            //TableRelation = "DCS Parameter".Code;

            trigger OnValidate()
            begin
                /*if DCSParameter.Get("Parameter Code") then
                 "Parameter Name":=DCSParameter.Description;*/
            end;
        }
        field(4; Score; Decimal)
        {
        }
        field(5; "Calculated Success"; Decimal)
        {
        }
        field(6; "Calculated Failure"; Decimal)
        {
        }
        field(7; "Requested Amount"; Decimal)
        {
        }
        field(8; "Qualifying Amount"; Decimal)
        {
        }
        field(9; RequestTime; DateTime)
        {
        }
        field(10; "General Output"; Text[100])
        {
        }
        field(11; "Loan No."; Code[20])
        {
        }
        field(12; "Parameter Name"; Text[100])
        {
        }
        field(13; Priority; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Loan No.", "Parameter Code")
        {
        }
        key(Key2; Priority)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        RequestTime := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        RequestTime := CurrentDateTime;
    end;

    var
    //DCSParameter: Record "DCS Parameter";
}

