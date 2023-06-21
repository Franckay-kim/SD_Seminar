table 51532332 "Agent Group Schedule"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2;"Document No";Code[20])
        {
            Editable = false;
        }
        field(3;"Group Code";Code[20])
        {
            Editable = false;
        }
        field(4;"Total Group Loan Paid";Decimal)
        {
            Editable = false;
        }
        field(5;"Total Group Loan UnPaid";Decimal)
        {
            Editable = false;
        }
        field(6;"Total Group Savings Paid";Decimal)
        {
            Editable = false;
        }
        field(7;"Total Savings Paid";Decimal)
        {
            Editable = false;
        }
        field(8;"Total Group Paid Amount";Decimal)
        {
            Editable = false;
        }
        field(9;"GroupTransaction Verified By";Text[250])
        {
            Editable = false;
        }
        field(10;"Group Verifier Phone Number";Text[250])
        {
            Editable = false;
        }
        field(11;"Group Trans Init Time";DateTime)
        {
            Editable = false;
        }
        field(12;"Group Trans Posting Time";DateTime)
        {
            Editable = false;
        }
        field(13;"Group Present Members";Integer)
        {
            Editable = false;
        }
        field(14;"Group Absent Members";Integer)
        {
            Editable = false;
        }
        field(15;"Group Image";BLOB)
        {
            SubType = Bitmap;
        }
        field(16;"Group Remarks";Text[250])
        {
            Editable = false;
        }
        field(17;Posted;Boolean)
        {
            Editable = false;
        }
        field(18;"Posted By";Code[50])
        {
            Editable = false;
        }
        field(19;"Date Posted";DateTime)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error(ErrRestr,'DELETE');
    end;

    trigger OnModify()
    begin
        Error(ErrRestr,'MODIFY');
    end;

    var
        ErrRestr: Label '%1 Operation Restriced!';
}

