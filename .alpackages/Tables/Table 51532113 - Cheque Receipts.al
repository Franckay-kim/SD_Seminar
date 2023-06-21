table 51532113 "Cheque Receipts"
{

    fields
    {
        field(1;"No.";Code[20])
        {

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  SalesSetup.Get;
                  NoSeriesmgt.TestManual(SalesSetup."Cheque Receipts Nos");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Transaction Date";Date)
        {
        }
        field(3;"Refference Document";Code[20])
        {
        }
        field(4;"Transaction Time";Time)
        {
        }
        field(5;"Created By";Code[60])
        {
        }
        field(6;"Posted By";Code[60])
        {
        }
        field(7;Posted;Boolean)
        {
        }
        field(8;"No. Series";Code[10])
        {
        }
        field(9;"Unpaid By";Code[60])
        {
            Editable = false;
        }
        field(10;Unpaid;Boolean)
        {
            Editable = false;
        }
        field(11;"Transaction Type";Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE (Type=CONST("Sacco_Co-op Charge"));
        }
        field(12;"Clearing Bank";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(13;Status;Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
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
          SalesSetup.Get;
          SalesSetup.TestField(SalesSetup."Cheque Receipts Nos");
          NoSeriesmgt.InitSeries(SalesSetup."Cheque Receipts Nos",xRec."No. Series",0D,"No.","No. Series");
        end;

        "Transaction Time":=Time;
        "Transaction Date":=Today;
    end;

    var
        NoSeriesmgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Banking No Setup";
}

