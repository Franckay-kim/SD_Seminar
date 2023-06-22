/// <summary>
/// Table Contact Unit (ID 51532002).
/// </summary>
table 51532002 "Contact Unit"
{
    Caption = 'Contact Unit';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Contact Category"; Option)
        {
            Caption = 'Contact Category';
            DataClassification = ToBeClassified;
            OptionMembers = ,Potential,Existing;
        }
        field(3; "Employer No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
            //TableRelation = Customer where("Account Type" = const(Employer));

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                Cust.reset;
                Cust.SetRange("No.", "Employer No");
                if Cust.FindFirst() then
                    "Full Name" := Cust.Name;
                "Contact Phone No" := Cust."Phone No.";
                "E-Mail" := Cust."E-Mail";
            end;
        }
        field(20; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
            //TableRelation = Customer where("Account Type" = const(Employer));
        }
        field(21; "ID No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
        }
        field(4; "First Name"; Text[100])
        {
            Caption = 'First Name';
            DataClassification = ToBeClassified;
        }
        field(5; "Middle Name"; Text[100])
        {
            Caption = 'Middle Name';
            DataClassification = ToBeClassified;
        }
        field(6; "Last Name"; Text[100])
        {
            Caption = 'Last Name';
            DataClassification = ToBeClassified;
        }
        field(7; "Full Name"; Text[250])
        {
            Caption = 'Full Name';
            DataClassification = ToBeClassified;
        }
        field(8; "Visit Date"; Date)
        {
            Caption = 'Visit Date';
            DataClassification = ToBeClassified;
        }
        field(9; "Contact Person"; Text[100])
        {
            Caption = 'Contact Person';
            DataClassification = ToBeClassified;
        }
        field(10; "Physical Address"; Text[100])
        {
            Caption = 'Physical Address';
            DataClassification = ToBeClassified;
        }
        field(11; "Postal Address"; Text[100])
        {
            Caption = 'Postal Address';
            DataClassification = ToBeClassified;
        }
        field(12; Branch; Code[20])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }
        field(13; Objective; Text[250])
        {
            Caption = 'Objective';
            DataClassification = ToBeClassified;
        }
        field(14; "Phone No"; Text[50])
        {
            Caption = 'Phone No';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Phone No" := UpperCase("Phone No");

                "Phone No" := DelChr("Phone No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');

                CountryRegion.Get(Nationality);
                NewMob := '';
                NewMob := CopyStr("Phone No", 1, 4);
                if (CopyStr("Phone No", 1, 4)) <> (CountryRegion."EU Country/Region Code") then
                    Error('The Mobile phone No. should take the format of ' + CountryRegion."EU Country/Region Code");
                if StrLen("Phone No") <> 13 then
                    Error('Phone No. should be equal to 13 characters');
            end;
        }
        field(15; "E-Mail"; Text[50])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
        }
        field(16; "Contact Phone No"; Code[20])
        {
            Caption = 'Contact Phone No';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Contact Phone No" := UpperCase("Contact Phone No");

                "Contact Phone No" := DelChr("Contact Phone No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');

                CountryRegion.Get(Nationality);
                ContNewMob := '';
                ContNewMob := CopyStr("Contact Phone No", 1, 4);
                if (CopyStr("Contact Phone No", 1, 4)) <> (CountryRegion."EU Country/Region Code") then
                    Error('The Mobile phone No. should take the format of ' + CountryRegion."EU Country/Region Code");
                if StrLen("Contact Phone No") <> 13 then
                    Error('Phone No. should be equal to 13 characters');
            end;
        }
        field(17; "No. Series"; Code[20])
        {

        }
        field(18; Converted; Boolean)
        {
            Editable = false;
        }
        field(19; "Physical Location"; Text[100])
        {

        }
        field(22; Diocese; code[20])
        {
            TableRelation = Diocese;
        }
        field(23; "Contact Email"; text[100])
        {
        }
        field(24; "Created By"; code[50])
        {
            Editable = false;
        }
        field(25; "Convert Group"; Boolean)
        {

        }
        field(26; "Contact Type"; Option)
        {
            OptionMembers = Staff,Officer;
        }
        field(27; Nationality; Code[20])
        {
            TableRelation = "Country/Region";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if CountryRegion.Get(Nationality) then
                    "Phone No" := CountryRegion."EU Country/Region Code";
                "Contact Phone No" := CountryRegion."EU Country/Region Code";
                Nationality := UpperCase(Nationality);
            end;
        }
        field(28; "Incoming Document Entry No."; Integer)
        {

        }
        field(29; RecID; RecordId)
        {

        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            CreditNoSeries.Get();
            CreditNoSeries.TestField("Contact Unit No");
            NoSeriesMgt.InitSeries(CreditNoSeries."Contact Unit No", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Created By" := UserId;

        if userset.Get(UserId) then begin
            //Branch := userset."Global Dimension 2 Code";
        end;

    end;

    var
        CreditNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        userset: Record "User Setup";
        CountryRegion: Record "Country/Region";
        NewMob: code[20];
        ContNewMob: code[20];
}
