table 51532211 "Bank Slip Line"
{

    fields
    {
        field(1;No;Code[20])
        {
            Description = 'Stores the reference to the header';
        }
        field(2;Type;Option)
        {
            Description = 'Stores the type of pay in';
            OptionMembers = " ",Cash,Cheque;

            trigger OnValidate()
            begin
                if Type=Type::" " then
                    Error('Type Cannot be Blank')
            end;
        }
        field(3;"Cheque No";Code[20])
        {
            Description = 'Stores the cheque no.';

            trigger OnValidate()
            begin
                /*IF Type=Type::Cash THEN
                  BEGIN
                    IF "Cheque No"='' THEN
                      BEGIN
                        ERROR('Cheque Number Must Be Entered');
                      END;
                  END;*/

            end;
        }
        field(4;"Drawers Name";Text[50])
        {
            Description = 'Stores the name of the drawer';
        }
        field(5;"Cheque Date";Date)
        {
            Description = 'Stores the date of the cheque';

            trigger OnValidate()
            begin
                
                
                /*
                IF Type=Type::"1" THEN
                  BEGIN
                    IF "Cheque Date"=0D THEN
                      BEGIN
                        ERROR('Cheque Date Must Be Entered');
                      END;
                  END;
                  */

            end;
        }
        field(6;Amount;Decimal)
        {
            Description = 'Stores the amount';
        }
        field(7;"Line No";Integer)
        {
            AutoIncrement = true;
        }
        field(8;"Bank Slip No.";Code[20])
        {
            Description = 'Stores the reference of the bank pay in slip number into the database';
        }
        field(9;Select;Boolean)
        {
        }
        field(10;Posted;Boolean)
        {
        }
        field(11;"Posted By";Code[50])
        {
        }
        field(12;"Posted Date";Date)
        {
        }
        field(13;"Posted Time";Time)
        {
        }
        field(14;"Posted Machine";Text[100])
        {
        }
        field(15;Vaulted;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;No,"Line No")
        {
        }
        key(Key2;Select)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Header.Reset;
        if Header.Get(No) then
          begin
            if (Header."Bank Slip No."<>'')and ("Bank Slip No."='') then
              begin
                "Bank Slip No.":=Header."Bank Slip No.";
              end;
          end;
    end;

    var
        Header: Record "Bank Slip";
}

