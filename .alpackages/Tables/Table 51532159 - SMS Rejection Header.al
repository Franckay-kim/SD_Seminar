table 51532159 "SMS Rejection Header"
{

    fields
    {
        field(1;"No.";Code[20])
        {

            trigger OnValidate()
            begin
                if "No."<> xRec."No." then begin
                  NoSetup.Get;
                  NoSeriesMgt.TestManual(NoSetup."SMS Subscription");
                  "No. Series" := '';
                  end;
            end;
        }
        field(2;"Member No";Code[20])
        {
            TableRelation = Members;

            trigger OnValidate()
            begin
                if Members.Get("Member No") then
                    Name:=Members.Name
                else
                    Name:='';
            end;
        }
        field(3;Name;Text[100])
        {
            Editable = false;
        }
        field(4;"No. Series";Code[10])
        {
            Editable = false;
        }
        field(5;"Approval Status";Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(6;"Approved By";Code[50])
        {
            Editable = false;
        }
        field(7;"Date Approved";Date)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "No." = '' then begin
          NoSetup.Get();
          NoSetup.TestField(NoSetup."SMS Subscription");
          NoSeriesMgt.InitSeries(NoSetup."SMS Subscription",xRec."No. Series",0D,"No.","No. Series");
          end;
    end;

    var
        Members: Record Members;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSetup: Record "Credit Nos. Series";
}

