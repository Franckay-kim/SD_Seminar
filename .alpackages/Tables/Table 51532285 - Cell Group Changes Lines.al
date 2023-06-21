table 51532285 "Cell Group Changes Lines"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3; Names; Text[50])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(4; "Date Of Birth"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                // IF "Date Of Birth" > TODAY THEN
                //  ERROR(DateofBirthError);
            end;
        }
        field(5; "Staff/Payroll"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "ID Number"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Signatory; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Must Sign"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Must be Present"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Picture; BLOB)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(11; Signature; BLOB)
        {
            Caption = 'Signature';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(12; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Type; Option)
        {
            OptionMembers = Member,"Chair Person",Secretary,Treasurer,"Vice Chair Persion";
        }
        field(14; "Member No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members WHERE("Customer Type" = CONST(Single));

            trigger OnValidate()
            var
                Members: Record Members;
                ImageData: Record "Image Data";
            begin
                if Members.Get("Member No.") then begin
                    Names := Members.Name;

                    "ID Number" := Members."ID No.";
                    "Date Of Birth" := Members."Date of Birth";
                    "Staff/Payroll" := Members."Payroll/Staff No.";
                    "Phone No." := Members."Mobile Phone No"
                end;
                //   ImageData.RESET;
                //   ImageData.SETRANGE(ImageData."Member No",Members."No.");
                //   IF ImageData.FIND('-') THEN BEGIN
                //    ImageData.CALCFIELDS(Picture,Signature);
                //    Picture:=ImageData.Picture;
                //    Signature:=ImageData.Signature;
                //    END;
                CellMembers.Reset;
                CellMembers.SetRange(CellMembers."Member No.", "Member No.");
                if CellMembers.FindFirst then
                    Error('This member is attached to a different cell');

                SignatoryApplication.SetRange("Account No", "Account No");
                SignatoryApplication.SetRange("Member No.", "Member No.");
                if SignatoryApplication.Find('-') then begin
                    CellGroupChanges.Get(SignatoryApplication."Header No");
                    if CellGroupChanges.Status <> CellGroupChanges.Status::Approved then
                        Error('This member is already a member within this application No: ' + SignatoryApplication."Header No");
                end;
            end;
        }
        field(15; "F Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "S Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "L Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "ID Type"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Designation; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "  ",Male,Female;
        }
        field(21; "Phone No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Substituted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Header No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Member,"Non-Member";
        }
    }

    keys
    {
        key(Key1; "Entry No", "Header No", "Account No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CellGroupChanges.Reset;
        CellGroupChanges.SetRange("No.", "Header No");
        CellGroupChanges.SetRange(Status, CellGroupChanges.Status::Approved);
        if CellGroupChanges.FindFirst then Error('You cannot modify a posted or approved one');
    end;

    trigger OnInsert()
    begin
        CellGroupChanges.Reset;
        CellGroupChanges.SetRange("No.", "Header No");
        CellGroupChanges.SetRange(Status, CellGroupChanges.Status::Approved);
        if CellGroupChanges.FindFirst then Error('You cannot modify a posted or approved one');
    end;

    trigger OnModify()
    begin
        CellGroupChanges.Reset;
        CellGroupChanges.SetRange("No.", "Header No");
        CellGroupChanges.SetRange(Status, CellGroupChanges.Status::Approved);
        if CellGroupChanges.FindFirst then Error('You cannot modify a posted or approved one');
    end;

    trigger OnRename()
    begin
        CellGroupChanges.Reset;
        CellGroupChanges.SetRange("No.", "Header No");
        CellGroupChanges.SetRange(Status, CellGroupChanges.Status::Approved);
        if CellGroupChanges.FindFirst then Error('You cannot modify a posted or approved one');
    end;

    var
        Cust: Record "Savings Accounts";
        LoanGuarantors: Record "Loan Guarantors and Security";
        Loans: Record Loans;
        LoansR: Record Loans;
        LoansG: Integer;
        GenSetUp: Record "General Set-Up";
        SelfGuaranteedA: Decimal;
        StatusPermissions: Record "Credit Ledger Entry";
        LoanProduct: Record "Loan Charges";
        TotalGuaranteed: Decimal;
        BalanceRemaining: Decimal;
        LoanGuar: Record "Loan Guarantors and Security";
        TotG: Decimal;
        Members: Record Members;
        SecReg: Record "Securities Register";
        Employer: Record Customer;
        Text001: Label '%1 Members are not allowed to guarantee loans';
        Text002: Label 'This member has self guaranteed %1 and has a balance of %2';
        LoanApp: Record Loans;
        Text003: Label 'This Loan is already %1 and cannot modify';
        Text004: Label 'This collateral has been used for loan no. %1 and has a outstanding balance of %2';
        LoanGs: Record "Loan Guarantors and Security";
        //LoanProcess: Codeunit "Loans Process";
        LoanSubHeader: Record "Guarantors Substitution";
        LoanSubLine: Record "Loan Security Sub";
        LoaneeEmployer: Code[20];
        NonMembers: Record "Non-Members";
        SignatoryApplication: Record "Cell Group Changes Lines";
        CellMembers: Record "Cell Group Members";
        CellGroupChanges: Record "Cell Group Changes";
}

