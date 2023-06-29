/// <summary>
/// Report testfosa (ID 50106).
/// </summary>
report 50106 testfosa
{
    ApplicationArea = All;
    Caption = 'testfosa';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/testFosaTransfer.rdl';
    dataset
    {
        dataitem(SavingsLedgerEntry; "Savings Ledger Entry")
        {
            column(Amount; Amount)
            {
            }
            column(AmountLCY; "Amount (LCY)")
            {
            }
            column(ApproverID; "Approver ID")
            {
            }
            column(BalAccountNo; "Bal. Account No.")
            {
            }
            column(BalAccountType; "Bal. Account Type")
            {
            }
            column(BulkProcess; "Bulk Process")
            {
            }
            column(CreditAmount; "Credit Amount")
            {
            }
            column(CreditAmountLCY; "Credit Amount (LCY)")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(DebitAmount; "Debit Amount")
            {
            }
            column(DebitAmountLCY; "Debit Amount (LCY)")
            {
            }
            column(Description; Description)
            {
            }
            column(DimensionSetID; "Dimension Set ID")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(GroupCode; "Group Code")
            {
            }
            column(JournalBatchName; "Journal Batch Name")
            {
            }
            column(LoanDisbursement; "Loan Disbursement")
            {
            }
            column(MemberName; "Member Name")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(Open; Open)
            {
            }
            column(Positive; Positive)
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(PostingGroup; "Posting Group")
            {
            }
            column(RegisterDate; "Register Date")
            {
            }
            column(RegisterTime; "Register Time")
            {
            }
            column(RemainingAmount; "Remaining Amount")
            {
            }
            column(Reversed; Reversed)
            {
            }
            column(ReversedEntryNo; "Reversed Entry No.")
            {
            }
            column(ReversedbyEntryNo; "Reversed by Entry No.")
            {
            }
            column(SourceCode; "Source Code")
            {
            }
            column(SpecialAccount; "Special Account")
            {
            }
            column(StaffNo; "Staff No.")
            {
            }

            column(TransactionNo; "Transaction No.")
            {
            }
            column(UserID; "User ID")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
