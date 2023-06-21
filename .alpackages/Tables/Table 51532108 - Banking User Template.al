table 51532108 "Banking User Template"
{
    //DrillDownPageID = "Banking User Setup";
    //LookupPageID = "Banking User Setup";

    fields
    {
        field(1; UserID; Code[50])
        {
            NotBlank = true;
            TableRelation = "User Setup"."User ID";


            trigger OnValidate()
            begin
                //LoginMgt.ValidateUserID(UserID);

                Usetup.Get(UserID);
                //"Shortcut Dimension 1 Code" := Usetup."Global Dimension 1 Code";
                //"Shortcut Dimension 1 Code" := Usetup."Global Dimension 2 Code";
            end;
        }
        field(2; "Cashier Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(3; "Cashier Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cashier Journal Template"));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Cashier Journal Template", "Cashier Journal Template");
                UserTemp.SetRange(UserTemp."Cashier Journal Batch", "Cashier Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Cashier Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(4; "Salary Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(5; "Salary Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Salary Journal Template"));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(6; "Default  Bank"; Code[20])
        {
            //TableRelation = "Bank Account" WHERE("Bank Type" = FILTER(Cashier | Treasury));

            trigger OnValidate()
            begin
                if "Default  Bank" <> '' then begin
                    UserTemp.Reset;
                    UserTemp.SetRange(UserTemp."Default  Bank", "Default  Bank");
                    if UserTemp.FindFirst then begin
                        repeat
                            if UserTemp.UserID <> Rec.UserID then begin
                                Error('Please note that another user has been assigned the same bank.');
                            end;
                        until UserTemp.Next = 0;
                    end;

                end;
            end;
        }
        field(7; "Loans Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(8; "Loans Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loans Template"));
        }
        field(9; "Check Off Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(10; "Check Off Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Check Off Template"));
        }
        field(11; "Max. Deposit Limit"; Decimal)
        {
        }
        field(12; "Max. Withdrawal Limit"; Decimal)
        {
        }
        field(13; "Max. Cashier Withholding"; Decimal)
        {
        }
        field(14; "Min. Balance"; Decimal)
        {
        }
        field(15; "Member No."; Code[20])
        {
            TableRelation = Members;

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Member No.", "Member No.");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Member No." <> '') then begin
                            Error('Please note that another user has been assigned the same member No.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(16; "Bankers Cheque Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(17; Type; Option)
        {
            OptionCaption = ' ,Cashier,Treasury';
            OptionMembers = " ",Cashier,Treasury;

            trigger OnValidate()
            begin
                "Default  Bank" := '';
            end;
        }
        field(18; "MPESA Disbursement A/c"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(19; "Cheque Disbursement A/c"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(20; "Bills Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(21; "Bills Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Bills Template"));
        }
        field(22; "Over Draft Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(23; "Over Draft Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cashier Journal Template"));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Over Draft Template", "Over Draft Template");
                UserTemp.SetRange(UserTemp."Over Draft Batch", "Over Draft Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Over Draft Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(24; "No of Open Transactions"; Integer)
        {
        }
        field(25; "Interest Account Template"; Code[20])
        {
            Caption = 'Interest Account Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = FILTER(General | "Cash Receipts"));
        }
        field(26; "Interest Account Batch"; Code[20])
        {
            Caption = 'Interest Account Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Interest Account Template"));
        }
        field(27; "Transfer Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = FILTER("Cash Receipts" | General));
        }
        field(28; "Transfer Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Transfer Journal Template"));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Transfer Journal Template", "Transfer Journal Template");
                UserTemp.SetRange(UserTemp."Transfer Journal Batch", "Transfer Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Transfer Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(29; "Excess Account"; Code[20])
        {
            // TableRelation = Customer."No." WHERE("Account Type" = CONST("Cashier Excess"));
            //TableRelation = "Bank Account"."No." where("Bank Type" = const(Cashier), "Till Type" = const(Excess));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Excess Account", "Excess Account");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Excess Account" <> '') then begin
                            Error('Please note that another user has been assigned the same Account');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(30; "Shortage Account"; Code[20])
        {
            //TableRelation = Customer."No." WHERE("Account Type" = CONST("Cashier Shortage"));
            //TableRelation = "Bank Account"."No." where("Bank Type" = const(Cashier), "Till Type" = const(Shortage));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Shortage Account", "Shortage Account");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Shortage Account" <> '') then begin
                            Error('Please note that another user has been assigned the same Account');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(31; "Cheque Clearance Account"; Code[20])
        {
            // TableRelation = "Bank Account" WHERE("Bank Type" = FILTER(Normal));
        }
        field(32; "ATM Charges Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(33; "ATM Charges Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("ATM Charges Journal Template"));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(34; "Cheque Discounting Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(35; "Cheque Discounting Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cheque Discounting Template"));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Cheque Discounting Template", "Cheque Discounting Template");
                UserTemp.SetRange(UserTemp."Cheque Discounting Batch", "Cheque Discounting Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Cheque Discounting Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(36; "Supervisor Mobile No"; Code[13])
        {
            CharAllowed = '0123456789';
        }
        field(37; "Supervisor E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(38; "Delegates Pay.Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Purchases));
        }
        field(39; "Delegates Pay. Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Delegates Pay.Journal Template"));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(40; "Accrual. Fee.Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Purchases));
        }
        field(41; "Accrual. Fee. Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Accrual. Fee.Journal Template"));

            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(42; "Responsibility Centre"; Code[20])
        {
            //CalcFormula = Lookup("User Setup"."Responsibility Centre" WHERE("User ID" = FIELD(UserID)));
            Editable = false;
            //FieldClass = FlowField;
        }
        field(43; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(44; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(45; "Default  Cheque Bank"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin

                if "Default  Cheque Bank" <> '' then begin
                    UserTemp.Reset;
                    UserTemp.SetRange(UserTemp."Default  Cheque Bank", "Default  Cheque Bank");
                    if UserTemp.FindFirst then begin
                        repeat
                            if UserTemp.UserID <> Rec.UserID then begin
                                //ERROR('Please note that another user has been assigned the same bank.');
                            end;
                        until UserTemp.Next = 0;
                    end;

                end
            end;
        }
        field(46; "MPesa Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(47; "MPesa Customer Account"; Code[20])
        {
            TableRelation = Customer;
        }
        field(48; "Shop Customer Account"; Code[20])
        {
            TableRelation = Customer;
        }
        field(49; "MPESA Transaction Limit"; Decimal)
        {
        }
        field(50; "Max. MPESA Withholding"; Decimal)
        {
        }
        field(51; "Chief Accountant"; Boolean)
        {
        }
        field(52; "Chief Cashier"; Boolean)
        {
        }
        field(53; "Cust. Service Cheque Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(54; "Yetu Cheque GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(55; "Co-op Jirani Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(56; "Co-op Jirani Customer Account"; Code[20])
        {
            TableRelation = Customer;
        }
    }

    keys
    {
        key(Key1; UserID)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; UserID, "Default  Bank", Type)
        {
        }
    }

    var
        LoginMgt: Codeunit "User Management";
        UserTemp: Record "Banking User Template";
        Usetup: Record "User Setup";
}

