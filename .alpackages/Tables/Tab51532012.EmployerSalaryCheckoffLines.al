/// <summary>
/// Table Employer Salary/Checkoff Lines (ID 51532012).
/// </summary>
table 51532012 "Employer Salary/Checkoff Lines"
{
    Caption = 'Employer Salary/Checkoff Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Header No."; Code[30])
        {
            Caption = 'Entry Type';
            DataClassification = ToBeClassified;
        }
        field(3; "Member No."; Code[30])
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
        field(4; "Member Name"; Text[150])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(6; "Receipt Class"; Option)
        {
            Caption = 'Receipt Class';
            OptionMembers = "",Salary,Checkoff;
            DataClassification = ToBeClassified;
        }
        field(8; "Period Start Date"; Date)
        {
            Caption = 'Period Start Date';
            DataClassification = ToBeClassified;
        }
        field(9; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = ToBeClassified;
        }
        field(10; "Employer Code"; Code[30])
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
        field(11; "Staff No."; Code[30])
        {
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
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
