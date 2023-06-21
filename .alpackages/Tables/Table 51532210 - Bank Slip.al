table 51532210 "Bank Slip"
{
    
    fields
    {
        field(1;No;Code[20])
        {

            trigger OnValidate()
            begin

                if No <> xRec.No then begin
                  GenLedgerSetup.Get;
                  NoSeriesMgt.TestManual(GenLedgerSetup."Bank Deposit No.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Date;Date)
        {
        }
        field(8;"From Bank Code";Code[20])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin

                BankAcc.Reset;
                if BankAcc.Get("From Bank Code") then
                  begin
                    "From Account Name":=BankAcc.Name;
                  end;
            end;
        }
        field(9;"Received From";Text[100])
        {
        }
        field(13;"To Bank Code";Code[20])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin

                BankAcc.Reset;
                if BankAcc.Get("To Bank Code") then
                  begin
                    "To Account Name":=BankAcc.Name;
                  end;
            end;
        }
        field(14;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15;"From Account Name";Text[50])
        {
        }
        field(16;Posted;Boolean)
        {
        }
        field(17;"Date Posted";Date)
        {
        }
        field(18;"Time Posted";Time)
        {
        }
        field(19;"Posted By";Code[50])
        {
        }
        field(20;Amount;Decimal)
        {
        }
        field(21;Remarks;Text[50])
        {
        }
        field(26;"Source Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                /*
                    IF "Bank Pay in Type"="Bank Pay in Type"::" " THEN
                     ERROR('Bank Pay in Type should NOT be blank');
                */
                      DimVal.Reset;
                      DimVal.SetRange(DimVal.Code,"Source Dimension 1 Code");
                      if DimVal.Find('-') then
                           "Source Dimension 1 Name":=DimVal.Name;

            end;
        }
        field(27;"Source Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                /*
                    IF "Bank Pay in Type"="Bank Pay in Type"::" " THEN
                     ERROR('Bank Pay in Type should NOT be blank');
                */
                      DimVal.Reset;
                      DimVal.SetRange(DimVal.Code,"Source Dimension 2 Code");
                      if DimVal.Find('-') then
                           "Source Dimension 2 Name":=DimVal.Name;

            end;
        }
        field(28;"Source Dimension 1 Name";Text[60])
        {
            Editable = false;
        }
        field(29;"Source Dimension 2 Name";Text[60])
        {
            Editable = false;
        }
        field(30;"Destination Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                /*
                    IF "Bank Pay in Type"="Bank Pay in Type"::" " THEN
                     ERROR('Bank Pay in Type should NOT be blank');
                */
                      DimVal.Reset;
                      DimVal.SetRange(DimVal.Code,"Source Dimension 1 Code");
                      if DimVal.Find('-') then
                           "Source Dimension 1 Name":=DimVal.Name;

            end;
        }
        field(31;"Destination Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                /*
                    IF "Bank Pay in Type"="Bank Pay in Type"::" " THEN
                     ERROR('Bank Pay in Type should NOT be blank');
                */
                      DimVal.Reset;
                      DimVal.SetRange(DimVal.Code,"Source Dimension 2 Code");
                      if DimVal.Find('-') then
                           "Source Dimension 2 Name":=DimVal.Name;

            end;
        }
        field(32;"Destination Dimension 1 Name";Text[60])
        {
            Editable = false;
        }
        field(33;"Destination Dimension 2 Name";Text[60])
        {
            Editable = false;
        }
        field(34;"To Account Name";Text[50])
        {
        }
        field(35;"Pay In Bank Template Name";Code[10])
        {
            Caption = 'Inter Bank Template Name';
            NotBlank = true;
            TableRelation = "Gen. Journal Template";
        }
        field(36;"Pay In Bank Journal Batch";Code[10])
        {
            Caption = 'Inter Bank Journal Batch';
            NotBlank = true;
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Pay In Bank Template Name"));
        }
        field(37;"Bank Pay in Type";Option)
        {
            OptionMembers = " ",Cash,Cheque;
        }
        field(38;"Bank Slip No.";Code[20])
        {
            Description = 'Stores the reference of the bank pay in slip no in the database';
        }
        field(39;"Confirmed Amount";Decimal)
        {
            CalcFormula = Sum("Bank Slip Line".Amount WHERE (No=FIELD(No),
                                                             Select=CONST(true)));
            FieldClass = FlowField;
        }
        field(40;Status;Option)
        {
            OptionMembers = New,Confirmation,Posted;
        }
        field(41;Vaulted;Boolean)
        {
        }
        field(42;"Return Remarks";Text[250])
        {
        }
        field(43;"Created By";Code[50])
        {
        }
        field(44;"Created Date";Date)
        {
        }
        field(45;"Created Time";Time)
        {
        }
        field(46;"Created Machine";Text[100])
        {
        }
        field(47;"Current Source A/C Bal.";Decimal)
        {
        }
        field(48;"Register Number";Integer)
        {
        }
        field(49;"From Entry No.";Integer)
        {
        }
        field(50;"To Entry No.";Integer)
        {
        }
        field(51;"Document Date";Date)
        {
        }
        field(85;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";

            trigger OnValidate()
            begin
                /*
                TESTFIELD(Status,Status::Pending);
                
                IF PayLinesExist THEN BEGIN
                  ERROR('You first need to delete the existing Payment lines before changing the Responsibility Center');
                END ELSE BEGIN
                  "Currency Code":='';
                  VALIDATE("Currency Code");
                  "Paying Bank Account":='';
                  VALIDATE("Paying Bank Account");
                END;
                
                
                IF NOT UserMgt.CheckRespCenter(1,"Responsibility Center") THEN
                  ERROR(
                    Text001,
                    RespCenter.TABLECAPTION,UserMgt.GetPurchasesFilter);
                 {
                "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
                IF "Location Code" = '' THEN BEGIN
                  IF InvtSetup.GET THEN
                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                END ELSE BEGIN
                  IF Location.GET("Location Code") THEN;
                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                END;
                
                UpdateShipToAddress;
                   }
                   {
                CreateDim(
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::Vendor,"Pay-to Vendor No.",
                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                  DATABASE::Campaign,"Campaign No.");
                
                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                  RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                  "Assigned User ID" := '';
                END;
                  }
                */

            end;
        }
        field(86;"Currency Code";Code[10])
        {
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if No = '' then begin
          GenLedgerSetup.Get;
          GenLedgerSetup.TestField(GenLedgerSetup."Bank Deposit No.");
          NoSeriesMgt.InitSeries(GenLedgerSetup."Bank Deposit No.",xRec."No. Series",0D,No,"No. Series");

          //get the creation details
            "Created By":=UserId;
            "Created Date":=Today;
            "Created Time":=Time;
        //    "Created Machine":=ENVIRON('COMPUTERNAME');
        end;
    end;

    var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        CashierLinks: Record "Cash Office User Template";
        DimVal: Record "Dimension Value";
        TempBatch: Record "Cash Office User Template";
}

