/// <summary>
/// Table E-Tender Company Information (ID 51533367).
/// </summary>
table 51533367 "E-Tender Company Information"
{


    Caption = 'E-Tender Company Information';
    //DrillDownPageID = "Etender Supplier List";
    //LookupPageID = "Etender Supplier List";

    fields
    {
        field(1; "Primary Key"; Code[40])
        {
            Caption = 'Primary Key';

            trigger OnValidate();
            var
                PurchSetup: Record "Purchases & Payables Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;

            begin
                IF "Primary Key" <> xRec."Primary Key" THEN BEGIN
                    PurchSetup.GET();
                    //NoSeriesMgt.TestManual(PurchSetup."Supplier No");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Name; Text[150])
        {
            Caption = 'Name';
        }
        field(3; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(4; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(6; City; Text[30])
        {
            Caption = 'City';
            //TableRelation = IF (Country/Region Code=CONST()) "Post Code".City;
            //ValidateTableRelation = false;

            trigger OnValidate();
            begin
                //PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(7; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(8; "AGPO Registration Date"; DateTime)
        {
            Caption = 'AGPO Registration Date';

        }
        field(9; "AGPO Expiry Date"; DateTime)
        {
            Caption = 'AGPO Expiry Date';
        }
        field(10; Currency; Code[20])
        {
            Caption = 'Currency';
        }
        field(11; "Tax Compliance Certificate No."; Text[40])
        {
            Caption = 'Tax Compliance Certificate No.';
        }
        field(12; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
        }
        field(13; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(14; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(15; "Payment Routing No."; Text[20])
        {
            Caption = 'Payment Routing No.';
        }
        field(19; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate();
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                //VATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", '', DATABASE::"Company Information");
            end;
        }
        field(20; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
        }
        field(22; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(23; "Tax Compliance Issues Date"; DateTime)
        {
            Caption = 'Tax Compliance Issues Date';
        }
        field(24; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(25; "Tax Compliance Expiry Date"; DateTime)
        {
            Caption = 'Tax Compliance Expiry Date';
        }
        field(26; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            //TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City;
            //ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidateCity(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(27; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(29; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(30; "Post Code"; Code[20])
        {
            Caption = 'Post Code';

        }
        field(31; County; Text[30])
        {
            Caption = 'County';
        }
        field(32; "Ship-to Post Code"; Code[20])
        {

        }
        field(33; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(34; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
            NotBlank = true;
        }
        field(36; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            //TableRelation = Country/Region;
        }
        field(37; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            //TableRelation = Country/Region;
        }
        field(38; IBAN; Code[50])
        {
            Caption = 'IBAN';

            trigger OnValidate();
            begin
                //CheckIBAN(IBAN);
            end;
        }
        field(39; "SWIFT Code"; Code[30])
        {
            Caption = 'SWIFT Code';
        }
        field(90; GLN; Code[13])
        {
            Caption = 'GLN';
            Numeric = true;


        }
        field(99; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
            Editable = false;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;
            ValidateTableRelation = true;
        }
        field(50000; "PIN No"; Code[30])
        {

            trigger OnValidate();
            var
                ETenderCompanyInformation: Record "E-Tender Company Information";
            begin
                ETenderCompanyInformation.RESET;
                ETenderCompanyInformation.SETRANGE(ETenderCompanyInformation."PIN No", "PIN No");
                IF ETenderCompanyInformation.FIND('-') THEN BEGIN
                    IF "PIN No" = ETenderCompanyInformation."PIN No" THEN
                        ERROR('The PIN No Already Exists');
                END;
            end;
        }
        field(50004; Status; Option)
        {
            OptionCaption = ',New,Update Certificate,Pre Qualification,Pending,Approved,Cancelled,Open,Rejected';
            OptionMembers = ,New,"Update Certificate","Pre Qualification",Pending,Approved,Cancelled,Open,Rejected;
        }
        field(50005; "Vendor No"; Code[40])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                ETenderCompanyInformation.RESET;
                ETenderCompanyInformation.SETRANGE("Vendor No", Rec."Vendor No");
                IF ETenderCompanyInformation.FIND('-') THEN
                    ERROR(Text003 + ETenderCompanyInformation."Primary Key");
            end;
        }
        field(50006; "Vendor Type"; Option)
        {
            OptionCaption = 'Local,Foreign';
            OptionMembers = "Local",Foreign;
        }
        field(50007; "Vendor Category"; Option)
        {
            OptionCaption = ',AGPO Group,General';
            OptionMembers = ,"AGPO Group",General,All;
        }
        field(50008; RecID; RecordID)
        {
        }
        field(50009; "Item Category"; Code[50])
        {
        }
        field(50010; "Name of Building"; Text[80])
        {
        }
        field(50011; "Room /Office No."; Text[30])
        {
        }
        field(50012; "Floor No."; Text[30])
        {
        }
        field(50013; "Full Name of applicant"; Text[80])
        {
        }
        field(50014; "AGPO Category"; Option)
        {
            OptionCaption = '" ,Youth,Women,PWD,General"';
            OptionMembers = " ",Youth,Women,PWD,General;
        }
        field(50015; "Chief Executive"; Text[100])
        {
        }
        field(50016; Secretary; Text[100])
        {
        }
        field(50017; "General Manager"; Text[100])
        {
        }
        field(50018; Treasurer; Text[100])
        {
        }
        field(50019; "Other Personnel"; Text[100])
        {
        }
        field(50020; "Nature Of Business"; Option)
        {
            OptionCaption = '" , Sole Proprietor,Incorporated,Partnership,Registered Company"';
            OptionMembers = " "," Sole Proprietor",Incorporated,Partnership,"Registered Company";
        }
        field(50021; "Under Current Management Since"; DateTime)
        {
        }
        field(50022; "Net Worth"; Decimal)
        {
        }
        field(50024; "Terms Of Trade"; Text[50])
        {
        }
        field(50027; "Credit Period"; DateFormula)
        {
        }
        field(50028; "Current Trade License. No"; Code[40])
        {
        }
        field(50029; "Expiring date"; DateTime)
        {
        }
        field(50030; "Nominal Amount"; Decimal)
        {
        }
        field(50031; "Issued Amount"; Decimal)
        {
        }
        field(50033; "No. Series"; Code[30])
        {
        }
        field(50034; "AGPO Certificate No."; Text[50])
        {
        }
        field(50035; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,LevyInvoice,memo,supplier';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",LevyInvoice,memo,supplier;
        }
        field(50036; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate();
            var
                IncomingDocument: Record "Incoming Document";
            begin
                IF "Incoming Document Entry No." = xRec."Incoming Document Entry No." THEN
                    EXIT;
                IF "Incoming Document Entry No." = 0 THEN
                    IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                //ELSE
                //IncomingDocument.SetsupplierDoc(Rec);
            end;
        }
        field(50037; "Open Tender"; Boolean)
        {
        }
        field(50038; "Vendor Pre Registered"; Boolean)
        {

        }
    }


    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF "Primary Key" = '' THEN BEGIN
            PurchSetup.GET;

            //PurchSetup.TESTFIELD(PurchSetup."Supplier No");
            //NoSeriesMgt.InitSeries(PurchSetup."Supplier No", xRec."No. Series", 0D, "Primary Key", "No. Series");
        END;


        RecID := RECORDID;
        DocSetup.RESET;
        IF DocSetup.FIND('-') THEN
            REPEAT
                CompanyDoc.INIT;
                CompanyDoc."Entry No" := 0;
                CompanyDoc."Reference No" := "Primary Key";
                CompanyDoc."Document Code" := DocSetup.Code;
                CompanyDoc.Description := DocSetup.Description;
                CompanyDoc.Category := DocSetup.Category;
                CompanyDoc.Mandatory := DocSetup.Mandatory;
                CompanyDoc."Mandatory Category" := DocSetup."Mandatory Category";
                CompanyDoc.RecID := CompanyDoc.RecID;
                CompanyDoc."Prof RecID" := RecID;
                CompanyDoc.INSERT
UNTIL DocSetup.NEXT = 0;
    end;

    trigger OnModify();
    begin
        RecID := RECORDID;
    end;

    var
        PostCode: Record "Post Code";
        Text000: Label 'The number that you entered may not be a valid International Bank Account Number (IBAN). Do you want to continue?';
        Text001: Label 'File Location for IC files';
        Text002: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        NoPaymentInfoQst: TextConst Comment = '%1 = Company Information', ENU = 'No payment information is provided in %1. Do you want to update it now?';
        NoPaymentInfoMsg: Label 'No payment information is provided in %1. Review the report.';
        GLNCheckDigitErr: Label 'The %1 is not valid.';
        //DevBetaModeTxt: Label 'DEV_BETA', Comment = '{Locked}';
        CompanyDoc: Record 51533369;
        DocSetup: Record 51533370;
        ETenderCompanyInformation: Record 51533367;
        Text003: Label 'This Vendor number is already being used by Supplier Number,';
}

