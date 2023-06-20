/// <summary>
/// PageExtension CSD ResourceListExt (ID 50101) extends Record Resource List.
/// </summary>
pageextension 50101 "CSD ResourceListExt" extends "Resource List"
//CSD1.00 - 2023-30-05 - D. E. Veloper
{
    layout
    {
        modify(Type)
        {
            Visible = ShowType;
        }
        addafter(Type)
        {
            field("CSD Resource Type"; Rec."CSD Resource Type")
            {

            }
            field("CSD Maximum Participants"; Rec."CSD Maximum Participants")
            {
                Visible = ShowMaxField;
            }
        }

    }

    trigger OnOpenPage()
    begin
        ShowType := (Rec.GetFilter(Type) = '');
        ShowMaxField := (Rec.GetFilter(Type) =
            format(Rec.Type::machine));

    end;

    var
        [InDataSet]
        ShowMaxField: Boolean;
        [InDataSet]
        Showtype: Boolean;

}