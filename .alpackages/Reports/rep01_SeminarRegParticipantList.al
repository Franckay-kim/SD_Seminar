/// <summary>
/// Report CSD SeminarRegParticipantList (ID 50101).
/// </summary>
report 50101 "CSD SeminarRegParticipantList"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Layouts/SeminarRegParticipantList.rdl';
    Caption = 'Seminar Reg.-Participant List';
    DefaultLayout = RDLC;



    dataset
    {
        dataitem(SeminarRegistrationHeader; "Seminar Registration Header")
        {

            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Seminar No.";

            column("No_"; "No.")
            {
                IncludeCaption = true;
            }
            column("Seminar_No"; "Seminar No.")
            {
                IncludeCaption = true;
            }
            column("Seminar_Name"; "Seminar Name")
            {
                IncludeCaption = true;
            }
            column("Starting_Date"; "Starting Date")
            {
                IncludeCaption = true;
            }
            column("Duration"; Duration)
            {
                IncludeCaption = true;
            }
            column("Instructor_Name"; "Instructor Name")
            {
                IncludeCaption = true;
            }
            column("RoomName"; "Room Name")
            {
                IncludeCaption = true;
            }

            dataitem(SeminarRegistrationLine; "CSD Seminar Registration Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLink = "Document No." = field("No.");

                column("Bill_To_Customer_No"; "Bill-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column("Participant_Contact_No"; "Participant Contact No.")
                {
                    IncludeCaption = true;
                }
                column("Participant_Name"; "Participant Name")
                {
                    IncludeCaption = true;
                }

            }
        }

        dataitem("Company Information"; "Company Information")
        {
            column(Company_Name; Name)
            {
            }
        }

    }




    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    labels
    {
        SeminarRegistrationHeaderCap = 'Seminar Registration List';
    }

}