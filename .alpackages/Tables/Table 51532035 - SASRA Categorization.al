table 51532035 "SASRA Categorization"
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

    var
        CreditLedgerEntry: Record "Credit Ledger Entry";
        LoanBal: Decimal;
        CreditLedgerEntry1: Record "Credit Ledger Entry";

    procedure GetLoanBalances(LoanNo: Code[20])
    begin
        "Outstanding Balance" := 0;
        CreditLedgerEntry.Reset;
        CreditLedgerEntry.SetRange(CreditLedgerEntry."Loan No", LoanNo);
        CreditLedgerEntry.SetFilter(CreditLedgerEntry.Amount, '>%1', 0);
        CreditLedgerEntry.SetFilter(CreditLedgerEntry."Transaction Type", '%1', CreditLedgerEntry."Transaction Type"::Repayment);
        CreditLedgerEntry.SetFilter(CreditLedgerEntry."Posting Date", '..%1', "As At");
        if CreditLedgerEntry.Find('-') then begin
            repeat
                "Outstanding Balance" := Abs(CreditLedgerEntry.Amount);
            until CreditLedgerEntry.Next = 0;
        end;

        CreditLedgerEntry1.Reset;
        CreditLedgerEntry1.SetRange(CreditLedgerEntry1."Loan No", LoanNo);
        CreditLedgerEntry1.SetFilter(CreditLedgerEntry1.Amount, '>%1', 0);
        CreditLedgerEntry1.SetFilter(CreditLedgerEntry1."Transaction Type", '%1', CreditLedgerEntry1."Transaction Type"::Repayment);
        CreditLedgerEntry1.SetFilter(CreditLedgerEntry1."Posting Date", '..%1', "As At");
        if CreditLedgerEntry1.Find('-') then begin //REPEAT
            CreditLedgerEntry.CalcSums(Amount);
            "Outstanding Balance" += Abs(CreditLedgerEntry1.Amount);
            //UNTIL CreditLedgerEntry.NEXT = 0;1
        end;
    end;
}

