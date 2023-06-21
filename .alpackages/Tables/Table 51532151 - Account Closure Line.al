table 51532151 "Account Closure Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Account No."; Code[20])
        {
            TableRelation = "Savings Accounts";

            trigger OnValidate()
            begin
                SavAcc.Reset;
                SavAcc.SetRange("No.", "Account No.");
                if SavAcc.FindFirst then begin
                    SavAcc.CalcFields("Balance (LCY)");
                    Name := SavAcc.Name;
                    Balance := SavAcc."Balance (LCY)";
                    Amount := SavAcc."Balance (LCY)";
                    "Transfer Account" := "Account No.";
                end;
            end;
        }
        field(3; Name; Text[50])
        {
        }
        field(4; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory";
        }
        field(5; Balance; Decimal)
        {
            Editable = false;
        }
        field(6; Close; Boolean)
        {

            trigger OnValidate()
            begin
                Membershipclosure.Reset;
                Membershipclosure.SetRange(Membershipclosure."No.", "No.");
                if Membershipclosure.Find('-') then begin
                    Membershipclosure.TestField("Savings Scheme", Membershipclosure."Savings Scheme"::Specific);
                end;

                if not Close then
                    "Transfer Account" := '';
            end;
        }
        field(7; "Member No."; Code[20])
        {
        }
        field(8; Blocked; Option)
        {
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ",Credit,Debit,All;
        }
        field(9; "Transfer Account"; Code[20])
        {
            // TableRelation = "Savings Accounts" WHERE ("Member No."=FIELD("Member No."));
            //TableRelation = Vendor."No." where("Account Type" = const("Member Closure"), "Member No." = field("Member No."));

            trigger OnValidate()
            begin
                /* if "Transfer Account" <> '' then begin
                     TestField(Close, true);

                     SavAcc.Get("Transfer Account");

                     Membershipclosure.Reset;
                     Membershipclosure.SetRange(Membershipclosure."No.", "No.");
                     if Membershipclosure.Find('-') then begin
                         if SavAcc."Member No." <> Membershipclosure."Member No." then begin
                             Member.Get(SavAcc."Member No.");
                             NextofKIN.Reset;
                             NextofKIN.SetRange("ID No.", Member."ID No.");
                             NextofKIN.SetRange(Beneficiary, false);
                             if not NextofKIN.FindFirst then
                                 Error('Account Must belong to a Beneficiary or the Principal Member');
                         end;
                     end;



                 end;*/
            end;
        }
        field(10; "Product Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Share Capital,Main Shares,Fixed Deposit,Junior Savings,Registration Fee,Benevolent,Unallocated Fund,Micro Credit Deposits,NHIF,Jivinjari,School Fee,Dividend,Plot,Redeemable,KUSCCO,Housing,Creditor';
            OptionMembers = " ","Share Capital","Deposit Contribution","Fixed Deposit","Junior Savings","Registration Fee",Benevolent,"Unallocated Fund","Micro Credit Deposits",NHIF,Jivinjari,"School Fee",Dividend,Plot,Redeemable,KUSCCO,Housing,Creditor;
        }
        field(11; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "Account No.")
        {
        }
        key(Key2; Balance)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Membershipclosure.Reset;
        Membershipclosure.SetRange(Membershipclosure."No.", "No.");
        Membershipclosure.SetFilter(Membershipclosure.Status, '<>%1', Membershipclosure.Status::Open);
        if Membershipclosure.Find('-') then begin
            Error(Txt00000);
        end;
    end;

    trigger OnModify()
    begin


        /*
        Membershipclosure.RESET;
        Membershipclosure.SETRANGE(Membershipclosure."No.","No.");
        IF Membershipclosure.FIND('-') THEN BEGIN
            Membershipclosure.VALIDATE("Insurance Amount");
            Membershipclosure.MODIFY;
        END;
        */

    end;

    var
        Membershipclosure: Record "Membership closure";
        Txt00000: Label 'You cannot delete enteries when status is not open';
        SavAcc: Record "Savings Accounts";
        Member: Record Members;
        NextofKIN: Record "Next of KIN";
}

