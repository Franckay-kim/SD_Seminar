table 51532045 "Standing Order Register"
{
    //DrillDownPageID = "Standing Order Register List";
    //LookupPageID = "Standing Order Register List";

    fields
    {
        field(2; "No."; Code[10])
        {

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Standing Order Reg. Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "Date Processed"; Date)
        {
        }
        field(4; "Document No."; Code[20])
        {
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(7; "Source Account No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "Savings Accounts";
        }
        field(8; "Source Account Name"; Text[50])
        {
        }
        field(9; "Member No"; Code[20])
        {
            TableRelation = Members;
        }
        field(10; "Staff/Payroll No."; Code[10])
        {
        }
        field(11; "Allow Partial Deduction"; Boolean)
        {
        }
        field(12; "Deduction Status"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Successfull,Partial Deduction,Failed';
            OptionMembers = " ",Successfull,"Partial Deduction",Failed;
        }
        field(13; Amount; Decimal)
        {
            NotBlank = true;
        }
        field(14; "Amount Deducted"; Decimal)
        {
        }
        field(15; "Effective/Start Date"; Date)
        {
        }
        field(16; Duration; DateFormula)
        {
            NotBlank = true;
        }
        field(17; Frequency; DateFormula)
        {
            NotBlank = true;
        }
        field(18; "End Date"; Date)
        {
        }
        field(19; Remarks; Text[150])
        {
        }
        field(20; EFT; Boolean)
        {
        }
        field(21; "Transfered to EFT"; Boolean)
        {
        }
        field(22; "Standing Order No."; Code[20])
        {
        }
        field(23; "Destination Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,External,Fixed Asset,IC Partner,Internal,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,External,"Fixed Asset","IC Partner",Internal,Credit;
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
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Standing Order Reg. Nos.");
            NoSeriesMgt.InitSeries(NoSetup."Standing Order Reg. Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        NoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

