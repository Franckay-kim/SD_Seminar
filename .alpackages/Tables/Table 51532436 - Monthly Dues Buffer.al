table 51532436 "Monthly Dues Buffer"
{

    fields
    {
        field(1;"Member No.";Code[20])
        {
        }
        field(2;"Staff No.";Code[20])
        {
        }
        field(3;Name;Text[150])
        {
        }
        field(4;Employer;Text[100])
        {
        }
        field(5;"Loan Principal Due";Decimal)
        {
        }
        field(6;"Loan Interest Due";Decimal)
        {
            Editable = false;
            FieldClass = Normal;

            trigger OnValidate()
            begin
                //GetPreviosRec(xRec."Outstanding Balance");
            end;
        }
        field(7;"Loan Penalty Due";Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(8;"Savings Due";Decimal)
        {
        }
        field(9;"Total Due";Decimal)
        {
        }
        field(10;"Mobile No.";Code[50])
        {
        }
        field(13;SMS;Text[200])
        {
        }
        field(14;Sent;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Loan Registration";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Member No.")
        {
        }
    }

    fieldgroups
    {
    }
}

