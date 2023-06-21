table 51532408 "Electrol Zones/Area Svr Center"
{
    Caption = 'Electrol Zones/Area Svr Center/Buying Centre';
    //LookupPageId = "Electoral Zone Setup";
    //DrillDownPageId = "Electoral Zone Setup";


    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = ' ,Electral Zone,Area Service Centers,Buying Centre,Factory,Location,Sub-Location,Village';
            OptionMembers = " ","Electral Zone","Area Service Centers","Buying Centre",Factory,Location,"Sub-Location",Village;
        }
        field(2; "Code"; Code[20])
        {
        }
        field(3; Description; Text[150])
        {
        }
        field(4; "Mileage (KMs)"; Decimal)
        {
            Description = '//To gather for delegates transport allowance computations';
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

