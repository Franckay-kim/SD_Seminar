table 51533204 "HR Overtime Lines"
{

    fields
    {
        field(1;"Staff No.";Code[10])
        {
        }
        field(2;Date;Date)
        {
        }
        field(3;"Start Time";Time)
        {

            trigger OnValidate()
            begin
                if "End Time" <> 0T then
                begin
                    fnCalculateEndTime;
                end;
            end;
        }
        field(4;"End Time";Time)
        {

            trigger OnValidate()
            begin
                if "Start Time" <> 0T then
                begin
                    fnCalculateEndTime;
                end;
            end;
        }
        field(5;"Work Done";Text[150])
        {
        }
        field(6;"Application Code";Code[10])
        {
        }
        field(13;"Overtime Type";Option)
        {
            OptionCaption = ' ,Weekend,Holiday,Extra Hours';
            OptionMembers = " ",Weekend,Holiday,"Extra Hours";
        }
        field(14;"Overtime Hours";Decimal)
        {
        }
        field(15;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1;"Line No.","Application Code")
        {
        }
        key(Key2;"Overtime Type","Line No.")
        {
            SumIndexFields = "Overtime Hours";
        }
    }

    fieldgroups
    {
    }

    var
        HROvertimeDetails: Record "HR Overtime Lines";
        HROvertime: Record "HR Overtime Header";
        Text0001: Label '[End Time %1 ] CANNOT be less than the [Start Time %2]';

    local procedure fnCalculateEndTime()
    begin

        if "End Time" < "Start Time" then
        begin
            Error(Text0001,"End Time","Start Time");
        end else
        begin
            "Overtime Hours":=("End Time" - "Start Time")/3600000;
        end;
    end;
}

