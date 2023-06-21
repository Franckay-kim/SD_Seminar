table 51532374 "Teller Summary Codes"
{

    fields
    {
        field(1;Name;Code[100])
        {
        }
        field(2;Position;Integer)
        {
        }
        field(4;Type;Option)
        {
            OptionCaption = ' ,OpenBal,Receipts,CashFromBank,InternalTransfer_Rec,InterTeller_Rec,LTLoans,STLoans,ClassA,ClassB,ClassC,Shop_Sales,Income,Savings_Rec,SCapital_Entr,PayOrders,TellerExcess,MabakiExcess,MpesaDep,SubTot_Rec,Payments,InternalTrans_Pmt,InterTeller_Pmt,BankChq,MpesaWith,PettyCash,Savings_Pmt,SubTot_Pmt,CloseBal_Manual,CloseBal_System,ClosePhysical_Cheque,ClosePhysical_Cash,Vouchers,Total,CashShortExcess,MembersServed,Others_Receipts,Deposits_Count,Withdrawals_Count,Customers_Served_Total';
            OptionMembers = " ",OpenBal,Receipts,CashFromBank,InternalTransfer_Rec,InterTeller_Rec,LTLoans,STLoans,ClassA,ClassB,ClassC,Shop_Sales,Income,Savings_Rec,SCapital_Entr,PayOrders,TellerExcess,MabakiExcess,MpesaDep,SubTot_Rec,Payments,InternalTrans_Pmt,InterTeller_Pmt,BankChq,MpesaWith,PettyCash,Savings_Pmt,SubTot_Pmt,CloseBal_Manual,CloseBal_System,ClosePhysical_Cheque,ClosePhysical_Cash,Vouchers,Total,CashShortExcess,MembersServed,Others_Receipts,Deposits_Count,Withdrawals_Count,Customers_Served_Total;
        }
        field(5;Deactivated;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;Position)
        {
        }
    }

    fieldgroups
    {
    }
}

