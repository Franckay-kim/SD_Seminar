table 51532216 "Payments Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the reference of the payment voucher in the database';
            NotBlank = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    GenLedgerSetup.Get;
                    NoSeriesMgt.TestManual(GenLedgerSetup."Normal Payments No");
                    "No. Series" := '';



                end;
            end;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the payment voucher was inserted into the system';

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    //ERROR('You first need to delete the existing Payment lines before changing the Currency Code');
                end else begin
                    //"Paying Bank Account":='';
                    Validate("Paying Bank Account");
                end;
                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                //Update Payment Lines
                UpdateLines();
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
            Enabled = true;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Payment lines before changing the Currency Code'
                    );
                end else begin
                    //"Paying Bank Account":='';
                    Validate("Paying Bank Account");
                end;
                if "Currency Code" = xRec."Currency Code" then
                    UpdateCurrencyFactor;

                if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                end else
                    if "Currency Code" <> '' then
                        UpdateCurrencyFactor;

                //Update Payment Lines
                UpdateLines();
            end;
        }
        field(9; Payee; Text[100])
        {
            //TableRelation = Ven
            Description = 'Stores the name of the person who received the money';
        }
        field(10; "On Behalf Of"; Text[100])
        {
            Description = 'Stores the name of the person on whose behalf the payment voucher was taken';
        }
        field(11; Cashier; Code[80])
        {
            Description = 'Stores the identifier of the cashier in the database';
            Editable = false;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                /*
                 UserDept.RESET;
                UserDept.SETRANGE(UserDept.UserID,Cashier);
                IF UserDept.FIND('-') THEN
                  //"Global Dimension 1 Code":=UserDept.Department;
                */

            end;
        }
        field(16; Posted; Boolean)
        {
            Description = 'Stores whether the payment voucher is posted or not';
        }
        field(17; "Date Posted"; Date)
        {
            Description = 'Stores the date when the payment voucher was posted';
            Editable = false;
        }
        field(18; "Time Posted"; Time)
        {
            Description = 'Stores the time when the payment voucher was posted';
            Editable = false;
        }
        field(19; "Posted By"; Code[80])
        {
            Description = 'Stores the name of the person who posted the payment voucher';
            Editable = false;
            TableRelation = "User Setup"."User ID";
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
            Editable = true;
            TableRelation = IF ("Payment Type" = FILTER(<> "Petty Cash"),
                                "Paying Account Type" = CONST("Bank Account"),
                                "Pay Mode" = CONST(Cheque)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"))

            ELSE
            //IF ("Payment Type" = CONST("Petty Cash"), "Paying Account Type" = CONST("Bank Account")) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"),
            //                                                                                                                                                           "Bank Type" = FILTER(Cashier | Cash))

            //ELSE
            IF ("Paying Account Type" = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Payment Type" = FILTER(<> "Petty Cash"), "Paying Account Type" = CONST("Bank Account"), "Pay Mode" = CONST(Cash)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"));
            //ELSE
            //IF ("Payment Type" = FILTER(<> "Petty Cash"), "Paying Account Type" = CONST("Bank Account"), "Pay Mode" = CONST(EFT)) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"), "Bank Type" = FILTER(Cashier));

            trigger OnValidate()
            begin

                BankAcc.Reset;
                "Bank Name" := '';
                if BankAcc.Get("Paying Bank Account") then begin
                    if "Pay Mode" = "Pay Mode"::Cash then begin
                        //if not (BankAcc."Bank Type" in [BankAcc."Bank Type"::Cash, BankAcc."Bank Type"::Cashier]) then Error(Error001);
                    end;

                    "Bank Name" := BankAcc.Name;
                end;

                GL.Reset;
                GL.SetRange("No.", "Paying Bank Account");
                if GL.Find('-') then
                    "Bank Name" := GL.Name;

                PLine.Reset;
                PLine.SetRange(PLine.No, "No.");
                PLine.SetRange(PLine."Account Type", PLine."Account Type"::"Bank Account");
                PLine.SetRange(PLine."Account No.", "Paying Bank Account");
                if PLine.FindFirst then
                    Error(Text002);
            end;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;
                UpdateLines;

                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(35; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            OptionCaption = 'Open,1st Approval,2nd Approval,Cheque Printing,Posted,Cancelled,Checking,VoteBook,Pending Approval,Approved';
            OptionMembers = Open,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
        }
        field(38; "Payment Type"; Option)
        {
            OptionCaption = 'Normal,Petty Cash,Express,Cash Purchase,Benevolent Claim';
            OptionMembers = Normal,"Petty Cash",Express,"Cash Purchase","Benevolent Claim";
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;
                UpdateLines;
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
            CalcFormula = Sum("Payment Line"."Net Amount" WHERE(No = FIELD("No.")));
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
                    Error('You CANNOT insert cheque No. If the Pay Mode is Cash');
                end;
            end;
        }
        field(67; "Pay Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,EFT,Letter of Credit,Mpesa,Custom 4,Custom 5,Fosa Account';
            OptionMembers = " ",Cash,Cheque,EFT,"Letter of Credit",Mpesa,"Custom 4","Custom 5","Fosa Account";

            trigger OnValidate()
            begin
                case "Pay Mode" of
                    "Pay Mode"::"Custom 4":
                        begin
                            "Account Type" := "Account Type"::Savings;

                        end;
                    "Pay Mode"::Cheque:
                        begin
                            "Account Type" := "Account Type"::"Bank Account";
                        end;
                end;
            end;
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
        field(79; "Total Payment Amount LCY"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."NetAmount LCY" WHERE(No = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80; "Document Type"; Option)
        {
            OptionMembers = "Payment Voucher","Petty Cash","Cash Purchase";
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
                    Dim4 := DimVal.Name
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

                TestField(Status, Status::Open);

                if PayLinesExist then begin
                    Error('You first need to delete the existing Payment lines before changing the Responsibility Center');
                end else begin
                    //"Currency Code":='';
                    //VALIDATE("Currency Code");
                    //"Paying Bank Account":='';
                    //VALIDATE("Paying Bank Account");
                end;

                /*if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
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
        field(86; "Cheque Type"; Option)
        {
            OptionMembers = " ","Computer Check","Manual Check";
        }
        field(87; "Total Retention Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."Retention  Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(88; "Payment Narration"; Text[50])
        {
        }
        field(100; "Invoice No"; Code[20])
        {
            Description = 'Holds The Purchase invoice number if it is related to purch invoice, does not post';
        }
        field(105; "Creation Doc No."; Code[20])
        {
        }
        field(106; "Creation Doc Type"; Option)
        {
            OptionCaption = 'Advance,Claim,Payment Request,Investment';
            OptionMembers = Advance,Claim,"Payment Request",Investment;
        }
        field(150; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(151; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false),
                                                                                          "Direct Posting" = CONST(true))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
                                                                                          ;

            trigger OnValidate()
            begin

                /**case "Pay Mode" of
                  "Pay Mode"::"Custom 4":
                    begin

                      if AccountF.Get("Account No.") then begin
                        "Bank Name":=AccountF.Name;
                        end;
                        end;
                      "Pay Mode"::Cheque:
                      begin
                      if AccountB.Get("Account No.") then begin
                        "Bank Name":=AccountB.Name;
                      end;
                      end;
                  end;

                 if "Payment Type"="Payment Type"::"Benevolent Claim" then begin
                        if AccountF.Get("Account No.") then begin
                        "Bank Name":=AccountF.Name;
                        end;
                        if AccountB.Get("Account No.") then begin
                        "Bank Name":=AccountB.Name;
                        end;
                  end;**/
            end;
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
        field(481; "External Doc No"; Code[20])
        {
        }
        field(50000; "VAT Wthheld six %"; Decimal)
        {
        }
        field(50001; "Member No."; Code[80])
        {
            TableRelation = Members."No.";

            trigger OnValidate()
            begin

            end;
        }
        field(50002; Name; Text[100])
        {
            Editable = false;
        }
        field(50003; "Total Payment Amount BBF"; Decimal)
        {
            CalcFormula = Sum("BBF Claim Lines"."BBF Entitlement Paid" WHERE("Line No." = FIELD("No.")));
            Description = 'Stores the amount of the payment voucher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Total VAT Withholding Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line"."VAT Withholding Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Requisation Doc No."; Code[20])
        {
            TableRelation = "BBF Requisation Header" WHERE(Status = FILTER(Approved),
                                                            Payed = FILTER(false),
                                                            "Member No" = FIELD("Member No."));

            trigger OnValidate()
            var
                LineNo: Integer;
            begin
                BBFClaimLines.Reset;
                BBFClaimLines.SetRange("Line No.", "No.");
                if BBFClaimLines.Find('-') then
                    BBFClaimLines.DeleteAll;

                BBFClaimLines.Reset();
                if BBFClaimLines.FindLast() then LineNo := BBFClaimLines."Entry No.";

                BBFRequisationLines.Reset;
                BBFRequisationLines.SetRange("Header No", "Requisation Doc No.");
                if BBFRequisationLines.Find('-') then begin
                    repeat
                        LineNo += 1;

                        BBFClaimLines.Init;
                        BBFClaimLines."Entry No." := LineNo;
                        BBFClaimLines."Line No." := "No.";
                        BBFClaimLines."Requisation No." := BBFRequisationLines."Header No";
                        BBFClaimLines."Account No" := BBFRequisationLines."Account No.";
                        BBFClaimLines."Member No" := BBFRequisationLines."Member No";
                        BBFClaimLines."%Allocation" := BBFRequisationLines."%Allocation";
                        BBFClaimLines."BBF Entitlement Claimed" := BBFRequisationLines."Sacco Amount";
                        BBFClaimLines."BBF Entitlement Code" := BBFRequisationLines."BBF Entitlement Code";
                        BBFClaimLines.Beneficiary := BBFRequisationLines.Beneficiary;
                        BBFClaimLines."Date of Birth" := BBFRequisationLines."Date of Birth";
                        BBFClaimLines.Deceased := BBFRequisationLines.Deceased;
                        BBFClaimLines.Email := BBFRequisationLines.Email;
                        BBFClaimLines."Loan No." := BBFRequisationLines."Loan No.";
                        BBFClaimLines."Transaction Type" := BBFRequisationLines."Transaction Type";
                        BBFClaimLines.Name := BBFRequisationLines.Name;
                        BBFClaimLines."Next of Kin" := BBFRequisationLines."Next of Kin";
                        BBFClaimLines."ID No." := BBFRequisationLines."ID No.";
                        BBFClaimLines.Relationship := BBFRequisationLines.Relationship;
                        BBFClaimLines.Type := BBFRequisationLines.Type;
                        BBFClaimLines.Telephone := BBFRequisationLines.Telephone;
                        BBFClaimLines.Insert;
                    until BBFRequisationLines.Next = 0;
                end;
            end;
        }
        field(50006; "Paying Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;

            trigger OnValidate()
            begin
                /*CASE "Account Type" OF
                  "Account Type"::"G/L Account": BEGIN
                    GLEntry.GET("Paying Bank Account");
                    IF GLEntry.FIND('-') THEN
                      "Paying Bank Account" := GLEntry."G/L Account No.";
                      "Bank Name" := GLEntry.Description;
                  END;
                END;*/

            end;
        }
        field(50007; "Petty Cash Type"; Option)
        {
            OptionMembers = Normal,Teller;
            OptionCaption = 'Normal,Teller';

        }
        field(50008; "Teller A/c"; Code[20])
        {
            //TableRelation = "Bank Account"."No." where("Bank Type" = filter(Cashier));
            trigger OnValidate()
            var
                Bank: Record "Bank Account";
            begin
                Bank.RESET;
                Bank.SetRange("No.", "Teller A/c");
                if Bank.Find('-') then begin
                    //if Bank."Cashier ID" <> UserId then
                    Error('You must use your own teller bank A/c');
                end else
                    "Teller A/c" := '';

            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Responsibility Center")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //IF (Status=Status::Approved) OR (Status=Status::Posted) OR (Status=Status::"Pending Approval")THEN
        //     ERROR('You Cannot Delete this record');
    end;

    trigger OnInsert()
    var
        UserTemp: Record "User Setup";
    begin
        //MESSAGE('%1',"Payment Type");

        if "No." = '' then begin
            GenLedgerSetup.Get;

            if "Payment Type" = "Payment Type"::Normal then begin
                GenLedgerSetup.TestField(GenLedgerSetup."Normal Payments No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Normal Payments No", xRec."No. Series", 0D, "No.", "No. Series");
                UserTemp.Get(UserId);
                //UserTemp.TestField("Responsibility Centre");
                //UserTemp.TestField("Global Dimension 1 Code");
                //UserTemp.TestField("Global Dimension 2 Code");

                //"Global Dimension 1 Code" := UserTemp."Global Dimension 1 Code";
                //"Responsibility Center" := UserTemp."Responsibility Centre";
                //"Shortcut Dimension 2 Code" := UserTemp."Global Dimension 2 Code";

            end
            else
                if "Payment Type" = "Payment Type"::Express then begin
                    GenLedgerSetup.TestField(GenLedgerSetup."Board PVs Nos.");
                    NoSeriesMgt.InitSeries(GenLedgerSetup."Board PVs Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                end
                else
                    if "Payment Type" = "Payment Type"::"Cash Purchase" then begin
                        GenLedgerSetup.TestField(GenLedgerSetup."Cash Purchases");
                        NoSeriesMgt.InitSeries(GenLedgerSetup."Cash Purchases", xRec."No. Series", 0D, "No.", "No. Series");
                    end else
                        if "Payment Type" = "Payment Type"::"Benevolent Claim" then begin
                            GenLedgerSetup.TestField("Benevolent Claim Nos");
                            NoSeriesMgt.InitSeries(GenLedgerSetup."Benevolent Claim Nos", xRec."No. Series", 0D, "No.", "No. Series");

                            UserTemp.Get(UserId);
                            //UserTemp.TestField("Responsibility Centre");
                            //UserTemp.TestField("Global Dimension 1 Code");
                            //UserTemp.TestField("Global Dimension 2 Code");

                            //"Global Dimension 1 Code" := UserTemp."Global Dimension 1 Code";
                            //"Responsibility Center" := UserTemp."Responsibility Centre";
                            //"Shortcut Dimension 2 Code" := UserTemp."Global Dimension 2 Code";
                            if "Payment Type" = "Payment Type"::"Petty Cash" then begin
                                //UserTemp.TestField("Branch Imprest Account");
                                //"Paying Bank Account":=UserTemp."Branch Imprest Account";
                            end;


                        end else begin
                            GenLedgerSetup.TestField(GenLedgerSetup."Petty Cash Payments No");
                            NoSeriesMgt.InitSeries(GenLedgerSetup."Petty Cash Payments No", xRec."No. Series", 0D, "No.", "No. Series");
                        end;

        end;
        //MESSAGE("Global Dimension 1 Code");


        UserTemplate.Reset;
        UserTemplate.SetRange(UserTemplate.UserID, UserId);
        if UserTemplate.FindFirst then begin
            if "Payment Type" = "Payment Type"::"Petty Cash" then begin
                //UserTemplate.TESTFIELD(UserTemplate."Default Petty Cash Bank");
                "Paying Bank Account" := UserTemplate."Default Petty Cash Bank";
            end else begin
                "Paying Account Type" := "Paying Account Type"::"Bank Account";
                "Paying Bank Account" := UserTemplate."Default Payment Bank";
                "Cheque Type" := "Cheque Type"::"Manual Check";
            end;

        end;

        if "Paying Bank Account" <> '' then
            Validate("Paying Bank Account");



        Date := Today;
        Validate(Date);
        Cashier := UserId;
        Validate(Cashier);


        BankAcc.Reset;
        if BankAcc.Get("Paying Bank Account") then begin
            "Bank Name" := BankAcc.Name;
        end;

        UserTemp.Get(UserId);
        //UserTemp.TestField("Responsibility Centre");
        //UserTemp.TestField("Global Dimension 1 Code");
        //UserTemp.TestField("Global Dimension 2 Code");

        //"Global Dimension 1 Code" := UserTemp."Global Dimension 1 Code";
        //"Responsibility Center" := UserTemp."Responsibility Centre";
        //"Shortcut Dimension 2 Code" := UserTemp."Global Dimension 2 Code";
    end;

    trigger OnModify()
    begin
        if Status = Status::Open then
            UpdateLines();

        /*IF (Status=Status::Approved) OR (Status=Status::Posted) THEN
           ERROR('You Cannot modify an already approved/posted document');*/

    end;

    var
        CStatus: Code[20];
        // PVUsers: Record "W/P Budget Buffer";
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
        PLine: Record "Payment Line";
        RespCenter: Record "Responsibility CenterBR";
        //UserMgt: Codeunit "User Setup Management BR";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
        CurrExchRate: Record "Currency Exchange Rate";
        PayLine: Record "Payment Line";
        Text002: Label 'There is an Account number on the  payment lines the same as Paying Bank Account you are trying to select.';
        DimMgt: Codeunit DimensionManagement;
        AccountF: Record "Savings Accounts";
        AccountB: Record "Bank Account";
        AccountM: Record Members;
        ClaimLines: Record "BBF Claim Lines";
        usersetup: Record "User Setup";
        BBFRequisationLines: Record "BBF Requisation Lines";
        BBFClaimLines: Record "BBF Claim Lines";
        Userbanking: Record "Banking User Template";
        SavAcc: Record "Savings Accounts";
        Error001: Label 'This Payment can only be made against Banks Handling Cash';
        GL: Record "G/L Account";

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

    procedure UpdateLines()
    begin
        PLine.Reset;
        PLine.SetRange(PLine.No, "No.");
        if PLine.FindFirst then begin
            repeat
                //PLine."Global Dimension 1 Code":="Global Dimension 1 Code";
                //PLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                //pLine."Shortcut Dimension 3 Code":="Shortcut Dimension 3 Code";
                PLine."Dimension Set ID" := "Dimension Set ID";
                PLine."Currency Factor" := "Currency Factor";
                PLine."Paying Bank Account" := "Paying Bank Account";
                PayLine."Payment Type" := "Payment Type";
                PLine.Validate("Currency Factor");
                PLine.Modify;
            until PLine.Next = 0;
        end;
    end;

    procedure PayLinesExist(): Boolean
    begin
        PayLine.Reset;
        PayLine.SetRange("Payment Type", "Payment Type");
        PayLine.SetRange(No, "No.");
        exit(PayLine.FindFirst);
    end;

    local procedure TestNoSeries(): Boolean
    begin
        if "Payment Type" = "Payment Type"::"Petty Cash" then
            GenLedgerSetup.TestField(GenLedgerSetup."Petty Cash Payments No")
        else
            if "Payment Type" = "Payment Type"::Express then
                GenLedgerSetup.TestField(GenLedgerSetup."Board PVs Nos.")
            else
                GenLedgerSetup.TestField(GenLedgerSetup."Normal Payments No");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    var
        NoSeriesCode: Code[20];
    begin
        if "Payment Type" = "Payment Type"::"Petty Cash" then
            NoSeriesCode := GenLedgerSetup."Petty Cash Payments No"
        else
            if "Payment Type" = "Payment Type"::Express then
                NoSeriesCode := GenLedgerSetup."Board PVs Nos."
            else
                NoSeriesCode := GenLedgerSetup."Normal Payments No";

        exit(GetNoSeriesRelCode(NoSeriesCode));
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Payments', "No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure GetNoSeriesRelCode(NoSeriesCode: Code[20]): Code[10]
    var
        GenLedgerSetup: Record "General Ledger Setup";
        RespCenter: Record "Responsibility CenterBR";
        DimMgt: Codeunit DimensionManagement;
        NoSrsRel: Record "No. Series Relationship";
    begin
        /*
        //EXIT(GetNoSeriesRelCode(NoSeriesCode));
        GenLedgerSetup.GET;
        CASE GenLedgerSetup."Base No. Series" OF
          GenLedgerSetup."Base No. Series"::"1":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Responsibility Center");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          GenLedgerSetup."Base No. Series"::"2":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Global Dimension 1 Code");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          GenLedgerSetup."Base No. Series"::"3":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 2 Code");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          GenLedgerSetup."Base No. Series"::"4":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 3 Code");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          GenLedgerSetup."Base No. Series"::"5":
           BEGIN
            NoSrsRel.RESET;
            NoSrsRel.SETRANGE(Code,NoSeriesCode);
            NoSrsRel.SETRANGE("Series Filter","Shortcut Dimension 4 Code");
            IF NoSrsRel.FINDFIRST THEN
              EXIT(NoSrsRel."Series Code")
           END;
          ELSE EXIT(NoSeriesCode);
        END;
        */

    end;
}

