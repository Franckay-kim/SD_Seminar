table 51532223 "Payments Header Board"
{

    fields
    {
        field(1; "Transaction No."; Code[10])
        {
        }
        field(2; Amount; Decimal)
        {
        }
        field(3; "Cheque No."; Code[20])
        {
        }
        field(4; "Cheque Date"; Date)
        {
        }
        field(5; Posted; Boolean)
        {
        }
        field(6; "Bank No."; Code[10])
        {
            //TableRelation = "Bank Account"."No." WHERE("Bank Type" = CONST(Cash));
        }
        field(7; "User ID"; Code[50])
        {
        }
        field(8; "Allocated Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line Board".Amount WHERE("Document No" = FIELD("Transaction No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Transaction Date"; Date)
        {
        }
        field(10; "Transaction Time"; Time)
        {
        }
        field(11; "No. Series"; Code[10])
        {
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Posted,Cancelled';
            OptionMembers = Open,"Pending Approval",Approved,Posted,Cancelled;
        }
        field(13; "Posted By"; Code[50])
        {
        }
        field(14; "File Location"; Text[30])
        {
        }
        field(15; Remarks; Text[50])
        {
        }
        field(67; "Pay Mode"; Option)
        {
            OptionCaption = 'FOSA,CASH';
            OptionMembers = FOSA,CASH;
        }
        field(68; "Payment Type"; Option)
        {
            OptionMembers = Board,Staff;
        }
        field(69; "Responsibility Center"; Code[10])
        {
            Editable = true;
            TableRelation = "Responsibility CenterBR";
        }
        field(70; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(71; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(72; "Paying Account"; Code[20])
        {
            /* TableRelation = IF ("Pay Mode" = FILTER(CASH | FOSA),
                                 "Account Type" = CONST("Bank Account")) "Bank Account" WHERE("Bank Type" = FILTER("Petty Cash" | Cash))

             ELSE
             IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true));*/

            trigger OnValidate()
            begin
                "Paying Bank Name" := '';

                if BankAcc.Get("Paying Account") then
                    "Paying Bank Name" := BankAcc.Name;
            end;
        }
        field(73; "Paying Bank Name"; Text[50])
        {
            Editable = false;
        }
        field(74; Committee; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Board Committee";

            trigger OnValidate()
            begin
                "Committee Name" := '';

                if BoardCommittee.FindFirst then
                    "Committee Name" := BoardCommittee.Description;
            end;
        }
        field(75; "Committee Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(76; Allowance; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Committee Allowance Lines"."Allowance Code" WHERE("Header Code" = FIELD(Committee));
        }
        field(77; "Net Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line Board"."Net Amount" WHERE("Document No" = FIELD("Transaction No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Tax Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Line Board"."Tax Amount" WHERE("Document No" = FIELD("Transaction No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "No of Days"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = ToBeClassified;
            //OptionMembers = "G/L Account","Bank Account";
        }
        field(81; "FOSA Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
    }

    keys
    {
        key(Key1; "Transaction No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Oth: Record "OAuth 2.0 Setup";
    begin
        if (Posted) or (Status <> Status::Open) then
            Error('You can only delete an open transaction');
    end;

    trigger OnInsert()
    begin

        if "Transaction No." = '' then begin
            NoSetup.Get();
            if "Payment Type" = "Payment Type"::Board then begin
                NoSetup.TestField(NoSetup."Board PVs Nos.");
                NoSeriesMgt.InitSeries(NoSetup."Board PVs Nos.", xRec."No. Series", 0D, "Transaction No.", "No. Series");
            end
            else
                if "Payment Type" = "Payment Type"::Staff then begin
                    NoSetup.TestField(NoSetup."Staff PV Nos.");
                    NoSeriesMgt.InitSeries(NoSetup."Staff PV Nos.", xRec."No. Series", 0D, "Transaction No.", "No. Series");
                end
        end;

        "Transaction Date" := Today;
        "User ID" := UserId;
        "Transaction Time" := Time;
        UserSetup.Get(UserId);
        //BEGIN
        //UserSetup.TestField("Global Dimension 1 Code");
        // UserSetup.TestField("Global Dimension 2 Code");
        //UserSetup.TestField("Responsibility Centre");

        //"Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        // "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        // "Responsibility Center" := UserSetup."Responsibility Centre";
    end;

    trigger OnModify()
    begin

        if (Posted) or (Status <> Status::Open) then
            Error('You can only modify an open transaction');
    end;

    var
        Cust: Record Members;
        NoSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BOSARcpt: Record "Receipts and Payment Types";
        GLAcct: Record "G/L Account";
        UserSetup: Record "User Setup";
        BankAcc: Record "Bank Account";
        BoardCommittee: Record "Board Committee";
}

