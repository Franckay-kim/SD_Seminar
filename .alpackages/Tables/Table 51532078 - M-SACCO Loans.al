/// <summary>
/// Table M-SACCO Loans (ID 51532078).
/// </summary>
table 51532078 "M-SACCO Loans"
{

    fields
    {
        field(1; "Entry no"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Account No"; Text[30])
        {
        }
        field(3; Date; DateTime)
        {
        }
        field(4; "Requested Amount"; Decimal)
        {
        }
        field(5; Posted; Boolean)
        {
            Editable = true;
        }
        field(6; Status; Option)
        {
            OptionCaption = 'Pending,Successful,Failed';
            OptionMembers = Pending,Successful,Failed;
        }
        field(7; "Date Posted"; DateTime)
        {
        }
        field(8; Remarks; Text[200])
        {
            Editable = false;
        }
        field(9; DocumentNo; Text[30])
        {
        }
        field(10; "Latest Salary Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; "STO Amount"; Decimal)
        {
        }
        field(12; "Net Salary"; Decimal)
        {
        }
        field(13; "Total loans"; Decimal)
        {
        }
        field(14; "Approved Amount"; Decimal)
        {
        }
        field(15; "Commision Amount"; Decimal)
        {
        }
        field(16; "Loan Product Type"; Option)
        {
            OptionMembers = "Salary Advance","Instant Loan","Other Loans","M-YETU Loan";
        }
        field(17; Amount; Decimal)
        {
        }
        field(18; "Loan Code"; Code[20])
        {
        }
        field(19; "Date Entered"; Date)
        {
        }
        field(20; "Time Entered"; Time)
        {
        }
        field(21; "Telephone No"; Text[20])
        {
        }
        field(22; Message; Text[100])
        {
        }
        field(23; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry no")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('Deletion not allowed');
    end;
}

