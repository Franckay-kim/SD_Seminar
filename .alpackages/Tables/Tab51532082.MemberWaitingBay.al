table 51532082 "Member Waiting Bay"
{
    Caption = 'Member Waiting Bay';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Waiting Bay Nos.");
                    "No. Series" := '';
                    "No." := UpperCase("No.");
                end;
            end;
        }
        field(2; "Customer Type"; Option)
        {
            Caption = 'Customer Type';
            OptionCaption = ' ,Single,Joint,Group,Microfinance,Cell';
            OptionMembers = " ",Single,Joint,Group,Microfinance,Cell;

            DataClassification = ToBeClassified;
        }
        field(3; "ID No."; Code[10])
        {
            Caption = 'ID No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Mobile Phone No."; Code[13])
        {
            Caption = 'Mobile Phone No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Mobile Phone No." := UpperCase("Mobile Phone No.");

                "Mobile Phone No." := DelChr("Mobile Phone No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');

                CountryRegion.Get(Nationality);
                NewMob := '';
                NewMob := CopyStr("Mobile Phone No.", 1, 4);
                if (CopyStr("Mobile Phone No.", 1, 4)) <> (CountryRegion."EU Country/Region Code") then
                    Error('The Mobile phone No. should take the format of ' + CountryRegion."EU Country/Region Code");
                if StrLen("Mobile Phone No.") <> 13 then
                    Error('Phone No. should be equal to 13 characters');
            end;
        }
        field(5; "First Name"; Text[50])
        {
            Caption = 'First Name';
            DataClassification = ToBeClassified;
        }
        field(6; "Second Name"; Text[50])
        {
            Caption = 'Second Name';
            DataClassification = ToBeClassified;
        }
        field(7; "Last Name"; Text[50])
        {
            Caption = 'Last Name';
            DataClassification = ToBeClassified;
        }
        field(8; Reason; Text[100])
        {
            Caption = 'Reason';
            DataClassification = ToBeClassified;
        }
        field(9; "Single Party/Multiple/Business"; Option)
        {
            OptionCaption = 'Single,Group,Corporate,Cell,Joint';
            OptionMembers = Single,Group,Business,Cell,Joint;
        }
        field(10; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(11; "Status"; Option)
        {
            Editable = false;
            OptionMembers = Open,Converted;
        }
        field(12; "Date Created"; date)
        {
            Editable = false;
        }
        field(13; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(14; "MemberShip App No."; Code[30])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Member Application"."No." where("ID No." = field("ID No.")));
        }
        field(15; "Converted To Member"; Boolean)
        {

        }
        field(16; Nationality; Code[20])
        {
            TableRelation = "Country/Region";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if CountryRegion.Get(Nationality) then
                    "Mobile Phone No." := CountryRegion."EU Country/Region Code";
                Nationality := UpperCase(Nationality);
            end;
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
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Waiting Bay Nos.");
            NoSeriesMgt.InitSeries(SeriesSetup."Waiting Bay Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        "Date Created" := Today;
        "Created By" := UserId;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CountryRegion: Record "Country/Region";
        NewMob: code[20];
}
