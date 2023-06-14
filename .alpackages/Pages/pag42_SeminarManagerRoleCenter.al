page 50142 "CSD Seminar Manager RoleCenter"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 10 - Lab 1 - 5
// - Created new page
{
    PageType = RoleCenter;
    Caption = 'Seminar Manager RoleCenter';
    layout
    {
        area(RoleCenter)
        {
            group(Column1)
            {
                part(Activities; "CSD Seminar Manager Activities")
                {
                }
                part(MySeminars; "CSD My Seminars")
                {
                }
            }
            group(Column2)
            {
                part(MyCustomers; "My Customers")
                {
                }
                systempart(MyNotifications; MyNotes)
                {
                }
                part(ReportInbox; "Report Inbox Part")
                {
                }
            }
        }
    }
    actions
    {
        area(embedding)
        {
            action(SeminarRegistrations)
            {
                Caption = 'Seminar Registrations';
                Image = List;
                RunObject = Page "CSD Posted Seminar Reg. List";
                ToolTip = 'Create seminar registrations';
            }
            action(Seminars)
            {
                Caption = 'Seminars';
                Image = List;
                RunObject = Page "CSD Seminar List";
                ToolTip = 'View all seminars';
            }
            action(Instructors)
            {
                Caption = 'Instructors';
                RunObject = Page "Resource List";
                RunPageView = WHERE(Type = const(Person));
                ToolTip = 'View all resources registeres as persons';
            }
            action(Rooms)
            {
                Caption = 'Instructors';
                RunObject = Page "Resource List";
                RunPageView = WHERE(Type = const(Machine));
                ToolTip = 'View all resources registeres as machines';
            }
            action("Sales Invoices")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
                ToolTip = 'Register your sales to customers';
            }
            action("Sales Credit Memos")
            {
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
                ToolTip = 'Revert the financial transactions involved when your customers want to cancel a purchase';
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'View or edit detailed information for the customers that you trade with.';
            }
        }
        area(Sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View history for sales, shipments, and inventory.';
                action("Posted Seminar Registrations")
                {
                    Caption = 'Posted Seminar Registrations';
                    Image = Timesheet;
                    RunObject = Page "CSD Posted Seminar Reg. List";
                    ToolTip = 'Open the list of posted Registrations.';
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Registers")
                {
                    Caption = 'Seminar Registers';
                    Image = PostedShipment;
                    RunObject = Page "CSD Seminar Registers";
                    ToolTip = 'Open the list of Seminar Registers.';
                }
            }
        }

        area(Creation)
        {
            action(NewSeminarRegistration)
            {
                Caption = 'Seminar Registration';
                Image = NewTimesheet;
                RunObject = page "CSD Seminar Registration";
                RunPageMode = Create;
            }
            action(NewSalesInvoice)
            {
                Caption = 'Sales Invoice';
                Image = NewSalesInvoice;
                RunObject = page "Sales Invoice";
                RunPageMode = Create;
            }
        }

        area(Processing)
        {
            action(CreateInvoices)
            {
                Caption = 'Create Invoices';
                Image = CreateJobSalesInvoice;
                RunObject = report "CSD Create Seminar Invoices";
            }

            action(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;
                RunObject = page Navigate;
                RunPageMode = Edit;
            }
        }
    }
}



