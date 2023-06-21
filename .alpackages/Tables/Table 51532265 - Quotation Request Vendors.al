table 51532265 "Quotation Request Vendors"
{

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender";
        }
        field(2;"Requisition Document No.";Code[20])
        {
        }
        field(3;"Vendor No.";Code[20])
        {
            TableRelation = Vendor WHERE ("Vendor Posting Group"=FILTER(<>'DRIVERS'));
        }
        field(4;"Vendor Name";Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE ("No."=FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Requisition Document No.","Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }
}

