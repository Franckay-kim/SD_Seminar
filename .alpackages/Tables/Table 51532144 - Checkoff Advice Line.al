table 51532144 "Checkoff Advice Line"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Member No."; Code[20])
        {

            trigger OnValidate()
            begin
                Period := Format(Today, 0, Text000);
            end;
        }
        field(3; "Account No."; Code[20])
        {
        }
        field(4; Names; Text[50])
        {
        }
        field(5; "Employer Code"; Code[20])
        {
            //TableRelation = Customer WHERE ("Account Type"=CONST(Employer));
        }
        field(6; "Loan No."; Code[20])
        {
        }
        field(7; Period; Code[20])
        {
        }
        field(8; "Amount On"; Decimal)
        {
        }
        field(9; "Amount Off"; Decimal)
        {
        }
        field(10; "Balance On"; Decimal)
        {
        }
        field(11; "Balance Off"; Decimal)
        {
        }
        field(12; "Product Type"; Code[20])
        {

            trigger OnValidate()
            begin
                if ProductFactory.Get("Product Type") then begin
                    "Product Search Code" := ProductFactory."Search Code";
                    "Product Name" := ProductFactory."Product Description";

                end;
            end;
        }
        field(13; "Advice Date"; Date)
        {
        }
        field(14; Interest; Decimal)
        {
        }
        field(15; "Advice Method"; Option)
        {
            OptionCaption = 'Changes,Everything';
            OptionMembers = Changes,Everything;
        }
        field(16; "ID No."; Code[40])
        {
        }
        field(17; "Advice Header No."; Code[10])
        {
        }
        field(18; Processed; Boolean)
        {
        }
        field(19; "Payroll No"; Code[20])
        {
        }
        field(20; "Advice Type"; Option)
        {
            OptionCaption = ' ,Stoppage,Adjustment,New Loan,Variations,New';
            OptionMembers = " ",Stoppage,Adjustment,"New Loan",Variations,New;
        }
        field(21; "Product Search Code"; Code[20])
        {
        }
        field(22; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(23; Transfered; Boolean)
        {
        }
        field(24; "Product Name"; Text[60])
        {
        }
        field(25; "Employer Account No."; Code[20])
        {
        }
        field(26; Principal; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; Ledger; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; Penalty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Processed = true then
            Error(Txt0001);
    end;

    var
        Text000: Label '<Month Text>';
        Txt0001: Label 'You cannot delete processed advice';
        ProductFactory: Record "Product Factory";
}

