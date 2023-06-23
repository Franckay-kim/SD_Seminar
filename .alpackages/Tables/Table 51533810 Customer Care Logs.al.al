/// <summary>
/// Table Customer Care Logs (ID 51533810).
/// </summary>
table 51533810 "Customer Care Logs"
{

    fields
    {
        field(1; No; Code[20])
        {
        }
        field(2; "Member No"; Code[20])
        {
            TableRelation = IF ("Calling As" = FILTER("As Member")) Members."No."
            ELSE
            IF ("Calling As" = FILTER("As Employer")) Customer."No.";

            trigger OnValidate()
            var
                SAcc: Record "Savings Accounts";
                Loans: Record Loans;
                Pfact: Record "Product Factory";
            begin
                IF "Calling As" = "Calling As"::"As Member" THEN BEGIN
                    Cust.RESET;
                    Cust.SETRANGE(Cust."No.", "Member No");
                    IF Cust.FIND('-') THEN BEGIN
                        // Cust.CALCFIELDS(Cust."Outstanding Balance", Cust."Current Shares", Cust."Insurance Fund", Cust."Un-allocated Funds",
                        //Cust."Shares Retained");
                        "Member Name" := Cust.Name;
                        "Payroll No" := Cust."Payroll/Staff No.";

                        "Loan Balance" := Cust.GetLoansBalance('');
                        Pfact.Reset();
                        Pfact.SetRange("Product Category", Pfact."Product Category"::"Deposit Contribution");
                        Pfact.SetRange("Product Class Type", Pfact."Product Class Type"::Savings);
                        if Pfact.FindFirst() then begin end;
                        "Current Deposits" := Cust.GetSavingsBalance(Pfact."Product ID");
                        "ID No" := Cust."ID No.";
                        "Phone No" := Cust."Mobile Phone No";
                        "Passport No" := Cust."Passport No.";
                        Email := Cust."E-Mail";
                        Gender := Cust.Gender;
                        Status := Cust.Status;
                        "Employer Code" := PRD."No.";

                        //"Holiday Savings":=Cust."Insurance Fund";
                        Pfact.Reset();
                        Pfact.SetRange("Product Category", Pfact."Product Category"::"Share Capital");
                        Pfact.SetRange("Product Class Type", Pfact."Product Class Type"::Savings);
                        if Pfact.FindFirst() then begin end;
                        "Share Capital" := Cust.GetSavingsBalance(Pfact."Product ID");
                        // Source := Cust."Customer Posting Group";
                    END;
                END ELSE
                    IF "Calling As" = "Calling As"::"As Employer" THEN BEGIN
                        PRD.RESET;
                        PRD.SETRANGE(PRD."No.", "Member No");
                        IF PRD.FIND('-') THEN BEGIN
                            "Member Name" := PRD.Name;
                            "Phone No" := PRD."Phone No.";
                            Email := PRD."E-Mail";
                            "Employer Code" := PRD."No.";


                        END;
                    END
            end;
        }
        field(3; "Member Name"; Text[60])
        {
        }
        field(4; "Payroll No"; Code[20])
        {
        }
        field(5; "Loan Balance"; Decimal)
        {
        }
        field(6; "Current Deposits"; Decimal)
        {
        }
        field(7; "Holiday Savings"; Decimal)
        {
        }
        field(8; Description; Text[250])
        {
        }
        field(9; Status; Option)
        {
            Description = 'Open,Pending,Received,Resolved';
            OptionCaption = 'Open,Pending,Received,Resolved';
            OptionMembers = Open,Pending,Received,Resolved;
        }
        field(10; "ID No"; Code[20])
        {
        }
        field(11; "Phone No"; Text[30])
        {
        }
        field(12; "Passport No"; Text[30])
        {
        }
        field(13; Email; Text[60])
        {
        }
        field(14; Gender; Option)
        {
            Description = 'Male,Female';
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(15; "Employer Code"; Code[20])
        {
            TableRelation = Customer;
        }
        field(16; "Share Capital"; Decimal)
        {
        }
        field(17; Source; Code[20])
        {
            Description = 'BOSA,FOSA';
        }
        field(18; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(19; "Application User"; Code[20])
        {
        }
        field(20; "Application Date"; Date)
        {
        }
        field(21; "Application Time"; Time)
        {
        }
        field(22; "Receive User"; Code[20])
        {
        }
        field(23; "Receive date"; Date)
        {
        }
        field(24; "Receive Time"; Time)
        {
        }
        field(25; "Resolved User"; Code[20])
        {
        }
        field(26; "Resolved Date"; Date)
        {
        }
        field(27; "Resolved Time"; Time)
        {
        }
        field(28; "Caller Reffered To"; Code[20])
        {
            TableRelation = User."User Name";

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //  UserMgt.LookupUserID("Caller Reffered To");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                // UserMgt.ValidateUserID("Caller Reffered To");
            end;
        }
        field(29; "Received From"; Code[20])
        {
        }
        field(30; "Calling As"; Option)
        {
            OptionCaption = 'As Member,As Employer,As Non Member,As Others';
            OptionMembers = "As Member","As Employer","As Non Member","As Others";
        }
        field(31; "Contact Mode"; Option)
        {
            OptionCaption = 'Physical,Phone Call,E-Mail,Letter,Social Media';
            OptionMembers = Physical,"Phone Call","E-Mail",Letter,"Social Media";
        }
        field(32; "Calling For"; Option)
        {
            OptionCaption = 'Inquiry,Request,Appreciation,Complaint,Criticism,Payment,Receipt,Loan Form,Housing';
            OptionMembers = Inquiry,Request,Appreciation,Complaint,Criticism,Payment,Receipt,"Loan Form",Housing;
        }
        field(33; "Date Sent"; Date)
        {
        }
        field(34; "Time Sent"; Time)
        {
        }
        field(35; "Sent By"; Code[20])
        {
        }
        field(36; "Short Code"; Code[20])
        {
            TableRelation = "Care Log Issues Short Code";

            trigger OnValidate()
            begin
                IF ShortCodes.GET("Short Code") THEN
                    "Short Code Name" := ShortCodes.Description;
            end;
        }
        field(37; "Short Code Name"; Text[150])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF No = '' THEN BEGIN
            SalesSetup.GET;
            SalesSetup.TESTFIELD(SalesSetup."Customer Care Queries");
            NoSeriesMgt.InitSeries(SalesSetup."Customer Care Queries", xRec."No. Series", 0D, No, "No. Series");
        END;

        "Application User" := USERID;
        "Application Date" := WORKDATE;
        "Application Time" := TIME;
    end;

    var
        SalesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Loans: Record Loans;
        GenSetUp: Record "General Set-Up";
        Cust: Record Members;
        //PVApp: Record "39004416";
        UserMgt: Codeunit "User Management";
        PRD: Record Customer;
        ShortCodes: Record "Care Log Issues Short Code";
}

