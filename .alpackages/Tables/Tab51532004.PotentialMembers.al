table 51532004 "Potential Members"
{
    Caption = 'Potential Members';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; "ID No"; Code[20])
        {
            Caption = 'ID No';
            DataClassification = ToBeClassified;
        }
        field(4; "Phone No"; Code[20])
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
        field(6; Remarks; text[250])
        {

        }
        field(5; "Email Address"; Text[50])
        {
            Caption = 'Email Address';
            DataClassification = ToBeClassified;
        }
        field(7; "Middle Name"; Text[100])
        {

        }
        field(8; "Last Name"; Text[100])
        {

        }
        field(9; "First Name"; Text[100])
        {

        }
        field(10; EntryNo; Integer)
        {
            AutoIncrement = true;
        }
        field(11; "Nature of Visit"; Option)
        {
            Caption = 'Nature of Visit';
            DataClassification = ToBeClassified;
            OptionMembers = Recruitment,Education,FollowUp,Loan;
        }
        field(12; "Convert"; Boolean)
        {

        }
        field(13; Nationality; Code[20])
        {
            TableRelation = "Country/Region";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if CountryRegion.Get(Nationality) then
                    "Phone No" := CountryRegion."EU Country/Region Code";
                Nationality := UpperCase(Nationality);
            end;
        }

    }
    keys
    {
        key(PK; "Code", EntryNo)
        {
            Clustered = true;
        }
    }
    var
        CountryRegion: Record "Country/Region";
        NewMob: code[20];
}
