/// <summary>
/// Table HR Job Related Requirements (ID 51533233).
/// </summary>
table 51533233 "HR Job Related Requirements"
{


    fields
    {
        field(1; "Qualification ID"; Code[50])
        {
            NotBlank = true;
            TableRelation = "HR Job Requirements"."Qualification Code";
        }
        field(2; "Qualification Type"; Code[20])
        {
            NotBlank = false;
            TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER("Qualification Type"));
        }
        field(3; "Qualification Code"; Code[30])
        {
            TableRelation = "HR Job Qualifications".Code WHERE("Qualification Type" = FIELD("Qualification Type"));

            trigger OnValidate()
            begin
                /*.SETFILTER(Requirments."Qualification Type","Qualification Type");
                Requirments.SETFILTER(Requirments.Code,"Qualification Code");
                IF Requirments.FIND('-') THEN
                 Qualification := Requirments.Description; */


                if HRQualifications.Get("Qualification Type", "Qualification Code") then
                    "Qualification Description" := HRQualifications.Description;

            end;
        }
        field(6; Priority; Option)
        {
            OptionMembers = " ",High,Medium,Low;
        }
        field(8; "Score ID"; Decimal)
        {
        }
        field(9; "Need code"; Code[10])
        {

        }
        field(10; "Stage Code"; Code[10])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Training Cost Item"));
        }
        field(11; Mandatory; Boolean)
        {
        }
        field(12; "Minimum Score"; Decimal)
        {
        }
        field(13; "Total (Stage)Desired Score"; Decimal)
        {
        }
        field(14; "Qualification Description"; Text[100])
        {
        }
        field(15; "Maximum Score"; Decimal)
        {
        }
        field(16; Relevant; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Qualification ID", "Qualification Type", "Qualification Code")
        {
            SumIndexFields = "Score ID";
        }
    }

    fieldgroups
    {
    }

    var
        HRQualifications: Record "HR Job Qualifications";
}

