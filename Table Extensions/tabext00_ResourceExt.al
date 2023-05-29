tableextension 50100 "CSD ResourceExt" extends Resource
// CSD1.00 - 2018-01-01 - D. E. Veloper
{
    fields
    {
        modify("Profit %")
        {
            trigger OnAfterValidate()
            begin
                Rec.TestField("Unit Cost");

            end;
        }
        modify(Type)
        {
            OptionCaption = 'Instructor,Room';
        }
        field(50101; "CSD Resource Type"; Option)
        {
            Caption = 'Resource Type';
            OptionMembers = "Internal","External";
            OptionCaption = 'Internal,External';
        }
    }

    var
        myInt: Integer;
}