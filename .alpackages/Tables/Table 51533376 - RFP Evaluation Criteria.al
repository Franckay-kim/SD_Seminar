table 51533376 "RFP Evaluation Criteria"
{
    // version RFP


    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Evaluation Year"; Integer)
        {
            //TableRelation = "Evaluation Year";
        }
        field(3; "Actual Weight Assigned"; Decimal)
        {
        }
        field(4; Description; Code[250])
        {
        }
        field(5; "Type Of Service"; Code[50])
        {
            //TableRelation = "Vendor Categories";
        }
        field(6; "Evaluation Type"; Option)
        {
            OptionMembers = "Score-Based","Non-Score-Based";
        }
        field(7; "Criteria Type"; Option)
        {
            OptionMembers = " ",Preliminary,Technical;
        }
    }

    keys
    {
        key(Key1; "Code", "Type Of Service")
        {
        }
    }

    fieldgroups
    {
    }
}

