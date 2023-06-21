table 51532020 "Segment/County/Dividend/Signat"
{
    // LookupPageID = "Segment/County/Dividend/Signat";

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = ' ,Station,County,Dividend Payment Type,Signatory Type,Sub-County,Province';
            OptionMembers = " ",Station,County,"Dividend Payment Type","Signatory Type","Sub-County",Province;
        }
        field(2; "Code"; Code[30])
        {

        }
        field(3; Description; Text[50])
        {
        }
        field(4; "Market Ninch Details"; Text[80])
        {
        }
        field(5; County; Code[30])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
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
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}

