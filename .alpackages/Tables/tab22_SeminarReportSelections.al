/// <summary>
/// Table CSD Seminar Report Selections (ID 50122).
/// </summary>
table 50122 "CSD Seminar Report Selections"
{
    Caption = 'Seminar Report Selections';

    fields
    {

        field(1; "usage"; Option)
        {
            caption = 'Usage';
            OptionMembers = "Registration";
        }
        field(2; "No."; Integer)
        {
            caption = 'No.';
        }
    }

    keys
    {
        key(pk; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}