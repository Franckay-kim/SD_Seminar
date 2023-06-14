page 50140 "CSD Seminar Manager Activities"
{
    PageType = CardPart;
    Caption = 'Seminar Manager Activities';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Cue";
    Editable = false;


    layout
    {
        area(Content)
        {
            cuegroup(Registrations)
            {
                Caption = 'Registrations';
                field(Planned; rec.Planned)
                {
                }
                field(Registered; rec.Registered)
                {
                }
                actions
                {
                    action(New)
                    {
                        Caption = 'New';
                        RunObject = page "CSD Seminar Registration";
                        RunPageMode = Create;
                    }
                }


            }

            cuegroup("For Posting")
            {
                field(Closed; rec.Closed)
                {
                }
            }

        }

    }

    trigger OnOpenPage();
    begin
        if not rec.get then begin
            rec.init;
            rec.insert;
        end;
    end;
}