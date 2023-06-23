/// <summary>
/// Table M-PESA Transactions (ID 51532085).
/// </summary>
table 51532085 "M-PESA Transactions"
{
    // DrillDownPageID = "Mpesa Transactions List";
    // LookupPageID = "Mpesa Transactions List";

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Transaction Date"; Date)
        {
        }
        field(3; "Account No."; Code[50])
        {
        }
        field(4; Description; Text[220])
        {
        }
        field(5; Amount; Decimal)
        {
        }
        field(6; Posted; Boolean)
        {
        }
        field(7; "Transaction Type"; Text[30])
        {
        }
        field(8; "Transaction Time"; Time)
        {
        }
        field(10; "Document Date"; Date)
        {
        }
        field(11; "Date Posted"; Date)
        {
        }
        field(12; "Time Posted"; Time)
        {
        }
        field(13; "Account Status"; Text[30])
        {
        }
        field(14; Messages; Text[200])
        {
        }
        field(15; "Needs Change"; Boolean)
        {
        }
        field(16; "Change Transaction No"; Code[20])
        {
        }
        field(17; "Old Account No"; Code[50])
        {
        }
        field(18; Changed; Boolean)
        {
        }
        field(19; "Date Changed"; Date)
        {
        }
        field(20; "Time Changed"; Time)
        {
        }
        field(21; "Changed By"; Code[30])
        {
        }
        field(22; "Approved By"; Code[30])
        {
        }
        field(25; "Key Word"; Text[30])
        {
        }
        field(27; CorporateNo; Text[30])
        {
        }
        field(28; "Telephone No"; Text[30])
        {
        }
        field(29; "Mpesa Names"; Text[30])
        {
        }
        field(30; "Bank Acc Balance"; Decimal)
        {
        }
        field(31; Reversed; Boolean)
        {
        }
        field(32; "Date Reversed"; Date)
        {
        }
        field(33; "Reversed By"; Code[50])
        {
        }
        field(34; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; Trace; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //ERROR('You cannot delete MPESA transactions.');
    end;

    trigger OnModify()
    begin
        if Posted = true then begin
            Error('You cannot modify posted MPESA transactions.');
        end;
    end;
}

