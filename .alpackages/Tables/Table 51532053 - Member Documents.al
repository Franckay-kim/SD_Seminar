table 51532053 "Member Documents"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Document Type";Option)
        {
            OptionCaption = ' ,Member,Account,Loan';
            OptionMembers = " ",Member,Account,Loan;
        }
        field(3;"Document No.";Code[10])
        {
            TableRelation = "Application Document Setup";

            trigger OnValidate()
            var
                ApplicationDocumentSetup: Record "Application Document Setup";
            begin
                if ApplicationDocumentSetup.Get("Document No.") then begin
                  "Document Type":=ApplicationDocumentSetup."Document Type";
                  Description:=ApplicationDocumentSetup.Description;
                  "Single Party/Multiple":=ApplicationDocumentSetup."Single Party/Multiple";
                  end;
            end;
        }
        field(4;Description;Text[250])
        {
            Editable = false;
        }
        field(5;"Single Party/Multiple";Option)
        {
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = Single,Multiple,Business;
        }
        field(6;"Reference No.";Code[20])
        {
            Editable = false;
        }
        field(7;"Product ID";Code[20])
        {
            Editable = false;
            TableRelation = "Product Factory";
        }
        field(8;"Product Name";Text[100])
        {
            Editable = false;
        }
        field(12;Provided;Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

