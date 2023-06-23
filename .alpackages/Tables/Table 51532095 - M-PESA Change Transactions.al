/// <summary>
/// Table M-PESA Change Transactions (ID 51532095).
/// </summary>
table 51532095 "M-PESA Change Transactions"
{
    // DrillDownPageID = "MPesa Changes List";
    // LookupPageID = "MPesa Changes List";

    fields
    {
        field(1; No; Code[20])
        {
        }
        field(2; "Transaction Date"; Date)
        {
        }
        field(3; "Initiated By"; Code[50])
        {
        }
        field(4; "MPESA Receipt No"; Code[20])
        {
            TableRelation = "M-PESA Transactions"."Document No." WHERE(Posted = CONST(false),
                                                                        "Transaction Type" = FILTER('Deposit' | 'Funds Transfer'),
                                                                        Reversed = CONST(false));

            trigger OnValidate()
            begin
                MPESATrans.Reset;
                MPESATrans.SetRange(MPESATrans."Document No.", "MPESA Receipt No");
                if MPESATrans.Find('-') then begin
                    "Account No" := MPESATrans."Account No.";
                end;
            end;
        }
        field(5; "Account No"; Code[30])
        {
        }
        field(6; "New Account No"; Code[30])
        {
            TableRelation = IF ("Destination Type" = CONST(Savings)) "Savings Accounts" WHERE("Product Category" = FILTER(<> "Registration Fee" & <> "Fixed Deposit"))
            ELSE
            IF ("Destination Type" = CONST(Loans)) Loans WHERE("Outstanding Balance" = FILTER(> 0));

            trigger OnValidate()
            begin
                if "Destination Type" = "Destination Type"::Loans then begin
                    if Loans.Get("New Account No") then begin
                        "Staff No." := Loans."Staff No";
                        Name := Loans."Member Name";
                    end;
                end;
                if "Destination Type" = "Destination Type"::Savings then begin
                    if SavingsAccounts.Get("New Account No") then begin
                        "Staff No." := SavingsAccounts."Payroll/Staff No.";
                        Name := SavingsAccounts.Name;
                    end;
                end;
            end;
        }
        field(7; Comments; Text[100])
        {
        }
        field(8; "Approved By"; Code[50])
        {
        }
        field(9; "Date Approved"; Date)
        {
        }
        field(10; "Time Approved"; Time)
        {
        }
        field(11; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; Changed; Boolean)
        {
        }
        field(13; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(14; "Sent For Approval By"; Code[50])
        {
        }
        field(15; "Date Sent For Approval"; Date)
        {
        }
        field(16; "Time Sent For Approval"; Time)
        {
        }
        field(17; "Reasons for rejection"; Text[200])
        {
        }
        field(18; "BOSA Account No"; Code[20])
        {
            TableRelation = Members."No.";
        }
        field(19; "Transaction Type"; Option)
        {
            OptionMembers = "Deposit Contribution","Share Capital","Loan Repayment","Benevolent Funds";
        }
        field(20; "Destination Type"; Option)
        {
            OptionCaption = 'Savings,Loans,Invalid Transaction';
            OptionMembers = Savings,Loans,"Invalid Transaction";
        }
        field(21; "Loan Product Type"; Text[100])
        {
        }
        field(22; "App Status"; Option)
        {
            OptionCaption = 'Pending,First Approval,Changed,Rejected';
            OptionMembers = Pending,"First Approval",Changed,Rejected;
        }
        field(23; "Responsibility Centre"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(24; "Valid Transaction"; Option)
        {
            OptionCaption = 'Yes,No';
            OptionMembers = Yes,No;

            trigger OnValidate()
            begin
                if "Valid Transaction" = "Valid Transaction"::No then begin
                    TestField("Destination Type", "Destination Type"::"Invalid Transaction");

                    MSACCOSetup.Reset;
                    MSACCOSetup.SetRange(Type, MSACCOSetup.Type::"Invalid Paybill");
                    if MSACCOSetup.FindFirst then begin
                        if MSACCOSetup.Count <> 1 then
                            Error('System can only have one Invalid Paybill Account');

                        MSACCOSetup.TestField("G/L Account");
                        "New Account No" := MSACCOSetup."G/L Account";
                    end
                    else
                        Error('Invalid Paybill Account not Set Up.');
                end
                else begin
                    "Destination Type" := "Destination Type"::Savings;
                    "New Account No" := '';
                end;
            end;
        }
        field(25; Reversed; Boolean)
        {
        }
        field(26; "Date Reversed"; Date)
        {
        }
        field(27; "Reversed By"; Code[50])
        {
        }
        field(28; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(29; Name; Text[200])
        {
            DataClassification = ToBeClassified;
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
        if Status <> Status::Open then begin
            Error('You cannot delete the MPESA transaction because it has already been sent for first approval.');
        end;
    end;

    trigger OnInsert()
    begin
        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."M-SACCO Change Nos");
            NoSeriesMgt.InitSeries(NoSetup."M-SACCO Change Nos", xRec."No. Series", 0D, No, "No. Series");
        end;

        "Initiated By" := UserId;
        "Transaction Date" := Today;
    end;

    var
        NoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MPESATrans: Record "M-PESA Transactions";
        SavingsAccounts: Record "Savings Accounts";
        MSACCOSetup: Record "M-SACCO Account Setup";
        Loans: Record Loans;
}

