table 51532291 "Beneficiary Application"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Account No"; Code[20])
        {
            Description = 'LookUp to Member Application Table';
        }
        field(3; Name; Text[50])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                Name := UpperCase(Name);
            end;
        }
        field(4; Relationship; Text[30])
        {
            Description = 'LookUp to Relationships Table';
            TableRelation = "Relationship Types";

            trigger OnValidate()
            begin
                //TESTFIELD("Date of Birth");
                //TESTFIELD("ID No./Birth Cert. No.");
                //TESTFIELD(Address);
                //TESTFIELD(Telephone);
            end;
        }
        field(5; Beneficiary; Boolean)
        {
        }
        field(6; "Date of Birth"; Date)
        {

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date of Birth" > Today then
                    Error(DateofBirthError);
            end;
        }
        field(7; Address; Text[30])
        {
        }
        field(8; Telephone; Code[20])
        {
            Caption = 'Mobile No.';

            trigger OnValidate()
            begin
                Telephone := DelChr(Telephone, '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');


                NewMob := CopyStr(Telephone, 1, 4);
                if (CopyStr(Telephone, 1, 4)) <> ('+254') then
                    Error('The Mobile phone No. should take the format of ' + '+254');
                if StrLen(Telephone) <> 13 then
                    Error('Phone No. should be equal to 13 characters');
            end;
        }
        field(9; Fax; Code[10])
        {
        }
        field(10; Email; Text[30])
        {

            trigger OnValidate()
            begin
                //SMTPMail.CheckValidEmailAddresses(Email);
            end;
        }
        field(11; "ID No./Birth Cert. No."; Code[20])
        {

            trigger OnValidate()
            begin
                "ID No./Birth Cert. No." := DelChr("ID No./Birth Cert. No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
                FieldLength("ID No./Birth Cert. No.", 10);
            end;
        }
        field(12; "%Allocation"; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                TotalA := 0;

                NOK.Reset;
                NOK.SetRange(NOK."Account No", "Account No");
                if NOK.Find('-') then begin
                    repeat
                        TotalA := TotalA + NOK."%Allocation"
                    until NOK.Next = 0;
                end;
                TotalA := TotalA + "%Allocation";
                if TotalA > 100 then
                    Error('Total allocation cannot be more than 100%.');
            end;
        }
        field(13; Type; Option)
        {
            OptionCaption = 'Next of Kin,Spouse,Sink Fund Beneficiary,Family Member';
            OptionMembers = "Next of Kin",Spouse,"Benevolent Beneficiary","Family Member";

            trigger OnValidate()
            var
                BBFEntitlement: Record "BBF Entitlement";
            begin
                //   Name:=' ';
                if Type = Type::Spouse then
                    Name := 'Spouse';
                case Type of
                    Type::"Benevolent Beneficiary":
                        begin
                            if BBFEntitlement.Get(Relationship) then begin
                                "BBF Entitlement Code" := BBFEntitlement.Code;
                                "BBF Entitlement" := BBFEntitlement."Sacco Amount";
                            end;
                        end;


                end;
            end;
        }
        field(14; Deceased; Boolean)
        {
            Editable = false;
        }
        field(15; "BBF Entitlement Code"; Code[10])
        {
            TableRelation = "BBF Entitlement".Code WHERE(Self = CONST(false));

            trigger OnValidate()
            begin
                TestField(Type, Type::"Benevolent Beneficiary");
                "BBF Entitlement" := 0;
                BEntitlement.Reset;
                BEntitlement.SetRange(Code, "BBF Entitlement Code");
                if BEntitlement.Find('-') then begin
                    "BBF Entitlement" := BEntitlement."Sacco Amount" + BEntitlement."Insurance Amount";
                end;
            end;
        }
        field(16; "BBF Entitlement"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Type, Type::"Benevolent Beneficiary");
            end;
        }
        field(17; Spouse; Boolean)
        {

            trigger OnValidate()
            begin

                NOK.Reset;
                NOK.SetRange(NOK."Account No", "Account No");
                NOK.SetRange(Spouse, true);
                NOK.SetFilter("Entry No.", '<>%1', "Entry No.");
                if NOK.Find('-') then begin
                    NOK.ModifyAll(Spouse, false);
                end;
            end;
        }
        field(18; "Cheque Collector"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF (Nationality = CONST('')) "Post Code"
            ELSE
            IF (Nationality = FILTER(<> '')) "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(38; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(39; Nationality; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40; County; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Account No", "Entry No.")
        {
            SumIndexFields = "%Allocation";
        }
    }

    fieldgroups
    {
    }

    var
        NOK: Record "Beneficiary Application";
        TotalA: Decimal;
        NOK1: Record "Beneficiary Application";
        //SMTPMail: Codeunit "SMTP Mail";
        BEntitlement: Record "BBF Entitlement";
        NewMob: Code[20];
        PostCode: Record "Post Code";

    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;
}

