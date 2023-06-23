/// <summary>
/// Table Account Transfer Destination (ID 51532125).
/// </summary>
table 51532125 "Account Transfer Destination"
{

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; "Destination Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(3; "Destination Account No."; Code[20])
        {
            TableRelation = IF ("Destination Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                      Blocked = CONST(false))
            ELSE
            IF ("Destination Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Destination Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Destination Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Destination Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Destination Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Destination Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Destination Account Type" = CONST(Credit)) "Credit Accounts" WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                if "Destination Account Type" = "Destination Account Type"::"G/L Account" then begin


                    "G/L".Reset;
                    if "G/L".Get("Destination Account No.") then begin
                        "Destination Account Name" := "G/L".Name;
                        //"Source Transaction Type":="Source Transaction Type"::" ";
                        //"Destination Account No.":=Cust."FOSA Account";
                        //VALIDATE("Source Loan No.");
                    end;
                end;

                if "Destination Account Type" = "Destination Account Type"::Vendor then begin
                    Vend.Reset;
                    if Vend.Get("Destination Account No.") then begin
                        "Destination Account Name" := Vend.Name;
                    end;
                end;

                if "Destination Account Type" = "Destination Account Type"::Credit then begin
                    credit.Reset;
                    if credit.Get("Destination Account No.") then begin
                        "Destination Account Name" := credit.Name;
                        "Product Name" := credit."Product Name";
                        "Product Code" := credit."Product Type";
                    end;
                end;

                if "Destination Account Type" = "Destination Account Type"::Savings then begin
                    saving.Reset;
                    if saving.Get("Destination Account No.") then begin
                        "Destination Account Name" := saving.Name;
                        "Product Name" := saving."Product Name";
                        "Product Code" := saving."Product Type";
                    end;
                end;

                if "Destination Account Type" = "Destination Account Type"::Customer then begin
                    Cust.Reset;
                    if Cust.Get("Destination Account No.") then begin
                        "Destination Account Name" := Cust.Name;
                    end;
                end;



                if "Destination Account Type" = "Destination Account Type"::"Bank Account" then begin
                    Bank.Reset;
                    if Bank.Get("Destination Account No.") then begin
                        "Destination Account Name" := Bank.Name;
                    end;
                end;


                if "Destination Account Type" = "Destination Account Type"::"IC Partner" then begin
                    Vend.Reset;
                    if Vend.Get("Destination Account No.") then begin
                        "Destination Account Name" := Vend.Name;
                        //"ChqAcount Number":=Vend."ChqAcount Number";
                    end;
                end;
            end;
        }
        field(4; "Destination Loan No."; Code[30])
        {
            TableRelation = IF ("Destination Account Type" = CONST(Credit)) Loans."Loan No." WHERE("Loan Account" = FIELD("Destination Account No."),
                                                                                                  Posted = CONST(true),
                                                                                                  "Total Outstanding Balance" = FILTER(> 0));
        }
        field(5; "Destination Transaction Type"; Option)
        {
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal Due,Ledger Fee,Appraisal Paid,Pre-Earned Interest,Penalty Due,Penalty Paid';
            OptionMembers = " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,"Appraisal Due","Ledger Fee","Appraisal Paid","Pre-Earned Interest","Penalty Due","Penalty Paid";
        }
        field(6; "Destination Account Name"; Text[100])
        {
        }
        field(7; "Destination Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Destination Account Type" = "Destination Account Type"::Credit then begin
                    if "Destination Transaction Type" = "Destination Transaction Type"::" " then
                        Error('Kindly specify transaction type for credit accounts');
                    if "Destination Transaction Type" = "Destination Transaction Type"::"Appraisal Due" then begin

                        TestField("Destination Loan No.");
                        Loans.Get("Destination Loan No.");
                        Loans.CalcFields("Outstanding Balance", "Outstanding Bills", "Outstanding Interest", "Outstanding Loan Reg. Fee");
                        if (Loans."Outstanding Balance" + Loans."Outstanding Interest") < "Destination Amount" then
                            Error('Amount should not exceed the loan limit of %1', (Loans."Outstanding Balance" + Loans."Outstanding Interest"));
                    end;
                end;
            end;
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
        field(11; "Product Code"; Code[20])
        {
        }
        field(12; "Member No."; Code[20])
        {
            TableRelation = Members;
        }
    }

    keys
    {
        key(Key1; "No.", "Entry No.")
        {
            SumIndexFields = "Destination Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Destination Account No." <> '' then begin
            Transfer.Reset;
            if Transfer.Get("No.") then begin
                if (Transfer.Posted) then
                    Error('Cannot delete approved or posted batch');
            end;
        end;
    end;

    trigger OnModify()
    begin
        if "Destination Account No." <> '' then begin
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
        credit: Record "Credit Accounts";
        saving: Record "Savings Accounts";
        Loans: Record Loans;
}

