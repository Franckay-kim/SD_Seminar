/// <summary>
/// Table HR Online Recruit Profiles (ID 51533461).
/// </summary>
table 51533461 "HR Online Recruit Profiles"
{
    Caption = 'HR Online Recruit Profiles';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Online Application No."; Code[50])
        {
            Caption = 'Online Application No.';
        }
        field(2; "First Name"; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "First Name" := UpperCase(DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9'));
                fn_FullName;
            end;
        }
        field(3; "Middle Name"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Middle Name" := UpperCase(DelChr("Middle Name", '=', '0|1|2|3|4|5|6|7|8|9'));
                fn_FullName;
            end;
        }
        field(4; "Last Names"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Last Names" := UpperCase(DelChr("Last Names", '=', '0|1|2|3|4|5|6|7|8|9'));
                fn_FullName;
            end;
        }
        field(5; Initials; Text[15])
        {
            Caption = 'Initials';
            DataClassification = ToBeClassified;
        }
        field(6; "Search Name"; Text[50])
        {
            Caption = 'Search Name';
            DataClassification = ToBeClassified;
        }
        field(7; "Postal Address"; Text[250])
        {
            Caption = 'Postal Address';
            DataClassification = ToBeClassified;
        }
        field(8; "Residential Add (Street No)"; Text[50])
        {
            Caption = 'Residential Add (Street No)';
            DataClassification = ToBeClassified;
        }
        field(9; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(10; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
        }
        field(11; County; Text[30])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
        }
        field(12; "Home Phone Number"; Text[30])
        {
            Caption = 'Home Phone Number';
            DataClassification = ToBeClassified;
        }
        field(13; "Cell Phone Number"; Text[30])
        {
            Caption = 'Cell Phone Number';
            DataClassification = ToBeClassified;
        }
        field(14; "Work Phone Number"; Text[30])
        {
            Caption = 'Work Phone Number';
            DataClassification = ToBeClassified;
        }
        field(15; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
        }
        field(16; Picture; Blob)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
        }
        field(17; "ID Number"; Text[30])
        {
            Caption = 'ID Number';
            DataClassification = ToBeClassified;
        }
        field(18; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(19; "Country Code"; Code[60])
        {
            Caption = 'Country Code';
            DataClassification = ToBeClassified;
        }
        field(20; Status; Option)
        {
            OptionCaption = ' ,Normal,Resigned,Discharged,Retrenched,Pension,Disabled,Submitted';
            OptionMembers = " ",Normal,Resigned,Discharged,Retrenched,Pension,Disabled,Submitted;
        }
        field(21; Comment; Boolean)
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        }
        field(22; "Marital Status"; Option)
        {
            OptionCaption = ' ,Single,Married,Separated,Divorced,Widow,Other';
            OptionMembers = " ",Single,Married,Separated,Divorced,Widow,Other;
        }
        field(23; "Ethnic Origin"; Option)
        {
            OptionCaption = ' ,African,Indian,White,Coloured';
            OptionMembers = " ",African,Indian,White,Coloured;
        }
        field(24; "First Language (R/W/S)"; Code[20])
        {
            Caption = 'First Language (R/W/S)';
            DataClassification = ToBeClassified;
        }
        field(25; "Driving Licence"; Code[20])
        {
            Caption = 'Driving Licence';
            DataClassification = ToBeClassified;
        }
        field(26; Disabled; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(27; "Date Of Birth"; Date)
        {
            Caption = 'Date Of Birth';
            DataClassification = ToBeClassified;
        }
        field(28; Age; Text[80])
        {
            Caption = 'Age';
            DataClassification = ToBeClassified;
        }
        field(29; "Second Language (R/W/S)"; Code[10])
        {
            Caption = 'Second Language (R/W/S)';
            DataClassification = ToBeClassified;
        }
        field(30; "Additional Language"; Code[30])
        {
            Caption = 'Additional Language';
            DataClassification = ToBeClassified;
        }
        field(31; "Primary Skills Category"; Option)
        {
            OptionCaption = ' ,Auditors,Consultants,Training,Certification,Administration,Marketing,Management,Business Development,Other';
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(32; "Postal Address2"; Text[200])
        {
            Caption = 'Postal Address2';
            DataClassification = ToBeClassified;
        }
        field(33; "Residential Add (District)"; Text[50])
        {
            Caption = 'Residential Add (District)';
            DataClassification = ToBeClassified;
        }
        field(34; "Residential Add (City)"; Text[50])
        {
            Caption = 'Residential Add (City)';
            DataClassification = ToBeClassified;
        }
        field(35; "Post Code2"; Code[20])
        {
            Caption = 'Post Code2';
            DataClassification = ToBeClassified;
        }
        field(36; Citizenship; Code[60])
        {
            Caption = 'Citizenship';
            DataClassification = ToBeClassified;
        }
        field(37; "Disabling Details"; Text[50])
        {
            Caption = 'Disabling Details';
            DataClassification = ToBeClassified;
        }
        field(38; "Disability Grade"; Text[30])
        {
            Caption = 'Disability Grade';
            DataClassification = ToBeClassified;
        }
        field(39; "Passport Number"; Text[30])
        {
            Caption = 'Passport Number';
            DataClassification = ToBeClassified;
        }
        field(40; "First Language Read"; Boolean)
        {
            Caption = 'First Language Read';
            DataClassification = ToBeClassified;
        }
        field(41; "First Language Write"; Boolean)
        {
            Caption = 'First Language Write';
            DataClassification = ToBeClassified;
        }
        field(42; "First Language Speak"; Boolean)
        {
            Caption = 'First Language Speak';
            DataClassification = ToBeClassified;
        }
        field(43; "Second Language Read"; Boolean)
        {
            Caption = 'Second Language Read';
            DataClassification = ToBeClassified;
        }
        field(44; "Second Language Write"; Boolean)
        {
            Caption = 'Second Language Write';
            DataClassification = ToBeClassified;
        }
        field(45; "Second Language Speak"; Boolean)
        {
            Caption = 'Second Language Speak';
            DataClassification = ToBeClassified;
        }
        field(46; "PIN Number"; Code[20])
        {
            Caption = 'PIN Number';
            DataClassification = ToBeClassified;
        }
        field(47; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(48; "Applicant Type"; Option)
        {
            OptionCaption = ' ,External,Internal';
            OptionMembers = " ",External,"Internal";
        }
        field(49; "Date Applied"; Date)
        {
            Caption = 'Date Applied';
            DataClassification = ToBeClassified;
        }
        field(50; "Citizenship Details"; Text[60])
        {
            Caption = 'Citizenship Details';
            DataClassification = ToBeClassified;
        }
        field(51; Expatriate; Boolean)
        {
            Caption = 'Expatriate';
            DataClassification = ToBeClassified;
        }
        field(52; "Full Name"; Text[100])
        {
            Caption = 'Full Name';
            DataClassification = ToBeClassified;
        }
        field(53; "Application Status"; Option)
        {
            OptionCaption = ' ,New,In Process,Rejected,To be Hired,Hired,On Hold,Recommended for Different Position,Offer Rejected,Submitted';
            OptionMembers = " ",New,"In Process",Rejected,"To be Hired",Hired,"On Hold","Recommended for Different Position","Offer Rejected",Submitted;
        }
        field(54; "Basic Salary"; Decimal)
        {
            Caption = 'Basic Salary';
            DataClassification = ToBeClassified;
        }
        field(55; Title; Option)
        {
            OptionCaption = ' ,Mr.,Mrs.,Ms.,Dr.,Prof';
            OptionMembers = " ","Mr.","Mrs.","Ms.","Dr.",Prof;
        }
        field(56; "Asking Basic Pay"; Decimal)
        {
            Caption = 'Asking Basic Pay';
            DataClassification = ToBeClassified;
        }
        field(57; "Related to any staff member"; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(58; "Do you have Disability certifi"; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(59; "Disability Certificate No"; Text[30])
        {
            Caption = 'Disability Certificate No';
            DataClassification = ToBeClassified;
        }
        field(60; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = ToBeClassified;
        }
        field(61; MyRecId; RecordId)
        {
            Caption = 'MyRecId';
            DataClassification = ToBeClassified;
        }
        field(62; "Passport No"; Code[50])
        {
            Caption = 'Passport No';
            DataClassification = ToBeClassified;
        }
        field(63; "Asking Salary Currency"; Code[10])
        {
            Caption = 'Asking Salary Currency';
            DataClassification = ToBeClassified;
        }
        field(64; "Current Salary Currency"; Code[10])
        {
            Caption = 'Current Salary Currency';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Online Application No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Online Application No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Online Job Profile Nos");
            NoSeriesMgt.InitSeries(HRSetup."Online Job Profile Nos", xRec."No. Series", 0D, "Online Application No.", "No. Series");
        end;

    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure fn_FullName()
    begin
        "Full Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Middle Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Names", '=', '0|1|2|3|4|5|6|7|8|9');
        "Full Name" := UpperCase("Full Name");
    end;
}
