/// <summary>
/// Table Product Applicable Categories (ID 51532008).
/// </summary>
table 51532008 "Product Applicable Categories"
{
    Caption = 'Product Applicable Categories';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;

            DataClassification = ToBeClassified;
        }
        field(2; "Member Account Category"; Option)
        {
            Caption = 'Member Category';
            OptionCaption = 'Single,Group,Corporate,Cell,Joint';
            OptionMembers = Single,Group,Business,Cell,Joint;

            DataClassification = ToBeClassified;

        }
        field(3; "Product ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Factory"."Product ID";
        }
        field(4; "Minimum Contribution"; Decimal)
        {

        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// GetMinimumContribution.
    /// </summary>
    /// <param name="Account Category">Option Single,Group,Business,Cell,Joint.</param>
    /// <param name="Product Code">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetMinimumContribution("Account Category": Option Single,Group,Business,Cell,Joint; "Product Code": Code[20]): Decimal
    var
        ProdApp: Record "Product Applicable Categories";
    begin
        ProdApp.Reset();
        ProdApp.SetRange("Product ID", "Product Code");
        ProdApp.SetRange("Member Account Category", "Account Category");
        if ProdApp.FindFirst() then
            exit(ProdApp."Minimum Contribution")
        else
            exit(0);
    end;
}
