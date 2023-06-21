table 51532021 "Savings Account Registration"
{

    fields
    {
        field(1; "No."; Code[20])
        {

        }
        field(2; "Product Type"; Code[20])
        {
            Description = 'LookUp to Product Factory';
            TableRelation = "Product Factory" WHERE("Product Class Type" = CONST(Savings),
                                                     Status = CONST(Active),
                                                     "Product Category" = FILTER(<> "Fixed Deposit"));

            trigger OnValidate()
            begin
                if ProductFactory.Get("Product Type") then
                    "Product Name" := ProductFactory."Product Description";

                "Minimum Contribution" := ProductFactory."Minimum Contribution";
                "Monthly Contribution" := ProductFactory."Minimum Contribution";
                "Product Category" := ProductFactory."Product Category";

                ProductDocuments.Reset;
                ProductDocuments.SetRange("Product ID", "Product Type");
                if ProductDocuments.Find('-') then begin
                    repeat
                        ApplicationDocuments.FindLast;
                        EntryNo := ApplicationDocuments."Entry No." + 1;

                        ApplicationDocuments.Reset;
                        ApplicationDocuments.SetRange("Document No.", ProductDocuments."Document No.");
                        ApplicationDocuments.SetRange("Reference No.", "No.");
                        if not ApplicationDocuments.Find('-') then begin
                            ApplicationDocuments.Init;
                            ApplicationDocuments."Entry No." := EntryNo;
                            ApplicationDocuments."Product ID" := ProductDocuments."Product ID";
                            ApplicationDocuments.Description := ProductDocuments.Description;
                            ApplicationDocuments."Reference No." := "No.";
                            ApplicationDocuments."Document No." := ProductDocuments."Document No.";
                            ApplicationDocuments."Product Name" := ProductFactory."Product Description";
                            ApplicationDocuments.Insert;
                        end;
                    until ProductDocuments.Next = 0;

                end;
            end;
        }
        field(3; "Product Name"; Text[100])
        {
        }
        field(4; "Monthly Contribution"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Monthly Contribution" < "Minimum Contribution" then
                    Error('Contribution cannot be less than the Minimum required of KES %1', "Minimum Contribution");
            end;
        }
        field(5; "Product Category"; Option)
        {
            OptionCaption = ' ,Share Capital,Main Shares,Fixed Deposit,Junior Savings,Registration Fee,Benevolent,Unallocated Fund,Micro Credit Deposits,NHIF,Jivinjari,School Fee,Dividend,Plot,Redeemable,KUSCCO,Housing,Creditor,Prime';
            OptionMembers = " ","Share Capital","Deposit Contribution","Fixed Deposit","Junior Savings","Registration Fee",Benevolent,"Unallocated Fund","Micro Credit Deposits",NHIF,Jivinjari,"School Fee",Dividend,Plot,Redeemable,KUSCCO,Housing,Creditor,Prime;
        }
        field(6; "Minimum Contribution"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    keys
    {
        key(Key1; "No.", "Product Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ProductFactory.Get("Product Type") then
            if ProductFactory."Auto Open Account" then
                Error('Operation Disabled. Product should be Auto Created');
    end;

    trigger OnRename()

    begin
        if ProductFactory.Get(xRec."Product Type") then
            if ProductFactory."Auto Open Account" then
                Error('Operation Disabled. Product should be Auto Created');
    end;

    trigger OnInsert()
    var
        MemberApp: Record "Member Application";
        ProdApplicable: Record "Product Applicable Categories";
    begin

        MemberApp.Reset();
        MemberApp.SetRange("No.", "No.");
        if MemberApp.Find('-') then begin
            ProdApplicable.Reset();
            ProdApplicable.SetRange("Product ID", "Product Type");
            ProdApplicable.SetRange("Member Account Category", MemberApp."Single Party/Multiple/Business");
            if ProdApplicable.FindFirst() = false then
                Error('This product is not applicable for this Customer Type');
        end;
    end;

    var
        ProductFactory: Record "Product Factory";
        ProductDocuments: Record "Product Documents";
        ApplicationDocuments: Record "Application Documents";
        EntryNo: Integer;
}

