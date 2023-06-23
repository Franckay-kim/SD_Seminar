/// <summary>
/// Table Member Class Application (ID 51532400).
/// </summary>
table 51532400 "Member Class Application"
{

    fields
    {
        field(1; "Application No"; Code[20])
        {
        }
        field(2; "Member Class"; Code[20])
        {
            TableRelation = "Member Category"."No.";

            trigger OnValidate()
            begin

                // "Product ID":='';
                // Cat.GET("Member Class");
                // Cat.TESTFIELD("Product ID");
                // "Product ID":=Cat."Product ID";
            end;
        }
        field(3; "Product ID"; Code[20])
        {
            Editable = false;
        }
        field(4; "Create Benevolent"; Boolean)
        {

            trigger OnValidate()
            begin

                ClassApp.Reset;
                ClassApp.SetRange("Application No", "Application No");
                ClassApp.SetRange("Create Benevolent", true);
                ClassApp.SetFilter("Member Class", '<>%1', "Member Class");
                if ClassApp.Find('-') then begin
                    ClassApp.ModifyAll("Create Benevolent", false);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Application No", "Member Class")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cat: Record "Member Category";
        ClassApp: Record "Member Class Application";
}

