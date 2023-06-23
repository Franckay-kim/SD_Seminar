/// <summary>
/// Table HR Employee Exit Interviews (ID 51533014).
/// </summary>
table 51533014 "HR Employee Exit Interviews"
{
    //DrillDownPageID = "HR Exit Interview list";
    //LookupPageID = "HR Exit Interview list";

    fields
    {
        field(1; "Exit Interview No"; Code[10])
        {
        }
        field(2; "Date Of Interview"; Date)
        {
        }
        field(3; "Interview Done By"; Code[20])
        {
            TableRelation = "HR Employees";

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Interview Done By");
                if HREmp.Find('-') then begin
                    IntFullName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Interviewer Name" := IntFullName;
                end;
            end;
        }
        field(4; "Re Employ In Future"; Boolean)
        {
        }
        field(5; "Reason For Leaving"; Option)
        {
            OptionMembers = " ",Resignation,Dismissal,Retirement,Termination,"Contract Ended","Appointment Revoked",Retrenchment,Personal;
        }
        field(6; "Reason For Leaving (Other)"; Text[150])
        {
        }
        field(7; "Date Of Leaving"; Date)
        {
        }
        field(10; Comment; Text[250])
        {
            Editable = true;
        }
        field(11; "Employee No."; Code[20])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Employee No.");
                if HREmp.Find('-') then begin
                    EmpFullName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Employee Name" := EmpFullName;
                end;
            end;
        }
        field(12; "No Series"; Code[10])
        {
        }
        field(13; "Form Submitted"; Boolean)
        {
        }
        field(14; "Global Dimension 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Employee Name"; Text[50])
        {
        }
        field(16; "Interviewer Name"; Text[50])
        {
        }
        field(17; Closed; Boolean)
        {
        }
        field(18; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending,Approved';
            OptionMembers = New,Pending,Approved;
        }
    }

    keys
    {
        key(Key1; "Exit Interview No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        //GENERATE NEW NUMBER FOR THE DOCUMENT
        if "Exit Interview No" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Exit Interview Nos");
            NoSeriesMgt.InitSeries(HRSetup."Exit Interview Nos", xRec."No Series", 0D, "Exit Interview No", "No Series");
        end;
    end;

    var
        OK: Boolean;
        HREmp: Record "HR Employees";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmpFullName: Text;
        IntFullName: Text;
        Misc: Record "Misc. Article Information";
}

