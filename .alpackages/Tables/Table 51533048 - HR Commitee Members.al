/// <summary>
/// Table HR Commitee Members (ID 51533048).
/// </summary>
table 51533048 "HR Commitee Members"
{

    fields
    {
        field(1; "Committee Member No."; Code[20])
        {
            TableRelation = IF (Type = CONST(Member)) Members."No."
            ELSE
            IF (Type = CONST(Employees)) "HR Employees"."No.";

            trigger OnValidate()
            begin
                if Type = Type::Employees then begin
                    HREmp.Reset;
                    HREmp.Get("Committee Member No.");
                    "Member Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                end else begin
                    if Type = Type::Member then
                        Membrs.Reset;
                    Membrs.Get("Committee Member No.");
                    "Member Name" := Membrs.Name;
                end;
            end;
        }
        field(2; "Member Name"; Text[100])
        {
        }
        field(3; Role; Text[100])
        {
        }
        field(8; "Date Appointed"; Date)
        {
        }
        field(9; Grade; Code[20])
        {
        }
        field(10; Active; Boolean)
        {
        }
        field(11; Committee; Code[20])
        {
            TableRelation = "HR Disciplinary Cases"."Case Number";
        }
        field(12; No; Code[20])
        {
        }
        field(13; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(50000; Type; Option)
        {
            OptionCaption = 'Member,Employees';
            OptionMembers = Member,Employees;
        }
    }

    keys
    {
        key(Key1; Committee, "Committee Member No.", No, "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HREmp: Record "HR Employees";
        Membrs: Record Members;
}

