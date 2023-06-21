table 51532124 "Account Transfer Source"
{

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; "Source Account No."; Code[20])
        {
            TableRelation = IF ("Source Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                 Blocked = CONST(false))
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
            IF ("Source Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Source Account Type" = CONST(Credit)) "Credit Accounts";

            trigger OnValidate()
            begin
                if "Source Account Type" = "Source Account Type"::"G/L Account" then begin


                    "G/L".Reset;
                    if "G/L".Get("Source Account No.") then begin
                        "Source Account Name" := "G/L".Name;
                        //"Source Transaction Type":="Source Transaction Type"::" ";
                        //"Destination Account No.":=Cust."FOSA Account";
                        Validate("Source Loan No.");
                    end;
                end;

                if "Source Account Type" = "Source Account Type"::Vendor then begin
                    Vend.Reset;
                    if Vend.Get("Source Account No.") then begin
                        "Source Account Name" := Vend.Name;
                        Vend.CalcFields(Vend."Balance (LCY)", Vend.Balance);
                        Balance := Vend.Balance * -1;
                        "Available Balance" := Vend."Balance (LCY)" * -1;
                    end;
                end;

                if "Source Account Type" = "Source Account Type"::Credit then begin
                    Credit.Reset;
                    if Credit.Get("Source Account No.") then begin
                        "Source Account Name" := Credit.Name;
                        "Product Name" := Credit."Product Name";
                        "Product Code" := Credit."Product Type"
                    end;
                end;

                if "Source Account Type" = "Source Account Type"::Savings then begin
                    Saving.Reset;
                    if Saving.Get("Source Account No.") then begin
                        Saving.CalcFields(Saving.Balance);
                        "Source Account Name" := Saving.Name;
                        "Product Name" := Saving."Product Name";
                        "Product Code" := Saving."Product Type";
                        Balance := Saving.Balance;

                        CalcAvailableBal;
                    end;
                end;

                if "Source Account Type" = "Source Account Type"::Customer then begin
                    Cust.Reset;
                    if Cust.Get("Source Account No.") then begin
                        "Source Account Name" := Cust.Name;
                    end;
                end;



                if "Source Account Type" = "Source Account Type"::"Bank Account" then begin
                    Bank.Reset;
                    if Bank.Get("Source Account No.") then begin
                        "Source Account Name" := Bank.Name;
                    end;
                end;


                if "Source Account Type" = "Source Account Type"::"IC Partner" then begin
                    Vend.Reset;
                    if Vend.Get("Source Account No.") then begin
                        "Source Account Name" := Vend.Name;
                        //"ChqAcount Number":=Vend."ChqAcount Number";
                    end;
                end;
            end;
        }
        field(3; "Source Account Name"; Text[100])
        {
        }
        field(4; "Source Transaction Type"; Option)
        {
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal Due,Ledger Fee,Appraisal Paid,Pre-Earned Interest,Penalty Due,Penalty Paid';
            OptionMembers = " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Ledger Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid";

            trigger OnValidate()
            begin
                /*IF "Destination Account Type"="Destination Account Type"::BANK THEN BEGIN
                "Destination Account No.":='5-02-09276-01';
                VALIDATE("Destination Account No.");
                END;
                   */

            end;
        }
        field(5; "Source Loan No."; Code[20])
        {
            TableRelation = IF ("Source Account Type" = CONST(Credit)) Loans."Loan No." WHERE(Posted = CONST(true),
                                                                                             "Outstanding Balance" = FILTER(> 0),
                                                                                             "Loan Account" = FIELD("Source Account No."));

            trigger OnValidate()
            begin
                if "Source Transaction Type" = "Source Transaction Type"::" " then begin
                    Vend.Reset;
                    if Vend.Get("Source Loan No.") then
                        "External Document No." := Vend.Name;
                end else
                    if "Source Transaction Type" = "Source Transaction Type"::Repayment then begin
                        Cust.Reset;
                        if Cust.Get("Source Loan No.") then
                            "External Document No." := Cust.Name;
                    end;

                if "Source Transaction Type" = "Source Transaction Type"::"Interest Due" then begin
                    "G/L".Reset;
                    if "G/L".Get("Source Loan No.") then begin
                        "External Document No." := "G/L".Name;
                    end;
                end;

                if "Source Transaction Type" = "Source Transaction Type"::"Interest Paid" then begin
                    memb.Reset;
                    if memb.Get("Source Loan No.") then begin
                        "External Document No." := memb.Name;
                    end;
                end;
                if "Source Transaction Type" = "Source Transaction Type"::Loan then begin
                    Bank.Reset;
                    if Bank.Get("Source Loan No.") then begin
                        "External Document No." := Bank.Name;
                    end;
                end;
            end;
        }
        field(6; "Source Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcAvailableBal;
                if "Source Account Type" = "Source Account Type"::Savings then begin
                    if "Source Amount" > "Available Balance" then
                        Error('Amount cannot be more than the avaiable balance');
                end;
            end;
        }
        field(7; "Source Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(8; "External Document No."; Code[35])
        {
        }
        field(9; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(10; "Product Name"; Text[50])
        {
            Editable = false;
        }
        field(11; Balance; Decimal)
        {
            Editable = false;
        }
        field(12; "Available Balance"; Decimal)
        {
            Editable = false;
        }
        field(13; "Product Code"; Code[20])
        {
        }
        field(14; "Member No."; Code[20])
        {
            TableRelation = Members;
        }
    }

    keys
    {
        key(Key1; "No.", "Entry No.")
        {
            SumIndexFields = "Source Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Source Account No." <> '' then begin
            Transfer.Reset;
            if Transfer.Get("No.") then begin
                if (Transfer.Posted) then
                    Error('Cannot delete approved or posted batch');
            end;
        end;
    end;

    trigger OnModify()
    begin
        if "Source Account No." <> '' then begin
            Transfer.Reset;
            if Transfer.Get("No.") then begin
                if (Transfer.Posted) then
                    Error('Cannot modify approved or posted batch');
            end;
        end;
    end;

    trigger OnRename()
    begin
        Transfer.Reset;
        if Transfer.Get("No.") then begin
            if (Transfer.Posted) then
                Error('Cannot rename approved or posted batch');
        end;
    end;

    var
        Cust: Record Customer;
        Vend: Record Vendor;
        Bank: Record "Bank Account";
        Transfer: Record "Account Transfer Header";
        "G/L": Record "G/L Account";
        memb: Record "Savings Accounts";
        Credit: Record "Credit Accounts";
        Saving: Record "Savings Accounts";
        TChargeAmount: Decimal;
        GenSetup: Record "General Set-Up";
        TransactionCharges: Record "Transaction Charges";
        transtype: Code[20];
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Lines";
        Account: Record "Savings Accounts";
        AccountTypes: Record "Product Factory";

    local procedure CalcAvailableBal()
    var
        TCharges: Decimal;
        AvailableBalance: Decimal;
        MinBalance: Decimal;
        Account: Record "Savings Accounts";
        ProdType: Record "Product Factory";
    begin

        CalcCharges;


        "Available Balance" := 0;
        MinBalance := 0;

        if Account.Get("Source Account No.") then begin
            Account.CalcFields(Account.Balance, Account."Uncleared Cheques", Account."Authorised Over Draft");

            ProdType.Reset;
            ProdType.SetRange(ProdType."Product ID", "Product Code");
            if ProdType.Find('-') then begin
                MinBalance := ProdType."Minimum Balance";

                "Available Balance" := (Account.Balance + Account."Authorised Over Draft") - (MinBalance + Account."Uncleared Cheques" + TChargeAmount);

            end;
        end;
    end;

    local procedure CalcCharges()
    begin

        GenSetup.Get;

        TChargeAmount := 0;

        Transfer.Reset;
        Transfer.SetRange(Transfer.No, "No.");
        if Transfer.Find('-') then begin
            transtype := Transfer."Transaction Type";
        end;

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", transtype);
        if TransactionCharges.Find('-') then begin
            repeat

                ChargeAmount := 0;

                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin


                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := ("Source Amount" * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if ("Source Amount" >= TariffDetails."Lower Limit") and ("Source Amount" <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := "Source Amount" * TariffDetails.Percentage * 0.01;
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;


                    TChargeAmount := TChargeAmount + ChargeAmount;

                    if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin

                        //Excise Duty

                        TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                        ;
                    end;
                end;
            until TransactionCharges.Next = 0;
        end;


        //Charge withdrawal Frequency
        //IF Type =Type::"Cash Withdrawal" THEN BEGIN
        if Account.Get("Source Account No.") then begin
            if AccountTypes.Get(Account."Product Type") then begin
                if Account."Last Withdrawal Date" <> 0D then begin
                    if CalcDate(AccountTypes."Withdrawal Interval", Account."Last Withdrawal Date") > Today then begin
                        //IF CALCDATE(AccountTypes."Withdrawal Interval",Account."Last Withdrawal Date") <= CALCDATE('1D',TODAY) THEN BEGIN



                        TransactionCharges.Reset;
                        TransactionCharges.SetRange(TransactionCharges."Transaction Type", transtype);
                        if TransactionCharges.Find('-') then begin
                            repeat

                                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Withdrawal Frequency") then begin



                                    ChargeAmount := 0;
                                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                        ChargeAmount := ("Source Amount" * TransactionCharges."Percentage of Amount") * 0.01
                                    else
                                        ChargeAmount := TransactionCharges."Charge Amount";

                                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                        TariffDetails.Reset;
                                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                        if TariffDetails.Find('-') then begin
                                            repeat
                                                if ("Source Amount" >= TariffDetails."Lower Limit") and ("Source Amount" <= TariffDetails."Upper Limit") then begin
                                                    if TariffDetails."Use Percentage" = true then begin
                                                        ChargeAmount := "Source Amount" * TariffDetails.Percentage * 0.01;
                                                    end else begin
                                                        ChargeAmount := TariffDetails."Charge Amount";
                                                    end;
                                                end;
                                            until TariffDetails.Next = 0;
                                        end;
                                    end;


                                    TChargeAmount := TChargeAmount + ChargeAmount;


                                    if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin

                                        //Excise Duty


                                        TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                                    end;
                                end;
                            until TransactionCharges.Next = 0;
                        end;

                    end;


                end;
            end;
        end;

        //Charge withdrawal Frequency
    end;
}

