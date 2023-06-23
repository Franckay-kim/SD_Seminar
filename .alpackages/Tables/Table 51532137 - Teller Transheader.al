/// <summary>
/// Table Teller Transheader (ID 51532137).
/// </summary>
table 51532137 "Teller Transheader"
{
    //DrillDownPageID = 39004257;
    //LookupPageID = 39004257;

    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                IF No <> xRec.No THEN BEGIN
                  NoSetup.GET();
                  NoSeriesMgt.TestManual(NoSetup."Teller Bulk Trans Nos.");
                  "No. Series" := '';
                END;
                */

            end;
        }
        field(2; "No. Series"; Code[20])
        {
        }
        field(3; Posted; Boolean)
        {
            Editable = false;
        }
        field(4; "Posted By"; Code[20])
        {
            Editable = false;
        }
        field(5; "Date Entered"; Date)
        {
        }
        field(6; "Entered By"; Text[20])
        {
        }
        field(7; Remarks; Text[150])
        {
        }
        field(8; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(9; "Time Entered"; Time)
        {
        }
        field(10; "Posting date"; Date)
        {
        }
        field(11; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(12; "Account No"; Code[30])
        {
            TableRelation = "Savings Accounts"."No.";

            trigger OnValidate()
            begin
                /*  BANKACC.RESET;
                  BANKACC.SETRANGE(BANKACC."No.","Account No");
                  BANKACC.SETRANGE(BANKACC.CashierID,USERID );
                  IF BANKACC.FIND('-') THEN BEGIN
                  "Account Name":=BANKACC.Name;
                  END ELSE
                ERROR('You need a till for this transaction')
                */

            end;
        }
        field(13; "Document No"; Code[20])
        {
        }
        field(14; Amount; Decimal)
        {
        }
        field(15; "Account Name"; Code[50])
        {
        }
        field(16; "Employer Code"; Code[30])
        {
        }
        field(17; "Document Date"; Date)
        {
        }
        field(18; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Teller Translines".Amount WHERE("Teller Transheader No" = FIELD(No)));
            FieldClass = FlowField;
        }
        field(19; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(20; "Scheduled Amount"; Decimal)
        {
        }
        field(21; "Transacted by"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //IF Posted = TRUE THEN
        //ERROR('You cannot delete a Posted Check Off');
        /*
        IF "Entered By" <> UPPERCASE(USERID) THEN
        ERROR('Cannot delete a transaction being processed by %1',"Entered By");
                   */

    end;

    trigger OnInsert()
    begin
        /*
        IF No = '' THEN BEGIN
        NoSetup.GET();
        NoSetup.TESTFIELD(NoSetup."Teller Bulk Trans Nos.");
        NoSeriesMgt.InitSeries(NoSetup."Teller Bulk Trans Nos.",xRec."No. Series",0D,No,"No. Series");
        END;
        
         "Document Date":=TODAY;
         "Document No":=No;
         "Posting date":=TODAY;
         "Entered By":=USERID;
        "Account Type":="Account Type"::"Bank Account";
        "Time Entered":=TIME;
        */

    end;

    trigger OnModify()
    begin
        //IF Posted = TRUE THEN
        //ERROR('You cannot modify a Posted Check Off');
        /*
      //Cyrus
      IF "Entered By" <> UPPERCASE(USERID) THEN
      ERROR('Cannot modify a transaction being processed by %1',"Entered By");
      */

    end;

    trigger OnRename()
    begin
        //IF Posted = TRUE THEN
        //ERROR('You cannot rename a Posted Check Off');
        /*
     IF "Entered By" <> UPPERCASE(USERID) THEN
     ERROR('Cannot rename a transaction being processed by %1',"Entered By");
         */

    end;

    var
        NoSetup: Record "Dividend Instructions - Member";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        cust: Record "Social Listening Sites App.";
        "GL Account": Record "G/L Account";
        BANKACC: Record "Bank Account";
}

