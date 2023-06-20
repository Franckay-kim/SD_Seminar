/// <summary>
/// Table CSD Seminar Charge (ID 50112).
/// </summary>
table 50112 "CSD Seminar Charge"
// CSD1.00 - 2023-06-06 - D. E. Veloper
//chapter 6 - Lab 1
//Created new table
{
    Caption = 'Seminar Charge';

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            trigger OnValidate();
            begin
                case Type of
                    Type::Resource:
                        begin
                            Resource.Get("No.");
                            Resource.TestField(Blocked, false);
                            Resource.TestField("Gen. Prod. Posting Group");
                            Description := Resource.Name;
                            // "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group ";
                            //"VAT Prod. Posting Group" := Resource."VAT Prod. Posting Group ";
                            //"Unit of Measure Code" := Resource."Base Unit of Measure ";
                            "Unit Price" := Resource."Unit Price";
                        end;
                    Type::"G/L Account":
                        begin
                            GLAccount.Get("No.");
                            GLAccount.CheckGLAcc();
                            GLAccount.TestField("Direct Posting", true);
                            Description := GLAccount.Name;
                            //"Gen. Prod. Posting Group" := GLAccount."Gen. Bus. Posting Group ";
                            // "VAT Prod. Posting Group" := GLAccount."VAT Bus. Posting Group ";
                        end;
                end;
            end;

        }
        field(2; "Type"; Option)
        {
            caption = 'Type';
            OptionMembers = "Resource","G/L Account";
            trigger OnValidate();
            var
                OldType: Integer;
            begin
                if Type <> xRec.Type then begin
                    OldType := Type;
                    Init;
                    Type := OldType;
                end;
            end;

        }
        field(3; "Quantity"; Decimal)
        {
            caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            trigger OnValidate();
            begin
                "Total Price" := Round("Unit Price" * Quantity, 0.01);
            end;
        }
        field(4; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            MinValue = 0;
            trigger OnValidate();
            begin
                "Total Price" := Round("Unit Price" * Quantity, 0.01);
            end;
        }
        field(5; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Editable = false;
            trigger OnValidate();
            begin
                if (Quantity <> 0) then
                    "Unit Price" := Round("Total Price" / Quantity, 0.01)
                else
                    "Unit Price" := 0;
            end;

        }
        field(6; "Unit of Measure Code"; Code[20])
        {
            caption = 'Unit of Measure Code';

            trigger OnValidate();
            begin
                case Type of
                    Type::Resource:
                        begin
                            Resource.Get("No.");
                            if "Unit of Measure Code" = '' then begin
                                //    "Unit of Measure Code" := Resource."Base Unit of Measure ";
                            end;
                            ResourceUofM.Get("No.", "Unit of Measure Code");
                            // "Qty. per Unit of Measure" := ResourceUofM."Qty.per Unit of Measure ";
                            // " Total Price " := Round(Resource." Unit Price " * " Qty.per Unit of Measure ");
                        end;
                    Type::"G/L Account":
                        begin
                            // "Qty. per Unit of Measure" := 1;
                        end;
                end;
                if CurrFieldNo = FieldNo("Unit of Measure Code") then begin
                    Validate("Unit Price");
                end;
            end;

        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; "Description"; Text[50])
        {
            caption = 'Description';
        }
        field(9; "Bill-to Customer No."; code[20])
        {
            caption = 'Bill-to Customer No.';
        }
        field(10; "To Invoice"; Boolean)
        {
            caption = 'To Invoice';
        }
        field(11; "Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionMembers = "Instructor","Room","Participant";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        Resource: Record "Resource";
        GLAccount: Record "G/L Account";
        ResourceUofM: Record "Resource Unit of Measure";


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