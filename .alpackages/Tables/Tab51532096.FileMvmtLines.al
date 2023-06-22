/// <summary>
/// Table File Mvmt Lines (ID 51532096).
/// </summary>
table 51532096 "File Mvmt Lines"
{
    Caption = 'File Mvmt Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "File No."; Code[20])
        {
            Caption = 'File No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; From; Code[50])
        {
            Caption = 'From';
            TableRelation = "User Setup"."User ID";
            DataClassification = ToBeClassified;
        }
        field(4; "To"; Code[50])
        {
            Caption = 'To';
            TableRelation = "User Setup"."User ID";
            DataClassification = ToBeClassified;
        }
        field(5; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = ToBeClassified;
        }
        field(6; "Time Created"; Time)
        {
            Caption = 'Time Created';
            DataClassification = ToBeClassified;
        }
        field(7; "Date Moved"; Date)
        {
            Caption = 'Date Moved';
            DataClassification = ToBeClassified;
        }
        field(8; "Time Moved"; Time)
        {
            Caption = 'Time Moved';
            DataClassification = ToBeClassified;
        }
        field(9; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(10; "Document No"; Code[30])
        {
            Caption = 'Document No.';
            FieldClass = FlowField;
            CalcFormula = lookup("File Mvmt Header"."Document No." where("File No." = field("File No.")));
        }
    }
    keys
    {
        key(PK; "File No.")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// OnApproval.
    /// </summary>
    procedure OnApproval()
    begin
        If Status = Status::Approved then begin
            "Date Moved" := WorkDate();
            "Time Moved" := Time;
            Modify();
        end;
    end;
}
