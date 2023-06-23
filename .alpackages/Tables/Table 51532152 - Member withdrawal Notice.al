/// <summary>
/// Table Member withdrawal Notice (ID 51532152).
/// </summary>
table 51532152 "Member withdrawal Notice"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Members;

            trigger OnValidate()
            var
                LoansG: Integer;
                LoanGuarantors: Record "Loan Guarantors and Security";
                Loans: Record Loans;
                DepoAcc: Record "Savings Accounts";
                DepoBal: Decimal;
                LoanBal: Decimal;

            begin
                if Members.Get("Member No.") then
                    Name := Members.Name;
                "Global Dimension 1 Code" := Members."Global Dimension 1 Code";
                "Global Dimension 2 Code" := Members."Global Dimension 2 Code";
                Cell.Reset;
                Cell.SetRange(Cell."Member No.", "Member No.");
                Cell.SetRange(Substituted, false);
                if Cell.FindFirst then begin
                    Error('This member is attached to a cell, ensure the member is substituted');
                end;
                LoansG := 0;
                LoanGuarantors.Reset;
                LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No.");
                LoanGuarantors.SetRange(Substituted, false);
                //LoanGuarantors.SETRANGE(LoanGuarantors."Guarantor Type",LoanGuarantors."Guarantor Type"::Guarantor);
                if LoanGuarantors.Find('-') then begin

                    repeat
                        if Loans.Get(LoanGuarantors."Loan No") then begin
                            Loans.CalcFields(Loans."Outstanding Balance");
                            if Loans."Outstanding Balance" > 0 then begin
                                LoansG += 1;
                            end;
                        end;
                    until LoanGuarantors.Next = 0;

                    if LoansG > 0 then
                        Message('Member is Guaranteeing %1 Active Loans', LoansG);
                end;
                LoanBal := 0;
                DepoBal := 0;

                Loans.reset;
                Loans.SetRange("Member No.", "Member No.");
                Loans.SetFilter("Outstanding Balance", '>0');
                if Loans.Find('-') then
                    repeat
                        Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Loan Reg. Fee");
                        LoanBal += Loans."Outstanding Balance" + Loans."Outstanding Interest";

                    until Loans.next = 0;
                DepoAcc.Reset();
                DepoAcc.SetRange("Member No.", "Member No.");
                DepoAcc.SetRange("Product Category", DepoAcc."Product Category"::"Deposit Contribution");
                if DepoAcc.Find('-') then
                    repeat
                        DepoAcc.CalcFields(Balance, "Balance (LCY)");
                        DepoBal += DepoAcc."Balance (LCY)";
                    until DepoAcc.Next = 0;

                if DepoBal < LoanBal then
                    Error('Please note that the member has a loan balance of %1, against a non withdrawable deposits balance of %2', Format(LoanBal), Format(DepoBal))
                else
                    Message('Please note that the member has a loan balance of %1, against a non withdrawable deposits balance of %2', Format(LoanBal), Format(DepoBal));

            end;
        }

        field(3; "Reason for withdrawal"; Text[250])
        {
        }
        field(4; "Withdrawa Noticel Date"; Date)
        {

            trigger OnValidate()
            begin
                //IF "Withdrawa Noticel Date"<TODAY THEN ERROR(ErrMsg);

                GeneralSetUp.Get;
                GeneralSetUp.TestField(GeneralSetUp."Withdrawal Notice period");
                "Maturity Date" := CalcDate(Format(GeneralSetUp."Withdrawal Notice period"), "Withdrawa Noticel Date");
            end;
        }
        field(5; "Maturity Date"; Date)
        {
        }
        field(6; "Entered By"; Code[50])
        {
        }
        field(7; "Date Entered"; Date)
        {
        }
        field(8; "Time Entered"; Time)
        {
        }
        field(9; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(10; "No. Series"; Code[10])
        {
        }
        field(11; Name; Text[50])
        {
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
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

    trigger OnDelete()
    begin
        if Status = Status::Approved then
            Error(Txt00001);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Withdrawal Notice");
            NoSeriesMgt.InitSeries(NoSetup."Withdrawal Notice", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Date Entered" := Today;
        "Time Entered" := Time;
        "Entered By" := UserId;
    end;

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Members: Record Members;
        GeneralSetUp: Record "General Set-Up";
        Txt00001: Label 'You cannot delete approved record';
        ErrMsg: Label 'You cannot base Withdrawa Noticel Date in the past';
        Cust: Record Members;
        Cell: Record "Cell Group Members";
}

