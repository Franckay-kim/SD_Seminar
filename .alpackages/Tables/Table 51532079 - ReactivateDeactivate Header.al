/// <summary>
/// Table Reactivate/Deactivate Header (ID 51532079).
/// </summary>
table 51532079 "Reactivate/Deactivate Header"
{
    //DrillDownPageID = "Member Change Card";
    //LookupPageID = "Member Change Card";

    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get();
                    NoSeriesMgt.TestManual(SeriesSetup."Member Reactivation Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Application Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Application Date" > Today then
                    Error(DateofBirthError);
            end;
        }
        field(3; "Application Time"; Time)
        {
            Editable = false;
        }
        field(4; Comment; Boolean)
        {
            //CalcFormula = Exist("Comment Line" WHERE ("Table Name"=CONST(Member),
            //                                       "No."=FIELD("No.")));
            Caption = 'Comment';
            Description = 'LookUp to Comment Line';
            Editable = false;
            //FieldClass = FlowField;
        }
        field(5; "No. Series"; Code[20])
        {
            Editable = false;
        }
        field(6; "Account Type"; Option)
        {
            OptionCaption = ' ,Member,Savings';
            OptionMembers = " ",Member,Savings;

            trigger OnValidate()
            begin
                ClearFields;
                "Account No." := '';
            end;
        }
        field(7; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Member)) Members
            ELSE
            IF ("Account Type" = CONST(Savings)) "Savings Accounts"."No." where("Member No." = field("Member No."));

            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
            begin

                "Change Started" := false;

                ClearFields;
                /* if UserSetup.Get(UserId) then begin
                    UserSetup.TestField(UserSetup."Global Dimension 1 Code");
                    UserSetup.TestField(UserSetup."Global Dimension 2 Code");
                    //"Global Dimension 1 Code":= UserSetup."Global Dimension 1 Code";
                    "User Branch" := UserSetup."Global Dimension 2 Code";
                    "Responsibility Center" := UserSetup."Responsibility Centre";
                end; */


                if "Account Type" = "Account Type"::Member then begin
                    if CustMembr.Get("Account No.") then
                        Validate("Member No.", CustMembr."No.");
                    Validate("Single Party/Multiple/Business", CustMembr."Single Party/Multiple");
                    Validate("First Name", CustMembr."First Name");
                    Validate("Second Name", CustMembr."Second Name");
                    Validate("Last Name", CustMembr."Last Name");
                    Validate(Name, CustMembr.Name);
                    "P.I.N Number" := CustMembr."P.I.N Number";
                    Validate("Member Status", CustMembr.Status);
                    "Member Status" := CustMembr.Status;
                    //VALIDATE(Blocked, CustMembr.Blocked);
                    Blocked := CustMembr.Blocked;
                    Validate("Politically Exposed", CustMembr."Politically Exposed");
                    Validate("Political Position", CustMembr."Political Position");
                    Validate("Member Segment", CustMembr."Member Station");
                    Validate("Account Category", CustMembr."Account Category");
                    Validate("Member Category", CustMembr."Member Category");
                    Validate("Relationship Manager", CustMembr."Relationship Manager");
                    "Mobile Phone No" := CustMembr."Mobile Phone No";
                    "Member Station" := CustMembr."Member Station";
                    "E-Mail" := CustMembr."E-Mail";
                    "Personal E-mail" := CustMembr."Personal E-mail";
                    "Payroll/Staff No." := CustMembr."Payroll/Staff No.";
                    "ID No." := CustMembr."ID No.";
                    "Passport No." := CustMembr."Passport No.";
                    //VALIDATE("Date of Birth", CustMembr."Date of Birth");
                    "Date of Birth" := CustMembr."Date of Birth";
                    "Registration Date" := CustMembr."Registration Date";
                    Validate("Marital Status", CustMembr."Marital Status");
                    Validate(Gender, CustMembr.Gender);
                    Validate("Tax Exempted", CustMembr."Tax Exempted");
                    Validate("Tax Waiver End Date", CustMembr."Tax Waiver End Date");
                    //VALIDATE("Sacco CID",CustMembr."Sacco CID");

                    Validate("Group Account", CustMembr."Group Account");
                    Validate("Group Account No.", CustMembr."Group Code");
                    Validate("Group Type", CustMembr."Group Type");
                    Validate("Nature of Business", CustMembr."Nature of Business");
                    Validate("Company Registration No.", CustMembr."Company Registration No.");
                    Validate("Date of Business Reg.", CustMembr."Date of Business Reg.");
                    Validate("Business/Group Location", CustMembr."Business/Group Location");
                    Validate("Plot/Bldg/Street/Road", CustMembr."Plot/Bldg/Street/Road");
                    Validate("Type of Business", CustMembr."Type of Business");
                    Validate("Ownership Type", CustMembr."Ownership Type");
                    Validate("Other Business Type", CustMembr."Other Business Type");


                    "Post Code" := CustMembr."Post Code";
                    City := CustMembr.City;
                    Nationality := CustMembr.Nationality;
                    //County := CustMembr.County;
                    VALIDATE(County, CustMembr.County);
                    Validate("Phone No.", CustMembr."Alternative Phone No. 1");
                    "Mobile Phone No" := CustMembr."Mobile Phone No";
                    Validate("Current Address", CustMembr."Current Address");
                    Validate("Home Address", CustMembr."Home Address");
                    Validate("Sub Location", CustMembr."Sub Location");
                    Validate(Location, CustMembr.Location);
                    Validate(Division, CustMembr.Division);
                    Validate(District, CustMembr.District);

                    Validate("Employer Code", CustMembr."Employer Code");
                    Validate("Global Dimension 1 Code", CustMembr."Global Dimension 1 Code");
                    Validate("Global Dimension 2 Code", CustMembr."Global Dimension 2 Code");
                    Validate("Recruited by Type", CustMembr."Recruited by Type");
                    Validate("Recruited By", CustMembr."Recruited By");
                    Validate("Recruited By Name", CustMembr."Recruited By Name");
                    Validate("Recruited By Staff No", CustMembr."Recruited By Staff No");
                    Validate("Electrol Zone", CustMembr."Electrol Zone");
                    Validate("Area Service Center", CustMembr."Area Service Center");

                    Validate("Bank Code", CustMembr."Bank Code");
                    Validate("Branch Code", CustMembr."Branch Code");
                    Validate("Bank Account No.", CustMembr."Bank Account No.");
                    Validate("Terms of Employment", CustMembr."Terms of Employment");
                    Validate(Factory, CustMembr.Factory);
                    Validate("Factory Name", CustMembr."Factory Name");

                    Validate("Vote Code", CustMembr."Vote Code");
                    Validate("Nearest Land Mark", CustMembr."Nearest Land Mark");
                    Validate("Buying Centre", CustMembr."Buying Centre");
                    Validate("Buying Centre Name", CustMembr."Buying Centre Name");
                    Validate("Read/Write", CustMembr."Read/Write");
                    Validate("Appointment Date", CustMembr."Appointment Date");
                    Validate("Administrative Location", CustMembr."Administrative Location");
                    Validate("Administrative Sub-Location", CustMembr."Administrative Sub-Location");
                    Validate("Administrative Village", CustMembr."Administrative Village");
                    Validate("Customer CID", CustMembr."Form No.");
                    Validate("Old Member No.", CustMembr."Old Member No.");
                    Validate(Acreage, CustMembr.Acreage);
                    Validate("Society Code", CustMembr."Society Code");
                    Validate("Mobile Centre", CustMembr."Mobile Centre");
                    Validate("Customer Type", CustMembr."Customer Type");
                    Validate("Contract End Date", CustMembr."Contract End Date");
                    Validate(Diocese, CustMembr.Diocese);
                    Validate("Catholic Faithful Refferee", CustMembr."Catholic Faithful Refferee");
                    Validate(Parish, CustMembr.Parish);
                    Validate(Jumuiya, CustMembr.Jumuiya);
                    Validate("Old E-Mail", Cust."E-Mail");
                    Validate("Old ID No", Cust."ID No.");
                    Validate("Old Member Name", Cust.Name);
                    Validate("Old Phone No.", Cust."Mobile Phone No");
                    Validate("Group Type", Cust."Group Type");



                    ImageData.Reset;
                    ImageData.SetRange(ImageData."Member No", CustMembr."No.");
                    if ImageData.Find('-') then begin
                        ImageData.CalcFields(Picture, Signature, "ID - Back Page", "ID - Front Page");
                        Picture := ImageData.Picture;
                        Signature := ImageData.Signature;
                        "ID Front Page" := ImageData."ID - Front Page";
                        "ID Back Page" := ImageData."ID - Back Page";
                    end else begin

                        ImageData.Reset;
                        ImageData.SetRange(ImageData."ID Number", CustMembr."ID No.");
                        if ImageData.Find('-') then begin
                            ImageData.CalcFields(Picture, Signature, "ID - Back Page", "ID - Front Page");
                            Picture := ImageData.Picture;
                            Signature := ImageData.Signature;
                            "ID Front Page" := ImageData."ID - Front Page";
                            "ID Back Page" := ImageData."ID - Back Page";
                        end;
                    end;


                    "Created By" := UserId;
                    /* END;*/




                    /*"Account Type"::Savings :
                     BEGIN*/
                end else
                    if "Account Type" = "Account Type"::Savings then begin
                        if SAccounts.Get("Account No.") then begin

                            if not CustMembr.Get(SAccounts."Member No.") then begin

                                Validate("Member No.", SAccounts."Member No.");
                                Validate("Single Party/Multiple/Business", SAccounts."Single Party/Multiple/Business");
                                Validate(Name, SAccounts.Name);


                                Validate("Account Status", SAccounts.Status);
                                //"Account Status" := SAccounts.Status;
                                //VALIDATE(Blocked, SAccounts.Blocked);
                                Blocked := SAccounts.Blocked;
                                Validate("Relationship Manager", SAccounts."Relationship Manager");
                                Validate("Mobile Phone No", SAccounts."Mobile Phone No");
                                Validate("Transactional Mobile No", SAccounts."Transactional Mobile No");
                                Validate("E-Mail", SAccounts."E-Mail");
                                Validate("Politically Exposed", SAccounts."Politically Exposed");
                                Validate("Political Position", SAccounts."Political Position");
                                Validate("Payroll/Staff No.", SAccounts."Payroll/Staff No.");
                                Validate("ID No.", SAccounts."ID No.");
                                Validate("Passport No.", SAccounts."Passport No.");
                                Validate("Date of Birth", SAccounts."Date of Birth");
                                Validate("Marital Status", SAccounts."Marital Status");
                                Validate("Old Member No.", SAccounts."Old Account No");
                                Validate("Customer CID", SAccounts."Form No.");
                                Validate(Gender, SAccounts.Gender);
                                Validate("Child Name", SAccounts."Child Name");
                                Validate("Monthly Contribution", SAccounts."Monthly Contribution");  //# Check if advice info is populated
                                "Info Base Area" := SAccounts."Info Base Area";
                                "Signing Instructions" := SAccounts."Signing Instructions";
                                "FD Duration" := SAccounts."FD Duration";
                                "FD Maturity Date" := SAccounts."FD Maturity Date";
                                "FD Maturity Instructions" := SAccounts."FD Maturity Instructions";
                                "FD Start Date" := SAccounts."FD Start Date";
                                "Fixed Deposit Amount" := SAccounts."Fixed Deposit Amount";
                                "Fixed Deposit cert. no" := SAccounts."Fixed Deposit cert. no";
                                "Fixed Deposit Status" := SAccounts."Fixed Deposit Status";
                                "Fixed Deposit Type" := SAccounts."Fixed Deposit Type";
                                "Neg. Interest Rate" := SAccounts."Neg. Interest Rate";
                                "Savings Account No." := SAccounts."Savings Account No.";

                                Validate("Enable Sweeping", SAccounts."Enable Sweeping");
                                Validate(Hide, SAccounts."Special Account");
                                //      VALIDATE("Bank Account No.",SAccounts."External Account No");
                                //      VALIDATE("Branch Code",SAccounts."Bank Code");

                                Validate("Birth Certificate No.", SAccounts."Birth Certificate No.");
                                Validate("Parent Account No.", SAccounts."Parent Account No.");


                                Validate("Product Type", SAccounts."Product Type");
                                Validate("Product Name", SAccounts."Product Name");
                                Validate("Product Category", SAccounts."Product Category");

                                Validate("Group Account", SAccounts."Group Account");
                                Validate("Group Account No.", SAccounts."Group Account No");
                                Validate("Company Registration No.", SAccounts."Company Registration No.");

                                "Post Code" := SAccounts."Post Code";
                                City := SAccounts.City;
                                //VALIDATE(County, SAccounts.County);
                                Validate("Phone No.", SAccounts."Alternative Phone No. 1");
                                Validate("Mobile Phone No", SAccounts."Mobile Phone No");
                                Validate("E-Mail", SAccounts."E-Mail");
                                Validate("Current Address", SAccounts."Current Address");
                                Validate("Home Address", SAccounts."Home Address");
                                Validate("Mobile Centre", SAccounts."Mobile Centre");
                                //Waumini training reworks changes
                                //Validate("Employer Code", SAccounts."Employer Code");
                                Validate("Global Dimension 1 Code", SAccounts."Global Dimension 1 Code");
                                Validate("Global Dimension 2 Code", SAccounts."Global Dimension 2 Code");
                                Validate("Recruited by Type", SAccounts."Recruited by Type");
                                Validate("Recruited By", SAccounts."Recruited By");



                                ImageData.Reset;
                                ImageData.SetRange(ImageData."Member No", SAccounts."No.");
                                if ImageData.Find('-') then begin
                                    ImageData.CalcFields(Picture, Signature, "ID - Back Page", "ID - Front Page");
                                    Picture := ImageData.Picture;
                                    Signature := ImageData.Signature;
                                    "ID Front Page" := ImageData."ID - Front Page";
                                    "ID Back Page" := ImageData."ID - Back Page";
                                end else begin

                                    ImageData.Reset;
                                    ImageData.SetRange(ImageData."ID Number", SAccounts."ID No.");
                                    if ImageData.Find('-') then begin
                                        ImageData.CalcFields(Picture, Signature, "ID - Back Page", "ID - Front Page");
                                        Picture := ImageData.Picture;
                                        Signature := ImageData.Signature;
                                        "ID Front Page" := ImageData."ID - Front Page";
                                        "ID Back Page" := ImageData."ID - Back Page";
                                    end;
                                end;




                            end else begin
                                Validate("Member No.", CustMembr."No.");
                                Validate("Single Party/Multiple/Business", CustMembr."Single Party/Multiple");
                                Validate("First Name", CustMembr."First Name");
                                Validate("Second Name", CustMembr."Second Name");
                                Validate("Last Name", CustMembr."Last Name");
                                Validate(Name, CustMembr.Name);
                                Validate("Politically Exposed", CustMembr."Politically Exposed");
                                Validate("Political Position", CustMembr."Political Position");
                                Validate("P.I.N Number", CustMembr."P.I.N Number");
                                Validate("Member Segment", CustMembr."Member Station");
                                Validate("Member Category", CustMembr."Member Category");
                                Validate("Relationship Manager", CustMembr."Relationship Manager");
                                Validate("Mobile Phone No", CustMembr."Mobile Phone No");
                                Validate("E-Mail", CustMembr."E-Mail");
                                Validate("Personal E-mail", CustMembr."Personal E-mail");
                                //VALIDATE("Sacco CID",CustMembr."Sacco CID");
                                Validate("Payroll/Staff No.", CustMembr."Payroll/Staff No.");
                                Validate("ID No.", CustMembr."ID No.");
                                Validate("Passport No.", CustMembr."Passport No.");
                                Validate("Date of Birth", CustMembr."Date of Birth");
                                Validate("Marital Status", CustMembr."Marital Status");
                                Validate(Gender, CustMembr.Gender);
                                Validate("Tax Exempted", CustMembr."Tax Exempted");
                                Validate("Tax Waiver End Date", CustMembr."Tax Waiver End Date");
                                Validate("Old Member No.", SAccounts."Old Account No");
                                Validate("Customer CID", SAccounts."Form No.");
                                Validate("Contract End Date", CustMembr."Contract End Date");

                                Validate("Signing Instructions", SAccounts."Signing Instructions");
                                "FD Duration" := SAccounts."FD Duration";
                                "FD Maturity Date" := SAccounts."FD Maturity Date";
                                "Fixed Deposit Amount" := SAccounts."Fixed Deposit Amount";
                                "Fixed Deposit cert. no" := SAccounts."Fixed Deposit cert. no";
                                "Fixed Deposit Status" := SAccounts."Fixed Deposit Status";
                                "Fixed Deposit Type" := SAccounts."Fixed Deposit Type";
                                "FD Maturity Instructions" := SAccounts."FD Maturity Instructions";
                                "FD Start Date" := SAccounts."FD Start Date";
                                "Neg. Interest Rate" := SAccounts."Neg. Interest Rate";
                                Validate("Savings Account No.", SAccounts."Savings Account No.");

                                Validate("Birth Certificate No.", SAccounts."Birth Certificate No.");
                                Validate("Parent Account No.", SAccounts."Parent Account No.");


                                Validate("Product Type", SAccounts."Product Type");
                                Validate("Product Name", SAccounts."Product Name");
                                Validate("Product Category", SAccounts."Product Category");
                                //VALIDATE("Account Status", SAccounts.Status);
                                "Account Status" := SAccounts.Status;
                                // VALIDATE(Blocked, SAccounts.Blocked);
                                Blocked := SAccounts.Blocked;

                                Validate("Group Account", SAccounts."Group Account");
                                Validate("Group Account No.", CustMembr."Group Code");
                                Validate("Group Type", CustMembr."Group Type");
                                Validate("Nature of Business", CustMembr."Nature of Business");
                                Validate("Company Registration No.", CustMembr."Company Registration No.");
                                Validate("Date of Business Reg.", CustMembr."Date of Business Reg.");
                                Validate("Business/Group Location", CustMembr."Business/Group Location");
                                Validate("Plot/Bldg/Street/Road", CustMembr."Plot/Bldg/Street/Road");
                                Validate("Type of Business", CustMembr."Type of Business");
                                Validate("Ownership Type", CustMembr."Ownership Type");
                                Validate("Other Business Type", CustMembr."Other Business Type");

                                Validate("Post Code", CustMembr."Post Code");
                                Validate(City, CustMembr.City);
                                Nationality := CustMembr.Nationality;
                                //VALIDATE(County, CustMembr.County);
                                Validate("Phone No.", CustMembr."Alternative Phone No. 1");
                                Validate("Mobile Phone No", CustMembr."Mobile Phone No");
                                Validate("E-Mail", CustMembr."E-Mail");
                                Validate("Personal E-mail", CustMembr."Personal E-mail");
                                Validate("Current Address", CustMembr."Current Address");
                                Validate("Home Address", CustMembr."Home Address");
                                Validate("Sub Location", CustMembr."Sub Location");
                                Validate(Location, CustMembr.Location);
                                Validate(Division, CustMembr.Division);
                                Validate(District, CustMembr.District);
                                Validate("Employer Type", CustMembr."Employer Type");


                                Validate("Employer Code", CustMembr."Employer Code");
                                Validate("Terms of Employment", CustMembr."Terms of Employment");
                                Validate("External Employer Name", CustMembr."External Employer Name");
                                Validate("Global Dimension 1 Code", CustMembr."Global Dimension 1 Code");
                                Validate("Global Dimension 2 Code", CustMembr."Global Dimension 2 Code");
                                Validate("Recruited by Type", CustMembr."Recruited by Type");
                                Validate("Recruited by Type", CustMembr."Recruited by Type");
                                Validate("Recruited By", CustMembr."Recruited By");
                                Validate("Recruited By Name", CustMembr."Recruited By Name");
                                Validate("Recruited By Staff No", CustMembr."Recruited By Staff No");
                                Validate("Recruited By", CustMembr."Recruited By");
                                Validate("Electrol Zone", CustMembr."Electrol Zone");
                                Validate("Area Service Center", CustMembr."Area Service Center");

                                Validate("Bank Code", CustMembr."Bank Code");
                                Validate("Branch Code", CustMembr."Branch Code");
                                Validate("Bank Account No.", CustMembr."Bank Account No.");
                                Validate("Mobile Centre", CustMembr."Mobile Centre");


                                ImageData.Reset;
                                ImageData.SetRange(ImageData."Member No", CustMembr."No.");
                                if ImageData.Find('-') then begin
                                    ImageData.CalcFields(Picture, Signature, "ID - Back Page", "ID - Front Page");
                                    Picture := ImageData.Picture;
                                    Signature := ImageData.Signature;
                                    "ID Front Page" := ImageData."ID - Front Page";
                                    "ID Back Page" := ImageData."ID - Back Page";
                                end else begin

                                    ImageData.Reset;
                                    ImageData.SetRange(ImageData."ID Number", CustMembr."ID No.");
                                    if ImageData.Find('-') then begin
                                        ImageData.CalcFields(Picture, Signature, "ID - Back Page", "ID - Front Page");
                                        Picture := ImageData.Picture;
                                        Signature := ImageData.Signature;
                                        "ID Front Page" := ImageData."ID - Front Page";
                                        "ID Back Page" := ImageData."ID - Back Page";
                                    end;
                                end;


                            end;
                        end;
                    end;
                /*END;*/

                IF NOT GuiAllowed then if (Rec."Account No." = xRec."Account No.") then exit;

                ReactivateDeactivateHeader.Reset;
                ReactivateDeactivateHeader.SetRange(ReactivateDeactivateHeader."Account No.", "Account No.");
                ReactivateDeactivateHeader.SetRange(ReactivateDeactivateHeader.Status, Status::Open, Status::Pending);
                ReactivateDeactivateHeader.SetRange(Type, Type);
                if ReactivateDeactivateHeader.Find('-') then begin
                    repeat
                        if ReactivateDeactivateHeader."Account No." <> '' then
                            if Count >= 1 then
                                Error(MultipleApplicationsError);
                    until ReactivateDeactivateHeader.Next = 0;
                end;

                ///Get Signatory
                GetSignatory;
                GetJointMembers;
                GetNextofkin;
                GetClass_Factory;
                GetBeneficiary;

            end;
        }
        field(8; Name; Text[100])
        {
        }
        field(9; Description; Text[50])
        {
            Caption = 'Remarks';
        }
        field(11; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(12; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(13; "Responsibility Center"; Code[20])
        {
            Description = 'LookUp to Responsibility Center BR';
            TableRelation = "Responsibility Center";
        }
        field(14; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(15; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(16; "First Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(17; "Second Name"; Text[50])
        {
            Description = 'Maintain names separately';

            trigger OnValidate()
            begin
                "Second Name" := DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(18; "Last Name"; Text[50])
        {
            Description = 'Names separately';

            trigger OnValidate()
            begin
                "Last Name" := DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(19; "Member Segment"; Code[20])
        {
            Description = 'LookUp to Member Segment Table where Type = Segment';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));
        }
        field(20; "Member No."; Code[20])
        {
            TableRelation = Members."No.";
        }
        field(21; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Rejected,Approved,Processed';
            OptionMembers = Open,Pending,Rejected,Approved,Processed;
        }
        field(22; "Account Status"; Option)
        {
            OptionCaption = ' ,New,Active,Dormant,Frozen,Withdrawal Application,Withdrawn,Deceased,Defaulter,Closed';
            OptionMembers = " ",New,Active,Dormant,Frozen,"Withdrawal Application",Withdrawn,Deceased,Defaulter,Closed;

            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::Savings then begin
                    if "Account Status" = "Account Status"::Closed then begin
                        SavingsAccounts.Reset;
                        SavingsAccounts.SetRange("Savings Account No.", "Account No.");
                        if SavingsAccounts.Find('-') then begin
                            SavingsAccounts.CalcFields("Balance (LCY)");
                            if SavingsAccounts."Balance (LCY)" <> 0 then
                                Error(Erro0001);
                        end;
                        Blocked := Blocked::All;
                    end;

                    if "Account Status" = xRec."Account Status"::Deceased then
                        Error('You cannot activate deceased account');

                    if "Account Status" = "Account Status"::Active then
                        Blocked := Blocked::" ";

                end
                else
                    if "Account Type" = "Account Type"::Member then begin

                        if "Account Status" = xRec."Account Status"::Deceased then
                            Error('You cannot activate decesaed account')
                    end;
            end;
        }
        field(23; Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ",Credit,Debit,All;

            trigger OnValidate()
            begin
                // MyComment:=Window.InputBox('Enter reason for update: '+FORMAT(Blocked),'account:'+"Account No.",'',100,100);
                // IF MyComment='' THEN ERROR('Kindly Enter reason for updating status for this account');
                // "Block Reason":=MyComment;
            end;
        }
        field(24; "Payroll/Staff No."; Code[20])
        {

            trigger OnValidate()
            begin

                if "Account Type" = "Account Type"::Member then begin
                    Cust.Reset;
                    Cust.SetFilter("No.", '<>%1', "Account No.");
                    Cust.SetRange(Cust."Payroll/Staff No.", "Payroll/Staff No.");
                    if Cust.FindFirst then
                        Error(MemberExistError, Cust."No.", Cust.Name);
                end;
            end;
        }
        field(25; "ID No."; Code[50])
        {

            trigger OnValidate()
            begin
                if "ID No." <> DelChr("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_') then
                    Error('Invalid ID No.');

                /*``
                FieldLength("ID No.",10);
                */
                if "ID No." <> '' then begin

                    /*
                    ReactivateDeactivateHeader.RESET;
                    ReactivateDeactivateHeader.SETRANGE(ReactivateDeactivateHeader."ID No.","ID No.");
                    IF ReactivateDeactivateHeader.FIND('-') THEN BEGIN
                     REPEAT
                      IF (ReactivateDeactivateHeader.Status IN [ReactivateDeactivateHeader.Status::Open,ReactivateDeactivateHeader.Status::Pending,
                                                       ReactivateDeactivateHeader.Status::Approved]) THEN
                       IF ReactivateDeactivateHeader.COUNT >1 THEN  MESSAGE(FORMAT(ReactivateDeactivateHeader.COUNT));
                       ERROR(MemberExistError,ReactivateDeactivateHeader."No.",ReactivateDeactivateHeader.Name);
                       UNTIL ReactivateDeactivateHeader.NEXT=0;
                    END;
                    */

                    if "Account Type" = "Account Type"::Member then begin
                        Customer.Reset;
                        Customer.SetFilter("No.", '<>%1', "Account No.");
                        Customer.SetRange(Customer."ID No.", "ID No.");
                        Customer.SetFilter(Customer.Status, '<>%1', Customer.Status::Closed);
                        if Customer.FindFirst then
                            Error(MemberExistError, Customer."No.", Customer.Name);
                    end;
                end;



                GeneralSetUp.Get;
                GeneralSetUp.TestField("ID Character Limit");
                if StrLen("ID No.") > GeneralSetUp."ID Character Limit" then
                    Error('ID Number must be less than or equal to %1 digits', GeneralSetUp."ID Character Limit");

            end;
        }
        field(26; "Passport No."; Code[20])
        {

            trigger OnValidate()
            begin

                if "Passport No." <> '' then begin

                    if "Account Type" = "Account Type"::Member then begin
                        Customer.Reset;
                        Customer.SetFilter("No.", '<>%1', "Account No.");
                        Customer.SetRange(Customer."Passport No.", "Passport No.");
                        Customer.SetFilter(Customer.Status, '<>%1', Customer.Status::Closed);
                        if Customer.FindFirst then
                            Error(MemberExistError, Customer."No.", Customer.Name);
                    end;
                end;
            end;
        }
        field(28; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(29; "Product Type"; Code[20])
        {
            Editable = false;
        }
        field(30; "Product Name"; Text[100])
        {
            Editable = false;
        }
        field(31; "Document Type"; Option)
        {
            OptionCaption = ' ,Reactivate,Deactivate';
            OptionMembers = " ",Reactivate,Deactivate;
        }
        field(50; "Created By"; Code[60])
        {
            Editable = false;
        }
        field(55; "Employer Code"; Code[20])
        {
            //TableRelation = Customer WHERE("Account Type" = CONST(Employer));

            trigger OnValidate()
            begin
                /*if Customr.Get("Employer Code") then begin
                    "Employer Name" := Customr.Name;
                    "Self Employed" := Customr."Self Employed";
                end;*/
            end;
        }
        field(56; "Date of Birth"; Date)
        {

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date of Birth" > Today then
                    Error(DateofBirthError);
                /*
                GeneralSetUp.GET;
                IF "Date of Birth" >  CALCDATE(GeneralSetUp."Min. Member Age",TODAY) THEN
                 ERROR(MinimumAgeError,CALCDATE(GeneralSetUp."Min. Member Age",TODAY));*/

            end;
        }
        field(60; "Mobile Phone No"; Code[50])
        {

            trigger OnValidate()
            begin
                "Mobile Phone No" := DelChr("Mobile Phone No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');


                if "Account Type" = "Account Type"::Member then begin
                    if "Mobile Phone No" <> '' then begin
                        Cust.Reset;
                        Cust.SetRange(Cust."Mobile Phone No", "Mobile Phone No");
                        Cust.SetFilter(Cust.Status, '<>%1', Cust.Status::Closed);
                        Cust.SetFilter("No.", '<>%1', "Account No.");
                        if Cust.FindFirst then
                            Error('Member Already Exists with the same Mobile No. - %1-%2', Cust."No.", Cust.Name);
                    end;
                end;

                /*
                IF CountryRegion.GET(Nationality) THEN BEGIN
                    NewMob:='';
                    NewMob:=COPYSTR("Mobile Phone No",1,4);
                    IF (COPYSTR("Mobile Phone No",1,4))<>(CountryRegion."County Phone Code") THEN
                    ERROR('The Mobile phone No. should take the format of '+CountryRegion."County Phone Code");
                    IF STRLEN("Mobile Phone No") <> 13 THEN
                       ERROR('Phone No. should be equal to 13 characters');
                END;
                */

            end;
        }
        field(61; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Divorced,Widower,Widow;
        }
        field(63; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(65; "Post Code"; Code[50])
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
        field(66; City; Text[50])
        {
            Caption = 'City';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(68; County; Text[50])
        {
            Caption = 'County';
            Description = 'LookUp to Member Segment Table where Type = County';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
        }
        field(69; "Bank Code"; Code[20])
        {
            Description = 'LookUp to Banks Table';
            TableRelation = "PR Bank Accounts"."Bank Code";
        }
        field(70; "Branch Code"; Code[20])
        {
            Description = 'LookUp to Banks Table';
            TableRelation = "PR Bank Branches"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
        }
        field(71; "Recruited By"; Code[20])
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
                if "Recruited by Type" = "Recruited by Type"::Marketer then begin
                    SalespersonPurchaser.Reset;
                    SalespersonPurchaser.SetRange(Code, "Recruited By");
                    if SalespersonPurchaser.Find('-') then begin
                        "Recruited By Name" := SalespersonPurchaser.Name;
                    end;
                end else
                    if "Recruited by Type" = "Recruited by Type"::"Board Member" then begin
                        Members.Reset;
                        Members.SetRange("No.", "Recruited By");
                        if Members.Find('-') then begin
                            "Recruited By Name" := Members.Name;
                        end;
                    end else
                        if "Recruited by Type" = "Recruited by Type"::Staff then begin
                            HREmployees.Reset;
                            HREmployees.SetRange("No.", "Recruited By");
                            if HREmployees.Find('-') then begin
                                "Recruited By Name" := HREmployees."Full Name";
                                "Recruited By Staff No" := HREmployees."No.";
                            end;
                        end else
                            if "Recruited by Type" = "Recruited by Type"::Member then begin
                                Members.Reset;
                                Members.SetRange("No.", "Recruited By");
                                if Members.Find('-') then begin
                                    "Recruited By Name" := Members.Name;
                                    "Recruited By Staff No" := Members."Payroll/Staff No.";
                                end;
                            end else begin
                                //  HREmployees.RESET;
                                //  HREmployees.SETRANGE("No.","Recruited By");
                                //  IF HREmployees.FIND('-') THEN
                                //    BEGIN
                                "Recruited By Name" := "Recruited By";
                                // END;
                            end;
            end;
        }
        field(73; "Type of Business"; Option)
        {
            OptionCaption = ' ,Sole Proprietor,Partnership,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor",Partnership,"Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
        }
        field(74; "Other Business Type"; Text[15])
        {
        }
        field(75; "Ownership Type"; Option)
        {
            OptionCaption = ' ,Personal Account,Joint Account,Group/Business,FOSA Shares';
            OptionMembers = " ","Personal Account","Joint Account","Group/Business","FOSA Shares";
        }
        field(76; "Other Account Type"; Text[15])
        {
        }
        field(77; "Nature of Business"; Text[30])
        {
        }
        field(78; "Bank Account No."; Code[20])
        {

            trigger OnValidate()
            begin
                //IF STRLEN("Bank Account No.") <>13 THEN
                //ERROR('Invalid Bank account No. Please enter the correct Bank Account No.');
            end;
        }
        field(79; "Company Registration No."; Code[20])
        {

            trigger OnValidate()
            begin
                /*IF "Company Registration No." <>'' THEN BEGIN
                CustMembr.RESET;
                CustMembr.SETRANGE(CustMembr."Company Registration No.","Company Registration No.");
                IF CustMembr.FINDFIRST THEN
                 ERROR(MemberExistError,CustMembr."No.",CustMembr.Name);
                END;*/

            end;
        }
        field(80; "Date of Business Reg."; Date)
        {

            trigger OnValidate()
            begin
                if "Date of Business Reg." > Today then
                    Error(DateofBirthError);
            end;
        }
        field(81; "Business/Group Location"; Text[50])
        {
        }
        field(82; "P.I.N Number"; Code[20])
        {

            trigger OnValidate()
            begin
                //FieldLength("ID No.",15);

                /*IF "P.I.N Number" <>'' THEN BEGIN
                CustMembr.RESET;
                CustMembr.SETRANGE(CustMembr."P.I.N Number","P.I.N Number");
                IF CustMembr.FINDFIRST THEN
                 ERROR(MemberExistError,CustMembr."No.",CustMembr.Name);
                END;*/


                if "Account Type" = "Account Type"::Member then begin
                    Customer.Reset;
                    Customer.SetFilter("No.", '<>%1', "Account No.");
                    Customer.SetRange(Customer."P.I.N Number", "P.I.N Number");
                    Customer.SetFilter(Customer.Status, '<>%1', Customer.Status::Closed);
                    if Customer.FindFirst then
                        Error(MemberExistError, Customer."No.", Customer.Name);
                end;

            end;
        }
        field(83; "Plot/Bldg/Street/Road"; Text[50])
        {
        }
        field(84; "Group Type"; Option)
        {
            OptionCaption = ' ,Welfare,Church,Investment Club,Others';
            OptionMembers = " ",Welfare,Church,"Investment Club",Others;
        }
        field(85; "Single Party/Multiple/Business"; Option)
        {
            OptionCaption = 'Single,Group,Corporate';
            OptionMembers = Single,Multiple,Business;
        }
        field(86; "Birth Certificate No."; Code[15])
        {
        }
        field(87; "Group Account No."; Code[20])
        {
            Description = 'LookUp to Member where Group Account = Yes';
            TableRelation = Members WHERE("Group Account" = FILTER(true),
                                           "Customer Type" = CONST(Microfinance));
        }
        field(88; "MPESA Mobile No"; Code[13])
        {
            CharAllowed = '0123456789';
        }
        field(89; "Group Account"; Boolean)
        {
        }
        field(90; "Recruited by Type"; Option)
        {
            OptionCaption = 'Marketer,Others,Staff,Board Member,Member';
            OptionMembers = Marketer,Others,Staff,"Board Member",Member;

            trigger OnValidate()
            begin
                "Recruited By" := '';
                "Recruited By Name" := '';
                "Recruited By Staff No" := '';
            end;
        }
        field(91; "Employer Name"; Text[50])
        {
        }
        field(92; "Member Category"; Code[20])
        {
            TableRelation = "Member Category";

            trigger OnValidate()
            begin
                MemberCategory.Reset;
                MemberCategory.SetRange("No.", "Member Category");
                if MemberCategory.Find('-') then begin
                    if "Account Type" = "Account Type"::Member then begin
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
                        end;
                    end;
                end;
            end;
        }
        field(93; "Relationship Manager"; Code[20])
        {
            TableRelation = "HR Employees" WHERE(Status = FILTER(Active));
        }
        field(94; "Statement E-Mail Freq."; DateFormula)
        {
        }
        field(95; Classification; Option)
        {
            OptionCaption = ' ,Good Standing,Bad Standing';
            OptionMembers = " ","Good Standing","Bad Standing";
        }
        field(96; "Electrol Zone"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Electral Zone"));
        }
        field(97; "Area Service Center"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Area Service Centers"));
        }
        field(98; "Current Address"; Text[50])
        {
            Caption = 'Address';
        }
        field(99; "Home Address"; Text[50])
        {
            Caption = 'Home Address';
        }
        field(100; "Phone No."; Text[50])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(101; Nationality; Code[30])
        {
            TableRelation = "Country/Region";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                /* if StrLen("Mobile Phone No") < 9 then begin
                     if CountryRegion.Get(Nationality) then
                         "Mobile Phone No" := CountryRegion."County Phone Code"
                 end; */
            end;
        }
        field(102; "Terms of Employment"; Option)
        {
            OptionMembers = " ",Permanent,Contract,Casual;
        }
        field(114; Source; Option)
        {
            Description = 'Used to identify origin of Member Application [CRM, Navision, Web]';
            OptionCaption = ' ,Navision,CRM,Web';
            OptionMembers = " ",Navision,CRM,Web;
        }
        field(115; Picture; BLOB)
        {
            Caption = 'Picture';
            Description = 'Used to capture applicant Photos and should be deleted on account creation.';
            SubType = Bitmap;
        }
        field(116; Signature; BLOB)
        {
            Caption = 'Signature';
            Description = 'Used to capture applicant Signature and should be deleted on account creation.';
            SubType = Bitmap;
        }
        field(118; "Fixed Deposit Status"; Option)
        {
            OptionCaption = ' ,Active,Matured,Closed,Not Matured';
            OptionMembers = " ",Active,Matured,Closed,"Not Matured";
        }
        field(119; "FD Marked for Closure"; Boolean)
        {
        }
        field(120; "Expected Maturity Date"; Date)
        {
        }
        field(121; "Savings Account No."; Code[20])
        {
            Description = 'LookUp to Savings Account Table';
            TableRelation = "Savings Accounts" WHERE("Member No." = FIELD("Member No."));
        }
        field(122; "Parent Account No."; Code[20])
        {
            Description = 'LookUp to Member Table';
            TableRelation = "Savings Accounts" WHERE("Member No." = FIELD("Member No."),
                                                      "Product Category" = FILTER(" "));
        }
        field(123; "Fixed Deposit Type"; Code[20])
        {
            Description = 'LookUp to Fixed Deposit Type Table';
            TableRelation = "Fixed Deposit Type" WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin

                TestField("FD Start Date");
                if FixedDepositType.Get("Fixed Deposit Type") then begin
                    "FD Maturity Date" := CalcDate(FixedDepositType.Duration, "FD Start Date");
                    "FD Duration" := FixedDepositType.Duration;
                    "Product Category" := "Product Category"::"Fixed Deposit";
                end;

                Validate("FD Maturity Instructions");
            end;
        }
        field(124; "FD Maturity Date"; Date)
        {
        }
        field(125; "Monthly Contribution"; Decimal)
        {
        }
        field(126; "Product Category"; Option)
        {
            OptionCaption = ' ,Share Capital,Deposit Contribution,Fixed Deposit,Junior Savings,Registration Fee,Benevolent,Unallocated Fund,Micro Credit Deposits';
            OptionMembers = " ","Share Capital","Deposit Contribution","Fixed Deposit","Junior Savings","Registration Fee",Benevolent,"Unallocated Fund","Micro Credit Deposits";
        }
        field(127; "Neg. Interest Rate"; Decimal)
        {
        }
        field(128; "FD Duration"; DateFormula)
        {

            trigger OnValidate()
            begin
                //"FD Maturity Date":=CALCDATE("FD Duration","Application Date");
            end;
        }
        field(129; "FD Maturity Instructions"; Option)
        {
            OptionCaption = ' ,Transfer all to Savings,Renew Principal,Renew Principal & Interest,Forefeit Interest';
            OptionMembers = " ","Transfer all to Savings","Renew Principal","Renew Principal & Interest","Forefeit Interest";

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
        field(130; "Fixed Deposit cert. no"; Code[30])
        {
            Description = 'Capture FxD certificate Number';
        }
        field(131; "Fixed Deposit Amount"; Decimal)
        {
        }
        field(132; "Signing Instructions"; Option)
        {
            OptionMembers = "Any Two","Any Three",All;
        }
        field(133; "Dividend Payment Method"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat" WHERE(Type = CONST("Dividend Payment Type"));
        }
        field(134; Hide; Boolean)
        {
        }
        field(135; "Enable Sweeping"; Boolean)
        {
        }
        field(136; "Tax Exempted"; Boolean)
        {
            Caption = 'Physically Challenged';
        }
        field(137; "Entry Type"; Option)
        {
            OptionCaption = 'Initial,Changes';
            OptionMembers = Initial,Changes;
        }
        field(138; "Block Reason"; Text[100])
        {
            Editable = false;
        }
        field(139; Factory; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = FILTER(Factory));
        }
        field(140; "Factory Name"; Text[50])
        {
            Editable = false;
        }
        field(141; "Reasons for Status Change"; Text[50])
        {
        }
        field(158; "Sub Location"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(159; Location; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(160; Division; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(161; District; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50054; "ID Front Page"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50055; "ID Back Page"; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50056; "Personal E-mail"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //if "Personal E-mail"<>'' then
                //SMTPMail.CheckValidEmailAddresses("Personal E-mail");
            end;
        }
        field(50057; "Recruited By Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50058; "Recruited By Staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50059; "Meeting Days"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50060; "Meeting Time"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50061; "Meeting Venue"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(39004247; "Old Member No."; Code[20])
        {
        }
        field(39004256; "Vote Code"; Code[30])
        {
        }
        field(39004257; "Nearest Land Mark"; Text[100])
        {
        }
        field(39004258; "Buying Centre"; Code[30])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = FILTER("Buying Centre"));

            trigger OnValidate()
            begin
                /*BuyingCentre.RESET;
                BuyingCentre.SETRANGE(Code,"Buying Centre");
                IF BuyingCentre.FIND('-') THEN
                  BEGIN
                    "Buying Centre Name":=  FORMAT(BuyingCentre.Description,50);
                    END;*/

            end;
        }
        field(39004259; "Buying Centre Name"; Text[50])
        {
            Editable = false;
        }
        field(39004261; "Read/Write"; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(39004262; "Appointment Date"; Date)
        {
        }
        field(39004265; "Administrative Location"; Code[20])
        {
        }
        field(39004266; "Administrative Sub-Location"; Code[30])
        {
        }
        field(39004267; "Administrative Village"; Code[20])
        {
        }
        field(39004268; Unit; Text[50])
        {
        }
        field(39004269; Acreage; Text[50])
        {
        }
        field(39004270; "Customer CID"; Code[20])
        {
        }
        field(39004271; "Society Code"; Code[10])
        {
            //TableRelation = Societies."No.";
        }
        field(39004272; "Self Employed"; Boolean)
        {
        }
        field(39004273; "Info Base Area"; Text[250])
        {
        }
        field(39004274; "Mobile Centre"; Code[50])
        {
        }
        field(39004275; "Alternative Phone No. 1"; Text[13])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(39004276; "Alternative Phone No. 2"; Text[13])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(39004277; "Needs Authorization"; Boolean)
        {
        }
        field(39004278; "FD Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if "FD Start Date" <> 0D then begin
                    if FixedDepositType.Get("Fixed Deposit Type") then begin
                        "FD Maturity Date" := CalcDate(FixedDepositType.Duration, "FD Start Date");
                        "FD Duration" := FixedDepositType.Duration;
                        "Product Category" := "Product Category"::"Fixed Deposit";
                    end;
                end;

                Validate("FD Maturity Instructions");
            end;
        }
        field(39004279; Type; Option)
        {
            OptionCaption = 'Member Change,Status Change';
            OptionMembers = "Member Change","Status Change";
        }
        field(39004280; "Member Status"; Option)
        {
            OptionCaption = ' ,New,Active,Dormant,Frozen,Withdrawal Application,Withdrawn,Deceased,Defaulter,Closed,Blocked';
            OptionMembers = " ",New,Active,Dormant,Frozen,"Withdrawal Application",Withdrawn,Deceased,Defaulter,Closed,Blocked;

            trigger OnValidate()
            begin

                if "Account Type" = "Account Type"::Member then begin

                    if "Member Status" = xRec."Member Status"::Deceased then
                        Error('You cannot activate decesaed account');

                    if "Member Status" <> "Member Status"::Active then begin
                        Validate(Blocked, Blocked::All);
                    end
                    else begin
                        Validate(Blocked, Blocked::" ");
                    end;
                end;

                //MyComment:=Window.InputBox('Enter reason for update:: '+FORMAT("Member Status"),'account:'+"Account No.",'',100,100);
                //IF MyComment='' THEN ERROR('Kindly Enter reason for updating this account');

                //"Reasons for Status Change":=MyComment;
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
        field(39004283; "Account Category"; Option)
        {
            OptionCaption = 'Member,Staff Members,Board Members,Delegates';
            OptionMembers = Member,"Staff Members","Board Members",Delegates;
        }
        field(39004284; "Dividend Account"; Code[20])
        {
            TableRelation = "Savings Accounts";
        }
        field(39004285; "User Branch"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(39004286; "Customer Type"; Option)
        {
            OptionCaption = ' ,Single,Joint,Group,Microfinance,Cell';
            OptionMembers = " ",Single,Joint,Group,Microfinance,Cell;
        }
        field(39004293; "Child Name"; Text[150])
        {
        }
        field(39004294; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004300; "Tax Waiver End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004301; "Member Station"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'LookUp to Member Segment Table where Type = Segment';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));
        }
        field(39004302; "Registration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39004303; "Change Started"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39004304; "Transactional Mobile No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(39004305; Diocese; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Diocese.Code;
        }
        field(39004306; Parish; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Parish.Code where("Diocese Code" = field(Diocese));
        }
        field(39004307; Jumuiya; code[50])
        {
            TableRelation = Jumuiya.Code where(Diocese = field(Diocese), Parish = field(Parish));
            DataClassification = ToBeClassified;
        }
        field(39004308; "External Employer Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                //  if "Employer Code" <> '' then
                //     Error('Employer code must not have a value');
            end;
        }
        field(39004309; "Catholic Faithful Refferee"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members."No." where("Member Type" = const("Catholic Faithful"));

        }
        field(39004310; "Old Member Name"; Text[150])
        {
            //FieldClass = FlowField;
            //CalcFormula = lookup(Members.Name where("No." = field("Account No.")));

            // DataClassification = ToBeClassified;
        }
        field(39004311; "Old ID No"; Text[150])
        {
            // FieldClass = FlowField;
            // CalcFormula = lookup(Members."ID No." where("No." = field("Account No.")));

            // DataClassification = ToBeClassified;
        }
        field(39004312; "Old E-Mail"; Text[150])
        {
            // FieldClass = FlowField;
            // CalcFormula = lookup(Members."E-Mail" where("No." = field("Account No.")));

            // DataClassification = ToBeClassified;
        }
        field(39004313; "Old Phone No."; Code[50])
        {
            // FieldClass = FlowField;
            // CalcFormula = lookup(Members."Mobile Phone No" where("No." = field("Account No.")));

            // DataClassification = ToBeClassified;
        }
        field(39004314; "Employer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Internal,External;
        }
        field(39004315; "Portal Status"; Option)
        {
            OptionMembers = Open,Submitted;
        }
        field(39004316; "User Comment"; Text[150])
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

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Member Reactivation Nos.");
            NoSeriesMgt.InitSeries(SeriesSetup."Member Reactivation Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Application Date" := Today;
        "Created By" := UserId;

        if UserSetup.Get(UserId) then begin
            /*  UserSetup.TestField(UserSetup."Global Dimension 1 Code");
             UserSetup.TestField(UserSetup."Global Dimension 2 Code");
             //"Global Dimension 1 Code":= UserSetup."Global Dimension 1 Code";
             "User Branch" := UserSetup."Global Dimension 2 Code";
             "Responsibility Center" := UserSetup."Responsibility Centre"; */
        end;
    end;

    trigger OnModify()
    begin
        // Message(format(UserSecurityId()));
        // Message(format(SystemCreatedBy));
        if not "Change Started" then
            "Change Started" := true;
        //if UserSecurityId() <> SystemCreatedBy then
        Error('Member change can only be modified by the user who created it.');
    end;

    var
        Customr: Record Customer;
        Sav: Record "Savings Accounts";
        Cust: Record Members;
        Product: Record "Product Factory";
        MemberCategory: Record "Member Category";
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserSetup: Record "User Setup";
        CustMembr: Record Members;
        SAccounts: Record "Savings Accounts";
        ReactivateDeactivateHeader: Record "Reactivate/Deactivate Header";
        MultipleApplicationsError: Label 'Applicant has a similar application being processed.';
        GeneralSetUp: Record "General Set-Up";
        Text018: Label 'This applicant is below the mininmum membership age of %1. Is the applicant applying for a junior account';
        DateofBirthError: Label 'Date cannot be greater than today.';
        MinimumAgeError: Label 'Date of birth must be less than %1';
        MemberExistError: Label 'Number already exists with member %1 Name: %2';
        Addr: Label 'P.O. BOX - ';
        Customer: Record Members;
        PostCode: Record "Post Code";
        CountryRegion: Record "Country/Region";
        ProductFactory: Record "Product Factory";
        ImageData: Record "Image Data";
        ParentEdit: Boolean;
        TypeHide: Boolean;
        FXDDetailsVisible: Boolean;
        JuniourAccVisible: Boolean;
        FixedDepositType: Record "Fixed Deposit Type";
        SavingsAccounts: Record "Savings Accounts";
        Erro0001: Label 'You can not close an account that has balance';
        AmoutTotal: Decimal;
        EntryNo: Integer;
        NextOfKinApp: Record "Next of KIN Application";
        NextOfKin: Record "Next of KIN";
        AccountSignApp: Record "Signatory Application";
        AccountSign: Record "Account Signatories";

        MyComment: Text;
        NewMob: Code[13];
        MFact: Record "Member Factory Application";
        NewMFact: Record "Member Factory";
        MClass: Record "Member Class Application";
        NewMClass: Record "Member Class";
        //MReg: Codeunit "Registration Process";
        //SMTPMail: Codeunit "SMTP Mail";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Members: Record Members;
        HREmployees: Record "HR Employees";
        JointApp: Record "Joint Member Application";
        JointMembers: Record "Joint Members";
        BeneficiaryApp: Record "Beneficiary Application";
        Beneficiary: Record Beneficiaries;

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
    /// ClearFields.
    /// </summary>
    procedure ClearFields()
    begin
        "Member No." := '';
        Clear("Single Party/Multiple/Business");
        ;
        Clear("First Name");
        Clear("Second Name");
        ;
        Clear("Last Name");
        ;
        Clear(Name);
        ;
        "P.I.N Number" := '';
        Clear("Member Status");

        //VALIDATE(Blocked, CustMembr.Blocked);
        Clear(Blocked);
        ;
        Clear("Politically Exposed");
        Clear("Political Position");
        Clear("Member Segment");
        Clear("Account Category");
        Clear("Member Category");
        Clear("Relationship Manager");
        ;
        Clear("Mobile Phone No");
        Clear("Member Station");
        ;
        Clear("E-Mail");
        Clear("Personal E-mail");
        Clear("Payroll/Staff No.");
        Clear("ID No.");
        Clear("Passport No.");
        //VALIDATE("Date of Birth", CustMembr."Date of Birth");
        Clear("Date of Birth");
        Clear("Registration Date");
        Clear("Marital Status");
        Clear(Gender);
        Clear("Tax Exempted");
        Clear("Tax Waiver End Date");
        //VALIDATE("Sacco CID",CustMembr."Sacco CID");

        Clear("Group Account");
        Clear("Group Account No.");
        Clear("Group Type");
        Clear("Nature of Business");
        Clear("Company Registration No.");
        Clear("Date of Business Reg.");
        Clear("Business/Group Location");
        Clear("Plot/Bldg/Street/Road");
        Clear("Type of Business");
        Clear("Ownership Type");
        Clear("Other Business Type");


        Clear("Post Code");
        Clear(City);
        Clear(Nationality);
        //County := CustMembr.County;
        Clear(County);
        Clear("Phone No.");
        Clear("Mobile Phone No");
        Clear("Current Address");
        Clear("Home Address");
        Clear("Sub Location");
        Clear(Location);
        Clear(Division);
        Clear(District);

        Clear("Employer Code");
        Clear("Global Dimension 1 Code");
        Clear("Global Dimension 2 Code");
        Clear("Recruited by Type");
        Clear("Recruited By");
        Clear("Recruited By Name");
        Clear("Recruited By Staff No");
        Clear("Electrol Zone");
        Clear("Area Service Center");

        Clear("Bank Code");
        Clear("Branch Code");
        Clear("Bank Account No.");
        Clear("Terms of Employment");
        Clear(Factory);
        Clear("Factory Name");

        Clear("Vote Code");
        Clear("Nearest Land Mark");
        Clear("Buying Centre");
        Clear("Buying Centre Name");
        Clear("Read/Write");
        Clear("Appointment Date");
        Clear("Administrative Location");
        Clear("Administrative Sub-Location");
        Clear("Administrative Village");
        Clear("Customer CID");
        Clear("Old Member No.");
        Clear(Acreage);
        Clear("Society Code");
        Clear("Mobile Centre");
        Clear("Customer Type");
        Clear("Contract End Date");
        Clear(Diocese);
        Clear("Catholic Faithful Refferee");
        Clear(Parish);
        Clear(Jumuiya);
        Clear("Old E-Mail");
        Clear("Old Member Name");
        Clear("Old Phone No.");
        Clear("Group Type");
        Clear(Signature);
        Clear(Picture);
        "Member No." := '';
        "First Name" := '';
        "Second Name" := '';
        "Last Name" := '';
        Name := '';
        "Member Station" := '';
        "P.I.N Number" := '';
        "Account Status" := "Account Status"::" ";
        "Member Status" := "Member Status"::" ";

        Blocked := Blocked::" ";
        "Member Segment" := '';
        "Member Category" := '';
        "Relationship Manager" := '';
        "Mobile Phone No" := '';
        "Alternative Phone No. 1" := '';
        "Alternative Phone No. 2" := '';

        "Dividend Account" := '';

        //"Sacco CID":='';
        "E-Mail" := '';
        "Personal E-mail" := '';
        "Payroll/Staff No." := '';
        "ID No." := '';
        "Passport No." := '';
        "Date of Birth" := 0D;
        "Marital Status" := "Marital Status"::" ";
        "Needs Authorization" := false;


        "Signing Instructions" := "Signing Instructions"::"Any Two";
        Evaluate("FD Duration", '0D');
        "FD Maturity Date" := 0D;
        "Fixed Deposit Amount" := 0;
        "Fixed Deposit cert. no" := '';
        "FD Start Date" := 0D;
        "Fixed Deposit Status" := "Fixed Deposit Status"::" ";
        "FD Maturity Instructions" := "FD Maturity Instructions"::" ";
        "Fixed Deposit Type" := '';
        "Neg. Interest Rate" := 0;
        "Savings Account No." := '';

        "Birth Certificate No." := '';
        "Parent Account No." := '';
        "Tax Exempted" := false;
        "Tax Waiver End Date" := 0D;
        "Contract End Date" := 0D;


        "Product Type" := '';
        "Product Name" := '';
        "Product Category" := "Product Category"::" ";

        "Group Account No." := '';
        "Company Registration No." := '';


        "Group Account No." := '';
        "Group Type" := "Group Type"::" ";
        "Nature of Business" := '';
        "Company Registration No." := '';
        "Date of Business Reg." := 0D;
        "Business/Group Location" := '';
        "Plot/Bldg/Street/Road" := '';
        "Type of Business" := "Type of Business"::" ";
        "Ownership Type" := "Ownership Type"::" ";
        "Other Business Type" := '';
        ;
        "Meeting Days" := '';
        "Meeting Time" := '';
        "Meeting Venue" := '';


        "Post Code" := '';
        City := '';
        Nationality := '';
        County := '';
        "Phone No." := '';
        "Mobile Phone No" := '';
        "E-Mail" := '';
        "Current Address" := '';
        "Home Address" := '';
        "Sub Location" := '';
        Location := '';
        Division := '';
        District := '';

        "Employer Code" := '';
        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        "Recruited By" := '';
        "Electrol Zone" := '';
        "Area Service Center" := '';

        "Bank Code" := '';
        "Branch Code" := '';
        "Bank Account No." := '';
        ///Clear(Rec);
        //Init();
        //"Account Type" := xrec."Account Type";
    end;

    /// <summary>
    /// Tracker.
    /// </summary>
    /// <param name="CustMembr">Record Members.</param>
    procedure Tracker(CustMembr: Record Members)
    var
        ReactivateDeactivateHeader: Record "Reactivate/Deactivate Header";
        InfoBase: Record "Information Base";
    begin
        ReactivateDeactivateHeader.Reset;
        ReactivateDeactivateHeader.SetRange(ReactivateDeactivateHeader."No.", "No.");
        if ReactivateDeactivateHeader.Find('-') then begin
            if CustMembr.Get("Account No.") then begin

                if xRec."First Name" <> "First Name" then
                    CustMembr.Validate(CustMembr."First Name", "First Name");
                if xRec."Second Name" <> "Second Name" then
                    CustMembr.Validate(CustMembr."Second Name", "Second Name");
                if xRec."Last Name" <> "Last Name" then
                    CustMembr.Validate(CustMembr."Last Name", "Last Name");
                if xRec.Name <> Name then
                    CustMembr.Validate(CustMembr.Name, Name);
                if xRec."P.I.N Number" <> "P.I.N Number" then
                    CustMembr.Validate(CustMembr."P.I.N Number", "P.I.N Number");
                if xRec."Member Station" <> "Member Station" then
                    CustMembr.Validate(CustMembr."Member Station", "Member Station");
                if xRec."Member Status" <> "Member Status" then
                    CustMembr.Validate(CustMembr.Status, "Member Status");
                if CustMembr."Account Category" <> "Account Category" then
                    CustMembr.Validate("Account Category", "Account Category");
                if xRec.Blocked <> Blocked then
                    CustMembr.Validate(CustMembr.Blocked, Blocked);
                if xRec."Customer Type" <> "Customer Type" then
                    CustMembr.Validate(CustMembr."Customer Type", "Customer Type");
                if xRec."Meeting Days" <> "Meeting Days" then
                    CustMembr.Validate(CustMembr."Meeting Days", "Meeting Days");
                if xRec."Meeting Time" <> "Meeting Time" then
                    CustMembr.Validate(CustMembr."Meeting Time", "Meeting Time");
                if xRec."Meeting Venue" <> "Meeting Venue" then
                    CustMembr.Validate(CustMembr."Meeting Venue", "Meeting Venue");




                if xRec."Dividend Account" <> "Dividend Account" then
                    CustMembr.Validate(CustMembr."Dividend Account", "Dividend Account");
                if xRec."Politically Exposed" <> "Politically Exposed" then
                    CustMembr.Validate(CustMembr."Politically Exposed", "Politically Exposed");
                if xRec."Political Position" <> "Political Position" then
                    CustMembr.Validate(CustMembr."Political Position", "Political Position");
                if xRec."Member Segment" <> "Member Segment" then
                    CustMembr.Validate(CustMembr."Member Station", "Member Segment");
                if xRec."Member Category" <> "Member Category" then
                    CustMembr.Validate(CustMembr."Member Category", "Member Category");
                if xRec."Relationship Manager" <> "Relationship Manager" then
                    CustMembr.Validate(CustMembr."Relationship Manager", "Relationship Manager");
                if xRec."Mobile Phone No" <> "Mobile Phone No" then
                    CustMembr.Validate(CustMembr."Mobile Phone No", "Mobile Phone No");
                if xRec."Alternative Phone No. 1" <> "Alternative Phone No. 1" then
                    CustMembr.Validate(CustMembr."Alternative Phone No. 1", "Alternative Phone No. 1");
                if xRec."Alternative Phone No. 2" <> "Alternative Phone No. 2" then
                    CustMembr.Validate(CustMembr."Alternative Phone No. 2", "Alternative Phone No. 2");
                if xRec."Payroll/Staff No." <> "Payroll/Staff No." then
                    CustMembr.Validate(CustMembr."Payroll/Staff No.", "Payroll/Staff No.");
                if xRec."ID No." <> "ID No." then
                    CustMembr.Validate(CustMembr."ID No.", "ID No.");
                //CustMembr."ID No.":="ID No.";
                if xRec."Passport No." <> "Passport No." then
                    CustMembr.Validate(CustMembr."Passport No.", "Passport No.");
                if xRec."Date of Birth" <> "Date of Birth" then
                    CustMembr.Validate(CustMembr."Date of Birth", "Date of Birth");
                if xRec."Registration Date" <> "Registration Date" then
                    CustMembr.Validate(CustMembr."Registration Date", "Registration Date");
                if xRec."Marital Status" <> "Marital Status" then
                    CustMembr.Validate(CustMembr."Marital Status", "Marital Status");
                if xRec."Group Account No." <> "Group Account No." then
                    CustMembr.Validate(CustMembr."Group Code", "Group Account No.");

                if xRec."Contract End Date" <> "Contract End Date" then
                    CustMembr.Validate(CustMembr."Contract End Date", "Contract End Date");


                if xRec."Needs Authorization" <> "Needs Authorization" then begin
                    CustMembr.Validate(CustMembr."Needs Authorization", "Needs Authorization");
                    Sav.Reset;
                    Sav.SetRange("Member No.", CustMembr."No.");
                    if Sav.FindFirst then begin
                        Sav.ModifyAll("Needs Authorization", "Needs Authorization");
                    end;
                end;

                if xRec."Group Type" <> "Group Type" then
                    CustMembr.Validate(CustMembr."Group Type", "Group Type");
                if xRec."Nature of Business" <> "Nature of Business" then
                    CustMembr.Validate(CustMembr."Nature of Business", "Nature of Business");
                if xRec."Company Registration No." <> "Company Registration No." then
                    CustMembr.Validate(CustMembr."Company Registration No.", "Company Registration No.");
                if xRec."Date of Business Reg." <> "Date of Business Reg." then
                    CustMembr.Validate(CustMembr."Date of Business Reg.", "Date of Business Reg.");
                if xRec."Business/Group Location" <> "Business/Group Location" then
                    CustMembr.Validate(CustMembr."Business/Group Location", "Business/Group Location");
                if xRec."Plot/Bldg/Street/Road" <> "Plot/Bldg/Street/Road" then
                    CustMembr.Validate(CustMembr."Plot/Bldg/Street/Road", "Plot/Bldg/Street/Road");
                if xRec."Type of Business" <> "Type of Business" then
                    CustMembr.Validate(CustMembr."Type of Business", "Type of Business");
                if xRec."Ownership Type" <> "Ownership Type" then
                    CustMembr.Validate(CustMembr."Ownership Type", "Ownership Type");
                if xRec."Other Business Type" <> "Other Business Type" then
                    CustMembr.Validate(CustMembr."Other Business Type", "Other Business Type");

                if xRec."Post Code" <> "Post Code" then
                    CustMembr.Validate(CustMembr."Post Code", "Post Code");
                if xRec.City <> City then
                    CustMembr.Validate(CustMembr.City, City);
                if xRec.Nationality <> Nationality then
                    CustMembr.Validate(CustMembr.Nationality, Nationality);
                if xRec.County <> County then
                    CustMembr.Validate(CustMembr.County, County);
                if xRec."Phone No." <> "Phone No." then
                    CustMembr.Validate(CustMembr."Alternative Phone No. 1", "Phone No.");
                if xRec."E-Mail" <> "E-Mail" then
                    CustMembr.Validate(CustMembr."E-Mail", "E-Mail");
                //IF xRec."Sacco CID" <> "Sacco CID" THEN
                // CustMembr.VALIDATE(CustMembr."Sacco CID", "Sacco CID");
                if xRec."Current Address" <> "Current Address" then
                    CustMembr.Validate(CustMembr."Current Address", "Current Address");
                if xRec."Home Address" <> "Home Address" then
                    CustMembr.Validate(CustMembr."Home Address", "Home Address");
                if xRec."Sub Location" <> "Sub Location" then
                    CustMembr.Validate(CustMembr."Sub Location", "Sub Location");
                if xRec.Location <> Location then
                    CustMembr.Validate(CustMembr.Location, Location);
                if xRec.Division <> Division then
                    CustMembr.Validate(CustMembr.Division, Division);
                if xRec.District <> District then
                    CustMembr.Validate(CustMembr.District, District);
                if xRec."Administrative Location" <> "Administrative Location" then
                    CustMembr.Validate(CustMembr."Administrative Location", "Administrative Location");
                if xRec."Administrative Sub-Location" <> "Administrative Sub-Location" then
                    CustMembr.Validate(CustMembr."Administrative Sub-Location", "Administrative Sub-Location");
                if xRec."Administrative Village" <> "Administrative Village" then
                    CustMembr.Validate(CustMembr."Administrative Village", "Administrative Village");

                if xRec.Gender <> Gender then
                    CustMembr.Validate(CustMembr.Gender, Gender);
                if xRec."Employer Code" <> "Employer Code" then
                    CustMembr.Validate(CustMembr."Employer Code", "Employer Code");
                if xRec."Global Dimension 1 Code" <> "Global Dimension 1 Code" then
                    CustMembr.Validate(CustMembr."Global Dimension 1 Code", "Global Dimension 1 Code");
                if xRec."Global Dimension 2 Code" <> "Global Dimension 2 Code" then
                    CustMembr.Validate(CustMembr."Global Dimension 2 Code", "Global Dimension 2 Code");
                if xRec.County <> County then
                    CustMembr.Validate(CustMembr.County, County);
                if xRec."Recruited by Type" <> "Recruited by Type" then
                    CustMembr.Validate(CustMembr."Recruited by Type", "Recruited by Type");
                if xRec."Recruited By" <> "Recruited By" then
                    CustMembr.Validate(CustMembr."Recruited By", "Recruited By");
                if xRec."Recruited By Name" <> "Recruited By Name" then
                    CustMembr.Validate(CustMembr."Recruited By Name", "Recruited By Name");
                if xRec."Recruited By Staff No" <> "Recruited By Staff No" then
                    CustMembr.Validate(CustMembr."Recruited By Staff No", "Recruited By Staff No");
                if xRec."Electrol Zone" <> "Electrol Zone" then
                    CustMembr.Validate(CustMembr."Electrol Zone", "Electrol Zone");
                if xRec."Area Service Center" <> "Area Service Center" then
                    CustMembr.Validate(CustMembr."Area Service Center", "Area Service Center");
                if xRec."Dividend Payment Method" <> "Dividend Payment Method" then
                    CustMembr."Dividend Payment Method" := "Dividend Payment Method";
                if xRec."Terms of Employment" <> "Terms of Employment" then
                    CustMembr."Terms of Employment" := "Terms of Employment";
                //hide
                if xRec.Hide <> Hide then
                    CustMembr."Special Member" := Hide;
                if xRec."Old Member No." <> "Old Member No." then
                    CustMembr."Old Member No." := "Old Member No.";
                if xRec."Customer CID" <> "Customer CID" then
                    CustMembr."Form No." := "Customer CID";
                if xRec."Mobile Centre" <> "Mobile Centre" then
                    CustMembr."Mobile Centre" := "Mobile Centre";
                if xRec."Old Member No." <> "Old Member No." then
                    CustMembr."Old Member No." := "Old Member No.";

                if xRec."Bank Code" <> "Bank Code" then
                    CustMembr.Validate(CustMembr."Bank Code", "Bank Code");
                if xRec."Branch Code" <> "Branch Code" then
                    CustMembr.Validate(CustMembr."Branch Code", "Branch Code");
                if xRec."Tax Exempted" <> "Tax Exempted" then
                    CustMembr.Validate("Tax Exempted", "Tax Exempted");
                if xRec."Tax Waiver End Date" <> "Tax Waiver End Date" then
                    CustMembr.Validate("Tax Waiver End Date", "Tax Waiver End Date");
                if xRec."Bank Account No." <> "Bank Account No." then
                    CustMembr.Validate(CustMembr."Bank Account No.", "Bank Account No.");
                if xRec.Diocese <> Diocese then
                    CustMembr.Validate(CustMembr.Diocese, Diocese);
                if xRec.Parish <> Parish then
                    CustMembr.Validate(CustMembr.Parish, Parish);
                if xRec.Jumuiya <> Jumuiya then
                    CustMembr.Validate(CustMembr.Jumuiya, Jumuiya);
                if xRec."External Employer Name" <> "External Employer Name" then
                    CustMembr.Validate(CustMembr."External Employer Name", "External Employer Name");
                if xRec."Catholic Faithful Refferee" <> "Catholic Faithful Refferee" then
                    CustMembr.Validate(CustMembr."Catholic Faithful Refferee", "Catholic Faithful Refferee");

                if xRec."Employer Type" <> "Employer Type" then
                    CustMembr.Validate(CustMembr."Employer Type", "Employer Type");

                CustMembr.Modify;



                //NOK

                NextOfKinApp.Reset;
                NextOfKinApp.SetRange(NextOfKinApp."Account No", "No.");
                if NextOfKinApp.Find('-') then begin

                    NextOfKin.Reset;
                    NextOfKin.SetRange("Account No", CustMembr."No.");
                    if NextOfKin.Find('-') then
                        NextOfKin.DeleteAll;
                    repeat

                        NextOfKin.Init;
                        NextOfKin."Entry No." := NextOfKinApp."Entry No.";
                        NextOfKin."Account No" := CustMembr."No.";
                        NextOfKin.Name := NextOfKinApp.Name;
                        NextOfKin.Relationship := NextOfKinApp.Relationship;
                        NextOfKin.Beneficiary := NextOfKinApp.Beneficiary;
                        NextOfKin."Date of Birth" := NextOfKinApp."Date of Birth";
                        NextOfKin.Address := NextOfKinApp.Address;
                        NextOfKin.Telephone := NextOfKinApp.Telephone;
                        NextOfKin.Fax := NextOfKinApp.Fax;
                        NextOfKin."Post Code" := NextOfKinApp."Post Code";
                        NextOfKin.City := NextOfKinApp.City;
                        NextOfKin.Email := NextOfKinApp.Email;
                        NextOfKin."ID No." := NextOfKinApp."ID No./Birth Cert. No.";
                        NextOfKin."%Allocation" := NextOfKinApp."%Allocation";
                        NextOfKin.Type := NextOfKinApp.Type;
                        NextOfKin."Cheque Collector" := NextOfKinApp."Cheque Collector";
                        NextOfKin."BBF Entitlement" := NextOfKinApp."BBF Entitlement";
                        NextOfKin."BBF Entitlement Code" := NextOfKinApp."BBF Entitlement Code";
                        NextOfKin.Spouse := NextOfKinApp.Spouse;
                        NextOfKin.Insert;
                    until NextOfKinApp.Next = 0;
                end;
                //End NOK

                //Beneficiary
                BeneficiaryApp.Reset;
                BeneficiaryApp.SetRange(BeneficiaryApp."Account No", "No.");
                if BeneficiaryApp.Find('-') then begin

                    Beneficiary.Reset;
                    Beneficiary.SetRange("Account No", CustMembr."No.");
                    if Beneficiary.Find('-') then
                        Beneficiary.DeleteAll;
                    repeat

                        Beneficiary.Init;
                        Beneficiary."Entry No." := BeneficiaryApp."Entry No.";
                        Beneficiary."Account No" := CustMembr."No.";
                        Beneficiary.Name := BeneficiaryApp.Name;
                        Beneficiary.Relationship := BeneficiaryApp.Relationship;
                        Beneficiary.Beneficiary := BeneficiaryApp.Beneficiary;
                        Beneficiary."Date of Birth" := BeneficiaryApp."Date of Birth";
                        Beneficiary.Address := BeneficiaryApp.Address;
                        Beneficiary.Telephone := BeneficiaryApp.Telephone;
                        Beneficiary.Fax := BeneficiaryApp.Fax;
                        Beneficiary."Post Code" := BeneficiaryApp."Post Code";
                        Beneficiary.City := BeneficiaryApp.City;
                        Beneficiary.Email := BeneficiaryApp.Email;
                        Beneficiary."ID No." := BeneficiaryApp."ID No./Birth Cert. No.";
                        Beneficiary."%Allocation" := BeneficiaryApp."%Allocation";
                        Beneficiary.Type := BeneficiaryApp.Type;
                        Beneficiary."Cheque Collector" := BeneficiaryApp."Cheque Collector";
                        Beneficiary."BBF Entitlement" := BeneficiaryApp."BBF Entitlement";
                        Beneficiary."BBF Entitlement Code" := BeneficiaryApp."BBF Entitlement Code";
                        Beneficiary.Spouse := BeneficiaryApp.Spouse;
                        Beneficiary.Insert;
                    until BeneficiaryApp.Next = 0;
                end;
                //End beneficiary

                if "Account Type" = "Account Type"::Member then begin
                    MFact.Reset;
                    MFact.SetRange("Application No", "No.");
                    if MFact.Find('-') then begin

                        NewMFact.Reset;
                        NewMFact.SetRange("Member No", CustMembr."No.");
                        if NewMFact.FindFirst then
                            NewMFact.DeleteAll;

                        repeat
                            NewMFact.Init;
                            NewMFact."Member No" := CustMembr."No.";
                            NewMFact."Factory Code" := MFact."Factory Code";
                            NewMFact."Factory Name" := MFact."Factory Name";
                            NewMFact."Factory/Society No." := MFact."Factory/Society No.";
                            NewMFact."Buying Center Code" := MFact."Buying Center Code";
                            NewMFact."Buying Center Name" := MFact."Buying Center Name";
                            NewMFact."Exempt Deposit" := MFact."Exempt Deposit";
                            NewMFact.Insert;
                        until MFact.Next = 0;

                    end;
                end;

                MClass.Reset;
                MClass.SetRange("Application No", "No.");
                if MClass.Find('-') then begin

                    NewMClass.Reset;
                    NewMClass.SetRange("Application No", CustMembr."No.");
                    if NewMClass.Find('-') then
                        NewMClass.DeleteAll;

                    repeat
                        if MClass."Member Class" = 'CLASS C' then
                            TestField("Group Account No.");

                        NewMClass.Init;
                        NewMClass."Application No" := CustMembr."No.";
                        NewMClass."Member Class" := MClass."Member Class";
                        NewMClass."Product ID" := MClass."Product ID";
                        NewMClass.Insert;

                        ProductFactory.Get(MClass."Product ID");

                        Sav.Reset;
                        Sav.SetRange("Member No.", CustMembr."No.");
                        Sav.SetRange("Product Type", ProductFactory."Product ID");
                    /*if not Sav.FindFirst then
                        MReg.CreateSavingsAccount(ProductFactory, CustMembr."No.", 0)*/

                    until MClass.Next = 0;
                end;








                ImageData.Reset;
                ImageData.SetRange(ImageData."Member No", CustMembr."No.");
                if ImageData.Find('-') then
                    ImageData.DeleteAll;

                ImageData.Init;
                CalcFields(Picture, Signature, "ID Back Page", "ID Front Page");
                ImageData."ID Number" := CustMembr."ID No.";
                ImageData.Picture := Picture;
                ImageData.Signature := Signature;
                ImageData."ID - Front Page" := "ID Front Page";
                ImageData."ID - Back Page" := "ID Back Page";
                // ImageData."Sketch Map":="Sketch Map";
                ImageData."Member No" := CustMembr."No.";
                ImageData.Insert(true);

                //Group Accounts
                AccountSignApp.Reset;
                AccountSignApp.SetRange(AccountSignApp."Account No", "No.");
                if AccountSignApp.Find('-') then begin
                    AccountSign.Reset;
                    AccountSign.SetRange("Account No", CustMembr."No.");
                    if AccountSign.Find('-') then
                        AccountSign.DeleteAll;
                    repeat

                        AccountSign.Init;
                        AccountSign."Entry No" := AccountSignApp."Entry No";
                        AccountSign."Account No" := CustMembr."No.";
                        AccountSign."Account Type" := AccountSignApp."Account Type";
                        AccountSign."Member No." := AccountSignApp."Member No.";
                        AccountSign.Names := AccountSignApp.Names;
                        AccountSign."Date Of Birth" := AccountSignApp."Date Of Birth";
                        AccountSign."Staff/Payroll" := AccountSignApp."Staff/Payroll";
                        AccountSign."ID Number" := AccountSignApp."ID Number";
                        AccountSign."Phone No." := AccountSignApp."Phone No.";
                        AccountSign.Signatory := AccountSignApp.Signatory;
                        AccountSign."Must Sign" := AccountSignApp."Must Sign";
                        AccountSign."Must be Present" := AccountSignApp."Must be Present";
                        AccountSignApp.CalcFields(AccountSignApp.Signature, AccountSignApp.Picture);
                        AccountSign.Picture := AccountSignApp.Picture;
                        AccountSign.Signature := AccountSignApp.Signature;
                        AccountSign.Expired := AccountSignApp.Expired;
                        AccountSign."Expired By" := AccountSignApp."Expired By";
                        AccountSign."Expiry Date" := AccountSignApp."Expiry Date";
                        AccountSign."PIN Number" := AccountSignApp."PIN Number";
                        //AccountSign."Mobile No.":=AccountSignApp."Mobile No.";
                        AccountSign.Insert;

                        if AccountSignApp.Picture.HasValue then begin
                            Clear(AccountSignApp.Signature);
                            AccountSignApp.Modify;
                        end;

                        if AccountSignApp.Signature.HasValue then begin
                            Clear(AccountSignApp.Signature);
                            AccountSignApp.Modify;
                        end;
                    until AccountSignApp.Next = 0;
                end;
                //End Group Accounts

                //Joint Accounts
                JointApp.Reset;
                JointApp.SetRange(JointApp."Account No", "No.");
                if JointApp.Find('-') then begin
                    JointMembers.Reset;
                    JointMembers.SetRange("Account No", CustMembr."No.");
                    if JointMembers.Find('-') then
                        JointMembers.DeleteAll;
                    repeat

                        JointMembers.Init;
                        JointMembers."Entry No" := JointApp."Entry No";
                        JointMembers."Account No" := CustMembr."No.";
                        JointMembers."Account Type" := JointApp."Account Type";
                        JointMembers."Member No." := JointApp."Member No.";
                        JointMembers.Names := JointApp.Names;
                        JointMembers."Date Of Birth" := JointApp."Date Of Birth";
                        JointMembers."Staff/Payroll" := JointApp."Staff/Payroll";
                        JointMembers."ID Number" := JointApp."ID Number";
                        JointMembers."Phone No." := JointApp."Phone No.";
                        JointMembers.Signatory := JointApp.Signatory;
                        JointMembers."Must Sign" := JointApp."Must Sign";
                        JointMembers."Must be Present" := JointApp."Must be Present";
                        JointApp.CalcFields(JointApp.Signature, JointApp.Picture);
                        JointMembers.Picture := JointApp.Picture;
                        JointMembers.Signature := JointApp.Signature;
                        JointMembers."Expiry Date" := JointApp."Expiry Date";
                        JointMembers."PIN Number" := JointApp."PIN Number";
                        //AccountSign."Mobile No.":=JointApp."Mobile No.";
                        JointMembers.Insert;

                        if JointApp.Picture.HasValue then begin
                            Clear(JointApp.Signature);
                            JointApp.Modify;
                        end;

                        if JointApp.Signature.HasValue then begin
                            Clear(JointApp.Signature);
                            JointApp.Modify;
                        end;
                    until JointApp.Next = 0;
                end;
                //End Joint Accounts
                //info base
                InfoBase.Reset();
                InfoBase.SetRange("Member No.", CustMembr."No.");
                InfoBase.SetRange(Info, "Info Base Area");
                if InfoBase.Find('-') = false then begin
                    InfoBase.init;
                    InfoBase.Validate("Member No.", CustMembr."No.");
                    InfoBase.Validate("Account No.", CustMembr."No.");
                    InfoBase.Validate("Captured By", UserId);
                    InfoBase.Validate(Info, "Info Base Area");
                    InfoBase.Insert(true);
                end;



            end;
        end;
    end;

    /// <summary>
    /// TrackerII.
    /// </summary>
    /// <param name="SavingsAccounts">Record "Savings Accounts".</param>
    procedure TrackerII(SavingsAccounts: Record "Savings Accounts")
    begin
        ReactivateDeactivateHeader.Reset;
        ReactivateDeactivateHeader.SetRange(ReactivateDeactivateHeader."No.", "No.");
        if ReactivateDeactivateHeader.Find('-') then begin
            if SavingsAccounts.Get("Account No.") then begin

                if xRec.Name <> Name then
                    SavingsAccounts.Validate(SavingsAccounts.Name, Name);
                if xRec."Account Status" <> "Account Status" then
                    SavingsAccounts.Validate(SavingsAccounts.Status, "Account Status");
                //IF xRec.Blocked <> Blocked THEN
                SavingsAccounts.Validate(SavingsAccounts.Blocked, Blocked);
                if xRec."Relationship Manager" <> "Relationship Manager" then
                    SavingsAccounts.Validate(SavingsAccounts."Relationship Manager", "Relationship Manager");
                if xRec."Transactional Mobile No" <> "Transactional Mobile No" then
                    SavingsAccounts.Validate(SavingsAccounts."Transactional Mobile No", "Transactional Mobile No");
                if xRec."Mobile Phone No" <> "Mobile Phone No" then
                    SavingsAccounts.Validate(SavingsAccounts."Mobile Phone No", "Mobile Phone No");
                if xRec."Alternative Phone No. 1" <> "Alternative Phone No. 1" then
                    SavingsAccounts.Validate(SavingsAccounts."Alternative Phone No. 1", "Alternative Phone No. 1");
                if xRec."Alternative Phone No. 2" <> "Alternative Phone No. 2" then
                    SavingsAccounts.Validate(SavingsAccounts."Alternative Phone No. 2", "Alternative Phone No. 2");
                if xRec."Politically Exposed" <> "Politically Exposed" then
                    SavingsAccounts.Validate(SavingsAccounts."Politically Exposed", "Politically Exposed");
                if xRec."Political Position" <> "Political Position" then
                    SavingsAccounts.Validate(SavingsAccounts."Political Position", "Political Position");
                if xRec."Payroll/Staff No." <> "Payroll/Staff No." then
                    SavingsAccounts.Validate(SavingsAccounts."Payroll/Staff No.", "Payroll/Staff No.");
                if xRec."ID No." <> "ID No." then
                    SavingsAccounts.Validate(SavingsAccounts."ID No.", "ID No.");
                if xRec."Passport No." <> "Passport No." then
                    SavingsAccounts.Validate(SavingsAccounts."Passport No.", "Passport No.");
                if xRec."Date of Birth" <> "Date of Birth" then
                    SavingsAccounts.Validate(SavingsAccounts."Date of Birth", "Date of Birth");
                if xRec."Marital Status" <> "Marital Status" then
                    SavingsAccounts.Validate(SavingsAccounts."Marital Status", "Marital Status");
                if xRec."Group Account No." <> "Group Account No." then
                    SavingsAccounts.Validate(SavingsAccounts."Group Account No", "Group Account No.");
                if xRec."Monthly Contribution" <> "Monthly Contribution" then
                    SavingsAccounts.Validate(SavingsAccounts."Monthly Contribution", "Monthly Contribution");

                if xRec."Needs Authorization" <> "Needs Authorization" then
                    SavingsAccounts.Validate(SavingsAccounts."Needs Authorization", "Needs Authorization");


                if xRec."Company Registration No." <> "Company Registration No." then
                    SavingsAccounts.Validate(SavingsAccounts."Company Registration No.", "Company Registration No.");
                if xRec."Signing Instructions" <> "Signing Instructions" then
                    SavingsAccounts."Signing Instructions" := "Signing Instructions";
                if xRec."FD Duration" <> "FD Duration" then
                    SavingsAccounts."FD Duration" := "FD Duration";
                if xRec."FD Maturity Date" <> "FD Maturity Date" then
                    SavingsAccounts."FD Maturity Date" := "FD Maturity Date";
                if xRec."Fixed Deposit Amount" <> "Fixed Deposit Amount" then
                    SavingsAccounts."Fixed Deposit Amount" := "Fixed Deposit Amount";
                if xRec."Fixed Deposit cert. no" <> "Fixed Deposit cert. no" then
                    SavingsAccounts."Fixed Deposit cert. no" := "Fixed Deposit cert. no";
                if xRec."Fixed Deposit Status" <> "Fixed Deposit Status" then
                    SavingsAccounts."Fixed Deposit Status" := "Fixed Deposit Status";
                if xRec."FD Maturity Instructions" <> "FD Maturity Instructions" then
                    SavingsAccounts."FD Maturity Instructions" := "FD Maturity Instructions";
                if xRec."Fixed Deposit Type" <> "Fixed Deposit Type" then
                    SavingsAccounts."Fixed Deposit Type" := "Fixed Deposit Type";
                if xRec."Neg. Interest Rate" <> "Neg. Interest Rate" then
                    SavingsAccounts."Neg. Interest Rate" := "Neg. Interest Rate";
                if xRec."Savings Account No." <> "Savings Account No." then
                    SavingsAccounts."Savings Account No." := "Savings Account No.";

                if xRec."Birth Certificate No." <> "Birth Certificate No." then
                    SavingsAccounts."Birth Certificate No." := "Birth Certificate No.";
                if xRec."Parent Account No." <> "Parent Account No." then
                    SavingsAccounts."Parent Account No." := "Parent Account No.";

                if xRec."Product Type" <> "Product Type" then
                    SavingsAccounts."Product Type" := "Product Type";
                if xRec."Product Name" <> "Product Name" then
                    SavingsAccounts."Product Name" := "Product Name";
                if xRec."Product Category" <> "Product Category" then
                    SavingsAccounts."Product Category" := "Product Category";

                if xRec."Child Name" <> "Child Name" then
                    SavingsAccounts."Child Name" := "Child Name";

                if xRec."Group Account No." <> "Group Account No." then
                    SavingsAccounts."Group Account No" := "Group Account No.";
                if xRec."Company Registration No." <> "Company Registration No." then
                    SavingsAccounts."Company Registration No." := "Company Registration No.";
                SavingsAccounts."Info Base Area" := "Info Base Area";
                if xRec.Hide <> Hide then
                    SavingsAccounts."Special Account" := Hide;
                if xRec."Enable Sweeping" <> "Enable Sweeping" then
                    SavingsAccounts."Enable Sweeping" := "Enable Sweeping";
                //    IF xRec."Bank Account No."<>"Bank Account No." THEN
                //      SavingsAccounts."External Account No":="Bank Account No.";
                //    IF xRec."Branch Code"<>"Branch Code" THEN
                //      SavingsAccounts."Bank Code":="Branch Code";
                if xRec."Old Member No." <> "Old Member No." then
                    SavingsAccounts."Old Account No" := "Old Member No.";
                if xRec."Customer CID" <> "Customer CID" then
                    SavingsAccounts."Form No." := "Customer CID";
                if xRec."Mobile Centre" <> "Mobile Centre" then
                    SavingsAccounts."Mobile Centre" := "Mobile Centre";

                if xRec."Post Code" <> "Post Code" then
                    SavingsAccounts.Validate(SavingsAccounts."Post Code", "Post Code");
                if xRec.City <> City then
                    SavingsAccounts.Validate(SavingsAccounts.City, City);
                if xRec.County <> County then
                    SavingsAccounts.Validate(SavingsAccounts.County, County);
                if xRec."Phone No." <> "Phone No." then
                    SavingsAccounts.Validate(SavingsAccounts."Alternative Phone No. 1", "Phone No.");
                if xRec."E-Mail" <> "E-Mail" then
                    SavingsAccounts.Validate(SavingsAccounts."E-Mail", "E-Mail");
                if xRec."Current Address" <> "Current Address" then
                    SavingsAccounts.Validate(SavingsAccounts."Current Address", "Current Address");
                if xRec."Home Address" <> "Home Address" then
                    SavingsAccounts.Validate(SavingsAccounts."Home Address", "Home Address");

                if xRec."Employer Code" <> "Employer Code" then
                    SavingsAccounts.Validate(SavingsAccounts."Employer Code", "Employer Code");
                if xRec."Global Dimension 1 Code" <> "Global Dimension 1 Code" then
                    SavingsAccounts.Validate(SavingsAccounts."Global Dimension 1 Code", "Global Dimension 1 Code");
                if xRec."Global Dimension 2 Code" <> "Global Dimension 2 Code" then
                    SavingsAccounts.Validate(SavingsAccounts."Global Dimension 2 Code", "Global Dimension 2 Code");
                if xRec.County <> County then
                    SavingsAccounts.Validate(SavingsAccounts.County, County);
                if xRec."Recruited by Type" <> "Recruited by Type" then
                    SavingsAccounts.Validate(SavingsAccounts."Recruited by Type", "Recruited by Type");
                if xRec."Recruited By" <> "Recruited By" then
                    SavingsAccounts.Validate(SavingsAccounts."Recruited By", "Recruited By");
                if xRec."FD Start Date" <> "FD Start Date" then
                    SavingsAccounts.Validate("FD Start Date", "FD Start Date");

                if xRec."Block Reason" <> "Block Reason" then
                    SavingsAccounts.Validate(SavingsAccounts."Block Reason", "Block Reason");
                SavingsAccounts.Modify;




                AccountSign.Reset;
                AccountSign.SetRange("Account No", SavingsAccounts."No.");
                if AccountSign.Find('-') then
                    AccountSign.DeleteAll;

                AccountSignApp.Reset;
                AccountSignApp.SetRange(AccountSignApp."Account No", "No.");
                if AccountSignApp.Find('-') then begin

                    repeat


                        AccountSign.Init;
                        AccountSign."Entry No" := AccountSignApp."Entry No";
                        AccountSign."Account No" := SavingsAccounts."No.";
                        AccountSign.Names := AccountSignApp.Names;
                        AccountSign."Date Of Birth" := AccountSignApp."Date Of Birth";
                        AccountSign."Staff/Payroll" := AccountSignApp."Staff/Payroll";
                        AccountSign."ID Number" := AccountSignApp."ID Number";
                        AccountSign."Phone No." := AccountSignApp."Phone No.";
                        AccountSign.Signatory := AccountSignApp.Signatory;
                        AccountSign."Must Sign" := AccountSignApp."Must Sign";
                        AccountSign."Must be Present" := AccountSignApp."Must be Present";
                        AccountSignApp.CalcFields(AccountSignApp.Signature, AccountSignApp.Picture);
                        AccountSign.Picture := AccountSignApp.Picture;
                        AccountSign.Signature := AccountSignApp.Signature;
                        AccountSign."Expiry Date" := AccountSignApp."Expiry Date";
                        AccountSign."Member No." := SavingsAccounts."Member No.";
                        //AccountSign."Mobile No.":=AccountSignApp."Mobile No.";
                        AccountSign.Insert;

                        if AccountSignApp.Picture.HasValue then begin
                            Clear(AccountSignApp.Signature);
                            AccountSignApp.Modify;
                        end;

                        if AccountSignApp.Signature.HasValue then begin
                            Clear(AccountSignApp.Signature);
                            AccountSignApp.Modify;
                        end;
                    until AccountSignApp.Next = 0;
                end;




            end;
        end;
    end;

    local procedure GetSignatory()
    var
        SignatoryApplication: Record "Signatory Application";
        AccountSignatories: Record "Account Signatories";
    begin
        SignatoryApplication.Reset;
        SignatoryApplication.SetRange("Account No", "No.");
        if SignatoryApplication.Find('-') then
            SignatoryApplication.DeleteAll;


        AccountSignatories.Reset;
        AccountSignatories.SetRange(AccountSignatories."Account No", "Account No.");
        if AccountSignatories.Find('-') then begin
            repeat
                EntryNo += 1;
                SignatoryApplication.Init;
                SignatoryApplication."Account No" := "No.";
                SignatoryApplication."Entry No" := EntryNo;
                SignatoryApplication."Account Type" := AccountSignatories."Account Type";
                SignatoryApplication."Member No." := AccountSignatories."Member No.";
                ;
                SignatoryApplication."ID Number" := AccountSignatories."ID Number";
                SignatoryApplication."Phone No." := AccountSignatories."Phone No.";
                SignatoryApplication."Date Of Birth" := AccountSignatories."Date Of Birth";
                SignatoryApplication.Signatory := AccountSignatories.Signatory;
                SignatoryApplication.CalcFields(Signature, Picture);
                AccountSignatories.CalcFields(Signature, Picture);
                SignatoryApplication.Signature := AccountSignatories.Signature;
                SignatoryApplication.Picture := AccountSignatories.Picture;
                SignatoryApplication."Must be Present" := AccountSignatories."Must be Present";
                SignatoryApplication."Must Sign" := AccountSignatories."Must Sign";
                SignatoryApplication.Names := AccountSignatories.Names;
                SignatoryApplication."Staff/Payroll" := AccountSignatories."Staff/Payroll";
                SignatoryApplication.Type := AccountSignatories.Type;
                SignatoryApplication."Expiry Date" := AccountSignatories."Expiry Date";
                SignatoryApplication.Insert;

            until AccountSignatories.Next = 0;
        end;
    end;

    /// <summary>
    /// GetNextofkin.
    /// </summary>
    procedure GetNextofkin()
    begin
        NextOfKinApp.Reset;
        NextOfKinApp.SetRange("Account No", "No.");
        if NextOfKinApp.Find('-') then
            NextOfKinApp.DeleteAll;

        NextOfKin.Reset;
        NextOfKin.SetRange(NextOfKin."Account No", "Member No.");
        if NextOfKin.Find('-') then begin
            repeat

                NextOfKinApp.Init;
                NextOfKinApp."Entry No." := NextOfKin."Entry No.";
                NextOfKinApp."Account No" := "No.";
                NextOfKinApp.Name := NextOfKin.Name;
                NextOfKinApp.Relationship := NextOfKin.Relationship;
                NextOfKinApp.Beneficiary := NextOfKin.Beneficiary;
                NextOfKinApp."Date of Birth" := NextOfKin."Date of Birth";
                NextOfKinApp.Address := NextOfKin.Address;
                NextOfKinApp.Telephone := NextOfKin.Telephone;
                NextOfKinApp.Fax := NextOfKin.Fax;
                NextOfKinApp."Post Code" := NextOfKin."Post Code";
                NextOfKinApp.City := NextOfKin.City;
                NextOfKinApp.Email := NextOfKin.Email;
                NextOfKinApp."ID No./Birth Cert. No." := NextOfKin."ID No.";
                NextOfKinApp."%Allocation" := NextOfKin."%Allocation";
                NextOfKinApp.Type := NextOfKin.Type;
                NextOfKinApp."Cheque Collector" := NextOfKin."Cheque Collector";
                NextOfKinApp."BBF Entitlement" := NextOfKin."BBF Entitlement";
                NextOfKinApp."BBF Entitlement Code" := NextOfKin."BBF Entitlement Code";
                NextOfKinApp.Spouse := NextOfKin.Spouse;
                NextOfKinApp.Insert;
            until NextOfKin.Next = 0;
        end;
    end;

    /// <summary>
    /// GetClass_Factory.
    /// </summary>
    /// <summary>
    /// GetClass_Factory.
    /// </summary>
    procedure GetClass_Factory()
    begin

        if "Account Type" = "Account Type"::Member then begin
            MFact.Reset;
            MFact.SetRange("Application No", "No.");
            if MFact.Find('-') then
                MFact.DeleteAll;

            NewMFact.Reset;
            NewMFact.SetRange("Member No", "Member No.");
            if NewMFact.FindFirst then begin
                repeat

                    MFact.Init;
                    MFact."Application No" := "No.";
                    MFact."Factory Code" := NewMFact."Factory Code";
                    MFact."Factory Name" := NewMFact."Factory Name";
                    MFact."Factory/Society No." := NewMFact."Factory/Society No.";
                    MFact."Buying Center Code" := NewMFact."Buying Center Code";
                    MFact."Buying Center Name" := NewMFact."Buying Center Name";
                    MFact."Exempt Deposit" := NewMFact."Exempt Deposit";
                    MFact.Insert;

                until NewMFact.Next = 0;

            end;

        end;

        MClass.Reset;
        MClass.SetRange("Application No", "No.");
        if MClass.Find('-') then
            MClass.DeleteAll;

        NewMClass.Reset;
        NewMClass.SetRange("Application No", "Member No.");
        if NewMClass.Find('-') then begin

            repeat

                MClass.Init;
                MClass."Application No" := "No.";
                MClass."Member Class" := NewMClass."Member Class";
                MClass."Product ID" := NewMClass."Product ID";
                MClass.Insert;

            until NewMClass.Next = 0;
        end;
    end;

    local procedure GetJointMembers()
    var
        SignatoryApplication: Record "Joint Member Application";
        AccountSignatories: Record "Joint Members";
    begin
        SignatoryApplication.Reset;
        SignatoryApplication.SetRange("Account No", "No.");
        if SignatoryApplication.Find('-') then
            SignatoryApplication.DeleteAll;


        AccountSignatories.Reset;
        AccountSignatories.SetRange(AccountSignatories."Account No", "Account No.");
        if AccountSignatories.Find('-') then begin
            repeat
                EntryNo += 1;
                SignatoryApplication.Init;
                SignatoryApplication."Account No" := "No.";
                SignatoryApplication."Entry No" := EntryNo;
                SignatoryApplication."Account Type" := AccountSignatories."Account Type";
                SignatoryApplication."Member No." := AccountSignatories."Member No.";
                SignatoryApplication."ID Number" := AccountSignatories."ID Number";
                SignatoryApplication."Phone No." := AccountSignatories."Phone No.";
                SignatoryApplication."Date Of Birth" := AccountSignatories."Date Of Birth";
                SignatoryApplication.Signatory := AccountSignatories.Signatory;
                SignatoryApplication.CalcFields(Signature, Picture);
                SignatoryApplication.Signature := AccountSignatories.Signature;
                SignatoryApplication.Picture := AccountSignatories.Picture;
                SignatoryApplication."Must be Present" := AccountSignatories."Must be Present";
                SignatoryApplication."Must Sign" := AccountSignatories."Must Sign";
                SignatoryApplication.Names := AccountSignatories.Names;
                SignatoryApplication."Staff/Payroll" := AccountSignatories."Staff/Payroll";
                SignatoryApplication.Type := AccountSignatories.Type;
                SignatoryApplication."Expiry Date" := AccountSignatories."Expiry Date";
                SignatoryApplication."PIN Number" := AccountSignatories."PIN Number";
                SignatoryApplication.Insert;

            until AccountSignatories.Next = 0;
        end;
    end;

    /// <summary>
    /// GetBeneficiary.
    /// </summary>
    procedure GetBeneficiary()
    begin
        BeneficiaryApp.Reset;
        BeneficiaryApp.SetRange("Account No", "No.");
        if BeneficiaryApp.Find('-') then
            BeneficiaryApp.DeleteAll;

        Beneficiary.Reset;
        Beneficiary.SetRange("Account No", "Member No.");
        if Beneficiary.Find('-') then begin
            repeat

                BeneficiaryApp.Init;
                BeneficiaryApp."Entry No." := Beneficiary."Entry No.";
                BeneficiaryApp."Account No" := "No.";
                BeneficiaryApp.Name := Beneficiary.Name;
                BeneficiaryApp.Relationship := Beneficiary.Relationship;
                BeneficiaryApp.Beneficiary := Beneficiary.Beneficiary;
                BeneficiaryApp."Date of Birth" := Beneficiary."Date of Birth";
                BeneficiaryApp.Address := Beneficiary.Address;
                BeneficiaryApp.Telephone := Beneficiary.Telephone;
                BeneficiaryApp.Fax := Beneficiary.Fax;
                BeneficiaryApp."Post Code" := Beneficiary."Post Code";
                BeneficiaryApp.City := Beneficiary.City;
                BeneficiaryApp.Email := Beneficiary.Email;
                BeneficiaryApp."ID No./Birth Cert. No." := Beneficiary."ID No.";
                BeneficiaryApp."%Allocation" := Beneficiary."%Allocation";
                BeneficiaryApp.Type := Beneficiary.Type;
                BeneficiaryApp."Cheque Collector" := Beneficiary."Cheque Collector";
                BeneficiaryApp."BBF Entitlement" := Beneficiary."BBF Entitlement";
                BeneficiaryApp."BBF Entitlement Code" := Beneficiary."BBF Entitlement Code";
                BeneficiaryApp.Spouse := Beneficiary.Spouse;
                BeneficiaryApp.Insert;
            until Beneficiary.Next = 0;
        end;
    end;
}

