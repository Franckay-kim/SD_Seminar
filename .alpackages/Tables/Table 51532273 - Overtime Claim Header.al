/// <summary>
/// Table Overtime Claim Header (ID 51532273).
/// </summary>
table 51532273 "Overtime Claim Header"
{


    fields
    {
        field(10; "Claim No"; Code[20])
        {
            Editable = false;
        }
        field(11; Department; Text[30])
        {
        }
        field(20; "Date Created"; Date)
        {
        }
        field(30; "Created By"; Code[40])
        {
        }
        field(40; "Staff No."; Code[20])
        {
            Editable = false;
            TableRelation = "HR Employees";

            trigger OnValidate()
            begin
                if Employee.Get("Staff No.") then
                    Name := Employee."No." + ' ' + Employee."First Name" + ' ' + Employee."Middle Name";
            end;
        }
        field(50; Name; Text[50])
        {
        }
        field(51; Status; Option)
        {
            OptionCaption = 'Pending,Pending Approval,Approved,Cancelled';
            OptionMembers = Pending,"Pending Approval",Approved,Cancelled;
        }
        field(52; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility CenterBR";

            trigger OnValidate()
            begin
                /*if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);*/
            end;
        }
        field(53; "Currency Code"; Code[20])
        {
        }
        field(54; Amount; Decimal)
        {
            CalcFormula = Sum("Overtime Claim Lines".Amount WHERE("Claim No" = FIELD("Claim No")));
            FieldClass = FlowField;
        }
        field(55; "No. Series"; Code[20])
        {
        }
        field(56; "No. Printed"; Integer)
        {
        }
        field(57; "Total Overtime Hrs"; Decimal)
        {
            CalcFormula = Sum("Overtime Claim Lines"."No. of Hours" WHERE("Claim No" = FIELD("Claim No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Total Overtime Week Days"; Decimal)
        {
            CalcFormula = Sum("Overtime Claim Lines"."No. of Hours" WHERE("Overtime Type" = CONST(Weekdays),
                                                                           "Claim No" = FIELD("Claim No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Total Overtime Weekend & Holid"; Decimal)
        {
            CalcFormula = Sum("Overtime Claim Lines"."No. of Hours" WHERE("Overtime Type" = CONST("Weekends and Holidays"),
                                                                           "Claim No" = FIELD("Claim No")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Claim No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        "Date Created" := Today;
        //"Created By":=USERID;
        if "Claim No" = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Overtime Claim Nos");
            NoSeriesMgt.InitSeries(GenLedgerSetup."Overtime Claim Nos", xRec."No. Series", 0D, "Claim No", "No. Series");
        end;
        "Date Created" := Today;
        "Created By" := UserId;


        //Get the Employee Details
        /*if UserSetup.Get(UserId) then begin
          if UserSetup."Employee No." = '' then
             Error('Your USERID should be linked to an employee account contact your system administrator');

          "Staff No.":=UserSetup."Employee No.";
          if Employee.Get(UserSetup."Employee No.") then
            Name:= Employee."No."+ ' '+ Employee."First Name"+' '+Employee."Middle Name";

        end;*/
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        GenLedgerSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //UserMgt: Codeunit "User Setup Management BR";
        UserSetup: Record "User Setup";
        Employee: Record "HR Employees";
        RespCenter: Record "Responsibility CenterBR";
        Text001: Label 'Your identification is set up to process from %1 %2 only.';
}

