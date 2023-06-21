table 51532219 "Imprest Details"
{

    fields
    {
        field(1;"Source Line No.";Code[20])
        {
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                // IF Pay.GET(No) THEN
                // "Imprest Holder":=Pay."Account No.";
            end;
        }
        field(2;"Account No:";Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No." WHERE ("Direct Posting"=CONST(true));

            trigger OnValidate()
            begin
                
                if GLAcc.Get("Account No:") then
                 "Account Name":=GLAcc.Name;
                 GLAcc.TestField("Direct Posting",true);
                /*IF Pay.GET(No) THEN BEGIN
                 IF Pay."Account No."<>'' THEN
                "Imprest Holder":=Pay."Account No."
                 ELSE  ERROR('Please Enter the Customer/Account Number');
                END;*/

            end;
        }
        field(3;"Account Name";Text[30])
        {
            Editable = false;
        }
        field(4;Amount;Decimal)
        {
        }
        field(5;"Due Date";Date)
        {
        }
        field(6;"Imprest Holder";Code[20])
        {
            Editable = false;
            NotBlank = false;
            TableRelation = Customer."No.";
        }
        field(7;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(8;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(9;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(10;"Imprest Line Source";Option)
        {
            Editable = false;
            OptionMembers = " ","Cash Voucher","Payment Voucher";
        }
        field(11;Commited;Boolean)
        {
            Editable = false;
        }
        field(12;"Transaction Date";Date)
        {
        }
        field(13;"Cash Line No";Integer)
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
    }

    keys
    {
        key(Key1;"Line No.","Source Line No.","Cash Line No")
        {
            SumIndexFields = Amount;
        }
        key(Key2;"Cash Line No")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record "G/L Account";
        DimMgt: Codeunit DimensionManagement;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",StrSubstNo('%1 %2','Imprest Details',"Line No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array [8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;
}

