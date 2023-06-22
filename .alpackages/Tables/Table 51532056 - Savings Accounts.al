/// <summary>
/// Table Savings Accounts (ID 51532056).
/// </summary>
table 51532056 "Savings Accounts"
{
    Caption = 'Savings Accounts';
    DataCaptionFields = "No.", Name;
    //DrillDownPageID = "Savings Account List";
    //LookupPageID = "Savings Account List";
    Permissions = TableData "Cust. Ledger Entry" = r;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                // //IF "Customer Type"="Customer Type"::Member THEN BEGIN
                // IF "No." <> xRec."No." THEN BEGIN
                //  SalesSetup.GET;
                //  NoSeriesMgt.TestManual(SalesSetup."Members Nos");
                //  "No. Series" := '';
                // // END;
                // END;
                //Prevent Changing once entries exist
                TestNoEntriesExist(FieldCaption("No."), "No.");
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then "Search Name" := UpperCase(Name);
                /*
              StatusPermissions.RESET;
              StatusPermissions.SETRANGE(StatusPermissions."User ID",USERID);
              StatusPermissions.SETRANGE(StatusPermissions."Function",StatusPermissions."Function"::NameEdit);
              IF StatusPermissions.FIND('-') = FALSE THEN
              ERROR('You do not have permissions to edit the name.');
                  */
                if Name <> '' then begin
                    if "Member No." <> '' then begin
                        Cust.Reset;
                        Cust.SetRange("Member No.", "Member No.");
                        Cust.SetFilter("No.", '<>%1', "No.");
                        if Cust.FindFirst then begin
                            Cust.ModifyAll(Name, Name);
                        end;
                        if Members.Get("Member No.") then begin
                            Members.Name := Name;
                            //Members.MODIFY;
                        end;
                    end;
                end;
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; "Current Address"; Text[60])
        {
            Caption = 'Address';
        }
        field(6; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(7; Contact; Text[50])
        {
            Caption = 'Contact';

            trigger OnValidate()
            begin
                //IF RMSetup.GET THEN
                //  IF RMSetup."Bus. Rel. Code for Customers" <> '' THEN
                //    IF (xRec.Contact = '') AND (xRec."Primary Contact No." = '') THEN BEGIN
                //      MODIFY;
                //      UpdateContFromCust.OnModify(Rec);
                //      UpdateContFromCust.InsertNewContactPerson(Rec,FALSE);
                //      MODIFY(TRUE);
                //    END
            end;
        }
        field(8; "Alternative Phone No. 1"; Text[13])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
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
                //ValidateShortcutDimCode(2,"Last Date Modified");
            end;
        }
        field(11; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";

            trigger OnValidate()
            begin
                TestNoEntriesExist(FieldCaption("No."), "No.");
            end;
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = IF ("Recruited by Type" = FILTER(Marketer)) "Salesperson/Purchaser".Code
            ELSE
            IF ("Recruited by Type" = FILTER(Staff)) "HR Employees"
            ELSE
            IF ("Recruited by Type" = FILTER("Board Member")) Members WHERE("Account Category" = FILTER("Board Members"))
            ELSE
            IF ("Recruited by Type" = FILTER(Member)) Members WHERE("Account Category" = FILTER(Member));
        }
        field(14; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(15; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Customer), "No." = FIELD("No.")));
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
        field(21; Balance; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Savings Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Savings Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Savings Ledger Entry".Amount WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Savings Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Balance Due"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD(UPPERLIMIT("Date Filter")), "Initial Entry Due Date" = FIELD("Date Filter"), "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"), "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance Due';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Balance Due (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD(UPPERLIMIT("Date Filter")), "Initial Entry Due Date" = FIELD("Date Filter"), "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"), "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"), "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance Due (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(28; "Post Code"; Code[20])
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
                //PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(29; County; Text[30])
        {
            Caption = 'County';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
        }
        field(30; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Savings Ledger Entry"."Debit Amount" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Savings Ledger Entry"."Credit Amount" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Savings Ledger Entry"."Debit Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Currency Code" = FIELD("Currency Code"), "Document No." = FIELD("Document No. Filter")));
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Savings Ledger Entry"."Credit Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Document No." = FIELD("Document No. Filter"), "Currency Code" = FIELD("Currency Code")));
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(35; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(36; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(37; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(38; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";
        }
        field(39; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(40; Status; Option)
        {
            OptionCaption = ' ,New,Active,Dormant,Frozen,Withdrawal Application,Withdrawn,Deceased,Defaulter,Closed,Blocked,Creditor';
            OptionMembers = " ",New,Active,Dormant,Frozen,"Withdrawal Application",Withdrawn,Deceased,Defaulter,Closed,Blocked,Creditor;
        }
        field(41; "Employer Code"; Code[50])
        {
        }
        field(42; "Date of Birth"; Date)
        {
            trigger OnValidate()
            begin
                // IF "Date of Birth" > TODAY THEN
                // ERROR('Date of birth cannot be greater than today');
                //
                // IF CALCDATE('18Y',"Date of Birth")>=TODAY THEN
                // ERROR('Birth certificate indicates this memebr is a minor');
            end;
        }
        field(44; "Home Address"; Text[60])
        {
        }
        field(45; "Payroll/Staff No."; Code[20])
        {
        }
        field(46; "ID No."; Code[50])
        {
            trigger OnValidate()
            begin
                "ID No." := DelChr("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?');
                if "ID No." <> '' then begin
                    if "Member No." <> '' then begin
                        Cust.Reset;
                        Cust.SetRange("Member No.", "Member No.");
                        Cust.SetFilter("No.", '<>%1', "No.");
                        if Cust.FindFirst then begin
                            Cust.ModifyAll("ID No.", "ID No.");
                        end;
                        if Members.Get("Member No.") then begin
                            Members."ID No." := "ID No.";
                            //Members.MODIFY;
                        end;
                    end;
                end;
            end;
        }
        field(47; "Mobile Phone No"; Code[60])
        {
            trigger OnValidate()
            begin
                //TESTFIELD("Country/Region Code");
                if "Member No." <> '' then begin
                    Cust.Reset;
                    Cust.SetRange("Member No.", "Member No.");
                    Cust.SetFilter("No.", '<>%1', "No.");
                    if Cust.FindFirst then begin
                        Cust.ModifyAll("Mobile Phone No", "Mobile Phone No");
                    end;
                    if Members.Get("Member No.") then begin
                        Members."Mobile Phone No" := "Mobile Phone No";
                        //Members.MODIFY;
                    end;
                end;
            end;
        }
        field(48; "Marital Status"; Option)
        {
            OptionCaption = ' ,Single,Married,Divorced,Widower,Widow,Widowed,m-pos,joint,engaged,Others';
            OptionMembers = " ",Single,Married,Divorced,Widower,Widow,Widowed,"m-pos",joint,engaged,Others;
        }
        field(49; Signature; BLOB)
        {
            Caption = 'Signature';
            SubType = Bitmap;
        }
        field(50; "Passport No."; Code[50])
        {
        }
        field(51; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(52; "Monthly Contribution"; Decimal)
        {
            trigger OnValidate()
            begin
                // PeriodicAcc.EmplyerSavingAdvice(Rec, xRec."Monthly Contribution", "Monthly Contribution");
                /*MContChanges.Init;
                    MContChanges."Account No." := "No.";
                    MContChanges.Product := "Product Name";
                    MContChanges.Scheme := Format("Product Category");
                    MContChanges.Date := Today;
                    MContChanges."Date Time" := CurrentDateTime;
                    MContChanges."Old Value" := xRec."Monthly Contribution";
                    MContChanges."New Value" := "Monthly Contribution";
                    MContChanges."Member No." := "Member No.";
                    MContChanges."Changed By" := UserId;
                    MContChanges.Insert;*/
            end;
        }
        field(53; "Outstanding Interest"; Decimal)
        {
            Description = 'Check Flow field';
            FieldClass = Normal;
        }
        field(54; "Account Category"; Option)
        {
            OptionCaption = 'Member,Staff Account,Board Members,Delegates,Single,Group,Joint,Bakisha,Corporate,Inst,Microfinance,pos';
            OptionMembers = Member,"Staff Account","Board Members",Delegates,Single,Group,Joint,Bakisha,Corporate,Inst,Microfinance,pos;
        }
        field(55; "Type Of Organisation"; Option)
        {
            OptionCaption = ' ,Club,Association,Partnership,Investment,Merry go round,Other,Group';
            OptionMembers = " ",Club,Association,Partnership,Investment,"Merry go round",Other,Group;
        }
        field(56; "Alternative Phone No. 2"; Code[13])
        {
        }
        field(57; "Group Account No"; Code[20])
        {
            Description = 'Check Relation';
            TableRelation = Members WHERE("Group Account" = FILTER(true), "Customer Type" = CONST(Microfinance));
        }
        field(58; Membership; Option)
        {
            OptionCaption = ' ,Ordinary,Preferential';
            OptionMembers = " ",Ordinary,Preferential;
        }
        field(59; "Group Account"; Boolean)
        {
        }
        field(60; "Product Type"; Code[60])
        {
            TableRelation = "Product Factory"."Product ID";

            trigger OnValidate()
            begin
                if ProductFactory.Get("Product Type") then begin
                    "Product Name" := ProductFactory."Product Description";
                    "Product Category" := ProductFactory."Product Category";
                end;
            end;
        }
        field(61; "Member No."; Code[20])
        {
            TableRelation = Members;
        }
        field(62; "Product Name"; Text[50])
        {
        }
        field(63; "Can Guarantee Loan"; Boolean)
        {
        }
        field(64; "Loan Disbursement Account"; Boolean)
        {
        }
        field(65; "Loan Security Inclination"; Option)
        {
            OptionCaption = ' ,Short Loan Security,Long Term Loan Security,Share Capital';
            OptionMembers = " ","Short Term Loan Security","Long Term Loan Security","Share Capital";
        }
        field(66; "ATM Transactions"; Decimal)
        {
            CalcFormula = Sum("ATM Transactions".Amount WHERE("Account No" = FIELD("No."), Posted = CONST(false)));
            FieldClass = FlowField;
        }
        field(67; "Fixed Deposit Status"; Option)
        {
            OptionCaption = ' ,Active,Matured,Closed,Not Matured';
            OptionMembers = " ",Active,Matured,Closed,"Not Matured";
        }
        field(68; "Relates to Business/Group"; Boolean)
        {
        }
        field(69; "Company Registration No."; Code[20])
        {
        }
        field(70; "Birth Certificate No."; Code[20])
        {
        }
        field(71; "ATM No."; Code[20])
        {
        }
        field(72; "Created By"; Code[50])
        {
        }
        field(73; "Registration Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Registration Date" <> 0D then if "Product Category" = "Product Category"::"Fixed Deposit" then Validate("FD Start Date", "Registration Date");
            end;
        }
        field(74; Source; Option)
        {
            Description = 'Used to identify origin of Member Application [CRM, Navision, Web]';
            OptionCaption = ' ,Navision,CRM,Web,Agency';
            OptionMembers = " ",Navision,CRM,Web,Agency;
        }
        field(75; "Authorised Over Draft"; Decimal)
        {
            CalcFormula = Sum("Over Draft Authorisation"."Approved Amount" WHERE("Account No." = FIELD("No."), Posted = CONST(true), Expired = CONST(false)));
            FieldClass = FlowField;
        }
        field(76; "Uncleared Cheques"; Decimal)
        {
            CalcFormula = Sum("Cashier Transaction Lines".Amount WHERE("Account No" = FIELD("No."), Cleared = FILTER(false), Posted = FILTER(true), "Header Transaction Type" = FILTER("Credit Cheque" | "Cheque Deposit")));
            FieldClass = FlowField;
        }
        field(77; "Fixed Deposit Type"; Code[20])
        {
            Description = 'LookUp to Fixed Deposit Type Table';
            TableRelation = "Fixed Deposit Type";

            trigger OnValidate()
            begin
                CalculateFixedMaturity;
            end;
        }
        field(78; "FD Maturity Date"; Date)
        {
        }
        field(79; "Product Category"; Option)
        {
            OptionCaption = ' ,Share Capital,Main Shares,Fixed Deposit,Junior Savings,Registration Fee,Benevolent,Unallocated Fund,Micro Credit Deposits,NHIF,Corp,School Fee,Dividend,Joint,Redeemable,KUSCCO,Housing,Creditor,Prime';
            OptionMembers = " ","Share Capital","Deposit Contribution","Fixed Deposit","Junior Savings","Registration Fee",Benevolent,"Unallocated Fund","Micro Credit Deposits",NHIF,Corp,"School Fee",Dividend,Joint,Redeemable,KUSCCO,Housing,Creditor,Prime;
        }
        field(80; "Neg. Interest Rate"; Decimal)
        {
            trigger OnValidate()
            begin
                CalcFields("Balance (LCY)", Balance);
                FDCalcRules.Reset;
                FDCalcRules.SetRange(Code, "Fixed Deposit Type");
                if FDCalcRules.Find('-') then begin
                    repeat
                        if FDCalcRules."Allowed Margin" <> 0 then begin
                            if (Balance >= FDCalcRules."Minimum Amount") and (Balance <= FDCalcRules."Maximum Amount") then if ("Neg. Interest Rate" > (FDCalcRules."Interest Rate" + FDCalcRules."Allowed Margin")) or ("Neg. Interest Rate" < (FDCalcRules."Interest Rate" - FDCalcRules."Allowed Margin")) then Error('The negotiated rate must be within the allowed margin of %1', FDCalcRules."Allowed Margin");
                        end;
                    until FDCalcRules.Next = 0;
                end;
            end;
        }
        field(81; "FD Duration"; DateFormula)
        {
            trigger OnValidate()
            begin
                CalculateFixedMaturity;
            end;
        }
        field(82; "FD Maturity Instructions"; Option)
        {
            OptionCaption = ' ,Transfer all to Savings,Renew Principal,Renew Principal & Interest,Forefeit Interest';
            OptionMembers = " ","Transfer all to Savings","Renew Principal","Renew Principal & Interest","Forefeit Interest";

            trigger OnValidate()
            begin
                if FixedDepositType.Get("Fixed Deposit Type") then begin
                    if FixedDepositType."Call Deposit" then begin
                        if "FD Maturity Instructions" = "FD Maturity Instructions"::"Renew Principal & Interest" then Error('This option is not applicable to call deposits');
                    end;
                end;
            end;
        }
        field(83; "Fixed Deposit cert. no"; Code[30])
        {
            Description = 'Capture FxD certificate Number';
        }
        field(84; "Fixed Deposit Amount"; Decimal)
        {
        }
        field(85; "Savings Account No."; Code[20])
        {
            Description = 'LookUp to Savings Account Table';
            TableRelation = "Savings Accounts" WHERE("Member No." = FIELD("Member No."));
        }
        field(86; "Transactional Mobile No"; Text[13])
        {
        }
        field(87; "Virtual Member"; Boolean)
        {
        }
        field(89; "Single Party/Multiple/Business"; Option)
        {
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = Single,Multiple,Business;
        }
        field(90; "Parent Account No."; Code[20])
        {
            Description = 'LookUp to Member Table';
            TableRelation = Members;
        }
        field(91; "Last Withdrawal Date"; Date)
        {
        }
        field(92; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";
        }
        field(93; "Recruited by Type"; Option)
        {
            OptionCaption = 'Marketer,Office,Staff,Board Member,Member';
            OptionMembers = Marketer,Office,Staff,"Board Member",Member;
        }
        field(94; "Recovery Priority"; Integer)
        {
        }
        field(95; "Group Name"; Text[50])
        {
        }
        field(50000; "Allow Multiple Agent Trans"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Loan Held Cheques"; Decimal)
        {
            CalcFormula = Sum("Cashier Transaction Lines".Amount WHERE("Loan Held at" = FIELD("No."), Cleared = FILTER(false), Posted = FILTER(true), "Header Transaction Type" = FILTER("Credit Cheque" | "Cheque Deposit")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Status Change Statistics"; Integer)
        {
            CalcFormula = Count("Reactivate/Deactivate Header" WHERE("Account Type" = CONST(Savings), "Account No." = FIELD("No."), Status = CONST(Processed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Relationship Manager"; Code[10])
        {
            TableRelation = "HR Employees" WHERE(Status = FILTER(Active));
        }
        field(50006; "Signing Instructions"; Option)
        {
            OptionMembers = "Any Two","Any Three",All;
        }
        field(50007; "Send Statement Freq."; DateFormula)
        {
            trigger OnValidate()
            begin
                "Last Statement Date" := CalcDate("Send Statement Freq.", Today);
            end;
        }
        field(50008; "Last Statement Date"; Date)
        {
        }
        field(50009; "Interest Earned"; Decimal)
        {
            CalcFormula = Sum("Interest Buffer"."Interest Amount" WHERE("Account No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Untranfered Interest"; Decimal)
        {
            CalcFormula = Sum("Interest Buffer"."Interest Amount" WHERE("Account No" = FIELD("No."), Transferred = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Lien Placed"; Decimal)
        {
            CalcFormula = Sum("Cashier Transactions".Amount WHERE("Account No" = FIELD("No."), Posted = CONST(true), Type = FILTER(Lien), "Cheque Status" = CONST(Pending)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Principle Balance"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Savings Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Entry Type" = CONST("Normal Entry")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Interest Balance"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Savings Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Entry Type" = CONST("Interest Entry")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Cell Group Code"; Code[20])
        {
            //CalcFormula = Lookup("Cell Group Members"."Account No" WHERE ("Member No."=FIELD("Member No.")));
            //FieldClass = FlowField;
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
        field(39004243; "Special Account"; Boolean)
        {
        }
        field(39004244; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(39004245; "FD Date Renewed"; Date)
        {
        }
        field(39004247; "Old Member No."; Code[20])
        {
        }
        field(39004248; "Associated Member No."; Code[20])
        {
        }
        field(39004249; "Enable Sweeping"; Boolean)
        {
        }
        field(39004250; "External Account No"; Code[50])
        {
            trigger OnValidate()
            begin
                if StrLen("External Account No") > 14 then Error('Invalid Bank Account No. Please enter a bank account with less than 15 digits.');
            end;
        }
        field(39004251; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Code Structure"."Bank Code";
        }
        field(39004252; "Amount to Transfer"; Decimal)
        {
        }
        field(39004253; "Savings Interest Earned"; Decimal)
        {
            CalcFormula = Sum("Savings Interest Buffer"."Interest Amount" WHERE("Account No" = FIELD("No."), Posted = FILTER(false), "Interest Date" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004254; "Employer Account No"; Code[20])
        {
        }
        field(39004255; "Old Account No"; Code[20])
        {
        }
        field(39004256; "Block Reason"; Text[100])
        {
            Editable = false;
        }
        field(39004257; "Form No."; Code[20])
        {
        }
        field(39004258; "Info Base Area"; Text[250])
        {
        }
        field(39004259; "Society Code"; Code[20])
        {
            //TableRelation = Societies."No.";
        }
        field(39004260; "NHIF Commission"; Boolean)
        {
        }
        field(39004261; "Junior Date of Birth"; Date)
        {
        }
        field(39004262; "Junior Account Name"; Text[100])
        {
        }
        field(39004263; "Blocked 2"; Option)
        {
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ",Credit,Debit,All;
        }
        field(39004264; "PF No."; Code[20])
        {
            FieldClass = Normal;
        }
        field(39004272; "Mobile Centre"; Code[50])
        {
        }
        field(39004273; "ID Type"; Option)
        {
            OptionCaption = 'National ID,Military ID,Passport,Alien ID';
            OptionMembers = "National ID","Military ID",Passport,"Alien ID";
        }
        field(39004274; "Military ID"; Code[20])
        {
        }
        field(39004278; "KTDA No."; Code[40])
        {
        }
        field(39004279; "Needs Authorization"; Boolean)
        {
        }
        field(39004280; "FD Start Date"; Date)
        {
            trigger OnValidate()
            begin
                CalculateFixedMaturity;
            end;
        }
        field(39004281; "Politically Exposed"; Option)
        {
            OptionCaption = ' ,Yes';
            OptionMembers = " ",Yes;
        }
        field(39004282; "Political Position"; Text[50])
        {
        }
        field(39004283; "Defaulted Loans Guaranteed"; Integer)
        {
            /*CalcFormula = Count("Defaulted Loan Guarantors" WHERE ("Guarantor Member No."=FIELD("Member No."),
                                                                       "Guarantor Account"=FIELD("No.")));
                FieldClass = FlowField;*/
        }
        field(39004284; "Cheque Account No."; Code[20])
        {
        }
        field(39004285; "Lien Guaranteed"; Decimal)
        {
            CalcFormula = Sum("Loan Guarantors and Security"."Current Committed" WHERE("Savings Account No./Member No." = FIELD("No."), "Current Committed" = FILTER(> 0), "Guarantor Type" = CONST(Lien), "Outstanding Balance" = FILTER(> 0), "Loan Top Up" = CONST(false), Substituted = CONST(false)));
            FieldClass = FlowField;
        }
        field(39004286; "Agent Mandate"; Text[100])
        {
        }
        field(39004287; "POS Transactions"; Decimal)
        {
            /*CalcFormula = Sum("POS Transactions".Amount WHERE ("Account No"=FIELD("No."),
                                                                   Posted=CONST(false),
                                                                   IsReversal=CONST(false),
                                                                   "Transaction Type"=FILTER('CW'|'CWF'|'D')));
                FieldClass = FlowField;*/
        }
        field(39004290; "Recruited By Name"; Text[100])
        {
            Editable = false;
        }
        field(39004291; "FD Interest Earned"; Decimal)
        {
            CalcFormula = Sum("Interest Buffer"."Interest Amount" WHERE("Account No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39004293; "Child Name"; Text[150])
        {
        }
        field(39004294; "Overdraft Interest"; Decimal)
        {
            /*CalcFormula = Sum("OD Interest Buffer"."Interest Amount" WHERE ("Account No"=FIELD("No."),
                                                                                Posted=CONST(false)));
                FieldClass = FlowField;*/
        }
        field(39004295; "Last Creditor SMS Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004296; "Old Last Transaction Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004297; "First Transaction Date"; Date)
        {
            CalcFormula = Min("Savings Ledger Entry"."Posting Date" WHERE("Customer No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(39004298; "Msacco Blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004299; MobileLoanLevel; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(39004300; LastMobileGraduationDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004301; days; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(39004302; "Deposit Class"; Option)
        {
            OptionMembers = "Withdrawable","Non-Withdrawable";
            FieldClass = flowfield;
            Calcformula = lookup("Product Factory"."Deposits Class" where("Product ID" = field("Product Type")));
        }
    }
    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; Name)
        {
        }
        key(Key4; Contact)
        {
        }
        key(Key5; "Global Dimension 1 Code")
        {
        }
        key(Key6; "Alternative Phone No. 1")
        {
        }
        key(Key7; "Member No.")
        {
        }
        key(Key8; "Payroll/Staff No.")
        {
        }
        key(Key9; "ID No.")
        {
        }
        key(Key10; "Old Account No")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Product Name", "Mobile Phone No", Name, "ID No.", "Member No.", "Product Category", "Payroll/Staff No.")
        {
        }
    }
    trigger OnDelete()
    var
        CampaignTargetGr: Record "Campaign Target Group";
        ContactBusRel: Record "Contact Business Relation";
        Job: Record Job;
        CampaignTargetGrMgmt: Codeunit "Campaign Target Group Mgt";
        StdCustSalesCode: Record "Standard Customer Sales Code";
    begin
        DimMgt.DeleteDefaultDim(DATABASE::Customer, "No.");
        //MobSalesmgt.CustOnDelete(Rec);
        // CALCFIELDS("Group Account");
        // IF "Group Account">0 THEN
        // ERROR(Text001);
    end;

    trigger OnInsert()
    begin
        //IF "No." = '' THEN BEGIN
        //  SalesSetup.GET;
        //SalesSetup.TESTFIELD(SalesSetup."Members Nos");
        //NoSeriesMgt.InitSeries(SalesSetup."Members Nos",xRec."No. Series",0D,"No.","No. Series");
        // END;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        if (Name <> xRec.Name) or ("Search Name" <> xRec."Search Name") or ("Name 2" <> xRec."Name 2") or ("Current Address" <> xRec."Current Address") or (City <> xRec.City) or (Contact <> xRec.Contact) or ("Global Dimension 1 Code" <> xRec."Global Dimension 1 Code") or ("Global Dimension 2 Code" <> xRec."Global Dimension 2 Code") or (Comment <> xRec.Comment) or ("Balance (LCY)" <> xRec."Balance (LCY)") or ("Net Change (LCY)" <> xRec."Net Change (LCY)") or (County <> xRec.County) or ("No. Series" <> xRec."No. Series") or //("Fax No." <> xRec."Fax No.") OR
        //("Telex Answer Back" <> xRec."Telex Answer Back") OR
        //("VAT Registration No." <> xRec."VAT Registration No.") OR
        ("Post Code" <> xRec."Post Code") or (County <> xRec.County) or ("E-Mail" <> xRec."E-Mail") or //("Home Page" <> xRec."Home Page") OR
        ("Alternative Phone No. 1" <> xRec."Alternative Phone No. 1") then begin
            Modify;
            //UpdateContFromCust.OnModify(Rec);
        end;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.';
        Text002: Label 'Do you wish to create a contact for %1 %2?';
        CommentLine: Record "Comment Line";
        SalesOrderLine: Record "Sales Line";
        CustBankAcc: Record "Customer Bank Account";
        ShipToAddr: Record "Ship-to Address";
        PostCode: Record "Post Code";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        ShippingAgentService: Record "Shipping Agent Services";
        //ItemCrossReference: Record "Item Cross Reference";
        RMSetup: Record "Marketing Setup";
        //SalesPrice: Record "Sales Price";
        //SalesLineDisc: Record "Sales Line Discount";
        SalesPrepmtPct: Record "Sales Prepayment %";
        ServContract: Record "Service Contract Header";
        ServHeader: Record "Service Header";
        ServiceItem: Record "Service Item";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MoveEntries: Codeunit MoveEntries;
        UpdateContFromCust: Codeunit "CustCont-Update";
        DimMgt: Codeunit DimensionManagement;
        InsertFromContact: Boolean;
        Text003: Label 'Contact %1 %2 is not related to customer %3 %4.';
        Text004: Label 'post';
        Text005: Label 'create';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        Text007: Label 'You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.';
        Text008: Label 'Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?';
        Text009: Label 'Cannot delete customer.';
        Text010: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.';
        Text011: Label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
        Text012: Label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
        Text013: Label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';
        Text014: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text015: Label 'You cannot delete %1 %2 because there is at least one %3 associated to this customer.';
        Loans: Record Loans;
        MinShares: Decimal;
        Cust: Record "Savings Accounts";
        Vend: Record Vendor;
        CustFosa: Code[20];
        Vend2: Record Vendor;
        FOSAAccount: Record Vendor;
        Text001: Label 'You cannot delete %1 %2 because there is at least one transaction %3 for this customer.';
        IntRate: Decimal;
        DocNo: Code[10];
        PDate: Date;
        IntBufferNo: Integer;
        MidMonthFactor: Decimal;
        DaysInMonth: Integer;
        StartDate: Date;
        IntDays: Integer;
        AsAt: Date;
        MinBal: Boolean;
        AccruedInt: Decimal;
        RIntDays: Integer;
        Bal: Decimal;
        Rate: Decimal;
        "Sacco Account": Record "Savings Accounts";
        ProductFactory: Record "Product Factory";
        Account: Record "Savings Accounts";
        Text016: Label 'You cannot Modify %1 %2 because there is at least one transaction %3 for this Member.';
        FixedDepositType: Record "Fixed Deposit Type";
        //PeriodicAcc: Codeunit "Periodic Activities";
        FDCalcRules: Record "FD Interest Calculation Rules";
        Members: Record Members;
    //MContChanges: Record "Monthly Contributions Changes";
    procedure TestNoEntriesExist(CurrentFieldName: Text[100];
    GLNO: Code[20])
    var
        MemberLedgEntry: Record "Savings Ledger Entry";
    begin
        /*
            //To prevent change of field
            MemberLedgEntry.SETCURRENTKEY(MemberLedgEntry."Customer No.");
            MemberLedgEntry.SETRANGE(MemberLedgEntry."Customer No.","No.");
            IF MemberLedgEntry.FIND('-') THEN
              ERROR(
              Text016,
               CurrentFieldName,"No.",Name);
               */
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldCust">Record "Savings Accounts".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldCust: Record "Savings Accounts"): Boolean
    var
        Cust: Record "Savings Accounts";
    begin
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer;
    var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    /// <summary>
    /// ShowContact.
    /// </summary>
    procedure ShowContact()
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
        if "No." = '' then exit;
        ContBusRel.SetCurrentKey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SetRange("No.", "No.");
        if not ContBusRel.FindFirst then begin
            if not Confirm(Text002, false, TableCaption, "No.") then exit;
            //UpdateContFromCust.InsertNewContact(Rec,FALSE);
            ContBusRel.FindFirst;
        end;
        Commit;
        Cont.SetCurrentKey("Company Name", "Company No.", Type, Name);
        Cont.SetRange("Company No.", ContBusRel."Contact No.");
        PAGE.Run(PAGE::"Contact List", Cont);
    end;

    /// <summary>
    /// SetInsertFromContact.
    /// </summary>
    /// <param name="FromContact">Boolean.</param>
    procedure SetInsertFromContact(FromContact: Boolean)
    begin
        InsertFromContact := FromContact;
    end;

    procedure CheckBlockedCustOnDocs(Cust2: Record "Savings Accounts";
    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
    Shipment: Boolean;
    Transaction: Boolean)
    begin
        /*WITH Cust2 DO BEGIN
             IF ((Blocked = Blocked::All) OR
                ((Blocked = Blocked::Invoice) AND (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"])) OR
                ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::"Blanket Order"]) AND
                 NOT Transaction)) OR
                  ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"]) AND
                  Shipment AND Transaction)) THEN
                CustBlockedErrorMessage(Cust2,Transaction);
            END;*/
    end;

    procedure CheckBlockedCustOnJnls(Cust2: Record "Savings Accounts";
    DocType: Enum "Gen. Journal Document Type";
    Transaction: Boolean)
    begin
        /*with Cust2 do begin
              if (Blocked = Blocked::All)
              then
                CustBlockedErrorMessage(Cust2,Transaction)
            end;*/
    end;

    /// <summary>
    /// CustBlockedErrorMessage.
    /// </summary>
    /// <param name="Cust2">Record "Savings Accounts".</param>
    /// <param name="Transaction">Boolean.</param>
    procedure CustBlockedErrorMessage(Cust2: Record "Savings Accounts";
    Transaction: Boolean)
    var
        "Action": Text[30];
    begin
    end;

    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.FindFirst then
            MapMgt.MakeSelection(DATABASE::Customer, GetPosition)
        else
            Message(Text014);
    end;

    procedure GetTotalAmountLCY(): Decimal
    begin
        ///CALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)", 
        // "Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");
        //EXIT(GetTotalAmountLCYCommon);
    end;

    procedure GetTotalAmountLCYUI(): Decimal
    begin
        //SETAUTOCALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
        //"Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");
        //EXIT(GetTotalAmountLCYCommon);
    end;

    local procedure GetTotalAmountLCYCommon(): Decimal
    var
        SalesLine: Record "Sales Line";
        ServiceLine: Record "Service Line";
        SalesOutstandingAmountFromShipment: Decimal;
        ServOutstandingAmountFromShipment: Decimal;
        InvoicedPrepmtAmountLCY: Decimal;
    begin
        //SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
        //ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment("No.");
        //InvoicedPrepmtAmountLCY := GetInvoicedPrepmtAmountLCY;
        //EXIT("Balance (LCY)" + "Outstanding Orders (LCY)" + "Shipped Not Invoiced (LCY)" + "Outstanding Invoices (LCY)" +
        //"Outstanding Serv. Orders (LCY)" + "Serv Shipped Not Invoiced(LCY)" + "Outstanding Serv.Invoices(LCY)" -
        // SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment - InvoicedPrepmtAmountLCY);
    end;

    procedure GetSalesLCY(): Decimal
    var
        CustomerSalesYTD: Record Customer;
        AccountingPeriod: Record "Accounting Period";
        StartDate: Date;
        EndDate: Date;
    begin
        //StartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
        //EndDate := AccountingPeriod.GetFiscalYearEndDate(WORKDATE);
        //CustomerSalesYTD := Rec;
        //CustomerSalesYTD."SECURITYFILTERING"("SECURITYFILTERING");
        //CustomerSalesYTD.SETRANGE("Date Filter",StartDate,EndDate);
        //CustomerSalesYTD.CALCFIELDS("Sales (LCY)");
        //EXIT(CustomerSalesYTD."Sales (LCY)");
    end;

    procedure CalcAvailableCredit(): Decimal
    begin
        exit(CalcAvailableCreditCommon(false));
    end;

    procedure CalcAvailableCreditUI(): Decimal
    begin
        exit(CalcAvailableCreditCommon(true));
    end;

    local procedure CalcAvailableCreditCommon(CalledFromUI: Boolean): Decimal
    begin
        //IF "Credit Limit (LCY)" = 0 THEN
        // EXIT(0);
        //IF CalledFromUI THEN
        // EXIT("Credit Limit (LCY)" - GetTotalAmountLCYUI);
        //EXIT("Credit Limit (LCY)" - GetTotalAmountLCY);
    end;

    procedure CalcOverdueBalance() OverDueBalance: Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        CustLedgEntryRemainAmtQuery: Query "Cust. Ledg. Entry Remain. Amt.";
    begin
        CustLedgEntryRemainAmtQuery.SetRange(Customer_No, "No.");
        CustLedgEntryRemainAmtQuery.SetRange(IsOpen, true);
        CustLedgEntryRemainAmtQuery.SetFilter(Due_Date, '<%1', WorkDate);
        CustLedgEntryRemainAmtQuery.Open;
        if CustLedgEntryRemainAmtQuery.Read then OverDueBalance := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;

    procedure GetLegalEntityType(): Text
    begin
        //EXIT(FORMAT("Partner Type"));
    end;

    procedure GetLegalEntityTypeLbl(): Text
    begin
        //EXIT(FIELDCAPTION("Partner Type"));
    end;

    procedure SetStyle(): Text
    begin
        if CalcAvailableCredit < 0 then exit('Unfavorable');
        exit('');
    end;

    procedure HasValidDDMandate(Date: Date): Boolean
    var
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
    begin
        exit(SEPADirectDebitMandate.GetDefaultMandate("No.", Date) <> '');
    end;

    procedure GetInvoicedPrepmtAmountLCY(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetCurrentKey("Document Type", "Bill-to Customer No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Bill-to Customer No.", "No.");
        SalesLine.CalcSums("Prepmt. Amount Inv. (LCY)", "Prepmt. VAT Amount Inv. (LCY)");
        exit(SalesLine."Prepmt. Amount Inv. (LCY)" + SalesLine."Prepmt. VAT Amount Inv. (LCY)");
    end;

    procedure CalcCreditLimitLCYExpendedPct(): Decimal
    begin
        //IF "Credit Limit (LCY)" = 0 THEN
        // EXIT(0);
        //IF "Balance (LCY)" / "Credit Limit (LCY)" < 0 THEN
        // EXIT(0);
        //IF "Balance (LCY)" / "Credit Limit (LCY)" > 1 THEN
        // EXIT(10000);
        //EXIT(ROUND("Balance (LCY)" / "Credit Limit (LCY)" * 10000,1));
    end;

    procedure CreateAndShowNewInvoice()
    var
        SalesHeader: Record "Sales Header";
    begin
        /*
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader.SETRANGE("Sell-to Customer No.","No.");
            SalesHeader.INSERT(TRUE);
            COMMIT;
            PAGE.RUNMODAL(PAGE::"Mini Sales Invoice",SalesHeader)
            */
    end;

    procedure CreateAndShowNewCreditMemo()
    var
        SalesHeader: Record "Sales Header";
    begin
        /*
            SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
            SalesHeader.SETRANGE("Sell-to Customer No.","No.");
            SalesHeader.INSERT(TRUE);
            COMMIT;
            PAGE.RUNMODAL(PAGE::"Mini Sales Credit Memo",SalesHeader)
            */
    end;

    procedure CreateAndShowNewQuote()
    var
        SalesHeader: Record "Sales Header";
    begin
        /*
            SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
            SalesHeader.SETRANGE("Sell-to Customer No.","No.");
            SalesHeader.INSERT(TRUE);
            COMMIT;
            PAGE.RUNMODAL(PAGE::"Mini Sales Quote",SalesHeader)
            */
    end;

    local procedure UpdatePaymentTolerance(UseDialog: Boolean)
    begin
        //IF "Block Payment Tolerance" THEN BEGIN
        //IF UseDialog THEN
        // IF NOT CONFIRM(RemovePaymentRoleranceQst,FALSE) THEN
        //  EXIT;
        //PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
        //END ELSE BEGIN
        // IF UseDialog THEN
        //  IF NOT CONFIRM(AllowPaymentToleranceQst,FALSE) THEN
        //   EXIT;
        //PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
        //END;
    end;

    procedure GetBillToCustomerNo(): Code[20]
    begin
        //IF "Bill-to Customer No." <> '' THEN
        // EXIT("Bill-to Customer No.");
        //EXIT("No.");
    end;

    procedure GetSMSFieldName(SavingsAccounts: Record "Savings Accounts") RetunField: Text[20]
    var //SMSCodes: Record "SMS Rejection Line";
        TableName: Text;
        i: Integer;
        FieldName: array[5] of Text;
    begin
        TableName := SavingsAccounts.TableName;
        /*i:=1;
            SMSCodes.Reset;
            SMSCodes.SetRange(SMSCodes."Member No.",TableName);
            if SMSCodes.Find('-') then begin
              repeat
                SMSCodes.CalcFields(SMSCodes."Modified By");
                FieldName[i]:=SMSCodes."Modified By";
                i+=i;
                until SMSCodes.Next=0;
                RetunField:=Format(FieldName[1])+'['+Format(FieldName[2])+'['+Format(FieldName[3])+'['+Format(FieldName[4])+'['+Format(FieldName[5]);
              end;*/
    end;

    procedure GetSMSCode(SavingsAccounts: Record "Savings Accounts";
    FieldName: Text) "code": Text[20]
    var
        TableName: Text;
    //SMSCodes: Record "SMS Rejection Line";
    begin
        /*
            TableName:=SavingsAccounts.TABLENAME;

            SMSCodes.RESET;
            SMSCodes.SETRANGE(SMSCodes."Member No.",TableName);
            SMSCodes.SETRANGE(SMSCodes."Modified By",FieldName);
            IF SMSCodes.FIND('-') THEN BEGIN
                code:=SMSCodes.Code;
              END;
              */
    end;

    /// <summary>
    /// GetSMSFormat.
    /// </summary>
    /// <returns>Return variable StringCode of type Text[130].</returns>
    procedure GetSMSFormat() StringCode: Text[130]
    var //SMSSetup: Record "SMS Charges";
        //SMSSeries: Record "SMS Series";
        TextBody: Text;
        String: Text;
    begin
        /*
            SMSSetup.GET;

            SMSSetup.TESTFIELD(SMSSetup."Charge Amount");
            //Get the sms format
            SMSSeries.RESET;
            SMSSeries.SETRANGE(SMSSeries.Code,SMSSetup."Charge Amount");
            IF SMSSeries.FIND('-') THEN BEGIN
              TextBody:=SMSSeries."Message Body";
              //StringCode:=PeriodicAcc.Token(TextBody,'[');
              StringCode:=PeriodicAcc.Token(TextBody,'[]');
              END;
              */
    end;

    procedure GetAcualSMSFormat() TextBody: Text[130]
    var //SMSSetup: Record "SMS Charges";
        //SMSSeries: Record "SMS Series";
        String: Text;
    begin
        /*
            SMSSetup.GET;

            SMSSetup.TESTFIELD(SMSSetup."Charge Amount");
            //Get the sms format
            SMSSeries.RESET;
            SMSSeries.SETRANGE(SMSSeries.Code,SMSSetup."Charge Amount");
            IF SMSSeries.FIND('-') THEN BEGIN
              TextBody:=SMSSeries."Message Body";
              //StringCode:=PeriodicAcc.Token(TextBody,'[');
              //StringCode:=PeriodicAcc.Token(TextBody,'[]');
              END;
              */
    end;

    procedure CalculateFixedMaturity()
    var
        InitDateFormula: DateFormula;
    begin
        if "Product Category" = "Product Category"::"Fixed Deposit" then begin
            "FD Maturity Date" := 0D;
            "FD Duration" := InitDateFormula;
            TestField("FD Start Date");
            TestField("Registration Date");
            if FixedDepositType.Get("Fixed Deposit Type") then begin
                "FD Duration" := FixedDepositType.Duration;
                "FD Maturity Date" := CalcDate(FixedDepositType.Duration, "FD Start Date");
                if FixedDepositType."Call Deposit" then "FD Maturity Date" := CalcDate('1Y', "FD Start Date");
            end;
            Validate("FD Maturity Instructions");
        end;
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

    procedure GetDepositArreas() Arrears: Decimal
    var //Savings: Record "Savings Accounts";
        PFact: Record "Product Factory";
    begin
        CalcFields("Balance (LCY)");
        if "Registration Date" <> 0D then begin
            if PFact.Get("Product Type") then begin
                if PFact."Maximum Deposit Contribution" <= "Balance (LCY)" then exit;
                if Pfact."Minimum Contribution" > 0 then begin
                    Arrears := (CalculateMonthBetweenTwoDate("Registration Date", Today) * PFact."Minimum Contribution") - "Balance (LCY)";
                    if Arrears < 0 then Arrears := 0;
                end;
            end;
        end;
    end;

    local procedure CalculateMonthBetweenTwoDate(StartDate: Date;
    EndDate: Date): Integer
    var
        NoOfYears: Integer;
        NoOfMonths: Integer;
    begin
        NoOfYears := DATE2DMY(EndDate, 3) - DATE2DMY(StartDate, 3);
        NoOfMonths := DATE2DMY(EndDate, 2) - DATE2DMY(StartDate, 2);
        exit(12 * NoOfYears + NoOfMonths);
    end;
}
