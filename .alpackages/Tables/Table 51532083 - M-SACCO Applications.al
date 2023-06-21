table 51532083 "M-SACCO Applications"
{
    //DrillDownPageID = "Mpesa Applications List";
    //LookupPageID = "Mpesa Applications List";

    fields
    {
        field(1; No; Code[30])
        {
        }
        field(2; "Date Entered"; Date)
        {
        }
        field(3; "Time Entered"; Time)
        {
        }
        field(4; "Entered By"; Code[40])
        {
        }
        field(5; "Document Serial No"; Text[50])
        {
        }
        field(6; "Document Date"; Date)
        {
        }
        field(7; "Customer ID No"; Code[50])
        {

            trigger OnValidate()
            var
                Member: Record Members;
                SaccoAccount: Record "Savings Accounts";
            begin
                "Customer ID No" := DelChr("Customer ID No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');

                FieldLength("Customer ID No", 10);
                if ValidateID then begin
                    if Rec."Application Type" = Rec."Application Type"::Initial then begin
                        Member.Reset;
                        Member.SetRange("ID No.", Rec."Customer ID No");
                        if Member.Find('-') then begin
                            if StrLen(Member."Mobile Phone No") > 13 then begin //validate 13 digit phone number +254718009161,+254725251210
                                Error('Phone number too long in member card. Format should be +2547XXYYYZZZ');
                            end else begin
                                if StrLen(Member."Mobile Phone No") < 9 then begin
                                    Error('Phone number too short in member card. Format should be +2547XXYYYZZZ');
                                end else begin
                                    //strPhone:='+254'+COPYSTR(Member."Mobile Phone No",STRLEN(Member."Mobile Phone No")-8,9);
                                    Rec."Customer Name" := Member.Name;
                                    Rec."MPESA Mobile No" := '+254' + CopyStr(Member."Mobile Phone No", StrLen(Member."Mobile Phone No") - 8);
                                end;
                            end;

                        end else begin
                            Member.Reset;
                            Member.SetRange("Passport No.", Rec."Customer ID No");
                            if Member.Find('-') then begin
                                if StrLen(Member."Mobile Phone No") > 13 then begin //validate 13 digit phone number +254718009161,+254725251210
                                    Error('Phone number too long in member card. Format should be +2547XXYYYZZZ');
                                end else begin
                                    if StrLen(Member."Mobile Phone No") < 9 then begin
                                        Error('Phone number too short in member card. Format should be +2547XXYYYZZZ');
                                    end else begin
                                        //strPhone:='+254'+COPYSTR(Member."Mobile Phone No",STRLEN(Member."Mobile Phone No")-8,9);
                                        Rec."Customer Name" := Member.Name;
                                        Rec."MPESA Mobile No" := '+254' + CopyStr(Member."Mobile Phone No", StrLen(Member."Mobile Phone No") - 8);
                                    end;
                                end;
                            end else
                                Error('Member card information is incomplete, ID number ' + Rec."Customer ID No" + ' not found.');
                            //Error('Member card information is incomplete, ID number ' + Rec."Customer ID No" + ' not found.');
                        end;
                    end else begin  // -- change
                        saccoAccount.Reset;
                        saccoAccount.SetRange("ID No.", Rec."Customer ID No");
                        if saccoAccount.Find('-') then begin
                            Rec."Customer Name" := saccoAccount.Name;
                            if (StrLen(saccoAccount."Mobile Phone No") >= 9) and (StrLen(saccoAccount."Mobile Phone No") <= 13) then begin
                                Rec."MPESA Mobile No" := '+254' + CopyStr(saccoAccount."Mobile Phone No", StrLen(saccoAccount."Mobile Phone No") - 8);
                            end;
                        end
                        else begin
                            saccoAccount.Reset;
                            saccoAccount.SetRange("Passport No.", Rec."Customer ID No");
                            if saccoAccount.Find('-') then begin
                                Rec."Customer Name" := saccoAccount.Name;
                                if (StrLen(saccoAccount."Mobile Phone No") >= 9) and (StrLen(saccoAccount."Mobile Phone No") <= 13) then begin
                                    Rec."MPESA Mobile No" := '+254' + CopyStr(saccoAccount."Mobile Phone No", StrLen(saccoAccount."Mobile Phone No") - 8);
                                end;
                            end;
                        end;
                    end;
                end;

            end;
        }
        field(8; "Customer Name"; Text[200])
        {

            trigger OnValidate()
            begin

                "Customer Name" := DelChr("Customer Name", '=', '0|1|2|3|4|5|6|7|8|9|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|+|_|~');

                //FieldLength("MPESA Mobile No",10);
            end;
        }
        field(9; "MPESA Mobile No"; Text[50])
        {

            trigger OnValidate()
            begin

                "MPESA Mobile No" := DelChr("MPESA Mobile No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-');

                FieldLength("MPESA Mobile No", 13);
            end;
        }
        field(10; "MPESA Corporate No"; Code[30])
        {
        }
        field(11; Status; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(12; Comments; Text[200])
        {
        }
        field(13; "Rejection Reason"; Text[30])
        {
        }
        field(14; "Date Approved"; Date)
        {
        }
        field(15; "Time Approved"; Time)
        {
        }
        field(16; "Approved By"; Code[30])
        {
        }
        field(17; "Date Rejected"; Date)
        {
        }
        field(18; "Time Rejected"; Time)
        {
        }
        field(19; "Rejected By"; Code[30])
        {
        }
        field(20; "Sent To Server"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(21; "No. Series"; Code[15])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(22; "1st Approval By"; Code[30])
        {
        }
        field(23; "Date 1st Approval"; Date)
        {
        }
        field(24; "Time First Approval"; Time)
        {
        }
        field(25; "Withdrawal Limit Code"; Code[20])
        {
            TableRelation = "M-SACCO Withdrawal Limits".Code;

            trigger OnValidate()
            begin
                WithdrawLimit.Reset;
                WithdrawLimit.SetRange(WithdrawLimit.Code, "Withdrawal Limit Code");
                if WithdrawLimit.Find('-') then begin
                    WithdrawLimit.TestField(WithdrawLimit."Limit Amount");
                    "Withdrawal Limit Amount" := WithdrawLimit."Limit Amount";
                end;
            end;
        }
        field(26; "Withdrawal Limit Amount"; Decimal)
        {
        }
        field(27; "Application Type"; Option)
        {
            OptionMembers = Initial,Change,"De-Activate",Activate;

            trigger OnValidate()
            begin
                if "Application Type" = "Application Type"::Initial then begin
                    if "Application No" <> '' then begin
                        Error('Please ensure the application number field is blank if the application is not a change application.');
                    end;
                end;
            end;
        }
        field(28; "Application No"; Code[15])
        {
            TableRelation = "M-SACCO Applications".No WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                if "Application Type" = "Application Type"::Initial then begin
                    Error('The application must be a change/activate/deactivate application before selecting this option.');
                end;

                MPESAApp.Reset;
                MPESAApp.SetRange(MPESAApp.No, "Application No");
                if MPESAApp.Find('-') then begin
                    "Old Telephone No" := MPESAApp."MPESA Mobile No";
                    "Document Serial No" := MPESAApp."Document Serial No";
                    "Customer ID No" := MPESAApp."Customer ID No";
                    "Customer Name" := MPESAApp."Customer Name";
                end
                else begin
                    "Old Telephone No" := '';
                end;

                MPESAAppDetails.Reset;
                MPESAAppDetails.SetRange(MPESAAppDetails."Application No", No);
                if MPESAAppDetails.Find('-') then begin
                    repeat
                        MPESAAppDetails.Delete;
                    until MPESAAppDetails.Next = 0
                end;


                MPESAAppDetails.Reset;
                MPESAAppDetails.SetRange(MPESAAppDetails."Application No", "Application No");
                if MPESAAppDetails.Find('-') then begin
                    repeat
                        MPESAAppDet2.Reset;
                        MPESAAppDet2.Init;
                        MPESAAppDet2."Application No" := No;
                        MPESAAppDet2."Account Type" := MPESAAppDetails."Account Type";
                        MPESAAppDet2."Account No." := MPESAAppDetails."Account No.";
                        MPESAAppDet2.Description := MPESAAppDetails.Description;
                        MPESAAppDet2.Insert;
                    until MPESAAppDetails.Next = 0
                end;
            end;
        }
        field(29; Changed; Option)
        {
            OptionMembers = No,Yes;
        }
        field(30; "Date Changed"; Date)
        {
        }
        field(31; "Time Changed"; Time)
        {
        }
        field(32; "Changed By"; Code[30])
        {
        }
        field(33; "Old Telephone No"; Code[30])
        {
        }
        field(34; "I agree information is true"; Boolean)
        {
        }
        field(35; "App Status"; Option)
        {
            OptionMembers = Pending,"1st Approval",Approved,Rejected;
        }
        field(36; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility CenterBR";
        }
        field(37; "Virtual Registration"; Boolean)
        {
        }
        field(38; "Staff No."; Code[20])
        {
            CalcFormula = Lookup(Members."Payroll/Staff No." WHERE("ID No." = FIELD("Customer ID No")));
            FieldClass = FlowField;
        }
        field(39; "Online Registration"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Status <> Status::Open then begin
            //ERROR('You cannot delete the MPESA transaction because it has already been sent for first approval.');
        end;
    end;

    trigger OnInsert()
    var
        Usetup: Record "User Setup";
        MWith: Record "M-Sacco Withdrawal Limits";
    begin
        if No = '' then begin
            NoSetup.Get;
            NoSetup.TestField(NoSetup."M-SACCO Application Nos");
            NoSeriesMgt.InitSeries(NoSetup."M-SACCO Application Nos", xRec."No. Series", 0D, No, "No. Series");
        end;

        "Entered By" := UserId;
        "Date Entered" := Today;
        "Time Entered" := Time;
        IF Usetup.Get(UserId) then
            //"Responsibility Center" := Usetup."Responsibility Centre";
        vALIDATE("Responsibility Center", 'FOSA');
        Mwith.Reset();
        MWith.SetRange(Default, true);
        if Mwith.FindFirst() then Validate("Withdrawal Limit Code", MWith.Code);

    end;

    var
        NoSetup: Record "Banking No Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WithdrawLimit: Record "M-SACCO Withdrawal Limits";
        MPESAApp: Record "M-SACCO Applications";
        MPESAAppDetails: Record "M-SACCO Application Details";
        MPESAAppDet2: Record "M-SACCO Application Details";
        ValidateID: Boolean;

    procedure SetValidateID(Val: Boolean)
    begin

        ValidateID := Val;
    end;

    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;

    procedure ValidateApproval(): Boolean
    var
        DocMustbeOpen: Label 'This application must be open';
        StrTel: Text[30];
        sendforApprovalOk: Boolean;
        MNo: Code[20];
        Member: Record Members;
        Account: Record "Savings Accounts";

    begin
        if Rec.Status <> Rec.Status::Open then
            Error(DocMustbeOpen);


        //TESTFIELD("Document Serial No");
        Rec.TestField("Document Date");
        Rec.TestField("Customer ID No");
        Rec.TestField("Customer Name");
        Rec.TestField("Responsibility Center");
        Rec.TestField("Withdrawal Limit Code");
        Rec.TestField("Withdrawal Limit Amount");

        Rec.TestField("MPESA Mobile No");

        StrTel := CopyStr(Rec."MPESA Mobile No", 1, 4);

        if StrTel <> '+254' then begin
            Error('The MPESA Mobile Phone No. should be in the format +254XXXYYYZZZ.');
        end;

        if StrLen(Rec."MPESA Mobile No") <> 13 then begin
            Error('Invalid MPESA mobile phone number. Please enter the correct mobile phone number.');
        end;

        MNo := '';
        Member.Reset;
        Member.SetRange(Member."ID No.", Rec."Customer ID No");
        if Member.Find('-') then
            MNo := Member."No."
        else begin
            Member.Reset;
            Member.SetRange(Member."Passport No.", Rec."Customer ID No");
            if Member.Find('-') then
                MNo := Member."No."
        end;


        // -- check if phone number exists anywhere else other than for this member
        Account.Reset;
        Account.SetRange(Account."Transactional Mobile No", Rec."MPESA Mobile No");
        if Account.Find('-') then begin
            repeat


                if Rec."Application Type" = Rec."Application Type"::"De-Activate" then
                    if Account."Msacco Blocked" then
                        Error('Account Already Blocked');

                if Rec."Application Type" = Rec."Application Type"::Activate then
                    if not Account."Msacco Blocked" then
                        Error('Account Already Active');

                if Account."ID No." <> Rec."Customer ID No" then begin
                    Error('Phone No ' + Rec."MPESA Mobile No" + ' already linked to account ' + Account."No." + ' ' + Account.Name);
                end;
                if Account."Member No." <> MNo then begin
                    Error('Phone No ' + Rec."MPESA Mobile No" + ' already linked to account ' + Account."No." + ' ' + Account.Name);
                end;
            until Account.Next = 0;
        end;
        // --

        // -- check if phone number for this member
        Member.Reset;
        Member.SetRange(Member."Mobile Phone No", Rec."MPESA Mobile No");
        Member.SetRange(Member."ID No.", Rec."Customer ID No");
        if Member.Find('-') then begin
            //--ni yake
        end else begin
            Member.Reset;
            Member.SetRange(Member."Mobile Phone No", Rec."MPESA Mobile No");
            Member.SetRange(Member."Passport No.", Rec."Customer ID No");
            if Member.Find('-') then begin
                //Error('Phone No ' + Rec."MPESA Mobile No" + ' does not match with available member information');
            end else
                Error('Phone No ' + Rec."MPESA Mobile No" + ' does not match with available member information');
        end;
        // --

        sendforApprovalOk := false;

        MPESAAppDetails.Reset;
        MPESAAppDetails.SetRange(MPESAAppDetails."Application No", Rec.No);
        if not MPESAAppDetails.Find('-') then Error('Please select the account to link with the telephone No.');

        repeat

            //Check if Id number exists in this account
            Account.Reset;
            Account.SetRange(Account."ID No.", Rec."Customer ID No");
            Account.SetRange(Account."No.", MPESAAppDetails."Account No.");
            if Account.Find('-') then begin   //Check if Id number exists in this account
                sendforApprovalOk := true;
                if Account."Member No." <> MNo then begin
                    Error('Invalid Account ' + Account."No." + ' for this Application.');
                end;
            end else begin
                Account.Reset;
                Account.SetRange(Account."Passport No.", Rec."Customer ID No");
                Account.SetRange(Account."No.", MPESAAppDetails."Account No.");
                if Account.Find('-') then begin
                    sendforApprovalOk := true;
                    if Account."Member No." <> MNo then begin
                        Error('Invalid Account ' + Account."No." + ' for this Application.');
                    end;
                end else
                    Error('Id number ' + Rec."Customer ID No" + ' does not exist for account no ' + MPESAAppDetails."Account No.");
            end;

        until MPESAAppDetails.Next = 0;

        exit(sendforApprovalOk);
    end;
}

