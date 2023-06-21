table 51533385 "Tender Committee Activities"
{
    // version TENDER

    //LookupPageID = "Tender Committee List";

    fields
    {
        field(1; "Code"; Code[10])
        {

            trigger OnValidate();
            var
                HRSetup: Record "Purchases & Payables Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                IF Code <> xRec.Code THEN BEGIN
                    HRSetup.GET;
                    //NoSeriesMgt.TestManual(HRSetup."Tender Committee Nos.");
                    //"No. Series" := '';
                END;
            end;
        }
        field(2; "RFQ Description"; Text[200])
        {
        }
        field(3; Date; DateTime)
        {
        }
        field(4; Venue; Text[200])
        {
        }
        field(5; "Employee Responsible"; Code[20])
        {
            TableRelation = "HR Employees"."No." WHERE(Status = CONST(Active));

            trigger OnValidate();
            var
                HREmp: Record "HR Employees";
                EmpName: Text;
            begin
                HREmp.RESET;
                HREmp.SETRANGE(HREmp."No.", "Employee Responsible");
                IF HREmp.FIND('-') THEN BEGIN
                    EmpName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Employee Name" := EmpName;
                END;
            end;
        }
        field(6; Costs; Decimal)
        {
        }
        field(7; "G/L Account No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate();
            var
                GLAccts: Record "G/L Account";
            begin
                GLAccts.RESET;
                GLAccts.SETRANGE(GLAccts."No.", "G/L Account No");
                IF GLAccts.FIND('-') THEN BEGIN
                    "G/L Account Name" := GLAccts.Name;
                END;
            end;
        }
        field(8; "Bal. Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate();
            begin
                //{
                //IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN
                //GLAccts.GET(GLAccts."No.")
                //ELSE
                //Banks.GET(Banks."No.");
                //}
            end;
        }
        field(11; Posted; Boolean)
        {
            Editable = false;
        }
        field(16; "Email Message"; Text[250])
        {
        }
        field(17; "No. Series"; Code[10])
        {
        }
        field(18; Closed; Boolean)
        {
            Editable = true;
        }
        field(19; "Contribution Amount (If Any)"; Decimal)
        {
        }
        field(20; "Activity Status"; Option)
        {
            OptionCaption = 'Planning,On going,Complete';
            OptionMembers = Planning,"On going",Complete;
        }
        field(21; "G/L Account Name"; Text[50])
        {
        }
        field(22; "Employee Name"; Text[50])
        {
        }
        field(23; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility CenterBR".Code;
        }
        field(24; Status; Option)
        {
            Editable = true;
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(25; "RFQ No."; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No." WHERE(Status = FILTER(Released));

            trigger OnValidate();
            var
                PurchaseQuoteHeader: Record "Purchase Quote Header";
            begin
                PurchaseQuoteHeader.RESET;
                PurchaseQuoteHeader.SETRANGE(PurchaseQuoteHeader."No.", "RFQ No.");
                IF PurchaseQuoteHeader.FIND('-') THEN BEGIN
                    "RFQ Description" := PurchaseQuoteHeader."Posting Description";
                    "User ID" := USERID;
                    "Date Created" := TODAY;
                END;
            end;
        }
        field(26; "User ID"; Code[60])
        {
        }
        field(27; "Date Created"; Date)
        {
        }
        field(28; Time; Time)
        {
        }
        field(29; "Last Modified By"; Code[60])
        {
        }
        field(30; "Last Modified On"; Date)
        {
        }
        field(31; "Last Modified At"; Time)
        {
        }
        field(34; "Member Count"; Integer)
        {
            CalcFormula = count("Tender Committee Members" where("Document No." = field(Code)));
            FieldClass = FlowField;
        }
        field(35; Subject; Text[250])
        {
        }
        field(36; "Evaluation Committe"; Boolean)
        {
        }
        field(37; "Secretary Comment"; Text[250])
        {
        }
        field(38; "Committee Type"; Option)
        {
            OptionMembers = ,Evaluation,Opening;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin

        IF Code = '' THEN BEGIN
            HRSetup.GET;
            // HRSetup.TESTFIELD(HRSetup."Tender Committee Nos.");
            // NoSeriesMgt.InitSeries(HRSetup."Tender Committee Nos.", xRec."No. Series", 0D, Code, "No. Series");
        END;
        "Last Modified At" := Time;
        "Last Modified By" := USERID;
        "Last Modified On" := TODAY;
        Date := CREATEDATETIME(TODAY, Time);
        "Date Created" := TODAY;

        "User ID" := USERID;
    end;

    trigger OnModify();
    begin
        "Last Modified At" := Time;
        "Last Modified By" := USERID;
        "Last Modified On" := TODAY;
    end;

    trigger OnRename();
    begin
        "Last Modified At" := Time;
        "Last Modified By" := USERID;
        "Last Modified On" := TODAY;
    end;

    var
        GLAccts: Record "G/L Account";
        Banks: Record "Bank Account";
        Text000: Label 'You have canceled the create process.';
        Text001: Label 'Replace existing attachment?';
        Text002: Label 'You have canceled the import process.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HREmp: Record "HR Employees";
        EmpName: Text;
        HRSEtup: Record "Purchases & Payables Setup";
}

