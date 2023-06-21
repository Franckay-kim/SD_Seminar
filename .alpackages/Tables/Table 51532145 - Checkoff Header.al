table 51532145 "Checkoff Header"
{


    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Checkoff No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "No. Series"; Code[10])
        {
        }
        field(3; "Date Entered"; Date)
        {
        }
        field(4; "Time Entered"; Time)
        {
        }
        field(5; "Entered By"; Code[50])
        {
        }
        field(6; "Posting Date"; Date)
        {
        }
        field(7; "Account Type"; Enum "Gen. Journal Account Type")
        {
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Savings,Credit';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        }
        field(8; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = FILTER(Customer)) Customer."No."
            ELSE
            IF ("Account Type" = FILTER("Bank Account")) "Bank Account"."No.";

            trigger OnValidate()
            begin
                if Customer.Get("Account No.") then begin
                    "Account Name" := Customer.Name;
                    "Employer Code" := "Account No.";
                    "Employer Name" := "Account Name";
                end else
                    "Account Name" := '';
            end;
        }
        field(9; "Account Name"; Text[50])
        {
        }
        field(10; "Document No."; Code[20])
        {
        }
        field(11; Amount; Decimal)
        {
        }
        field(12; "CHK Line Amount"; Decimal)
        {
            CalcFormula = Sum("Checkoff Lines".Amount WHERE("Checkoff Header" = FIELD("No.")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
        field(13; "Employer Code"; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Customer.Get("Employer Code") then begin
                    "Employer Name" := Customer.Name;
                end else
                    "Employer Name" := '';
            end;
        }
        field(14; "Employer Name"; Text[50])
        {
            Editable = false;
        }
        field(15; "Total Count"; Integer)
        {
            CalcFormula = Count("Checkoff Lines" WHERE("Checkoff Header" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(16; Description; Text[50])
        {
        }
        field(17; Posted; Boolean)
        {
        }
        field(18; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(19; "Posted Records"; Integer)
        {
            CalcFormula = Count("Checkoff Lines" WHERE("Checkoff Header" = FIELD("No."),
                                                        Posted = FILTER(true)));
            FieldClass = FlowField;
        }
        field(20; "Vendor No"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(21; "CHK Buffer Amount"; Decimal)
        {
            CalcFormula = Sum("Checkoff Buffer".Amount WHERE("Checkoff No" = FIELD("No.")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
        field(22; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Reversed By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Date Reversed"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "CheckOff Type"; Option)
        {
            OptionMembers = Block,Distributed;
            DataClassification = ToBeClassified;
        }
        field(26; Source; Option)
        {
            OptionMembers = Navision,Web;
            DataClassification = ToBeClassified;
        }
        field(27; "Portal Status"; Option)
        {
            OptionMembers = New,Submitted;
            DataClassification = ToBeClassified;
        }
        field(28; "Receipt No."; Code[500])
        {
            TableRelation = "Receipts Header"."No." where(Posted = const(true));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RHead: Record "Receipts Header";
            begin
                RHead.reset;
                RHead.SetRange("No.", "Receipt No.");
                if RHead.Find('-') then begin
                    RHead.CalcFields("Total Amount");
                    "Receipt Amount" := RHead."Total Amount";
                end;
            end;

        }
        field(29; "Receipt Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Receipt Line".Amount where(No = field("Receipt No."), Posted = const(true)));
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
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Checkoff No.");
            NoSeriesMgt.InitSeries(NoSetup."Checkoff No.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Date Entered" := Today;
        "Time Entered" := Time;
        "Entered By" := UserId;
        "Account Type" := "Account Type"::Customer;
        "CheckOff Type" := "CheckOff Type"::Block;

    end;

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Customer: Record Customer;

    procedure GenerateLines()
    var
        Emp: Record Customer;
        //PeriodicActy: Codeunit "Periodic Activities";
        Err002: Label 'There are entries that have been posted you cannot generate lines';
    begin
        Rec.CalcFields("Posted Records");
        if Rec."Posted Records" > 0 then
            Error(Err002);

        Emp.Get(Rec."Employer Code");
        /*case Rec."CheckOff Type" of
            Rec."CheckOff Type"::Block:
                begin
                    if Emp."Checkoff Type" = Emp."Checkoff Type"::"Per Product" then
                        PeriodicActy.GenerateSingleCheckoff(Rec)
                    else
                        if Emp."Checkoff Type" = Emp."Checkoff Type"::Block then
                            PeriodicActy.GenerateBlockCheckoff(Rec)
                        else
                            Error('Check Type Must have a value in Employer %1', Rec."Employer Code");
                end;
            Rec."CheckOff Type"::Distributed:
                PeriodicActy.GenerateDistributedCheckoff(Rec);
        end;*/
    end;

    procedure ValidateApproval()
    var
        DocMustbeOpen: Label 'This application request must be open';
    begin
        if Rec.Status <> Rec.Status::Open then
            Error(DocMustbeOpen);

        Rec.TestField(Description);
        Rec.TestField(Amount);
        Rec.TestField("Employer Code");
        Rec.TestField("Posting Date");
    end;
}

