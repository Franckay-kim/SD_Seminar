/// <summary>
/// Table Workplan Dimension (ID 51532314).
/// </summary>
table 51532314 "Workplan Dimension"
{
    Caption = 'Workplan Dimension';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(3; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Dimension Code")
        {
        }
        key(Key2; "Dimension Code", "Dimension Value Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CheckIfBlocked;
        UpdateDimFields('');
    end;

    trigger OnInsert()
    begin
        TestField("Dimension Value Code");
        CheckIfBlocked;
        UpdateDimFields("Dimension Value Code");
    end;

    trigger OnModify()
    begin
        CheckIfBlocked;
        UpdateDimFields("Dimension Value Code");
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRetrieved: Boolean;

    /// <summary>
    /// CheckIfBlocked.
    /// </summary>
    procedure CheckIfBlocked()
    var
        GLBudgetName: Record "G/L Budget Name";
        GLBudgetEntry: Record "G/L Budget Entry";
    begin
        if GLBudgetEntry.Get("Entry No.") then
            if GLBudgetName.Get(GLBudgetEntry."Budget Name") then
                GLBudgetName.TestField(Blocked, false);
    end;

    local procedure UpdateDimFields(NewDimValue: Code[20])
    var
        Modified: Boolean;
        GLBudgetName: Record "G/L Budget Name";
        GLBudgetEntry: Record "G/L Budget Entry";
    begin
        if "Dimension Code" = '' then
            exit;
        if not GLSetupRetrieved then begin
            GLSetup.Get;
            GLSetupRetrieved := true;
        end;

        if GLBudgetEntry.Get("Entry No.") then begin
            case "Dimension Code" of
                GLSetup."Global Dimension 1 Code":
                    begin
                        GLBudgetEntry."Global Dimension 1 Code" := NewDimValue;
                        Modified := true;
                    end;
                GLSetup."Global Dimension 2 Code":
                    begin
                        GLBudgetEntry."Global Dimension 2 Code" := NewDimValue;
                        Modified := true;
                    end;
            end;
            if GLBudgetName.Get(GLBudgetEntry."Budget Name") then begin
                case "Dimension Code" of
                    GLBudgetName."Budget Dimension 1 Code":
                        begin
                            GLBudgetEntry."Budget Dimension 1 Code" := NewDimValue;
                            Modified := true;
                        end;
                    GLBudgetName."Budget Dimension 2 Code":
                        begin
                            GLBudgetEntry."Budget Dimension 2 Code" := NewDimValue;
                            Modified := true;
                        end;
                    GLBudgetName."Budget Dimension 3 Code":
                        begin
                            GLBudgetEntry."Budget Dimension 3 Code" := NewDimValue;
                            Modified := true;
                        end;
                    GLBudgetName."Budget Dimension 4 Code":
                        begin
                            GLBudgetEntry."Budget Dimension 4 Code" := NewDimValue;
                            Modified := true;
                        end;
                end;
            end;
            if Modified then begin
                GLBudgetEntry."User ID" := UserId;
                GLBudgetEntry.Modify;
            end;
        end;
    end;
}

