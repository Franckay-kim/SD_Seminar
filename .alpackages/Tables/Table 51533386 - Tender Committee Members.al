/// <summary>
/// Table Tender Committee Members (ID 51533386).
/// </summary>
table 51533386 "Tender Committee Members"
{
    // version TENDER

    Caption = 'HR Activity Participants';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Company Activity';
            OptionMembers = "Company Activity";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = true;
        }
        field(4; "Sequence No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Sequence No.';
        }
        field(5; "Approval Code"; Code[20])
        {
            Caption = 'Approval Code';
        }
        field(6; "Sender ID"; Code[50])
        {
            Caption = 'Sender ID';
            Editable = true;
        }
        field(7; Contribution; Decimal)
        {
            Caption = 'Contribution';
        }
        field(8; "Approver ID"; Code[50])
        {
            Caption = 'Participant User ID';
            Editable = true;
        }
        field(9; "Activity Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Created,Open,Canceled,Rejected,Approved';
            OptionMembers = Created,Open,Canceled,Rejected,Approved;
        }
        field(10; "Date-Time Sent for Approval"; DateTime)
        {
            Caption = 'Date-Time Sent for Approval';
        }
        field(11; "Last Date-Time Modified"; DateTime)
        {
            Caption = 'Last Date-Time Modified';
        }
        field(12; "Last Modified By ID"; Code[50])
        {
            Caption = 'Last Modified By ID';
        }
        field(13; Comment; Boolean)
        {

        }
        field(14; "Event Date"; DateTime)
        {
            Caption = 'Event Date';
            Editable = false;
        }
        field(15; "Event Code"; Code[10])
        {
            AutoFormatType = 1;
            Caption = 'Event Code';
            Editable = false;
        }
        field(16; "Event Description"; Text[30])
        {
            AutoFormatType = 1;
            Caption = 'Event Description';
            Editable = false;
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(18; "Approval Type"; Option)
        {
            Caption = 'Approval Type';
            OptionCaption = '" ,Sales Pers./Purchaser,Approver"';
            OptionMembers = " ","Sales Pers./Purchaser",Approver;
        }
        field(19; "Limit Type"; Option)
        {
            Caption = 'Limit Type';
            OptionCaption = 'Approval Limits,Credit Limits,Request Limits,No Limits';
            OptionMembers = "Approval Limits","Credit Limits","Request Limits","No Limits";
        }
        field(20; "Event Venue"; Text[30])
        {
            Caption = 'Event Venue';
            Editable = false;
        }
        field(21; "Email Message"; Text[250])
        {
            Caption = 'Email Message';
        }
        field(22; Participant; Code[20])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate();
            begin
                HREmp.RESET;
                HREmp.SETRANGE(HREmp."No.", Participant);
                IF HREmp.FIND('-') THEN BEGIN
                    "Partipant Name" := HREmp."Full Name";
                    "Participant Email" := HREmp."Company E-Mail";
                    "User ID" := HREmp."User ID";
                END;

                IF HREmp.GET(Participant) THEN
                    "Approver ID" := HREmp."User ID";
                // HRCompanyActivities.GET("Document No.");
                "Event Date" := HRCompanyActivities.Date;
                "Event Venue" := HRCompanyActivities.Venue;
                //"Email Message":=HRCompanyActivities."Email Message";
                "Event Code" := HRCompanyActivities.Code;
                //"Event Description":=HRCompanyActivities.Description;
                "Sender ID" := USERID;
                "Activity Status" := "Activity Status"::Created;

            end;
        }
        field(23; Notified; Boolean)
        {
            Editable = false;
        }
        field(24; "Partipant Name"; Text[60])
        {
        }
        field(25; "Attendance Confimed"; Boolean)
        {
        }
        field(26; "Line. No"; Integer)
        {
            AutoIncrement = false;
        }
        field(27; "Participant Email"; Text[100])
        {
        }
        field(28; "User ID"; Code[60])
        {
        }
        field(29; "RFQ No"; Code[20])
        {
        }
        field(30; Role; Option)
        {
            OptionCaption = 'Member,Secretary,Chairman';
            OptionMembers = Member,Secretary,Chairman;
        }
        field(31; "Evaluation Committee"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", Participant)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin

    end;

    var
        HRCompanyActivities: Record "Tender Committee Activities";
        HREmp: Record "HR Employees";
        TendComm: Record "Tender Committee Members";


}

