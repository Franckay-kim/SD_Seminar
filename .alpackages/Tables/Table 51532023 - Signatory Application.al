table 51532023 "Signatory Application"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Account No"; Code[20])
        {
            NotBlank = true;
        }
        field(3; Names; Text[50])
        {

            NotBlank = true;
        }
        field(4; "Date Of Birth"; Date)
        {

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date Of Birth" > Today then
                    Error(DateofBirthError);
                GeneralSetUp.Get;
                if CalcDate(GeneralSetUp."Min. Member Age", "Date Of Birth") > Today then
                    Error(MinimumAgeError, GeneralSetUp."Min. Member Age");


                if (CalcDate(GeneralSetUp."Max. Member Age", "Date Of Birth")) < Today
                then
                    Error('The member age of %1 is exceeded', GeneralSetUp."Max. Member Age");
            end;
        }
        field(5; "Staff/Payroll"; Code[20])
        {
        }
        field(6; "ID Number"; Code[50])
        {
        }
        field(7; Signatory; Boolean)
        {
        }
        field(8; "Must Sign"; Boolean)
        {
        }
        field(9; "Must be Present"; Boolean)
        {
        }
        field(10; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(11; Signature; BLOB)
        {
            Caption = 'Signature';
            SubType = Bitmap;
        }
        field(12; "Expiry Date"; Date)
        {
        }
        field(13; Type; Option)
        {
            OptionCaption = 'Member,Chair Person,Secretary,Treasurer,Vice Chair Persion';
            OptionMembers = Member,"Chair Person",Secretary,Treasurer,"Vice Chair Persion";
        }
        field(14; "Member No."; Code[10])
        {
            TableRelation = IF ("Account Type" = CONST(Member)) Members WHERE("Customer Type" = CONST(Single), Status = const(Active))
            ELSE
            IF ("Account Type" = CONST("Non-Member")) "Non-Members";

            trigger OnValidate()
            var
                Members: Record Members;
                ImageData: Record "Image Data";
                NonMembers: Record "Non-Members";
            begin
                if "Account Type" = "Account Type"::Member then begin
                    if Members.Get("Member No.") then begin
                        Names := Members.Name;
                        "ID Number" := Members."ID No.";
                        "Date Of Birth" := Members."Date of Birth";
                        "Staff/Payroll" := Members."Payroll/Staff No.";
                        "Phone No." := Members."Mobile Phone No";
                        //VALIDATE("Phone No.");
                        "PIN Number" := Members."P.I.N Number";

                        ImageData.Reset;
                        ImageData.SetRange(ImageData."Member No", Members."No.");
                        if ImageData.Find('-') then begin
                            ImageData.CalcFields(Picture, Signature);
                            Picture := ImageData.Picture;
                            Signature := ImageData.Signature;
                        end;
                    end;
                end else
                    if "Account Type" = "Account Type"::"Non-Member" then begin
                        NonMembers.Reset;
                        NonMembers.SetRange("ID No.", "Member No.");
                        if NonMembers.FindFirst then begin
                            Names := NonMembers.Name;
                            "Date Of Birth" := NonMembers."Date of Birth";
                            "ID Number" := NonMembers."ID No.";
                            "Phone No." := NonMembers."Mobile Phone No";
                            //VALIDATE("Phone No.");
                            "PIN Number" := NonMembers."P.I.N Number";
                        end;
                    end;
                if "Account Type" = "Account Type"::Member then begin

                    SignatoryApplication.SetRange("Account No", "Account No");
                    SignatoryApplication.SetRange("Member No.", "Member No.");
                    if SignatoryApplication.Find('-') then begin
                        Error('This member is already a signatory within this application');
                    end;
                end;
            end;
        }
        field(15; "Entry Type"; Option)
        {
            OptionCaption = 'Initial,Changes';
            OptionMembers = Initial,Changes;
        }
        field(16; "Phone No."; Code[20])
        {

            trigger OnValidate()
            begin
                "Phone No." := DelChr("Phone No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');

                if "Phone No." <> '' then begin

                    ///CountryRegion.GET(Nationality);
                    if (CopyStr("Phone No.", 1, 4)) <> ('+254') then
                        Error('The Mobile phone No. should take the format of ' + '+254');
                    if StrLen("Phone No.") <> 13 then
                        Error('Phone No. should be equal to 13 characters');
                end;
            end;
        }
        field(17; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Member,"Non-Member";
        }
        field(18; "PIN Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Expired"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
                "Expired By" := UserId;
                "Expiry Date" := Today;
            end;
        }
        field(20; "Expired By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Account No", "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Rec.Reset;
        Rec.SetRange("Account No", "Account No");
        if Rec.Count > 19 then Error('Group Account must have three to twenty members');
    end;

    var
        SignatoryApplication: Record "Signatory Application";
        GeneralSetUp: Record "General Set-Up";
        MinimumAgeError: Label 'Minimum Age for Membership is %1';
}

