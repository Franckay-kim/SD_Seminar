table 51532281 "Cell Group Member Application"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
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
        field(13;Type;Option)
        {
            OptionMembers = Member,"Chair Person",Secretary,Treasurer,"Vice Chair Persion";
        }
        field(14;"Member No.";Code[10])
        {
            TableRelation = Members WHERE ("Customer Type"=CONST(Single));

            trigger OnValidate()
            var
                Members: Record Members;
                ImageData: Record "Image Data";
                NonMembers: Record "Non-Members";
            begin
                if "Account Type"="Account Type"::Member then begin
                if Members.Get("Member No.") then begin
                  Names:=Members.Name;
                  "ID Number":=Members."ID No.";
                  "Date Of Birth":=Members."Date of Birth";
                  "Staff/Payroll":=Members."Payroll/Staff No.";
                  "Phone No.":=Members."Mobile Phone No";


                   ImageData.Reset;
                   ImageData.SetRange(ImageData."Member No",Members."No.");
                   if ImageData.Find('-') then begin
                    ImageData.CalcFields(Picture,Signature);
                    Picture:=ImageData.Picture;
                    Signature:=ImageData.Signature;
                    end;
                 end;
                 end;
                // END ELSE IF "Account Type"="Account Type"::"Non-Member" THEN BEGIN
                //   IF NonMembers.GET("ID Number") THEN BEGIN
                //  Names:=NonMembers.Name;
                //  "ID Number":=NonMembers."ID No.";
                //  "Date Of Birth":=NonMembers."Date of Birth";
                //  "Phone No.":=NonMembers."Mobile Phone No";
                // END;
                // END;
                CellMembers.Reset;
                CellMembers.SetRange(CellMembers."Member No.","Member No.");
                if CellMembers.FindFirst then
                  Error(Err001);

                SignatoryApplication.SetRange("Account No","Account No");
                SignatoryApplication.SetRange("Member No.","Member No.");
                if SignatoryApplication.Find('-') then begin
                  Error('This member is already a member within this application');
                  end;
            end;
        }
        field(15;"Entry Type";Option)
        {
            OptionCaption = 'Initial,Changes';
            OptionMembers = Initial,Changes;
        }
        field(16;"Phone No.";Code[20])
        {
        }
        field(17;"Account Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Member,"Non-Member";
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
        Rec.Reset;
        Rec.SetRange("Account No","Account No");
        if Rec.Count>19 then Error('A cell group must have three to twenty members');
    end;

    var
        SignatoryApplication: Record "Cell Group Member Application";
        CellMembers: Record "Cell Group Members";
        Err001: Label 'This member is already attached to another cell';
}

