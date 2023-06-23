/// <summary>
/// Table Quotation Analysis Header (ID 51533405).
/// </summary>
table 51533405 "Quotation Analysis Header"
{
    // version proc

    //DrillDownPageID = "Quotation Analysis List";
    //LookupPageID = "Quotation Analysis List";

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate();
            var
                NoSetup: Record "Purchases & Payables Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin

                IF "No." <> xRec."No." THEN BEGIN
                    NoSetup.GET();
                    //NoSeriesMgt.TestManual(NoSetup."Bid Analysis No");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Cancelled,Completed';
            OptionMembers = Open,Pending,Approved,Rejected,Cancelled,Completed;
        }
        field(5; "RFQ No."; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No." WHERE(Status = CONST(Released));

            trigger OnValidate();
            var
                PurchQuote: Record "Purchase Quote Header";
                PurchaseQuoteHeader: Record "Purchase Quote Header";
            begin
                TESTFIELD(Status, Status::Open);
                PurchQuote.RESET;
                PurchQuote.SETRANGE(PurchQuote."No.", "RFQ No.");
                IF PurchQuote.FIND('-') THEN BEGIN
                    "Responsibility Center" := PurchQuote."Responsibility Center";
                    "Approved PR" := PurchQuote."Internal Requisition No.";
                    "Shortcut Dimension 1 Code" := PurchQuote."Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PurchQuote."Shortcut Dimension 2 Code";

                END;

                PurchQuote.RESET;
                PurchQuote.SETRANGE(PurchQuote."No.", "RFQ No.");
                IF PurchQuote.FIND('-') THEN
                    RecordLinkManagement.CopyLinks(PurchQuote, Rec);

            end;
        }
        field(6; "Requires Expert Remarks"; Boolean)
        {
        }
        field(7; Remarks; Text[250])
        {
        }
        field(8; "Expert Email"; Text[100])
        {
            Editable = false;
        }
        field(9; Expert; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate();
            var
                UserSetup: Record "User Setup";
            begin
                IF Expert = '' THEN
                    "Expert Email" := '';


                UserSetup.RESET;
                UserSetup.SETRANGE(UserSetup."User ID", Expert);
                IF UserSetup.FIND('-') THEN
                    "Expert Email" := UserSetup."E-Mail";
            end;
        }
        field(10; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(11; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(12; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";
        }
        field(13; "Document Date"; Date)
        {
        }
        field(14; "Created By"; Code[50])
        {
        }
        field(15; "Awarded Quote"; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote),
                                                         //"RFQ No." = FIELD("RFQ No."),
                                                         Status = CONST(Open));

            trigger OnValidate();
            var

                PurchHeader: Record "Purchase Header";
            begin
                IF "Awarded Quote" = '' THEN
                    "Vendor Name" := '' ELSE
                    PurchHeader.RESET;
                PurchHeader.SETRANGE(PurchHeader."No.", "Awarded Quote");
                IF PurchHeader.FIND('-') THEN
                    "Vendor Name" := PurchHeader."Buy-from Vendor Name";
                MODIFY;
            end;
        }
        field(16; "Confirm Next Action"; Option)
        {
            OptionCaption = '" ,Forward to Supplies Officer"';
            OptionMembers = " ","Forward to Supplies Officer";
        }
        field(17; "Supplies Officer"; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate();
            var
                UserSetup: Record "User Setup";
            begin
                IF "Supplies Officer" = '' THEN
                    "Supplies Officer E-Mail" := '';

                UserSetup.RESET;
                UserSetup.SETRANGE(UserSetup."User ID", "Supplies Officer");
                IF UserSetup.FIND('-') THEN
                    "Supplies Officer E-Mail" := UserSetup."E-Mail";
            end;
        }
        field(18; "Supplies Officer E-Mail"; Text[100])
        {
            Editable = false;
        }
        field(19; "Sent to Proc Officer"; Boolean)
        {
        }
        field(20; "Cost Center Name"; Text[100])
        {
        }
        field(21; "Vendor Name"; Text[100])
        {
            Editable = false;
        }
        field(22; "Re-Award Analysis"; Boolean)
        {
        }
        field(50005; "Payment Terms"; Code[20])
        {
            TableRelation = "Payment Terms".Code;
        }
        field(50006; "Delivery Time"; Duration)
        {
        }
        field(50007; "Approved PR"; Code[30])
        {

            trigger OnValidate();
            var
                Analysis: Record "Quotation Analysis Header";
            begin

                IF "Approved PR" <> '' THEN BEGIN
                    Analysis.RESET;
                    Analysis.SETRANGE(Analysis."Approved PR", "Approved PR");
                    IF Analysis.FINDFIRST THEN BEGIN
                        //IF "Re-Award Analysis" = FALSE THEN
                        ERROR(Text100, Analysis."Approved PR", Analysis."No.");
                    END;
                END;
            end;
        }
        field(50008; "Document Type"; Option)
        {
            OptionCaption = 'Quote Analysis Officer';
            OptionMembers = "Quote Analysis Officer";
        }
        field(50009; "Budget Line Name"; Text[100])
        {
        }
        field(50010; "Expert Remarks"; Text[250])
        {

            trigger OnValidate();
            begin
                IF "Expert Remarks" <> ''
                  THEN
                    Remarks := "Expert Remarks";
                IF Expert = '' THEN
                    "Expert Email" := '';
                Expert := USERID;
            end;
        }
        field(50011; "Awarded Quote Amount(LCY)"; Decimal)
        {
        }
        field(50012; "Sent to Finance"; Boolean)
        {
        }
        field(50013; "No. of Quotations Received"; Integer)
        {
        }
        field(50014; "Tender Chair"; Code[50])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate();
            var
                UserSetup: Record "User Setup";
            begin
                IF "Tender Chair" = '' THEN
                    "Tender Chair E-Mail" := '';

                UserSetup.RESET;
                UserSetup.SETRANGE(UserSetup."User ID", "Tender Chair");
                IF UserSetup.FIND('-') THEN
                    "Tender Chair E-Mail" := UserSetup."E-Mail";
            end;
        }
        field(50015; "Tender Chair E-Mail"; Text[100])
        {
            Editable = false;
        }
        field(50016; "Sent to Tender Chair"; Boolean)
        {
        }
        field(50017; "Waiver Approved By"; Text[100])
        {
        }
        field(50018; "LPO No."; Code[50])
        {
            FieldClass = Normal;
        }
        field(50019; "Repeat Order"; Boolean)
        {
        }
        field(50020; "Cancelled By"; Text[50])
        {
        }
        /* field(50021; "Awarded Quote Status"; Option)
         {
             CalcFormula = Lookup("Purchase Header".Status WHERE("Document Type" = CONST(Quote),
                                                                  "No." = FIELD("Awarded Quote")));
             FieldClass = FlowField;
             OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Cancelled';
             OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Cancelled;
         } */
        field(50022; "Awarded Quote Accountant"; Code[50])
        {
            FieldClass = Normal;
        }
        field(50023; "Repeat order Awardee"; Code[20])
        {
        }
        field(50024; "Repeat order RFQ No."; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No.";
        }
        field(50025; "Re-Awarded"; Boolean)
        {
        }
        field(39005610; "Shortcut Dimension 3 Code"; Code[30])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate();
            begin
                // ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            end;
        }
        field(39005611; "Shortcut Dimension 4 Code"; Code[30])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
            end;
        }
        field(39005612; "Shortcut Dimension 5 Code"; Code[30])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(5,"Shortcut Dimension 5 Code");
            end;
        }
        field(39005613; "Shortcut Dimension 6 Code"; Code[30])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(39005614; "Memo No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "RFQ No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            NoSetup.GET();
            //NoSetup.TESTFIELD(NoSetup."Bid Analysis No");
            //NoSeriesMgt.InitSeries(NoSetup."Bid Analysis No", xRec."No. Series", 0D, "No.", "No. Series");
        END;


        "Document Date" := TODAY;
        "Created By" := USERID;
    end;

    var
        NoSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HrEmp: Record "HR Employees";
        UserSetup: Record "User Setup";
        PurchQuote: Record "Purchase Header";
        PurchHeader: Record "Purchase Header";
        RecordLinkManagement: Codeunit "Record Link Management";
        Analysis: Record "Quotation Analysis Header";
        Text100: Label 'The Approved PR No. %1 you are trying to attach has already been picked in another Bid Analysis No %2.';

        PurchaseQuoteHeader: Record "Purchase Quote Header";
}

