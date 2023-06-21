table 51533203 "HR Overtime Header"
{


    fields
    {
        field(1; "Staff No."; Code[10])
        {
            Editable = true;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                HREmp.Reset;
                if HREmp.Get("Staff No.") then begin
                    "Staff Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Global Dimension 1 Code" := HREmp."Department Code";
                    "Global Dimension 2 Code" := HREmp.Office;
                end else begin
                    "Staff Name" := '';
                    "Global Dimension 1 Code" := '';
                    "Global Dimension 2 Code" := '';
                end;
            end;
        }
        field(2; "Staff Name"; Text[50])
        {
            Editable = false;
        }
        field(3; "Convert To?"; Option)
        {
            OptionCaption = ' ,Convert to Pay,Convert to Leave';
            OptionMembers = " ","Convert to Pay","Convert to Leave";
        }
        field(4; "Posted to Payroll"; Boolean)
        {
            Editable = false;
        }
        field(5; "Application Code"; Code[10])
        {
            Editable = false;
        }
        field(6; Status; Option)
        {
            Editable = true;
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(7; "No. series"; Code[10])
        {
        }
        field(8; "Weekend Hours 2"; Decimal)
        {
        }
        field(9; "Application Date"; Date)
        {
            Editable = false;
        }
        field(10; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility CenterBR";
        }
        field(11; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Editable = false;
        }
        field(12; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            Editable = false;
        }
        field(13; "Weekend Hours"; Decimal)
        {
            CalcFormula = Sum("HR Overtime Lines"."Overtime Hours" WHERE("Application Code" = FIELD("Application Code"),
                                                                          "Overtime Type" = FILTER(Weekend)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Total Overtime Hours"; Decimal)
        {
            CalcFormula = Sum("HR Overtime Lines"."Overtime Hours" WHERE("Application Code" = FIELD("Application Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; Converted; Boolean)
        {
            Editable = false;
        }
        field(16; "Date Posted"; Date)
        {
        }
        field(17; "Time Posted"; Time)
        {
        }
        field(18; "Posted By"; Code[10])
        {
        }
        field(19; "Holiday Hours"; Decimal)
        {
            CalcFormula = Sum("HR Overtime Lines"."Overtime Hours" WHERE("Application Code" = FIELD("Application Code"),
                                                                          "Overtime Type" = CONST(Holiday)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Extra Hours"; Decimal)
        {
            CalcFormula = Sum("HR Overtime Lines"."Overtime Hours" WHERE("Application Code" = FIELD("Application Code"),
                                                                          "Overtime Type" = CONST("Extra Hours")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Application Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "Application Code" = '' then begin
            HRSetup.Get();
            HRSetup.TestField(HRSetup."Overtime Req Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Overtime Req Nos.", xRec."No. series", 0D, "Application Code", "No. series");
        end;
        "Application Date" := Today;

        /*
        HREmp.RESET;
        HREmp.SETRANGE(HREmp."User ID",USERID);
        IF HREmp.FIND('-') THEN
        BEGIN
            "Staff No.":=HREmp."No.";
        
            //"Responsibility Center":=HREmp."Responsibility Center";
            //"Global Dimension 1 Code":=HREmp."Global Dimension 1 Code";
            //"Global Dimension 2 Code":=HREmp."Global Dimension 2 Code";
        END ELSE
        BEGIN
            ERROR('User id'+' '+'['+USERID+']'+' has not been assigned to any HREmp. Please consult the HR officer for assistance')
        END;
        */

    end;

    var
        HREmp: Record "HR Employees";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        OT: Record "HR Overtime Header";
        usersetup: Record "User Setup";
        HrLeavePeriods: Record "HR Leave Periods";
        LeaveGjline: Record "HR Leave Journal Line";
        "LineNo.": Integer;
        "Days Applied": Decimal;
        "Hours Earned": Decimal;
        "Amount Earned": Decimal;

    procedure "Convert Overtime"()
    begin
    end;

    procedure "Convert Payroll"()
    begin
    end;
}

