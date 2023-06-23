/// <summary>
/// Table Interest Due Period (ID 51532186).
/// </summary>
table 51532186 "Interest Due Period"
{

    fields
    {
        field(1; "Interest Due Date"; Date)
        {
            Caption = 'Interest Due Date';
            Editable = true;
            NotBlank = true;

            trigger OnValidate()
            begin
                Name := Format("Interest Due Date", 0, Text000);
            end;
        }
        field(2; Name; Text[10])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(3; "New Fiscal Year"; Boolean)
        {
            Caption = 'New Fiscal Year';
            Editable = false;

            trigger OnValidate()
            begin
                TestField("Date Locked", false);
                if "New Fiscal Year" then begin
                    if not InvtSetup.Get then
                        exit;
                    //"Average Cost Calc. Type" := InvtSetup."Average Cost Calc. Type";
                    "Average Cost Period" := InvtSetup."Average Cost Period";
                end else begin
                    "Average Cost Calc. Type" := "Average Cost Calc. Type"::" ";
                    "Average Cost Period" := "Average Cost Period"::" ";
                end;
            end;
        }
        field(4; Closed; Boolean)
        {
            Caption = 'Closed';

            trigger OnValidate()
            begin
                if xRec.Closed = true then
                    Error('You canot reopen Closed Period');
                "Closed by User" := UserId;
                "Closing Date Time" := Today;
                Modify;
            end;
        }
        field(5; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
            Editable = false;
        }
        field(5804; "Average Cost Calc. Type"; Option)
        {
            Caption = 'Average Cost Calc. Type';
            Editable = false;
            OptionCaption = ' ,Item,Item & Location & Variant';
            OptionMembers = " ",Item,"Item & Location & Variant";
        }
        field(5805; "Average Cost Period"; Option)
        {
            Caption = 'Average Cost Period';
            Editable = false;
            OptionCaption = ' ,Day,Week,Month,Quarter,Year,Accounting Period';
            OptionMembers = " ",Day,Week,Month,Quarter,Year,"Accounting Period";
        }
        field(50000; "Closed by User"; Code[20])
        {
            Editable = false;
        }
        field(50001; "Closing Date Time"; Date)
        {
            Editable = false;
        }
        field(50002; "Posting Document No."; Code[20])
        {
            Editable = false;
        }
        field(50003; "Interest Calcuation Date"; Date)
        {
            Caption = 'Interest Calculation Date';
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                Name := Format("Interest Due Date", 0, Text000);
            end;
        }
        field(50004; "Period End Date"; Date)
        {
            Editable = false;
        }
        field(50005; "No of Days"; Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Interest Due Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField("Date Locked", false);
        UpdateAvgItems(3);
    end;

    trigger OnInsert()
    begin

        AccountingPeriod2 := Rec;
        if AccountingPeriod2.Find('>') then
            AccountingPeriod2.TestField("Date Locked", false);
        UpdateAvgItems(1);
    end;

    trigger OnModify()
    begin
        UpdateAvgItems(2);
    end;

    trigger OnRename()
    begin

        TestField("Date Locked", false);
        AccountingPeriod2 := Rec;
        if AccountingPeriod2.Find('>') then
            AccountingPeriod2.TestField("Date Locked", false);
        UpdateAvgItems(4);
    end;

    var
        AccountingPeriod2: Record "Interest Due Period";
        InvtSetup: Record "Inventory Setup";
        Text000: Label '<Month Text>';

    /// <summary>
    /// UpdateAvgItems.
    /// </summary>
    /// <param name="UpdateType">Option.</param>
    procedure UpdateAvgItems(UpdateType: Option)
    var
        ChangeAvgCostSetting: Codeunit "Change Average Cost Setting";
    begin
        //ChangeAvgCostSetting.UpdateAvgCostFromAccPeriodChg(Rec,xRec,UpdateType);
    end;
}

