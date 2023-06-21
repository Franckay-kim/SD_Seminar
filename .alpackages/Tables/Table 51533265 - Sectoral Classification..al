table 51533265 "Sectoral Classification."
{
    DataCaptionFields = "Sub Sector Level2", "Sub Sector Level2 Description";


    fields
    {
        field(1; "Main Sector"; Code[130])
        {
        }
        field(2; "Main Sector Description"; Text[100])
        {
        }
        field(3; "Sub Sector Level1"; Code[130])
        {
        }
        field(4; "Sub Sector Level1 Description"; Text[100])
        {
        }
        field(5; "Sub Sector Level2"; Code[130])
        {
        }
        field(6; "Sub Sector Level2 Description"; Text[130])
        {
        }
    }

    keys
    {
        key(Key1; "Main Sector", "Sub Sector Level1", "Sub Sector Level2")
        {
        }
        key(Key2; "Sub Sector Level2")
        {
        }
    }


    fieldgroups
    {
        fieldgroup(DropDown; "Main Sector Description", "Sub Sector Level1 Description", "Sub Sector Level2 Description") { }
    }

}

