table 51532148 "Checkoff Advice Header"
{

    fields
    {
        field(1; "No."; Code[10])
        {

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Advice No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employer Code"; Code[20])
        {
            //TableRelation = Customer WHERE("Account Type" = CONST(Employer));

            trigger OnValidate()
            begin
                if Emp.Get("Employer Code") then begin
                    "Employer Name" := Emp.Name;
                end;
            end;
        }
        field(3; "Employer Name"; Text[50])
        {
        }
        field(4; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                Period := Format("Start Date", 0, Text000);
                Validate(Period);
            end;
        }
        field(5; "End Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "End Date" := CalcDate('CM', "Start Date");
            end;
        }
        field(6; "No. Series"; Code[10])
        {
        }
        field(7; "Captured By"; Code[50])
        {
        }
        field(8; "Date Entered"; Date)
        {
        }
        field(9; Period; Code[20])
        {

            trigger OnValidate()
            begin
                Period := Period + ' ' + Format(Date2DMY("Start Date", 3));
                Validate("End Date");
            end;
        }
        field(10; Processed; Boolean)
        {
        }
        field(11; "Loan Issued Cut Off Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Loan Interest Cut OFF Date" <> 0D then begin
                    if CalcDate('CM', "Loan Interest Cut OFF Date") <> CalcDate('CM', "Start Date") then
                        Error('Invalid Date. Must be Same Period as start date');
                end;
            end;
        }
        field(12; "Loan Interest Cut OFF Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Processed = true then
            Error(Txt0001)
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Advice No.");
            NoSeriesMgt.InitSeries(NoSetup."Advice No.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Date Entered" := Today;
        "Captured By" := UserId;
    end;

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text000: Label '<Month Text>';
        Emp: Record Customer;
        Txt0001: Label 'You cannot delete processed buffer';
}

