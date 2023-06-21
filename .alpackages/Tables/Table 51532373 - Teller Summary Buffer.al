table 51532373 "Teller Summary Buffer"
{

    fields
    {
        field(1; Date; Date)
        {
        }
        field(2; "Bank Account"; Code[20])
        {
        }
        field(3; Cashier; Code[50])
        {
        }
        field(4; Type; Option)
        {
            OptionCaption = ' ,OpenBal,Receipts,CashFromBank,InternalTransfer_Rec,InterTeller_Rec,LTLoans,STLoans,ClassA,ClassB,ClassC,Photocopy_Sales,BankStmt,Savings_Rec,SCapital_Entr,PayOrders,TellerExcess,MabakiExcess,MpesaDep,SubTot_Rec,Payments,InternalTrans_Pmt,InterTeller_Pmt,BankChq,MpesaWith,PettyCash,Savings_Pmt,SubTot_Pmt,CloseBal_Manual,CloseBal_System,ClosePhysical_Cheque,ClosePhysical_Cash,Vouchers,Total,CashShortExcess,MembersServed,Others_Receipts,Deposits_Count,Withdrawals_Count,Customers_Served_Total';
            OptionMembers = " ",OpenBal,Receipts,CashFromBank,InternalTransfer_Rec,InterTeller_Rec,LTLoans,STLoans,ClassA,ClassB,ClassC,Photocopy_Sales,BankStmt,Savings_Rec,SCapital_Entr,PayOrders,TellerExcess,MabakiExcess,MpesaDep,SubTot_Rec,Payments,InternalTrans_Pmt,InterTeller_Pmt,BankChq,MpesaWith,PettyCash,Savings_Pmt,SubTot_Pmt,CloseBal_Manual,CloseBal_System,ClosePhysical_Cheque,ClosePhysical_Cash,Vouchers,Total,CashShortExcess,MembersServed,Others_Receipts,Deposits_Count,Withdrawals_Count,Customers_Served_Total;

            trigger OnValidate()
            begin

            end;

        }
        field(5; Name; Code[100])
        {
            //TableRelation = "Teller Summary Codes".Name;
        }
        field(6; Position; Integer)
        {
        }
        field(7; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Position, Date, "Bank Account", Type)
        {
        }
    }

    fieldgroups
    {
    }

    var
    //TellerSummaryCodes: Record "Teller Summary Codes";
}

