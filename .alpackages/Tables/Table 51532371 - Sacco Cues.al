table 51532371 "Sacco Cues"
{

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; "Loans - Application"; Integer)
        {
            CalcFormula = Count(Loans WHERE(Status = CONST(Application),
                                             Posted = CONST(false)));

            FieldClass = FlowField;
        }
        field(3; "Loans - Appraisal"; Integer)
        {
            CalcFormula = Count(Loans WHERE(Status = CONST(Appraisal),
                                             Posted = CONST(false)));

            FieldClass = FlowField;
        }
        field(4; "Loans - Approved"; Decimal)
        {
            CalcFormula = Sum(Loans."Approved Amount");

            FieldClass = FlowField;
        }
        field(5; "Loans - Rejected"; Integer)
        {
            CalcFormula = Count(Loans WHERE(Status = CONST(Rejected),
                                             Posted = CONST(false)));

            FieldClass = FlowField;
        }
        field(6; "Approval Entry"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE(Status = CONST(Open),
                                                        "Approver ID" = FIELD("User Filter")));
            FieldClass = FlowField;
        }
        field(7; "User Filter"; Code[50])
        {
            FieldClass = FlowFilter;
        }
        field(8; "Loans - Posted"; Integer)
        {
            CalcFormula = Count(Loans WHERE(Posted = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        /*field(9;"Leave - Application";Integer)
        {
            CalcFormula = Count("HR Leave Application" WHERE (Status=CONST(New),
                                                              "Applicant User ID"=FIELD("User Filter")));
            FieldClass = FlowField;
        }
        field(10;"Leave - Pending";Integer)
        {
            CalcFormula = Count("HR Leave Application" WHERE (Status=CONST("Pending Approval"),
                                                              "Applicant User ID"=FIELD("User Filter")));
            FieldClass = FlowField;
        }
        field(11;"Leave - Approved";Integer)
        {
            CalcFormula = Count("HR Leave Application" WHERE (Status=CONST(Approved),
                                                              "Applicant User ID"=FIELD("User Filter")));
            FieldClass = FlowField;
        }
        field(12;"Leave - Rejected";Integer)
        {
            CalcFormula = Count("HR Leave Application" WHERE (Status=CONST(Rejected),
                                                              "Applicant User ID"=FIELD("User Filter")));
            FieldClass = FlowField;
        }*/
        field(13; "Member Application - Open"; Integer)
        {
            CalcFormula = Count("Member Application" WHERE(Status = CONST(Open),
                                                            "Group Account" = CONST(false)));
            FieldClass = FlowField;
        }
        field(14; "Member Application - Pending"; Integer)
        {
            CalcFormula = Count(Members);
            FieldClass = FlowField;
        }
        field(15; "Group Application - Open"; Integer)
        {
            CalcFormula = Count("Member Application" WHERE(Status = CONST(Open),
                                                            "Group Account" = CONST(false)));
            FieldClass = FlowField;
        }
        field(16; "Group Application - Pending"; Integer)
        {
            CalcFormula = Count("Member Application" WHERE(Status = CONST(Pending),
                                                            "Group Account" = CONST(false)));
            FieldClass = FlowField;
        }
        field(17; "Account Application - Open"; Integer)
        {
            CalcFormula = Count("Savings Account Application" WHERE(Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(18; "Account Application - Pending"; Integer)
        {
            CalcFormula = Count("Savings Account Application" WHERE(Status = CONST(Pending)));
            FieldClass = FlowField;
        }
        field(19; "Cashier Trans. - Open"; Integer)
        {
            CalcFormula = Count("Cashier Transactions" WHERE(Posted = CONST(false),
                                                              Cashier = FIELD("User Filter"),
                                                              Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(20; "Cashier Trans. - Pending"; Integer)
        {
            CalcFormula = Count("Cashier Transactions" WHERE(Posted = CONST(false),
                                                              Cashier = FIELD("User Filter"),
                                                              Status = CONST("Pending Approval")));
            FieldClass = FlowField;
        }
        field(21; "Cashier Trans. - Approved"; Integer)
        {
            CalcFormula = Count("Cashier Transactions" WHERE(Posted = CONST(false),
                                                              Cashier = FIELD("User Filter"),
                                                              Status = CONST(Approved)));
            FieldClass = FlowField;
        }
        field(22; "Cashier Trans. - Posted"; Integer)
        {
            CalcFormula = Count("Cashier Transactions" WHERE(Posted = CONST(true),
                                                              Cashier = FIELD("User Filter")));
            FieldClass = FlowField;
        }
        field(23; "Treasury/Teller - Open"; Integer)
        {
            CalcFormula = Count("Treasury Cashier Transactions" WHERE(Posted = CONST(false),
                                                                       Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(24; "Treasury/Teller - Pending"; Integer)
        {
            CalcFormula = Count("Treasury Cashier Transactions" WHERE(Posted = CONST(false),
                                                                       Status = CONST(Pending)));
            FieldClass = FlowField;
        }
        field(25; "Treasury/Teller - Approved"; Integer)
        {
            CalcFormula = Count("Treasury Cashier Transactions" WHERE(Posted = CONST(false),
                                                                       Status = CONST(Approved)));
            FieldClass = FlowField;
        }
        field(26; "Treasury/Teller - Posted"; Integer)
        {
            CalcFormula = Count("Treasury Cashier Transactions" WHERE(Posted = CONST(true)));
            FieldClass = FlowField;
        }
        field(27; "Transfer List"; Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE("Assigned User ID" = FIELD("User Filter")));
            FieldClass = FlowField;
        }
        /*field(28;"Shops Sales Invoice List";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE ("Document Type"=FILTER(Invoice),
                                                      "Created By"=FIELD("User Filter")));
            FieldClass = FlowField;
        }*/
        field(29; "Posted Shops Sales Invoice"; Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE("User ID" = FIELD("User Filter")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

