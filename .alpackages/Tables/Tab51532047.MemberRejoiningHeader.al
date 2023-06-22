/// <summary>
/// Table Member Rejoining Header (ID 51532047).
/// </summary>
table 51532047 "Member Rejoining Header"
{
    Caption = 'Member Rejoining Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeriesSetup.Get;
                    NoSeriesMgt.TestManual(SeriesSetup."Member Reactivation Nos.");
                    "No. Series" := '';
                    "No." := UpperCase("No.");
                    "Created By" := UserId;
                end;
            end;
        }
        field(2; "Member No."; Code[30])
        {
            Caption = 'Member No.';
            DataClassification = ToBeClassified;
            TableRelation = Members."No." where(Status = filter("Withdrawal Application" | Closed));

            trigger OnValidate()
            var
                Members: Record Members;
                GenSetup: Record "General Set-Up";
            begin
                IF Members.Get("Member No.") then begin
                    "Member Name" := Members.Name;
                    "Member Status" := Members.status;
                end;
                IF GenSetup.Get() then begin
                    "Reactivation Charge" := GenSetup."Rejoining Fee";
                end;
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Caption = 'Member Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Payment Reference"; Code[20])
        {
            Caption = 'Payment Reference';
            DataClassification = ToBeClassified;
            TableRelation = "Receipts Header"."No.";

            trigger OnValidate()
            var
                ReceiptH: Record "Receipts Header";
                MemberRejoin: Record "Member Rejoining Header";
            begin
                ReceiptH.Reset();
                ReceiptH.SetRange("No.", "Payment Reference");
                If ReceiptH.Find('-') then begin
                    //"Amount Paid" := 
                    //ReceiptH.CalcFields("Amount Recieved")
                end;
                MemberRejoin.Reset();
                MemberRejoin.SetRange("Payment Reference", Rec."Payment Reference");
                MemberRejoin.SetFilter("No.", '<>%1', Rec."No.");
                if MemberRejoin.Find('-') then
                    Error('This payment reference has been used in a previous member rejoining');
            end;
        }
        field(5; "Created By"; Code[30])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,Pending,Approved,Rejected;
            DataClassification = ToBeClassified;
        }
        field(7; Processed; Boolean)
        {
            Caption = 'Processed';
            DataClassification = ToBeClassified;
        }
        field(8; "Reactivation Charge"; Decimal)
        {
            Caption = 'Reactivation Charge';
            Editable = false;
            //TableRelation = "Transaction Charges"."Charge Code";
            DataClassification = ToBeClassified;
        }
        field(9; "Rejoining Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "No. Series"; Code[10])
        {
            Editable = false;
        }
        field(11; "Member Status"; Option)
        {
            OptionMembers = " ",New,Active,Dormant,Frozen,"Withdrawal Application",Withdrawn,Deceased,Defaulter,Closed,Blocked,Creditor;
        }
        field(12; "Amount Paid"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Receipts Header"."Amount Recieved" where("No." = field("Payment Reference")));

        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()

    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Member Reactivation Nos.");
            NoSeriesMgt.InitSeries(SeriesSetup."Member Reactivation Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
