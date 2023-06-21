table 51532195 Committment
{

    fields
    {
        field(1; "Line No."; Integer)
        {
        }
        field(2; "Commitment Date"; Date)
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Document Type"; Option)
        {
            OptionCaption = 'LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,Grant Surrender,Cash Purchase';
            OptionMembers = LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,"Grant Surrender","Cash Purchase";
        }
        field(5; "Document No."; Code[20])
        {
        }
        field(6; Amount; Decimal)
        {
        }
        field(7; "Month Budget"; Decimal)
        {
        }
        field(8; "Month Actual"; Decimal)
        {
        }
        field(9; Committed; Boolean)
        {
        }
        field(10; "Committed By"; Code[50])
        {
        }
        field(11; "Committed Date"; Date)
        {
        }
        field(12; "Committed Time"; Time)
        {
        }
        field(13; "Committed Machine"; Text[100])
        {
        }
        field(14; Cancelled; Boolean)
        {
        }
        field(15; "Cancelled By"; Code[20])
        {
        }
        field(16; "Cancelled Date"; Date)
        {
        }
        field(17; "Cancelled Time"; Time)
        {
        }
        field(18; "Cancelled Machine"; Text[100])
        {
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
        }
        field(21; "Shortcut Dimension 3 Code"; Code[20])
        {
        }
        field(22; "Shortcut Dimension 4 Code"; Code[20])
        {
        }
        field(23; "G/L Account No."; Code[20])
        {
        }
        field(24; Budget; Code[20])
        {
        }
        field(25; "Vendor/Cust No."; Code[20])
        {
        }
        field(26; Type; Enum "Gen. Journal Account Type")
        {
            //OptionMembers = " ",Vendor,Customer;
        }
        field(27; "Budget Check Criteria"; Option)
        {
            OptionMembers = "Current Month","Whole Year";
        }
        field(28; "Actual Source"; Option)
        {
            OptionMembers = "G/L Entry","Analysis View Entry";
        }
        field(29; "Document Line No."; Integer)
        {
        }
        field(30; "Commitment Line Description"; Text[50])
        {
        }
        field(31; "G/L Name"; Text[30])
        {
        }
        field(32; "Vendor Name"; Text[50])
        {
        }
        field(33; "Based on Totaling Account"; Boolean)
        {
        }
        field(35; "Order No."; Code[20])
        {
        }
        field(36; "Reversed By Doc Type"; Option)
        {
            OptionCaption = 'LPO,Requisition,Imprest,Payment Voucher,PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,Grant Surrender,Cash Purchase';
            OptionMembers = LPO,Requisition,Imprest,"Payment Voucher",PettyCash,PurchInvoice,StaffClaim,StaffAdvance,StaffSurrender,"Grant Surrender","Cash Purchase";
        }
        field(37; "Reversed By Doc No."; Code[20])
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
        }
        key(Key2; Budget, "G/L Account No.", "Posting Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "G/L Account No.", "Posting Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }
}

