table 51532109 "Salary Header"
{
    //DrillDownPageID = "Salary Lists";
    //LookupPageID = "Salary Lists";

    fields
    {
        field(1; No; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Salary Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
        }
        field(3; Posted; Boolean)
        {
            Editable = true;
        }
        field(6; "Posted By"; Code[50])
        {
            Editable = false;
        }
        field(7; "Date Entered"; Date)
        {
        }
        field(9; "Entered By"; Text[50])
        {
        }
        field(10; Remarks; Text[150])
        {
        }
        field(19; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(20; "Time Entered"; Time)
        {
        }
        field(21; "Posting date"; Date)
        {
        }
        field(22; "Account Type"; Enum "Gen. Journal Account Type")
        {
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Savings,Credit';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        }
        field(23; "Account No"; Code[50])
        {
            /*TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Account Type" = CONST(Employer))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Account Type" = CONST(Credit)) "Credit Accounts";*/

            trigger OnValidate()
            begin

                if "Account Type" = "Account Type"::Customer then begin
                    cust.Reset;
                    cust.SetRange(cust."No.", "Account No");
                    if cust.Find('-') then begin
                        "Account Name" := cust.Name;
                        "Employer Code" := "Account No";

                    end;
                end;

                if "Account Type" = "Account Type"::Vendor then begin
                    Vend.Reset;
                    Vend.SetRange(Vend."No.", "Account No");
                    if Vend.Find('-') then begin
                        "Account Name" := Vend.Name;
                    end;
                end;

                if "Account Type" = "Account Type"::Employee then begin
                    Savings.Reset;
                    Savings.SetRange(Savings."No.", "Account No");
                    if Savings.Find('-') then begin
                        //"Account Name":=Savings.Name;
                        "Account Name" := PadStr(Format(Savings.Name), 30);
                    end;
                end;


                if "Account Type" = "Account Type"::"G/L Account" then begin
                    "GL Account".Reset;
                    "GL Account".SetRange("GL Account"."No.", "Account No");
                    if "GL Account".Find('-') then begin
                        "Account Name" := "GL Account".Name;
                    end;
                end;

                if "Account Type" = "Account Type"::"Bank Account" then begin
                    BANKACC.Reset;
                    BANKACC.SetRange(BANKACC."No.", "Account No");
                    if BANKACC.Find('-') then begin
                        "Account Name" := BANKACC.Name;

                    end;
                end;
            end;
        }
        field(24; "Document No"; Code[20])
        {
        }
        field(25; Amount; Decimal)
        {
        }
        field(26; "Scheduled Amount"; Decimal)
        {
            CalcFormula = Sum("Salary Lines".Amount WHERE("Salary Header No." = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Total Count"; Integer)
        {
            CalcFormula = Count("Salary Lines" WHERE("Salary Header No." = FIELD(No)));
            FieldClass = FlowField;
        }
        field(28; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(29; "Employer Code"; Code[30])
        {
            TableRelation = Customer."No.";
        }
        field(30; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(31; "Income Type"; Option)
        {
            OptionCaption = ' ,Salary,Milk,Tea,Staff Salary,Business,Periodic,Bonus,Mini-Bonus,Banana,Coffee';
            OptionMembers = " ",Salary,Milk,Tea,"Staff Salary",Business,Periodic,Bonus,"Mini-Bonus",Banana,Coffee;

            trigger OnValidate()
            begin
                "Recovery Type" := "Recovery Type"::" ";


                if ("Income Type" = "Income Type"::Milk) or ("Income Type" = "Income Type"::Banana) then
                    "Recovery Type" := "Recovery Type"::" "
                else
                    "Recovery Type" := "Recovery Type"::"Full Amount";
            end;
        }
        field(32; "Destination Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Salary Processing"));

            trigger OnValidate()
            begin
                "Document No" := No;
            end;
        }
        field(33; Validated; Boolean)
        {
        }
        field(34; "Mutiple Salaries Checked"; Boolean)
        {
        }
        field(35; "Last Loan Issue Date"; Date)
        {
        }
        field(36; "Source Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Salary Processing"));

            trigger OnValidate()
            begin
                "Document No" := No;
            end;
        }
        field(37; "Unidentified Amount"; Decimal)
        {
            CalcFormula = Sum("Salary Lines".Amount WHERE("Salary Header No." = FIELD(No),
                                                           "Account Not Found" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Unidentified Account No"; Code[30])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin

                if "Account Type" = "Account Type"::Customer then begin
                    cust.Reset;
                    cust.SetRange(cust."No.", "Account No");
                    if cust.Find('-') then begin
                        "Account Name" := cust.Name;
                    end;
                end;

                if "Account Type" = "Account Type"::"G/L Account" then begin
                    "GL Account".Reset;
                    "GL Account".SetRange("GL Account"."No.", "Account No");
                    if "GL Account".Find('-') then begin
                        "Account Name" := "GL Account".Name;
                    end;
                end;

                if "Account Type" = "Account Type"::"Bank Account" then begin
                    BANKACC.Reset;
                    BANKACC.SetRange(BANKACC."No.", "Account No");
                    if BANKACC.Find('-') then begin
                        "Account Name" := BANKACC.Name;

                    end;
                end;
            end;
        }
        field(39; "Payment Type"; Option)
        {
            OptionCaption = ' ,Salaries,Annual Payout,Semi-Annual,Quarterly';
            OptionMembers = " ",Salaries,"Annual Payout","Semi-Annual",Quarterly;
        }
        field(40; "Recovery Type"; Option)
        {
            OptionCaption = ' ,Full Amount,Half Amount,Skip Loans';
            OptionMembers = " ","Full Amount","Half Amount","Skip Loans";

            trigger OnValidate()
            begin

                if "Recovery Type" = "Recovery Type"::"Half Amount" then
                    if ("Income Type" <> "Income Type"::Milk) and ("Income Type" <> "Income Type"::Banana) then
                        Error('Invalid Option');
            end;
        }
        field(41; "Cheque No."; Code[6])
        {
            trigger OnValidate()

            begin
                "Document No" := "Cheque No.";
            end;
        }
        field(42; "Additional SMS"; Text[80])
        {

            trigger OnValidate()
            begin
                /*
                IF "Additional SMS"<>'' THEN
                    IF "Income Type"<>"Income Type"::Tea THEN
                        ERROR('This option is for Tea only');
                
                */

            end;
        }
        field(43; "Process Type"; Option)
        {
            OptionCaption = ' ,General Process,Branch Process';
            OptionMembers = " ","General Process","Branch Process";
        }
        field(44; "Posted Entries"; Integer)
        {
            CalcFormula = Count("Salary Lines" WHERE("Salary Header No." = FIELD(No),
                                                      Posted = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(45; "UnPosted Entries"; Integer)
        {
            CalcFormula = Count("Salary Lines" WHERE("Salary Header No." = FIELD(No),
                                                      Posted = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(46; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(47; "Payroll Period"; Date)
        {
            // TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(48; "Dont Send SMS"; Boolean)
        {
        }
        field(49; Reversed; Boolean)
        {
        }
        field(50; "Add. Account Type"; Enum "Gen. Journal Account Type")
        {
            //  OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(51; "Add. Account No"; Code[30])
        {
            /* TableRelation = IF ("Add. Account Type" = CONST("G/L Account")) "G/L Account"
             ELSE
             IF ("Add. Account Type" = CONST(Customer)) Customer WHERE("Account Type" = CONST(Employer))
             ELSE
             IF ("Add. Account Type" = CONST(Vendor)) Vendor
             ELSE
             IF ("Add. Account Type" = CONST("Bank Account")) "Bank Account"
             ELSE
             IF ("Add. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
             ELSE
             IF ("Add. Account Type" = CONST("IC Partner")) "IC Partner"
             ELSE
             IF ("Add. Account Type" = CONST(Savings)) "Savings Accounts"
             ELSE
             IF ("Add. Account Type" = CONST(Credit)) "Credit Accounts";*/

            trigger OnValidate()
            begin

                if "Account Type" = "Account Type"::Customer then begin
                    cust.Reset;
                    cust.SetRange(cust."No.", "Account No");
                    if cust.Find('-') then begin
                        "Account Name" := cust.Name;
                    end;
                end;

                if "Account Type" = "Account Type"::Vendor then begin
                    Vend.Reset;
                    Vend.SetRange(Vend."No.", "Account No");
                    if Vend.Find('-') then begin
                        "Account Name" := Vend.Name;
                    end;
                end;

                if "Account Type" = "Account Type"::Employee then begin
                    Savings.Reset;
                    Savings.SetRange(Savings."No.", "Account No");
                    if Savings.Find('-') then begin
                        "Account Name" := Savings.Name;
                    end;
                end;


                if "Account Type" = "Account Type"::"G/L Account" then begin
                    "GL Account".Reset;
                    "GL Account".SetRange("GL Account"."No.", "Account No");
                    if "GL Account".Find('-') then begin
                        "Account Name" := "GL Account".Name;
                    end;
                end;

                if "Account Type" = "Account Type"::"Bank Account" then begin
                    BANKACC.Reset;
                    BANKACC.SetRange(BANKACC."No.", "Account No");
                    if BANKACC.Find('-') then begin
                        "Account Name" := BANKACC.Name;

                    end;
                end;
            end;
        }
        field(52; "Additional Deduction"; Decimal)
        {
        }
        field(53; "Additional Ded. Details"; Text[50])
        {
        }
        field(54; Source; Option)
        {
            OptionMembers = Navision,Web;
            DataClassification = ToBeClassified;
        }
        field(55; "Portal Status"; Option)
        {
            OptionMembers = New,Submitted;
            DataClassification = ToBeClassified;
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
    var
        USetup: Record "User Setup";
    begin
        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Salary Nos.");
            NoSeriesMgt.InitSeries(NoSetup."Salary Nos.", xRec."No. Series", 0D, No, "No. Series");
        end;

        "Entered By" := UpperCase(UserId);
        USetup.Get(UserId);
        "Account Type" := "Account Type"::Customer;
        "Process Type" := "Process Type"::"General Process";
        // "Global Dimension 2 Code" := USetup."Global Dimension 2 Code";

        "Date Entered" := Today;
        "Time Entered" := Time;
    end;

    var
        NoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        "GL Account": Record "G/L Account";
        BANKACC: Record "Bank Account";
        cust: Record Customer;
        Vend: Record Vendor;
        Savings: Record "Savings Accounts";

    procedure ValidateLines()
    var
        SalaryLines: Record "Salary Lines";
        SavingsAccounts: Record "Savings Accounts";
        Members: Record Members;
        StrMenuTxt: Label '&Old Account No.,&Account No.,&ID No';
        Selection: Integer;
        UserSetup: Record "User Setup";
    begin
        SalaryLines.Reset;
        SalaryLines.SetRange(SalaryLines."Salary Header No.", Rec.No);
        if SalaryLines.Find('-') then begin
            repeat
                SavingsAccounts.Reset;
                SavingsAccounts.SetRange("No.", SalaryLines."Account No.");
                //SavingsAccounts.SETFILTER(SavingsAccounts."Loan Disbursement Account",'%1',TRUE);
                if SavingsAccounts.Find('-') then begin
                    SalaryLines."ID No." := SavingsAccounts."ID No.";
                    SalaryLines."Account No." := SavingsAccounts."No.";
                    SalaryLines.Status := SavingsAccounts.Status;
                    if SavingsAccounts.Blocked <> SavingsAccounts.Blocked::" " then
                        SalaryLines."Blocked Accounts" := true
                    else
                        SalaryLines."Blocked Accounts" := false;

                    if Members.Get(SavingsAccounts."Member No.") then begin

                        if SavingsAccounts."Employer Code" <> '' then
                            SalaryLines."Employer Code" := SavingsAccounts."Employer Code"
                        else
                            SalaryLines."Employer Code" := Members."Employer Code";

                        if Rec."Process Type" = Rec."Process Type"::"General Process" then begin
                            if SavingsAccounts."Global Dimension 1 Code" <> '' then
                                SalaryLines."Global Dimension 1 Code" := SavingsAccounts."Global Dimension 1 Code"
                            else
                                SalaryLines."Global Dimension 1 Code" := Members."Global Dimension 1 Code";

                            if SavingsAccounts."Global Dimension 2 Code" <> '' then
                                SalaryLines."Global Dimension 2 Code" := SavingsAccounts."Global Dimension 2 Code"
                            else
                                SalaryLines."Global Dimension 2 Code" := Members."Global Dimension 2 Code";
                        end
                        else
                            if Rec."Process Type" = Rec."Process Type"::"Branch Process" then begin
                                if SavingsAccounts."Global Dimension 1 Code" <> '' then
                                    SalaryLines."Global Dimension 1 Code" := SavingsAccounts."Global Dimension 1 Code"
                                else
                                    SalaryLines."Global Dimension 1 Code" := Members."Global Dimension 1 Code";

                                UserSetup.Get(UserId);
                                // SalaryLines."Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";

                            end
                            else
                                Error('Process Type Must Have a Value');


                    end;
                    //SalaryLines."Member No.":=SavingsAccounts."Member No.";
                    SalaryLines."Member No." := SavingsAccounts."Member No.";
                    SalaryLines.Name := SavingsAccounts.Name;
                    SalaryLines."Old Account No." := SavingsAccounts."Old Account No";
                    SalaryLines."ID No." := SavingsAccounts."ID No.";
                    SalaryLines."Account Not Found" := false;
                    SalaryLines.Modify;
                end else
                    SalaryLines."Account Not Found" := true;
                SalaryLines.Modify;

            until SalaryLines.Next = 0;
        end;


        Rec.Validated := true;
        Rec.Modify;
        Message('Salary Lines Validated sucessfully');
    end;

    procedure ValidateApproval()
    var
        DocMustbeOpen: Label 'This application request must be open';
    begin
        Rec.TestField("Destination Transaction Type");
        if Rec.Status <> Rec.Status::Open then
            Error(DocMustbeOpen);

        Rec.CalcFields("Unidentified Amount", "Scheduled Amount");

        if Rec."Additional Deduction" > 0 then begin
            Rec.TestField("Add. Account No");
            Rec.TestField("Additional Ded. Details");
        end;
        //IF "Payment Type"="Payment Type"::" " THEN ERROR('Kindly select payment type');

        if Rec."Scheduled Amount" <> Rec.Amount then
            Error('Scheduled amount and Amount must be the same');

        if Rec."Unidentified Amount" <> 0 then
            Rec.TestField("Unidentified Account No");

        Rec.TestField("Destination Transaction Type");
        Rec.TestField("Account No");
        Rec.TestField("Document No");
        Rec.TestField("Cheque No.");
        Rec.TestField(Remarks);
        Rec.TestField(Amount);
        Rec.TestField("Income Type");
        Rec.TestField("Posting date");
        Rec.TestField("Mutiple Salaries Checked", true);

        if Rec.Validated = false then
            Error('Kindly validate the salary batch before proceeding');
    end;
}

