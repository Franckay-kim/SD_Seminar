table 51532329 "Agent Biometric Data"
{

    fields
    {
        field(1;DocumentNo;Code[20])
        {
        }
        field(2;IDNO;Code[20])
        {
        }
        field(3;PassportPhoto;BLOB)
        {
            SubType = Bitmap;
        }
        field(4;IDFront;BLOB)
        {
            SubType = Bitmap;
        }
        field(5;IDBack;BLOB)
        {
            SubType = Bitmap;
        }
        field(6;Signature;BLOB)
        {
            SubType = Bitmap;
        }
        field(7;FingerOne;BLOB)
        {
            SubType = Bitmap;
        }
        field(8;FingerTwo;BLOB)
        {
            SubType = Memo;
        }
        field(9;FingerThree;BLOB)
        {
            SubType = Memo;
        }
        field(10;FingerFour;BLOB)
        {
            SubType = Memo;
        }
        field(11;ApplicationFormFront;BLOB)
        {
            SubType = Bitmap;
        }
        field(12;ApplicationFormBack;BLOB)
        {
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1;IDNO)
        {
        }
    }

    fieldgroups
    {
    }
}

