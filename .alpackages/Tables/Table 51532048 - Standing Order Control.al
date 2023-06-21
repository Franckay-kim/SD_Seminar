table 51532048 "Standing Order Control"
{

    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get();
                    NoSeriesMgt.TestManual(SeriesSetup."Standing Order Control Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Document Date"; Date)
        {
            Editable = false;
        }
        field(3; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(4; "Transaction Branch"; Code[10])
        {
            Editable = false;
        }
        field(5; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility CenterBR";
        }
        field(6; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,Pending,Approved,Rejected,Processed;
        }
        field(7; "Document Type"; Option)
        {
            OptionMembers = Open,Pending,Approved,Rejected,Stopped;
        }
        field(8; "Standing Order No"; Code[10])
        {
            TableRelation = "Standing Order Header" WHERE(Status = FILTER(Approved | Stopped));

            trigger OnValidate()
            var
                StandingOrderHeader: Record "Standing Order Header";
                StandingOrderControl: Record "Standing Order Control";
                ExistingAppliactionError: Label 'There is an exiting Pending appliaction for this Standing Order.';
            begin
                StandingOrderControl.Reset;
                StandingOrderControl.SetRange(StandingOrderControl."Standing Order No", "Standing Order No");
                StandingOrderControl.SetRange(StandingOrderControl.Status, StandingOrderControl.Status::Open,
                                              StandingOrderControl.Status::Pending);
                if StandingOrderControl.FindFirst then begin
                    Error(ExistingAppliactionError);
                end;

                if StandingOrderHeader.Get("Standing Order No") then begin
                    //  "Source Account Type" := StandingOrderHeader."Source Account Type";
                    "Source Account No." := StandingOrderHeader."Source Account No.";
                    "Source Account Name" := StandingOrderHeader."Source Account Name";
                    "Member No." := StandingOrderHeader."Member No.";
                    "ID Number" := StandingOrderHeader."ID Number";
                    "Payroll/Staff No." := StandingOrderHeader."Payroll/Staff No.";
                    "Income Type" := StandingOrderHeader."Income Type";
                    "Allow Partial Deduction" := StandingOrderHeader."Allow Partial Deduction";
                    Amount := StandingOrderHeader.Amount;
                    "Effective Date" := StandingOrderHeader."Effective/Start Date";
                    Frequency := StandingOrderHeader."Frequency (Months)";
                    "End Date" := StandingOrderHeader."End Date";
                end;
            end;
        }
        field(9; "Source Account Type"; Option)
        {
            Editable = false;
            OptionMembers = "39004276";
        }
        field(10; "Source Account No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            var
                StandingOrderHeader: Record "Standing Order Header";
            begin
            end;
        }
        field(11; "Source Account Name"; Text[80])
        {
            Editable = false;
        }
        field(12; "Member No."; Code[10])
        {
            Editable = false;
        }
        field(13; "ID Number"; Code[20])
        {
            Editable = false;
        }
        field(14; "Payroll/Staff No."; Code[20])
        {
            Editable = false;
        }
        field(15; Description; Text[50])
        {
            Description = 'LookUp to Standing Orders Description Table';
        }
        field(16; "Allow Partial Deduction"; Boolean)
        {
            Editable = false;
        }
        field(17; "Income Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Salary,Milk,Tea,Staff Salary,Business,Periodic,Bonus,Mini-Bonus';
            OptionMembers = " ",Salary,Milk,Tea,"Staff Salary",Business,Periodic,Bonus,"Mini-Bonus";
            // TableRelation = "Credit Product Categories".Code;
        }
        field(18; Amount; Decimal)
        {
            Editable = false;
        }
        field(19; "Deduction Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Partial,Full';
            OptionMembers = Partial,Full;
        }
        field(20; "Effective Date"; Date)
        {
            Editable = false;
        }
        field(21; Frequency; DateFormula)
        {
            Editable = false;
        }
        field(22; "End Date"; Date)
        {
            Editable = false;
        }
        field(23; "Created By"; Code[50])
        {
            Editable = false;
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

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Standing Order Control Nos.");
            NoSeriesMgt.InitSeries(SeriesSetup."Standing Order Control Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Document Date" := Today;
        "Created By" := UserId;
    end;

    var
        SeriesSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

