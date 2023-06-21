table 51532044 "Standing Order Lines"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Document No."; Code[10])
        {
        }
        field(17; "Destination Account Type"; Enum "Gen. Journal Account Type")
        {
            // OptionCaption = 'G/L Account,Customer,Vendor,External,Fixed Asset,IC Partner,Employee,Internal,Credit';
            // OptionMembers = "G/L Account",Customer,Vendor,External,"Fixed Asset","IC Partner",Employee,Internal,Credit;

            trigger OnValidate()
            begin
                if "Destination Account Type" = "Destination Account Type"::"Bank Account" then begin
                    if STOHeader.Get("Document No.") then begin
                        if STOHeader."Allow Partial Deduction" = true then
                            Error('An external standing order cannot be partially deducted');
                    end;
                end;




            end;
        }
        field(18; "Destination Account No."; Code[50])
        {
            //ValidateTableRelation = false;
            /*TableRelation = IF ("Destination Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Destination Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Destination Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Destination Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Destination Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Destination Account Type" = CONST(Savings)) "Savings Accounts"."No." where("Product Category" = filter(<> "Registration Fee"))
            ELSE
            IF ("Destination Account Type" = CONST(Credit)) "Credit Accounts" WHERE(Balance = FILTER(> 0));*/

            trigger OnValidate()
            begin

                /* if "Destination Account Type" = "Destination Account Type"::Savings then begin
                     if Account.Get("Destination Account No.") then begin
                         if Account."Product Category" = Account."Product Category"::"Registration Fee" then
                             error('Please select another valid a/c');
                         "Destination Account Name" := Account.Name;
                     end;
                 end; */

                if "Destination Account Type" = "Destination Account Type"::"Bank Account" then begin
                    if BankAcc.Get("Destination Account No.") then begin
                        //"Destination Account Name":=BankAcc.Name;
                        //"Bank Code":=BankAcc."Bank No.";



                        if STOHeader.Get("Document No.") then begin
                            if STOHeader."Allow Partial Deduction" = true then
                                Error('An external standing order cannot be partially deducted');
                        end;
                    end;

                    if "Destination Account Type" = "Destination Account Type"::"Bank Account" then begin
                        if StrLen("Destination Account No.") > 14 then
                            Error('Invalid Bank Account No. Please enter a bank account with less than 15 digits.');
                    end;


                end;

                /* if "Destination Account Type" = "Destination Account Type"::Credit then begin
                     if Cust.Get("Destination Account No.") then begin
                         "Destination Account Name" := Cust.Name;
                     end;
                 end; */

                /*
                STOLines.RESET;
                STOLines.SETRANGE(STOLines."Document No.","Document No.");
                IF STOLines.FIND('-')=TRUE THEN //BEGIN
                //IF STOLines.COUNT>1 THEN
                  ERROR('Only one entry is allowed for this type of standing order, Please delete the lines before proceeding');
                //END;
                */

            end;
        }
        field(19; "Destination Account Name"; Text[80])
        {
            Editable = false;
        }
        field(20; "Loan No."; Code[30])
        {
            TableRelation = IF ("Destination Account No." = FILTER(<> '')) Loans WHERE("Loan Account" = FIELD("Destination Account No."),
                                                                                     "Outstanding Balance" = FILTER(> 0));
        }
        field(21; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if Amount < 0 then
                    Error(LessThanZeroAmount);


                /* if "Destination Account Type" = "Destination Account Type"::Credit then begin
                    if "Loan No." = '' then
                        Error('Kindly specify the loan no. before proceeding');

                end; */
            end;
        }
        field(22; "Bank Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Bank Code";

            trigger OnValidate()
            begin
                if "Destination Account Type" = "Destination Account Type"::Employee then
                    Error('Only applicable FOR external STOs');

                BankCodeStructure.Reset;
                BankCodeStructure.SetRange(BankCodeStructure."Bank Code", "Bank Code");
                if BankCodeStructure.Find('-') then
                    "Bank Name" := BankCodeStructure."Bank Name";
            end;
        }
        field(23; "Branch Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Branch Code";

            trigger OnValidate()
            begin
                if "Destination Account Type" <> "Destination Account Type"::"Bank Account" then
                    Error('Only applicable for external STOs');


                BankCodeStructure.Reset;
                BankCodeStructure.SetRange(BankCodeStructure."Branch Code", "Branch Code");
                if BankCodeStructure.Find('-') then begin
                    "Bank Code" := BankCodeStructure."Bank Code";
                    "Bank Name" := BankCodeStructure."Bank Name";
                    "Branch Name" := BankCodeStructure.Branch;
                end;

                if "Branch Code" = '' then begin
                    "Bank Code" := '';
                    "Bank Name" := '';
                    "Bank Account No." := '';
                end;
            end;
        }
        field(24; "Bank Name"; Text[100])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Destination Account Type" <> "Destination Account Type"::"Bank Account" then
                    Error('Only applicable for external STOs');
            end;
        }
        field(25; "Bank Account No."; Code[15])
        {

            trigger OnValidate()
            begin
                if "Destination Account Type" <> "Destination Account Type"::"Bank Account" then
                    Error('Only applicable for external STOs');

                //*
                if "Destination Account Type" = "Destination Account Type"::"Bank Account" then begin
                    if StrLen("Bank Account No.") <> 13 then
                        Error('Invalid Bank account No. Please enter the correct Bank Account No.');
                end;
            end;
        }
        field(26; Balance; Decimal)
        {
        }
        field(27; "Branch Name"; Text[150])
        {
        }
        field(28; Priority; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Destination Account No.", "Loan No.")
        {
        }
        key(Key2; "Destination Account Type")
        {
        }
        key(Key3; Priority)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Validate("Destination Account Type");
    end;

    var
        Account: Record "Savings Accounts";
        BankAcc: Record "Bank Account";
        BankCodeStructure: Record "Bank Code Structure";
        Cust: Record "Credit Accounts";
        StrTel: Text;
        LessThanZeroAmount: Label 'Amount cannot be less than zero (0)';
        STOHeader: Record "Standing Order Header";
        STOLines: Record "Standing Order Lines";
}

