table 51532433 "Defaulter SMS Buffer"
{

    fields
    {
        field(1;"Loan No.";Code[20])
        {
        }
        field(2;"Defaulter CID";Code[20])
        {
        }
        field(3;"Defaulter Name";Text[150])
        {
        }
        field(4;"Loan Product";Code[20])
        {
        }
        field(5;"Approved Amount";Decimal)
        {
        }
        field(6;"Outstanding Balance";Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE ("Loan No"=FIELD("Loan No."),
                                                                  "Transaction Type"=FILTER(Loan|Repayment)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //GetPreviosRec(xRec."Outstanding Balance");
            end;
        }
        field(7;"Outstanding Bills";Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE ("Loan No"=FIELD("Loan No."),
                                                                  "Transaction Type"=FILTER(Bills)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Loan Category";Option)
        {
            OptionMembers = ,loss;
        }
        field(9;"Defaulter SMS";Code[160])
        {
        }
        field(10;"Defaulter Mobile No.";Code[50])
        {
        }
        field(11;"Guarantor CID";Code[20])
        {
        }
        field(12;"Guarantor Name";Text[150])
        {
        }
        field(13;"Guarantor SMS";Code[160])
        {
        }
        field(14;"Guarantor Mobile No.";Code[50])
        {
        }
        field(15;Type;Option)
        {
            OptionCaption = ' ,Defaulter,Guarantor';
            OptionMembers = " ",Defaulter,Guarantor;
        }
        field(16;"Installments Defaulted";Integer)
        {
        }
        field(17;"Entry No";Integer)
        {
        }
        field(18;"Disbursement Account";Code[20])
        {
        }
        field(19;"Defaulter SMS Sent";Boolean)
        {
        }
        field(20;"Guarantor SMS Sent";Boolean)
        {
        }
        field(21;"Issued Date";Date)
        {
            CalcFormula = Lookup(Loans."Disbursement Date" WHERE ("Loan No."=FIELD("Loan No.")));
            FieldClass = FlowField;
        }
        field(22;Installments;Integer)
        {
            CalcFormula = Lookup(Loans.Installments WHERE ("Loan No."=FIELD("Loan No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Loan No.","Guarantor CID",Type,"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

