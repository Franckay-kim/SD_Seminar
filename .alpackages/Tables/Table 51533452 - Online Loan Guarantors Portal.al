table 51533452 "Online Loan Guarantors"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Loan Application No"; Integer)
        {
            trigger OnValidate()
            var
                NoOfGuarantors: Integer;
            begin
                if not OnlineLoansApplication.Get("Loan Application No") then exit;

                if ProductFactory.Get(OnlineLoansApplication."Loan Type") then
                    if ProductFactory."Maximum Guarantors" > 0 then begin
                        OnlineGuarantors.Reset;
                        OnlineGuarantors.SetRange("Loan Application No", "Loan Application No");
                        NoOfGuarantors := OnlineGuarantors.Count();

                        if ProductFactory."Maximum Guarantors" < NoOfGuarantors then Error('The maximum guarantors for this loan is %1.', ProductFactory."Maximum Guarantors");
                    end;

                "Applicant No" := OnlineLoansApplication."Member No";
                "Applicant Name" := OnlineLoansApplication."Member Name";
                "Applicant Mobile" := OnlineLoansApplication.Telephone;
                "Loan Type" := OnlineLoansApplication."Loan Type";
                "Loan Description" := OnlineLoansApplication."Loan Type Name";
                "Loan Amount" := OnlineLoansApplication."Loan Amount";
            end;
        }
        field(3; "Guarantor No."; Text[100])
        {
        }
        field(4; "Guarantor Names"; Text[100])
        {
        }
        field(5; "Guarantor Email"; Text[100])
        {
        }
        field(6; "Guarantor ID No"; Text[100])
        {

            trigger OnValidate()
            begin
                Members.Reset;
                Members.SetRange("ID No.", "Guarantor ID No");
                if not Members.FindFirst then exit;

                if ProductFactory.Get("Loan Type") then SavingsProduct := ProductFactory."Appraisal Savings Product";

                SavingsAccounts.Reset;
                SavingsAccounts.SetRange("Member No.", "Guarantor No.");
                SavingsAccounts.SetAutoCalcFields("Balance (LCY)");
                SavingsAccounts.SetFilter("Balance (LCY)", '>%1', 0);
                SavingsAccounts.SetRange("Product Type", SavingsProduct);
                SavingsAccounts.SetFilter(Status, '%1|%2', SavingsAccounts.Status::Active, SavingsAccounts.Status::Dormant);
                SavingsAccounts.SetRange("Can Guarantee Loan", true);
                if not SavingsAccounts.FindFirst then Error('Sorry, this member does not have an account capable of guarantorship.');

                "Guarantor Names" := Members.Name;
                "Guarantor Email" := Members."E-Mail";
                "Guarantor Phone" := Members."Mobile Phone No";
            end;
        }
        field(7; "Guarantor Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Guarantor Amount" > "Requested Amount" then Error(ErrAmountGreater, "Requested Amount");

                if ProductFactory.Get("Loan Type") then SavingsProduct := ProductFactory."Appraisal Savings Product";

                SavingsAccounts.Reset;
                SavingsAccounts.SetRange("Member No.", "Guarantor No.");
                SavingsAccounts.SetAutoCalcFields("Balance (LCY)");
                SavingsAccounts.SetRange("Product Type", SavingsProduct);
                SavingsAccounts.SetRange(SavingsAccounts.Status, SavingsAccounts.Status::Active);
                SavingsAccounts.SetFilter("Balance (LCY)", '>%1', 0);
                SavingsAccounts.SetRange("Can Guarantee Loan", true);
                if not SavingsAccounts.FindFirst then Error('Sorry, You do not have an account capable of guarantorship or you do not have enough balance.');

                DepositShares := SavingsAccounts."Balance (LCY)";
                //ApplicationAmtGuaranteed := LoansProcess.GetMemberCommittedDeposits(SavingsAccounts."No.", false);
                //TotalGuarantorCommitment := ApplicationAmtGuaranteed + LoansProcess.GetMemberCommittedDeposits(SavingsAccounts."No.", true);
                AvailableGuarantorship := DepositShares - TotalGuarantorCommitment;

                if AvailableGuarantorship < 0 then AvailableGuarantorship := 0;

                if "Guarantor Amount" > AvailableGuarantorship then Error('Sorry, you can only guarantee upto a maximum of %1', AvailableGuarantorship);
            end;
        }
        field(8; "Guarantor Phone"; Text[50])
        {
        }
        field(9; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pending,Approved,Rejected;
        }
        field(10; "Applicant No"; Text[50])
        {
        }
        field(11; "Applicant Name"; Text[150])
        {
        }
        field(12; "Applicant Mobile"; Text[100])
        {
        }
        field(13; "Loan Type"; Text[30])
        {
        }
        field(14; "Loan Description"; Text[100])
        {
        }
        field(15; "Requested Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Loan Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Date Approved"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Mem.Get("Applicant No"); //Loanee
        Members.Get("Guarantor No.");

        Msg := 'Dear ' + Members.Name + ', Kindly note that ' + Mem.Name + ' has cancelled their online guarantorship request of KShs. ' + Format("Requested Amount") + '.';

        //if Members."Mobile Phone No" <> '' then
        // SendSms.SendSms(OptionSms::"Loan Guarantors", Members."Mobile Phone No", Msg, '', '', false, false);
    end;

    var
        OnlineGuarantors: Record "Online Loan Guarantors";
        OnlineLoansApplication: Record "Online Loan Application";
        Members: Record Members;
        ErrDocNotFound: Label 'Loan Application not found.';
        ErrApproved: Label 'Status must not be equal to %1.';
        ErrAmountZero: Label 'Agreed Amount must be greater than 0.';
        ErrAmountGreater: Label 'Agreed Amount must not be greater than Requested Amount of %1.';
        ErrLoanStatus: Label 'Loan Application Status must not be equal to %1.';
        SavingsAccounts: Record "Savings Accounts";
        DepositShares: Decimal;
        ApplicationAmtGuaranteed: Decimal;
        TotalGuarantorCommitment: Decimal;
        AvailableGuarantorship: Decimal;
        //LoansProcess: Codeunit "Loans Process";
        //SendSms: Codeunit SendSms;
        OptionSms: Option "New Member","New Account","Loan Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit","Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit","Chq Book","Bankers Cheque","Teller Cheque Transfer","Defaulter Loan Issued",Bonus,Dividend,Bulk,"Standing Order","Loan Bill Due","POS Deposit","Mini Bonus","Leave Application","Loan Witness",PV,"Insurance Expiry",Withdrawal,"ATM Notif";
        Mem: Record Members;
        Msg: Text;
        ProductFactory: Record "Product Factory";
        SavingsProduct: Text;

    procedure ApproveReject("Action": Option Approve,Reject)
    begin
        if not OnlineLoansApplication.Get("Loan Application No") then Error(ErrDocNotFound);
        if OnlineLoansApplication.Status <> OnlineLoansApplication.Status::Pending then Error(ErrLoanStatus);
        if "Approval Status" <> "Approval Status"::Pending then Error(ErrApproved, "Approval Status");

        case Action of
            Action::Reject:
                begin
                    "Guarantor Amount" := 0;
                    "Approval Status" := "Approval Status"::Rejected;
                end;
            Action::Approve:
                begin
                    if "Guarantor Amount" <= 0 then Error(ErrAmountZero);
                    if "Guarantor Amount" > "Requested Amount" then Error(ErrAmountGreater, "Requested Amount");
                    "Approval Status" := "Approval Status"::Approved;
                    "Date Approved" := CurrentDateTime;
                end;
        end;
        Rec.Modify;
    end;
}

