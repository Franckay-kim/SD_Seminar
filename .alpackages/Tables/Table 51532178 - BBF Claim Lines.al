/// <summary>
/// Table BBF Claim Lines (ID 51532178).
/// </summary>
table 51532178 "BBF Claim Lines"
{


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Member No"; Code[20])
        {
            Description = 'LookUp to Member Application Table';
            TableRelation = Members."No.";

            trigger OnValidate()
            begin
                if AccountM.Get("Member No") then
                    Name := AccountM.Name;
                AccountF.Reset;
                AccountF.SetRange("Member No.", "Member No");
                if AccountF.Find('-') then
                    "Account No" := AccountF."No.";
            end;
        }
        field(3; Name; Text[50])
        {
            Editable = false;
            NotBlank = true;
        }
        field(4; Relationship; Text[30])
        {
            Description = 'LookUp to Relationships Table';
            Editable = false;
            TableRelation = "Relationship Types";
        }
        field(5; Beneficiary; Boolean)
        {
            Editable = false;
        }
        field(6; "Date of Birth"; Date)
        {
            Editable = false;

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date of Birth" > Today then
                    Error(DateofBirthError);
            end;
        }
        field(7; Address; Text[30])
        {
            Editable = false;
        }
        field(8; Telephone; Code[20])
        {
            CharAllowed = '0123456789';
            Editable = false;
        }
        field(9; Fax; Code[10])
        {
        }
        field(10; Email; Text[30])
        {
        }
        field(11; "ID No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                "ID No." := DelChr("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
                FieldLength("ID No.", 10);
            end;
        }
        field(12; "%Allocation"; Decimal)
        {
            Editable = false;
            MinValue = 0;
        }
        field(13; Type; Option)
        {
            Editable = false;
            OptionCaption = 'Next of Kin,Spouse,Benevolent Beneficiary,Family Member';
            OptionMembers = "Next of Kin",Spouse,"Benevolent Beneficiary","Family Member";
        }
        field(14; Deceased; Boolean)
        {
            Editable = false;
        }
        field(15; "BBF Entitlement Code"; Code[10])
        {
            Editable = false;
            TableRelation = "BBF Entitlement".Code;
        }
        field(16; "BBF Entitlement Claimed"; Decimal)
        {
            Editable = false;
        }
        field(17; "Line No."; Code[50])
        {
            Editable = false;
            TableRelation = "Payments Header"."No." WHERE("Payment Type" = CONST("Benevolent Claim"));
        }
        field(18; "Account No"; Code[80])
        {
            Editable = false;
        }
        field(19; "Next of Kin"; Text[150])
        {
            TableRelation = "Next of KIN".Name WHERE(Type = CONST("Benevolent Beneficiary"),
                                                      Deceased = CONST(false),
                                                      Beneficiary = CONST(true),
                                                      "Account No" = FIELD("Member No"));

            trigger OnValidate()
            var
                Entitlement: Record "BBF Entitlement";
                MaxKinNo: Integer;
                ErrorOnMaxEntitlement: Label 'Member has exhausted the Max. No. of -%1- entitlement under this category.Category is %2.';
            //RunPeriodicTrans: Codeunit "Sacco Transactions";
            begin
                KinDetails.Reset;
                KinDetails.SetRange(Name, "Next of Kin");
                if KinDetails.Find('-') then
                    KinDetails.TestField("BBF Entitlement");
                KinDetails.TestField("BBF Entitlement Code");
                Relationship := KinDetails.Relationship;
                "BBF Entitlement Claimed" := KinDetails."BBF Entitlement";
                "BBF Entitlement Code" := KinDetails."BBF Entitlement Code";
                Beneficiary := KinDetails.Beneficiary;
                "ID No." := KinDetails."ID No.";
                Deceased := KinDetails.Deceased;
                Type := KinDetails.Type;
                "Date of Birth" := KinDetails."Date of Birth";
                Address := KinDetails.Address;

                if Entitlement.Get("BBF Entitlement Code") then begin

                    KinDetails.Reset;
                    KinDetails.SetRange(Relationship, Relationship);
                    KinDetails.SetRange(Deceased, true);
                    if KinDetails.Find('-') then
                        repeat
                            MaxKinNo := KinDetails.Count;
                        until KinDetails.Next = 0;

                    if MaxKinNo > Entitlement."Max No." then Error(ErrorOnMaxEntitlement, MaxKinNo, Relationship);
                end;
            end;
        }
        field(20; Posted; Boolean)
        {
        }
        field(22; "Loan No."; Code[20])
        {
            TableRelation = Loans WHERE("Loan Account" = FIELD("Account No"));
        }
        field(23; "Transaction Type"; Option)
        {
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal';
            OptionMembers = " ",Loan,Repayment,"Interest Due","Interest Paid",Bills,Appraisal;
        }
        field(24; "Requisation No."; Code[20])
        {
        }
        field(25; "BBF Entitlement Paid"; Decimal)
        {

            trigger OnValidate()
            begin
                if "BBF Entitlement Paid" > "BBF Entitlement Claimed" then Error(Err0001);
                Difference := "BBF Entitlement Claimed" - "BBF Entitlement Paid";
            end;
        }
        field(26; Difference; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Member No", "Requisation No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        BHeader.Reset;
        BHeader.SetRange("No.", "Line No.");
        BHeader.SetFilter(Status, '<>%1', BHeader.Status::Open);
        if BHeader.Find('-') then begin
            Error(ErrorOnDelMod, BHeader.Status);
        end;
    end;

    trigger OnModify()
    begin
        BHeader.Reset;
        BHeader.SetRange("No.", "Line No.");
        BHeader.SetFilter(Status, '<>%1', BHeader.Status::Open);
        if BHeader.Find('-') then begin
            Error(ErrorOnDelMod, BHeader.Status);
        end;
    end;

    trigger OnRename()
    begin
        BHeader.Reset;
        BHeader.SetRange("No.", "Line No.");
        BHeader.SetFilter(Status, '<>%1', BHeader.Status::Open);
        if BHeader.Find('-') then begin
            Error(ErrorOnDelMod, BHeader.Status);
        end;
    end;

    var
        NOK: Record "Next of KIN";
        TotalA: Decimal;
        NOK1: Record "Next of KIN";
        AccountM: Record Members;
        KinDetails: Record "Next of KIN";
        AccountF: Record "Savings Accounts";
        BHeader: Record "Payments Header";
        ErrorOnDelMod: Label 'You cannot DELETE or MODIFY a Document whose status is %1';
        Err0001: Label 'Amount Paid cannot be more than claimed';

    /// <summary>
    /// FieldLength.
    /// </summary>
    /// <param name="VarVariant">Text.</param>
    /// <param name="FldLength">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;
}

