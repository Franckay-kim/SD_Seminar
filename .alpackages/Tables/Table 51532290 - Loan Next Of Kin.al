table 51532290 "Loan Next Of Kin"
{
    //DrillDownPageID = "Loan Next Of Kin";
    //LookupPageID = "Loan Next Of Kin";

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Account No"; Code[20])
        {
            TableRelation = Loans."Loan No.";
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
        }
        field(5; Beneficiary; Boolean)
        {
            Enabled = false;
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
        field(7; Address; Text[50])
        {
        }
        field(8; Telephone; Code[20])
        {
            Caption = 'Mobile No.';

            trigger OnValidate()
            begin
                Telephone := DelChr(Telephone, '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');

                if Telephone <> '' then begin

                    if (CopyStr(Telephone, 1, 4)) <> ('+254') then
                        Error('The Mobile phone No. should take the format of ' + '+254');
                    if StrLen(Telephone) <> 13 then
                        Error('Phone No. should be equal to 13 characters');
                end;
            end;
        }
        field(9; Fax; Code[10])
        {
        }
        field(10; Email; Text[30])
        {
        }
        field(11; "ID No."; Code[20])
        {

            trigger OnValidate()
            begin
                "ID No." := DelChr("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
                FieldLength("ID No.", 10);
            end;
        }
        field(12; "%Allocation"; Decimal)
        {
            Enabled = false;
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
            begin
                Relationship := ' ';
                if Type = Type::Spouse then
                    Relationship := 'Spouse';
            end;
        }
        field(14; Deceased; Boolean)
        {
            Editable = false;
            Enabled = false;
        }
        field(15; "BBF Entitlement Code"; Code[10])
        {
            Enabled = false;
            TableRelation = "BBF Entitlement".Code WHERE(Self = CONST(false));

            trigger OnValidate()
            begin
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
            Enabled = false;
        }
        field(17; Spouse; Boolean)
        {
            Enabled = false;
        }
        field(18; "Cheque Collector"; Boolean)
        {
            DataClassification = ToBeClassified;
            Enabled = false;
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
        key(Key1; "Account No", "Entry No.", Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Loans.Get("Account No") then begin
            if Loans.Posted = true then Error('You cannot modify, loan already posted');
        end;
    end;

    trigger OnModify()
    begin
        if Loans.Get("Account No") then begin
            if Loans.Posted = true then Error('You cannot modify, loan already posted');
        end;
    end;

    trigger OnRename()
    begin
        if Loans.Get("Account No") then begin
            if Loans.Posted = true then Error('You cannot modify, loan already posted');
        end;
    end;

    var
        NOK: Record "Next of KIN";
        TotalA: Decimal;
        NOK1: Record "Next of KIN";
        BEntitlement: Record "BBF Entitlement";
        PostCode: Record "Post Code";
        Loans: Record Loans;

    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;
}

