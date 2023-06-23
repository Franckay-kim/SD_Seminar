/// <summary>
/// Table HR Job Responsiblities (ID 51533000).
/// </summary>
table 51533000 "HR Job Responsiblities"
{


    fields
    {
        field(1; "Job ID"; Code[50])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "HR Jobs"."Job ID";
        }
        field(2; "Responsibility Description"; Text[250])
        {
        }
        field(3; Remarks; Text[150])
        {
        }
        field(4; "Responsibility Code"; Code[20])
        {

            trigger OnValidate()
            begin

            end;
        }
        field(5; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job ID", "Responsibility Description")
        {
        }
    }

    fieldgroups
    {
    }

    var
    //HRAppEvalArea: Record "HR OSMeasure Line";
}

