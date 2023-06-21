table 51532381 "Plot Allotment"
{

    fields
    {
        field(1;"Plot Code";Code[20])
        {
        }
        field(2;Allotment;Code[20])
        {
        }
        field(3;Issued;Boolean)
        {
            Editable = false;
        }
        field(4;"Issued By";Code[50])
        {
            Editable = false;
        }
        field(5;"Date Issued";Date)
        {
            Editable = false;
        }
        field(6;"Plot No.";Code[20])
        {
            Editable = false;
        }
        field(7;"Member No.";Code[20])
        {
            Editable = false;
        }
        field(8;"Member Name";Text[200])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Plot Code",Allotment)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        if Issued then
          Error('You cannot Delete issued plots');
    end;

    trigger OnModify()
    begin

        if Issued then
          Error('You cannot Modify issued plots');
    end;
}

