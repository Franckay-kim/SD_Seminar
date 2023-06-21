table 51532180 "CRM Application"
{


    fields
    {
        field(1; "No."; Code[50])
        {
            Editable = true;
        }
        field(2; "Application Form No."; Code[100])
        {
            Editable = true;
        }
        field(3; "Captured By"; Code[100])
        {
            Editable = true;
        }
        field(4; Date; DateTime)
        {
            Editable = true;
            Enabled = true;
        }
        field(5; "Member No."; Code[100])
        {
            Editable = true;

            trigger OnValidate()
            begin
                if Members.Get("Member No.") then begin
                    "Member Name" := Members.Name;
                    "Member No." := Members."No.";
                    "Member Segment" := Members."Member Station";
                    "ID No." := Members."ID No.";
                    Gender := Members.Gender;
                    "Date of Birth" := Members."Date of Birth";
                    "P.I.N Number" := Members."P.I.N Number";
                end;
            end;
        }
        field(7; Created; Boolean)
        {
            Editable = false;
        }
        field(8; "Application Type"; Option)
        {
            OptionCaption = ' ,Membership,Loan Application,Savings Account,Refund Sheet,Withdrawal Application,BBF Application,Loan Variation Application,Share Variation Application,Inst. Capital Transfer,Re-admission/Activation,Member Details Editing,Guarantor Substitution';
            OptionMembers = " ",Membership,"Loan Application","Savings Account","Refund Sheet","Withdrawal Application","BBF Application","Loan Variation Application","Share Variation Application","Inst. Capital Transfer","Re-admission/Activation","Member Details Editing","Guarantor Substitution";
        }
        field(9; "Member Name"; Code[100])
        {
        }
        field(10; Time; Time)
        {
        }
        field(11; Source; Option)
        {
            OptionMembers = BOSA,FOSA,INVESTMENT,MICRO;
        }
        field(12; "Product Factory"; Code[100])
        {
            Caption = 'Product Factory';
            Editable = true;
            TableRelation = "Product Factory";
        }
        field(13; "Payroll No."; Code[100])
        {
        }
        field(14; "ID No."; Code[100])
        {
        }
        field(15; "Certificate No."; Code[100])
        {
        }
        field(16; "Amount On"; Decimal)
        {
        }
        field(17; "Closure Type"; Option)
        {
            OptionCaption = 'Normal,Retirement,Business loans,Risk';
            OptionMembers = Normal,Retirement,"Business loans",Risk;
        }
        field(18; "Buyer No."; Code[100])
        {
        }
        field(19; "Buyer ID No."; Code[100])
        {
        }
        field(20; Adviced; Boolean)
        {

            trigger OnValidate()
            begin

                "Date Adviced" := Today;
                "Time Adviced" := Time;
                "Adviced By" := UserId;
                Modify;
            end;
        }
        field(21; "Date Adviced"; Date)
        {
        }
        field(22; "Time Adviced"; Time)
        {
        }
        field(23; "Adviced By"; Code[100])
        {
        }
        field(24; "Modification Type"; Option)
        {
            OptionCaption = 'Member Details,BBF Details';
            OptionMembers = "Member Details","BBF Details";
        }
        field(25; "Shedule Type"; Option)
        {
            OptionCaption = 'Normal Transfer,Institutional Capital Transfer';
            OptionMembers = "Normal Transfer","Institutional Capital Transfer";
        }
        field(26; "In coming Guarantor No."; Code[100])
        {
        }
        field(27; "Replaced Guarantor No."; Code[100])
        {
        }
        field(28; "Temp. Name"; Code[100])
        {
        }
        field(29; Case360_Docs; Integer)
        {
        }
        field(30; "User ID"; Code[80])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(31; "Approval Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved,Rejected,Deffered';
            OptionMembers = Open,Pending,Approved,Rejected,Deffered;
        }
        field(32; "Loan status"; Option)
        {
            FieldClass = Normal;
            OptionCaption = 'Application,Appraisal,Rejected,Approved,Issued,Deffered';
            OptionMembers = Application,Appraisal,Rejected,Approved,Issued,Deffered;
        }
        field(33; "Requested Amount"; Decimal)
        {
        }
        field(34; "Amount Off"; Decimal)
        {
        }
        field(35; "First Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                "Member Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(36; "Second Name"; Text[30])
        {

            trigger OnValidate()
            begin
                "Second Name" := DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9');
                "Member Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(37; "Last Name"; Text[30])
        {

            trigger OnValidate()
            begin
                "Last Name" := DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
                "Member Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(38; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(39; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(40; "Customer Type"; Option)
        {
            OptionCaption = ' ,Member,Account,MicroFinance';
            OptionMembers = " ",Member,Account,MicroFinance;
        }
        field(41; "Employer Code"; Code[20])
        {
            //TableRelation = Customer WHERE("Account Type" = CONST(Employer));

            trigger OnValidate()
            begin
                if Customer.Get("Employer Code") then begin
                    "Employer Name" := Customer.Name;
                end;
            end;
        }
        field(42; "Date of Birth"; Date)
        {

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date of Birth" > Today then
                    Error(DateofBirthError);

                GeneralSetUp.Get;
                if "Date of Birth" > CalcDate(GeneralSetUp."Min. Member Age", Today) then
                    Error(MinimumAgeError, CalcDate(GeneralSetUp."Min. Member Age", Today));
            end;
        }
        field(43; "E-Mail"; Text[50])
        {

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                //SMTPMail.CheckValidEmailAddresses("E-Mail");
            end;
        }
        field(44; "Station/Department"; Code[20])
        {
            TableRelation = Customer;
        }
        field(45; Nationality; Code[20])
        {
            TableRelation = "Country/Region";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                //IF CountryRegion.GET(Nationality) THEN
                // "Mobile Phone No":=CountryRegion."County Phone Code";
            end;
        }
        field(46; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(47; Occupation; Text[30])
        {
        }
        field(48; Designation; Text[30])
        {
        }
        field(49; "Terms of Employment"; Option)
        {
            OptionMembers = " ",Permanent,Contract,Casual;
        }
        field(50; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
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
        field(51; City; Text[30])
        {
            Caption = 'City';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(52; "Responsibility Center"; Code[20])
        {
            Description = 'LookUp to Responsibility Center BR';
            TableRelation = "Responsibility CenterBR";
        }
        field(53; County; Text[30])
        {
            Caption = 'County';
            Description = 'LookUp to Member Segment Table where Type = County';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
        }
        field(54; "Bank Code"; Code[20])
        {
            Description = 'LookUp to Banks Table';
            TableRelation = "Bank Code Structure";
        }
        field(55; "Branch Code"; Code[20])
        {
            Description = 'LookUp to Banks Table';
            TableRelation = "Bank Code Structure"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
        }
        field(56; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(57; "Member Segment"; Code[20])
        {
            Description = 'LookUp to Member Segment Table where Type = Segment';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));
        }
        field(58; "Type of Business"; Option)
        {
            OptionCaption = ' ,Sole Proprietor,Partnership,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor",Partnership,"Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
        }
        field(59; "Other Business Type"; Text[15])
        {
        }
        field(60; "Ownership Type"; Option)
        {
            OptionCaption = ' ,Personal Account,Joint Account,Group/Business,FOSA Shares';
            OptionMembers = " ","Personal Account","Joint Account","Group/Business","FOSA Shares";
        }
        field(61; "Other Account Type"; Text[15])
        {
        }
        field(62; "Nature of Business"; Text[30])
        {
        }
        field(63; "Bank Account No."; Code[20])
        {
        }
        field(64; "Company Registration No."; Code[20])
        {

            trigger OnValidate()
            begin
                /*IF "Company Registration No." <>'' THEN BEGIN
                Cust.RESET;
                Cust.SETRANGE(Cust."Company Registration No.","Company Registration No.");
                IF Cust.FINDFIRST THEN
                 ERROR(MemberExistError,Cust."No.",Cust.Name);
                END;
                */

            end;
        }
        field(65; "Date of Business Reg."; Date)
        {

            trigger OnValidate()
            begin
                if "Date of Business Reg." > Today then
                    Error(DateofBirthError);
            end;
        }
        field(66; "Business/Group Location"; Text[50])
        {
        }
        field(67; "P.I.N Number"; Code[20])
        {

            trigger OnValidate()
            begin
                //FieldLength("ID No.",15);

                if "P.I.N Number" <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."P.I.N Number", "P.I.N Number");
                    if Cust.FindFirst then
                        Error(MemberExistError, Cust."No.", Cust.Name);
                end;
            end;
        }
        field(68; "Plot/Bldg/Street/Road"; Text[50])
        {
        }
        field(69; "Group Type"; Option)
        {
            OptionCaption = ' ,Welfare,Microfinance';
            OptionMembers = " ",Welfare,Microfinance;
        }
        field(70; "Single Party/Multiple/Business"; Option)
        {
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = Single,Multiple,Business;
        }
        field(71; "Birth Certificate No."; Code[15])
        {
        }
        field(72; "Group Account No."; Code[20])
        {
            Description = 'LookUp to Member where Group Account = Yes';
            TableRelation = Members WHERE("Group Account" = FILTER(true));
        }
        field(73; "Electrol Zone"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Electral Zone"));
        }
        field(74; "Area Service Center"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Area Service Centers"));
        }
        field(75; Type; Option)
        {
            OptionCaption = ' ,From Other Sacco';
            OptionMembers = " ","From Other Sacco";
        }
        field(76; "Dividend Payment Method"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST("Dividend Payment Type"));
        }
        field(77; "Old Member No."; Code[20])
        {
        }
        field(78; "Employer Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        MinimumAgeError: Label 'Date of birth must be less than %1';
        UserSet: Record "User Setup";
        Cust: Record Members;
        StrTel: Text[30];
        PostCode: Record "Post Code";
        ProductFactory: Record "Product Factory";
        AutoOpenSavingAccs: Record "Savings Account Registration";
        GeneralSetUp: Record "General Set-Up";
        CountryRegion: Record "Country/Region";
        //SMTPMail: Codeunit "SMTP Mail";
        Customer: Record Customer;
        MemberApplication: Record "Member Application";
        MemberCategory: Record "Member Category";
        ApplicationDocuments: Record "Application Documents";
        DateofBirthError: Label 'Date cannot be greater than today.';
        MemberExistError: Label 'Already exists with member %1 Name: %2';
        BankAccountErr: Label 'Bank Account No cannot be more then 14 characters.';
        Members: Record Members;
}

