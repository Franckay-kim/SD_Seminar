table 51532024 "Employer Salary/Checkoff Buffe"
{
    Caption = 'Employer Salary/Checkoff Buffe';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            // AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Member No."; Code[30])
        {
            Caption = 'Member No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Members: Record Members;
            begin
                Members.Reset();
                ;
                Members.SetRange("No.", "Member No.");
                if Members.Find('-') then begin
                    "Member Name" := Members.Name;
                    "Staff No." := Members."Payroll/Staff No.";
                end;
            end;

        }
        field(3; "Member Name"; Text[150])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Employer Code"; Code[30])
        {
            Caption = 'Employer Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                IF Cust.get("Employer Code") then begin

                end;
            end;
        }
        field(7; "Header No."; Code[30])
        {
            Caption = 'Header No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                EmpSH: Record "Employer Salary/Checkoff Head";
            begin
                EmpSH.Reset();
                EmpSH.SetRange("No.", "Header No.");
                if EmpSH.Find('-') then begin
                    Validate("Period Start Date", EmpSH."Period Start Date");
                    Validate("Period End Date", EmpSH."Period End Date");
                    Validate("Employer Code", EmpSH."Employer Code");
                end;
            end;
        }
        field(8; "Staff No."; Code[30])
        {
            Caption = 'Entry Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Members: Record Members;
                Cust: Record Customer;
            begin
                Members.Reset();
                Members.SetRange("Payroll/Staff No.", "Staff No.");
                Members.SetRange("Employer Code", "Employer Code");
                if Members.Find('-') then begin
                    Validate("Member No.", Members."No.");
                end;
            end;
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Entry Type';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Header No.", "Member No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        EmpHed: Record "Employer Salary/Checkoff Head";
    begin
        IF EmpHed.Get("Header No.") then
            if EmpHed.Generated then
                Error('Cannot delete a buffer whose lines have been generated.');
    end;

    trigger OnModify()
    var
        EmpHed: Record "Employer Salary/Checkoff Head";
    begin
        IF EmpHed.Get("Header No.") then
            if EmpHed.Generated then
                Error('Cannot modify a buffer whose lines have been generated.');
    end;

    trigger OnInsert()
    var
        EmpHed: Record "Employer Salary/Checkoff Head";
    begin
        IF EmpHed.Get("Header No.") then
            if EmpHed.Generated then
                Error('Cannot insert into buffer whose lines have been generated.');
    end;

}
