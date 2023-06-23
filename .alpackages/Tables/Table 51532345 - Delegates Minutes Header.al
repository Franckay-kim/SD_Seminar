/// <summary>
/// Table Delegates Minutes Header (ID 51532345).
/// </summary>
table 51532345 "Delegates Minutes Header"
{
    //LookupPageId = "Delegates Meeting List";
    //DrillDownPageId = "Delegates Meeting List";
    fields
    {
        field(1; "Code"; Code[50])
        {
        }
        field(2; Venue; Text[30])
        {
        }
        field(3; "Start Time"; Time)
        {
        }
        field(4; "End Time"; Time)
        {
        }
        field(5; Month; Integer)
        {
        }
        field(6; Year; Integer)
        {
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; "Electoral Zone"; Code[50])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code;
        }
        field(11; "Created By"; Code[50])
        {
        }
        field(12; "Creation Date"; Date)
        {
        }
        field(13; Posted; Boolean)
        {
        }
        field(14; "Meeting Date"; Date)
        {
        }
        field(15; "Delegate Group"; Code[50])
        {
            TableRelation = "Delegate Groupss".Code;
        }
        field(16; "Meeting Description"; Text[100])
        {

        }
        field(17; Status; Option)
        {
            OptionMembers = Open,Pending,Approved;
        }
        field(18; "Meeting Type"; Option)
        {
            OptionMembers = ,ADM,SGM,Regional,"Mzalendo/Faithful";
        }
        field(19; Diocese; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Diocese.Code;
            trigger OnValidate()

            begin
                Diocese := UpperCase(Diocese);
            end;
        }
        field(20; "Arch Diocese"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Parish.Code where("Diocese Code" = field(Diocese));
            trigger OnValidate()

            begin
                "Arch Diocese" := UpperCase("Arch Diocese");
            end;
        }

        field(21; "Administrative Town"; Text[100])
        {
            Caption = 'Administrative Town';
            DataClassification = ToBeClassified;
        }
        field(22; Destination; Code[30])
        {
            TableRelation = "Travel Destination"."Destination Code";
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

    trigger OnInsert()
    begin
        if Code = '' then begin
            MembNoSeries.Get;
            MembNoSeries.TestField(MembNoSeries."Delegate Minutes Nos.");
            NoSeriesMgt.InitSeries(MembNoSeries."Delegate Minutes Nos.", xRec."No. Series", 0D, Code, "No. Series");
            "Created By" := UserId;
            "Creation Date" := Today;
        end;
    end;

    var
        MembNoSeries: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

