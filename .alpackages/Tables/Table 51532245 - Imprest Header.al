/// <summary>
/// Table Imprest Header (ID 51532245).
/// </summary>
table 51532245 "Imprest Header"
{
    //DrillDownPageID = "Imprest Vouchers List";
    //LookupPageID = "Imprest Vouchers List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the reference of the payment voucher in the database';
            NotBlank = false;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the payment voucher was inserted into the system';
            Editable = false;

            trigger OnValidate()
            begin
                /*if ImpLinesExist then begin
                    Error('You first need to delete the existing imprest lines before changing the date'
                    );
                end;

                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                UpdateHeaderToLine;*/
            end;
        }
        field(3; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            Enabled = true;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if ImpLinesExist then begin
                    Error('You first need to delete the existing imprest lines before changing the Currency Code'
                    );
                end;

                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                    //RecreatePurchLines(FIELDCAPTION("Currency Code"));
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                UpdateHeaderToLine;
            end;
        }
        field(9; Payee; Text[100])
        {
            Description = 'Stores the name of the person who received the money';
        }
        field(10; "On Behalf Of"; Text[100])
        {
            Description = 'Stores the name of the person on whose behalf the payment voucher was taken';
        }
        field(11; Cashier; Code[60])
        {
            Description = 'Stores the identifier of the cashier in the database';
        }
        field(16; Posted; Boolean)
        {
            Description = 'Stores whether the payment voucher is posted or not';
        }
        field(17; "Date Posted"; Date)
        {
            Description = 'Stores the date when the payment voucher was posted';
        }
        field(18; "Time Posted"; Time)
        {
            Description = 'Stores the time when the payment voucher was posted';
        }
        field(19; "Posted By"; Code[50])
        {
            Description = 'Stores the name of the person who posted the payment voucher';
        }
        field(20; "Total Payment Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line".Amount WHERE(No = FIELD("No.")));
            Description = 'Stores the amount of the payment voucher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            Description = 'Stores the name of the paying bank account in the database';
            TableRelation = "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"));

            trigger OnValidate()
            begin
                BankAcc.Reset;
                "Bank Name" := '';
                if BankAcc.Get("Paying Bank Account") then begin
                    "Bank Name" := BankAcc.Name;
                    // "Currency Code":=BankAcc."Currency Code";   //Currency Being determined first before document is released for approval
                    // VALIDATE("Currency Code");
                end;
            end;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;

                UpdateHeaderToLine;
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(35; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Imprest;
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;

                UpdateHeaderToLine;
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(57; "Function Name"; Text[100])
        {
            Description = 'Stores the name of the function in the database';
        }
        field(58; "Budget Center Name"; Text[100])
        {
            Description = 'Stores the name of the budget center in the database';
        }
        field(59; "Bank Name"; Text[100])
        {
            Description = 'Stores the description of the paying bank account in the database';
        }
        field(60; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
        }
        field(61; Select; Boolean)
        {
            Description = 'Enables the user to select a particular record';
        }
        field(62; "Total VAT Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."VAT Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Total Witholding Tax Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Withholding Tax Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Total Net Amount"; Decimal)
        {
            CalcFormula = Sum("Imprest Lines".Amount WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Current Status"; Code[20])
        {
            Description = 'Stores the current status of the payment voucher in the database';
        }
        field(66; "Cheque No."; Code[20])
        {

            trigger OnValidate()
            begin
                if "Pay Mode" = "Pay Mode"::Cash then begin

                    "Cheque No." := ''

                end;
            end;
        }
        field(67; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Letter of Credit",Mpesa,"Custom 4","Custom 5";
        }
        field(68; "Payment Release Date"; Date)
        {

            trigger OnValidate()
            begin

                //Changed to ensure Release date is not less than the Date entered
                if "Payment Release Date" < Date then
                    Error('The Payment Release Date cannot be lesser than the Document Date');
            end;
        }
        field(69; "No. Printed"; Integer)
        {
        }
        field(70; "VAT Base Amount"; Decimal)
        {
        }
        field(71; "Exchange Rate"; Decimal)
        {
        }
        field(72; "Currency Reciprical"; Decimal)
        {
        }
        field(73; "Current Source A/C Bal."; Decimal)
        {
        }
        field(74; "Cancellation Remarks"; Text[250])
        {
        }
        field(75; "Register Number"; Integer)
        {
        }
        field(76; "From Entry No."; Integer)
        {
        }
        field(77; "To Entry No."; Integer)
        {
        }
        field(78; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(79; "Total Net Amount LCY"; Decimal)
        {
            CalcFormula = Sum("Imprest Lines"."Amount LCY" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Document Type"; Option)
        {
            OptionMembers = "Payment Voucher","Petty Cash";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(3, "Shortcut Dimension 3 Code");
                Validate("Shortcut Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name;

                UpdateHeaderToLine;
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(4, "Shortcut Dimension 4 Code");
                Validate("Shortcut Dimension 4 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name;

                UpdateHeaderToLine;
            end;
        }
        field(83; Dim3; Text[250])
        {
        }
        field(84; Dim4; Text[250])
        {
        }
        field(85; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";

            trigger OnValidate()
            begin

                TestField(Status, Status::Pending);
                /*if not UserMgt.CheckRespCenter(1, "Shortcut Dimension 3 Code") then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);*/
                /*
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(86; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            Editable = false;
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Savings,Credit';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        }
        field(87; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            Editable = true;
            TableRelation = IF ("Account Type" = CONST(Customer)) Customer;

            trigger OnValidate()
            begin
                Cust.Reset;
                if Cust.Get("Account No.") then begin
                    Cust.TestField("Gen. Bus. Posting Group");
                    Cust.TestField(Blocked, Cust.Blocked::" ");
                    Payee := Cust.Name;
                    "On Behalf Of" := Cust.Name;

                    //Check CreditLimit Here In cases where you have a credit limit set for employees
                    Cust.CalcFields(Cust."Balance (LCY)");
                    if Cust."Balance (LCY)" > Cust."Credit Limit (LCY)" then
                        Error('The allowable unaccounted balance of %1 has been exceeded', Cust."Credit Limit (LCY)");
                    //IF Cust."Balance (LCY)">0 THEN
                    //ERROR('You have to surrender first before you take another imprest');

                end;
            end;
        }
        field(88; "Surrender Status"; Option)
        {
            OptionMembers = " ",Full,Partial;
        }
        field(89; Purpose; Text[250])
        {
        }
        field(90; "Employee Job Group"; Code[10])
        {
            Editable = false;
            TableRelation = "Employee Statistics Group";
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(50000; Requisition; Code[20])
        {
            TableRelation = "Purchase Header"."No.";
        }
        field(50001; "Bal. Account No."; Code[20])
        {
            Caption = 'Payment Account';
            TableRelation = IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"."No."
                            ;

            trigger OnValidate()
            begin
                /*
                  //Savings Accounts
                  "Bal. Account Type"::Savings:
                    BEGIN
                      SavAcc.GET("Bal. Account No.");
                      SavAcc.CheckBlockedCustOnJnls(SavAcc,"Document Type",FALSE);
                      {IF savacc."IC Partner Code" <> '' THEN BEGIN
                        IF GenJnlTemplate.GET("Journal Template Name") THEN;
                        IF (savacc."IC Partner Code" <> '') AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
                          ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
                          "IC Partner Code" := savacc."IC Partner Code";
                        END;
                      END;
                      }
                      IF "Account No." = '' THEN
                        Description := SavAcc.Name;
                
                      //"Payment Method Code" := savacc."Payment Method Code";
                      //VALIDATE("Recipient Bank Account",savacc."Preferred Bank Account");
                      "Posting Group" := SavAcc."Customer Posting Group";
                      "Salespers./Purch. Code" := SavAcc."Recruited By";
                     // "Payment Terms Code" := savacc."Payment Terms Code";
                      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
                      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
                      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
                        "Currency Code" := SavAcc."Currency Code";
                      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
                        "Currency Code" := SavAcc."Currency Code";
                      ClearBalancePostingGroups;
                      //IF (savacc."Bill-to Customer No." <> '') AND (savacc."Bill-to Customer No." <> "Bal. Account No.") THEN
                        //IF NOT CONFIRM(Text014,FALSE,savacc.TABLECAPTION,savacc."No.",savacc.FIELDCAPTION("Bill-to Customer No."),
                            // savacc."Bill-to Customer No.")
                       // THEN
                        //  ERROR('');
                      VALIDATE("Payment Terms Code");
                      CheckPaymentTolerance;
                    END;
                
                   "Bal. Account Type"::Credit:
                    BEGIN
                    CrAcc.GET("Bal. Account No.");
                      CrAcc.CheckBlockedCustOnJnls(CrAcc,"Document Type",FALSE);
                      {IF savacc."IC Partner Code" <> '' THEN BEGIN
                        IF GenJnlTemplate.GET("Journal Template Name") THEN;
                        IF (crAcc."IC Partner Code" <> '') AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
                          ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
                          "IC Partner Code" := crAcc."IC Partner Code";
                        END;
                      END;
                      }
                      IF "Account No." = '' THEN
                        Description := CrAcc.Name;
                
                      //"Payment Method Code" := savacc."Payment Method Code";
                      //VALIDATE("Recipient Bank Account",savacc."Preferred Bank Account");
                      "Posting Group" := CrAcc."Customer Posting Group";
                      "Salespers./Purch. Code" := CrAcc."Recruited By";
                     // "Payment Terms Code" := crAcc."Payment Terms Code";
                      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
                      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
                      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
                        "Currency Code":= CrAcc."Currency Code";
                      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
                        "Currency Code" := CrAcc."Currency Code";
                      ClearBalancePostingGroups;
                      //IF (savacc."Bill-to Customer No." <> '') AND (savacc."Bill-to Customer No." <> "Bal. Account No.") THEN
                        //IF NOT CONFIRM(Text014,FALSE,savacc.TABLECAPTION,savacc."No.",savacc.FIELDCAPTION("Bill-to Customer No."),
                            // savacc."Bill-to Customer No.")
                       // THEN
                        //  ERROR('');
                      VALIDATE("Payment Terms Code");
                      CheckPaymentTolerance;
                    END;
                */

            end;
        }
        field(50002; "Bal. Account Type"; Option)
        {
            Caption = 'Payment Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;

            trigger OnValidate()
            begin
                /**"Bal. Account No.":='';
                if UserSetup.Get(UserId)then begin

                    if "Bal. Account Type"="Bal. Account Type"::Employee then begin
                        UserSetup.TestField("Member No.");

                        Savings.Reset;
                        Savings.SetRange("Member No.",UserSetup."Member No.");
                        Savings.SetRange("Product Type",'STAFF');
                        if Savings.FindFirst then begin
                            "Bal. Account No.":=Savings."No.";
                            Payee:=Savings.Name;
                            "On Behalf Of":=Savings.Name;
                            "Member No.":=UserSetup."Member No.";
                        end
                        else
                        Error('Staff does not have a Staff Savings Account');
                    end;

                    Validate("Bal. Account No.");
                end
                else Error('User must be setup under UserSetup Other Advance Staff Account and their respective Account Entered');**/
            end;
        }
        field(50003; "Member No."; Code[20])
        {
        }
        field(50004; "Visitation No"; Code[20])
        {
            TableRelation = "Member Visitation";
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

    trigger OnDelete()
    begin
        if (Status = Status::Approved) or (Status = Status::Posted) or (Status = Status::"Pending Approval") then
            Error('You Cannot Delete this record its status is not Pending');
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GenLedgerSetup.Get;
            if "Payment Type" = "Payment Type"::Imprest then begin
                GenLedgerSetup.TestField(GenLedgerSetup."Imprest Req No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Imprest Req No", xRec."No. Series", 0D, "No.", "No. Series");
            end
        end;

        if GuiAllowed then begin
            UserTemplate.Reset;
            UserTemplate.SetRange(UserTemplate.UserID, UserId);
            if UserTemplate.FindFirst then begin
                //"Paying Bank Account":=UserTemplate."Default Payment Bank";
                //VALIDATE("Paying Bank Account");
            end;

            if "Payment Type" = "Payment Type"::Imprest then begin

                //"Paying Bank Account":='1';
                BankAcc.Reset;
                if BankAcc.Get("Paying Bank Account") then begin
                    "Bank Name" := BankAcc.Name;
                end;

            end;

            Date := Today;
            Cashier := UserId;
            Validate(Cashier);

            UserSetup.Reset;
            UserSetup.SetRange("User ID", UserId);
            if UserSetup.Find('-') then
                // "Responsibility Center" := UserSetup."Responsibility Centre";
                //"Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";

                //
                if UserSetup.Get(UserId) then begin
                    //UserSetup.TestField(UserSetup."Imprest Account");
                    "Account Type" := "Account Type"::Customer;
                    //"Account No." := UserSetup."Imprest Account";
                    Validate("Account No.");
                end else
                    Error('User must be setup under User Setup and their respective Account Entered');



            if UserSetup.Get(UserId) then begin


                // UserSetup.TestField(UserSetup."Imprest Account");
                "Account Type" := "Account Type"::Customer;
                //"Account No." := UserSetup."Imprest Account";
                Validate("Account No.");

                //"Member No." := UserSetup."Member No.";

                // UserSetup.TestField("Member No.");
                "Bal. Account Type" := "Bal. Account Type"::Employee;

                //    Savings.RESET;
                //    Savings.SETRANGE("Member No.",UserSetup."Member No.");
                //    Savings.SETRANGE("Product Type",'STAFF');
                //    IF Savings.FINDFIRST THEN
                //    "Bal. Account No.":=Savings."No."
                //    ELSE
                //    ERROR('Staff does not have a Staff Savings Account');
                //    VALIDATE("Account No.");
            end
            else
                Error('User must be setup under UserSetup Other Advance Staff Account and their respective Account Entered');
            //InsertRecID;
        end;
    end;

    trigger OnModify()
    begin
        if Status = Status::Pending then
            UpdateHeaderToLine;

        /*IF (Status=Status::Approved) OR (Status=Status::Posted)OR (Status=Status::"Pending Approval") THEN
              ERROR('You Cannot Modify this record its status is not Pending'); */

    end;

    var
        CStatus: Code[20];
        //PVUsers: Record "W/P Budget Buffer";
        UserTemplate: Record "Cash Office User Template";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
        SingleMonth: Boolean;
        DateFrom: Date;
        DateTo: Date;
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        BudgetDate: Date;
        YrBudget: Decimal;
        BudgetDateTo: Date;
        BudgetAvailable: Decimal;
        GenLedSetup: Record "General Ledger Setup";
        "Total Budget": Decimal;
        CommittedAmount: Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        TotAmt: Decimal;
        DimVal: Record "Dimension Value";
        RespCenter: Record "Responsibility CenterBR";
        //UserMgt: Codeunit "User Setup Management BR";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        Pline: Record "Imprest Lines";
        CurrExchRate: Record "Currency Exchange Rate";
        ImpLines: Record "Imprest Lines";
        UserSetup: Record "User Setup";
        DImMgt: Codeunit DimensionManagement;
    // Savings: Record "Savings Accounts";

    /// <summary>
    /// UpdateHeaderToLine.
    /// </summary>
    procedure UpdateHeaderToLine()
    var
        PayLine: Record "Imprest Lines";
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.No, "No.");
        if PayLine.Find('-') then begin
            repeat
                PayLine."Imprest Holder" := "Account No.";
                PayLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                PayLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                PayLine."Dimension Set ID" := "Dimension Set ID";
                PayLine."Currency Code" := "Currency Code";
                PayLine."Currency Factor" := "Currency Factor";
                PayLine.Validate("Currency Factor");
                PayLine.Modify;
            until PayLine.Next = 0;
        end;
    end;

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        if "Currency Code" <> '' then begin
            CurrencyDate := Date;
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    /// <summary>
    /// ImpLinesExist.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure ImpLinesExist(): Boolean
    begin
        ImpLines.Reset;
        ImpLines.SetRange(No, "No.");
        exit(ImpLines.FindFirst);
    end;

    /// <summary>
    /// ShowDimensions.
    /// </summary>
    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DImMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Imprest', "No."));
        //VerifyItemLineDim;
        DImMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    /// <summary>
    /// ValidateShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DImMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    /// <summary>
    /// LookupShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DImMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    /// <summary>
    /// ShowShortcutDimCode.
    /// </summary>
    /// <param name="ShortcutDimCode">VAR array[8] of Code[20].</param>
    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DImMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

