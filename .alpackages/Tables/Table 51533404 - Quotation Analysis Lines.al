/// <summary>
/// Table Quotation Analysis Lines (ID 51533404).
/// </summary>
table 51533404 "Quotation Analysis Lines"
{
    // version proc


    fields
    {
        field(1; "RFQ No."; Code[20])
        {
        }
        field(2; "RFQ Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Quote No."; Code[20])
        {
        }
        field(4; "Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate();
            var
                Vend: Record Vendor;
            begin
                Vend.RESET;
                Vend.SETRANGE(Vend."No.", "Vendor No.");
                IF Vend.FIND('-') THEN
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(5; "Item No."; Code[20])
        {
        }
        field(6; Description; Text[250])
        {
        }
        field(7; Quantity; Decimal)
        {
        }
        field(8; "Unit Of Measure"; Code[20])
        {
        }
        field(9; Amount; Decimal)
        {
        }
        field(10; "Line Amount"; Decimal)
        {
        }
        field(11; Total; Decimal)
        {
        }
        field(12; "Last Direct Cost"; Decimal)
        {
            CalcFormula = Lookup(Item."Last Direct Cost" WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(13; Remarks; Text[50])
        {
        }
        field(14; "Header No"; Code[20])
        {
        }
        field(15; Award; Boolean)
        {
        }
        field(50000; "Vendor Name"; Text[70])
        {

            trigger OnValidate();
            var
                Vend: Record Vendor;
            begin
                Vend.RESET;
                Vend.SETRANGE(Vend."No.", "Vendor No.");
                IF Vend.FIND('-') THEN
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(50001; "Currency Code"; Code[10])
        {
        }
        field(50075; "Delivery Time"; Duration)
        {
        }
        field(50076; "Payment Terms"; Code[20])
        {
            TableRelation = "Payment Terms".Code;
        }
        field(50110; Brand; Text[40])
        {
        }
        field(50111; Warranty; Duration)
        {
        }
        field(50112; "Country Of Origin"; Code[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(50113; "Professional Opinion"; Text[250])
        {
        }
        field(50114; Responsive; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "RFQ No.", "RFQ Line No.", "Quote No.", "Vendor No.", "Header No")
        {
        }
        key(Key2; "Item No.")
        {
        }
        key(Key3; "Vendor No.")
        {
        }
        key(Key4; "RFQ No.", "RFQ Line No.", "Line Amount")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vend: Record Vendor;
}

