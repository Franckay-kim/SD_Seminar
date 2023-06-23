/// <summary>
/// Table Securities Register (ID 51532166).
/// </summary>
table 51532166 "Securities Register"
{
    //DrillDownPageID = "Collateral Register - List";
    //LookupPageID = "Collateral Register - List";

    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    NoSeriesMgt.TestManual(SalesSetup."Loan Security Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(8; "Account No."; Code[20])
        {
            Caption = 'Member No.';
            TableRelation = Members."No." WHERE("Customer Type" = FILTER(<> Cell));

            trigger OnValidate()
            begin
                if CusMembr.Get("Account No.") then
                    "Account Name" := CusMembr.Name;
            end;
        }
        field(9; "Account Name"; Text[100])
        {
            Editable = false;
        }
        field(10; "Collateral Type"; Option)
        {
            OptionCaption = ' ,Real Estate,Plant and Equipment,Natural Reserves,Marketable Securities,Inventory,Motor Vehicle';
            OptionMembers = " ","Real Estate","Plant and Equipment","Natural Reserves","Marketable Securities",Inventory,"Motor Vehicle";
        }
        field(11; Collateral; Code[20])
        {
            TableRelation = "Loan Securities Set-up".Code WHERE(Type = FIELD("Collateral Type"));

            trigger OnValidate()
            begin
                /*IF SecurityRegSetUp.GET(Collateral) THEN BEGIN
                    IF SecurityRegSetUp.Blocked THEN
                        ERROR(Text001, SecurityRegSetUp."Security Description");

                    "Collateral Name" := SecurityRegSetUp."Security Description";
                    "Collateral Multiplier" := SecurityRegSetUp."Collateral Multiplier";
                    "Collateral Limit" := "Collateral Value" * ("Collateral Multiplier" / 100);
                    "Charged Value" := "Collateral Limit";
                END;*/
                if SecurityRegSetUp.Get(Collateral) then begin
                    if SecurityRegSetUp.Blocked then
                        Error(Text001, SecurityRegSetUp."Security Description");

                    "Collateral Name" := SecurityRegSetUp."Security Description";
                    "Collateral Multiplier" := SecurityRegSetUp."Collateral Multiplier";
                    SecurityRegSetUp.Reset;
                    SecurityRegSetUp.SetRange(SecurityRegSetUp.Type, "Collateral Type");
                    if SecurityRegSetUp.Find('-') then begin
                        case SecurityRegSetUp."Guarantorship Basis" of
                            SecurityRegSetUp."Guarantorship Basis"::"Collateral Value":
                                "Collateral Limit" := "Collateral Value" * ("Collateral Multiplier" / 100);
                            SecurityRegSetUp."Guarantorship Basis"::"Forced Sales Value":
                                "Collateral Limit" := "Forced Sale Value" * ("Collateral Multiplier" / 100);
                        end;
                    end;
                end;

            end;
        }
        field(12; "Collateral Name"; Text[80])
        {
            Editable = false;
        }
        field(15; "Collateral Multiplier"; Integer)
        {
            Editable = false;
        }
        field(16; "Collateral Value"; Decimal)
        {

            trigger OnValidate()
            begin
                // "Collateral Limit":="Collateral Value"*("Collateral Multiplier"/100)
                SecurityRegSetUp.Reset;
                SecurityRegSetUp.SetRange(SecurityRegSetUp.Type, "Collateral Type");
                if SecurityRegSetUp.Find('-') then begin
                    case SecurityRegSetUp."Guarantorship Basis" of
                        SecurityRegSetUp."Guarantorship Basis"::"Collateral Value":
                            begin
                                "Collateral Limit" := "Collateral Value" * ("Collateral Multiplier" / 100);
                                //  IF "Forced Sale Value"<"Collateral Limit" THEN ERROR(Text005,"Collateral Limit");
                            end;
                        SecurityRegSetUp."Guarantorship Basis"::"Forced Sales Value":
                            begin
                                "Collateral Limit" := "Forced Sale Value" * ("Collateral Multiplier" / 100);
                                // IF "Forced Sale Value"<"Collateral Value" THEN ERROR(Text005,"Collateral Value");
                            end;
                    end;
                end;
            end;
        }
        field(17; "Collateral Limit"; Decimal)
        {
            Description = 'Max. amount Collateral can cover against loan';
            Editable = false;
        }
        field(29; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(30; "Inward/Outward"; Option)
        {
            OptionCaption = ' ,In-Store,Returned';
            OptionMembers = " ","In-Store",Returned;
        }
        field(31; "Last Valuation Date"; Date)
        {

            trigger OnValidate()
            begin
                GenSetup.Get;
                if "Last Valuation Date" <> 0D then begin
                    if "Last Valuation Date" > Today then
                        Error(Text004);
                    GenSetup.TestField("Maximum Valuation Period");
                    if CalcDate(GenSetup."Maximum Valuation Period", "Last Valuation Date") < Today then
                        Error(Text003, GenSetup."Maximum Valuation Period");
                    SecurityRegSetUp.Reset;
                    SecurityRegSetUp.SetRange(SecurityRegSetUp.Type, "Collateral Type");
                    if SecurityRegSetUp.Find('-') then begin
                        if Format(SecurityRegSetUp."Revaluation Frequency") <> '' then
                            "Next Valuation Date" := CalcDate(SecurityRegSetUp."Revaluation Frequency", "Last Valuation Date");
                    end;
                end;
            end;
        }
        field(32; "Forced Sale Value"; Decimal)
        {

            trigger OnValidate()
            var
                Text001: Label 'Forced sale value cannot be more than collateral limit';
            begin
                Validate(Collateral);
                SecurityRegSetUp.Reset;
                SecurityRegSetUp.SetRange(SecurityRegSetUp.Type, "Collateral Type");
                if SecurityRegSetUp.Find('-') then begin
                    case SecurityRegSetUp."Guarantorship Basis" of
                        SecurityRegSetUp."Guarantorship Basis"::"Collateral Value":
                            begin
                                "Collateral Limit" := "Collateral Value" * ("Collateral Multiplier" / 100);
                                // IF "Forced Sale Value"<"Collateral Limit" THEN ERROR(Text005,"Collateral Limit");
                            end;
                        SecurityRegSetUp."Guarantorship Basis"::"Forced Sales Value":
                            begin
                                "Collateral Limit" := "Forced Sale Value" * ("Collateral Multiplier" / 100);
                                //IF "Forced Sale Value"<"Collateral Value" THEN ERROR(Text005,"Collateral Value");
                            end;
                    end;
                end;
                if "Forced Sale Value" > "Collateral Value" then Error(Text005, "Collateral Value")
            end;
        }
        field(33; "Collateral Perfected"; Boolean)
        {
            Editable = false;
        }
        field(34; "Next Valuation Date"; Date)
        {
            Editable = false;
        }
        field(35; Remarks; Text[250])
        {
        }
        field(36; "Collateral Details"; Text[200])
        {
        }
        field(37; "Registered Owner"; Text[100])
        {
        }
        field(38; "Re-Opened By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(39; "Date Re-Opened"; Date)
        {
        }
        field(40; "Insurance Expiry Date"; Date)
        {
        }
        field(41; "Valuation Type"; Option)
        {
            OptionCaption = ' ,Appreciating,Depreciating';
            OptionMembers = " ",Appreciating,Depreciating;
        }
        field(42; "Legally Cleared"; Boolean)
        {
        }
        field(43; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(44; "Charged Value"; Decimal)
        {

            trigger OnValidate()
            begin

                if "Charged Value" > "Collateral Limit" then
                    Error('"Charged Value" cannot be greater than "Collateral Limit"');
                if "Charged Value" > "Collateral Value" then
                    Error('Charged value cannot be greater than collateral value');
            end;
        }
        field(45; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = New,Old,Land;
        }
        field(46; "Has Tracker"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Tracker certificate date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Model Detail"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(49; Colour; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50; YOM; Date)
        {
            Caption = 'Year of Manufacture';
            DataClassification = ToBeClassified;
        }
        field(51; "Plate No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Collateral Name")
        {
        }
    }

    trigger OnInsert()
    var
        Usetup: Record "User Setup";
    begin
        /* if "No." = '' then begin
             SalesSetup.Get;
             SalesSetup.TestField(SalesSetup."Loan Security Nos.");
             NoSeriesMgt.InitSeries(SalesSetup."Loan Security Nos.", xRec."No. Series", 0D, "No.", "No. Series");
         end;
         IF USetup.get(UserId) then
             Validate("Global Dimension 2 Code", Usetup."Global Dimension 2 Code");*/

    end;

    trigger OnModify()
    begin
        if (Status = Status::Approved) or (Status = Status::Pending) then
            Error(Text002, Status);
    end;

    var
        SalesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CusMembr: Record Members;
        SecurityRegSetUp: Record "Loan Securities Set-up";
        Text001: Label 'This collateral is blocked thus not avaialable for use.';
        Text002: Label 'This application is %1 thus cannot modify.';
        GenSetup: Record "General Set-Up";
        Text003: Label 'The last valuation day is more than %1 hence is invalid';
        Text004: Label 'Last valuation date cannot be greater than today';
        Text005: Label 'The forced sale value cannot be greater than collateral maximum limit of %1';
}

