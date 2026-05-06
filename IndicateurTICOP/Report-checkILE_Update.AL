report 70003 CheckILEUpdate

{
    Permissions = tabledata "Item Ledger Entry" = r;
    DefaultLayout = RDLC;
    Caption = 'CheckILE';
    ApplicationArea = all;
    RDLCLayout = 'CheckILEUPdate.RDL';
    UsageCategory = ReportsAndAnalysis;


    dataset
    {

        dataitem(ILE; "Item Ledger Entry")

        {
            RequestFilterFields = "Document No.", "Item No.", "Posting Date";
            DataItemTableView = where("Entry Type" = const("Item Ledger Entry Type"::Sale));
            Column(Entry_No_; "Entry No.")
            {

            }
            column(Cost_Amount__Actual_; "Cost Amount (Actual)") { }
            Column(Cost_Amount__Expected_; "Cost Amount (Expected)") { }

            Column(Cost_Amount; "Cost Amount (Actual)" + "Cost Amount (Expected)")
            { }

            column(Cout_Ticop; "Operation Cost")
            { }

            column(Sales_Amount__Actual_; "Sales Amount (Actual)")
            { }
            column(Sales_Amount__Expected_; "Sales Amount (Expected)") { }
            Column(Sales_amount; "Sales Amount (Actual)" + "Sales Amount (Expected)")
            {

            }
            Column(Sales_Operation_Amount; "Sales Operation Amount")
            {
            }


            column(Profit__; "Profit %")
            { }
            column(Profit_Amount; "Profit Amount")
            {

            }

            trigger OnPreDataItem()
            begin

                SetAutoCalcFields("Sales Amount (Actual)", "Sales Amount (Expected)", "Cost Amount (Actual)", "Cost Amount (Expected)")
            end;
        }

    }


}