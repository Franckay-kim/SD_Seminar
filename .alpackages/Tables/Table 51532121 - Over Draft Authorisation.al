table 51532121 "Over Draft Authorisation"
{


    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Overdraft Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Account No."; Code[20])
        {
            TableRelation = "Savings Accounts";

            trigger OnValidate()
            begin

                if Account.Get("Account No.") then begin
                    "Account Name" := Account.Name;
                    "Product Type" := Account."Product Type";
                    "Member No." := Account."Member No.";

                    //if LoansProcess.IsDefaulter("Member No.") then
                    //    Error('Member is Defaulter');

                    if ProductTypes.Get("Product Type") then begin
                        if ProductTypes."Allow Over Draft" = false then
                            Error('Overdraft not allowed for this account type.');
                        ProductTypes.TestField(ProductTypes."Over Draft Interest Account");

                        "Overdraft Interest %" := ProductTypes."Over Draft Interest %";
                    end;
                end else begin
                    if Bank.Get("Account No.") then begin
                        "Account Name" := Bank.Name;
                    end;
                end;
            end;
        }
        field(3; "Account Name"; Text[50])
        {
        }
        field(4; "Client No."; Code[20])
        {
            Caption = 'Client No.';
        }
        field(5; "Effective/Start Date"; Date)
        {

            trigger OnValidate()
            begin

                "Expiry Date" := CalcDate(Duration, "Effective/Start Date");
                Validate("Expiry Date");
            end;
        }
        field(6; "Expiry Date"; Date)
        {

            trigger OnValidate()
            begin

                AllowMultipleOD := false;

                if ("Effective/Start Date" <> 0D) and ("Expiry Date" <> 0D) then begin
                    if Account.Get("Account No.") then begin
                        if ProductTypes.Get("Product Type") then begin
                            AllowMultipleOD := ProductTypes."Allow Multiple Over Draft";
                        end;
                    end;


                    OverDraftAuth.Reset;
                    OverDraftAuth.SetCurrentKey(OverDraftAuth."Account No.", OverDraftAuth.Status, OverDraftAuth.Expired);
                    OverDraftAuth.SetRange(OverDraftAuth."Account No.", "Account No.");
                    OverDraftAuth.SetRange(OverDraftAuth.Status, OverDraftAuth.Status::Pending);
                    OverDraftAuth.SetRange(OverDraftAuth.Expired, false);
                    if OverDraftAuth.Find('-') then begin
                        repeat
                            if ("Effective/Start Date" >= OverDraftAuth."Effective/Start Date") and ("Effective/Start Date" <= OverDraftAuth."Expiry Date") then begin
                                if AllowMultipleOD = true then begin
                                    if Confirm('There is an already approved Over Draft within the specified period. - %1. Do you wish to issue another one?' +
                                       '', false, OverDraftAuth."No.") = false then
                                        Error('Process Terminated.');
                                end else
                                    Error('There is an already approved Over Draft within the specified period. - %1. Cancel an existing one if you' +
                                           ' want to issue another one.', OverDraftAuth."No.");

                            end;


                            if ("Expiry Date" >= OverDraftAuth."Effective/Start Date") and ("Expiry Date" <= OverDraftAuth."Expiry Date") then begin
                                if AllowMultipleOD = true then begin
                                    if Confirm('There is an already approved Over Draft within the specified period. - %1. Do you wish to issue another one?' +
                                       '', false, OverDraftAuth."No.") = false then
                                        Error('Process Terminated.');
                                end else
                                    Error('There is an already approved Over Draft within the specified period. - %1. Cancel an existing one if you' +
                                           ' want to issue another one.', OverDraftAuth."No.");

                            end;

                        until OverDraftAuth.Next = 0;
                    end;
                end;
            end;
        }
        field(7; Duration; DateFormula)
        {

            trigger OnValidate()
            begin

                TestField("Effective/Start Date");
                TestField(Duration);

                if "Effective/Start Date" < Today then
                    Error('Effective date cannot be in the past.');

                "Expiry Date" := CalcDate(Duration, "Effective/Start Date");
                Validate("Expiry Date");
            end;
        }
        field(8; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(9; Remarks; Text[50])
        {
        }
        field(10; "Approved Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Approved Amount" > "Requested Amount" then
                    Error('Approved Amount cannot be greater than the requeested amount.');
            end;
        }
        field(11; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(13; "Date Approved"; Date)
        {
        }
        field(14; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST(Overdraft));
        }
        field(15; Liquidated; Boolean)
        {
            Editable = false;
        }
        field(16; "Date Liquidated"; Date)
        {
            Editable = false;
        }
        field(17; "Liquidated By"; Code[50])
        {
            Editable = false;
        }
        field(18; Posted; Boolean)
        {
        }
        field(19; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility CenterBR";
        }
        field(20; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(21; "Approved By"; Code[50])
        {
            Editable = false;
        }
        field(22; "Canceled By"; Code[50])
        {
            Editable = false;
        }
        field(23; "Overdraft Interest %"; Decimal)
        {
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(25; "Application Date"; Date)
        {
        }
        field(26; "Product Type"; Code[20])
        {
        }
        field(27; "Issue to"; Option)
        {
            OptionCaption = 'Account,Cashier';
            OptionMembers = Account,Cashier;
        }
        field(28; "Requested Amount"; Decimal)
        {

            trigger OnValidate()
            begin

                "Approved Amount" := "Requested Amount";
                Validate("Approved Amount");
            end;
        }
        field(29; Expired; Boolean)
        {
            Editable = false;
        }
        field(30; "Available Balance"; Decimal)
        {
        }
        field(31; "Recommended By"; Text[150])
        {
        }
        field(32; "Member No."; Code[20])
        {
            TableRelation = Members;
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
            NoSetup.Get;
            NoSetup.TestField(NoSetup."Overdraft Nos");
            NoSeriesMgt.InitSeries(NoSetup."Overdraft Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;


        "Created By" := UpperCase(UserId);



        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        if UserSetup.Find('-') then begin
            //UserSetup.TESTFIELD(UserSetup."Responsibility Center");
            //UserSetup.TestField(UserSetup."Global Dimension 1 Code");
            //UserSetup.TestField(UserSetup."Global Dimension 2 Code");
            //"Responsibility Center":=UserSetup."Responsibility Center";
            //"Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            //"Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        end;
    end;

    var
        NoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Account: Record "Savings Accounts";
        UsersID: Record User;
        "Bank Name": Text[30];
        ChequeNo: Code[20];
        i: Integer;
        Bank: Record "Bank Account";
        ProductTypes: Record "Product Factory";
        OverDraftAuth: Record "Over Draft Authorisation";
        AllowMultipleOD: Boolean;
        UserSetup: Record "User Setup";
        Amnt: Decimal;
        MinAccBal: Decimal;
    //LoansProcess: Codeunit "Loans Process";

    local procedure CalcAvailableBal()
    var
        TCharges: Decimal;
        AvailableBalance: Decimal;
        MinAccBal: Decimal;
        Account: Record "Savings Accounts";
        AccountTypes: Record "Product Factory";
    begin

        TCharges := 0;
        "Available Balance" := 0;
        MinAccBal := 0;



        if Account.Get("Account No.") then begin
            Account.CalcFields(Account.Balance, Account."Uncleared Cheques", Account."Authorised Over Draft");

            AccountTypes.Reset;
            AccountTypes.SetRange(AccountTypes."Product ID", "Product Type");
            if AccountTypes.Find('-') then begin
                MinAccBal := AccountTypes."Minimum Contribution";

                "Available Balance" := (Account.Balance + Account."Authorised Over Draft") - (MinAccBal + Account."Uncleared Cheques");

            end;
        end;
    end;
}

