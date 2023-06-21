table 51532154 "Guarantors Substitution"
{


    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if xRec."No." <> xRec."No." then begin
                    CreditNosSeries.Get;
                    NoSeriesMgt.TestManual(CreditNosSeries."Guarantors Substitution");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Loan Account No."; Code[20])
        {
            TableRelation = "Credit Accounts";
        }
        field(3; Name; Text[50])
        {
            Editable = false;
        }
        field(4; "Account Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter,Apportioned,Suspended,Awaiting Verdict';
            OptionMembers = Active,"Non-Active",Blocked,Dormant,"Re-instated",Deceased,Withdrawal,Retired,Termination,Resigned,"Ex-Company",Casuals,"Family Member",Defaulter,Apportioned,Suspended,"Awaiting Verdict";
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(6; "Current Savings"; Decimal)
        {
            Editable = false;
        }
        field(7; "FOSA Account"; Code[20])
        {
            Editable = false;
            Enabled = false;
        }
        field(8; "Business Loan No."; Code[20])
        {
            Editable = false;
            Enabled = false;
        }
        field(9; "Business Loan Shares"; Decimal)
        {
            Editable = false;
        }
        field(10; "Posted By"; Code[30])
        {
            Editable = false;
        }
        field(11; "Captured By"; Code[30])
        {
            Editable = false;
        }
        field(12; "Responsibility Centre"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility CenterBR";
        }
        field(13; "Activity Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14; "Branch Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Document No."; Code[20])
        {
        }
        field(16; Date; Date)
        {
            Editable = false;
        }
        field(17; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18; "ID/Passport"; Code[10])
        {
        }
        field(19; "Loan No."; Code[20])
        {
            TableRelation = Loans."Loan No." WHERE("Outstanding Balance" = FILTER(> 0), "Member No." = field("Member No."));

            trigger OnValidate()
            begin
                if Loan.Get("Loan No.") then begin
                    Loan.CalcFields(Loan."Outstanding Balance");
                    if Loan."Outstanding Balance" <= 0 then
                        Error(Txt001);

                    "Loan Account No." := Loan."Loan Account";
                    Name := Loan."Member Name";

                    Members.Get(Loan."Member No.");
                    "Staff No." := Members."Payroll/Staff No.";
                    ProdFact.Reset;
                    ProdFact.SetRange("Product Category", ProdFact."Product Category"::"Deposit Contribution");
                    ProdFact.SetRange("Member Class", 'CLASS A');
                    if ProdFact.FindFirst then begin
                        Savings.Reset;
                        Savings.SetRange("Member No.", Loan."Member No.");
                        Savings.SetRange("Product Type", ProdFact."Product ID");
                        if Savings.FindFirst then begin
                            Savings.CalcFields("Balance (LCY)");
                            "Class A" := Savings."Balance (LCY)";
                        end;
                    end;


                    ProdFact.Reset;
                    ProdFact.SetRange("Product Category", ProdFact."Product Category"::"Deposit Contribution");
                    ProdFact.SetRange("Member Class", 'CLASS B');
                    if ProdFact.FindFirst then begin
                        Savings.Reset;
                        Savings.SetRange("Member No.", Loan."Member No.");
                        Savings.SetRange("Product Type", ProdFact."Product ID");
                        if Savings.FindFirst then begin
                            Savings.CalcFields("Balance (LCY)");
                            "Class B" := Savings."Balance (LCY)";
                        end;
                    end;


                    ProdFact.Reset;
                    ProdFact.SetRange("Product Category", ProdFact."Product Category"::"Micro Credit Deposits");
                    ProdFact.SetRange("Member Class", 'CLASS C');
                    if ProdFact.FindFirst then begin
                        Savings.Reset;
                        Savings.SetRange("Member No.", Loan."Member No.");
                        Savings.SetRange("Product Type", ProdFact."Product ID");
                        if Savings.FindFirst then begin
                            Savings.CalcFields("Balance (LCY)");
                            "Class C" := Savings."Balance (LCY)";
                        end;
                    end;


                    GenerateGuarantors();



                end;
            end;
        }

        field(20; Posted; Boolean)
        {
            Editable = false;
        }
        field(21; "Class A"; Decimal)
        {
        }
        field(22; "Class B"; Decimal)
        {
        }
        field(23; "Class C"; Decimal)
        {
        }
        field(24; "Staff No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members."No.";
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

    trigger OnInsert()
    begin

        if "No." = '' then begin
            CreditNosSeries.Get;
            CreditNosSeries.TestField(CreditNosSeries."Guarantors Substitution");
            NoSeriesMgt.InitSeries(CreditNosSeries."Guarantors Substitution", xRec."No. Series", 0D, "No.", "No. Series");

        end;
        "Captured By" := UserId;
        Date := Today;
        UserSetup.Get(UserId);
        //BEGIN
        /*UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        UserSetup.TestField("Responsibility Centre");


        "Activity Code" := UserSetup."Global Dimension 1 Code";
        "Branch Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Centre" := UserSetup."Responsibility Centre";*/
    end;

    var
        CreditNosSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SubGuarantor: Record "Loan Security Sub";
        LoanGuarantor: Record "Loan Guarantors and Security";
        Loan: Record Loans;
        Txt001: Label 'This loan does not have a balance';
        UserSetup: Record "User Setup";
        Savings: Record "Savings Accounts";
        ProdFact: Record "Product Factory";
        Members: Record Members;

    procedure GenerateGuarantors()


    begin

        SubGuarantor.Reset;
        SubGuarantor.SetRange("Sub Header", "No.");
        if SubGuarantor.FindFirst then
            SubGuarantor.DeleteAll;

        LoanGuarantor.Reset;
        LoanGuarantor.SetRange(LoanGuarantor."Loan No", "Loan No.");
        LoanGuarantor.SetRange(LoanGuarantor.Substituted, false);
        if LoanGuarantor.Find('-') then begin

            repeat

                SubGuarantor.Init;
                SubGuarantor."Sub Header" := "No.";

                SubGuarantor."Guarantor Type" := LoanGuarantor."Guarantor Type";
                SubGuarantor."Savings Account No./Member No." := LoanGuarantor."Savings Account No./Member No.";
                SubGuarantor.Validate("Loan No", LoanGuarantor."Loan No");
                SubGuarantor.Validate("Savings Account No./Member No.");
                SubGuarantor."Collateral Reg. No." := LoanGuarantor."Collateral Reg. No.";
                SubGuarantor.Validate("Collateral Reg. No.");
                SubGuarantor.Name := LoanGuarantor.Name;
                SubGuarantor."Available Guarantorship" := LoanGuarantor."Available Guarantorship";
                SubGuarantor."Amount Guaranteed" := LoanGuarantor."Amount Guaranteed";
                SubGuarantor."Current Committed" := LoanGuarantor."Current Committed";
                SubGuarantor.Substituted := LoanGuarantor.Substituted;
                SubGuarantor."Super Guarantor" := LoanGuarantor."Super Guarantor";

                Loan.Get(LoanGuarantor."Loan No");
                SubGuarantor."Member No" := Loan."Member No.";
                SubGuarantor.Insert;

            until LoanGuarantor.Next = 0;

        end;
    end;
}

