page 50107 "CSD Seminar Comment List"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "CSD Seminar Comment Line";
    Caption = 'seminar comment List';
    Editable = false;


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
}