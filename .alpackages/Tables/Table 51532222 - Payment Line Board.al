/// <summary>
/// Table Payment Line Board (ID 51532222).
/// </summary>
table 51532222 "Payment Line Board"
{

    fields
    {
        field(1; "Document No"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Payment Types"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = CONST(Payment));

            trigger OnValidate()
            begin
                "Tax Amount" := 0;
                RecTypes.Reset;
                RecTypes.SetRange(RecTypes.Code, "Payment Types");
                if RecTypes.Find('-') then begin
                    Description := RecTypes.Description;
                    "Tax Exempt" := RecTypes."Daily Tax Exempt. Amount";
                    "Account Type" := RecTypes."Account Type";

                    if RecTypes."Account Type" = RecTypes."Account Type"::"G/L Account" then begin
                        /*if RecTypes."G/L Account" = '' then
                            Error('The G/L account no. must be specified')
                        else*/
                        "G/L Account No." := RecTypes."G/L Account";
                        "Account No" := RecTypes."G/L Account";
                    end;
                end;

                getDestinationRateAndAmounts;
            end;
        }
        field(3; "Transaction Type"; Option)
        {
            OptionCaption = ' ,Repayment,Deposits Contribution,Rejoining Fee,Registration Fee,Insurance Contribution,Shares Capital,Investment,Un-allocated Funds';
            OptionMembers = " ",Repayment,"Deposits Contribution","Rejoining Fee","Registration Fee","Insurance Contribution","Shares Capital",Investment,"Un-allocated Funds";
        }
        field(4; "Loan No."; Code[20])
        {
        }
        field(5; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                getDestinationRateAndAmounts();
            end;
        }
        field(6; "Tax Amount"; Decimal)
        {
            Editable = true;
        }
        field(7; "Net Amount"; Decimal)
        {
            Editable = true;
        }
        field(8; "Amount Balance"; Decimal)
        {
            Enabled = false;
        }
        field(9; "Interest Balance"; Decimal)
        {
            Enabled = false;
        }
        field(10; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(1,"Shortcut Dimension 1 Code","Dimension Set ID");
            end;
        }
        field(11; Description; Text[50])
        {
        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                //"Dimension Set ID" := DimMgt.ValidateShortcutDimValues2(2,"Shortcut Dimension 2 Code","Dimension Set ID");
            end;
        }
        field(13; "G/L Account No."; Code[20])
        {
            TableRelation = "G/L Account"."No." where("Direct Posting" = const(true));
            trigger OnValidate()
            begin
                GLAccount.Get("G/L Account No.");
                //"Budgetary Control A/C" := GLAccount."Budget Controlled";
            end;
        }
        field(14; "Member No."; Code[20])
        {
            TableRelation = IF ("Customer Type" = CONST("Board Member")) Members."No." WHERE("Account Category" = CONST("Board Members"))
            ELSE
            IF ("Customer Type" = CONST(Staff)) Members."No." WHERE("Account Category" = CONST("Staff Members"));

            trigger OnValidate()
            begin

                if Cust.Get("Member No.") then begin
                    "Member Name" := Cust.Name;
                    "Staff No." := Cust."Payroll/Staff No.";

                end;

                /*
                SavingsAccounts.RESET;
                SavingsAccounts.SETRANGE(SavingsAccounts."Member No.","Member No.");
                IF SavingsAccounts.FINDSET THEN
                  "Savings Account" := SavingsAccounts."No.";
                */


                getDestinationRateAndAmounts();



                Member.Reset;
                Member.SetRange(Member."No.", "Member No.");
                if Member.Find('-') then begin
                    "Shortcut Dimension 1 Code" := Member."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := Member."Global Dimension 2 Code";
                    "Staff No." := Member."Payroll/Staff No.";

                end

            end;
        }
        field(15; "Member Name"; Text[30])
        {
        }
        field(16; "Savings Account"; Code[20])
        {
            Description = 'FOSA';
            TableRelation = "Savings Accounts"."No." WHERE("Member No." = FIELD("Member No."),
                                                            "Product Category" = CONST(" "));
        }
        field(17; "Perdiem Amount"; Decimal)
        {
        }
        field(18; "External DOC No"; Code[35])
        {
        }
        field(19; "Send SMS"; Boolean)
        {
        }
        field(20; Committed; Boolean)
        {
        }
        field(21; "Budgetary Control A/C"; Boolean)
        {
        }
        field(90; "Employee Job Group"; Code[10])
        {
            Editable = false;
        }
        field(91; "Daily Rate(Amount)"; Decimal)
        {

            trigger OnValidate()
            begin
                getDestinationRateAndAmounts;
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
        }
        field(481; "Destination Code"; Code[20])
        {
            TableRelation = "Travel Destination"."Destination Code";

            trigger OnValidate()
            begin
                getDestinationRateAndAmounts();
            end;
        }
        field(482; "No of Days"; Decimal)
        {

            trigger OnValidate()
            begin
                getDestinationRateAndAmounts();
            end;
        }
        field(483; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(484; "Staff No."; Code[20])
        {

            trigger OnValidate()
            begin
                Validate("Member No.", '');
                if "Staff No." <> '' then begin

                    Cust.Reset;
                    Cust.SetRange("Payroll/Staff No.", "Staff No.");
                    if Cust.FindFirst then begin
                        Validate("Member No.", Cust."No.");
                    end;
                end;
            end;
        }
        field(485; "Customer Type"; Option)
        {
            OptionCaption = 'Staff,Board Member';
            OptionMembers = Staff,"Board Member";
        }
        field(486; "Tax Exempt"; Decimal)
        {
        }
        field(487; "Taxable Amount"; Decimal)
        {

            trigger OnValidate()
            begin

                BoardAllowance.Get("Committee Code", "Allowance Code");
                Validate("Allowance Code");

                "Tax Amount" := Round("Tax %" / 100 * "Taxable Amount", 1, '>');

                if "Minimum Tax" > 0 then
                    if "Tax Amount" < "Minimum Tax" then
                        "Tax Amount" := "Minimum Tax";

                if "Maximum Tax" > 0 then
                    if "Tax Amount" < "Maximum Tax" then
                        "Tax Amount" := "Maximum Tax";

                "Net Amount" := Amount - "Tax Amount";
            end;
        }
        field(488; "Total Tax Exemption"; Decimal)
        {
        }
        field(489; "Committee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Board Committee";
        }
        field(490; "Allowance Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Committee Allowance Lines"."Allowance Code" WHERE ("Header Code"=FIELD("Committee Code"));

            trigger OnValidate()
            begin
                Description := '';
                "Tax %" := 0;
                "Minimum Taxable Amount" := 0;
                "Minimum Tax" := 0;
                "Maximum Taxable Amount" := 0;
                "Maximum Tax" := 0;

                if "Allowance Code" <> '' then begin
                    BoardAllowance.Get("Committee Code", "Allowance Code");
                    Description := BoardAllowance."Allowance Description";
                    "Tax %" := BoardAllowance."Tax %";
                    "Tax GL" := BoardAllowance."Tax GL";
                    "Minimum Taxable Amount" := BoardAllowance."Minimum Taxable Amount";
                    "Minimum Tax" := BoardAllowance."Minimum Tax";
                    "Maximum Taxable Amount" := BoardAllowance."Maximum Taxable Amount";
                    "Maximum Tax" := BoardAllowance."Maximum Tax";
                    "Allowance GL" := BoardAllowance."Allowance GL";
                    "G/L Account No." := "Allowance GL";
                end;
            end;
        }
        field(491; "Tax %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(492; "Tax GL"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(493; "Minimum Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(494; "Maximum Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(495; "Minimum Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(496; "Maximum Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(497; "Allowance GL"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(498; "Pay to Savings Account"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(499; "Rate Per Day"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(500; "Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = ToBeClassified;
            // OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee,Savings,Credit;
        }
        field(501; "Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            /*TableRelation = IF ("Account Type" = CONST(Savings)) "Savings Accounts"."No." WHERE("Member No." = FIELD("Member No."),
                                                                                               "Product Category" = CONST(" "))
            ELSE
            IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE("Direct Posting" = CONST(true));*/
        }
    }

    keys
    {
        key(Key1; "Document No", "Line No")
        {
        }
        key(Key2; "Document No", "Member No.")
        {
            SumIndexFields = Amount, "Net Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*
        IF PaymentsHeaderBoard.GET("Document No") THEN
            IF PaymentsHeaderBoard.Posted OR (PaymentsHeaderBoard.Status<>PaymentsHeaderBoard.Status::Pending) THEN
              ERROR('You can only delete open transactions');
              */

    end;

    trigger OnModify()
    begin
        if PaymentsHeaderBoard.Get("Document No") then
            if PaymentsHeaderBoard.Posted or (PaymentsHeaderBoard.Status <> PaymentsHeaderBoard.Status::Open) then
                Error('You can only modify open transactions');
    end;

    var
        Loans: Record Loans;
        Cust: Record Members;
        ReceiptsPayments: Record "Receipts and Payment Types";
        RecTypes: Record "Receipts and Payment Types";
        SavingsAccounts: Record "Savings Accounts";
        TariffCodes: Record "Tariff Code s";
        DimMgt: Codeunit DimensionManagement;
        GLAccount: Record "G/L Account";
        Member: Record Members;
        HREmp: Record "HR Employees";
        Members: Record Members;
        HREmployees: Record "HR Employees";
        EmpGrade: Code[20];
        objDestRateEntry: Record "Destination Rate Entry";
        PaymentsHeaderBoard: Record "Payments Header Board";
        BoardAllowance: Record "Committee Allowance Lines";

    /// <summary>
    /// ValidateShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    /// <summary>
    /// getDestinationRateAndAmounts.
    /// </summary>
    procedure getDestinationRateAndAmounts()
    var
        Members: Record Members;
        HREmployees: Record "HR Employees";
        EmpGrade: Code[20];
        objDestRateEntry: Record "Destination Rate Entry";
    begin
        //Reset the brare fields

        "Tax Amount" := 0;
        "Taxable Amount" := Amount;

        if "Customer Type" = "Customer Type"::"Board Member" then begin
            /*BoardAllowance.Get("Committee Code", "Allowance Code");
            Validate("Allowance Code");

            if "Minimum Taxable Amount" > 0 then
                if "Total Tax Exemption" < "Minimum Taxable Amount" then
                    "Total Tax Exemption" := "Minimum Taxable Amount";


            if "Maximum Taxable Amount" > 0 then
                if "Total Tax Exemption" > "Maximum Taxable Amount" then
                    "Total Tax Exemption" := "Maximum Taxable Amount";


            "Tax Amount" := Round("Tax %" / 100 * "Taxable Amount", 1, '>');

            if "Minimum Tax" > 0 then
                if "Tax Amount" < "Minimum Tax" then
                    "Tax Amount" := "Minimum Tax";

            if "Maximum Tax" > 0 then
                if "Tax Amount" > "Maximum Tax" then
                    "Tax Amount" := "Maximum Tax";*/

        end;

        /*
        ReceiptsPayments.RESET;
        ReceiptsPayments.SETRANGE(ReceiptsPayments.Code,"Payment Types");
        IF ReceiptsPayments.FINDFIRST THEN BEGIN
        
            "Tax Exempt":=ReceiptsPayments."Daily Tax Exempt. Amount";
        
            IF "Daily Rate(Amount)" < "Tax Exempt" THEN
                "Tax Exempt" := "Daily Rate(Amount)";
        
           "Total Tax Exemption" := "No of Days"*"Tax Exempt";
        
            Amount := "No of Days" * "Daily Rate(Amount)";
            "Taxable Amount" := Amount - "Total Tax Exemption";
        
            IF TariffCodes.GET(ReceiptsPayments."Withholding Tax Code") THEN
                "Tax Amount" := ROUND(TariffCodes.Percentage/100 * "Taxable Amount",1,'>');
        
        END;
        */




        /*
        IF Members.GET("Member No.") THEN BEGIN
            "Staff No." := Members."Payroll/Staff No.";
        
            {
            //Get the Emp No
            HREmployees.RESET;
            HREmployees.SETRANGE(HREmployees."No.",Members."Payroll/Staff No.");
            IF HREmployees.FIND('-') THEN BEGIN
                //EmpNo:=objCust."Employee Job Group"
                EmpGrade := HREmployees.Grade;
            END;
        
        
            //get the destination rate for the grade
            objDestRateEntry.RESET;
            objDestRateEntry.SETRANGE(objDestRateEntry."Destination Code","Destination Code");
            objDestRateEntry.SETRANGE(objDestRateEntry."Advance Code","Payment Types");
            IF objDestRateEntry.FIND('-') THEN BEGIN
                "Daily Rate(Amount)":=objDestRateEntry."Daily Rate (Amount)";
                VALIDATE(Amount,objDestRateEntry."Daily Rate (Amount)"*"No of Days");
            END;
            }
        END;
        */


        "Net Amount" := Amount - "Tax Amount";

    end;
}

