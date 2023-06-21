table 51532173 "End Year Transfer Header"
{


    fields
    {
        field(1; "No."; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    NoSetup.Get;
                    NoSeriesMgt.TestManual(NoSetup."FOSA Interest Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; "Document No."; Code[30])
        {
            Editable = true;
        }
        field(4; "Distributed Amount"; Decimal)
        {
            CalcFormula = Sum("End Year Interest Buffer"."Interest Amount" WHERE(No = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Posted; Boolean)
        {
        }
        field(6; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
        }
        field(7; Cashier; Code[30])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(8; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",,Approved,Rejected;
        }
        field(9; "Posted By"; Code[30])
        {
            Editable = false;
        }
        field(10; "Time Posted"; Time)
        {
            Editable = false;
        }
        field(11; Description; Text[30])
        {
        }
        field(12; "Responsibility Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                "End Date" := CalcDate('<CY>', "Start Date");
                Validate("End Date");
            end;
        }
        field(16; "End Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                Description := Format("End Date", 0, '<Month Text>') + ' ' + Format(Date2DMY("End Date", 3)) + ' ' + 'Interest Expense';
            end;
        }
    }

    keys
    {
        key(Key1; "Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."FOSA Interest Nos");
            NoSeriesMgt.InitSeries(NoSetup."FOSA Interest Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        Cashier := UserId;
        "Document No." := "No.";
        UserSetup.Get(UserId); //THEN
                               // BEGIN
                               /* UserSetup.TestField("Global Dimension 1 Code");
                                UserSetup.TestField("Global Dimension 2 Code");
                                UserSetup.TestField("Responsibility Centre");

                                "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                                "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                                "Responsibility Center" := UserSetup."Responsibility Centre";*/
                               // END;
    end;

    trigger OnModify()
    begin
        /*if UserSetup.Get(UserId) then begin
            "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
            "Responsibility Center" := UserSetup."Responsibility Centre";
        end;*/
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserSetup: Record "User Setup";
        NoSetup: Record "Banking No Setup";
        CUST: Record Customer;
}

