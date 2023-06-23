/// <summary>
/// Table Loan Disbursement Lines (ID 51532063).
/// </summary>
table 51532063 "Loan Disbursement Lines"
{

    fields
    {
        field(1; No; Code[20])
        {
        }
        field(2; Date; Date)
        {
        }
        field(3; "Pay Mode"; Option)
        {
            Enabled = false;
            OptionCaption = 'Ordinary Savings,Cheques,M-PESA';
            OptionMembers = "Ordinary Savings",Cheques,"M-PESA";
        }
        field(4; "Cheque No"; Code[20])
        {
        }
        field(5; "Cheque Date"; Date)
        {
        }
        field(6; "Bank Code"; Code[20])
        {
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
        }
        field(8; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(9; "Account Name"; Text[150])
        {
        }
        field(10; Posted; Boolean)
        {
        }
        field(11; "Date Posted"; Date)
        {
        }
        field(12; "Time Posted"; Time)
        {
        }
        field(13; "Posted By"; Code[20])
        {
        }
        field(14; "Disbursement Amount"; Decimal)
        {
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(16; "Loan No."; Code[20])
        {

            trigger OnValidate()
            begin
                if Loans.Get("Loan No.") then begin
                    Date := Today;
                    "Account No." := Loans."Loan Account";
                    "Account Name" := Loans."Member Name";
                    "Disbursement Amount" := Loans."Amount To Disburse";
                    "Approved Amount" := Loans."Approved Amount";
                    //Amount:=Loans."Approved Amount";
                end;
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(18; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(19; "Disbursement Serial - PD"; Integer)
        {
        }
        field(20; "Approved Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; No, "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Loans.Get("Loan No.") then begin
            Loans."Already Suggested" := false;
            Loans.Modify;
        end;


        //Delete partial disbursement lines

        PartDisb.Reset;
        PartDisb.SetRange(PartDisb."Loan No.", "Loan No.");
        PartDisb.SetRange(PartDisb."Entry No", "Disbursement Serial - PD");
        if PartDisb.Find('-') then begin
            PartDisb."Suggested for Disbursement" := false;
            PartDisb.Modify;
        end;
    end;

    var
        Loans: Record Loans;
        PartDisb: Record "Partial Disbursement Schedule";
}

