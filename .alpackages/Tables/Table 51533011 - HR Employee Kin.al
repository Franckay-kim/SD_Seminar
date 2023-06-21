table 51533011 "HR Employee Kin"
{
    Caption = 'Employee Relative';

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Employees"."No.";
        }
        field(2; Relationship; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Next of Kin"));
        }
        field(3; SurName; Text[50])
        {
            NotBlank = true;
        }
        field(4; "Other Names"; Text[100])
        {
            NotBlank = true;
        }
        field(5; "ID No/Passport No"; Text[50])
        {
        }
        field(6; "Date Of Birth"; Date)
        {
        }
        field(7; Occupation; Text[100])
        {
        }
        field(8; Address; Text[250])
        {
        }
        field(9; "Office Tel No"; Text[100])
        {
        }
        field(10; "Home Tel No"; Text[50])
        {
        }
        field(12; Type; Option)
        {
            OptionMembers = "Next of Kin",Beneficiary;
        }
        field(13; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(14; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("No." = FIELD("Employee Code")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "E-mail"; Text[60])
        {
        }
        field(50001; Comments; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Allocation; Decimal)
        {
            trigger OnValidate()
            var
                EmpKin: Record "HR Employee Kin";
            begin
                EmpKin.Reset();
                EmpKin.SetRange("Employee Code", "Employee Code");
                if EmpKin.FindFirst() then
                    EmpKin.CalcSums(Allocation);
                if EmpKin.Allocation + Allocation > 100 then Error('Allocation cannot exceed 100');
            end;
        }
    }



    keys
    {
        key(Key1; "Employee Code", Type, Relationship, SurName, "Other Names", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        HRCommentLine: Record "Human Resource Comment Line";
    begin
        HRCommentLine.SetRange("Table Name", HRCommentLine."Table Name"::"Employee Relative");
        HRCommentLine.SetRange("No.", "Employee Code");
        HRCommentLine.DeleteAll;
    end;


}

