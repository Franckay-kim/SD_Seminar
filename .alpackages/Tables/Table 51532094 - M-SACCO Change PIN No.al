table 51532094 "M-SACCO Change PIN No"
{
    // DrillDownPageID = "Change MPESA PIN List";
    // LookupPageID = "Change MPESA PIN List";

    fields
    {
        field(1; No; Code[30])
        {

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Change M-SACCO PIN Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Date Entered"; Date)
        {
        }
        field(3; "Time Entered"; Time)
        {
        }
        field(4; "Entered By"; Code[30])
        {
        }
        field(5; "MPESA Application No"; Code[30])
        {
            TableRelation = "M-SACCO Applications".No WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                MPESAApp.Reset;
                MPESAApp.SetRange(MPESAApp.No, "MPESA Application No");
                if MPESAApp.Find('-')
                 then begin
                    "Customer ID No" := MPESAApp."Customer ID No";
                    "Customer Name" := MPESAApp."Customer Name";
                    "MPESA Mobile No" := MPESAApp."MPESA Mobile No";
                    "Document Date" := MPESAApp."Document Date";
                    "MPESA Corporate No" := MPESAApp."MPESA Corporate No";
                end;
            end;
        }
        field(6; "Document Date"; Date)
        {
        }
        field(7; "Customer ID No"; Code[50])
        {
        }
        field(8; "Customer Name"; Text[200])
        {
        }
        field(9; "MPESA Mobile No"; Text[50])
        {
        }
        field(10; "MPESA Corporate No"; Code[30])
        {
        }
        field(11; Status; Option)
        {
            OptionMembers = Pending,Approved,Rejected,Open;
        }
        field(12; Comments; Text[200])
        {
        }
        field(13; "Rejection Reason"; Text[30])
        {
        }
        field(14; "Date Sent"; Date)
        {
        }
        field(15; "Time Sent"; Time)
        {
        }
        field(16; "Sent By"; Code[30])
        {
        }
        field(17; "Date Rejected"; Date)
        {
        }
        field(18; "Time Rejected"; Time)
        {
        }
        field(19; "Rejected By"; Code[30])
        {
        }
        field(20; "Sent To Server"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(21; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(22; "Question 1"; Text[200])
        {
        }
        field(23; "Answer 1"; Text[100])
        {
        }
        field(24; "Question 2"; Text[200])
        {
        }
        field(25; "Answer 2"; Text[100])
        {
        }
        field(26; "Approval Status"; Option)
        {
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility CenterBR";
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
        if Status <> Status::Pending then begin
            Error('You cannot delete the MPESA transaction because it has already been sent for first approval.');
        end;
    end;

    trigger OnInsert()
    begin
        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Change M-SACCO PIN Nos");
            NoSeriesMgt.InitSeries(NoSetup."Change M-SACCO PIN Nos", xRec."No. Series", 0D, No, "No. Series");
        end;


        "Entered By" := UserId;
        "Date Entered" := Today;
        "Time Entered" := Time;
    end;

    var
        NoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MPESAApp: Record "M-SACCO Applications";
}

