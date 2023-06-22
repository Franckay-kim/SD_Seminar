/// <summary>
/// Table Member Application (ID 51532017).
/// </summary>
table 51532017 "Member Application"
{


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    CASE "Customer Type" of
                        "Customer Type"::Single:
                            NoSeriesMgt.TestManual(SeriesSetup."Member Application Nos.");
                        "Customer Type"::"Group":
                            NoSeriesMgt.TestManual(SeriesSetup."Group Application Nos.");
                        "Customer Type"::Joint:
                            NoSeriesMgt.TestManual(SeriesSetup."Joint Application Nos.");
                    END;

                    "No. Series" := '';
                    "No." := UpperCase("No.");
                end;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := UpperCase(Name);
                "Name" := UpperCase(Name);
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(5; "Current Address"; Text[50])
        {
            trigger OnValidate()

            begin
                "Current Address" := UpperCase("Current Address");
            end;
        }
        field(6; "Home Address"; Text[50])
        {
            Caption = 'Home Address';
            trigger OnValidate()

            begin
                "Home Address" := UpperCase("Home Address");
            end;
        }
        field(7; "Alternative Phone No. 1"; Text[13])
        {
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            begin
                "Alternative Phone No. 1" := DelChr("Alternative Phone No. 1", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');
                "Alternative Phone No. 1" := UpperCase("Alternative Phone No. 1");
            end;
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()

            begin
                "Global Dimension 1 Code" := UpperCase("Global Dimension 1 Code");
            end;
        }
        field(9; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            // Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()

            begin
                "Global Dimension 2 Code" := UpperCase("Global Dimension 2 Code");
            end;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            trigger OnValidate()

            begin
                "Currency Code" := UpperCase("Currency Code");
            end;
        }
        field(11; "Second Name"; Text[30])
        {

            trigger OnValidate()
            begin
                "Second Name" := DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Other Names", '=', '0|1|2|3|4|5|6|7|8|9');
                "Second Name" := UpperCase("Second Name");
                Name := UpperCase(Name);
            end;
        }
        field(12; "Other Names"; Text[30])
        {

            trigger OnValidate()
            begin
                "Other Names" := DelChr("Other Names", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Other Names", '=', '0|1|2|3|4|5|6|7|8|9');
                "Other Names" := UpperCase("Other Names");
                Name := UpperCase(Name);
            end;
        }
        field(13; "Customer Type"; Option)
        {
            OptionCaption = ' ,Single,Joint,Group,Microfinance,Cell';
            OptionMembers = " ",Single,Joint,Group,Microfinance,Cell;

            trigger OnValidate()
            begin

                // IF "Group Account" THEN BEGIN
                //  IF "Customer Type"="Customer Type"::Single THEN
                //    ERROR('Invalid Option For Group Accounts');
                // END;
            end;
        }
        field(14; "Application Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Application Date" > Today then
                    Error(DateofBirthError);
            end;
        }
        field(15; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected,Created';
            OptionMembers = Open,Pending,Approved,Rejected,Created;
        }
        field(16; "Employer Code"; Code[20])
        {
            //TableRelation = Customer WHERE("Account Type" = CONST(Employer));

            trigger OnValidate()
            begin

                /* if Customer.Get("Employer Code") then begin
                     "Employer Name" := Uppercase(Customer.Name);
                     "Self Employed" := Customer."Self Employed";
                     Diocese := Customer.Diocese;
                 end else begin
                     "Employer Name" := '';
                 end;
                 "Employer Code" := UpperCase("Employer Code"); */
            end;
        }
        field(17; "Date of Birth"; Date)
        {

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date of Birth" > Today then
                    Error(DateofBirthError);

                GeneralSetUp.Get;
                if CalcDate(GeneralSetUp."Min. Member Age", "Date of Birth") > Today then
                    Error(MinimumAgeError, GeneralSetUp."Min. Member Age");


                if "Tax Exempted" = true then begin
                    if (CalcDate(GeneralSetUp."Max. Member Age - Disabled", "Date of Birth")) < Today
                      then
                        Error('The member age of %1 is exceeded', GeneralSetUp."Max. Member Age - Disabled");
                end else begin
                    if (CalcDate(GeneralSetUp."Max. Member Age", "Date of Birth")) < Today
                    then
                        Error('The member age of %1 is exceeded', GeneralSetUp."Max. Member Age");
                end;
            end;
        }
        field(18; "E-Mail"; Text[50])
        {

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "E-Mail" <> '' then
                    MailManagement.CheckValidEmailAddresses("E-Mail");
                "E-Mail" := LowerCase("E-Mail");
            end;
        }
        field(19; "Station/Department"; Code[20])
        {
            TableRelation = Customer;
            trigger OnValidate()

            begin
                "Station/Department" := UpperCase("Station/Department");

            end;
        }
        field(23; Nationality; Code[20])
        {
            TableRelation = "Country/Region";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if CountryRegion.Get(Nationality) then
                    "Mobile Phone No" := CountryRegion."EU Country/Region Code";
                Nationality := UpperCase(Nationality);
            end;
        }
        field(24; "Payroll/Staff No."; Code[20])
        {

            trigger OnValidate()
            begin
                if "Payroll/Staff No." <> '' then begin

                    MemberApplication.Reset;
                    MemberApplication.SETFILTER("Employer Code", "Employer Code");
                    MemberApplication.SetFilter("Payroll/Staff No.", "Payroll/Staff No.");
                    MemberApplication.SetFilter("No.", '<>%1', memberApplication."No.");
                    if MemberApplication.FindFirst then
                        if (MemberApplication.Status in [MemberApplication.Status::Open, MemberApplication.Status::Pending, MemberApplication.Status::Approved]) then
                            Error(MemberExistError, MemberApplication."No.", MemberApplication.Name);


                    Cust.Reset;
                    Cust.SETRANGE(Cust."Employer Code", "Employer Code");
                    Cust.SetRange(Cust."Payroll/Staff No.", "Payroll/Staff No.");
                    if Cust.FindFirst then
                        Error(MemberExistError, Cust."No.", Cust.Name);
                    "Payroll/Staff No." := UpperCase("Payroll/Staff No.");
                end;
            end;
        }
        field(25; "ID No."; Code[20])
        {

            trigger OnValidate()
            var
                NOKA: Record "Next of KIN Application";
                Entr: Integer;
                NOK: Record "Next of KIN";
            begin
                "ID No." := UpperCase("ID No.");
                if "ID Type" = "ID Type"::"National ID" then begin

                    if "ID No." <> DelChr("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_') then
                        Error('Invalide ID No.');

                    //FieldLength("ID No.",8);

                    GeneralSetUp.Get;
                    GeneralSetUp.TestField("ID Character Limit");
                    if "Customer Type" <> "Customer Type"::Joint then
                        if StrLen("ID No.") > GeneralSetUp."ID Character Limit" then
                            Error('ID Number must be less than or equal to %1 digits', GeneralSetUp."ID Character Limit");
                end;
                if "ID Type" = "ID Type"::Passport then begin
                    "Passport No." := "ID No.";
                    "ID No." := '';

                end;

                if "ID No." <> '' then begin

                    MemberApplication.Reset;
                    MemberApplication.SetRange(MemberApplication."ID No.", "ID No.");
                    MemberApplication.SetFilter(MemberApplication.Status, '%1', MemberApplication.Status::Open);
                    if MemberApplication.Find('-') then begin
                        repeat
                            if (MemberApplication.Status in [MemberApplication.Status::Open, MemberApplication.Status::Pending,
                                                             MemberApplication.Status::Approved]) then
                                Error(MemberExistError, MemberApplication."No.", MemberApplication.Name);
                        until MemberApplication.Next = 0;
                    end;

                    // Cust.RESET;
                    // Cust.SETRANGE(Cust."ID No.","ID No.");
                    // Cust.SETFILTER(Cust.Status,'<>%1',Cust.Status::Closed);
                    // IF "Customer Type"<>"Customer Type"::Joint THEN
                    // IF Cust.FINDFIRST THEN
                    //  BEGIN
                    //    ERROR(MemberExistError,Cust."No.",Cust.Name);
                    //    {
                    //    IF Cust.Status<>Cust.Status::Closed THEN
                    //        ERROR(MemberExistError,Cust."No.",Cust.Name) ELSE
                    //      BEGIN
                    //        SavingsAccounts.RESET;
                    //        SavingsAccounts.SETRANGE("Member No.",Cust."No.");
                    //        SavingsAccounts.SETRANGE(SavingsAccounts."Product Category",SavingsAccounts."Product Category"::"Share Capital");
                    //        IF SavingsAccounts.FIND('-') THEN
                    //          BEGIN
                    //            SavingsAccounts.CALCFIELDS("Balance (LCY)");
                    //            IF SavingsAccounts."Balance (LCY)">0 THEN
                    //              ERROR ('The Member No.: %1 has Share Capital at account %2 of %3',Cust."No.",SavingsAccounts."No.",SavingsAccounts."Balance (LCY)");
                    //            END;
                    //        END;
                    //        }
                    //    END;
                end;
                if "ID No." <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."ID No.", "ID No.");
                    if Cust.FindFirst then begin
                        Error(MemberExistError, Cust."No.", Cust.Name);
                        /*if not Confirm('Is this member rejoining?') then
                            Error(MemberExistError, Cust."No.", Cust.Name)
                        else
                            GeneralSetUp.Get();
                        Type := Type::Rejoining;

                        AutoOpenSavingAccs.Reset;
                        AutoOpenSavingAccs.SetRange(AutoOpenSavingAccs."No.", Rec."No.");
                        AutoOpenSavingAccs.SetRange("Product Category", AutoOpenSavingAccs."Product Category"::"Registration Fee");
                        if AutoOpenSavingAccs.Find('-') then begin
                            AutoOpenSavingAccs."Monthly Contribution" := GeneralSetUp."Rejoining Fee"; //MESSAGE('Bal %1',AutoOpenSavingAccs."Monthly Contribution");
                            AutoOpenSavingAccs.Modify;
                        end;
                        "Associated Member No." := Cust."No.";
                        "Customer Type" := Cust."Customer Type";
                        Type := Type::Rejoining;
                        "First Name" := Cust."First Name";
                        "Second Name" := Cust."Second Name";
                        "Other Names" := Cust."Last Name";
                        Name := Cust.Name;
                        "ID No." := Cust."ID No.";
                        "Passport No." := Cust."Passport No.";
                        County := Cust.County;
                        "Mobile Phone No" := Cust."Mobile Phone No";
                        "Current Address" := Cust."Current Address";
                        "Home Address" := Cust."Home Address";
                        "Post Code" := Cust."Post Code";
                        City := Cust.City;
                        "Sub Location" := Cust."Sub Location";
                        Location := Cust.Location;
                        Division := Cust.Division;
                        District := Cust.District;
                        County := Cust.County;
                        "Recruited by Type" := Cust."Recruited by Type";
                        "Relationship Manager" := Cust."Relationship Manager";
                        Nationality := Cust.Nationality;
                        "Date of Birth" := Cust."Date of Birth";
                        "Birth Certificate No." := Cust."Birth Certificate No.";
                        "Marital Status" := Cust."Marital Status";
                        "Member Category" := Cust."Member Category";
                        //"Electrol Zone":=Cust."Electrol Zone";
                        //"Area Service Center":=Cust."Area Service Center";
                        "Responsibility Center" := Cust."Responsibility Center";
                        "Employer Code" := Cust."Employer Code";
                        "Home Address" := Cust."Home Address";
                        "Payroll/Staff No." := Cust."Payroll/Staff No.";
                        "Recruited By" := Cust."Recruited By";
                        "Marital Status" := Cust."Marital Status";
                        Gender := Cust.Gender;
                        "Dividend Payment Method" := Cust."Dividend Payment Method";
                        "Type of Business" := Cust."Type of Business";
                        "Other Business Type" := Cust."Other Business Type";
                        "Ownership Type" := Cust."Ownership Type";
                        "Other Account Type" := Cust."Other Account Type";
                        "Nature of Business" := Cust."Nature of Business";
                        "Company Registration No." := Cust."Company Registration No.";
                        "Date of Business Reg." := Cust."Date of Business Reg.";
                        "Business/Group Location" := Cust."Business/Group Location";
                        "Plot/Bldg/Street/Road" := Cust."Plot/Bldg/Street/Road";
                        "Group Account" := Cust."Group Account";
                        "Group Type" := Cust."Group Type";
                        "Group Account No." := Cust."Group Code";
                        "Bank Code" := Cust."Bank Code";
                        "Bank Account No." := Cust."Bank Account No.";
                        "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                        "Global Dimension 2 Code" := Cust."Global Dimension 2 Code";
                        "Tax Exempted" := Cust."Tax Exempted";
                        "Created By" := UserId;//Cust."Created By";
                        "E-Mail" := Cust."E-Mail";




                        NOKA.Reset;
                        if NOKA.FindLast then
                            Entr := NOKA."Entry No.";

                        NOK.Reset;
                        NOK.SetRange(NOK."Account No", Cust."No.");
                        if NOK.Find('-') then begin
                            repeat
                                NOKA.Init;
                                NOKA."Entry No." := NOK."Entry No."; //MESSAGE('en %1',NOKA."Entry No.");
                                NOKA."Account No" := "No.";
                                NOKA.Relationship := NOK.Relationship;
                                NOKA.Name := NOK.Name;
                                NOKA."Date of Birth" := NOK."Date of Birth";
                                NOKA."ID No./Birth Cert. No." := NOK."ID No.";
                                NOKA.Address := NOK.Address;
                                NOKA.Telephone := NOK.Telephone;
                                NOKA.Email := NOK.Email;
                                NOKA.Type := NOK.Type;
                                NOKA.Beneficiary := NOK.Beneficiary;
                                NOKA."%Allocation" := NOK."%Allocation";
                                NOKA.Insert;
                            until NOK.Next = 0;
                        end;
                        Cust."ID No." := '';
                        Cust."Mobile Phone No" := '';
                        Cust."P.I.N Number" := '';
                        Cust.Modify;*/
                    end;
                end;
            end;
        }
        field(26; "Mobile Phone No"; Code[13])
        {

            trigger OnValidate()
            begin
                TestField(Nationality);
                "Mobile Phone No" := UpperCase("Mobile Phone No");

                "Mobile Phone No" := DelChr("Mobile Phone No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');

                if "Mobile Phone No" <> '' then begin
                    if "customer type" = "Customer Type"::Single then begin
                        MemberApplication.Reset;
                        MemberApplication.SetRange(MemberApplication."Mobile Phone No", "Mobile Phone No");
                        MemberApplication.SetFilter(MemberApplication.Status, '%1', MemberApplication.Status::Open);
                        MemberApplication.SetRange("Single Party/Multiple/Business", "Single Party/Multiple/Business");
                        // MemberApplication.SetRange("Customer Type", "Customer Type"::Single);
                        if MemberApplication.Find('-') then begin
                            repeat
                                if (MemberApplication.Status in [MemberApplication.Status::Open, MemberApplication.Status::Pending,
                                                                 MemberApplication.Status::Approved]) then
                                    Error(MemberExistError, MemberApplication."No.", MemberApplication.Name);
                            until MemberApplication.Next = 0;
                        end;


                        Cust.Reset;
                        Cust.SetRange(Cust."Mobile Phone No", "Mobile Phone No");
                        //Cust.SetRange("Customer Type", "Customer Type"::Single);
                        Cust.SetFilter(Cust.Status, '<>%1', Cust.Status::Closed);
                        if Cust.FindFirst then
                            Error(MemberExistError, Cust."No.", Cust.Name);
                    end;
                end;
                CountryRegion.Get(Nationality);
                NewMob := '';
                NewMob := CopyStr("Mobile Phone No", 1, 4);
                if (CopyStr("Mobile Phone No", 1, 4)) <> (CountryRegion."EU Country/Region Code") then
                    Error('The Mobile phone No. should take the format of ' + CountryRegion."EU Country/Region Code");
                if StrLen("Mobile Phone No") <> 13 then
                    Error('Phone No. should be equal to 13 characters');
            end;

        }
        field(27; "Marital Status"; Option)
        {
            OptionCaption = ' ,Single,Married,Divorced,Widower,Widow';
            OptionMembers = " ",Single,Married,Devorced,Widower,Widow;
        }
        field(28; "Passport No."; Code[10])
        {

            trigger OnValidate()
            begin
                "Passport No." := UpperCase("Passport No.");
                if "Passport No." <> '' then begin

                    MemberApplication.Reset;
                    MemberApplication.SetRange(MemberApplication."Passport No.", "Passport No.");
                    MemberApplication.SetFilter(MemberApplication.Status, '%1', MemberApplication.Status::Open);
                    if MemberApplication.Find('-') then begin
                        repeat
                            if (MemberApplication.Status in [MemberApplication.Status::Open, MemberApplication.Status::Pending,
                                                             MemberApplication.Status::Approved]) then
                                Error(MemberExistError, MemberApplication."No.", MemberApplication.Name);
                        until MemberApplication.Next = 0;
                    end;

                    Cust.Reset;
                    Cust.SetRange(Cust."Passport No.", "Passport No.");
                    Cust.SetFilter(Cust.Status, '<>%1', Cust.Status::Closed);
                    if Cust.FindFirst then
                        Error(MemberExistError, Cust."No.", Cust.Name);
                end;
            end;
        }
        field(29; Gender; Option)
        {
            OptionCaption = '  ,Male,Female';
            OptionMembers = "  ",Male,Female;
        }
        field(30; "First Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "First Name" := UpperCase("First Name");
                AddDefaultAccounts();
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Other Names", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(33; "No. Series"; Code[10])
        {

        }
        field(34; Occupation; Text[30])
        {
            trigger OnValidate()

            begin
                Occupation := UpperCase(Occupation);
            end;
        }
        field(35; Designation; Text[30])
        {
            trigger OnValidate()

            begin
                Designation := UpperCase(Designation);
            end;
        }
        field(36; "Terms of Employment"; Option)
        {
            OptionMembers = " ",Permanent,Contract,Casual;
        }
        field(37; "Post Code"; Code[20])
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

                "Post Code" := UpperCase("Post Code");
                PostCode.ValidatePostCode(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(38; City; Text[30])
        {
            Caption = 'City';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            begin
                City := UpperCase(City);
                PostCode.ValidateCity(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(39; "Responsibility Center"; Code[20])
        {
            Description = 'LookUp to Responsibility Center BR';
            TableRelation = "Responsibility CenterBR";
            trigger OnValidate()

            begin
                "Responsibility Center" := UpperCase("Responsibility Center");
            end;
        }
        field(41; County; Text[30])
        {
            Caption = 'County';
            Description = 'LookUp to Member Segment Table where Type = County';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
            trigger OnValidate()

            begin
                County := UpperCase(County);
            end;
        }
        field(42; "Bank Code"; Code[20])
        {
            Description = 'LookUp to Banks Table';
            TableRelation = "PR Bank Accounts"."Bank Code";
            trigger OnValidate()

            begin
                "Bank Code" := UpperCase("Bank Code");
            end;
        }
        field(43; "Branch Code"; Code[20])
        {
            Description = 'LookUp to Banks Table';
            TableRelation = "PR Bank Branches"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
            trigger OnValidate()

            begin
                "Branch Code" := UpperCase("Branch Code");
            end;
        }
        field(44; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = IF ("Recruited by Type" = FILTER(Marketer)) "Salesperson/Purchaser".Code
            ELSE
            IF ("Recruited by Type" = FILTER(Staff)) "HR Employees"
            ELSE
            IF ("Recruited by Type" = FILTER("Board Member")) Members WHERE("Account Category" = FILTER("Board Members"))
            ELSE
            IF ("Recruited by Type" = FILTER(Member)) Members WHERE("Account Category" = FILTER(Member));

            trigger OnValidate()
            begin
                "Recruited By" := UpperCase("Recruited By");
                if "Recruited by Type" = "Recruited by Type"::Marketer then begin
                    SalespersonPurchaser.Reset;
                    SalespersonPurchaser.SetRange(Code, "Recruited By");
                    if SalespersonPurchaser.Find('-') then begin
                        "Recruited By Name" := Uppercase(SalespersonPurchaser.Name);
                    end;
                end else
                    if "Recruited by Type" = "Recruited by Type"::"Board Member" then begin
                        Members.Reset;
                        Members.SetRange("No.", "Recruited By");
                        if Members.Find('-') then begin
                            "Recruited By Name" := Uppercase(Members.Name);
                        end;
                    end else
                        if "Recruited by Type" = "Recruited by Type"::Staff then begin
                            HREmployees.Reset;
                            HREmployees.SetRange("No.", "Recruited By");
                            if HREmployees.Find('-') then begin
                                "Recruited By Name" := Uppercase(HREmployees."Full Name");
                                "Recruited By Staff No." := Uppercase(HREmployees."No.");
                            end;
                        end else
                            if "Recruited by Type" = "Recruited by Type"::Member then begin
                                Members.Reset;
                                Members.SetRange("No.", "Recruited By");
                                if Members.Find('-') then begin
                                    "Recruited By Name" := Uppercase(Members.Name);
                                    "Recruited By Staff No." := Uppercase(Members."Payroll/Staff No.");
                                end;
                            end else begin
                                //  HREmployees.RESET;
                                //  HREmployees.SETRANGE("No.","Recruited By");
                                //  IF HREmployees.FIND('-') THEN
                                //    BEGIN
                                "Recruited By Name" := Uppercase("Recruited By");
                                // END;
                            end;
            end;
        }
        field(46; "Member Station"; Code[20])
        {
            Caption = 'Current Residence';
            Description = 'LookUp to Member Segment Table where Type = Segment';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));

            trigger OnValidate()
            begin
                "Member Station" := UpperCase("Member Station");
                Segment.Reset;
                Segment.SetRange(Code, "Member Station");
                if Segment.FindFirst then
                    "Current Residence name" := Uppercase(Segment.Description);
            end;
        }
        field(47; "Type of Business"; Option)
        {
            OptionCaption = ' ,Sole Proprietor,Partnership,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor",Partnership,"Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
        }
        field(48; "Other Business Type"; Text[15])
        {
            trigger OnValidate()

            begin
                "Other Business Type" := UpperCase("Other Business Type");
            end;
        }
        field(49; "Ownership Type"; Option)
        {
            OptionCaption = ' ,Personal Account,Joint Account,Group/Business,FOSA Shares';
            OptionMembers = " ","Personal Account","Joint Account","Group/Business","FOSA Shares";
        }
        field(50; "Other Account Type"; Text[15])
        {
            trigger OnValidate()

            begin
                "Other Account Type" := UpperCase("Other Account Type");
            end;
        }
        field(51; "Nature of Business"; Text[30])
        {
            trigger OnValidate()

            begin
                "Nature of Business" := UpperCase("Nature of Business");
            end;
        }
        field(52; "Bank Account No."; Code[20])
        {

            trigger OnValidate()
            begin
                if StrLen("Bank Account No.") > 14 then
                    Error(BankAccountErr);
                "Bank Account No." := UpperCase("Bank Account No.");
            end;
        }
        field(53; "Company Registration No."; Code[20])
        {

            trigger OnValidate()
            begin
                "Company Registration No." := UpperCase("Company Registration No.");
                if "Company Registration No." <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."Company Registration No.", "Company Registration No.");
                    if Cust.FindFirst then
                        Error(MemberExistError, Cust."No.", Cust.Name);
                end;
            end;
        }
        field(54; "Date of Business Reg."; Date)
        {

            trigger OnValidate()
            begin
                if "Date of Business Reg." > Today then
                    Error(DateofBirthError);
            end;
        }
        field(55; "Business/Group Location"; Text[50])
        {
            trigger OnValidate()

            begin
                "Business/Group Location" := UpperCase("Business/Group Location");
            end;
        }
        field(56; "P.I.N Number"; Code[11])
        {

            trigger OnValidate()
            begin
                "P.I.N Number" := UpperCase("P.I.N Number");
                FieldLength("ID No.", 15);

                if "P.I.N Number" <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."P.I.N Number", "P.I.N Number");
                    if Cust.FindFirst then
                        Error(MemberExistError, Cust."No.", Cust.Name);
                end;
            end;
        }
        field(57; "Plot/Bldg/Street/Road"; Text[50])
        {
            trigger OnValidate()

            begin
                "Plot/Bldg/Street/Road" := UpperCase("Plot/Bldg/Street/Road");
            end;
        }
        field(58; "Group Type"; Option)
        {
            OptionCaption = ' ,Welfare,Church,Investment Club,Others';
            OptionMembers = " ",Welfare,Church,"Investment Club",Others;

        }
        field(59; "Single Party/Multiple/Business"; Option)
        {
            OptionCaption = 'Single,Group,Corporate,Cell,Joint';
            OptionMembers = Single,Group,Business,Cell,Joint;
        }
        field(60; "Birth Certificate No."; Code[15])
        {
            trigger OnValidate()

            begin
                "Birth Certificate No." := UpperCase("Birth Certificate No.");
            end;
        }
        field(61; "Group Account No."; Code[20])
        {
            Description = 'LookUp to Member where Group Account = Yes';
            TableRelation = Members WHERE("Customer Type" = CONST(Group));
            trigger OnValidate()

            begin
                "Group Account No." := UpperCase("Group Account No.");
            end;
        }
        field(62; "Created By"; Code[50])
        {
            trigger OnValidate()

            begin
                "Created By" := UpperCase("Created By");
            end;
        }
        field(63; Source; Option)
        {
            Description = 'Used to identify origin of Member Application [CRM, Navision, Web]';
            OptionCaption = ' ,Navision,CRM,Web,Agency';
            OptionMembers = " ",Navision,CRM,Web,Agency;
        }
        field(64; Picture; BLOB)
        {
            Caption = 'Picture';
            Description = 'Used to capture applicant Photos and should be deleted on account creation.';
            SubType = Bitmap;
            trigger OnValidate()

            begin
                if "Picture".Length() > (40 * 1024) then
                    Error('The image cannot exceed 40kb in size');
            end;
        }
        field(65; Signature; BLOB)
        {
            Caption = 'Signature';
            Description = 'Used to capture applicant Signature and should be deleted on account creation.';
            SubType = Bitmap;
            trigger OnValidate()

            begin
                if "Signature".Length() > (40 * 1024) then
                    Error('The image cannot exceed 40kb in size');
            end;
        }
        field(66; "Alternative Phone No. 2"; Code[13])
        {

            trigger OnValidate()
            begin
                "Alternative Phone No. 2" := UpperCase("Alternative Phone No. 2");
                if StrLen("Alternative Phone No. 2") > 13 then begin
                    "Alternative Phone No. 2" := '';
                    Modify;
                end;
            end;
        }
        field(67; "Group Account"; Boolean)
        {
        }
        field(68; "Recruited by Type"; Option)
        {
            OptionCaption = 'Marketer,Office,Staff,Board Member,Member,Agency Banking';
            OptionMembers = Marketer,Office,Staff,"Board Member",Member,"Agency Banking";

            trigger OnValidate()
            begin
                "Recruited By" := '';
                "Recruited By Name" := '';
                "Recruited By Staff No." := '';
            end;
        }
        field(69; "Employer Name"; Text[50])
        {
            trigger OnValidate()

            begin
                "Employer Name" := UpperCase("Employer Name");
            end;
        }
        field(70; "Member Category"; Code[10])
        {
            TableRelation = "Member Category"."No." WHERE("Premier Club Min.Deposits" = FILTER(0));

            trigger OnValidate()
            begin
                "Member category" := UpperCase("Member Category");
                MemberCategory.Reset;
                MemberCategory.SetRange("No.", "Member Category");
                if MemberCategory.Find('-') then begin
                    AutoOpenSavingAccs.Reset;
                    AutoOpenSavingAccs.SetRange("No.", "No.");
                    if AutoOpenSavingAccs.Find('-') then begin
                        repeat
                            if AutoOpenSavingAccs."Product Category" = AutoOpenSavingAccs."Product Category"::"Deposit Contribution" then
                                AutoOpenSavingAccs."Monthly Contribution" := MemberCategory."Monthly Share Deposit"
                            else
                                if AutoOpenSavingAccs."Product Category" = AutoOpenSavingAccs."Product Category"::"Share Capital" then
                                    AutoOpenSavingAccs."Monthly Contribution" := MemberCategory."Monthly Share Capital"
                                else
                                    if AutoOpenSavingAccs."Product Category" = AutoOpenSavingAccs."Product Category"::"Registration Fee" then
                                        AutoOpenSavingAccs."Monthly Contribution" := MemberCategory."Registration Fee";

                            if AutoOpenSavingAccs."Product Category" = AutoOpenSavingAccs."Product Category"::"Deposit Contribution" then
                                AutoOpenSavingAccs."Minimum Contribution" := MemberCategory."Monthly Share Deposit"
                            else
                                if AutoOpenSavingAccs."Product Category" = AutoOpenSavingAccs."Product Category"::"Share Capital" then
                                    AutoOpenSavingAccs."Minimum Contribution" := MemberCategory."Monthly Share Capital"
                                else
                                    if AutoOpenSavingAccs."Product Category" = AutoOpenSavingAccs."Product Category"::"Registration Fee" then
                                        AutoOpenSavingAccs."Minimum Contribution" := MemberCategory."Registration Fee";

                            AutoOpenSavingAccs.Modify;
                        until AutoOpenSavingAccs.Next = 0;
                    end;
                end;
            end;
        }
        field(71; "Relationship Manager"; Code[10])
        {
            TableRelation = "HR Employees" WHERE(Status = FILTER(Active));

            trigger OnValidate()

            begin
                "Relationship Manager" := UpperCase("Relationship Manager");
            end;
        }
        field(72; "Sketch Map"; BLOB)
        {
            Caption = 'Picture';
            Description = 'Used to capture applicant Photos and should be deleted on account creation.';
            SubType = Bitmap;
            trigger OnValidate()

            begin
                if "Sketch Map".Length() > (40 * 1024) then
                    Error('The image cannot exceed 40kb in size');
            end;
        }
        field(73; "Member Segment"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'LookUp to Member Segment Table where Type = Segment';
            trigger OnValidate()

            begin
                "Member Segment" := UpperCase("Member Segment");
            end;
        }
        field(156; "Agent Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "Agent Code" := UpperCase("Agent Code");
            end;
        }
        field(157; "Agent Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "Agent Doc No" := UpperCase("Agent Doc No");
            end;
        }
        field(158; "Sub Location"; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "Sub Location" := UpperCase("Sub Location");
            end;
        }
        field(159; Location; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "Location" := UpperCase("Location");
            end;

        }
        field(160; Division; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "Division" := UpperCase(Division);
            end;
        }
        field(161; District; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "District" := UpperCase(District);
            end;
        }
        field(50005; "Statement E-Mail Freq."; DateFormula)
        {
        }
        field(50055; "Member Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Catholic Faithful",Spouse,Child,"Catholic Institution";
            trigger OnValidate()
            begin
                "Catholic Faithful Refferee" := '';
            end;
        }
        field(50056; "Personal E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Personal E-mail" := LowerCase("Personal E-mail");
                if "Personal E-mail" <> '' then
                    MailManagement.CheckValidEmailAddresses("Personal E-mail");

            end;
        }
        field(50057; "Recruited By Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()

            begin
                "Recruited By Staff No." := UpperCase("Recruited By Staff No.");
            end;
        }
        field(39004242; Classification; Option)
        {
            OptionCaption = ' ,Good Standing,Bad Standing';
            OptionMembers = " ","Good Standing","Bad Standing";
        }
        field(39004243; "Society Code"; Code[20])
        {
            //TableRelation = Societies."No.";
            trigger OnValidate()

            begin
                "Society Code" := UpperCase("Society Code");
            end;
        }
        field(39004244; "Area Service Center"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Area Service Centers"));
            trigger OnValidate()

            begin
                "Area Service Center" := UpperCase("Area Service Center");
            end;
        }
        field(39004245; Type; Option)
        {
            OptionCaption = ' ,From Other Sacco,Rejoining';
            OptionMembers = " ","From Other Sacco",Rejoining;
        }
        field(39004246; "Dividend Payment Method"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST("Dividend Payment Type"));
            trigger OnValidate()

            begin
                "Dividend Payment Method" := UpperCase("Dividend Payment Method");
            end;
        }
        field(39004247; "Old Member No."; Code[20])
        {
            trigger OnValidate()

            begin
                "Old Member No." := UpperCase("Old Member No.");
            end;
        }
        field(39004248; "Associated Member No."; Code[20])
        {
            trigger OnValidate()

            begin
                "Associated Member No." := UpperCase("Associated Member No.");
            end;
        }
        field(39004249; "Virtual Member"; Boolean)
        {
        }
        field(39004250; "Tax Exempted"; Boolean)
        {
            Caption = 'Physically Challenged';
        }
        field(39004251; "CRM Application No."; Code[50])
        {
            Description = '//Look up 39004410';

            TableRelation = "CRM Application"."No." WHERE("Application Type" = CONST(Membership),
                                                           "Approval Status" = FILTER(Deffered | Open),
                                                           Created = CONST(false),
                                                           Case360_Docs = CONST(1));

            trigger OnValidate()
            begin
                "CRM Application No." := UpperCase("CRM Application No.");
                if CRMApplication.Get("CRM Application No.") then begin
                    //"Home Address":=CRMApplication."Home Address";
                    //"Phone No.":=CRMApplication."Phone No.";
                    "Global Dimension 1 Code" := UpperCase(CRMApplication."Global Dimension 1 Code");
                    "Global Dimension 2 Code" := UpperCase(CRMApplication."Global Dimension 2 Code");
                    //"Currency Code":=CRMApplication."Currency Code";
                    "Second Name" := UpperCase(CRMApplication."Second Name");
                    "Other Names" := UpperCase(CRMApplication."Last Name");
                    "Customer Type" := CRMApplication."Customer Type";
                    //"Application Date":=CRMApplication."Application Date";
                    //"Status":=CRMApplication."Status";
                    "Employer Code" := UpperCase(CRMApplication."Employer Code");
                    "Date of Birth" := CRMApplication."Date of Birth";
                    "E-Mail" := UpperCase(CRMApplication."E-Mail");
                    "Station/Department" := UpperCase(CRMApplication."Station/Department");
                    Nationality := UpperCase(CRMApplication.Nationality);
                    "Payroll/Staff No." := UpperCase(CRMApplication."Payroll No.");
                    "ID No." := UpperCase(CRMApplication."ID No.");
                    //"Mobile Phone No":=CRMApplication."Mobile Phone No";
                    //"Marital Status":=CRMApplication."Marital Status";
                    //"Passport No.":=CRMApplication."Passport No.";
                    Gender := CRMApplication.Gender;
                    "First Name" := UpperCase(CRMApplication."First Name");
                    Occupation := UpperCase(CRMApplication.Occupation);
                    Designation := UpperCase(CRMApplication.Designation);
                    "Terms of Employment" := CRMApplication."Terms of Employment";
                    "Post Code" := UpperCase(CRMApplication."Post Code");
                    City := UpperCase(CRMApplication.City);
                    //"Responsibility Center":=CRMApplication."Responsibility Cente"";
                    County := UpperCase(CRMApplication.County);
                    "Bank Code" := UpperCase(CRMApplication."Bank Code");
                    "Branch Code" := UpperCase(CRMApplication."Branch Code");
                    "Recruited By" := UpperCase(CRMApplication."Recruited By");
                    "Member Station" := UpperCase(CRMApplication."Member Segment");
                    "Type of Business" := CRMApplication."Type of Business";
                    "Other Business Type" := UpperCase(CRMApplication."Other Business Type");
                    "Ownership Type" := CRMApplication."Ownership Type";
                    "Other Account Type" := CRMApplication."Other Account Type";
                    "Nature of Business" := UpperCase(CRMApplication."Nature of Business");
                    "Bank Account No." := Uppercase(CRMApplication."Bank Account No.");
                    "Company Registration No." := UpperCase(CRMApplication."Company Registration No.");
                    "Date of Business Reg." := CRMApplication."Date of Business Reg.";
                    "Business/Group Location" := UpperCase(CRMApplication."Business/Group Location");
                    "P.I.N Number" := UpperCase(CRMApplication."P.I.N Number");
                    "Plot/Bldg/Street/Road" := UpperCase(CRMApplication."Plot/Bldg/Street/Road");
                    "Group Type" := CRMApplication."Group Type";
                    "Single Party/Multiple/Business" := CRMApplication."Single Party/Multiple/Business";
                    "Birth Certificate No." := UpperCase(CRMApplication."Birth Certificate No.");
                    "Group Account No." := UpperCase(CRMApplication."Group Account No.");
                    //"Created By":=CRMApplication."Created By";
                    Source := CRMApplication.Source;
                    //"Picture":=CRMApplication."Picture";
                    //"Signature":=CRMApplication."Signature";
                    //"Transaction Mobile No":=CRMApplication."Transaction Mobile No";
                    //"Group Account":=CRMApplication."Group Account";
                    //"Recruited by Type":=CRMApplication."Recruited by Type";
                    "Employer Name" := UpperCase(CRMApplication."Employer Name");
                    //"Member Category":=CRMApplication."Member Category";
                    //"Relationship Manager":=CRMApplication."Relationship Manager";
                    //"Statement E-Mail Freq.":=CRMApplication."Statement E-Mail Freq.";
                    //"Classification":=CRMApplication."Classification";
                    "Society Code" := UpperCase(CRMApplication."Electrol Zone");
                    "Area Service Center" := UpperCase(CRMApplication."Area Service Center");
                    Type := CRMApplication.Type;
                    "Dividend Payment Method" := UpperCase(CRMApplication."Dividend Payment Method");
                    "Old Member No." := UpperCase(CRMApplication."Old Member No.");
                    //"Associated Member No.":=CRMApplication."Associated Member No.";
                    //"Virtual Member":=CRMApplication."Virtual Member";
                    //"Tax Exempted":=CRMApplication."Tax Exempted";
                    //"CRM Application No.":=CRMApplication."CRM Application No.";
                end;
            end;
        }
        field(39004252; "Recruited By Name"; Text[100])
        {
            Editable = false;
            trigger OnValidate()

            begin
                "Recruited By Name" := UpperCase("Recruited By Name");
            end;
        }
        field(39004254; Salutation; Code[50])
        {
            Description = '39004358';
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
            trigger OnValidate()

            begin
                Salutation := UpperCase(Salutation);
            end;
        }
        field(39004255; "Electrol Zone Descr."; Text[100])
        {
            Editable = false;
            trigger OnValidate()

            begin
                "Electrol Zone Descr." := UpperCase("Electrol Zone Descr.");
            end;

        }
        field(39004257; "Nearest Land Mark"; Text[100])
        {
            trigger OnValidate()

            begin
                "Nearest Land Mark" := UpperCase("Nearest Land Mark");
            end;
        }
        field(39004258; "Buying Centre"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = FILTER("Buying Centre"));

            trigger OnValidate()
            begin
                "Buying Centre" := UpperCase("Buying Centre");
                BuyingCentre.Reset;
                BuyingCentre.SetRange(Code, "Buying Centre");
                if BuyingCentre.Find('-') then begin
                    "Buying Centre Name" := Format(BuyingCentre.Description, 50);
                end;
            end;
        }
        field(39004259; "Buying Centre Name"; Text[50])
        {
            Editable = false;
            trigger OnValidate()

            begin
                "Buying Centre Name" := UpperCase("Buying Centre Name");
            end;

        }
        field(39004260; "Account Category"; Option)
        {
            OptionCaption = 'Member,Staff Members,Board Members,Delegates,Non-Member,Minor';
            OptionMembers = Member,"Staff Members","Board Members",Delegates,"Non-Member",Minor;


            trigger OnValidate()
            begin
                AddDefaultAccounts;
            end;
        }
        field(39004261; "Read/Write"; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(39004262; "Appointment Date"; Date)
        {
            trigger Onvalidate()
            begin
                if "Appointment Date" > TODAY then
                    Error('Appointment date cannot be greater then today');
            end;
        }
        field(39004263; Factory; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = FILTER(Factory));

            trigger OnValidate()
            begin
                Factory := UpperCase(Factory);
                BuyingCentre.Reset;
                BuyingCentre.SetRange(Code, Factory);
                if BuyingCentre.Find('-') then begin
                    Factory := Format(BuyingCentre.Description, 50);
                end;
            end;
        }
        field(39004264; "Factory Name"; Text[50])
        {
            Editable = false;
            trigger OnValidate()

            begin
                "Factory Name" := UpperCase("Factory Name");
            end;
        }
        field(39004265; "Administrative Location"; Code[20])
        {
            trigger OnValidate()

            begin
                "Administrative Location" := UpperCase("Administrative Location");
            end;
        }
        field(39004266; "Administrative Sub-Location"; Code[20])
        {
            trigger OnValidate()

            begin
                "Administrative Sub-Location" := UpperCase("Administrative Sub-Location");
            end;
        }
        field(39004267; "Administrative Village"; Code[20])
        {
            trigger OnValidate()

            begin
                "Administrative Village" := UpperCase("Administrative Village");
            end;
        }
        field(39004268; Unit; Text[50])
        {
            trigger OnValidate()

            begin
                "Unit" := UpperCase("Unit");
            end;
        }
        field(39004269; Acreage; Text[50])
        {
            trigger OnValidate()

            begin
                Acreage := UpperCase(Acreage);
            end;
        }
        field(39004270; "Society No."; Code[20])
        {
            trigger OnValidate()

            begin
                "Society No." := UpperCase("Society No.");
            end;
        }
        field(39004271; "Self Employed"; Boolean)
        {
        }
        field(39004272; "Electoral Zone"; Code[20])
        {
            //TableRelation = "Voting Zones".Code;

            trigger OnValidate()
            begin
                "Electoral Zone" := UpperCase("Electoral Zone");
                /*VotingZones.Reset;
                VotingZones.SetRange(Code,"Electoral Zone");
                if VotingZones.FindFirst then
                "Electrol Zone Descr.":=VotingZones.Name;*/
            end;
        }
        field(39004273; "Meeting Days"; Text[50])
        {
            trigger OnValidate()

            begin
                "Meeting Days" := UpperCase("Meeting Days");
            end;
        }
        field(39004274; "Meeting Time"; Text[10])
        {
            trigger OnValidate()

            begin
                "Meeting Time" := UpperCase("Meeting Time");
            end;
        }
        field(39004275; "Meeting Venue"; Text[30])
        {
            trigger OnValidate()

            begin
                "Meeting Venue" := UpperCase("Meeting Venue");
            end;
        }
        field(39004276; "ID Type"; Option)
        {
            OptionCaption = 'National ID,Military ID,Passport,Alien ID';
            OptionMembers = "National ID","Military ID",Passport,"Alien ID";
        }
        field(39004277; "Military ID"; Code[20])
        {
            trigger OnValidate()

            begin
                "Military ID" := UpperCase("Military ID");
            end;
        }
        field(39004278; "KTDA No."; Code[10])
        {
            trigger OnValidate()

            begin
                "KTDA No." := UpperCase("KTDA No.");
            end;
        }
        field(39004279; "Signing Instructions"; Option)
        {
            OptionMembers = "Any One","Any Two","Any Three",All;
        }
        field(39004280; "Politically Exposed"; Option)
        {
            OptionCaption = ' ,Yes';
            OptionMembers = " ",Yes;
        }
        field(39004281; "Political Position"; Text[50])
        {
            trigger OnValidate()

            begin
                "Political Position" := UpperCase("Political Position");
            end;
        }
        field(39004282; "Search No."; Code[20])
        {
            trigger OnValidate()

            begin
                "Search No." := UpperCase("Search No.");
            end;
        }
        field(39004283; "Agent Mandate"; Text[100])
        {
            trigger OnValidate()

            begin
                "Agent Mandate" := UpperCase("Agent Mandate");
            end;
        }
        field(39004284; "Sacco CID"; Code[20])
        {

            trigger OnValidate()
            begin
                "Sacco CID" := UpperCase("Sacco CID");
                if "Sacco CID" <> '' then begin
                    Cust.Reset;
                    Cust.SetRange("Sacco CID", "Sacco CID");
                    if Cust.FindFirst then
                        Error('CID already Exists with Member No. %1 - %2', Cust."No.", Cust.Name);
                end;
            end;
        }
        field(39004285; "ID - Front"; BLOB)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
            Description = 'Used to capture applicant Photos and should be deleted on account creation.';
            SubType = Bitmap;

            trigger OnValidate()

            begin
                if "ID - Front".Length() > (40 * 1024) then
                    Error('The image cannot exceed 40kb in size');
            end;
        }
        field(39004286; "ID - Back"; BLOB)
        {
            Caption = 'Signature';
            DataClassification = ToBeClassified;
            Description = 'Used to capture applicant Signature and should be deleted on account creation.';
            SubType = Bitmap;
            trigger OnValidate()

            begin
                if "ID - Back".Length() > (40 * 1024) then
                    Error('The image cannot exceed 40kb in size');
            end;
        }
        field(39004287; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                if "Contract End Date" <> 0D then begin
                    if "Terms of Employment" = "Terms of Employment"::Permanent then
                        Error('Contract End Date Only Applicable to Casuals and Contracts');
                    if "Terms of Employment" = "Terms of Employment"::" " then
                        Error('Contract End Date Only Applicable to Casuals and Contracts');
                end;
            end;
        }
        field(39004300; "Tax Waiver End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004301; "Current Residence name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "Current Residence name" := UpperCase("Current Residence name");
            end;
        }
        field(39004302; Diocese; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Diocese.Code;
            trigger OnValidate()

            begin
                Diocese := UpperCase(Diocese);
            end;
        }
        field(39004303; Parish; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Parish.Code where("Diocese Code" = field(Diocese));
            trigger OnValidate()

            begin
                Parish := UpperCase(Parish);
            end;
        }
        field(39004304; Jumuiya; code[50])
        {
            TableRelation = Jumuiya.Code where(Diocese = field(Diocese), Parish = field(Parish));
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                Jumuiya := UpperCase(Jumuiya);
            end;
        }
        field(39004305; "Is Group Registered"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Yes,No;
        }
        field(39004306; "Catholic Faithful Refferee"; Code[50])
        {
            DataClassification = ToBeClassified;
            caption = 'Referee';
            TableRelation = Members."No." where("Member Type" = const("Catholic Faithful"));
            trigger OnValidate()

            begin
                "Catholic Faithful Refferee" := UpperCase("Catholic Faithful Refferee");
            end;
        }
        field(39004307; "Payment Type"; option)
        {
            //TableRelation = Jumuiya.Code where(Diocese = field(Diocese), Parish = field(Parish));
            OptionMembers = "M-Pesa",Cash,Checkoff;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Case "Payment Type" Of
                    "Payment Type"::"Checkoff":
                        begin
                            "Transaction Code" := '';
                            "Received By" := '';
                        end;
                End;
            end;

        }
        field(39004308; "Transaction Code"; code[50])

        {
            //TableRelation = Jumuiya.Code where(Diocese = field(Diocese), Parish = field(Parish));
            DataClassification = ToBeClassified;
            TableRelation = if ("Payment Type" = const(Cash)) "Receipts Header"."No."
            else
            if ("Payment Type" = const("M-Pesa")) "M-pesa Transactions"."Document No.";

            trigger OnValidate()
            var
                MemberApp: Record "Member Application";
            begin
                "Transaction Code" := UpperCase("Transaction Code");
                "Received By" := UpperCase(UserId);
                MemberApp.reset;
                MemberApp.SetRange("Transaction Code", Rec."Transaction Code");
                MemberApp.SetFilter("Payment Type", '<>%1', MemberApp."Payment Type"::Checkoff);
                MemberApp.SetFilter("No.", '<>%1', Rec."No.");
                if MemberApp.Find('-') then
                    Error('The transaction code has been used  in the joining of another member');
            end;

        }
        field(39004309; "Received By"; Code[30])
        {
            trigger OnValidate()

            begin
                "Received By" := UpperCase("Received By");
            end;
            // DataClassification = ToBeClassified;
        }
        field(39004310; "Portal Status"; Option)
        {
            OptionMembers = Pending,Submitted;
            DataClassification = ToBeClassified;
        }
        field(39004311; "Passport Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004312; "Current Post Code"; Code[20])
        {
            Caption = 'Current Post Code';
            TableRelation = IF (Nationality = CONST('')) "Post Code"
            ELSE
            IF (Nationality = FILTER(<> '')) "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin

                "Current Post Code" := UpperCase("Current Post Code");
                PostCode.ValidatePostCode(City, "Current Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }





    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "CRM Application No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        OPenrecords := '';
        i := 0;
        MemberApplication.Reset;
        MemberApplication.SetRange("Created By", UserId);
        MemberApplication.SetFilter(Status, '%1', MemberApplication.Status::Open);
        if MemberApplication.Find('-') then begin
            repeat
                i += 1;
                OPenrecords := MemberApplication."No.";
            until MemberApplication.Next = 0;
        end;

        //if i > UserSetup."Max. No of open Documents" then Error('You are not allowed to open multiple applications.Complete %1 first.', OPenrecords);
        if "No." = '' then begin
            SeriesSetup.Get;
            case "Customer Type" of
                "Customer Type"::Single:
                    begin
                        SeriesSetup.TestField(SeriesSetup."Member Application Nos.");
                        NoSeriesMgt.InitSeries(SeriesSetup."Member Application Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                    end;
                "Customer Type"::Joint:
                    begin
                        SeriesSetup.TestField(SeriesSetup."Joint Application Nos.");
                        NoSeriesMgt.InitSeries(SeriesSetup."Joint Application Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                    end;
                else begin
                    SeriesSetup.TestField(SeriesSetup."Group Application Nos.");
                    NoSeriesMgt.InitSeries(SeriesSetup."Group Application Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                end;

            end;

        end;

        //GeneralSetUp.Get();
        UserSet.Get(UserId);
        //UserSet.TestField("Global Dimension 1 Code");
        //UserSet.TestField("Global Dimension 2 Code");
        //UserSet.TestField("Responsibility Centre");
        //"Responsibility Center" := UserSet."Responsibility Centre";
        "Responsibility Center" := 'MARKETING';
        // "Global Dimension 1 Code" := UserSet."Global Dimension 1 Code";
        "Global Dimension 1 Code" := 'BOSA';
        //"Global Dimension 2 Code" := UserSet."Global Dimension 2 Code";



        "Application Date" := Today;
        "Home Address" := Addr;
        "Current Address" := Addr;
        "Created By" := UserId;
        /*
        IF UserSetup.GET(USERID) THEN BEGIN
          UserSetup.TESTFIELD(UserSetup."Global Dimension 1 Code"); UserSetup.TESTFIELD(UserSetup."Global Dimension 2 Code");
         "Global Dimension 1 Code":= UserSetup."Global Dimension 1 Code";
         "Global Dimension 2 Code":=UserSetup."Global Dimension 2 Code";
         "Responsibility Center":=UserSetup."Responsibility Centre";
        END;*/
        /* if "Customer Type" <> "Customer Type"::Cell then begin
             ProductFactory.Reset;
             ProductFactory.SetFilter(ProductFactory."Auto Open Account", '%1', true);
             ProductFactory.SetFilter(ProductFactory.Status, '%1', ProductFactory.Status::Active);
             if ProductFactory.Find('-') then
                 repeat
                     AutoOpenSavingAccs.Init;
                     AutoOpenSavingAccs."No." := "No.";
                     AutoOpenSavingAccs.Validate(AutoOpenSavingAccs."Product Type", ProductFactory."Product ID");
                     AutoOpenSavingAccs.Insert;
                 until ProductFactory.Next = 0;
         end;*/

        AddDefaultAccounts;

        ApplicationDocuments.Reset;
        ApplicationDocuments.SetRange("Reference No.", "No.");
        if ApplicationDocuments.FindFirst then
            ApplicationDocuments.DeleteAll;

        ApplicationDocumentSetup.Reset;
        ApplicationDocumentSetup.SetRange("Document Type", ApplicationDocumentSetup."Document Type"::Member);
        if "Single Party/Multiple/Business" = "Single Party/Multiple/Business"::Single then
            ApplicationDocumentSetup.SetFilter("Single Party/Multiple", '%1', ApplicationDocumentSetup."Single Party/Multiple"::Single);
        if "Single Party/Multiple/Business" = "Single Party/Multiple/Business"::Business then
            ApplicationDocumentSetup.SetFilter("Single Party/Multiple", '%1', ApplicationDocumentSetup."Single Party/Multiple"::Business);
        if "Single Party/Multiple/Business" = "Single Party/Multiple/Business"::Group then
            ApplicationDocumentSetup.SetFilter("Single Party/Multiple", '%1', ApplicationDocumentSetup."Single Party/Multiple"::Group);
        if "Single Party/Multiple/Business" = "Single Party/Multiple/Business"::Joint then
            ApplicationDocumentSetup.SetFilter("Single Party/Multiple", '%1', ApplicationDocumentSetup."Single Party/Multiple"::Joint);
        if "Single Party/Multiple/Business" = "Single Party/Multiple/Business"::Cell then
            ApplicationDocumentSetup.SetFilter("Single Party/Multiple", '%1', ApplicationDocumentSetup."Single Party/Multiple"::Cell);



        ApplicationDocumentSetup.SetRange(Mandatory, true);
        if ApplicationDocumentSetup.FindFirst then begin
            repeat
                ApplicationDocuments.Init;
                ApplicationDocuments.Validate("Reference No.", "No.");
                ApplicationDocuments.Validate("Document No.", ApplicationDocumentSetup."Document No.");
                ApplicationDocuments.Insert(true);
            // Message(Format(ApplicationDocuments));
            until ApplicationDocumentSetup.Next = 0;
        end;

    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserSet: Record "User Setup";
        Cust: Record Members;
        StrTel: Text[30];
        PostCode: Record "Post Code";
        ProductFactory: Record "Product Factory";
        AutoOpenSavingAccs: Record "Savings Account Registration";
        Text018: Label 'This applicant is below the mininmum membership age of %1. Is the applicant applying for a junior account';
        GeneralSetUp: Record "General Set-Up";
        DateofBirthError: Label 'This date cannot be greater than today.';
        MinimumAgeError: Label 'Minimum Age for Membership is %1';
        MemberExistError: Label 'Already exists with member %1 Name: %2';
        CountryRegion: Record "Country/Region";
        //SMTPMail: Codeunit "SMTP Mail";
        MailManagement: Codeunit "Mail Management";
        Customer: Record Customer;
        MemberApplication: Record "Member Application";
        Addr: Label 'P.O. BOX - ';
        BankAccountErr: Label 'Bank Account No cannot be more then 14 characters.';
        MemberCategory: Record "Member Category";
        ApplicationDocuments: Record "Application Documents";
        CRMApplication: Record "CRM Application";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        ElectrolZonesAreaSvrCenter: Record "Electrol Zones/Area Svr Center";
        SavingsAccounts: Record "Savings Accounts";
        HREmployees: Record "HR Employees";
        BuyingCentre: Record "Electrol Zones/Area Svr Center";
        Members: Record Members;
        NewMob: Code[20];
        i: Integer;
        OPenrecords: Code[20];
        //VotingZones: Record "Voting Zones";
        ApplicationDocumentSetup: Record "Application Document Setup";
        Segment: Record "Segment/County/Dividend/Signat";

    /// <summary>
    /// FieldLength.
    /// </summary>
    /// <param name="VarVariant">Text.</param>
    /// <param name="FldLength">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    /// <summary>
    /// FieldLength.
    /// </summary>
    /// <param name="VarVariant">Text.</param>
    /// <param name="FldLength">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;

    local procedure AddDefaultAccounts()
    var
        ProdApplicable: Record "Product Applicable Categories";
    begin

        AutoOpenSavingAccs.Reset;
        AutoOpenSavingAccs.SetRange("No.", "No.");
        if AutoOpenSavingAccs.FindFirst then
            AutoOpenSavingAccs.DeleteAll;

        ProdApplicable.Reset();
        ProdApplicable.SetRange("Member Account Category", rec."Single Party/Multiple/Business");
        if ProdApplicable.Find('-') then
            repeat
                ProductFactory.Reset();
                ProductFactory.SetRange("Product ID", ProdApplicable."Product ID");
                ProductFactory.SetRange("Auto Open Account", true);
                if ProductFactory.Find('-') then begin
                    AutoOpenSavingAccs.Init;
                    AutoOpenSavingAccs."No." := "No.";
                    AutoOpenSavingAccs.Validate(AutoOpenSavingAccs."Product Type", ProductFactory."Product ID");
                    AutoOpenSavingAccs.Insert;
                end;
            until ProdApplicable.Next = 0;


        /* ProductFactory.Reset;
         ProductFactory.SetFilter(ProductFactory.Status, '%1', ProductFactory.Status::Active);
         ProductFactory.SetFilter(ProductFactory."Auto Open Account", '%1', true);
         ProductFactory.SetFilter(ProductFactory."Product Category", '<>%1 & <>%2 & <>%3', ProductFactory."Product Category"::"Fixed Deposit",
                                  ProductFactory."Product Category"::"Junior Savings", ProductFactory."Product Category"::"Micro Credit Deposits");

         if "Single Party/Multiple/Business" = "Single Party/Multiple/Business"::Single then
             ProductFactory.SetRange("Auto Open Single/Group", ProductFactory."Auto Open Single/Group"::Single);
         if "Single Party/Multiple/Business" = "Single Party/Multiple/Business"::Business then
             ProductFactory.SetRange("Auto Open Single/Group", ProductFactory."Auto Open Single/Group"::Business);
         if "Single Party/Multiple/Business" = "Single Party/Multiple/Business"::Group then
             ProductFactory.SetRange("Auto Open Single/Group", ProductFactory."Auto Open Single/Group"::Group);


         if ProductFactory.Find('-') then begin
             repeat
                 AutoOpenSavingAccs.Init;
                 AutoOpenSavingAccs."No." := "No.";
                 AutoOpenSavingAccs.Validate(AutoOpenSavingAccs."Product Type", ProductFactory."Product ID");
                 AutoOpenSavingAccs.Insert;
             until ProductFactory.Next = 0;
         end;*/

    end;

    /// <summary>
    /// ValidateApproval.
    /// </summary>
    procedure ValidateApproval()
    var
        DefaultSavAccReg: Record "Savings Account Registration";
        NextofKINApplication: Record "Next of KIN Application";
        BenApp: Record "Beneficiary Application";
        SavingsFound: Boolean;
        NOKAlloc: Decimal;
        NextofKinError: Label 'You must specify next of Kin for this application.';
        ReffereeError: Label 'You must specify the referee fo this member type';
    begin
        Rec.TestField(Status, Rec.Status::Open);
        //Rec.TestField("P.I.N Number");
        Rec.TestField("Mobile Phone No");
        Rec.TestField("First Name");
        //Rec.TestField("Last Name");
        if Rec."ID Type" = Rec."ID Type"::"National ID" then
            Rec.TestField("ID No.");
        if Rec."ID Type" = Rec."ID Type"::Passport then
            Rec.TestField("Passport No.");

        if Rec."Tax Exempted" then begin
            Rec.TestField("Tax Waiver End Date");


        end;

        //felix on 7th Dec 2022 to throw error for member types child and spouse where referee is empty
        if Rec."Member Type" in [Rec."Member Type"::Child, Rec."Member Type"::Spouse] then begin
            if rec."Catholic Faithful Refferee" = '' then
                Error(ReffereeError);
        end;


        MemberApplication.Reset;
        MemberApplication.SetRange("No.", Rec."No.");
        if MemberApplication.FindFirst then begin

            SavingsFound := false;
            DefaultSavAccReg.Reset;
            DefaultSavAccReg.SetRange(DefaultSavAccReg."No.", MemberApplication."No.");
            if DefaultSavAccReg.Find('-') then begin
                repeat
                    if ProductFactory.Get(DefaultSavAccReg."Product Type") then
                        if ProductFactory."Product Category" = ProductFactory."Product Category"::" " then
                            SavingsFound := true;
                until DefaultSavAccReg.Next = 0;
            end;



            ApplicationDocumentSetup.Reset;
            ApplicationDocumentSetup.SetRange("Document Type", ApplicationDocumentSetup."Document Type"::Member);
            ApplicationDocumentSetup.SetFilter("Single Party/Multiple", '%1', ApplicationDocumentSetup."Single Party/Multiple"::Single);
            ApplicationDocumentSetup.SetRange(Mandatory, true);
            if ApplicationDocumentSetup.FindFirst then begin
                repeat
                    ApplicationDocuments.Reset;
                    ApplicationDocuments.SetRange("Reference No.", MemberApplication."No.");
                    ApplicationDocuments.SetRange("Document No.", ApplicationDocumentSetup."Document No.");
                    ApplicationDocuments.SetRange(Provided, ApplicationDocuments.Provided::Yes);
                    if not ApplicationDocuments.FindFirst then
                        Error('%1 is Mandatory for this application.', ApplicationDocumentSetup."Document No.");
                until ApplicationDocumentSetup.Next = 0;
            end;


            NOKAlloc := 0;
            NextofKINApplication.Reset;
            NextofKINApplication.SetRange("Account No", Rec."No.");
            if NextofKINApplication.FindFirst then begin
                repeat
                    NOKAlloc += NextofKINApplication."%Allocation";
                    NextofKINApplication.TestField(Name);
                    NextofKINApplication.Name := UpperCase(NextofKINApplication.Name);
                    //NextofKINApplication.TESTFIELD("ID No./Birth Cert. No.");
                    NextofKINApplication.Modify(true);
                until NextofKINApplication.Next = 0;
                if NOKAlloc > 0 then
                    IF NOKAlloc <> 100 THEN
                        ERROR('Next of Kin Allocation MUST be 100%, Current is %1', NOKAlloc);
            end
            else
                Error('Please enter Next of Kin Details');

            /*NOKAlloc := 0;
            BenApp.Reset;
            BenApp.SetRange("Account No", Rec."No.");
            if BenApp.FindFirst then begin
                repeat
                    NOKAlloc += BenApp."%Allocation";
                    BenApp.TestField(Name);
                //NextofKINApplication.TESTFIELD("ID No./Birth Cert. No.");
                until BenApp.Next = 0;
                if NOKAlloc <> 100 then
                    Error('Beneficiary Allocation MUST be 100%, Current is %1', NOKAlloc);
            end
            else
                Error('Please enter Beneficiary Details');*/


            Members.Reset;
            Members.SetRange(Name, Rec.Name);
            if Members.FindFirst then begin
                Message('Kindly Note that there are %1 Member(s) with the same Name (%2)', Members.Count, Members.Name);
            end;

            /*  if Rec."Terms of Employment" <> Rec."Terms of Employment"::" " then
                  if Rec."Terms of Employment" <> Rec."Terms of Employment"::Permanent then
                      Rec.TestField("Contract End Date");
              */



        end;


        case Rec."Single Party/Multiple/Business" of
            Rec."Single Party/Multiple/Business"::Single:
                begin
                    Rec.TestField("First Name");
                    Rec.TestField("Second Name");
                    Rec.TestField("Date of Birth");
                    //Rec.TestField("Marital Status");
                    // Rec.TestField("Sub Location");
                    // Rec.TestField(Location);
                    // Rec.TestField(District);
                    // Rec.TestField(Division);
                    Rec.TestField(Diocese);
                    if Rec."Member Type" = Rec."Member Type"::"Catholic Faithful" then
                        Rec.TestField(Parish);
                    Rec.TestField("Current Address");
                    //TESTFIELD("Member Segment");
                    Rec.TestField(Salutation);
                    Rec.TestField("Post Code");
                    Rec.TestField("Global Dimension 1 Code");
                    //Rec.TestField("Global Dimension 2 Code");
                    Rec.TestField(County);
                    Rec.TestField(Nationality);
                    Rec.TestField("Mobile Phone No");
                    if StrLen(Rec."Mobile Phone No") <> 13 then
                        Error('Invalid Mobile Phone No.');
                    //TESTFIELD("Phone No.");
                    Rec.TestField(Salutation);
                    IF GuiAllowed then Rec.TestField("Member Category");
                    //TESTFIELD("Society No.");
                    Rec.TestField("Date of Birth");
                    // Rec.TestField("Marital Status");
                    //TESTFIELD("Customer Type");
                    if Rec."Customer Type" = Rec."Customer Type"::" " then
                        Error('Enter Customer Type');

                    if Rec."Self Employed" = false then begin
                        Rec.TestField("Employer Code");
                        Rec.TESTFIELD("Terms of Employment");
                        //  Rec.TESTFIELD("Payroll/Staff No.");
                        //if Rec."Terms of Employment" = Rec."Terms of Employment"::Permanent then
                        // Rec.TESTFIELD("Appointment Date");
                    end;
                    Rec.TestField("Responsibility Center");
                    //TESTFIELD("Read/Write");
                    Rec.TestField(Nationality);
                    Rec.TestField("Post Code");

                    if (Rec."ID Type" = Rec."ID Type"::"National ID") or (Rec."ID Type" = Rec."ID Type"::"Alien ID") then
                        Rec.TestField("ID No.");
                    if Rec."ID Type" = Rec."ID Type"::Passport then
                        Rec.TestField("Passport No.");
                    if Rec."ID Type" = Rec."ID Type"::"Military ID" then
                        Rec.TestField("Military ID");

                    Rec.CalcFields(Picture, Signature);
                    Rec.CalcFields("ID - Back", "ID - Front");
                    if /*(not Rec."ID - Back".HasValue) or*/ (not Rec."ID - Front".HasValue) then
                        Error('This Application Does Not Contain ID Images.');
                    if (not Rec.Picture.HasValue) or (not Rec.Signature.HasValue) then begin
                        Error('This Application Does Not Contain a Picture or Signature.');



                    end;
                end;
            Rec."Single Party/Multiple/Business"::Business:
                begin
                    Rec.TestField(Diocese);
                end;
        end;
    end;
}

