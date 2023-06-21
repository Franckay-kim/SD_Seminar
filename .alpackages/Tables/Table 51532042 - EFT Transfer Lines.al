table 51532042 "EFT Transfer Lines"
{

    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                    SeriesSetup.Get();
                    NoSeriesMgt.TestManual(SeriesSetup."EFT Line Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Document No."; Code[10])
        {
            TableRelation = "EFT Transfer Header"."No.";
        }
        field(3; "Entered By"; Code[50])
        {
        }
        field(5; "Account Type"; Enum "Gen. Journal Account Type")
        {
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(6; "Account No."; Code[20])
        {
            /* TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
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
            ELSE
            IF ("Account Type" = CONST(Savings)) "Savings Accounts" where("Product Category" = filter(Prime))
            ELSE
            IF ("Account Type" = CONST(Credit)) "Credit Accounts"; */

            trigger OnValidate()
            var
                SAccounts: Record "Savings Accounts";
                BankAcc: Record "Bank Account";
                BankCodeStructure: Record "Bank Code Structure";
            begin
                /* case "Account Type" of
                     "Account Type"::Savings:
                         begin
                             if SAccounts.Get("Account No.") then
                                 "Account Name" := SAccounts.Name;
                             "Member No." := SAccounts."Member No.";
                             "External Account Name" := SAccounts.Name;

                             //getCharges;
                         end;

                     "Account Type"::"Bank Account":
                         begin
                             if BankAcc.Get("Account No.") then begin
                                 "Account Name" := BankAcc.Name;
                                 "Bank Code" := BankAcc."Bank No.";
                                 BankCodeStructure.Reset;
                                 BankCodeStructure.SetRange(BankCodeStructure."Branch Code", "Bank Code");
                                 if BankCodeStructure.Find('-') then
                                     "Bank Name" := BankCodeStructure."Bank Name";
                                 "Branch Code" := BankAcc."Bank Branch No.";
                             end;

                         end;
                 end; */

                if "Standing Order No" = '' then begin
                    if Amount <> 0 then begin
                        //Amount:=0;
                        //"Charge Amount":=0;
                        //MODIFY;
                    end;
                end;
            end;
        }
        field(7; "Account Name"; Text[100])
        {
            Editable = false;
        }
        field(8; "Member No."; Code[20])
        {
            Editable = false;
        }
        field(9; "External Account Name"; Text[100])
        {

            trigger OnValidate()
            begin
                if StrLen("External Account Name") > 28 then
                    Error('Destnation account name IS %1 more than 28 characters.', "Member No.");
            end;
        }
        field(10; "Charge Amount"; Decimal)
        {
            Editable = false;
        }
        field(12; "Don't Charge"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Don't Charge" then
                    "Charge Amount" := 0
                else
                    getCharges;
            end;
        }
        field(14; "Phone No."; Code[13])
        {
        }
        field(15; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if Amount < 0 then
                    Error(LessThanZeroAmount);


                getCharges;
            end;
        }
        field(16; "Amount Text"; Text[250])
        {
        }
        field(17; "Bank Code"; Code[10])
        {
            TableRelation = "Bank Code Structure";

            trigger OnValidate()
            begin
                //*
                BankCodes.Reset;
                BankCodes.SetRange(BankCodes."Bank Code", "Bank Code");
                if BankCodes.Find('-') then
                    "Bank Name" := BankCodes."Bank Name";
                //VALIDATE("Branch Code",BankCodes."Branch Code");
            end;
        }
        field(18; "Branch Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Branch Code";

            trigger OnValidate()
            begin
                BankCodes.Reset;
                BankCodes.SetRange(BankCodes."Branch Code", "Branch Code");
                if BankCodes.Find('-') then begin
                    "Bank Code" := BankCodes."Bank Code";
                    "Bank Name" := BankCodes."Bank Name" + ' ' + BankCodes.Branch;
                    //"Branch Name":=BankCodes.Branch;
                end;
            end;
        }
        field(19; "Bank Name"; Text[100])
        {
            Editable = false;
        }
        field(20; "Over Drawn"; Boolean)
        {
        }
        field(21; "Standing Order No"; Code[20])
        {
        }
        field(22; "Standing Order Register No"; Code[20])
        {
        }
        field(23; "Not Available"; Boolean)
        {
        }
        field(24; "Charge Account"; Code[20])
        {
            Editable = false;
        }
        field(25; Transferred; Boolean)
        {
        }
        field(26; ExportFormat; Text[78])
        {
        }
        field(27; "External Account No."; Text[30])
        {

            trigger OnValidate()
            begin
                if StrLen("External Account No.") > 14 then
                    Error('Destnation account no %1 more than 14 characters.', "Member No.");
            end;
        }
        field(28; "Multiple Accounts"; Boolean)
        {
            Editable = false;
        }
        field(29; "No. Series"; Code[20])
        {
        }
        field(30; "Excise Duty"; Decimal)
        {

            trigger OnValidate()
            begin
                GeneralSetUp.Get();
                TCharges := 0;
                if EFTHeader.Get("Document No.") then begin
                    TransactionCharges.Reset;
                    TransactionCharges.SetRange(TransactionCharges."Transaction Type", EFTHeader."Transaction Type");
                    if TransactionCharges.Find('-') then begin
                        repeat
                            ChargeAmount := 0;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then begin
                                if TransactionCharges."Recover Excise Duty" = false then
                                    "Charge Amount" := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                                else
                                    "Charge Amount" := ((Amount * TransactionCharges."Percentage of Amount") * 0.01) + (0.01 * ((Amount * TransactionCharges."Percentage of Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                            end
                            else begin
                                if TransactionCharges."Recover Excise Duty" = false then
                                    "Charge Amount" := TransactionCharges."Charge Amount" else
                                    "Charge Amount" := (TransactionCharges."Charge Amount") + (TransactionCharges."Charge Amount" * (GeneralSetUp."Excise Duty (%)" * 0.01));
                            end;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" then begin
                                                if TransactionCharges."Recover Excise Duty" = false then
                                                    "Charge Amount" := Amount * TariffDetails.Percentage * 0.01 else
                                                    "Charge Amount" := ((Amount * TariffDetails.Percentage * 0.01) + ((Amount * TariffDetails.Percentage * 0.01) * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                                            end else begin
                                                if TransactionCharges."Recover Excise Duty" = false then
                                                    "Charge Amount" := TariffDetails."Charge Amount" else
                                                    "Charge Amount" := ((TariffDetails."Charge Amount") + ((TariffDetails."Charge Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                                            end;
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;
                            TChargeAmount += "Charge Amount";
                        until TransactionCharges.Next = 0;
                    end;
                    TCharges += TChargeAmount;


                    "Excise Duty" := TCharges;
                end;
            end;
        }
        field(45; "Bankers Cheque No"; Code[6])
        {
            TableRelation = "Bankers Cheques Register"."Cheque No." WHERE(Status = FILTER(Pending),
                                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code"),
                                                                           "Bankers Cheque Type" = FIELD("Bankers Cheque Type"));
        }
        field(46; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(47; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50022; "Bankers Cheque Type"; Option)
        {
            OptionCaption = 'Co-op Bankers Cheque,Customer Service Cheques';
            OptionMembers = "Co-op Bankers Cheque","Customer Service Cheques";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Account No.", "External Account No.", No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CashierTransactions.Reset;
        CashierTransactions.SetRange("Account No", "Account No.");
        CashierTransactions.SetRange(Amount, (Amount + "Charge Amount"));
        CashierTransactions.SetRange(Remarks, 'EFT Amount');
        CashierTransactions.SetRange(Payee, "Document No.");
        CashierTransactions.SetRange("Cheque Status", CashierTransactions."Cheque Status"::Pending);
        if CashierTransactions.Find('-') then begin
            repeat
                CashierTransactions.Amount := 0;
                CashierTransactions.Modify;
            until CashierTransactions.Next = 0;
        end;
        /*
        //CashierTransactions.RESET;
         CashierTransactions.RESET;
         CashierTransactions.SETRANGE("Account No","Account No.");
         CashierTransactions.SETRANGE(Amount,(Amount+"Charge Amount"));
         CashierTransactions.SETRANGE(Remarks,'EFT Amount');
                      IF CashierTransactions.FIND('-')
                        THEN
                        BEGIN
                          REPEAT
                          //ERROR('here');
                          CashierTransactions."Cheque Status":=CashierTransactions."Cheque Status"::Honoured;
                          CashierTransactions.MODIFY;
                          UNTIL CashierTransactions.NEXT=0;
                        END
                        */

    end;

    trigger OnInsert()
    begin

        if No = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."EFT Line Nos");
            NoSeriesMgt.InitSeries(SeriesSetup."EFT Line Nos", xRec."No. Series", 0D, No, "No. Series");
        end;

        "Entered By" := UserId;
    end;

    trigger OnModify()
    begin
        /*CashierTransactions.RESET;
         CashierTransactions.SETRANGE("Account No","Account No.");
         CashierTransactions.SETRANGE(Amount,(Amount+"Charge Amount"));
         CashierTransactions.SETRANGE(Remarks,'EFT Amount');
         CashierTransactions.SETRANGE(Payee,"Document No.");
         CashierTransactions.SETRANGE("Cheque Status",CashierTransactions."Cheque Status"::Pending);
         IF CashierTransactions.FIND('-') THEN
          BEGIN
            REPEAT
              IF xRec."Account No."<>"Account No." THEN
            CashierTransactions.Amount:=0;
            CashierTransactions.MODIFY;
              UNTIL CashierTransactions.NEXT=0;
            END;
        // IF xRec."Account No."<>"Account No." THEN
        //  BEGIN
        //  Amount:=0;
        // "Charge Amount":=0;
        // MODIFY;
        // END;
        */

    end;

    var
        SeriesSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BankCodes: Record "Bank Code Structure";
        TransType: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charges";
        TariffDetails: Record "Tiered Charges Lines";
        TCharges: Decimal;
        ChargeAmount: Decimal;
        TChargeAmount: Decimal;
        EFTHeader: Record "EFT Transfer Header";
        SAccount: Record "Savings Accounts";
        AvailableBal: Decimal;
        LessThanZeroAmount: Label 'Amount cannot be less than zero (0)';
        CashierTransactions: Record "Cashier Transactions";
        GeneralSetUp: Record "General Set-Up";

    procedure getCharges()
    var
        Text001: Label 'Account %1 has insufficient funds to enable successful transaction.';
    begin
        GeneralSetUp.Get();
        TCharges := 0;
        if EFTHeader.Get("Document No.") then begin
            TransactionCharges.Reset;
            TransactionCharges.SetRange(TransactionCharges."Transaction Type", EFTHeader."Transaction Type");
            if TransactionCharges.Find('-') then begin
                repeat
                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then begin
                        if TransactionCharges."Recover Excise Duty" = false then
                            "Charge Amount" := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                        else begin
                            "Charge Amount" := ((Amount * TransactionCharges."Percentage of Amount") * 0.01) + (0.01 * ((Amount * TransactionCharges."Percentage of Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                            "Excise Duty" := (0.01 * ((Amount * TransactionCharges."Percentage of Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                        end;
                    end
                    else begin
                        if TransactionCharges."Recover Excise Duty" = false then
                            "Charge Amount" := TransactionCharges."Charge Amount" else begin
                            "Charge Amount" := (TransactionCharges."Charge Amount") + (TransactionCharges."Charge Amount" * (GeneralSetUp."Excise Duty (%)" * 0.01));
                            "Excise Duty" := (TransactionCharges."Charge Amount" * (GeneralSetUp."Excise Duty (%)" * 0.01));

                        end;
                    end;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" then begin
                                        if TransactionCharges."Recover Excise Duty" = false then
                                            "Charge Amount" := Amount * TariffDetails.Percentage * 0.01 else begin
                                            "Charge Amount" := ((Amount * TariffDetails.Percentage * 0.01) + ((Amount * TariffDetails.Percentage * 0.01) * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                                            "Excise Duty" := ((Amount * TariffDetails.Percentage * 0.01) * (GeneralSetUp."Excise Duty (%)" * 0.01));

                                        end;
                                    end else begin
                                        if TransactionCharges."Recover Excise Duty" = false then
                                            "Charge Amount" := TariffDetails."Charge Amount" else begin
                                            "Charge Amount" := ((TariffDetails."Charge Amount") + ((TariffDetails."Charge Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01)));
                                            "Excise Duty" := ((TariffDetails."Charge Amount") * (GeneralSetUp."Excise Duty (%)" * 0.01));
                                        end;
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;
                    TChargeAmount += "Charge Amount";
                until TransactionCharges.Next = 0;
            end;
            TCharges += TChargeAmount;


            "Charge Amount" := TCharges;

            if SAccount.Get("Account No.") then begin
                SAccount.CalcFields(SAccount."Balance (LCY)");
                AvailableBal := SAccount."Balance (LCY)" - (SAccount."Monthly Contribution" + "Charge Amount");
                if "Standing Order No" = '' then begin
                    if AvailableBal < Amount then
                        Error(Text001, "Account No." + ' :-' + "Account Name");
                end;
                //   MESSAGE('T charges %1 and %2',TChargeAmount,ChargeAmount);
                CashierTransactions.Reset;
                CashierTransactions.SetRange("Account No", "Account No.");
                CashierTransactions.SetRange(Amount, (Amount + "Charge Amount"));
                CashierTransactions.SetRange(Remarks, 'EFT Amount');
                CashierTransactions.SetRange("Cheque Status", CashierTransactions."Cheque Status"::Pending);
                if CashierTransactions.Find('-') then begin
                    CashierTransactions.Delete;
                end;
                CashierTransactions.Init;
                CashierTransactions.No := '';
                CashierTransactions."Account No" := "Account No.";
                CashierTransactions."Account Name" := "Account Name";
                CashierTransactions."Available Balance" := AvailableBal;
                CashierTransactions."Global Dimension 1 Code" := EFTHeader."Shortcut Dimension 1 Code";
                CashierTransactions."Global Dimension 2 Code" := EFTHeader."Shortcut Dimension 2 Code";
                CashierTransactions."ID No" := SAccount."ID No.";
                CashierTransactions."Responsibility Center" := EFTHeader."Responsibility Centre";
                CashierTransactions.Amount := Amount + "Charge Amount";
                CashierTransactions.Cashier := UserId;
                CashierTransactions.Remarks := 'EFT Amount';
                CashierTransactions.Payee := "Document No.";
                CashierTransactions.Posted := true;
                CashierTransactions."Transaction Description" := EFTHeader."No.";
                CashierTransactions.Type := CashierTransactions.Type::Lien;
                CashierTransactions.Insert(true);
            end;
        end;
    end;
}

