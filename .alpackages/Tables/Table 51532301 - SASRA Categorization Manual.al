/// <summary>
/// Table SASRA Categorization Manual (ID 51532301).
/// </summary>
table 51532301 "SASRA Categorization Manual"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            TableRelation = Loans;
        }
        field(2; "Loans Category-SASRA"; Option)
        {
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = Perfoming,Watch,Substandard,Doubtful,Loss;
        }
        field(3; "Outstanding Balance"; Decimal)
        {
            CalcFormula = Sum(Loans."Loan Balance As At" WHERE("Loan No." = FIELD("Loan No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //GetPreviosRec(xRec."Outstanding Balance");
            end;
        }
        field(4; "Outstanding Bills"; Decimal)
        {
            CalcFormula = Sum("Credit Ledger Entry".Amount WHERE("Loan No" = FIELD("Loan No."),
                                                                  "Transaction Type" = FILTER(Bills)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Defaulted Months"; Integer)
        {
        }
        field(6; "Defaulted Amount"; Decimal)
        {
        }
        field(7; "As At"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.")
        {
        }
    }

    fieldgroups
    {
    }
}

