table 51532119 "Bankers Cheque Application"
{

    fields
    {
        field(1; "No."; Code[10])
        {

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    Noseriesmgt.TestManual(SalesSetup."Bankers Cheque Application Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Application Date"; Date)
        {
        }
        field(3; "No. Series"; Code[10])
        {
        }
        field(4; "Responsibility Centre"; Code[10])
        {
            TableRelation = "Responsibility CenterBR";
        }
        field(5; "Begining Cheque No."; Code[6])
        {
        }
        field(6; "Cheque Register Generated"; Boolean)
        {
            Editable = false;
        }
        field(7; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(10; "No of Leaves"; Integer)
        {
        }
        field(11; "Bank Account"; Code[20])
        {
            //TableRelation = "Bank Account" WHERE("Bank Type" = FILTER(Normal));
        }
        field(12; "Leaf Limit Amount"; Decimal)
        {
        }
        field(13; "Bankers Cheque Type"; Option)
        {
            OptionCaption = 'Co-op Bankers Cheque,Customer Service Cheques';
            OptionMembers = "Co-op Bankers Cheque","Customer Service Cheques";
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
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Bankers Cheque Application Nos");
            Noseriesmgt.InitSeries(SalesSetup."Bankers Cheque Application Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;



        "Application Date" := Today;

        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        /*if UserSetup.Find('-') then begin
            UserSetup.TestField(UserSetup."Global Dimension 1 Code");
            UserSetup.TestField(UserSetup."Global Dimension 2 Code");

            "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
            //waumini training reworks
            "Responsibility Centre" := 'FOSA';
        end;*/
    end;

    trigger OnModify()
    begin

        if Status = Status::Approved then begin
            if "Cheque Register Generated" = true then
                Error('Cheque register has already been generated.');
        end;
    end;

    var
        Noseriesmgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Banking No Setup";
        UserSetup: Record "User Setup";
}

