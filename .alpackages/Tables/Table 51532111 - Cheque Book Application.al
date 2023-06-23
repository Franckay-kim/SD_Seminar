/// <summary>
/// Table Cheque Book Application (ID 51532111).
/// </summary>
table 51532111 "Cheque Book Application"
{
    //DrillDownPageID = "Cheque Book Application List";
    //LookupPageID = "Cheque Book Application List";

    fields
    {
        field(1; "No."; Code[10])
        {

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    Noseriesmgt.TestManual(SalesSetup."Cheque Application Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Account No."; Code[20])
        {
            TableRelation = "Savings Accounts"."No." WHERE("Product Category" = FILTER(" "));

            trigger OnValidate()
            begin
                "Cheque Account No." := "Account No.";
                Vend.Reset;
                Vend.SetRange(Vend."No.", "Account No.");
                if Vend.Find('-') then begin
                    Vend.TestField(Vend."Member No.");
                    Name := Vend.Name;
                    "ID No." := Vend."ID No.";
                    //"Staff No.":=Vend."Payroll/Staff No.";
                    "Member No." := Vend."Member No.";
                    "Cheque Account No." := Vend."Cheque Account No.";

                    //for existing cheque book holders
                    Translation.Reset;
                    Translation.SetRange(Translation."Member No", Vend."Member No.");
                    if Translation.Find('-') then begin
                        "Cheque Account No." := "Cheque Account No.";
                        "Translation Code" := Translation.Code;
                    end else begin

                        //for new cheque book applicants
                        Translation.Reset;
                        Translation.SetRange(Translation.Used, false);
                        if Translation.Find('-') then begin
                            "Cheque Account No." := '2' + Translation.Code + '1025';
                            "Translation Code" := Translation.Code;
                            Translation."Cheque Account No" := "Cheque Account No.";
                            Translation."Member No" := Vend."Member No.";
                            Translation."Member Name" := Vend.Name;
                            Translation.Used := true;
                            Translation.Modify;
                        end;


                    end;
                end else begin
                    Error('Member no. not found');
                end;

                /*
                IF Vend.GET("Account No.")  THEN BEGIN
                IF Vend."ChqAcount Number" = '' THEN BEGIN
                IF acctypes.GET(Vend."Account Type") THEN BEGIN
                //LASTNUMBER:=acctypes.ChqNumbers;
                acctypes.ChqNumbers:=INCSTR(acctypes.ChqNumbers);
                acctypes.MODIFY;
                END;
                Vend."ChqAcount Number":=LASTNUMBER;
                IF "Cheque Account No." = '' THEN BEGIN
                "Cheque Account No.":=Vend."ChqAcount Number";
                MODIFY;
                END;
                Vend.MODIFY;
                END;
                END;
                 */
                "Cheque Account No." := "Account No.";

            end;
        }
        field(3; Name; Text[50])
        {
        }
        field(4; "ID No."; Code[20])
        {
        }
        field(5; "Application Date"; Date)
        {
        }
        field(6; "Cheque Account No."; Code[20])
        {
            Editable = false;
        }
        field(7; "Staff No."; Code[20])
        {
        }
        field(8; "Export Format"; Code[10])
        {
        }
        field(9; "No. Series"; Code[10])
        {
        }
        field(10; "Member No."; Code[10])
        {
        }
        field(11; "Responsibility Centre"; Code[20])
        {
            TableRelation = "Responsibility CenterBR";
        }
        field(12; "Begining Cheque No."; Code[60])
        {

            trigger OnValidate()
            begin
                /*ChequeSetUp.RESET;
                ChequeSetUp.SETRANGE(ChequeSetUp."Cheque Code","Cheque Book Type");
                IF ChequeSetUp.FIND('-') THEN BEGIN
                
                EVALUATE(BeginNo,"Begining Cheque No.");
                EVALUATE(NoofLF,ChequeSetUp."Number Of Leaf");
                "End Cheque No.":=FORMAT(BeginNo+NoofLF);
                END;
                */

                Chqreg.Reset;
                Chqreg.SetRange("Cheque No.", "Begining Cheque No.");
                Chqreg.SetRange("Account No.", "Cheque Account No.");
                if Chqreg.Find('-') then
                    Error('That cheque range has been used');

            end;
        }
        field(13; "End Cheque No."; Code[60])
        {

            trigger OnValidate()
            begin
                Chqreg.Reset;
                Chqreg.SetRange("Cheque No.", "End Cheque No.");
                Chqreg.SetRange("Account No.", "Cheque Account No.");
                if Chqreg.Find('-') then
                    Error('That cheque range has been used');
            end;
        }
        field(14; "Application Exported"; Boolean)
        {
        }
        field(15; "Cheque Register Generated"; Boolean)
        {
            Editable = false;
        }
        field(16; Select; Boolean)
        {

            trigger OnValidate()
            begin
                if "Cheque Book charges Posted" = false then
                    Error('Please Post Cheque book charges before exporting');
            end;
        }
        field(17; "Cheque Book charges Posted"; Boolean)
        {
            Editable = false;
        }
        field(18; "Cheque Book Type"; Code[10])
        {
            TableRelation = "Cheque Set Up";

            trigger OnValidate()
            begin
                ChApp.Reset;
                ChApp.SetRange(ChApp."Account No.", "Account No.");
                ChApp.SetRange(ChApp.Status, ChApp.Status::Approved);
                if ChApp.Find('+') then begin
                    "Begining Cheque No." := IncStr(ChApp."End Cheque No.");

                end;


                //VALIDATE("Begining Cheque No.");
            end;
        }
        field(68005; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(68006; "Last check"; Code[30])
        {
            CalcFormula = Max("Cheques Register"."Cheque No." WHERE("Account No." = FIELD("Account No.")));
            FieldClass = FlowField;
        }
        field(68007; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Cheque Application"));
        }
        field(68008; "Translation Code"; Code[20])
        {
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
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Cheque Application Nos");
            Noseriesmgt.InitSeries(SalesSetup."Cheque Application Nos", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Application Date" := Today;


        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        if UserSetup.Find('-') then begin
            //UserSetup.TestField(UserSetup."Responsibility Centre");
            //"Responsibility Centre" := UserSetup."Responsibility Centre";
        end;
    end;

    trigger OnModify()
    begin

        // IF Status=Status::Approved THEN BEGIN
        if "Cheque Register Generated" = true then
            Error('Cheque register has already been generated you cannot make modifications.');
        //END;
        //}
    end;

    var
        Vend: Record "Savings Accounts";
        Noseriesmgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Banking No Setup";
        acctypes: Record "Product Factory";
        LASTNUMBER: Code[60];
        ChequeSetUp: Record "Cheque Set Up";
        "number of leafs": Code[20];
        ChApp: Record "Cheque Book Application";
        BeginNo: Integer;
        NoofLF: Integer;
        UserSetup: Record "User Setup";
        Chqreg: Record "Cheques Register";
        Translation: Record "Data Translation";
}

