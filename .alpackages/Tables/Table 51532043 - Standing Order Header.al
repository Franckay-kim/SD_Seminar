/// <summary>
/// Table Standing Order Header (ID 51532043).
/// </summary>
table 51532043 "Standing Order Header"
{

    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get();
                    NoSeriesMgt.TestManual(SeriesSetup."Standing Order Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Application Date"; Date)
        {
            Editable = false;

        }
        field(3; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(4; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected,Stopped';
            OptionMembers = Open,Pending,Approved,Rejected,Stopped;
        }
        field(5; "Transaction Branch"; Code[10])
        {
        }
        field(6; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(7; "Source Account Type"; Enum "Gen. Journal Account Type")
        {
            // OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Savings,Credit';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        }
        field(8; "Source Account No."; Code[20])
        {
            /* ValidateTableRelation = false;
            TableRelation = IF ("Source Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Source Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Source Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Source Account Type" = CONST(Savings)) "Savings Accounts" where("Product Category" = const(Prime))
            ELSE
            IF ("Source Account Type" = CONST(Credit)) "Credit Accounts"; */

            trigger OnValidate()
            begin

                if Account.Get("Source Account No.") then begin
                    "Payroll/Staff No." := Account."Payroll/Staff No.";
                    "Source Account Name" := Account.Name;
                    "Member No." := Account."Member No.";
                    "ID Number" := Account."ID No.";
                end;
            end;
        }
        field(9; "Source Account Name"; Text[80])
        {
            Editable = false;
        }
        field(10; "Member No."; Code[10])
        {
            Editable = false;
        }
        field(11; "ID Number"; Code[20])
        {
            Editable = false;
        }
        field(12; "Payroll/Staff No."; Code[20])
        {
            Editable = false;
        }
        field(13; Description; Text[100])
        {
            Description = 'LookUp to Standing Orders Description Table';
        }
        field(14; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                Validate("Income Type");
            end;
        }
        field(15; "Allocated Amount"; Decimal)
        {
            CalcFormula = Sum("Standing Order Lines".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; Balance; Decimal)
        {
            Editable = false;
        }
        field(20; "Standing Order Type"; Option)
        {
            OptionCaption = 'Internal,External,Pensioner';
            OptionMembers = Internal,External,Pensioner;

            trigger OnValidate()
            begin
                if "Standing Order Type" = "Standing Order Type"::Pensioner then
                    Priority := 1
                else
                    if "Standing Order Type" = "Standing Order Type"::Internal then
                        Priority := 2
                    else
                        if "Standing Order Type" = "Standing Order Type"::External then
                            Priority := 3;
            end;
        }
        field(21; "Allow Partial Deduction"; Boolean)
        {

            trigger OnValidate()
            begin
                STOLines.Reset;
                STOLines.SetRange("Document No.", "No.");
                STOLines.SetRange(STOLines."Destination Account Type", STOLines."Destination Account Type"::"Bank Account");
                if STOLines.Find('-') then begin

                    if STOLines."Destination Account Type" = STOLines."Destination Account Type"::"Bank Account" then
                        Error('An external standing order cannot be partially deducted');
                end;
            end;
        }
        field(22; "None Salary"; Boolean)
        {
            Enabled = false;
        }
        field(23; "Income Type"; Option)
        {
            OptionCaption = ' ,Salary,Milk,Tea,Staff Salary,Business,Periodic,Bonus,Mini-Bonus';
            OptionMembers = " ",Salary,Milk,Tea,"Staff Salary",Business,Periodic,Bonus,"Mini-Bonus";

            trigger OnValidate()
            begin

                if ("Income Type" = "Income Type"::Periodic) or ("Income Type" = "Income Type"::Business) then
                    TestField("STO Type", "STO Type"::Amount);

                if "STO Type" = "STO Type"::Percentage then
                    if Amount > 100 then
                        Error('Percentage Value cannot be more than 100');
            end;
        }
        field(24; Type; Option)
        {
            OptionCaption = ' ,Fixed,Sweep';
            OptionMembers = " ","Fixed",Sweep;

            trigger OnValidate()
            begin
                StndingOrders.Reset;
                StndingOrders.SetRange(StndingOrders."Source Account No.", "Source Account No.");
                StndingOrders.SetRange(StndingOrders.Status, StndingOrders.Status::Approved);
                StndingOrders.SetRange(StndingOrders.Type, Type);
                if StndingOrders.Find('-') then begin
                    Error('This member has another standing order of Type %1', StndingOrders.Type);
                end;

                if Type = Type::Sweep then
                    Amount := 0;
            end;
        }
        field(25; Priority; Decimal)
        {
        }
        field(26; "Effective/Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Effective/Start Date" < CalcDate('-CM', Today) then
                    Error('Date must be Current Month or in future');

                "Next Run Date" := "Effective/Start Date";
            end;
        }
        field(27; "Frequency (Months)"; DateFormula)
        {

            trigger OnValidate()
            begin
                /*EVALUATE(DurationInteger,FORMAT("Duration (Months)"));
                EVALUATE(FrequencyInteger,FORMAT("Frequency (Months)"));
                IF DurationInteger < FrequencyInteger THEN
                  ERROR(DurationError);*/


                Evaluate(FrequencyText, Format("Frequency (Months)"));
                FrequencyText := DelChr(Format(FrequencyText), '=', '-|+|');
                Evaluate("Frequency (Months)", FrequencyText);

                //"Next Run Date":=CALCDATE("Frequency (Months)","Effective/Start Date");

            end;
        }
        field(28; "Duration (Months)"; DateFormula)
        {

            trigger OnValidate()
            begin
                TestField("Effective/Start Date");
                TestField("Frequency (Months)");
                TestField("Duration (Months)");

                /*EVALUATE(DurationInteger,FORMAT("Duration (Months)"));
                EVALUATE(FrequencyInteger,FORMAT("Frequency (Months)"));
                IF DurationInteger < FrequencyInteger THEN
                  ERROR(DurationError);*/

                Evaluate(DurationText, Format("Duration (Months)"));
                DurationText := DelChr(Format(DurationText), '=', '-|+|');
                Evaluate("Duration (Months)", DurationText);

                "End Date" := CalcDate("Duration (Months)", "Effective/Start Date");

            end;
        }
        field(29; "End Date"; Date)
        {
            Editable = true;
        }
        field(30; Effected; Boolean)
        {
            Editable = false;
        }
        field(31; Unsuccessfull; Boolean)
        {
            Editable = false;
        }
        field(32; "Next Run Date"; Date)
        {
        }
        field(33; "Auto Process"; Boolean)
        {
        }
        field(34; "Date Reset"; Date)
        {
            Editable = false;
        }
        field(35; Invalid; Boolean)
        {
        }
        field(36; Unrecovered; Boolean)
        {
        }
        field(37; "Created By"; Code[60])
        {
        }
        field(38; "Bank Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Bank Code";

            trigger OnValidate()
            begin
                //*
                BankCodes.Reset;
                BankCodes.SetRange(BankCodes."Bank Code", "Bank Code");
                if BankCodes.Find('-') then
                    "Bank Name" := BankCodes."Bank Name";

                //*
                if "Bank Code" = '' then begin
                    "Branch Code" := '';
                    "Bank Name" := '';
                    "Bank Account No." := '';
                end;
            end;
        }
        field(39; "Branch Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
        }
        field(40; "Bank Name"; Text[100])
        {
            Editable = false;
        }
        field(41; "Bank Account No."; Code[15])
        {

            trigger OnValidate()
            begin
                if StrLen("Bank Account No.") <> 13 then begin
                    Error('Invalid Bank account No. Please enter the correct Bank Account No.');
                end;
            end;
        }
        field(42; "Transfered to EFT"; Boolean)
        {
            Description = 'Help Identify eft that has External transfer during eft processing';
        }
        field(43; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Standing Order"));
        }
        field(44; "Target Amount"; Decimal)
        {
        }
        field(45; "STO Type"; Option)
        {
            OptionCaption = 'Amount,Percentage';
            OptionMembers = Amount,Percentage;

            trigger OnValidate()
            begin
                Validate("Income Type");
            end;
        }
        field(46; "Grower No."; Code[20])
        {
            TableRelation = "Member Factory"."Factory/Society No." WHERE("Member No" = FIELD("Member No."));
        }
        field(47; Source; Option)
        {
            OptionMembers = Navision,Web;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; Priority)
        {
        }
        key(Key3; "Source Account No.", Priority)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin


        UserSetup.Get(UserId);
        StndingOrders.Reset;
        StndingOrders.SetRange(Status, StndingOrders.Status::Open);
        StndingOrders.SetRange("Created By", UserId);
        if StndingOrders.FindFirst then
            /* if StndingOrders.Count >= UserSetup."Max. No of open Documents" then
                Error('You can only work on %1 Open Standing Orders', UserSetup."Max. No of open Documents"); */


        if "No." = '' then begin
                SeriesSetup.Get;
                SeriesSetup.TestField(SeriesSetup."Standing Order Nos.");
                NoSeriesMgt.InitSeries(SeriesSetup."Standing Order Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            end;

        "Application Date" := Today;
        "Created By" := UserId;
    end;

    var
        SeriesSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        StndingOrders: Record "Standing Order Header";
        Account: Record "Savings Accounts";
        BankAcc: Record "Bank Account";
        Cust: Record "Credit Accounts";
        BankCodes: Record "Bank Code Structure";
        FrequencyText: Text;
        DurationText: Text;
        DurationError: Label 'Duration cannot be less than Frequency';
        FrequencyInteger: Integer;
        DurationInteger: Integer;
        STOLines: Record "Standing Order Lines";
        UserSetup: Record "User Setup";
        AmountError: Label 'Allocated amount and amount are not the same.';

    /// <summary>
    /// ValidateApproval.
    /// </summary>
    procedure ValidateApproval()
    var
        StandingOrderLines: Record "Standing Order Lines";
    begin
        Rec.TestField(Status, Rec.Status::Open);
        Rec.TestField("Source Account No.");
        Rec.TestField(Amount);
        Rec.TestField("Effective/Start Date");
        Rec.TestField("Duration (Months)");
        Rec.TestField("Frequency (Months)");
        Rec.CalcFields("Allocated Amount");

        // IF "Next Run Date"<>CALCDATE('-CM',"Next Run Date") THEN
        //  ERROR('Next Run Date Must be Begining of the Month');

        if Rec."Allocated Amount" <> Rec.Amount then
            Error(AmountError);

        if Rec."Income Type" = Rec."Income Type"::" " then
            Error('Specify Income Type');

        StandingOrderLines.Reset;
        StandingOrderLines.SetRange(StandingOrderLines."Document No.", Rec."No.");
        if StandingOrderLines.Find('-') then begin
            repeat
                StandingOrderLines.TestField(StandingOrderLines.Amount);
                if StandingOrderLines."Destination Account Type" <> StandingOrderLines."Destination Account Type"::"Bank Account" then
                    StandingOrderLines.TestField(StandingOrderLines."Destination Account No.");

                case StandingOrderLines."Destination Account Type" of
                    StandingOrderLines."Destination Account Type"::"Bank Account":
                        begin
                            StandingOrderLines.TestField(StandingOrderLines."Bank Code");
                            /*StandingOrderLines.TESTFIELD(StandingOrderLines."Branch Code");*/
                            //StandingOrderLines.TESTFIELD(StandingOrderLines."Destination Account No.");
                            Rec."Transfered to EFT" := true;
                            Rec.Modify;
                        end;

                /* StandingOrderLines."Destination Account Type"::Credit:
                    begin
                        StandingOrderLines.TestField(StandingOrderLines."Loan No.");

                    end; */

                end;
            until StandingOrderLines.Next = 0;
        end;
    end;
}

