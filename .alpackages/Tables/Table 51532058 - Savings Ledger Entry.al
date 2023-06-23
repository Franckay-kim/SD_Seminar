/// <summary>
/// Table Savings Ledger Entry (ID 51532058).
/// </summary>
table 51532058 "Savings Ledger Entry"
{
    //DrillDownPageID = "Savings Ledger Entries";
    //LookupPageID = "Savings Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Customer No."; Code[20])
        {
            TableRelation = "Savings Accounts";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            // OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            // OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(14; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Remaining Amount';
        }
        field(17; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
        }
        field(22; "Posting Group"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;



            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(36; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(43; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(49; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(51; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,,Employee,Savings,Credit';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset",,Employee,Savings,Credit;
        }
        field(52; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            /* TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) Employee
            ELSE
            IF ("Bal. Account Type" = CONST(Savings)) "Savings Accounts"
            ELSE
            IF ("Bal. Account Type" = CONST(Credit)) "Credit Accounts"; */
        }
        field(53; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(58; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(59; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(60; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount (LCY)';
        }
        field(61; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount (LCY)';
        }
        field(62; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(63; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(64; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(65; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "Bank Account Ledger Entry";
        }
        field(66; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "Bank Account Ledger Entry";
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50000; "Group Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Member Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Bulk Process"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Register Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Approver ID"; Code[50])
        {
            CalcFormula = Lookup("Approval Entry"."Approver ID" WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50006; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Loan Disbursement"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39005606; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees";
        }
        field(39005607; "Special Account"; Boolean)
        {
            CalcFormula = Lookup(Members."Special Member" WHERE("No." = FIELD("Member No.")));
            FieldClass = FlowField;
        }
        field(39005608; "Register Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39005609; "Entry Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Post Bank Account Statement for separation of Principle and Interest';
            OptionCaption = 'Normal Entry,Interest Entry';
            OptionMembers = "Normal Entry","Interest Entry";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Customer No.", "Posting Date")
        {
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
        key(Key3; "Customer No.", Open)
        {
        }
        key(Key4; "Document Type", "Customer No.", "Posting Date")
        {
            MaintainSQLIndex = false;
            SumIndexFields = Amount;
        }
        key(Key5; "Document No.", "Posting Date")
        {
        }
        key(Key6; "Transaction No.")
        {
        }
        key(Key7; "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            Enabled = false;
            SumIndexFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "Customer No.", "Posting Date", "Document Type", "Document No.")
        {
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;


    /// <summary>
    /// ShowDimensions.
    /// </summary>
    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
    end;


    /// <summary>
    /// CopyFromGenJnlLine.
    /// </summary>
    /// <param name="GenJnlLine">Record "Gen. Journal Line".</param>
    procedure CopyFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        "Customer No." := GenJnlLine."Account No.";
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        //"Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlLine."Dimension Set ID";
        //"Our Contact Code" := GenJnlLine."Salespers./Purch. Code";
        "Source Code" := GenJnlLine."Source Code";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        //"Reason Code" := GenJnlLine."Reason Code";
        "Currency Code" := GenJnlLine."Currency Code";
        "User ID" := UserId;
        //"Bal. Account Type" := GenJnlLine."Bal. Account Type";
        "Bal. Account No." := GenJnlLine."Bal. Account No.";


        //"Group Code" := GenJnlLine."Group Code";
        //"Member Name" := GenJnlLine."Member Name";
        //"Member No." := GenJnlLine."Member No.";
        "Register Time" := Time;
        "Register Date" := Today;
        //"Loan Disbursement" := GenJnlLine."Loan Disbursement";
        //"Staff No." := GenJnlLine."Staff No.";

        OnAfterCopyFromGenJnlLine(Rec, GenJnlLine);
    end;

    [IntegrationEvent(false, false)]

    /// <summary>
    /// OnAfterCopyFromGenJnlLine.
    /// </summary>
    /// <param name="SavingsLedgerEntry">VAR Record "Savings Ledger Entry".</param>
    /// <param name="GenJournalLine">Record "Gen. Journal Line".</param>
    procedure OnAfterCopyFromGenJnlLine(var SavingsLedgerEntry: Record "Savings Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
}

