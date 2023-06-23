/// <summary>
/// Table Treasury Cashier Transactions (ID 51532104).
/// </summary>
table 51532104 "Treasury Cashier Transactions"
{
    //DrillDownPageID = "Treasury Cashier List";
    //LookupPageID = "Treasury Cashier List";

    fields
    {
        field(1; No; Code[20])
        {
            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Treasury & Teller Trans Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Transaction Date"; Date)
        {
        }
        field(3; "Transaction Type"; Option)
        {
            OptionCaption = 'Issue To Teller,Return To Treasury,Issue From Bank,Return To Bank,Inter Teller Transfers,Branch Treasury Transactions,End of Day Return to Treasury,Mpesa to Teller,Interbank,Receive From Bank';
            OptionMembers = "Issue To Teller","Return To Treasury","Issue From Bank","Return To Bank","Inter Teller Transfers","Branch Treasury Transactions","End of Day Return to Treasury","Mpesa to Teller",Interbank,"Receive From Bank";

            trigger OnValidate()
            begin
                if "Transaction Type" = "Transaction Type"::"Mpesa to Teller" then begin
                    Description := Format("Transaction Type"::"Mpesa to Teller");
                    if BankingSetup.Get(UserId) then begin
                        //IF BankingSetup.Type=BankingSetup.Type::Cashier THEN BEGIN
                        //"From Account":=UPPERCASE(USERID);
                        //"From Till":=BankingSetup."Default  Bank";
                        bankacc.Reset;
                        bankacc.SetRange("No.", BankingSetup."MPesa Bank Account");
                        if bankacc.Find('-') then begin
                            "From Till" := PadStr(BankingSetup."MPesa Bank Account" + ' ' + bankacc.Name, 50);
                        end;
                        //END;
                    end;
                end;
                if "Transaction Type" = "Transaction Type"::"Issue To Teller" then begin
                    Description := IssuetoTeller;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "From Account" := UpperCase(UserId);
                            //"From Till":=BankingSetup."Default  Bank";
                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            BankAccount := BankingSetup."Default  Bank";
                            if bankacc.Get(BankAccount) then begin
                                bankacc.CalcFields(bankacc."Balance (LCY)", bankacc.Balance);
                                Balance := bankacc.Balance; //bankacc."Balance (LCY)";
                            end;
                        end;
                    end;
                    // Get Treasury
                    Treasury.Reset;
                    //Treasury.SetRange(Treasury."Shortcut Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                    Treasury.SetRange(Treasury.Type, Treasury.Type::Treasury);
                    if Treasury.Find('-') then begin
                        "From Account" := Treasury.UserID;
                        Validate("From Account");
                        // MESSAGE("From Account");
                    end;
                end;
                if "Transaction Type" = "Transaction Type"::"Return To Treasury" then begin
                    Description := ReturnToTreasury;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);
                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;
                if "Transaction Type" = "Transaction Type"::"Inter Teller Transfers" then begin
                    Description := InterTellerTrans;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);
                            //"From Till":=BankingSetup."Default  Bank";
                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;
                if "Transaction Type" = "Transaction Type"::"Issue From Bank" then begin
                    Description := IssueFromBank;
                    "From Account" := '';
                    "From Till" := '';
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "To Account" := UpperCase(UserId);
                            //"To Till":=BankingSetup."Default  Bank";
                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "To Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;
                if "Transaction Type" = "Transaction Type"::"Return To Bank" then begin
                    Description := ReturnToBank;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "From Account" := UpperCase(UserId);
                            //"From Till":=BankingSetup."Default  Bank";
                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;
                if "Transaction Type" = "Transaction Type"::"Branch Treasury Transactions" then begin
                    Description := BranchTreas;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "From Account" := UpperCase(UserId);
                            //"From Till":=BankingSetup."Default  Bank";
                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                end;
                if "Transaction Type" = "Transaction Type"::"End of Day Return to Treasury" then begin
                    Description := EndOfDay;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);
                            //"From Till":=BankingSetup."Default  Bank";
                            bankacc.Reset;
                            bankacc.SetRange("No.", BankingSetup."Default  Bank");
                            if bankacc.Find('-') then begin
                                "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                            end;
                        end;
                    end;
                    BankAccount := '';
                    if BankingSetup.Get(UserId) then begin
                        BankAccount := BankingSetup."Default  Bank";
                        if bankacc.Get(BankAccount) then begin
                            bankacc.CalcFields(bankacc."Balance (LCY)", bankacc.Balance);
                            "Till/Treasury Balance" := bankacc.Balance; //bankacc."Balance (LCY)";
                        end;
                    end;
                end;
                // Get Treasury
                if ("Transaction Type" = "Transaction Type"::"Issue To Teller") then begin
                    UserSetup.Get(UserId);
                    //UserSetup.TestField("Global Dimension 2 Code");
                    Treasury.Reset;
                    // Treasury.SetRange(Treasury."Shortcut Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                    Treasury.SetRange(Treasury.Type, Treasury.Type::Treasury);
                    if Treasury.Find('-') then begin
                        "From Account" := Treasury.UserID;
                        //VALIDATE("From Account");
                        //MESSAGE("From Account");
                    end;
                    Description := IssuetoTeller;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "To Account" := UpperCase(UserId);
                            "To Till" := BankingSetup."Default  Bank";
                            // MESSAGE("To Account");
                        end;
                    end;
                end;
                // Get Treasury
                if ("Transaction Type" = "Transaction Type"::"Return To Treasury") then begin
                    UserSetup.Get(UserId);
                    // UserSetup.TestField("Global Dimension 2 Code");
                    Treasury.Reset;
                    //Treasury.SetRange(Treasury."Shortcut Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                    Treasury.SetRange(Treasury.Type, Treasury.Type::Treasury);
                    if Treasury.Find('-') then begin
                        "To Account" := Treasury.UserID;
                        Validate("To Account");
                        //MESSAGE("To Account");
                    end;
                    Description := IssuetoTeller;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);
                            "To Till" := BankingSetup."Default  Bank";
                            // MESSAGE("from Account");
                        end;
                    end;
                end;
                if ("Transaction Type" = "Transaction Type"::"Issue From Bank") then begin
                    UserSetup.Get(UserId);
                    //UserSetup.TestField("Global Dimension 2 Code");
                    Treasury.Reset;
                    //Treasury.SetRange(Treasury."Shortcut Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                    Treasury.SetRange(Treasury.Type, Treasury.Type::Treasury);
                    if Treasury.Find('-') then begin
                        "To Account" := Treasury.UserID;
                        Validate("To Account");
                        //MESSAGE("To Account");
                    end;
                    Description := IssuetoTeller;
                    /*
                    IF BankingSetup.GET(USERID) THEN BEGIN
                    IF BankingSetup.Type=BankingSetup.Type::Cashier THEN BEGIN
                      "From Account":='';//UPPERCASE(USERID);
                      "To Till":=BankingSetup."Default  Bank";
                     // MESSAGE("from Account");
                    END;
                    END;
                    */
                    "From Account" := '';
                    Validate("From Account");
                end;
                // Get Treasury
                if ("Transaction Type" = "Transaction Type"::"Return To Bank") then begin
                    UserSetup.Get(UserId);
                    //UserSetup.TestField("Global Dimension 2 Code");
                    Treasury.Reset;
                    //Treasury.SetRange(Treasury."Shortcut Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                    Treasury.SetRange(Treasury.Type, Treasury.Type::Treasury);
                    if Treasury.Find('-') then begin
                        "From Account" := Treasury.UserID;
                        Validate("From Account");
                        //MESSAGE("To Account");
                    end;
                    Description := IssuetoTeller;
                    /*IF BankingSetup.GET(USERID) THEN BEGIN
                    IF BankingSetup.Type=BankingSetup.Type::Cashier THEN BEGIN
                      "From Account":=UPPERCASE(USERID);
                      "To Till":=BankingSetup."Default  Bank";
                     // MESSAGE("from Account");
                    END;
                    END;
                    */
                    "To Account" := '';
                    Validate("To Account");
                end;
                //"To Account":='';
                //"To Till":='';
                // Get Treasury
                if ("Transaction Type" = "Transaction Type"::"Inter Teller Transfers") then begin
                    Description := IssuetoTeller;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);
                            "From Till" := BankingSetup."Default  Bank";
                            "To Account" := '';
                            Validate("To Account");
                            "To Till" := '';
                            // MESSAGE("from Account");
                        end;
                    end;
                end;
                // Get Treasury
                if ("Transaction Type" = "Transaction Type"::"End of Day Return to Treasury") then begin
                    UserSetup.Get(UserId);
                    // UserSetup.TestField("Global Dimension 2 Code");
                    Treasury.Reset;
                    //Treasury.SetRange(Treasury."Shortcut Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                    Treasury.SetRange(Treasury.Type, Treasury.Type::Treasury);
                    if Treasury.Find('-') then begin
                        "To Account" := Treasury.UserID;
                        Validate("To Account");
                        //MESSAGE("From Account");
                    end;
                    Description := IssuetoTeller;
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                            "From Account" := UpperCase(UserId);
                            "From Till" := BankingSetup."Default  Bank";
                            // MESSAGE("To Account");
                        end;
                    end;
                end;
                if ("Transaction Type" = "Transaction Type"::"Branch Treasury Transactions") then begin
                    Description := 'Receipt from bank';
                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "From Account" := '';
                            "From Till" := '';
                            "To Account" := BankingSetup.UserID;
                            // "To Till" := BankingSetup.
                        end;
                    end;

                end;
                if ("Transaction Type" = "Transaction Type"::"Receive From Bank") then begin
                    Description := ReceiveBank;

                    if BankingSetup.Get(UserId) then begin
                        if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                            "From Account" := '';
                            "From Till" := '';
                            "To Account" := UpperCase(UserId);
                            Validate("To Account");
                            "To Till" := BankingSetup."Default  Bank";
                            // MESSAGE("from Account");
                        end;
                    end;
                end;
                Description := Format("Transaction Type");
                CalcTillBalance();
            end;
        }
        field(4; "From Account"; Code[30])
        {
            TableRelation = IF ("Transaction Type" = FILTER("Return To Bank" | "Branch Treasury Transactions")) "Banking User Template".UserID WHERE(Type = CONST(Treasury))
            ELSE
            IF ("Transaction Type" = FILTER("End of Day Return to Treasury" | "Return To Treasury" | "Inter Teller Transfers" | "Mpesa to Teller")) "Banking User Template".UserID WHERE(Type = CONST(Cashier))
            ELSE
            IF ("Transaction Type" = FILTER("Issue From Bank")) "Bank Account"."No."
            ELSE
            IF ("Transaction Type" = FILTER("Issue To Teller")) "Banking User Template".UserID WHERE(Type = CONST(Treasury))
            ELSE
            IF ("Transaction Type" = FILTER(Interbank)) "Bank Account"."No."
            else
            if ("Transaction Type" = FILTER("Receive From Bank")) "Bank Account"."No.";

            trigger OnValidate()
            var
                Bacc: Record "Bank Account";
            begin

                if BankingSetup.Get("From Account") then begin
                    bankacc.Reset;
                    bankacc.SetRange("No.", BankingSetup."Default  Bank");
                    if bankacc.Find('-') then begin
                        "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                    end;
                    //"From Till":=BankingSetup."Default  Bank";
                    bankacc.Reset;
                    bankacc.SetRange("No.", BankingSetup."Default  Bank");
                    if bankacc.Find('-') then begin
                        "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                    end;
                    if "Transaction Type" = "Transaction Type"::"Mpesa to Teller" then begin
                        bankacc.Reset;
                        bankacc.SetRange("No.", BankingSetup."MPesa Bank Account");
                        if bankacc.Find('-') then begin
                            "From Till" := PadStr(BankingSetup."MPesa Bank Account" + ' ' + bankacc.Name, 50);
                        end;
                    end;
                end;
                Validate("To Account");
                if "Transaction Type" = "Transaction Type"::Interbank then begin
                    bankacc.Reset;
                    bankacc.SetRange("No.", "From Account");
                    if bankacc.Find('-') then begin
                        bankacc.CalcFields(Balance);
                        "From Till" := PadStr(bankacc.Name, 50);
                        "Till Balance" := bankacc.Balance;
                        "Till/Treasury Balance" := bankacc.Balance;
                    end;
                end;
                CalcTillBalance();
            end;
        }
        field(5; "To Account"; Code[30])
        {
            /*TableRelation = IF ("Transaction Type" = FILTER("Return To Treasury" | "Issue From Bank" | "Branch Treasury Transactions" | "End of Day Return to Treasury")) "Banking User Template".UserID WHERE(Type = CONST(Treasury))
            ELSE
            IF ("Transaction Type" = FILTER("Issue To Teller" | "Mpesa to Teller")) "Banking User Template".UserID WHERE(Type = CONST(Cashier))
            ELSE
            IF ("Transaction Type" = FILTER("Return To Bank")) "Bank Account"."No." WHERE("Bank Type" = CONST(Normal))
            ELSE
            IF ("Transaction Type" = FILTER("Inter Teller Transfers")) "Banking User Template".UserID WHERE(Type = CONST(Cashier), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Code"))
            ELSE
            IF ("Transaction Type" = FILTER(Interbank)) "Bank Account"."No.";*/

            trigger OnValidate()
            var
                Bacc: Record "Bank Account";
            begin
                //IF "To Account"<>'' THEN IF "To Account"="From Account" THEN
                //  ERROR('To account cannot be same as from account');

                if BankingSetup.Get("To Account") then begin
                    "To Till" := BankingSetup."Default  Bank";
                    bankacc.Reset;
                    bankacc.SetRange("No.", BankingSetup."Default  Bank");
                    if bankacc.Find('-') then begin
                        "To Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                    end;
                end;
                if "Transaction Type" = "Transaction Type"::Interbank then begin
                    bankacc.Reset;
                    bankacc.SetRange("No.", "To Account");
                    if bankacc.Find('-') then begin
                        "To Till" := PadStr(bankacc.Name, 50);
                    end;
                end;
                Description := Format("Transaction Type");
                //Description+=' - From '+"From Till"+' to '+"To Till"; PADSTR(FORMAT(Type) + '-' + Remarks,50);
                Description := PadStr(Format(Description) + '- From ' + "From Till" + ' to ' + "To Till", 100);
            end;
        }
        field(6; Description; Text[100])
        {
        }
        field(7; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                if Amount < 0 then Error('Amount must not be negative');
                if "Transaction Type" = "Transaction Type"::"End of Day Return to Treasury" then begin
                    "Excess/Shortage Amount" := (Amount - "Till/Treasury Balance");
                    if "Excess/Shortage Amount" < 0 then
                        Type := Type::Shortage
                    else
                        Type := Type::Excess;
                    "Excess/Shortage Amount" := Abs(Amount - "Till/Treasury Balance");
                end;
                /*  if Amount = 0.0 then
                        Type := Type::" "
                      else if Amount > 0 then
                        Type := Type::Excess
                      else
                        Type := Type::Shortage*/
            end;
        }
        field(8; Posted; Boolean)
        {
        }
        field(9; "Date Posted"; Date)
        {
        }
        field(10; "Time Posted"; Time)
        {
        }
        field(11; "Posted By"; Text[50])
        {
        }
        field(12; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(13; "Transaction Time"; Time)
        {
        }
        field(14; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(15; Issued; Option)
        {
            OptionMembers = No,Yes,"N/A";
        }
        field(16; "Date Issued"; Date)
        {
        }
        field(17; "Time Issued"; Time)
        {
        }
        field(18; "Issue Received"; Option)
        {
            Editable = false;
            OptionMembers = No,Yes,"N/A";
        }
        field(19; "Date Received"; Date)
        {
            Editable = false;
        }
        field(20; "Time Received"; Time)
        {
            Editable = false;
        }
        field(21; "Issued By"; Text[50])
        {
            Editable = false;
        }
        field(22; "Received By"; Text[50])
        {
            Editable = false;
        }
        field(23; Received; Option)
        {
            Editable = false;
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(24; "Denomination Total"; Decimal)
        {
            CalcFormula = Sum(Coinage."Total Amount" WHERE(No = FIELD(No)));
            FieldClass = FlowField;
        }
        field(25; "External Document No."; Code[20])
        {
        }
        field(26; "Total Cash on Treasury Coinage"; Decimal)
        {
            CalcFormula = Sum(Coinage."Total Amount" WHERE(No = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Till/Treasury Balance"; Decimal)
        {
        }
        field(28; "Excess/Shortage Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Excess/Shortage Amount" < 0 then Error('Amount must not be negative');
                if Type = Type::" " then Error('Please specify the type');
            end;
        }
        field(29; "From Account Name"; Text[50])
        {
        }
        field(30; "To Account Name"; Text[50])
        {
        }
        field(31; "Actual Cash At Hand"; Decimal)
        {
            Enabled = false;
        }
        field(32; "Responsibility Center"; Code[20])
        {
        }
        field(33; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(34; Type; Option)
        {
            OptionCaption = ' ,Excess,Shortage';
            OptionMembers = " ",Excess,Shortage;

            trigger OnValidate()
            begin
                "Excess/Shortage Amount" := 0;
            end;
        }
        field(35; "From Till"; Code[50])
        {
            Editable = false;
        }
        field(36; "To Till"; Code[50])
        {
            Editable = false;
        }
        field(37; Balance; Decimal)
        {
        }
        field(38; "Captured By"; Code[50])
        {
            Editable = false;
        }
        field(46; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(47; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(48; "Till Balance"; Decimal)
        {
            //CalcFormula = Sum("Bank Account".Amount WHERE("Cashier ID" = FIELD("Captured By")));
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE("Bank Account No." = FIELD("From Account")));
            FieldClass = FlowField;
        }
        field(49; "Last Transaction"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Min("Treasury Cashier Transactions".No WHERE("Transaction Type" = FILTER("End of Day Return to Treasury"), "To Account" = FIELD("To Account")));
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
        UserSetup.Get(UserId);
        //UserSetup.TestField("Global Dimension 2 Code");
        "Captured By" := UserId;
        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Treasury & Teller Trans Nos.");
            NoSeriesMgt.InitSeries(NoSetup."Treasury & Teller Trans Nos.", xRec."No. Series", 0D, No, "No. Series");
        end;
        if "Transaction Type" = "Transaction Type"::"Issue To Teller" then begin
            Description := IssuetoTeller;
            if BankingSetup.Get(UserId) then begin
                if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                    "From Account" := UpperCase(UserId);
                    bankacc.Reset;
                    bankacc.SetRange("No.", BankingSetup."Default  Bank");
                    if bankacc.Find('-') then begin
                        "From Till" := PadStr(BankingSetup."Default  Bank" + ' ' + bankacc.Name, 50);
                    end;
                end;
            end;
            if BankingSetup.Get(UserId) then begin
                if BankingSetup.Type = BankingSetup.Type::Treasury then begin
                    BankAccount := BankingSetup."Default  Bank";
                    if bankacc.Get(BankAccount) then begin
                        bankacc.CalcFields(bankacc."Balance (LCY)", bankacc.Balance);
                        Balance := bankacc.Balance; //bankacc."Balance (LCY)";
                    end;
                end;
            end;
            if "Transaction Type" = "Transaction Type"::"Issue To Teller" then begin
                Description := IssuetoTeller;
                if BankingSetup.Get(UserId) then begin
                    if BankingSetup.Type = BankingSetup.Type::Cashier then begin
                        "To Account" := UpperCase(UserId);
                        "To Till" := BankingSetup."Default  Bank";
                    end;
                end;
            end;
        end
        else
            if "Transaction Type" = "Transaction Type"::"Issue From Bank" then
                Description := IssueFromBank
            else
                Description := ReturnToTreasury;
        "Transaction Date" := Today;
        "Transaction Time" := Time;
        Denominations.Reset;
        TransactionCoinage.Reset;
        Denominations.Init;
        TransactionCoinage.Init;
        if Denominations.Find('-') then begin
            repeat
                TransactionCoinage.No := No;
                TransactionCoinage.Code := Denominations.Code;
                TransactionCoinage.Description := Denominations.Description;
                TransactionCoinage.Type := Denominations.Type;
                TransactionCoinage.Value := Denominations.Value;
                TransactionCoinage.Quantity := 0;
                TransactionCoinage.Insert;
            until Denominations.Next = 0;
        end;
        if "Transaction Type" = "Transaction Type"::"Issue To Teller" then begin
            // Get Treasury
            Treasury.Reset;
            //Treasury.SetRange(Treasury."Shortcut Dimension 2 Code", UserSetup."Global Dimension 2 Code");
            Treasury.SetRange(Treasury.Type, Treasury.Type::Treasury);
            if Treasury.Find('-') then begin
                "From Account" := Treasury.UserID;
                Validate("From Account");
                // MESSAGE("From Account");
            end;
        end;
        /*UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "External Document No." := No;*/
    end;

    trigger OnModify()
    begin
        if Issued = Issued::Yes then Error('you cannot modify this transaction');
        if Posted then Error('you cannot modify this transaction');
    end;

    var
        NoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Denominations: Record Denominations;
        TransactionCoinage: Record Coinage;
        IssuetoTeller: Label 'ISSUE TO TELLER';
        IssueFromBank: Label 'ISSUE FROM BANK';
        ReturnToTreasury: Label 'RETURN TO TREASURY';
        InterTellerTrans: Label 'INTER TELLER TRANSFERS';
        ReturnToBank: Label 'RETURN TO BANK';
        BranchTreas: Label 'BRANCH TREASURY TRANSACTIONS';
        EndOfDay: Label 'END OF DAY RETURN TO TREASURY';
        ReceiveBank: Label 'RECEIVE FROM BANK';
        BankingSetup: Record "Banking User Template";
        bankacc: Record "Bank Account";
        BankAccount: Code[20];
        Treasury: Record "Banking User Template";
        UserSetup: Record "User Setup";

    /// <summary>
    /// CalcTillBalance.
    /// </summary>
    procedure CalcTillBalance()
    begin
        BankingSetup.Reset();
        BankingSetup.SetRange(UserID, "From Account");
        if BankingSetup.Find('-') then begin
            bankacc.Reset();
            bankacc.SetRange("No.", BankingSetup."Default  Bank");
            if bankacc.Find('-') then begin
                bankacc.CalcFields(Balance);
                "Till Balance" := bankacc.Balance;
                "Till/Treasury Balance" := bankacc.Balance;
            end;
        end else begin
            bankacc.Reset();
            bankacc.SetRange("No.", "From Account");
            if bankacc.Find('-') then begin
                bankacc.CalcFields(Balance);
                "Till Balance" := bankacc.Balance;
                "Till/Treasury Balance" := bankacc.Balance;
            end;
        end;
    end;
}
