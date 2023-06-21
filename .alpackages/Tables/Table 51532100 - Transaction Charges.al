table 51532100 "Transaction Charges"
{

    fields
    {
        field(1; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types";
        }
        field(2; "Charge Code"; Code[20])
        {
            Enabled = false;

            trigger OnValidate()
            begin
                TransactionTypes.Reset;
                TransactionTypes.SetRange(TransactionTypes.Code, "Charge Code");
                if TransactionTypes.Find('-') then
                    Description := TransactionTypes.Description;
            end;
        }
        field(3; Description; Text[50])
        {
        }
        field(4; "Charge Type"; Option)
        {
            OptionCaption = 'Flat Amount,% of Amount,Staggered';
            OptionMembers = "Flat Amount","% of Amount",Staggered;
        }
        field(5; "Charge Amount"; Decimal)
        {
        }
        field(6; "Percentage of Amount"; Decimal)
        {
        }
        field(7; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Minimum Amount"; Decimal)
        {
        }
        field(9; "Maximum Amount"; Decimal)
        {
        }
        field(10; "Staggered Charge Code"; Code[20])
        {
            TableRelation = "Tiered Charges Header";
        }
        field(11; "Transaction Charge Category"; Option)
        {
            OptionMembers = Normal,"Stamp Duty","Withdrawal Frequency","Withdrawn Amount","Failed STO Charge";
        }
        field(12; "Recover Excise Duty"; Boolean)
        {
        }
        field(16; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Sharing Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit,Member';
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit,Member;
        }
        field(17; "Account No."; Code[20])
        {
            Caption = 'Sharing Account No.';
            /* TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
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
            IF ("Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Account Type" = CONST(Credit)) "Credit Accounts"; */
        }
        field(18; "Sharing Value"; Decimal)
        {
        }
        field(19; "Sharing Use Percentage"; Boolean)
        {
        }
        field(20; "Dont Charge Sharing Duty"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Transaction Type", Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Recover Excise Duty" := true;
    end;

    // Table Functions

    /// <summary>
    /// Get a transaction Charge's billable amount
    /// </summary>
    /// <param name="BillableAmount"></param>
    /// <param name="Days"></param>
    /// <returns></returns>
    procedure GetChargeAmount(BillableAmount: Decimal; Days: Integer): Decimal
    var
        TransactionCharges: Record "Transaction Charges";
        ChargeAmount: Decimal;
        TieredCharges: Record "Tiered Charges Lines";
    //JournalPosting: Codeunit "Journal Posting";
    begin

        ChargeAmount := 0;

        CASE "Charge Type" OF

            "Charge Type"::"% of Amount":
                ChargeAmount := (BillableAmount * "Percentage of Amount") * 0.01;
            "Charge Type"::"Flat Amount":
                ChargeAmount := "Charge Amount";
            "Charge Type"::Staggered:
                BEGIN

                    TESTFIELD("Staggered Charge Code");

                    TieredCharges.RESET;
                    TieredCharges.SETRANGE(Code, "Staggered Charge Code");
                    TieredCharges.SETFILTER("Lower Limit", '<=%1', BillableAmount);
                    TieredCharges.SETFILTER("Upper Limit", '>=%1', BillableAmount);
                    IF TieredCharges.FINDFIRST THEN BEGIN
                        CASE TieredCharges."Use Percentage" OF
                            true:
                                ChargeAmount := TieredCharges."Charge Amount";
                            false:
                                ChargeAmount := BillableAmount * TieredCharges.Percentage * 0.01;
                        END;
                    END;

                    //Add function to calculate no of days here ***

                END;

        END;

        IF "Minimum Amount" > 0 THEN IF ChargeAmount < "Minimum Amount" THEN ChargeAmount := "Minimum Amount";
        IF "Maximum Amount" > 0 THEN IF ChargeAmount > "Maximum Amount" THEN ChargeAmount := "Maximum Amount";

        EXIT(ChargeAmount);
    end;


    /// <summary>
    /// Checks for excise duty
    /// </summary>
    /// <returns></returns>
    procedure HasExciseDuty(): Boolean
    begin
        if not "Recover Excise Duty" THEN exit(false);
        exit("Transaction Charge Category" <> "Transaction Charge Category"::"Stamp Duty");
    end;

    /// <summary>
    /// Returns excise duty amount
    /// </summary>
    /// <param name="ChargeAmount"></param>
    procedure ExciseDutyAmount(BillableAmount: Decimal): Decimal
    var
        GeneralSetup: Record "General Set-Up";
    begin
        GeneralSetup.Get();
        if not HasExciseDuty() then exit;
        if GeneralSetup."Excise Duty (%)" <= 0 then exit;
        GeneralSetup.TestField("Excise Duty G/L");
        exit(Round((GeneralSetup."Excise Duty (%)" / 100) * BillableAmount, 0.01, '='));
    end;
    //end of table functions
    var
        TransactionTypes: Record "Transaction Types";
}

