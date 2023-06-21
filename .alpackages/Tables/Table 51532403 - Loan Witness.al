table 51532403 "Loan Witness"
{

    fields
    {
        field(1; "Loan No."; Code[30])
        {
        }
        field(2; Type; Option)
        {
            OptionCaption = 'Member,Non-Member';
            OptionMembers = Member,"Non-Member";
        }
        field(3; "Member No."; Code[20])
        {
            Caption = 'Customer CID';
            Editable = false;
            TableRelation = IF (Type = CONST(Member)) Members."No.";

            trigger OnValidate()
            begin
                Name := '';
                "ID No." := '';
                "Mobile Phone No" := '';

                if Cust.Get("Member No.") then begin
                    Name := Cust.Name;
                    "ID No." := Cust."ID No.";
                    "Mobile Phone No" := Cust."Mobile Phone No";

                    Loans.Get("Loan No.");
                    if Loans."Loan Group" <> Loans."Loan Group"::MFI then
                        if "Member No." <> '' then begin
                            LoanG.Reset;
                            LoanG.SetRange("Loan No", "Loan No.");
                            if LoanG.Find('-') then begin
                                repeat
                                    if LoanG."Member No" = "Member No." then
                                        Error('Guarantor Cannot be a Witness');
                                until LoanG.Next = 0;
                            end;
                        end;
                end
            end;
        }
        field(4; Name; Text[100])
        {

            trigger OnValidate()
            begin
                if "Mobile Phone No" = '' then
                    "Mobile Phone No" := '+2547';
            end;
        }
        field(5; "ID No."; Code[20])
        {

            trigger OnValidate()
            begin

                Loans.Get("Loan No.");
                if Loans."Loan Group" <> Loans."Loan Group"::MFI then
                    if "ID No." <> '' then begin
                        LoanG.Reset;
                        LoanG.SetRange("Loan No", "Loan No.");
                        if LoanG.Find('-') then begin
                            repeat

                                Cust.Get(LoanG."Member No");
                                if Cust."ID No." = "ID No." then
                                    Error('Guarantor Cannot be a Witness');
                            until LoanG.Next = 0;
                        end;
                    end;
            end;
        }
        field(6; "Mobile Phone No"; Code[13])
        {

            trigger OnValidate()
            begin
                "Mobile Phone No" := DelChr("Mobile Phone No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');

                if StrLen("Mobile Phone No") <> 13 then
                    Error('Phone No. should be equal to 13 characters');
            end;
        }
        field(7; Spouse; Boolean)
        {
        }
        field(8; Category; Option)
        {
            OptionCaption = 'Witness,Chairperson,Secretary,Treasurer,Magistrate';
            OptionMembers = Witness,Chairperson,Secretary,Treasurer,Magistrate;
        }
        field(9; "SMS Sent"; Boolean)
        {
        }
        field(10; "Account No."; Code[20])
        {
            TableRelation = IF (Type = CONST(Member),
                                Micro = CONST(false)) "Savings Accounts"."No." WHERE("Product Category" = CONST("Deposit Contribution"))
            ELSE
            IF (Type = CONST(Member),
                                         Micro = CONST(true)) "Savings Accounts"."No." WHERE("Product Category" = CONST("Micro Credit Deposits"),
                                                                                            "Group Account No" = FIELD("Group Code"));

            trigger OnValidate()
            begin
                "Member No." := '';

                if SavingsAccounts.Get("Account No.") then
                    "Member No." := SavingsAccounts."Member No.";

                Validate("Member No.");
            end;
        }
        field(11; Micro; Boolean)
        {

            trigger OnValidate()
            begin

                if Loans.Get("Loan No.") then
                    if ProductFact.Get(Loans."Loan Product Type") then
                       /* if ProductFact."Loan Group" = ProductFact."Loan Group"::MFI then*/ begin
                        if Cust.Get(Loans."Member No.") then
                            "Group Code" := Cust."Group Code";
                    end;
            end;
        }
        field(12; "Group Code"; Code[20])
        {
        }
        field(13; Relationship; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'LookUp to Relationships Table';
            TableRelation = "Relationship Types";

            trigger OnValidate()
            begin
                //TESTFIELD("Date of Birth");
                //TESTFIELD("ID No./Birth Cert. No.");
                //TESTFIELD(Address);
                //TESTFIELD(Telephone);
            end;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "ID No.", Category)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Loans.Get("Loan No.") then begin
            if Loans.Posted = true then Error('You cannot modify, loan already posted');
        end;
    end;

    trigger OnModify()
    begin
        if Loans.Get("Loan No.") then begin
            if Loans.Posted = true then Error('You cannot modify, loan already posted');
        end;
    end;

    trigger OnRename()
    begin
        if Loans.Get("Loan No.") then begin
            if Loans.Posted = true then Error('You cannot modify, loan already posted');
        end;
    end;

    var
        Cust: Record Members;
        LoanG: Record "Loan Guarantors and Security";
        SavingsAccounts: Record "Savings Accounts";
        Loans: Record Loans;
        ProductFact: Record "Product Factory";
}

