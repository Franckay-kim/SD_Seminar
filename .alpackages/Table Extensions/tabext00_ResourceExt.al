/// <summary>
/// TableExtension CSD ResourceExt (ID 50100) extends Record Resource.
/// </summary>
tableextension 50100 "CSD ResourceExt" extends Resource
// CSD1.00 - 2023-29-05 - D. E. Veloper
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
            Caption = 'Instructor,Room';
        }
        field(50101; "CSD Resource Type"; Option)
        {
            Caption = 'Resource Type';
            OptionMembers = "Internal","External";
            OptionCaption = 'Internal,External';
        }
        field(50102; "CSD Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(50103; "CSD Quantity Per Day"; Decimal)
        {
            Caption = 'Quantity Per Day';
        }
    }
}