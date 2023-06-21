table 51532282 "Joint Members"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Account No";Code[20])
        {
            NotBlank = true;
        }
        field(3;Names;Text[50])
        {
            NotBlank = true;
        }
        field(4;"Date Of Birth";Date)
        {

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date Of Birth" > Today then
                  Error(DateofBirthError);
            end;
        }
        field(5;"Staff/Payroll";Code[20])
        {
        }
        field(6;"ID Number";Code[50])
        {
        }
        field(7;Signatory;Boolean)
        {
        }
        field(8;"Must Sign";Boolean)
        {
        }
        field(9;"Must be Present";Boolean)
        {
        }
        field(10;Picture;BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(11;Signature;BLOB)
        {
            Caption = 'Signature';
            SubType = Bitmap;
        }
        field(12;"Expiry Date";Date)
        {
        }
        field(13;Type;Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Type WHERE (Type=CONST("Signatory Type"));
        }
        field(14;"Member No.";Code[10])
        {

            trigger OnValidate()
            var
                Members: Record Members;
                ImageData: Record "Image Data";
            begin
                if Members.Get("Member No.") then begin
                  Names:=Members.Name;
                  "ID Number":=Members."ID No.";
                  "Date Of Birth":=Members."Date of Birth";
                  "Staff/Payroll":=Members."Payroll/Staff No.";

                   ImageData.Reset;
                   ImageData.SetRange(ImageData."Member No",Members."No.");
                   if ImageData.Find('-') then begin
                    ImageData.CalcFields(Picture,Signature);
                    Picture:=ImageData.Picture;
                    Signature:=ImageData.Signature;
                    end;
                 end;
            end;
        }
        field(15;"F Name";Text[30])
        {
        }
        field(16;"S Name";Text[30])
        {
        }
        field(17;"L Name";Text[30])
        {
        }
        field(18;"ID Type";Code[10])
        {
        }
        field(19;Designation;Text[150])
        {
        }
        field(20;Gender;Option)
        {
            OptionMembers = "  ",Male,Female;
        }
        field(21;"Phone No.";Code[20])
        {
        }
        field(22;"Account Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Member,"Non-Member";
        }
        field(23;"Physical Residdence";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24;"PIN Number";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25;"ID Front";BLOB)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(26;"ID Back";BLOB)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1;"Account No","Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        AccountSignatories.Reset;
        AccountSignatories.SetRange("Account No","Account No");
        ACount:=AccountSignatories.Count;

        ACount+=1;
        "Entry No":=ACount;
    end;

    var
        AccountSignatories: Record "Account Signatories";
        ACount: Integer;
}

