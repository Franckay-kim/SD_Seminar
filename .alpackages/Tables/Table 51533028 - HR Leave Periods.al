table 51533028 "HR Leave Periods"
{

    fields
    {
        field(1; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            NotBlank = true;

            trigger OnValidate()
            begin
                "Period Description" := Format("Starting Date", 0, Text000);
            end;
        }
        field(2; "Period Description"; Text[100])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(3; "New Fiscal Year"; Boolean)
        {
            Caption = 'New Fiscal Year';

            trigger OnValidate()
            begin
                TestField("Date Locked", false);
            end;
        }
        field(4; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = true;
        }
        field(5; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
            Editable = true;
        }
        field(6; "Reimbursement Clossing Date"; Boolean)
        {
        }
        field(8; "Period Code"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AccountingPeriod2: Record "HR Leave Periods";
        InvtSetup: Record "Inventory Setup";
        Text000: Label '<Month Text>';

    local procedure UpdateAvgItems()
    begin
    end;
}

