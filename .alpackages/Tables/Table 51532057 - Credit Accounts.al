/// <summary>
/// Table Credit Accounts (ID 51532057).
/// </summary>
table 51532057 "Credit Accounts"
{
    Caption = 'Credit Account';
    DataCaptionFields = "No.", Name;
    //DrillDownPageID = "Credit Accounts List";
    //LookupPageID = "Credit Accounts List";
    Permissions = TableData "Cust. Ledger Entry" = r;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; "Current Address"; Text[50])
        {
            Caption = 'Address';
        }
        field(6; City; Text[30])
        {
            Caption = 'City';
        }
        field(7; Contact; Text[50])
        {
            Caption = 'Contact';
        }
        field(8; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            CharAllowed = '0123456789';
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
        }
        field(14; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(15; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Customer),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ",Credit,Debit,All;
        }
        field(17; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(18; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(19; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(20; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(21; Balance; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Customer No." = FIELD("No."),
                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                  "Transaction Type" = FILTER(Loan | Repayment)));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Transaction Type" = FILTER(Loan | Repayment)));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Credit Ledger Entry".Amount WHERE("Customer No." = FIELD("No."),
                                                                   "Posting Date" = FIELD("Date Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                           "Posting Date" = FIELD("Date Filter")));
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Balance Due"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Balance Due';
            Editable = false;
            Enabled = false;
            FieldClass = Normal;
        }
        field(26; "Balance Due (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance Due (LCY)';
            Editable = false;
        }
        field(27; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(28; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(29; County; Text[30])
        {
            Caption = 'County';
        }
        field(30; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE("Customer No." = FIELD("No."),
                                                                                 "Entry Type" = FILTER(<> Application),
                                                                                 "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount" WHERE("Customer No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER(<> Application),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                       "Entry Type" = FILTER(<> Application),
                                                                                       "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                       "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                       "Posting Date" = FIELD("Date Filter"),
                                                                                       "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                        "Entry Type" = FILTER(<> Application),
                                                                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                        "Posting Date" = FIELD("Date Filter"),
                                                                                        "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(35; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(36; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(37; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(38; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";
        }
        field(39; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(40; Status; Option)
        {
            OptionCaption = ' ,New,Active,Dormant,Frozen,Withdrawal Application,Withdrawn,Deceased,Defaulter,Closed,Blocked';
            OptionMembers = " ",New,Active,Dormant,Frozen,"Withdrawal Application",Withdrawn,Deceased,Defaulter,Closed,Blocked;
        }
        field(41; "Employer Code"; Code[50])
        {
        }
        field(42; "Date of Birth"; Date)
        {
        }
        field(43; "E-Mail (Personal)"; Text[50])
        {
        }
        field(44; "Home Address"; Text[50])
        {
        }
        field(45; "Payroll/Staff No."; Code[20])
        {
            FieldClass = Normal;
        }
        field(46; "ID No."; Code[50])
        {
        }
        field(47; "Mobile Phone No"; Code[50])
        {
            CharAllowed = '0123456789';
        }
        field(48; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Divorced,Widower,Widow;
        }
        field(49; Signature; BLOB)
        {
            Caption = 'Signature';
            SubType = Bitmap;
        }
        field(50; "Passport No."; Code[50])
        {
        }
        field(51; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(52; "Monthly Contribution"; Decimal)
        {
        }
        field(53; "Outstanding Interest"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                          "Transaction Type" = FILTER("Interest Paid" | "Interest Due")));
            Description = 'Check Flow field';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Account Category"; Option)
        {
            OptionCaption = 'Member, Staff Account,Board Members,Delegates';
            OptionMembers = Member," Staff Account","Board Members",Delegates;
        }
        field(55; "Type Of Organisation"; Option)
        {
            OptionCaption = ' ,Club,Association,Partnership,Investment,Merry go round,Other,Group';
            OptionMembers = " ",Club,Association,Partnership,Investment,"Merry go round",Other,Group;
        }
        field(56; "MPESA Mobile No"; Code[20])
        {
        }
        field(57; "Group Account No"; Code[20])
        {
            Description = 'Check Relation';
            TableRelation = Members."No." WHERE("Group Account" = CONST(true));
        }
        field(58; Membership; Option)
        {
            OptionCaption = ' ,Ordinary,Preferential';
            OptionMembers = " ",Ordinary,Preferential;
        }
        field(59; "Group Account"; Boolean)
        {
        }
        field(60; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
        }
        field(61; "Member No."; Code[20])
        {
        }
        field(62; "Product Name"; Text[50])
        {
        }
        field(63; "Can Guarantee Loan"; Boolean)
        {
        }
        field(64; "Loan Disbursement Account"; Boolean)
        {
        }
        field(65; "Loan Security Inclination"; Option)
        {
            OptionCaption = ' ,Short Loan Security,Long Term Loan Security,Share Capital';
            OptionMembers = " ","Short Term Loan Security","Long Term Loan Security","Share Capital";
        }
        field(66; "ATM Transactions"; Decimal)
        {
        }
        field(68; "Relates to Business/Group"; Boolean)
        {
        }
        field(69; "Company Registration No."; Code[20])
        {
        }
        field(70; "Birth Certificate No."; Code[20])
        {
        }
        field(72; "Created By"; Code[50])
        {
        }
        field(73; "Outstanding Bills"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                          "Transaction Type" = FILTER(Bills)));
            Description = 'Check Flow field';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";
        }
        field(90; "Recruited by Type"; Option)
        {
            OptionCaption = 'Marketer,Others';
            OptionMembers = Marketer,Others;
        }
        field(50004; "Relationship Manager"; Code[10])
        {
            TableRelation = "HR Employees" WHERE(Status = FILTER(Active));
        }
        field(39004241; "Last Transaction Date"; Date)
        {
            CalcFormula = Max("Savings Ledger Entry"."Posting Date" WHERE("Customer No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(39004242; Classification; Option)
        {
            OptionCaption = ' ,Good Standing,Bad Standing';
            OptionMembers = " ","Good Standing","Bad Standing";
        }
        field(39004243; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(39004244; "Customer CID"; Code[20])
        {
        }
        field(39004245; "Old Member No."; Code[20])
        {
        }
        field(39004246; "Recruited By Name"; Text[100])
        {
        }
        field(39004325; "Special Account"; Boolean)
        {
            CalcFormula = Lookup(Members."Special Member" WHERE("No." = FIELD("Member No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; Name)
        {
        }
        key(Key4; Contact)
        {
        }
        key(Key5; "Global Dimension 1 Code")
        {
        }
        key(Key6; "Phone No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Product Name", "No.", Name, "Product Type")
        {
        }
    }

    trigger OnDelete()
    var
        CampaignTargetGr: Record "Campaign Target Group";
        ContactBusRel: Record "Contact Business Relation";
        Job: Record Job;
        CampaignTargetGrMgmt: Codeunit "Campaign Target Group Mgt";
        StdCustSalesCode: Record "Standard Customer Sales Code";
    begin
        DimMgt.DeleteDefaultDim(DATABASE::Customer, "No.");
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.';
        Text002: Label 'Do you wish to create a contact for %1 %2?';
        CommentLine: Record "Comment Line";
        SalesOrderLine: Record "Sales Line";
        CustBankAcc: Record "Customer Bank Account";
        ShipToAddr: Record "Ship-to Address";
        PostCode: Record "Post Code";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        ShippingAgentService: Record "Shipping Agent Services";
        //ItemCrossReference: Record "Item Cross Reference";
        RMSetup: Record "Marketing Setup";
        //SalesPrice: Record "Sales Price";
        //SalesLineDisc: Record "Sales Line Discount";
        SalesPrepmtPct: Record "Sales Prepayment %";
        ServContract: Record "Service Contract Header";
        ServHeader: Record "Service Header";
        ServiceItem: Record "Service Item";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MoveEntries: Codeunit MoveEntries;
        UpdateContFromCust: Codeunit "CustCont-Update";
        DimMgt: Codeunit DimensionManagement;
        InsertFromContact: Boolean;
        Text003: Label 'Contact %1 %2 is not related to customer %3 %4.';
        Text004: Label 'post';
        Text005: Label 'create';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        Text007: Label 'You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.';
        Text008: Label 'Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?';
        Text009: Label 'Cannot delete customer.';
        Text010: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.';
        Text011: Label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
        Text012: Label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
        Text013: Label 'You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';
        Text014: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text015: Label 'You cannot delete %1 %2 because there is at least one %3 associated to this customer.';
        Loans: Record Loans;
        MinShares: Decimal;
        Cust: Record "Credit Accounts";
        Vend: Record Vendor;
        CustFosa: Code[20];
        Vend2: Record Vendor;
        FOSAAccount: Record Vendor;
        Text001: Label 'You cannot delete %1 %2 because there is at least one transaction %3 for this customer.';
        IntRate: Decimal;
        DocNo: Code[10];
        PDate: Date;
        IntBufferNo: Integer;
        MidMonthFactor: Decimal;
        DaysInMonth: Integer;
        StartDate: Date;
        IntDays: Integer;
        AsAt: Date;
        MinBal: Boolean;
        AccruedInt: Decimal;
        RIntDays: Integer;
        Bal: Decimal;
        Rate: Decimal;
        "Sacco Account": Record "Credit Accounts";
        ProductFactory: Record "Product Factory";
        Account: Record "Savings Accounts";
        Text016: Label 'You cannot Modify %1 %2 because there is at least one transaction %3 for this Member.';

    /// <summary>
    /// TestNoEntriesExist.
    /// </summary>
    /// <param name="CurrentFieldName">Text[100].</param>
    /// <param name="GLNO">Code[20].</param>
    procedure TestNoEntriesExist(CurrentFieldName: Text[100]; GLNO: Code[20])
    var
        MemberLedgEntry: Record "Credit Ledger Entry";
    begin
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Customer No.");
        MemberLedgEntry.SetRange(MemberLedgEntry."Customer No.", "No.");
        if MemberLedgEntry.Find('-') then
            Error(
            Text016,
             CurrentFieldName, "No.", Name);
    end;

    procedure AssistEdit(OldCust: Record "Credit Accounts"): Boolean
    var
        Cust: Record "Credit Accounts";
    begin

    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    procedure ShowContact()
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
        if "No." = '' then
            exit;

        ContBusRel.SetCurrentKey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SetRange("No.", "No.");
        if not ContBusRel.FindFirst then begin
            if not Confirm(Text002, false, TableCaption, "No.") then
                exit;
            //UpdateContFromCust.InsertNewContact(Rec,FALSE);
            ContBusRel.FindFirst;
        end;
        Commit;

        Cont.SetCurrentKey("Company Name", "Company No.", Type, Name);
        Cont.SetRange("Company No.", ContBusRel."Contact No.");
        PAGE.Run(PAGE::"Contact List", Cont);
    end;

    /// <summary>
    /// SetInsertFromContact.
    /// </summary>
    /// <param name="FromContact">Boolean.</param>
    procedure SetInsertFromContact(FromContact: Boolean)
    begin
        InsertFromContact := FromContact;
    end;

    procedure CheckBlockedCustOnDocs(Cust2: Record "Credit Accounts"; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; Shipment: Boolean; Transaction: Boolean)
    begin
        //WITH Cust2 DO BEGIN
        // IF ((Blocked = Blocked::All) OR
        //  ((Blocked = Blocked::Invoice) AND (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"])) OR
        //((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::"Blanket Order"]) AND
        // (NOT Transaction)) OR
        // ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"]) AND
        // Shipment AND Transaction))
        //THEN
        //  CustBlockedErrorMessage(Cust2,Transaction);
        //END;
    end;

    procedure CheckBlockedCustOnJnls(Cust2: Record "Credit Accounts"; DocType: Enum "Gen. Journal Document Type"; Transaction: Boolean)
    begin

        begin
            if (Cust2.Blocked = Cust2.Blocked::All) or
               ((Cust2.Blocked = Cust2.Blocked::Debit) and (DocType in [DocType::Invoice, DocType::" "]))
            then
                CustBlockedErrorMessage(Cust2, Transaction)
        end;
    end;

    /// <summary>
    /// CustBlockedErrorMessage.
    /// </summary>
    /// <param name="Cust2">Record "Credit Accounts".</param>
    /// <param name="Transaction">Boolean.</param>
    procedure CustBlockedErrorMessage(Cust2: Record "Credit Accounts"; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        if Transaction then
            Action := Text004
        else
            Action := Text005;
        Error(Text006, Action, Cust2."No.", Cust2.Blocked);
    end;

    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.FindFirst then
            MapMgt.MakeSelection(DATABASE::Customer, GetPosition)
        else
            Message(Text014);
    end;

    procedure GetTotalAmountLCY(): Decimal
    begin
        ///CALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
         // "Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

        //EXIT(GetTotalAmountLCYCommon);
    end;

    procedure GetTotalAmountLCYUI(): Decimal
    begin
        //SETAUTOCALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
        //"Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

        //EXIT(GetTotalAmountLCYCommon);
    end;

    local procedure GetTotalAmountLCYCommon(): Decimal
    var
        SalesLine: Record "Sales Line";
        ServiceLine: Record "Service Line";
        SalesOutstandingAmountFromShipment: Decimal;
        ServOutstandingAmountFromShipment: Decimal;
        InvoicedPrepmtAmountLCY: Decimal;
    begin
        //SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
        //ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment("No.");
        //InvoicedPrepmtAmountLCY := GetInvoicedPrepmtAmountLCY;

        //EXIT("Balance (LCY)" + "Outstanding Orders (LCY)" + "Shipped Not Invoiced (LCY)" + "Outstanding Invoices (LCY)" +
        //"Outstanding Serv. Orders (LCY)" + "Serv Shipped Not Invoiced(LCY)" + "Outstanding Serv.Invoices(LCY)" -
        // SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment - InvoicedPrepmtAmountLCY);
    end;

    procedure GetSalesLCY(): Decimal
    var
        CustomerSalesYTD: Record Customer;
        AccountingPeriod: Record "Accounting Period";
        StartDate: Date;
        EndDate: Date;
    begin
        //StartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
        //EndDate := AccountingPeriod.GetFiscalYearEndDate(WORKDATE);
        //CustomerSalesYTD := Rec;
        //CustomerSalesYTD."SECURITYFILTERING"("SECURITYFILTERING");
        //CustomerSalesYTD.SETRANGE("Date Filter",StartDate,EndDate);
        //CustomerSalesYTD.CALCFIELDS("Sales (LCY)");
        //EXIT(CustomerSalesYTD."Sales (LCY)");
    end;

    procedure CalcAvailableCredit(): Decimal
    begin
        exit(CalcAvailableCreditCommon(false));
    end;

    /// <summary>
    /// CalcAvailableCreditUI.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcAvailableCreditUI(): Decimal
    begin
        exit(CalcAvailableCreditCommon(true));
    end;

    local procedure CalcAvailableCreditCommon(CalledFromUI: Boolean): Decimal
    begin
        //IF "Credit Limit (LCY)" = 0 THEN
        // EXIT(0);
        //IF CalledFromUI THEN
        // EXIT("Credit Limit (LCY)" - GetTotalAmountLCYUI);
        //EXIT("Credit Limit (LCY)" - GetTotalAmountLCY);
    end;

    procedure CalcOverdueBalance() OverDueBalance: Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        CustLedgEntryRemainAmtQuery: Query "Cust. Ledg. Entry Remain. Amt.";
    begin
        CustLedgEntryRemainAmtQuery.SetRange(Customer_No, "No.");
        CustLedgEntryRemainAmtQuery.SetRange(IsOpen, true);
        CustLedgEntryRemainAmtQuery.SetFilter(Due_Date, '<%1', WorkDate);
        CustLedgEntryRemainAmtQuery.Open;

        if CustLedgEntryRemainAmtQuery.Read then
            OverDueBalance := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    end;

    /// <summary>
    /// GetLegalEntityType.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetLegalEntityType(): Text
    begin
        //EXIT(FORMAT("Partner Type"));
    end;

    procedure GetLegalEntityTypeLbl(): Text
    begin
        //EXIT(FIELDCAPTION("Partner Type"));
    end;

    /// <summary>
    /// SetStyle.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure SetStyle(): Text
    begin
        if CalcAvailableCredit < 0 then
            exit('Unfavorable');
        exit('');
    end;

    /// <summary>
    /// HasValidDDMandate.
    /// </summary>
    /// <param name="Date">Date.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure HasValidDDMandate(Date: Date): Boolean
    var
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
    begin
        exit(SEPADirectDebitMandate.GetDefaultMandate("No.", Date) <> '');
    end;

    /// <summary>
    /// GetInvoicedPrepmtAmountLCY.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetInvoicedPrepmtAmountLCY(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetCurrentKey("Document Type", "Bill-to Customer No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Bill-to Customer No.", "No.");
        SalesLine.CalcSums("Prepmt. Amount Inv. (LCY)", "Prepmt. VAT Amount Inv. (LCY)");
        exit(SalesLine."Prepmt. Amount Inv. (LCY)" + SalesLine."Prepmt. VAT Amount Inv. (LCY)");
    end;

    procedure CalcCreditLimitLCYExpendedPct(): Decimal
    begin
        //IF "Credit Limit (LCY)" = 0 THEN
        // EXIT(0);

        //IF "Balance (LCY)" / "Credit Limit (LCY)" < 0 THEN
        // EXIT(0);

        //IF "Balance (LCY)" / "Credit Limit (LCY)" > 1 THEN
        // EXIT(10000);

        //EXIT(ROUND("Balance (LCY)" / "Credit Limit (LCY)" * 10000,1));
    end;

    procedure CreateAndShowNewInvoice()
    var
        SalesHeader: Record "Sales Header";
    begin
        /*
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUNMODAL(PAGE::"Mini Sales Invoice",SalesHeader)
        */

    end;

    procedure CreateAndShowNewCreditMemo()
    var
        SalesHeader: Record "Sales Header";
    begin
        /*
        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUNMODAL(PAGE::"Mini Sales Credit Memo",SalesHeader)
        */

    end;

    procedure CreateAndShowNewQuote()
    var
        SalesHeader: Record "Sales Header";
    begin
        /*
        SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
        SalesHeader.SETRANGE("Sell-to Customer No.","No.");
        SalesHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUNMODAL(PAGE::"Mini Sales Quote",SalesHeader)
        */

    end;

    local procedure UpdatePaymentTolerance(UseDialog: Boolean)
    begin
        //IF "Block Payment Tolerance" THEN BEGIN
        //IF UseDialog THEN
        // IF NOT CONFIRM(RemovePaymentRoleranceQst,FALSE) THEN
        //  EXIT;
        //PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
        //END ELSE BEGIN
        // IF UseDialog THEN
        //  IF NOT CONFIRM(AllowPaymentToleranceQst,FALSE) THEN
        //   EXIT;
        //PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
        //END;
    end;

    procedure GetBillToCustomerNo(): Code[20]
    begin
        //IF "Bill-to Customer No." <> '' THEN
        // EXIT("Bill-to Customer No.");
        //EXIT("No.");
    end;
}

