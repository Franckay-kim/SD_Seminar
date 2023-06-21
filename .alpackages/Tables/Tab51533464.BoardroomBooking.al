table 51533464 BoardroomBooking
{
    Caption = 'Boardroom Booking';

    fields
    {
        field(1; "Booking No."; Code[10])
        {
            Caption = 'Booking No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Booking No." <> xRec."Booking No." then begin
                    boardroomSetup.GET;
                    noSeriesMgt.TestManual(boardroomSetup."Booking Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Boardroom Name"; Option)
        {
            Caption = 'Boardroom';
            // TableRelation = Boardroom;
            OptionCaption = 'St. Matthews, St. Alexandra';
            OptionMembers = "St. Matthews","St. Alexandra";
        }
        field(3; "Meeting Desc"; Text[50])
        {
            Caption = 'Meeting Description';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';

        }
        field(5; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
            trigger OnValidate()
            begin
                if Format("Ending Time") <> '' then begin
                    if "Starting Time" = "Ending Time" then
                        Error('Starting time cannot be equal to ending time.')
                    else
                        if "Starting Time" > "Ending Time" then
                            Error('Starting time cannot be after ending time.');
                end;
            end;
        }
        field(12; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
            trigger OnValidate()
            begin
                if "Ending Time" = "Starting Time" then
                    Error('Starting time cannot be equal to ending time.')
                else
                    if "Starting Time" > "Ending Time" then
                        Error('Starting time cannot be after ending time.');
            end;
        }
        field(6; "Buffet Lunch"; Boolean)
        {
            Caption = 'Buffet Lunch';
        }
        field(7; "Foolscap Paper"; Boolean)
        {
            Caption = 'Foolscap Paper';
        }
        field(8; Snacks; Boolean)
        {
            Caption = 'Snacks';
        }
        field(9; "Branded Pens"; Boolean)
        {
            Caption = 'Branded Pens';
        }
        field(10; "Number of Attendees"; Integer)
        {
            Caption = 'Number of Attendees';
        }
        field(11; Projector; Boolean)
        {
            Caption = 'Projector';
        }
        field(13; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(14; "Status"; Option)
        {
            Caption = 'Approval Status';
            OptionCaption = 'Open,Pending, Approved, Denied';
            OptionMembers = Open,"Pending","Approved","Denied";
        }
        field(15; "Duration"; Duration)
        {
            Caption = 'Duration';
        }

        field(20; "Attendees"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Attendee;
        }
    }
    keys
    {
        key(PK; "Booking No.")
        {
            Clustered = true;
        }
    }

    var
        noSeriesMgt: Codeunit NoSeriesManagement;
        boardroomSetup: Record "Boardroom Setup";
        boardrooms: Record BoardroomBooking;
        oldStartingTime: Time;
        oldEndingTime: Time;


    trigger OnInsert()
    begin
        if "Booking No." = '' then begin
            boardroomSetup.get;
            boardroomSetup.TestField("Booking Nos.");
            noSeriesMgt.InitSeries(boardroomSetup."Booking Nos.", xRec."No. Series", 0D, "Booking No.", "No. Series");
        end;
    end;

    procedure CheckExistingDate(var existingDate: Boolean; dateToCheck: Date)
    begin
        existingDate := false;
        boardrooms.SetRange("Boardroom Name", Rec."Boardroom Name");
        boardrooms.SetFilter("Booking No.", '<>%1', Rec."Booking No.");
        boardrooms.SETRANGE("Date", dateToCheck);
        existingDate := boardrooms.FINDSET;
    end;

    procedure CheckStartingTime(var existingStartingTime: Boolean; timeToCheck: Time)
    var
        Value1: Time;
        Value2: Time;
        oldStartingTime: Boolean;
        oldTime: List of [Time];
    begin
        existingStartingTime := false;
        boardrooms.SetRange("Boardroom Name", Rec."Boardroom Name");
        boardrooms.SetFilter("Booking No.", '<>%1', Rec."Booking No.");
        boardrooms.SETRANGE("Starting Time", timeToCheck);
        existingStartingTime := boardrooms.FINDSET;

        if existingStartingTime then begin
            if boardrooms.FindFirst then begin
                Value1 := boardrooms."Starting Time";
            end;
        end;
        Message('Existing starting time ' + Format(Value1) + ' New starting time' + Format(timeToCheck));

        if not existingStartingTime then begin
            if boardrooms.FindFirst then begin
                Value2 := boardrooms."Starting Time";
            end;
        end;
        Message('Value 2 Existing starting time ' + Format(Value2) + ' New starting time' + Format(timeToCheck));


        boardrooms.SetFilter("Booking No.", '<>%1', Rec."Booking No.");
        boardrooms.SetRange("Starting Time", timeToCheck);
        oldStartingTime := boardrooms.FindSet;
        if oldStartingTime then begin

        end;

        if boardrooms.FindFirst then begin
            Value2 := boardrooms."Starting Time";
        end;


    end;

    procedure CheckEndingTime(var existingEndingTime: Boolean; timeToCheck: Time) returnEndingTime: Time
    var
        Value1: Time;
    begin
        existingEndingTime := false;
        boardrooms.SetRange("Boardroom Name", Rec."Boardroom Name");
        boardrooms.SetFilter("Booking No.", '<>%1', Rec."Booking No.");
        boardrooms.SETRANGE("Ending Time", timeToCheck);
        existingEndingTime := boardrooms.FINDSET;

        if existingEndingTime then begin
            if boardrooms.FindFirst then begin
                Value1 := boardrooms."Ending Time";
            end;
        end;
        Message('Existing ending time ' + Format(Value1) + ' New ending time' + Format(timeToCheck));
    end;

    procedure notifyOnApproval()
    begin


        EmailAttendees();
    end;

    procedure EmailAttendees()
    var
        //EmailMessage: Codeunit "Email Message";
        // Email: Codeunit Email;

        MeetingAttendee: Record "BoardRoom Attendees";
        Members: Record Members;

        // XmlParameters: text[250];
        Recipients: List of [Text];
        CCRecipients: List of [Text];
        BccRecipients: List of [Text];
        Subject: Text;
        Body: Text;
    begin
        Clear(Recipients);
        MeetingAttendee.Reset();
        MeetingAttendee.SetRange("Booking No.", Rec."Booking No.");
        if MeetingAttendee.FindSet() then begin
            Members.Reset();
            Members.SetRange("No.", MeetingAttendee."Member No.");
            if Members.Find('-') then
                if Members."E-Mail" <> '' then
                    Recipients.Add(Members."E-Mail");

        end;




        Subject := CompanyName + 'BOARDROOM BOOKING CONFIRMATION.';
        Body := '<HR><br><br>Dear Attendees ,<br><br>'
        + 'The boardroom for the meeting has been approved. <br><br>' + 'Kind Regards';
        /* EmailMessage.Create(Recipients, Subject, Body, true, CCRecipients, BccRecipients);

        Email.Send(EmailMessage, Enum::"Email Scenario"::Default); */



    end;


}

