/// <summary>
/// Table ATM Linking Applications (ID 51532168).
/// </summary>
table 51532168 "ATM Linking Applications"
{
    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    BankingNoSetup.Get;
                    NoSeriesMgt.TestManual(BankingNoSetup."ATM Linking Application Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Account No"; Code[20])
        {
            TableRelation = "Savings Accounts"."No." WHERE("Loan Disbursement Account" = CONST(true));

            trigger OnValidate()
            begin
                ATMApplications.SetRange(ATMApplications."Account No", "Account No");
                ATMApplications.SetRange(ATMApplications."ATM Linked", true);
                if ATMApplications.Find('-') then begin
                    repeat //MESSAGE(ATMApplications."No.");
                        ATMCount += 1;
                    until ATMApplications.Next = 0;
                end;
                if ATMCount > 0 then Error('The member has an existing linking application');
                /*
                    ATMApplications.RESET;
                    ATMApplications.SETRANGE(ATMApplications."Account No","Account No");
                    ATMApplications.SETRANGE(ATMApplications."ATM Delinked",FALSE);
                    IF ATMApplications.FIND('-') THEN
                      BEGIN
                        REPEAT
                          IF ATMApplications."ATM Charges Applied"=FALSE
                            THEN ERROR('This Account has an active ATM application');
                          UNTIL ATMApplications.NEXT=0;
                        END;
                    TESTFIELD("Card Type");
                    UserSetup.GET(USERID);
                    SavingsAccounts.RESET;
                    SavingsAccounts.SETRANGE(SavingsAccounts."No.","Account No");
                    IF SavingsAccounts.FIND('-') THEN
                      BEGIN
                        Members.RESET;
                        Members.SETRANGE(Members."No.",SavingsAccounts."Member No.");
                        IF Members.FIND('-') THEN
                          BEGIN
                            "Branch Code":=Members."Global Dimension 2 Code";
                            "Shortcut Dimension 1 Code":=UserSetup."Global Dimension 1 Code";//Members."Global Dimension 1 Code";
                            "Shortcut Dimension 2 Code":=UserSetup."Global Dimension 2 Code";//Members."Global Dimension 2 Code";
                            "Account Name":=Members.Name;
                            "Customer ID":=Members."ID No.";
                            "Phone No.":=Members."Phone No.";
                            Address:=Members."Current Address";
                            END ELSE
                            BEGIN
                             "Branch Code":='';
                            "Shortcut Dimension 1 Code":='';
                            "Shortcut Dimension 2 Code":='';
                            "Account Name":='';
                            "Customer ID":='';
                            "Phone No.":='';
                             Address:='';
                              END;

                              AvailableBalance:=0;
                              MinBalance:=0;
                              TChargeAmount:=0;
                              IF Account.GET(SavingsAccounts."No.") THEN
                                BEGIN
                                  Account.CALCFIELDS(Account.Balance,Account."Uncleared Cheques",Account."Authorised Over Draft",Account."Balance (LCY)");
                                  ProdType.RESET;
                                  ProdType.SETRANGE(ProdType."Product ID",Account."Product Type");
                                  IF ProdType.FIND('-') THEN
                                  BEGIN
                                  MinBalance:=ProdType."Minimum Balance";
                                  AvailableBalance:=(Account."Balance (LCY)"+Account."Authorised Over Draft") - (MinBalance+Account."Uncleared Cheques");
                                  END;
                                END;

                              GenSetup.GET;
                              ChargeAmount:=0;
                        ATMCardTypes.RESET;
                        ATMCardTypes.SETRANGE(ATMCardTypes."Application Charge Code","Card Type");
                        IF ATMCardTypes.FIND('-') THEN
                          BEGIN
                              TransType.RESET;
                              TransType.SETRANGE(TransType.Code,ATMCardTypes.Code);//TransType.Type::"ATM Applications");
                              IF TransType.FIND('-') THEN
                                BEGIN
                                    ChargeAmount:=0;
                                    TransactionCharges.RESET;
                                    TransactionCharges.SETRANGE(TransactionCharges."Transaction Type",TransType.Code);
                                    IF TransactionCharges.FIND('-') THEN
                                      BEGIN
                                        //MESSAGE('here');
                                          REPEAT
                                            ChargeAmount:=0;
                                          IF (TransactionCharges."Transaction Charge Category"=TransactionCharges."Transaction Charge Category"::Normal) OR
                                          (TransactionCharges."Transaction Charge Category"=TransactionCharges."Transaction Charge Category"::"Stamp Duty") THEN
                                          BEGIN
                                              IF TransactionCharges."Charge Type"=TransactionCharges."Charge Type"::"% of Amount" = TRUE THEN
                                              ChargeAmount:=TransactionCharges."Charge Amount"//(TransType.Amount*TransactionCharges."Percentage of Amount")*0.01
                                              ELSE ChargeAmount:=TransactionCharges."Charge Amount";

                                              TChargeAmount:=ChargeAmount;

                                              IF TransactionCharges."Transaction Charge Category"<>TransactionCharges."Transaction Charge Category"::"Stamp Duty" THEN
                                                BEGIN

                                              TChargeAmount:=TChargeAmount+(ChargeAmount*GenSetup."Excise Duty (%)")*0.01;;
                                              END;
                                          END;
                                    UNTIL TransactionCharges.NEXT = 0;

                                  END;
                                  END;
                                  END;
                                  END;
                                  IF AvailableBalance<ChargeAmount THEN ERROR(ErrRejectCard,ChargeAmount);
                    */
            end;
        }
        field(3; "Branch Code"; Code[20])
        {
            Editable = false;
        }
        field(4; "Account Type"; Option)
        {
            OptionCaption = 'Savings,Current';
            OptionMembers = Savings,Current;
        }
        field(5; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(6; Address; Text[35])
        {
            Editable = false;
        }
        field(7; "Customer ID"; Code[11])
        {
            Editable = false;
        }
        field(8; "Relation Indicator"; Option)
        {
            OptionCaption = 'Primary,Suplimentary';
            OptionMembers = Primary,Suplimentary;
        }
        field(9; "Card Type"; Code[10])
        {
            //TableRelation = "ATM Card Types".Code;
        }
        field(10; "Request Type"; Option)
        {
            OptionCaption = 'New,Replacement,Re-Pin';
            OptionMembers = New,Replacement,"Re-Pin",Supplementary;
        }
        field(11; "Application Date"; Date)
        {
            Editable = false;
        }
        field(12; "Card No"; Code[30])
        {
            trigger OnValidate()
            begin
                GeneralSetUp.Get();
                if StrLen("Card No") <> GeneralSetUp."ATM Card No Characters" then Error('ATM Card No %1 MUST be equal to %2 characters.', "Card No", GeneralSetUp."ATM Card No Characters");
                TestField("Account No");
                ATMLinkingApplications.Reset;
                ATMLinkingApplications.SetRange("Card No", "Card No");
                if ATMLinkingApplications.Find('-') then begin
                    Error('This card is already linked to ' + ATMLinkingApplications."Account No");
                end;
                "Card Expiry Date" := CalcDate('5Y', WorkDate());
                //send sms
                SavingsACC.Reset;
                SavingsACC.SetRange("No.", "Account No");
                if SavingsACC.Find('-') then begin
                    // SendSMS.SendSms(SourceType::"ATM Collection", SavingsACC."Mobile Phone No", Txt004, "No.", "Account No", false, false);
                end;
            end;
        }
        field(13; "Date Issued"; Date)
        {
            Editable = false;
        }
        field(14; Limit; Decimal)
        {
        }
        field(15; "Terms Read and Understood"; Boolean)
        {
        }
        field(16; "Card Issued"; Boolean)
        {
            Editable = false;
        }
        field(17; "Form No"; Code[30])
        {
        }
        field(18; "Sent To External File"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(19; "Card Status"; Option)
        {
            Editable = false;
            OptionMembers = Pending,Active,Frozen;
        }
        field(20; "Date Activated"; Date)
        {
            Editable = false;
        }
        field(21; "Date Frozen"; Date)
        {
            Editable = false;
        }
        field(22; "Replacement For Card No"; Code[20])
        {
        }
        field(23; "Phone No."; Code[20])
        {
        }
        field(24; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(25; Collected; Boolean)
        {
            Editable = false;
        }
        field(26; "Application Approved"; Boolean)
        {
            Editable = false;
        }
        field(27; "Date Collected"; Date)
        {
            Editable = false;
        }
        field(28; "Card Issued By"; Code[50])
        {
            Editable = false;
        }
        field(29; "Approval Date"; Date)
        {
            Editable = false;
        }
        field(30; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(31; "Card Expiry Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Card Expiry Date" < Today then Error('This card has already expired');
            end;
        }
        field(32; "Posted By."; Code[80])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(33; "Responsibility Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(34; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(35; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(36; "Card Issued Date"; Date)
        {
            Editable = false;
        }
        field(37; "PIN Issued Date"; Date)
        {
            Editable = false;
        }
        field(38; "PIN Issued By"; Code[50])
        {
            Editable = false;
        }
        field(39; "Linked Date"; Date)
        {
            Editable = false;
        }
        field(40; "ATM Linked"; Boolean)
        {
            Editable = false;
        }
        field(41; "ATM Charges Applied"; Boolean)
        {
        }
        field(42; "ATM Charged Date"; Date)
        {
        }
        field(43; "PIN Issued"; Boolean)
        {
            Editable = false;
        }
        field(44; "Linked By"; Code[50])
        {
            Editable = false;
        }
        field(45; "Delinked By"; Code[50])
        {
            Editable = false;
        }
        field(46; "ATM Delinked"; Boolean)
        {
            Editable = false;
        }
        field(47; "ATM Delinked Date"; Date)
        {
            Editable = false;
        }
        field(48; "ATM Application No."; Code[20])
        {
            TableRelation = "ATM Applications"."No." WHERE("Account No" = FIELD("Account No"));

            trigger OnValidate()
            var
                AtmApp: Record "ATM Applications";
            begin
                ATMApp.Get("ATM Application No.");
                if ATMApp."ATM Charges Applied" <> true then Error('Kindly Charge the ATM Fee.');
                ATMApplications.SetRange(ATMApplications."ATM Application No.", "ATM Application No.");
                if ATMApplications.Find('-') then begin
                    repeat
                        ATMCount += 1;
                    until ATMApplications.Next = 0;
                end;
                //MESSAGE('g5 %1',ATMCount);
                if ATMCount > 0 then Error('The member has an existing linking application');
                "Branch Code" := ATMApp."Branch Code";
                "Account Type" := ATMApp."Account Type";
                "Account Name" := ATMApp."Account Name";
                Address := ATMApp.Address;
                "Customer ID" := ATMApp."Customer ID";
                "Relation Indicator" := ATMApp."Relation Indicator";
                "Card Type" := ATMApp."Card Type";
                "Request Type" := ATMApp."Request Type";
                "Application Date" := ATMApp."Application Date";
                "Card No" := ATMApp."Card No";
                //"Date Issued":=ATMApp."Date Issued";
                Limit := ATMApp.Limit;
                "Terms Read and Understood" := ATMApp."Terms Read and Understood";
                //"Card Issued":=ATMApp."Card Issued";
                "Form No" := ATMApp."Form No";
                "Sent To External File" := ATMApp."Sent To External File";
                "Card Status" := ATMApp."Card Status";
                //"Date Activated":=ATMApp."Date Activated";
                //"Date Frozen":=ATMApp."Date Frozen";
                "Replacement For Card No" := ATMApp."Replacement For Card No";
                "Phone No." := ATMApp."Phone No.";
                Collected := ATMApp.Collected;
                //"Date Collected":=ATMApp."Date Collected";
                //"Card Issued By":=ATMApp."Card Issued By";
                //"Approval Date":=ATMApp."Approval Date";
                //Status:=ATMApp.Status;
                //"Card Expiry Date":=ATMApp."Card Expiry Date";
                "Posted By." := ATMApp."Posted By.";
                "Responsibility Center" := ATMApp."Responsibility Center";
                "Shortcut Dimension 1 Code" := ATMApp."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := ATMApp."Shortcut Dimension 2 Code";
                //"Card Issued Date":=ATMApp."Card Issued Date";
                //"PIN Issued Date":=ATMApp."PIN Issued Date";
                //"PIN Issued By":=ATMApp."PIN Issued By";
                //"Linked Date":=ATMApp."Linked Date";
                //"ATM Linked":=ATMApp."ATM Linked";
                "ATM Charges Applied" := ATMApp."ATM Charges Applied";
                "ATM Charged Date" := ATMApp."ATM Charged Date";
                //"PIN Issued":=ATMApp."PIN Issued";
                //"Linked By":=ATMApp."Linked By";
                //"Delinked By":=ATMApp."Delinked By";
                //"ATM Delinked":=ATMApp."ATM Delinked";
                //"ATM Delinked Date":=ATMApp."ATM Delinked Date";
                "Card Type" := ATMApp."Card Type";
                "Sales Agent" := ATMApp."Sales Agent";
            end;
        }
        field(49; "ATM Linking Statistics"; Integer)
        {
            CalcFormula = Count("ATM Linking  Statistics" WHERE("Account No." = FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Sales Agent"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(51; "Captured By"; Code[50])
        {
            Editable = false;
        }
        field(52; "Capture Date"; Date)
        {
            Editable = false;
        }
        field(53; "Approved  By"; Code[50])
        {
            Editable = false;
        }
        field(54; Source; Option)
        {
            OptionMembers = Navision,Web;
        }
        field(55; "Transferred To"; Code[50])
        {

        }
        field(56; "Received By"; Code[50])
        {

        }
        field(57; DateTimeTransferred; DateTime)
        {

        }
        field(58; DateTimeReceived; DateTime)
        {

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
            BankingNoSetup.Get();
            BankingNoSetup.TestField(BankingNoSetup."ATM Linking Application Nos");
            NoSeriesMgt.InitSeries(BankingNoSetup."ATM Linking Application Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        "Application Date" := Today;
        "Captured By" := UserId;
        "Capture Date" := Today;
    end;

    var
        GeneralSetUp: Record "General Set-Up";
        BankingNoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SavingsAccounts: Record "Savings Accounts";
        Members: Record Members;
        SavingsAccountss: Record "Savings Accounts";
        TChargeAmount: Decimal;
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charges";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Lines";
        Trans: Record "Cashier Transactions";
        GenSetup: Record "General Set-Up";
        AccountTypes: Record "Product Factory";
        TransType: Record "Transaction Types";
        Account: Record "Savings Accounts";
        AvailableBalance: Decimal;
        MinBalance: Decimal;
        ProdType: Record "Product Factory";
        ErrRejectCard: Label 'This account do not have minimum balance of %1 to apply for ATM Card.';
        //ATMCardTypes: Record "ATM Card Types";
        UserSetup: Record "User Setup";
        ATMApplications: Record "ATM Linking Applications";
        //ATMApp: Record "ATM Applications";
        SavingsACC: Record "Savings Accounts";
        //SendSMS: Codeunit SendSms;
        SourceType: Option "New Member","New Account","Loan Account Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit"," Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit";
        Txt004: Label 'Dear Member, Your Sacco Link ATM Card is ready for collection. Kindly visit your branch with Original copy of ID.';
        ATMCount: Integer;
        ATMLinkingApplications: Record "ATM Linking Applications";

    /// <summary>
    /// ValidateApproval.
    /// </summary>
    procedure ValidateApproval()
    begin
        Rec.TestField("Account No");
        Rec.TestField("ATM Application No.");
        Rec.TestField("Card No");
        Rec.TestField("Card Expiry Date");
        Rec.TestField("Account No");
        Rec.TestField("Form No");
        Rec.TestField("Card Type");
        Rec.TestField("Customer ID");
        Rec.TestField("Terms Read and Understood");
    end;
}
