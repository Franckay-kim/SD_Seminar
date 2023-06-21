table 51532182 "Document Exemptions Auth."
{


    fields
    {
        field(1; "Entry No."; Code[80])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Entry No." <> xRec."Entry No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Document Apprvls.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = 'Loan,Others';
            OptionMembers = Loan,Others;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;

            trigger OnValidate()
            var
                VarVariant: Variant;
            //CustomApprovals: Codeunit "Custom Approvals Codeunit";
            begin
                if Loans.Get("Document No.") then begin

                    VarVariant := Rec;
                    /*if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);*/
                end;
            end;
        }
        field(4; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            Editable = false;
        }
        field(5; "Approval Code"; Code[100])
        {
            Caption = 'Approval Code';
            Editable = false;
        }
        field(6; "Sender ID"; Code[100])
        {
            Caption = 'Sender ID';
            Editable = false;
        }
        field(7; "Salespers./Purch. Code"; Code[10])
        {
            Caption = 'Salespers./Purch. Code';
            Editable = false;
        }
        field(8; "Approver ID"; Code[100])
        {
            Caption = 'Approver ID';
            Editable = false;
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Approved';
            OptionMembers = Open,"Pending Approval",Rejected,Approved;

            trigger OnValidate()
            var
            // GenNewAvailCreditLimit: Codeunit "Mngt. Routine Processes";
            begin

            end;
        }
        field(10; "Date-Time Sent for Approval"; DateTime)
        {
            Caption = 'Date-Time Sent for Approval';
            Editable = false;
        }
        field(11; "Last Date-Time Modified"; DateTime)
        {
            Caption = 'Last Date-Time Modified';
            Editable = false;
        }
        field(12; "Last Modified By ID"; Code[100])
        {
            Caption = 'Last Modified By ID';
            Editable = false;
        }
        field(13; Comment; Boolean)
        {
            CalcFormula = Exist("Approval Comment Line" WHERE("Table ID" = FIELD("Table ID"),
                                                               "Document No." = FIELD("Document No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Due Date"; Date)
        {
            Caption = 'Due Date';
            Editable = false;
        }
        field(15; Amount; Decimal)
        {
            AutoFormatType = 1;
            Editable = false;
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Editable = false;
        }
        field(18; "Approval Type"; Option)
        {
            Caption = 'Approval Type';
            Editable = false;
            OptionCaption = ' ,Sales Pers./Purchaser,Approver';
            OptionMembers = " ","Sales Pers./Purchaser",Approver;
        }
        field(19; "Limit Type"; Option)
        {
            Caption = 'Limit Type';
            Editable = false;
            OptionCaption = 'Approval Limits,Credit Limits,Request Limits,No Limits';
            OptionMembers = "Approval Limits","Credit Limits","Request Limits","No Limits";
        }
        field(20; "Available Credit Limit (LCY)"; Decimal)
        {
            Editable = false;
        }
        field(21; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
        }
        field(22; "No. Series"; Code[80])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(23; "Comments For Exemptions"; Text[250])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "Entry No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField("Document Apprvls.");
            NoSeriesMgt.InitSeries(SeriesSetup."Document Apprvls.", xRec."No. Series", 0D, "Entry No.", "No. Series");
        end;
    end;

    var
        SeriesSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Loans: Record Loans;
}

