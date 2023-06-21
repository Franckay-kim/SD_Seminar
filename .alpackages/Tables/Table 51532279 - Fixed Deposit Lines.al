table 51532279 "Fixed Deposit Lines"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Fixed Deposit","Call Deposit";

            trigger OnValidate()
            begin

                SavingsAccounts.Get("FDR No.");

                Name := SavingsAccounts.Name;
                "Member No." := SavingsAccounts."Member No.";

                if "No." = '' then begin
                    FDRCount := 0;
                    FDR.Reset;
                    FDR.SetRange("FDR No.", SavingsAccounts."No.");
                    if FDR.FindFirst then
                        FDRCount := FDR.Count;

                    FDRCount += 1;
                    FDRCountCode := Format(FDRCount);
                    if StrLen(FDRCountCode) = 1 then
                        FDRCountCode := '00' + FDRCountCode;

                    if StrLen(FDRCountCode) = 2 then
                        FDRCountCode := '0' + FDRCountCode;

                    "No." := SavingsAccounts."No." + '-' + Format(FDRCountCode);
                end;
            end;
        }
        field(4; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Deposit Type" WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin
                TestField("Start Date");
                TestField(Amount);

                if FixedDepositType.Get(Period) then begin
                    "Maturity Date" := CalcDate(FixedDepositType.Duration, "Start Date");

                    if "Rate (%)" = 0 then begin
                        FDCalcRules.Reset;
                        FDCalcRules.SetRange(Code, Period);
                        if FDCalcRules.Find('-') then begin
                            repeat
                                if (Amount >= FDCalcRules."Minimum Amount") and (Amount <= FDCalcRules."Maximum Amount") then
                                    "Rate (%)" := FDCalcRules."Interest Rate";
                            until FDCalcRules.Next = 0;
                        end;
                    end;
                end;

                Validate("FD Maturity Instructions");
            end;
        }
        field(5; "Rate (%)"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField(Period);
                FDCalcRules.Reset;
                FDCalcRules.SetRange(Code, Period);
                if FDCalcRules.Find('-') then begin
                    repeat
                        if FDCalcRules."Allowed Margin" <> 0 then begin
                            if (Amount >= FDCalcRules."Minimum Amount") and (Amount <= FDCalcRules."Maximum Amount") then
                                if ("Rate (%)" > (FDCalcRules."Interest Rate" + FDCalcRules."Allowed Margin")) or
                                   ("Rate (%)" < (FDCalcRules."Interest Rate" - FDCalcRules."Allowed Margin")) then
                                    Error('The negotiated rate must be within the allowed margin of %1', FDCalcRules."Allowed Margin");
                        end;
                    until

                    FDCalcRules.Next = 0;
                end;
            end;
        }
        field(6; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate(Period);
            end;
        }
        field(8; "Maturity Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Application,Active,Matured,Closed;
        }
        field(10; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(11; "FD Maturity Instructions"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Transfer All & Close Account,Renew Principal and Transfer Interest Only,Renew Both Principal & Interest,Forefeit Interest';
            OptionMembers = " ","Transfer All & Close Account","Renew Principal and Transfer Interest Only","Renew Both Principal & Interest","Forefeit Interest";

            trigger OnValidate()
            begin

                if FixedDepositType.Get(Period) then begin
                    if FixedDepositType."Call Deposit" then begin
                        if "FD Maturity Instructions" = "FD Maturity Instructions"::"Renew Both Principal & Interest" then
                            Error('This option is not applicable to call deposits');
                    end;
                end;
            end;
        }
        field(12; "Fixed Deposit cert. no"; Code[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Capture FxD certificate Number';
        }
        field(13; "FDR No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Payment From"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Bank Account","Savings Account","Pre-Posted";
        }
        field(17; "Payment Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Payment From" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Payment From" = CONST("Savings Account")) "Savings Accounts" WHERE("Member No." = FIELD("Member No."));
        }
        field(18; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Interest Earned"; Decimal)
        {
            CalcFormula = Sum("Interest Buffer"."Interest Amount" WHERE("Account No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Untransfered Interest"; Decimal)
        {
            CalcFormula = Sum("Interest Buffer"."Interest Amount" WHERE("Account No" = FIELD("No."),
                                                                         Transferred = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "FD Date Renewed"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Last Accrual Date"; Date)
        {
            CalcFormula = Max("Interest Buffer"."Interest Date" WHERE("Account No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Daily Interest Earned"; Decimal)
        {
            Editable = false;
            CalcFormula = sum("Daily Savings Interest Buffer".Amount where("Account No." = field("No."), "FDR No." = field("FDR No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "FDR No.", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        FixedDepositType: Record "Fixed Deposit Type";
        FDCalcRules: Record "FD Interest Calculation Rules";
        SavingsAccounts: Record "Savings Accounts";
        FDR: Record "Fixed Deposit Lines";
        FDRCount: Integer;
        FDRCountCode: Text;
}

