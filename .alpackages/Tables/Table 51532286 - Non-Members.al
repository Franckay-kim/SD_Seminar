table 51532286 "Non-Members"
{

    fields
    {
        field(1;"No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  SeriesSetup.Get;
                  NoSeriesMgt.TestManual(SeriesSetup."Non-Member Nos");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Name;Text[90])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3;"First Name";Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "First Name":=DelChr("First Name",'=','0|1|2|3|4|5|6|7|8|9');
                Name:=DelChr("First Name",'=','0|1|2|3|4|5|6|7|8|9')+' '+DelChr("Second Name",'=','0|1|2|3|4|5|6|7|8|9')+' '+DelChr("Last Name",'=','0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(4;"Second Name";Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Maintain names separately';

            trigger OnValidate()
            begin
                "Second Name":=DelChr("Second Name",'=','0|1|2|3|4|5|6|7|8|9');
                Name:=DelChr("First Name",'=','0|1|2|3|4|5|6|7|8|9')+' '+DelChr("Second Name",'=','0|1|2|3|4|5|6|7|8|9')+' '+DelChr("Last Name",'=','0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(5;"Last Name";Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Names separately';

            trigger OnValidate()
            begin
                "Last Name":=DelChr("Last Name",'=','0|1|2|3|4|5|6|7|8|9');
                Name:=DelChr("First Name",'=','0|1|2|3|4|5|6|7|8|9')+' '+DelChr("Second Name",'=','0|1|2|3|4|5|6|7|8|9')+' '+DelChr("Last Name",'=','0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(6;"E-Mail";Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(7;"Date of Birth";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
            end;
        }
        field(8;"ID No.";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Mobile Phone No";Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Marital Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Single,Married,Divorced,Widowed,Others';
            OptionMembers = " ",Single,Married,Divorced,Widowed,Others;
        }
        field(11;Gender;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '  ,Male,Female';
            OptionMembers = "  ",Male,Female;
        }
        field(12;"P.I.N Number";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Member No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14;"No. Series";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"ID No.","No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
         if "No." = '' then begin
          SeriesSetup.Get;
          SeriesSetup.TestField(SeriesSetup."Non-Member Nos");
          NoSeriesMgt.InitSeries(SeriesSetup."Non-Member Nos",xRec."No. Series",0D,"No.","No. Series");
         end;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

