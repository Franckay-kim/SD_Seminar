table 51532028 "Image Data"
{

    fields
    {
        field(1; "ID Number"; Code[100])
        {
        }
        field(2; Picture; BLOB)
        {
            SubType = Bitmap;
        }
        field(3; Signature; BLOB)
        {
            SubType = Bitmap;

        }
        field(4; "Member No"; Code[100])
        {
            Description = 'LookUp to Member Table';
            TableRelation = Members;
        }
        field(5; "Sketch Map"; BLOB)
        {
            SubType = Bitmap;
        }
        field(6; "ID - Front Page"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(7; "ID - Back Page"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(8; FingerOne; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(9; FingerTwo; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(10; FingerThree; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(11; FingerFour; BLOB)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Member No")
        {
        }
    }

    fieldgroups
    {
    }
}

