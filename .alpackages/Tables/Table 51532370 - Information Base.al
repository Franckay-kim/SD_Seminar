table 51532370 "Information Base"
{

    fields
    {
        field(1;"Member No.";Code[20])
        {
        }
        field(2;Info;Text[250])
        {

            trigger OnValidate()
            begin

                Date:=Today;
                "Captured By":=UserId;
            end;
        }
        field(3;Date;Date)
        {
            Editable = false;
        }
        field(4;"Captured By";Code[50])
        {
            Editable = false;
        }
        field(5;"Account No.";Code[20])
        {
        }
        field(6;"Communication Channel";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Phone,Email,Letter,"Office Visit";
        }
        field(7;"Communication Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Promise to Pay","Negotiation in Progress","Non-Commito","Out of Service"," Wrong Number","Phone Off","No response","Third Party"," F&F";
        }
        field(8;"Collection Pipe";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Active,"Non-Payer",Acivated,"Irregular Payer","Regular Payer";
        }
        field(9;"Last Date Modified";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10;"Last Modified By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11;"Amount in Arreare";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Amount Paid";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Next Action Date";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Member No.",Info)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('Debtor Information base cannot be deleted');
    end;

    trigger OnModify()
    begin
        "Last Date Modified":=CurrentDateTime;
        "Last Modified By":=UserId;
    end;
}

