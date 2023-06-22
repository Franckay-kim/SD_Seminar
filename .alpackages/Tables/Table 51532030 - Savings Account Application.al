/// <summary>
/// Table Savings Account Application (ID 51532030).
/// </summary>
table 51532030 "Savings Account Application"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            SQLDataType = Varchar;

            trigger OnValidate()
            begin
                "No." := UpperCase("No.");
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Accounts Application");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                Name := UpperCase(Name);
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[50])
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
            end;
        }
        field(5; "Current Address"; Text[50])
        {
            Caption = 'Address';
            trigger OnValidate()

            begin
                "Current Address" := UpperCase("Current Address");
            end;
        }
        field(6; City; Text[30])
        {
            Caption = 'City';



            trigger OnValidate()
            begin
                City := UpperCase(City);
                //PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(7; Contact; Text[50])
        {
            Caption = 'Contact';
            trigger OnValidate()

            begin
                Contact := UpperCase(Contact);
            end;
        }
        field(8; "Alternative Phone No. 1"; Text[30])
        {
            Caption = 'Phone No.';
            CharAllowed = '0123456789';
            ExtendedDatatype = PhoneNo;
            trigger OnValidate()
            begin
                "Alternative Phone No. 1" := UpperCase("Alternative Phone No. 1");
            end;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                "Global Dimension 1 Code" := UpperCase("Global Dimension 1 Code");
                //ValidateShortcutDimCode(1,Blocked);
            end;
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                "Global Dimension 2 Code" := UpperCase("Global Dimension 2 Code");
                //ValidateShortcutDimCode(2,"Last Date Modified");
            end;
        }
        field(11; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
            trigger OnValidate()
            begin
                "Customer Posting Group" := UpperCase("Customer Posting Group");

            end;
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            trigger OnValidate()
            begin
                "Currency Code" := UpperCase("Currency Code");

            end;
        }
        field(13; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
            Description = 'LookUp to Salesperson/Purchaser Table';
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

            end;
        }
        field(14; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                "Country/Region Code" := UpperCase("Country/Region Code");
                if CountryRegion.Get("Country/Region Code") then
                    "Mobile Phone No" := CountryRegion.Code;
            end;
        }
        field(15; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Customer),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ",Credit,Debit,All;
        }
        field(17; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(18; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(19; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(20; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(21; Membership; Option)
        {
            OptionCaption = ' ,Ordinary,Preferential';
            OptionMembers = " ",Ordinary,Preferential;
        }
        field(22; "Account Category"; Option)
        {
            OptionCaption = 'Member, Staff Account,Board Members,Delegates';
            OptionMembers = Member," Staff Account","Board Members",Delegates;
        }
        field(23; "Member No."; Code[20])
        {
            Caption = 'Member No';
            TableRelation = Members."No.";

            trigger OnValidate()
            begin
                "Member No." := UpperCase("Member No.");
                MultipleAccountCreation;

                if Cust.Get("Member No.") then begin


                    if Cust.Status <> Cust.Status::Active then
                        Error('Member is not Active');

                    case "Product Category" of
                        "Product Category"::"Junior Savings":
                            begin
                                Name := UpperCase(Cust."First Name" + ' ' + Cust."Second Name" + ' ' + Cust."Last Name");
                                "Search Name" := UpperCase(Cust."Search Name");
                                Gender := Gender::" ";

                                if "Product Category" = "Product Category"::"Junior Savings" then begin
                                    SavingsAccount.Reset;
                                    SavingsAccount.SetRange("Member No.", "Member No.");
                                    //SavingsAccount.SETRANGE("Loan Disbursement Account",TRUE);
                                    if SavingsAccount.Find('-') then
                                        "Parent Account No." := UpperCase(SavingsAccount."No.");
                                end
                            end;
                        "Product Category"::" ", "Product Category"::"Deposit Contribution", "Product Category"::"Fixed Deposit",
                        "Product Category"::"Share Capital":
                            begin
                                Name := UpperCase(Cust."First Name" + ' ' + Cust."Second Name" + ' ' + Cust."Last Name");
                                "Search Name" := UpperCase(Cust."Search Name");
                                Gender := Cust.Gender;
                            end;
                    end;
                    Name := UpperCase(Cust.Name);
                    "Current Address" := UpperCase(Cust."Current Address");
                    "Payroll/Staff No." := UpperCase(Cust."Payroll/Staff No.");
                    "Employer Code" := UpperCase(Cust."Employer Code");
                    "Alternative Phone No. 1" := UpperCase(Cust."Alternative Phone No. 1");
                    "Alternative Phone No. 2" := UpperCase(Cust."Alternative Phone No. 2");
                    "Post Code" := UpperCase(Cust."Post Code");
                    "Country/Region Code" := UpperCase(Cust.Nationality);
                    County := UpperCase(Cust.County);
                    "Passport No." := UpperCase(Cust."Passport No.");
                    "E-Mail" := UpperCase(Cust."E-Mail");
                    "Sacco CID" := UpperCase(Cust."Sacco CID");
                    "Mobile Phone No" := UpperCase(Cust."Mobile Phone No");
                    "Politically Exposed" := Cust."Politically Exposed";
                    "ID No." := UpperCase(Cust."ID No.");
                    "Group Account" := Cust."Group Account";
                    "Group Code" := UpperCase(Cust."Group Code");
                    "Date of Birth" := Cust."Date of Birth";
                    "Marital Status" := Cust."Marital Status";
                    "Account Type" := Cust."Account Type";
                    "Relates to Business/Group" := Cust."Relates to Business/Group";
                    //"Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    //"Global Dimension 2 Code":=Cust."Global Dimension 2 Code";
                    "Type of Business" := Cust."Type of Business";
                    "Other Business Type" := UpperCase(Cust."Other Business Type");
                    "Member Category" := UpperCase(Cust."Member Category");
                    Validate("Member Category");

                    MemberCategory.Reset;
                    MemberCategory.SetRange("No.", "Member Category");
                    if MemberCategory.Find('-') then begin
                        if "Product Category" = "Product Category"::"Registration Fee" then
                            "Monthly Contribution" := MemberCategory."Registration Fee"
                        else
                            if "Product Category" = "Product Category"::"Share Capital" then
                                "Monthly Contribution" := MemberCategory."Monthly Share Capital"
                            else
                                if "Product Category" = "Product Category"::"Deposit Contribution" then
                                    "Monthly Contribution" := MemberCategory."Monthly Share Deposit";
                    end;
                end;
            end;
        }
        field(24; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                "Post Code" := UpperCase("Post Code");
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(25; County; Text[30])
        {
            Caption = 'County';
            trigger OnValidate()

            begin
                County := UpperCase(County);
            end;
        }
        field(26; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
            trigger OnValidate()

            begin
                "E-Mail" := UpperCase("E-Mail");
            end;
        }
        field(27; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(29; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;

        }
        field(30; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";
            trigger OnValidate()

            begin
                "Responsibility Center" := UpperCase("Responsibility Center");
            end;
        }
        field(31; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
            trigger OnValidate()

            begin
                "Base Calendar Code" := UpperCase("Base Calendar Code");
            end;
        }
        field(32; "Transaction Mobile No"; Code[20])
        {
            CharAllowed = '0123456789';
            Description = 'MPESA Mobile No';

            trigger OnValidate()
            begin
                "Transaction Mobile No" := UpperCase("Transaction Mobile No");
                /*IF STRLEN("Transaction Mobile No") > 13 THEN BEGIN
                "Transaction Mobile No":='';
                END;*/

            end;
        }
        field(33; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Approved,Rejected,Created';
            OptionMembers = Open,Pending,Approved,Rejected,Created;
        }
        field(34; "Employer Code"; Code[50])
        {
            trigger OnValidate()

            begin
                "Employer Code" := UpperCase("Employer Code");
            end;
        }
        field(35; "Date of Birth"; Date)
        {

            trigger OnValidate()
            begin
                if "Date of Birth" > Today then
                    Error(DateofBirthError);
            end;
        }
        field(36; "Home Address"; Text[50])
        {
            trigger OnValidate()

            begin
                "Home Address" := UpperCase("Home Address");
            end;
        }
        field(37; "Payroll/Staff No."; Code[20])
        {

            trigger OnValidate()
            begin
                "Payroll/Staff No." := UpperCase("Payroll/Staff No.");
                if "Payroll/Staff No." <> '' then begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."Employer Code", "Employer Code");
                    SavingsAccounts.SetRange(SavingsAccounts."Payroll/Staff No.", "Payroll/Staff No.");
                    if SavingsAccounts.FindFirst then
                        Error(AccountExistsError, SavingsAccounts."No.", SavingsAccounts.Name);
                end;
            end;
        }
        field(38; "ID No."; Code[50])
        {

            trigger OnValidate()
            begin
                "ID No." := UpperCase("ID No.");
                //"ID No.":=DELCHR("ID No.",'=','A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?');


                GeneralSetUp.Get;
                GeneralSetUp.TestField("ID Character Limit");
                if StrLen("ID No.") > GeneralSetUp."ID Character Limit" then
                    Error('ID Number must be less than or equal to %1 digits', GeneralSetUp."ID Character Limit");


                if "ID No." <> '' then begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."ID No.", "ID No.");
                    if SavingsAccounts.FindFirst then
                        Error(AccountExistsError, SavingsAccounts."No.", SavingsAccounts.Name);
                end;
            end;
        }
        field(39; "Mobile Phone No"; Code[50])
        {
            CharAllowed = '0123456789';

            trigger OnValidate()
            begin
                "Mobile Phone No" := UpperCase("Mobile Phone No");
                //TESTFIELD("Country/Region Code");
            end;
        }
        field(40; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Divorced,Widower,Widow;
        }
        field(41; "Passport No."; Code[50])
        {

            trigger OnValidate()
            begin
                "Passport No." := UpperCase("Passport No.");
                if "Passport No." <> '' then begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."Passport No.", "Passport No.");
                    if SavingsAccounts.FindFirst then
                        Error(AccountExistsError, SavingsAccounts."No.", SavingsAccounts.Name);
                end;
            end;
        }
        field(42; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(44; "Type Of Organisation"; Option)
        {
            OptionCaption = ' ,Club,Association,Partnership,Investment,Merry go round,Other,Group';
            OptionMembers = " ",Club,Association,Partnership,Investment,"Merry go round",Other,Group;
        }
        field(45; "Group Account No"; Code[20])
        {
            Description = 'Check Relation';
            TableRelation = Members WHERE("Group Account" = FILTER(true),
                                           "Customer Type" = CONST(Microfinance));

            trigger OnValidate()
            begin
                "Group Account No" := UpperCase("Group Account No");
                Members.Get("Group Account No");
                "Group Name" := Members.Name;
            end;
        }
        field(46; "Group Account"; Boolean)
        {
        }
        field(47; "Product Type"; Code[20])
        {
            Description = 'LookUp into Product Factory Table';
            TableRelation = "Product Factory" WHERE("Product Class Type" = CONST(Savings),
                                                     Status = CONST(Active));

            trigger OnValidate()
            var
                ProductApplicationDocuments: Record "Product Documents";
                ApplicationDocuments: Record "Application Documents";
                ApplicableCategories: Record "Product Applicable Categories";
                MemAcc: Record Members;
                AccTypeErr: Label 'This product is not applicable for this member type';
            begin

                "Product Type" := UpperCase("Product Type");
                MemAcc.RESET;
                MemAcc.Setrange("No.", "Member No.");
                IF MemAcc.FINDFIRST THEN BEGIN

                    ApplicableCategories.RESET;
                    ApplicableCategories.SETRANGE("Product ID", "Product Type");
                    ApplicableCategories.setrange("Member Account Category", MemAcc."Single Party/Multiple");
                    IF ApplicableCategories.FindFirst() = false then
                        Error(AccTypeErr);
                END;
                MultipleAccountCreation;

                if ProductFactory.Get("Product Type") then begin
                    MemberCategory.Reset;
                    MemberCategory.SetRange(MemberCategory."No.", ProductFactory."Member Category");
                    if MemberCategory.Find('-') then begin
                        Cust.SetRange("No.", "Member No.");
                        if Cust.Find('-') then begin
                            Sav.Reset;
                            Sav.SetRange(Sav."Member No.", Cust."No.");
                            Sav.SetRange(Sav."Product Category", Sav."Product Category"::"Deposit Contribution");
                            if Sav.Find('-') then begin
                                Sav.CalcFields(Balance, "Balance (LCY)");
                                if Sav."Balance (LCY)" < MemberCategory."Premier Club Min.Deposits" then
                                    Error('This member has deposits of %1 less than %2 required to Join %3', Sav.Balance, MemberCategory."Premier Club Min.Deposits", MemberCategory."No.");
                            end;
                        end;
                    end;


                    "Product Name" := UpperCase(ProductFactory."Product Description");
                    "Monthly Contribution" := ProductFactory."Minimum Contribution";
                    "Minimum Contribution" := ProductFactory."Minimum Contribution";
                    "Customer Posting Group" := UpperCase(ProductFactory."Product Posting Group");
                    "Product Category" := ProductFactory."Product Category";
                    "Can Guarantee Loan" := ProductFactory."Can Guarantee Loan";
                    "Loan Disbursement Account" := ProductFactory."Loan Disbursement Account";
                    "Global Dimension 1 Code" := ProductFactory."Global Dimension 1 Code";



                    ApplicationDocuments.Reset;
                    ApplicationDocuments.SetFilter(ApplicationDocuments."Reference No.", '%1', "No.");
                    if ApplicationDocuments.Find('-') then
                        ApplicationDocuments.DeleteAll;

                    ProductApplicationDocuments.Reset;
                    ProductApplicationDocuments.SetRange(ProductApplicationDocuments."Product ID", ProductFactory."Product ID");
                    if ProductApplicationDocuments.Find('-') then begin
                        repeat
                            ApplicationDocuments.Init;
                            ApplicationDocuments."Reference No." := "No.";
                            ApplicationDocuments.Validate(ApplicationDocuments."Document No.", ProductApplicationDocuments."Document No.");
                            ApplicationDocuments.Validate(ApplicationDocuments."Product ID", "Product Type");
                            ApplicationDocuments."Product Name" := UpperCase(ProductFactory."Product Description");
                            ApplicationDocuments."Document Type" := ProductApplicationDocuments."Document Type";
                            ApplicationDocuments.Insert;
                        until ProductApplicationDocuments.Next = 0;
                    end;

                    if "Product Category" = "Product Category"::"Junior Savings" then begin
                        SavingsAccount.Reset;
                        SavingsAccount.SetRange("Member No.", "Member No.");
                        SavingsAccount.SetRange("Product Category", SavingsAccount."Product Category"::" ");
                        if SavingsAccount.Find('-') then
                            "Parent Account No." := SavingsAccount."No.";
                        "Date of Birth" := 0D;
                    end else begin
                        if Cust.Get("Member No.") then begin
                            "Parent Account No." := '';
                            Name := UpperCase(Cust.Name);
                            "Date of Birth" := Cust."Date of Birth";
                        end;
                    end;
                end;
            end;
        }
        field(48; "Product Name"; Text[50])
        {
            Editable = false;
            trigger OnValidate()

            begin
                "Product Name" := UpperCase("Product Name");
            end;
        }
        field(49; "Can Guarantee Loan"; Boolean)
        {
        }
        field(50; "Loan Disbursement Account"; Boolean)
        {
        }
        field(51; "Loan Security Inclination"; Option)
        {
            OptionCaption = ' ,Short Loan Security,Long Term Loan Security,Share Capital';
            OptionMembers = " ","Short Term Loan Security","Long Term Loan Security","Share Capital";
        }
        field(52; "Fixed Deposit Status"; Option)
        {
            OptionCaption = ' ,Active,Matured,Closed,Not Matured';
            OptionMembers = " ",Active,Matured,Closed,"Not Matured";
        }
        field(53; "Relates to Business/Group"; Boolean)
        {
        }
        field(54; "Company Registration No."; Code[20])
        {
            trigger OnValidate()

            begin
                "Company Registration No." := UpperCase("Company Registration No.");
            end;
        }
        field(55; "Birth Certificate No."; Code[20])
        {

            trigger OnValidate()
            begin
                "Birth Certificate No." := UpperCase("Birth Certificate No.");
                if "Birth Certificate No." <> '' then begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."Birth Certificate No.", "Birth Certificate No.");
                    if SavingsAccounts.FindFirst then
                        Error(AccountExistsError, SavingsAccounts."No.", SavingsAccounts.Name);
                end;
            end;
        }
        field(56; "Created By"; Code[50])
        {
            trigger OnValidate()

            begin
                "Created By" := UpperCase("Created By");
            end;
        }

        field(57; "Group Code"; Code[10])
        {
            trigger OnValidate()

            begin
                "Group Code" := UpperCase("Group Code");
            end;
        }
        field(58; "Registration Date"; Date)
        {
        }
        field(59; "FD Marked for Closure"; Boolean)
        {
        }
        field(60; "Expected Maturity Date"; Date)
        {
        }
        field(61; "Savings Account No."; Code[20])
        {
            Description = 'LookUp to Savings Account Table';
            TableRelation = "Savings Accounts" WHERE("Member No." = FIELD("Member No."),
                                                      "Product Category" = FILTER(Prime));
            trigger OnValidate()

            begin
                "Savings Account No." := UpperCase("Savings Account No.");
            end;

        }
        field(62; "Parent Account No."; Code[20])
        {
            Description = 'LookUp to Member Table';
            TableRelation = "Savings Accounts" WHERE("Member No." = FIELD("Member No."),
                                                      "Product Category" = FILTER(" "));
            trigger OnValidate()

            begin
                "Parent Account No." := UpperCase("Parent Account No.");
            end;
        }
        field(64; "Fixed Deposit Type"; Code[20])
        {
            Description = 'LookUp to Fixed Deposit Type Table';
            TableRelation = "Fixed Deposit Type" WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin
                "Fixed Deposit Type" := UpperCase("Fixed Deposit Type");
                TestField("Application Date");
                TestField("FD Start Date");

                if FixedDepositType.Get("Fixed Deposit Type") then begin
                    "FD Maturity Date" := CalcDate(FixedDepositType.Duration, "FD Start Date");
                    //"FD Duration" := FixedDepositType."No. of Months";
                    "Product Category" := "Product Category"::"Fixed Deposit";
                    FDCalcRules.Reset;
                    FDCalcRules.SetRange(Code, "Fixed Deposit Type");
                    if FDCalcRules.Find('-') then begin
                        repeat
                            if FDCalcRules."Allowed Margin" <> 0 then begin
                                if ("Fixed Deposit Amount" >= FDCalcRules."Minimum Amount") and ("Fixed Deposit Amount" <= FDCalcRules."Maximum Amount") then
                                    if ("Neg. Interest Rate" > (FDCalcRules."Interest Rate" + FDCalcRules."Allowed Margin")) or
                                       ("Neg. Interest Rate" < (FDCalcRules."Interest Rate" - FDCalcRules."Allowed Margin")) then
                                        "Neg. Interest Rate" := FDCalcRules."Interest Rate";
                            end;
                        until
                        FDCalcRules.Next = 0;
                    end;
                end;

                Validate("FD Maturity Instructions");
            end;
        }
        field(65; "FD Maturity Date"; Date)
        {
        }
        field(66; "Monthly Contribution"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Monthly Contribution" < "Minimum Contribution" then
                    Error('Contribution cannot be less than the Minimum required of KES %1', "Minimum Contribution");
            end;
        }
        field(67; "Force No."; Code[20])
        {
            trigger OnValidate()

            begin
                "Force No." := UpperCase("Force No.");
            end;
        }
        field(69; "Product Category"; Option)
        {
            OptionCaption = ' ,Share Capital,Main Shares,Fixed Deposit,Junior Savings,Registration Fee,Benevolent,Unallocated Fund,Micro Credit Deposits,NHIF,Corp,School Fee,Dividend,Joint,Redeemable,KUSCCO,Housing,Creditor,Prime';
            OptionMembers = " ","Share Capital","Deposit Contribution","Fixed Deposit","Junior Savings","Registration Fee",Benevolent,"Unallocated Fund","Micro Credit Deposits",NHIF,Corp,"School Fee",Dividend,Joint,Redeemable,KUSCCO,Housing,Creditor,Prime;
        }
        field(70; "Neg. Interest Rate"; Decimal)
        {

            trigger OnValidate()
            begin
                FDCalcRules.Reset;
                FDCalcRules.SetRange(Code, "Fixed Deposit Type");
                if FDCalcRules.Find('-') then begin
                    repeat
                        if FDCalcRules."Allowed Margin" <> 0 then begin
                            if ("Fixed Deposit Amount" >= FDCalcRules."Minimum Amount") and ("Fixed Deposit Amount" <= FDCalcRules."Maximum Amount") then
                                if ("Neg. Interest Rate" > (FDCalcRules."Interest Rate" + FDCalcRules."Allowed Margin")) or
                                   ("Neg. Interest Rate" < (FDCalcRules."Interest Rate" - FDCalcRules."Allowed Margin")) then
                                    Error('The negotiated rate must be within the allowed margin of %1', FDCalcRules."Allowed Margin");
                        end;
                    until
                    FDCalcRules.Next = 0;
                end;
            end;
        }
        field(71; "FD Duration"; DateFormula)
        {

            trigger OnValidate()
            begin
                "FD Maturity Date" := CalcDate("FD Duration", "Application Date");
            end;
        }
        field(72; "FD Maturity Instructions"; Option)
        {
            OptionCaption = ' ,Transfer all to Savings,Renew Principal,Renew Principal & Interest';
            OptionMembers = " ","Transfer all to Savings","Renew Principal","Renew Principal & Interest";

            trigger OnValidate()
            begin

                if FixedDepositType.Get("Fixed Deposit Type") then begin
                    if FixedDepositType."Call Deposit" then begin
                        if "FD Maturity Instructions" = "FD Maturity Instructions"::"Renew Principal & Interest" then
                            Error('This option is not applicable to call deposits');
                    end;
                end;
            end;
        }
        field(73; "Fixed Deposit cert. no"; Code[30])
        {
            Description = 'Capture FxD certificate Number';
            trigger OnValidate()

            begin
                "Fixed Deposit cert. no" := UpperCase("Fixed Deposit cert. no");
            end;
        }
        field(75; "Group Type"; Option)
        {
            OptionCaption = ' ,Welfare,Microfinance';
            OptionMembers = " ",Welfare,Microfinance;
        }
        field(76; "Application Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Application Date" > Today then
                    Error(DateofBirthError);
            end;
        }
        field(77; "Account Type"; Option)
        {
            OptionCaption = ' ,Savings Account,Personal Savings,Microfinance Savings,Salary Account,Share Deposit Account,Fixed Deposit Account,Others(Specify)';
            OptionMembers = " ","Savings Account","Personal Savings","Microfinance Savings","Salary Account","Share Deposit Account","Fixed Deposit Account","Others(Specify)";
        }
        field(78; "Other Business Type"; Text[15])
        {
        }
        field(80; "Type of Business"; Option)
        {
            OptionCaption = ' ,Sole Proprietor,Paerneship,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor",Paerneship,"Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
        }
        field(81; "P.I.N Number"; Code[20])
        {

            trigger OnValidate()
            begin
                "P.I.N Number" := UpperCase("P.I.N Number");
                FieldLength("P.I.N Number", 15);

                if "P.I.N Number" <> '' then begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange(SavingsAccounts."ID No.", "ID No.");
                    if SavingsAccounts.FindFirst then
                        Error(AccountExistsError, SavingsAccounts."No.", SavingsAccounts.Name);
                end;
            end;
        }
        field(82; Source; Option)
        {
            Description = 'Used to identify origin of Member Application [CRM, Navision, Web]';
            OptionCaption = ' ,Navision,CRM,Web,Agency';
            OptionMembers = " ",Navision,CRM,Web,Agency;
        }
        field(83; "Fixed Deposit Amount"; Decimal)
        {
        }
        field(84; Picture; BLOB)
        {
            Caption = 'Picture';
            Description = 'Used to capture applicant Photos and should be deleted on account creation.';
            SubType = Bitmap;
        }
        field(85; Signature; BLOB)
        {
            Caption = 'Signature';
            Description = 'Used to capture applicant Signature and should be deleted on account creation.';
            SubType = Bitmap;
        }
        field(86; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";

            trigger OnValidate()
            var
                Sav: Record "Savings Accounts";
                Cust: Record Members;
                Product: Record "Product Factory";
                MemberCategory: Record "Member Category";
            begin
                "Member Category" := UpperCase("Member Category");
                MemberCategory.Reset;
                MemberCategory.SetRange("No.", "Member Category");
                if MemberCategory.Find('-') then begin
                    //IF "Account Type"="Account Type"::"Savings Account" THEN
                    //  BEGIN
                    // MESSAGE(MemberCategory."No.");

                    Cust.SetRange("No.", "Member No.");
                    if Cust.Find('-') then begin
                        Sav.Reset;
                        Sav.SetRange(Sav."Member No.", Cust."No.");
                        Sav.SetRange(Sav."Product Category", Sav."Product Category"::"Deposit Contribution");
                        if Sav.Find('-') then begin
                            Sav.CalcFields(Balance, "Balance (LCY)");
                            if Sav."Balance (LCY)" < MemberCategory."Premier Club Min.Deposits" then begin
                                if MemberCategory."Premier Club Min.Deposits" <> 0 then
                                    Error('This member has deposits of %1 less than %2 required to Join %3', Sav.Balance, MemberCategory."Premier Club Min.Deposits", MemberCategory."No.");
                            end;
                        end;
                        //   END;
                    end;
                end;
            end;
        }
        field(90; "Recruited by Type"; Option)
        {
            OptionCaption = 'Marketer,Office,Staff,Board Member,Member';
            OptionMembers = Marketer,Office,Staff,"Board Member",Member;

            trigger OnValidate()
            begin
                "Recruited By" := '';
                "Recruited By Name" := '';
            end;
        }
        field(50004; "Relationship Manager"; Code[10])
        {
            TableRelation = "HR Employees" WHERE(Status = FILTER(Active));
            trigger OnValidate()

            begin
                "Relationship Manager" := UpperCase("Relationship Manager");
            end;
        }
        field(50005; "Statement E-Mail Freq."; DateFormula)
        {
        }
        field(50006; "Signing Instructions"; Option)
        {
            OptionMembers = "Any Two","Any Three",All;
        }
        field(39004242; Classification; Option)
        {
            OptionCaption = ' ,Good Standing,Bad Standing';
            OptionMembers = " ","Good Standing","Bad Standing";
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
        field(39004249; "CRM Application No."; Code[50])
        {
            TableRelation = "CRM Application"."No." WHERE("Application Type" = CONST("Savings Account"),
                                                           "Approval Status" = FILTER(Deffered | Open),
                                                           Created = CONST(false),
                                                           Case360_Docs = CONST(1));

            trigger OnValidate()
            begin
                "CRM Application No." := UpperCase("CRM Application No.");
                if CRMApplication.Get("CRM Application No.") then begin
                    "Product Type" := UpperCase(CRMApplication."Product Factory");
                    Validate("Product Type");
                    "Member No." := UpperCase(CRMApplication."Member No.");
                    Validate("Member No.");
                end;
            end;
        }
        field(39004250; "Customer CID"; Code[20])
        {
            trigger OnValidate()

            begin
                "Customer CID" := UpperCase("Customer CID");
            end;
        }
        field(39004251; "Info Base Area"; Text[250])
        {
            trigger OnValidate()

            begin
                "Info Base Area" := UpperCase("Info Base Area");
            end;
        }
        field(39004252; "Group Name"; Text[100])
        {
            Editable = false;
            trigger OnValidate()

            begin
                "Group Name" := UpperCase("Group Name");
            end;
        }
        field(39004253; "ID Type"; Option)
        {
            OptionCaption = 'National ID,Military ID,Passport,Alien ID';
            OptionMembers = "National ID","Military ID",Passport,"Alien ID";
        }
        field(39004254; "Military ID"; Code[20])
        {
            trigger OnValidate()

            begin
                "Military ID" := UpperCase("Military ID");
            end;
        }
        field(39004255; "Alternative Phone No. 2"; Code[13])
        {
            trigger OnValidate()

            begin
                "Alternative Phone No. 2" := UpperCase("Alternative Phone No. 2");
            end;
        }
        field(39004278; "KTDA No."; Code[10])
        {
            trigger OnValidate()

            begin
                "KTDA No." := UpperCase("KTDA No.");
            end;
        }
        field(39004279; "Politically Exposed"; Option)
        {
            OptionCaption = ' ,Yes';
            OptionMembers = " ",Yes;
        }
        field(39004280; "Political Position"; Text[50])
        {
            trigger OnValidate()

            begin
                "Political Position" := UpperCase("Political Position");
            end;
        }
        field(39004281; "Search No."; Code[20])
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
        field(39004286; "Recruited By Name"; Text[100])
        {
            Editable = false;
            trigger OnValidate()

            begin
                "Recruited By Name" := UpperCase("Recruited By Name");
            end;
        }
        field(39004293; "Child Name"; Text[150])
        {
            trigger OnValidate()

            begin
                "Child Name" := UpperCase("Child Name");
            end;
        }
        field(39004294; "Sacco CID"; Code[20])
        {
            trigger OnValidate()

            begin
                "Sacco CID" := UpperCase("Sacco CID");
            end;
        }
        field(39004295; "FD Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if "FD Start Date" <> 0D then begin
                    TestField("FD Start Date");

                    if "Fixed Deposit Type" <> '' then
                        if FixedDepositType.Get("Fixed Deposit Type") then begin
                            "FD Maturity Date" := CalcDate(FixedDepositType.Duration, "FD Start Date");
                            //"FD Duration" := FixedDepositType."No. of Months";
                            "Product Category" := "Product Category"::"Fixed Deposit";
                        end;

                    Validate("FD Maturity Instructions");
                end
            end;
        }
        field(39004296; "Minimum Contribution"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(39004297; "Agent Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "Agent Code" := UpperCase("Agent Code");
            end;
        }
        field(39004298; "Agent Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            begin
                "Agent Document No" := UpperCase("Agent Document No");
            end;
        }
        field(39004299; "Created By Agent"; Boolean)
        {
            DataClassification = ToBeClassified;
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
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Accounts Application");
            NoSeriesMgt.InitSeries(SeriesSetup."Accounts Application", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Application Date" := Today;
        "Created By" := UserId;

        /* if UserSetup.Get(UserId) then begin
             UserSetup.TestField(UserSetup."Global Dimension 1 Code");
             UserSetup.TestField(UserSetup."Global Dimension 2 Code");
             UserSetup.TestField(UserSetup."Responsibility Centre");
             "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
             "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
             "Responsibility Center" := UserSetup."Responsibility Centre";
         end; */
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
        Cust: Record Members;
        ProductFactory: Record "Product Factory";
        ImageData: Record "Image Data";
        ParentEdit: Boolean;
        TypeHide: Boolean;
        FXDDetailsVisible: Boolean;
        JuniourAccVisible: Boolean;
        FixedDepositType: Record "Fixed Deposit Type";
        GeneralSetUp: Record "General Set-Up";
        UserSetup: Record "User Setup";
        SavingsAccounts: Record "Savings Accounts";
        DateofBirthError: Label 'Date cannot be greater than today.';
        AccountExistsError: Label 'Applicant already has a similar Account No.%1 Name %2 .';
        CountryRegion: Record "Country/Region";
        PostCode: Record "Post Code";
        FDCalcRules: Record "FD Interest Calculation Rules";
        MemberCategory: Record "Member Category";
        SavingsAccount: Record "Savings Accounts";
        CRMApplication: Record "CRM Application";
        Sav: Record "Savings Accounts";
        Members: Record Members;

    /// <summary>
    /// MultipleAccountCreation.
    /// </summary>
    procedure MultipleAccountCreation()
    var
        AllowMultipleAcntError: Label 'Applicant already has %1, Kindly ensure this product allows multiple account creations to proceed.';
    begin
        SavingsAccounts.Reset;
        SavingsAccounts.SetRange(SavingsAccounts."Member No.", "Member No.");
        SavingsAccounts.SetRange(SavingsAccounts."Product Type", "Product Type");
        if SavingsAccounts.Find('-') then begin
            if ProductFactory.Get("Product Type") then begin
                if not ProductFactory."Allow Multiple Accounts" then
                    if SavingsAccounts.Count >= 1 then
                        Error(AllowMultipleAcntError, SavingsAccounts."Product Name");
            end;
        end;
    end;

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

    /// <summary>
    /// ValidateApproval.
    /// </summary>
    procedure ValidateApproval()
    var
        ProductApplicationDocuments: Record "Product Documents";
        ApplicationDocuments: Record "Application Documents";
        DocumentErrorTxt: Label 'Some documents are missing for this application %1.';
    begin
        Rec.TestField(Status, Rec.Status::Open);
        Rec.TestField(Name);
        Rec.TestField("Product Type");
        Rec.TestField("Global Dimension 1 Code");
        //TESTFIELD("Global Dimension 2 Code");
        Rec.TestField("Responsibility Center");
        //TESTFIELD("Mobile Phone No");

        /* if Rec."Loan Disbursement Account" = true then
                Rec.TestField("Transaction Mobile No");*/

        case Rec."Product Category" of


            Rec."Product Category"::"Junior Savings":
                begin
                    Rec.TestField("Date of Birth");
                    Rec.Testfield("Birth Certificate No.");
                    //TESTFIELD("Parent Account No.");
                    //TESTFIELD(Picture); TESTFIELD(Signature);
                    /* if (Rec."Birth Certificate No." = '') and (Rec."Passport No." = '') then
                        ERROR(JuniorError, "Birth Certificate No.", "Passport No.", "Product Category");
                     if GuiAllowed then
                         if not Confirm('The Birth Certificate No or Passport No linked to the junior acc Application for  Member No ' + Rec."Member No." + ' is not present. Do you wish to continue?')
      then
                             exit;*/
                end;

            Rec."Product Category"::"Fixed Deposit":
                begin
                    Rec.TestField("Member No.");
                    // Rec.TestField("Fixed Deposit Type");
                    // Rec.TestField("FD Duration");
                    // Rec.TestField("Savings Account No.");
                    // Rec.TestField("Fixed Deposit Amount");
                    // if Rec."FD Maturity Instructions" = Rec."FD Maturity Instructions"::" " then Error('Maturity Instructions can not be blank');
                end;
            Rec."Product Category"::"Micro Credit Deposits":
                begin
                    Rec.TestField("Member No.");
                    Rec.TestField("Group Account No"); //TESTFIELD("Signing Instructions");
                end;
        end;



        ProductApplicationDocuments.Reset;
        ProductApplicationDocuments.SetRange(ProductApplicationDocuments."Product ID", Rec."Product Type");
        if ProductApplicationDocuments.Find('-') then begin
            repeat
                ApplicationDocuments.Reset;
                ApplicationDocuments.SetRange(ApplicationDocuments."Reference No.", Rec."No.");
                ApplicationDocuments.SetFilter(ApplicationDocuments."Product ID", ProductApplicationDocuments."Product ID");
                ApplicationDocuments.SetFilter(ApplicationDocuments.Provided, '<>%1', ApplicationDocuments.Provided::Yes);
                if ApplicationDocuments.FindFirst then begin
                    Error(DocumentErrorTxt, Rec."No." + ' - ' + Rec.Name);
                end;
            until ProductApplicationDocuments.Next = 0;
        end;
    end;
}

