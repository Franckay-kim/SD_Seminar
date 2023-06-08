page 50106 "CSD Seminar Comment Sheet"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Comment Line";
    Caption = 'seminar comment sheet';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Rec.Date)
                {

                }
                field(code; Rec.code)
                {
                    Visible = false;
                }
                field(comment; Rec.comment)
                {

                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)

    begin
        rec.SetupNewLine;
    end;
}