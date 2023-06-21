table 51532026 Members
{
    //DrillDownPageID = "Member List";
    //LookupPageID = "Member List";

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                /*IF "No." <> xRec."No." THEN BEGIN
                  GeneralSetUp.GET();
                  IF GeneralSetUp."BaseMember Nos. on MemberClass"=TRUE THEN
                    BEGIN
                  MemberCategory.RESET;
                  MemberCategory.SETRANGE("No.",xRec."Member Category");
                  IF MemberCategory.FIND('-') THEN
                    BEGIN
                  NoSeriesMgt.TestManual(MemberCategory."Member Nos.");
                  "No. Series" := '';
                  END ELSE
                  BEGIN
                   SeriesSetup.GET;
                  NoSeriesMgt.TestManual(SeriesSetup."Member Nos.");
                  "No. Series" := '';
                    END;
                    END ELSE
                    BEGIN
                        SeriesSetup.GET;
                        NoSeriesMgt.TestManual(SeriesSetup."Member Nos.");
                        "No. Series" := '';
                      END;
                END;
                */
                "No." := UpperCase("No.");
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    if "Customer Type" <> "Customer Type"::Cell then begin
                        case "Customer Type" of
                            "Customer Type"::Joint:
                                begin
                                    NoSeriesMgt.TestManual(SeriesSetup."Joint Nos.");
                                end;
                            "Customer Type"::Single:
                                begin
                                    NoSeriesMgt.TestManual(SeriesSetup."Member Nos.");
                                end;
                            "Customer Type"::"Group":
                                begin
                                    NoSeriesMgt.TestManual(SeriesSetup."Group Nos.");
                                end;

                        end;


                        "No. Series" := '';
                    end
                    else
                        if "Customer Type" = "Customer Type"::Cell then begin
                            NoSeriesMgt.TestManual(SeriesSetup."Cell Group Nos");
                        end;
                end;
                //Prevent Changing once entries exist
                TestNoEntriesExist(FieldCaption("No."), "No.");
            end;
        }
        field(2; Name; Text[90])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                Name := UpperCase(Name);
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then "Search Name" := Name;
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts.Name, Name);
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.Name, Name);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(3; "Search Name"; Code[80])
        {
            Caption = 'Search Name';

            trigger OnValidate()
            begin
                "Search Name" := UpperCase("Search Name");
            end;
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';

            trigger OnValidate()
            begin
                "Name 2" := UpperCase("Name 2");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Name 2", "Name 2");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Name 2", "Name 2");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(5; "Current Address"; Text[60])
        {
            Caption = 'Current Address';

            trigger OnValidate()
            begin
                "Current Address" := UpperCase("Current Address");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Current Address", "Current Address");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Current Address", "Current Address");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(6; "Home Address"; Text[60])
        {
            Caption = 'Home Address';

            trigger OnValidate()
            begin
                "Home Address" := UpperCase("Home Address");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Home Address", "Home Address");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Home Address", "Home Address");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(7; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                City := UpperCase(City);
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts.City, City);
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.City, City);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                PostCode.ValidateCity(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(8; Contact; Text[50])
        {
            Caption = 'Contact';

            trigger OnValidate()
            begin
                Contact := UpperCase(Contact);
            end;
        }
        field(9; "Alternative Phone No. 1"; Text[13])
        {
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            begin
                "Alternative Phone No. 1" := UpperCase("Alternative Phone No. 1");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Alternative Phone No. 1", "Alternative Phone No. 1");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Phone No.", "Alternative Phone No. 1");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(10; "Telex No."; Text[50])
        {
            Caption = 'Telex No.';

            trigger OnValidate()
            begin
                "Telex No." := UpperCase("Telex No.");
            end;
        }
        field(11; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';

            trigger OnValidate()
            begin
                "Our Account No." := UpperCase("Our Account No.");
            end;
        }
        field(12; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;

            trigger OnValidate()
            begin
                "Territory Code" := UpperCase("Territory Code");
            end;
        }
        field(13; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                "Global Dimension 1 Code" := UpperCase("Global Dimension 1 Code");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Global Dimension 1 Code", "Global Dimension 1 Code");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Global Dimension 1 Code", "Global Dimension 1 Code");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                "Global Dimension 2 Code" := UpperCase("Global Dimension 2 Code");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Global Dimension 2 Code", "Global Dimension 2 Code");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Global Dimension 2 Code", "Global Dimension 2 Code");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                "Currency Code" := UpperCase("Currency Code");
            end;
        }
        field(16; "Recruited By"; Code[10])
        {
            Caption = 'Recruited By';
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
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    SavingAccounts.Validate(SavingAccounts."Recruited By", "Recruited By");
                    SavingAccounts.Modify;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Recruited By", "Recruited By");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(17; Nationality; Code[10])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                Nationality := UpperCase(Nationality);
                /*IF CountryRegion.GET(Nationality) THEN
                      "Mobile Phone No":=CountryRegion.Code + DELCHR(xRec."Mobile Phone No",'=',xRec.Nationality);*/
            end;
        }
        field(18; Comment; Boolean)
        {
            /*CalcFormula = Exist("Comment Line" WHERE ("Table Name"=CONST(Member),
                                                          "No."=FIELD("No.")));
                Caption = 'Comment';
                Description = 'LookUp to Comment Line';
                Editable = false;
                FieldClass = FlowField;*/
        }
        field(19; Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ",Credit,Debit,All;

            trigger OnValidate()
            begin
                SavingAccounts.Reset;
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts.Blocked, Blocked);
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.Blocked, Blocked);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(20; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(21; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(22; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(23; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(24; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';

            trigger OnValidate()
            begin
                "Fax No." := UpperCase("Fax No.");
            end;
        }
        field(25; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                "VAT Registration No." := UpperCase("VAT Registration No.");
                //VATRegNoFormat.Test("VAT Registration No.",Nationality,"No.",DATABASE::Customer);
            end;
        }
        field(26; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(27; "Post Code"; Code[30])
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
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Post Code", "Post Code");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Post Code", "Post Code");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                PostCode.ValidatePostCode(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(28; County; Text[30])
        {
            Caption = 'County';
            Description = 'LookUp to Member Segment Table where Type = County';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));

            trigger OnValidate()
            begin
                County := UpperCase(County);
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    SavingAccounts.Validate(SavingAccounts.County, County);
                    SavingAccounts.Modify;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.County, County);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(29; "E-Mail"; Text[150])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                "E-Mail" := UpperCase("E-Mail");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."E-Mail", "E-Mail");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."E-Mail", "E-Mail");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(30; "Current Location"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;

            trigger OnValidate()
            begin
                "Current Location" := UpperCase("Current Location");
            end;
        }
        field(31; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(32; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(33; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                "Primary Contact No." := UpperCase("Primary Contact No.");
            end;
        }
        field(34; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Description = 'LookUp to Responsibility Center BR Table';
            TableRelation = "Responsibility CenterBR";

            trigger OnValidate()
            begin
                "Responsibility Center" := UpperCase("Responsibility Center");
            end;
        }
        field(35; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";

            trigger OnValidate()
            begin
                "Base Calendar Code" := UpperCase("Base Calendar Code");
            end;
        }
        field(36; "Customer Type"; Option)
        {
            OptionCaption = ' ,Single,Joint,Group,Microfinance,Cell,Staff,Minor';
            OptionMembers = " ",Single,Joint,Group,Microfinance,Cell,Staff,Minor;
        }
        field(37; "Registration Date"; Date)
        {
        }
        field(38; Status; Option)
        {
            OptionCaption = ' ,New,Active,Dormant,Frozen,Withdrawal Application,Withdrawn,Deceased,Withdrawal-Defaulter,Closed,Blocked,Creditor';
            OptionMembers = " ",New,Active,Dormant,Frozen,"Withdrawal Application",Withdrawn,Deceased,Defaulter,Closed,Blocked,Creditor;

            /*trigger OnValidate()
            begin
                if xRec.Status = xRec.Status::Closed then
                    if Status = Status::Active then begin
                        Rejoined := true;
                        "Date Rejoined" := Today;
                    end;
                SavingAccounts.Reset;
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat // SavingAccounts.Validate(SavingAccounts.Status, Status);
                    //  SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.Status, Status);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                if Status = Status::Defaulter then begin
                    Emp.Reset;
                    Emp.SetRange("Employer Type", Emp."Employer Type"::Defaulter);
                    if Emp.FindFirst then begin
                        "Employer Code" := Emp."No.";
                    end;
                end;
                if Status = Status::Creditor then begin
                    Emp.Reset;
                    Emp.SetRange("Employer Type", Emp."Employer Type"::Creditor);
                    if Emp.FindFirst then begin
                        "Employer Code" := Emp."No.";
                    end;
                end;
            end; */
        }
        field(39; "Employer Code"; Code[100])
        {
            Description = 'LookUp to Customer Table';
            //TableRelation = Customer WHERE("Account Type" = CONST(Employer));

            trigger OnValidate()
            var
                MEH: Record "Member Employment History";
            begin
                "Employer Code" := UpperCase("Employer Code");
                MEH.reset;
                MEH.InitEntry("No.", "Employer Code", '');
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Employer Code", "Employer Code");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Employer Code", "Employer Code");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                CheckoffAdviceLine.Reset;
                CheckoffAdviceLine.SetRange("Member No.", "No.");
                if CheckoffAdviceLine.Find('-') then begin
                    repeat
                        CheckoffAdviceLine.Validate("Employer Code", "Employer Code");
                        CheckoffAdviceLine.Modify;
                    until CheckoffAdviceLine.Next = 0;
                end;
                LoanApps.Reset;
                LoanApps.SetRange("Member No.", "No.");
                if LoanApps.Find('-') then begin
                    repeat
                        LoanApps.Validate("Employer Code", "Employer Code");
                        LoanApps.Modify;
                    until LoanApps.Next = 0;
                end;
            end;
        }
        field(40; "Date of Birth"; Date)
        {
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                /*IF "Date of Birth"<>0D THEN
                IF "Date of Birth" > TODAY THEN
                  ERROR(DateofBirthError);
                */
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Date of Birth", "Date of Birth");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Date of Birth", "Date of Birth");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(41; "Terms of Employment"; Option)
        {
            OptionMembers = " ",Permanent,Contract,Casual;
        }
        field(43; Location; Text[50])
        {
            trigger OnValidate()
            begin
                Location := UpperCase(Location);
            end;
        }
        field(44; "Resons for Status Change"; Text[80])
        {
            trigger OnValidate()
            begin
                "Resons for Status Change" := UpperCase("Resons for Status Change");
            end;
        }
        field(45; "Payroll/Staff No."; Code[20])
        {
            trigger OnValidate()
            begin
                "Payroll/Staff No." := UpperCase("Payroll/Staff No.");
                if "Payroll/Staff No." <> '' then begin
                    /*Cust.RESET;
                    Cust.SETRANGE(Cust."Payroll/Staff No.","Payroll/Staff No.");
                    Cust.SETFILTER(Cust.Status,'<>%1',Cust.Status::Defaulter);
                    Cust.SETFILTER("Employer Code","Employer Code");
                    IF Cust.FINDFIRST THEN
                     ERROR(MemberExistError,Cust."No.",Cust.Name);*/
                    SavingAccounts.Reset;
                    SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                    SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                    SavingAccounts.SetFilter(SavingAccounts."Employer Code", "Employer Code");
                    if SavingAccounts.Find('-') then begin
                        repeat
                            SavingAccounts.Validate(SavingAccounts."Payroll/Staff No.", "Payroll/Staff No.");
                            SavingAccounts.Modify;
                        until SavingAccounts.Next = 0;
                    end;
                end;
                /*CreditAccounts.RESET;
                    CreditAccounts.SETFILTER(CreditAccounts."Member No.",'<>%1','');
                    CreditAccounts.SETRANGE(CreditAccounts."Member No.","No.");
                    IF CreditAccounts.FIND('-') THEN BEGIN
                     REPEAT
                     CreditAccounts.VALIDATE(CreditAccounts."Payroll/Staff No.","Payroll/Staff No.");
                      CreditAccounts.MODIFY;
                      UNTIL CreditAccounts.NEXT=0;
                    END;*/
            end;
        }
        field(46; "ID No."; Code[50])
        {
            trigger OnValidate()
            begin
                //"ID No.":=DELCHR("ID No.",'=','A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
                if "ID No." <> '' then begin
                    /*Cust.RESET;
                        Cust.SETRANGE(Cust."ID No.","ID No.");
                        Cust.SETFILTER(Cust.Status,'<>%1',Cust.Status::Defaulter);
                        IF Cust.FINDFIRST THEN
                         ERROR(MemberExistError,Cust."No.",Cust.Name);*/
                end;
                //**FieldLength("ID No.",10);
                "ID No." := UpperCase("ID No.");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."ID No.", "ID No.");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."ID No.", "ID No.");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                if xRec."ID No." <> "ID No." then begin
                    /* if SaccoTrans.SubscribedSMS("No.", SourceType::"Member Changes") then begin
                             SavingAccounts.Reset;
                             SavingAccounts.SetRange("Product Category", SavingAccounts."Product Category"::" ");
                             SavingAccounts.SetRange("Member No.", "No.");
                             if SavingAccounts.FindFirst then
                                 SendSMS.SendSms(SourceType::"Member Changes", "Mobile Phone No", 'Dear ' + Name + ', You ID No. has been updated to ' + "ID No." + '. ',
                                 "No.", SavingAccounts."No.", true, false);
                         end;*/
                end;
            end;
        }
        field(47; "Mobile Phone No"; Code[35])
        {
            trigger OnValidate()
            begin
                /*IF "Mobile Phone No" <>'' THEN BEGIN
                Cust.RESET;
                Cust.SETRANGE(Cust."Mobile Phone No","Mobile Phone No");
                Cust.SETFILTER(Cust.Status,'<>%1',Cust.Status::Defaulter);
                IF Cust.FINDFIRST THEN
                 ERROR(MemberExistError,Cust."No.",Cust.Name);
                END;*/
                "Mobile Phone No" := UpperCase("Mobile Phone No");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts."Mobile Phone No" := "Mobile Phone No";
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts."Mobile Phone No" := "Mobile Phone No";
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                if "Mobile Phone No" <> '' then
                    if xRec."Mobile Phone No" <> "Mobile Phone No" then begin
                        "MPESA Mobile No" := "Mobile Phone No";
                        /*if SaccoTrans.SubscribedSMS("No.", SourceType::"Member Changes") then begin
                                SavingAccounts.Reset;
                                SavingAccounts.SetRange("Product Category", SavingAccounts."Product Category"::" ");
                                SavingAccounts.SetRange("Member No.", "No.");
                                if SavingAccounts.FindFirst then
                                    SendSMS.SendSms(SourceType::"Member Changes", "Mobile Phone No", 'Dear ' + Name + ', You Mobile Phone No. has been updated to ' + "Mobile Phone No" + '. ',
                                    "No.", SavingAccounts."No.", true, false);
                            end;*/
                    end;
            end;
        }
        field(48; "Marital Status"; Option)
        {
            OptionCaption = ' ,Single,Married,Divorced,Widowed,Others';
            OptionMembers = " ",Single,Married,Divorced,Widowed,Others;

            trigger OnValidate()
            begin
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Marital Status", "Marital Status");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Marital Status", "Marital Status");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(49; "Passport No."; Code[50])
        {
            trigger OnValidate()
            begin
                if "Passport No." <> '' then begin
                    /*Cust.RESET;
                        Cust.SETRANGE(Cust."Passport No.","Passport No.");
                        Cust.SETFILTER(Cust.Status,'<>%1',Cust.Status::Defaulter);
                        IF Cust.FINDFIRST THEN
                         ERROR(MemberExistError,Cust."No.",Cust.Name);*/
                end;
                "Passport No." := UpperCase("Passport No.");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Passport No.", "Passport No.");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Passport No.", "Passport No.");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(50; Gender; Option)
        {
            OptionCaption = '  ,Male,Female';
            OptionMembers = "  ",Male,Female;

            trigger OnValidate()
            begin
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts.Gender, Gender);
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.Gender, Gender);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(51; "First Name"; Text[50])
        {
            trigger OnValidate()
            begin
                Name := Uppercase("First Name" + ' ' + "Second Name" + ' ' + "Last Name");
                "First Name" := UpperCase("First Name");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts.Name, Name);
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.Name, Name);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(52; "Alternative Phone No. 2"; Code[13])
        {
            trigger OnValidate()
            begin
                "Alternative Phone No. 1" := UpperCase("Alternative Phone No. 1");
            end;
        }
        field(53; "Account Category"; Option)
        {
            OptionCaption = 'Member,Staff Members,Board Members,Delegates,Non-Member,Minor';
            OptionMembers = Member,"Staff Members","Board Members",Delegates,"Non-Member",Minor;
        }
        field(54; "MPESA Mobile No"; Code[13])
        {
            trigger OnValidate()
            begin
                "MPESA Mobile No" := UpperCase("MPESA Mobile No");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Alternative Phone No. 2", "MPESA Mobile No");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."MPESA Mobile No", "MPESA Mobile No");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(55; "Group Code"; Code[40])
        {
            TableRelation = Members."No." WHERE("Group Account" = FILTER(true), "Customer Type" = CONST(Microfinance));

            trigger OnValidate()
            begin
                "Group Code" := UpperCase("Group Code");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Group Account No", "Group Code");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Group Account No", "Group Code");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(57; "Group Account"; Boolean)
        {
            trigger OnValidate()
            begin
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Group Account", "Group Account");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Group Account", "Group Account");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(58; "Second Name"; Text[50])
        {
            Description = 'Maintain names separately';

            trigger OnValidate()
            begin
                "Second Name" := UpperCase("Second Name");
                Name := UpperCase("First Name" + ' ' + "Second Name" + ' ' + "Last Name");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts.Name, Name);
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.Name, Name);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(59; "Last Name"; Text[50])
        {
            Description = 'Names separately';

            trigger OnValidate()
            begin
                Name := UpperCase(Name);
                Name := UpperCase("First Name" + ' ' + "Second Name" + ' ' + "Last Name");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts.Name, Name);
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts.Name, Name);
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(60; "Employment / Occupation Detail"; Text[50])
        {
            trigger OnValidate()
            begin
                "Employment / Occupation Detail" := UpperCase("Employment / Occupation Detail");
            end;
        }
        field(61; "Employer's Postal Address"; Text[150])
        {
            trigger OnValidate()
            begin
                "Employer's Postal Address" := UpperCase("Employer's Postal Address");
            end;
        }
        field(62; "Member Station"; Code[20])
        {
            Description = 'LookUp to Member Segment Table where Type = Segment';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));

            trigger OnValidate()
            begin
                "Member Station" := UpperCase("Member Station");
            end;
        }
        field(63; "Membership Type"; Option)
        {
            OptionCaption = ' ,Ordinary,Preferential';
            OptionMembers = " ",Ordinary,Preferential;
        }
        field(64; "Account Type"; Option)
        {
            OptionCaption = ' ,Savings Account,Personal Savings,Microfinance Savings,Salary Account,Share Deposit Account,Fixed Deposit Account,Others(Specify)';
            OptionMembers = " ","Savings Account","Personal Savings","Microfinance Savings","Salary Account","Share Deposit Account","Fixed Deposit Account","Others(Specify)";
        }
        field(65; "Relates to Business/Group"; Boolean)
        {
            trigger OnValidate()
            begin
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Relates to Business/Group", "Relates to Business/Group");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Relates to Business/Group", "Relates to Business/Group");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(66; "Type of Business"; Option)
        {
            OptionCaption = ' ,Sole Proprietor,Paerneship,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor",Paerneship,"Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
        }
        field(67; "Other Business Type"; Text[15])
        {
            trigger OnValidate()
            begin
                "Other Business Type" := UpperCase("Other Business Type");
            end;
        }
        field(68; "Ownership Type"; Option)
        {
            OptionCaption = ' ,Personal Account,Joint Account,Group/Business,FOSA Shares,Staff';
            OptionMembers = " ","Personal Account","Joint Account","Group/Business","FOSA Shares",Staff;
        }
        field(69; "Other Account Type"; Text[15])
        {
            trigger OnValidate()
            begin
                "Other Account Type" := UpperCase("Other Account Type");
            end;
        }
        field(70; "Nature of Business"; Text[30])
        {
            trigger OnValidate()
            begin
                "Nature of Business" := UpperCase("Nature of Business");
            end;
        }
        field(71; "Company Registration No."; Code[20])
        {
            trigger OnValidate()
            begin
                "Company Registration No." := UpperCase("Company Registration No.");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Company Registration No.", "Company Registration No.");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Company Registration No.", "Company Registration No.");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(72; "Date of Business Reg."; Date)
        {
        }
        field(73; "Business/Group Location"; Text[50])
        {
            trigger OnValidate()
            begin
                "Business/Group Location" := UpperCase("Business/Group Location");
            end;
        }
        field(74; "Plot/Bldg/Street/Road"; Text[50])
        {
            trigger OnValidate()
            begin
                "Plot/Bldg/Street/Road" := UpperCase("Plot/Bldg/Street/Road");
            end;
        }
        field(75; "Group Type"; Option)
        {
            OptionCaption = ' ,Welfare,Church,Investment Club,Others';
            OptionMembers = " ",Welfare,Church,"Investment Club",Others;
        }
        field(76; "Single Party/Multiple"; Option)
        {
            OptionCaption = 'Single,Group,Corporate';
            OptionMembers = Single,Multiple,Business;

            trigger OnValidate()
            begin
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Single Party/Multiple/Business", "Single Party/Multiple");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
            end;
        }
        field(77; "Birth Certificate No."; Code[20])
        {
            trigger OnValidate()
            begin
                "Birth Certificate No." := UpperCase("Birth Certificate No.");
            end;
        }
        field(78; "Current Residence"; Text[30])
        {
            trigger OnValidate()
            begin
                "Current Residence" := UpperCase("Current Residence");
            end;
        }
        field(79; "Protected Account"; Boolean)
        {
        }
        field(80; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                "User ID" := UpperCase("User ID");
            end;
        }
        field(81; "Created By"; Code[50])
        {
            trigger OnValidate()
            begin
                "Created By" := UpperCase("Created By");
            end;
        }
        field(82; "Bank Code"; Code[20])
        {
            Description = 'LookUp to Banks Code Structure Table';
            TableRelation = "PR Bank Accounts"."Bank Code";

            trigger OnValidate()
            begin
                "Bank Code" := UpperCase("Bank Code");
            end;
        }
        field(83; "Branch Code"; Code[20])
        {
            Description = 'LookUp to Banks Code Structure Table';
            TableRelation = "PR Bank Branches"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));

            trigger OnValidate()
            begin
                "Branch Code" := UpperCase("Branch Code");
            end;
        }
        field(84; "Bank Account No."; Code[20])
        {
            trigger OnValidate()
            begin
                "Bank Account No." := UpperCase("Bank Account No.");
            end;
        }
        field(85; "P.I.N Number"; Code[20])
        {
            trigger OnValidate()
            begin
                "P.I.N Number" := UpperCase("P.I.N Number");
                FieldLength("ID No.", 15);
            end;
        }
        field(86; Source; Option)
        {
            Description = 'Used to identify origin of Member Application [CRM, Navision, Web]';
            OptionCaption = ' ,Navision,CRM,Web,Agency';
            OptionMembers = " ",Navision,CRM,Web,Agency;
        }
        field(87; "Application No."; Code[10])
        {
            trigger OnValidate()
            begin
                "Application No." := UpperCase("Application No.");
            end;
        }
        field(88; "Member Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Catholic Faithful",Spouse,Child,"Catholic Institution";
        }
        field(89; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";

            trigger OnValidate()
            begin
                "Member Category" := UpperCase("Member Category");
            end;
        }
        field(90; "Recruited by Type"; Option)
        {
            OptionCaption = 'Marketer,Others,Staff,Board Member,Member';
            OptionMembers = Marketer,Others,Staff,"Board Member",Member;

            trigger OnValidate()
            begin
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Recruited by Type", "Recruited by Type");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Recruited by Type", "Recruited by Type");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
            end;
        }
        field(91; "Sub Location"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Sub Location" := UpperCase("Sub Location");
            end;
        }
        field(92; Division; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Division := UpperCase(Division);
            end;
        }
        field(93; District; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                District := UpperCase(District);
            end;
        }
        field(50000; "BSS Registered"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "FingerPrint Verified"; Boolean)
        {
            Editable = false;
        }
        field(50002; SystemGeneratedGuid; Guid)
        {
        }
        field(50003; "Status Change Statistics"; Integer)
        {
            CalcFormula = Count("Reactivate/Deactivate Header" WHERE("Account Type" = CONST(Member), "Account No." = FIELD("No."), Status = CONST(Processed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Relationship Manager"; Code[10])
        {
            TableRelation = "HR Employees" WHERE(Status = FILTER(Active));

            trigger OnValidate()
            begin
                "Relationship Manager" := UpperCase("Relationship Manager");
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Relationship Manager", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Relationship Manager", "Relationship Manager");
                if SavingAccounts.Find('-') then begin
                    repeat
                        SavingAccounts.Validate(SavingAccounts."Relationship Manager", "Relationship Manager");
                        SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Relationship Manager", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Relationship Manager", "Relationship Manager");
                if CreditAccounts.Find('-') then begin
                    repeat
                        CreditAccounts.Validate(CreditAccounts."Relationship Manager", "Relationship Manager");
                        CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                LoanApps.Reset;
                LoanApps.SetRange(LoanApps."Member No.", '<>%1', '');
                LoanApps.SetRange(LoanApps."Member No.", "No.");
                if LoanApps.Find('-') then begin
                    repeat
                        LoanApps."Relationship Manager" := "Relationship Manager";
                        LoanApps.Modify;
                    until LoanApps.Next = 0;
                end;
            end;
        }
        field(50005; "Statement E-Mail Freq."; DateFormula)
        {
        }
        field(50056; "Personal E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Personal E-mail" := UpperCase("Personal E-mail");
                //if "Personal E-mail"<>'' then
                //SMTPMail.CheckValidEmailAddresses("Personal E-mail");
            end;
        }
        field(50057; "Recruited By Staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                "Recruited By Staff No" := UpperCase("Recruited By Staff No");
            end;
        }
        field(50058; "Cell Group Code"; Code[20])
        {
            // CalcFormula = Lookup("Cell Group Members"."Account No" WHERE ("Member No."=FIELD("No.")));
            //FieldClass = FlowField;
            trigger OnValidate()
            begin
                "Cell Group Code" := UpperCase("Cell Group Code");
            end;
        }
        field(39004241; "Last Transaction Date"; Date)
        {
            CalcFormula = Max("Savings Ledger Entry"."Posting Date" WHERE("Customer No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(39004242; Classification; Option)
        {
            OptionCaption = ' ,Good Standing,Bad Standing';
            OptionMembers = " ","Good Standing","Bad Standing";
        }
        field(39004243; "Electrol Zone"; Code[35])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Electral Zone"));

            trigger OnValidate()
            begin
                "Electrol Zone" := UpperCase("Electrol Zone");
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
            OptionCaption = ' ,From Other Sacco';
            OptionMembers = " ","From Other Sacco";
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
        field(39004249; "Special Member"; Boolean)
        {
        }
        field(39004250; "Virtual Members"; Boolean)
        {
        }
        field(39004251; "Tax Exempted"; Boolean)
        {
            Caption = 'Disabled';
        }
        field(39004252; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(39004253; "Recruited By Name"; Text[100])
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
        field(39004256; "Vote Code"; Code[35])
        {
            trigger OnValidate()
            begin
                "Vote Code" := UpperCase("Vote Code");
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
        field(39004261; "Read/Write"; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(39004262; "Appointment Date"; Date)
        {
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
        field(39004266; "Administrative Sub-Location"; Code[35])
        {
            trigger OnValidate()
            begin
                "Administrative Sub-Location" := UpperCase("Administrative Sub-Location");
            end;
        }
        field(39004267; "Administrative Village"; Code[35])
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
                Unit := UpperCase(Unit);
            end;
        }
        field(39004269; Acreage; Text[50])
        {
            trigger OnValidate()
            begin
                Acreage := UpperCase(Acreage);
            end;
        }
        field(39004270; "Form No."; Code[20])
        {
            trigger OnValidate()
            begin
                "Form No." := UpperCase("Form No.");
            end;
        }
        field(39004271; "Society Code"; Code[10])
        {
            // TableRelation = Societies."No.";
            trigger OnValidate()
            begin
                "Society Code" := UpperCase("Society Code");
            end;
        }
        field(39004272; "Mobile Centre"; Code[50])
        {
            trigger OnValidate()
            begin
                "Mobile Centre" := UpperCase("Mobile Centre");
            end;
        }
        field(39004273; "ID Type"; Option)
        {
            OptionCaption = 'National ID,Military ID,Passport,Alien ID';
            OptionMembers = "National ID","Military ID",Passport,"Alien ID";
        }
        field(39004274; "Military ID"; Code[20])
        {
            trigger OnValidate()
            begin
                "Military ID" := UpperCase("Military ID");
            end;
        }
        field(39004278; "KTDA No."; Code[40])
        {
            trigger OnValidate()
            begin
                "KTDA No." := UpperCase("KTDA No.");
            end;
        }
        field(39004279; "Meeting Days"; Text[50])
        {
            trigger OnValidate()
            begin
                "Meeting Days" := UpperCase("Meeting Days");
            end;
        }
        field(39004280; "Meeting Time"; Text[10])
        {
            trigger OnValidate()
            begin
                "Meeting Time" := UpperCase("Meeting Time");
            end;
        }
        field(39004281; "Meeting Venue"; Text[30])
        {
            trigger OnValidate()
            begin
                "Meeting Venue" := UpperCase("Meeting Venue");
            end;
        }
        field(39004282; "Signing Instructions"; Option)
        {
            OptionMembers = "Any Two","Any Three",All;
        }
        field(39004283; "Needs Authorization"; Boolean)
        {
        }
        field(39004284; "Additional BBF"; Integer)
        {
            CalcFormula = Count("Next of KIN" WHERE("Account No" = FIELD("No."), Spouse = CONST(false), Type = CONST("Benevolent Beneficiary")));
            FieldClass = FlowField;
        }
        field(39004285; "Politically Exposed"; Option)
        {
            OptionCaption = ' ,Yes';
            OptionMembers = " ",Yes;
        }
        field(39004286; "Political Position"; Text[50])
        {
            trigger OnValidate()
            begin
                "Political Position" := UpperCase("Political Position");
            end;
        }
        field(39004287; "Search No."; Code[20])
        {
            trigger OnValidate()
            begin
                "Search No." := UpperCase("Search No.");
            end;
        }
        field(39004288; "Dividend Account"; Code[20])
        {
            TableRelation = "Savings Accounts"."No." WHERE("Member No." = FIELD("No."), "Product Category" = FILTER(" "));

            trigger OnValidate()
            begin
                "Dividend Account" := UpperCase("Dividend Account");
            end;
        }
        field(39004289; "Cheques Bounced"; Integer)
        {
            CalcFormula = Count("Cashier Transactions" WHERE("Member No." = FIELD("No."), "Cheque Status" = CONST(Stopped), Posted = CONST(true)));
            FieldClass = FlowField;
        }
        field(39004290; "Agent Mandate"; Text[100])
        {
            trigger OnValidate()
            begin
                "Agent Mandate" := UpperCase("Agent Mandate");
            end;
        }
        field(39004291; "Group Deposits"; Decimal)
        {
            CalcFormula = - Sum("Savings Ledger Entry".Amount WHERE("Member No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(39004292; "Group Loan Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Member No." = FIELD("No."), "Transaction Type" = FILTER(Loan | Repayment)));
            FieldClass = FlowField;
        }
        field(39004293; "Group Interest Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Group Code" = FIELD("No."), "Transaction Type" = FILTER("Interest Due" | "Interest Paid")));
            FieldClass = FlowField;
        }
        field(39004294; "Group Bill Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Group Code" = FIELD("No."), "Transaction Type" = FILTER(Bills)));
            FieldClass = FlowField;
        }
        field(39004295; "Group Appraisal Balance"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Group Code" = FIELD("No."), "Transaction Type" = FILTER("Appraisal Due" | "Appraisal Paid")));
            FieldClass = FlowField;
        }
        field(39004296; "Nominee Card Issued"; Boolean)
        {
        }
        field(39004297; Dividends; Decimal)
        {
            CalcFormula = Sum("Dividend Progression"."Gross Dividends" WHERE("Member No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(39004298; "Sacco CID"; Code[20])
        {
            trigger OnValidate()
            begin
                "Sacco CID" := UpperCase("Sacco CID");
                if "Sacco CID" <> '' then begin
                    Cust.Reset;
                    Cust.SetRange("Sacco CID", "Sacco CID");
                    Cust.SetFilter("No.", '<>%1', "No.");
                    if Cust.FindFirst then Error('CID already Exists with Member No. %1 - %2', Cust."No.", Cust.Name);
                end;
            end;
        }
        field(39004299; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004300; "Tax Waiver End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004301; Rejoined; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004302; "Date Rejoined"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004303; "Last BlackList Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004304; Blacklisted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004305; "No Of Cell Members"; Integer)
        {
            CalcFormula = Count(Members WHERE("Cell Group Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(39004306; Diocese; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Diocese.Code;

            trigger OnValidate()
            begin
                Diocese := UpperCase(Diocese);
            end;
        }
        field(39004307; Parish; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Parish.Code where("Diocese Code" = field(Diocese));

            trigger OnValidate()
            begin
                Parish := UpperCase(Parish);
            end;
        }
        field(39004308; Jumuiya; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Jumuiya.Code where(Diocese = field(Diocese), Parish = field(Parish));

            trigger OnValidate()
            begin
                Jumuiya := UpperCase(Jumuiya);
            end;
        }
        field(39004309; "Is Group Registered"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Yes,No;
        }
        field(39004310; "Catholic Faithful Refferee"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members."No." where("Member Type" = const("Catholic Faithful"));

            trigger OnValidate()
            begin
                "Catholic Faithful Refferee" := UpperCase("Catholic Faithful Refferee");
            end;
        }
        field(39004311; "External Employer Name"; Text[150])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "External Employer Name" := UpperCase("External Employer Name");
                //if "Employer Code" <> '' then
                //   Error('Employer code must not have a value');
            end;
        }
        field(39004312; "Employer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Internal,External;
        }
        field(39004313; "Passport Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004314; "Delegate Member"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Delegate Member" = true then begin
                    "Board Member" := false;
                    "Account Category" := "Account Category"::Delegates;
                end
                else begin
                    "Board Member" := false;
                    "Account Category" := "Account Category"::Member;
                end;
                modify;
            end;
        }
        field(39004315; "Board Member"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Board Member" = true then begin
                    "Delegate Member" := false;
                    "Account Category" := "Account Category"::"Board Members";
                end
                else begin
                    "Delegate Member" := false;
                    "Account Category" := "Account Category"::Member;
                end;
                Modify();
            end;
        }
        field(39004316; "Recovered Guarantors"; Boolean)
        {
        }
        field(39004317; "Has Recovered Loans"; Boolean)
        {
            FieldClass = flowfield;
            CalcFormula = lookup("Loan Recovery Header".Posted where("Member No." = field("No.")));
        }
        field(39004318; "Current Post Code"; Code[30])
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
                SavingAccounts.Reset;
                SavingAccounts.SetFilter(SavingAccounts."Member No.", '<>%1', '');
                SavingAccounts.SetRange(SavingAccounts."Member No.", "No.");
                if SavingAccounts.Find('-') then begin
                    repeat
                    // SavingAccounts.Validate(SavingAccounts."Post Code", "Post Code");
                    // SavingAccounts.Modify;
                    until SavingAccounts.Next = 0;
                end;
                CreditAccounts.Reset;
                CreditAccounts.SetFilter(CreditAccounts."Member No.", '<>%1', '');
                CreditAccounts.SetRange(CreditAccounts."Member No.", "No.");
                if CreditAccounts.Find('-') then begin
                    repeat
                    // CreditAccounts.Validate(CreditAccounts."Post Code", "Post Code");
                    // CreditAccounts.Modify;
                    until CreditAccounts.Next = 0;
                end;
                PostCode.ValidatePostCode(City, "Current Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
    }
    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Payroll/Staff No.")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Payroll/Staff No.", Name, "Old Member No.", "Form No.")
        {
        }
    }
    trigger OnInsert()
    begin
        /*IF "No." = '' THEN BEGIN
          GeneralSetUp.GET();
          IF GeneralSetUp."BaseMember Nos. on MemberClass"=TRUE THEN
            BEGIN
          MemberCategory.RESET;
          MemberCategory.SETRANGE("No.",xRec."Member Category");
          IF MemberCategory.FIND('-') THEN
            BEGIN
              MemberCategory.TESTFIELD(MemberCategory."Member Nos.");
              NoSeriesMgt.InitSeries(MemberCategory."Member Nos.",xRec."No. Series",0D,"No.","No. Series");
              END ELSE
              BEGIN
          SeriesSetup.GET;
          SeriesSetup.TESTFIELD(SeriesSetup."Member Nos.");
          NoSeriesMgt.InitSeries(SeriesSetup."Member Nos.",xRec."No. Series",0D,"No.","No. Series");
          END;
          END ELSE
          BEGIN
          SeriesSetup.GET;
          SeriesSetup.TESTFIELD(SeriesSetup."Member Nos.");
          NoSeriesMgt.InitSeries(SeriesSetup."Member Nos.",xRec."No. Series",0D,"No.","No. Series");
            END;
        END;
        */
        if "No." = '' then begin
            if "Customer Type" <> "Customer Type"::Cell then begin
                SeriesSetup.Get;
                case "Customer Type" of
                    "Customer Type"::Joint:
                        begin
                            SeriesSetup.TestField(SeriesSetup."Joint Nos.");
                            NoSeriesMgt.InitSeries(SeriesSetup."Joint Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                        end;
                    "Customer Type"::Single:
                        begin
                            SeriesSetup.TestField(SeriesSetup."Member Nos.");
                            NoSeriesMgt.InitSeries(SeriesSetup."Member Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                        end;
                    "Customer Type"::"Group":
                        begin
                            SeriesSetup.TestField(SeriesSetup."Group Nos.");
                            NoSeriesMgt.InitSeries(SeriesSetup."Group Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                        end;

                end;

            end
            else
                if "Customer Type" = "Customer Type"::Cell then begin
                    SeriesSetup.Get;
                    SeriesSetup.TestField(SeriesSetup."Cell Group Nos");
                    NoSeriesMgt.InitSeries(SeriesSetup."Cell Group Nos", xRec."No. Series", 0D, "No.", "No. Series");
                end;
        end;
        "Created By" := UserId;
        "Last Date Modified" := Today;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SavingAccounts: Record "Savings Accounts";
        CreditAccounts: Record "Credit Accounts";
        CountryRegion: Record "Country/Region";
        LoanApps: Record Loans;
        Cust: Record Members;
        MemberExistError: Label 'Already exists with member %1 Name: %2';
        PostCode: Record "Post Code";
        CheckoffAdviceLine: Record "Checkoff Advice Line";
        BuyingCentre: Record "Electrol Zones/Area Svr Center";
        MemberCategory: Record "Member Category";
        GeneralSetUp: Record "General Set-Up";
        //SaccoTrans: Codeunit "Sacco Transactions";
        SourceType: Option "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application","Loan Witness";
        //SendSMS: Codeunit SendSms;
        //SMTPMail: Codeunit "SMTP Mail";
        Emp: Record Customer;

    procedure TestNoEntriesExist(CurrentFieldName: Text[100];
    GLNO: Code[20])
    var
        MemberLedgEntry: Record "Cust. Ledger Entry";
        Text000: Label 'l';
    begin
        //To prevent change of field
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Customer No.");
        MemberLedgEntry.SetRange(MemberLedgEntry."Customer No.", "No.");
        if MemberLedgEntry.Find('-') then Error(Text000, CurrentFieldName);
    end;

    procedure FieldLength(VarVariant: Text;
    FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        /*IF STRLEN(VarVariant) > FldLength THEN
              ERROR(FieldLengthError,FldLength);
              */
    end;

    procedure SendRecords()
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
        ReportDistributionManagement: Codeunit "Report Distribution Management";
    begin
        /*
            DocumentSendingProfile.GetDefaultForCustomer("No.",DocumentSendingProfile);
            COMMIT;

            TempDocumentSendingProfile.INIT;
            TempDocumentSendingProfile.Code := DocumentSendingProfile.Code;
            TempDocumentSendingProfile.VALIDATE("One Related Party Selected",IsSingleCustomerSelected);
            TempDocumentSendingProfile.SetDocumentUsage(Rec);
            TempDocumentSendingProfile.INSERT;

            IF PAGE.RUNMODAL(PAGE::"Select Sending Options",TempDocumentSendingProfile) = ACTION::LookupOK THEN BEGIN
              CheckDocumentSendingProfileIsSupported(TempDocumentSendingProfile);
              ReportDistributionManagement.SendDocumentReport(TempDocumentSendingProfile,Rec);
            END;
            */
    end;

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
        ReportDistributionManagement: Codeunit "Report Distribution Management";
    begin
        /*
            TempDocumentSendingProfile.INIT;

            IF ShowRequestForm THEN
              TempDocumentSendingProfile.Printer := TempDocumentSendingProfile.Printer::"Yes (Prompt for Settings)"
            ELSE
              TempDocumentSendingProfile.Printer := TempDocumentSendingProfile.Printer::"Yes (Use Default Settings)";

            TempDocumentSendingProfile.INSERT;

            ReportDistributionManagement.SendDocumentReport(TempDocumentSendingProfile,Rec);
            */
    end;

    procedure EmailRecords(ShowRequestForm: Boolean)
    var
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
        ReportDistributionManagement: Codeunit "Report Distribution Management";
    begin
        /*
            TempDocumentSendingProfile.INIT;

            IF ShowRequestForm THEN
              TempDocumentSendingProfile."E-Mail" := TempDocumentSendingProfile."E-Mail"::"Yes (Prompt for Settings)"
            ELSE
              TempDocumentSendingProfile."E-Mail" := TempDocumentSendingProfile."E-Mail"::"Yes (Use Default Settings)";

            TempDocumentSendingProfile."E-Mail Attachment" := TempDocumentSendingProfile."E-Mail Attachment"::PDF;

            TempDocumentSendingProfile.INSERT;

            ReportDistributionManagement.SendDocumentReport(TempDocumentSendingProfile,Rec);
            */
    end;

    local procedure IsSingleCustomerSelected(): Boolean
    var
        SelectedCount: Integer;
        CustomerCount: Integer;
        BillToCustomerNoFilter: Text;
    begin
        SelectedCount := Count;
        if SelectedCount < 1 then exit(false);
        if SelectedCount = 1 then exit(true);
        BillToCustomerNoFilter := GetFilter("No.");
        SetRange("No.", "No.");
        CustomerCount := Count;
        SetFilter("No.", BillToCustomerNoFilter);
        exit(SelectedCount = CustomerCount);
    end;

    local procedure CheckDocumentSendingProfileIsSupported(var TempDocumentSendingProfile: Record "Document Sending Profile" temporary)
    var
        CannotSendMultipleStatementsElectronicallyErr: Label 'You can only send one electronic statements at a time.';
    begin
        if (Count > 1) and (TempDocumentSendingProfile."Electronic Document" <> TempDocumentSendingProfile."Electronic Document"::No) then Error(CannotSendMultipleStatementsElectronicallyErr);
    end;

    procedure HasPermission()
    var
        SChange: Record "Status Change Permissions";
        PermErr: Label 'You do not have permissions to view this account';
    begin
        if Rec."Account Category" = Rec."Account Category"::"Staff Members" then begin
            SChange.RESET;
            Schange.Setrange("User ID", UserID);
            if Schange.find('-') then begin
                if SChange."View Staff A/C" = False then
                    Error(PermErr);
            end;
        end;
    end;

    procedure GetSavingsBalance(ProdFilter: Code[50]): Decimal
    var
        SavAcc: Record "Savings Accounts";
        Loans: Record Loans;
        Bal: Decimal;
    begin
        Clear(Bal);
        SavAcc.RESET;
        SavAcc.setrange("Member No.", Rec."No.");
        if ProdFilter <> '' then
            SavAcc.SETFILTER("Product Type", ProdFilter);
        if SavAcc.FIND('-') then begin
            repeat
                SavAcc.CALCFIELDS("Balance", "Balance (Lcy)");
                Bal += SavAcc."Balance (Lcy)";
            until SavAcc.next = 0;
        end;
        exit(Bal);
    end;

    procedure GetLoansBalance(ProdFilter: Code[50]): Decimal
    var
        SavAcc: Record "Savings Accounts";
        Loans: Record Loans;
        Bal: Decimal;
    begin
        Clear(Bal);
        Loans.RESET;
        Loans.setrange("Member No.", Rec."No.");
        if ProdFilter <> '' then
            Loans.SETFILTER("Loan Product Type", ProdFilter);
        if Loans.FIND('-') then begin
            repeat
                Loans.CALCFIELDS("Outstanding Balance", "Outstanding Interest");
                Bal += Loans."Outstanding Balance" + Loans."Outstanding Interest";
            until Loans.next = 0;
        end;
        exit(Bal);
    end;
}
