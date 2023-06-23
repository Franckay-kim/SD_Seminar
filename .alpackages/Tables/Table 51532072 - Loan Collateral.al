/// <summary>
/// Table Loan Collateral (ID 51532072).
/// </summary>
table 51532072 "Loan Collateral"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            TableRelation = Loans."Loan No.";
        }
        field(2; "Client Code"; Code[20])
        {
        }
        field(3; "Collateral Registration"; Code[20])
        {
        }
        field(4; "Collateral Value"; Decimal)
        {
            Editable = false;
        }
        field(5; "Collateral Type"; Option)
        {
            OptionCaption = ' ,Land,Motor Vehicles,Buildings,Chattels,Bonds and Stocks,Insurance Policies,Lien';
            OptionMembers = " ",Land,"Motor Vehicles",Buildings,Chattels,"Bonds and Stocks","Insurance Policies",Lien;

            trigger OnValidate()
            begin
                //TESTFIELD("Collateral Total Value");
                if CollTypes.Get("Collateral Type") then begin
                    "Collateral Multiplier" := CollTypes."Collateral % Applicable" * 0.01;
                    "Collateral Value" := "Collateral Total Value" * CollTypes."Collateral % Applicable" * 0.01;
                end;
            end;
        }
        field(6; "Collateral Multiplier"; Decimal)
        {
        }
        field(7; "Collateral Total Value"; Decimal)
        {

            trigger OnValidate()
            begin
                TestField("Collateral Total Value");
                if CollTypes.Get("Collateral Type") then begin
                    "Collateral Multiplier" := CollTypes."Collateral % Applicable" * 0.01;
                    "Collateral Value" := "Collateral Total Value" * CollTypes."Collateral % Applicable" * 0.01;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Collateral Registration", "Client Code")
        {
        }
        key(Key2; "Collateral Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Client Code", "Collateral Registration", "Collateral Type", "Collateral Multiplier")
        {
        }
    }

    var
        Loans: Record Loans;
        Loantypes: Record "Product Factory";
        Interest: Decimal;
        Cust: Record Members;
        RepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedRepayment: Decimal;
        RepaymentMade: Decimal;
        ExpectedInterest: Decimal;
        InterestPaid: Decimal;
        InterestArrears: Decimal;
        Count1: Integer;
        GenSetup: Record "Credit Nos. Series";
        RemainingPeriod: Decimal;
        IntBal: Decimal;
        LoanApp: Record Loans;
        DateFilter: Text;
        InstallPaid: Integer;
        InsureReabate: Decimal;
        NoOfMonths: Integer;
        NoOfInstallments: Integer;
        HalfNoOfInstallments: Decimal;
        TotalExpeInt: Decimal;
        Insurance: Decimal;
        LoanServ: Record Loans;
        ProdCharges: Record "Loan Product Charges";
        CollTypes: Record "Collateral Types Ratings";
}

