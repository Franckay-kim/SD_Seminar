/// <summary>
/// Table HR Professional body Header (ID 51533087).
/// </summary>
table 51533087 "HR Professional body Header"
{
    //DrillDownPageID = "HR Professional Bodies List";
    //LookupPageID = "HR Professional Bodies List";

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Created By"; Code[30])
        {
        }
        field(3; "Date Created"; Date)
        {
        }
        field(4; "Shortcut Dimension code1"; Code[20])
        {
        }
        field(5; "Shortcut Dimension code2"; Code[20])
        {
        }
        field(6; Designation; Code[20])
        {
        }
        field(7; "Professional Body"; Text[100])
        {
        }
        field(8; "Body relevant"; Boolean)
        {
        }
        field(9; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Approved;
        }
        field(10; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility CenterBR".Code;
        }
        field(11; "No Series"; Code[20])
        {
        }
        field(12; Members; Integer)
        {
            CalcFormula = Count("HR Employees" WHERE("Professional Body" = FIELD("No."),
                                                      Status = FILTER(Active)));
            FieldClass = FlowField;
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
        fieldgroup(DropDown; "No.", "Professional Body")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Proffessional Bodies Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Proffessional Bodies Nos.", xRec."No Series", 0D, "No.", "No Series");
        end;

        "Created By" := UserId;
        "Date Created" := Today;
    end;

    var
        HREmployees: Record "HR Employees";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeQaulifications: Record "HR Employee Qualifications";
}

