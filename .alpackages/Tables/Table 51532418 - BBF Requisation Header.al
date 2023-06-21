table 51532418 "BBF Requisation Header"
{

    fields
    {
        field(1; No; Code[20])
        {
            Editable = false;
        }
        field(2; Date; Date)
        {
            Editable = false;
        }
        field(3; "Captured By"; Code[30])
        {
            Editable = false;
        }
        field(4; Amount; Decimal)
        {
            CalcFormula = Sum("BBF Requisation Lines"."Sacco Amount" WHERE("Header No" = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Member No"; Code[20])
        {
            TableRelation = Members."No." WHERE(Status = FILTER(<> Deceased));

            trigger OnValidate()
            begin
                "Benevolent Balance" := 0;
                "Last Contribution Date" := 0D;

                if Members.Get("Member No") then begin
                    "Account Name" := Members.Name;
                    "Member Status" := Format(Members.Status);
                    "Employer Code" := Members."Employer Code";
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange("Member No.", "Member No");
                    SavingsAccounts.SetFilter("Product Category", '<>%1|%2', SavingsAccounts."Product Category"::"Registration Fee", SavingsAccounts."Product Category"::"Deposit Contribution");
                    if SavingsAccounts.FindFirst then begin
                        repeat
                            SavingsAccounts.CalcFields("Balance (LCY)", "Last Transaction Date");
                            "Benevolent Balance" += SavingsAccounts."Balance (LCY)";
                            "Last Contribution Date" := SavingsAccounts."Last Transaction Date";
                        until SavingsAccounts.Next() = 0;
                    end;
                end
                else begin
                    "Account Name" := '';
                end;
                Loans.RESET;
                Loans.SETRANGE("Member No.", "Member No");
                Loans.SETRANGE(Posted, TRUE);
                IF Loans.FIND('-') THEN
                    repeat
                        Loans.CALCFIELDS("Outstanding Balance", "Outstanding Interest");
                        "Loans Balance" += Loans."Outstanding Balance" + Loans."Outstanding Interest";
                    until Loans.Next() = 0;
            end;
        }
        field(6; "Account Name"; Text[50])
        {
        }
        field(7; "Responsibily Center"; Code[30])
        {
            TableRelation = "Responsibility CenterBR";
        }
        field(8; Type; Option)
        {
            OptionCaption = '  ,Kin,Principal Member';
            OptionMembers = "  ",Kin,"Principal Member";

            trigger OnValidate()
            begin

            end;
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;

            trigger OnValidate()
            begin
                if Status = Status::Approved then begin
                    if Members.Get("Member No") then
                        Members.Status := Members.Status::Deceased;
                    Members.Modify();
                end;
            end;
        }
        field(11; Payed; Boolean)
        {
        }
        field(12; Posted; Boolean)
        {
        }
        field(13; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(15; "Payment Release Date"; Date)
        {
        }
        field(16; "Collector Name"; Text[100])
        {
        }
        field(17; "Collector ID"; Code[20])
        {
        }
        field(18; "Collector Mobile No."; Code[13])
        {
        }
        field(19; "Collector Relationship"; Text[30])
        {
            Description = 'LookUp to Relationships Table';
            TableRelation = "Relationship Types";
        }
        field(20; "Benevolent Balance"; Decimal)
        {
        }
        field(21; "Last Contribution Date"; Date)
        {
        }
        field(22; "Loans Balance"; Decimal)
        {

        }
        field(23; "Member Status"; text[100])
        {

        }
        field(24; "Date of Demise"; Date)
        {
        }
        field(25; "Paying Bank"; code[20])
        {
            TableRelation = "Bank Account";
        }
        field(26; "Employer Code"; code[20])
        {

        }
        field(27; "Pay Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,EFT,Letter of Credit,Mpesa';
            OptionMembers = " ",Cash,Cheque,EFT,"Letter of Credit",Mpesa;
        }
        field(28; "Cheque No."; Code[20])
        {
            Caption = 'Cheque/EFT No';

            trigger OnValidate()
            begin
                if "Pay Mode" = "Pay Mode"::Cash then begin
                    Error('You CANNOT insert cheque No. If the Pay Mode is Cash');
                end;
            end;
        }

    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if No = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."BBF Claims");
            NoSeriesMgt.InitSeries(SeriesSetup."BBF Claims", xRec."No. Series", 0D, No, "No. Series");
        end;
        if UserSetup.Get(UserId) then
            //"Responsibily Center" := UserSetup."Responsibility Centre";
            //"Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            //"Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";

            "Captured By" := UserId;
        Date := Today;
        ApplicationDocuments.Reset;
        ApplicationDocuments.SetRange("Reference No.", No);
        if ApplicationDocuments.FindFirst then
            ApplicationDocuments.DeleteAll;

        ApplicationDocumentSetup.SetRange(Mandatory, true);
        if ApplicationDocumentSetup.FindFirst then begin
            repeat
                ApplicationDocuments.Init;
                ApplicationDocuments.Validate("Reference No.", No);
                ApplicationDocuments.Validate("Document No.", ApplicationDocumentSetup."Document No.");
                ApplicationDocuments.Insert(true);
            until ApplicationDocumentSetup.Next = 0;
        end;

        /*ProductFactory.Reset;
        ProductFactory.SetRange("Product Category", ProductFactory."Product Category"::Benevolent);
        if ProductFactory.Find('-') then begin

            ApplDocs.Reset;
            ApplDocs.SetRange(ApplDocs."Product ID", ProductFactory."Product ID");
            if ApplDocs.Find('-') then begin
                repeat
                    LoanReqDocs.Init;
                    LoanReqDocs."Loan No." := No;
                    LoanReqDocs.Description := ApplDocs.Description;
                    LoanReqDocs."Document No." := ApplDocs."Document No.";
                    LoanReqDocs."Document Type" := ApplDocs."Document Type";
                    LoanReqDocs."Entry No." := LoanReqDocs."Entry No." + 100;
                    LoanReqDocs."Product ID" := ProductFactory."Product ID";
                    LoanReqDocs."Product Name" := ProductFactory."Product Description";
                    LoanReqDocs.Insert;
                until ApplDocs.Next = 0;
            end;
        end;*/
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserSetup: Record "User Setup";
        Members: Record Members;
        Loans: Record Loans;
        BBFRequisationLines: Record "BBF Requisation Lines";
        EntryNo: Integer;
        SavingsAccounts: Record "Savings Accounts";
        BBFEntitlement: Record "BBF Entitlement";
        DimVal: Record "Dimension Value";
        ProductFactory: Record "Product Factory";
        ApplDocs: Record "Product Documents";
        LoanReqDocs: Record "Loan Required Documents";
        BBFRequisationHeader: Record "BBF Requisation Header";
        Err001: Label 'Claim has already been raised';
        ApplicationDocuments: Record "Application Documents";
        ApplicationDocumentSetup: Record "Application Document Setup";
}

