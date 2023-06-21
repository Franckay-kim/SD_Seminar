table 51532061 "Schedule of Loan Payment"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
        }
        field(2; "Payment Options"; Option)
        {
            OptionMembers = Cheques,"M-PESA";
        }
        field(3; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if Loans.Get("Loan No.") then begin

                    // Bal := CheckBalance.ComputeCharges(Loans."Approved Amount", Loans."Loan Product Type", Loans."Loan No.", Amount);
                    //MESSAGE('Bal %1', Bal);
                    if Bal < 0 then
                        Error('Not enough it results in a negative disbursement');
                end;

                //All to go through savings acc if any money goes to fosa

                if "Payment Options" = "Payment Options"::Cheques then begin
                    if Loans.Get("Loan No.") then begin
                        Loans."All Posting through Savings Ac" := true;
                        Loans.Modify;
                    end;

                end;
            end;
        }
        field(4; Serial; Integer)
        {
        }
        field(5; "Posting Dates"; Date)
        {
        }
        field(6; Posted; Boolean)
        {
        }
        field(7; "Cheque No."; Code[20])
        {
        }
        field(8; "Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";
        }
    }

    keys
    {
        key(Key1; "Loan No.", Serial)
        {
        }
    }

    fieldgroups
    {
    }

    var
        //CheckBalance: Codeunit "Loans Process";
        Loans: Record Loans;
        Bal: Decimal;
}

