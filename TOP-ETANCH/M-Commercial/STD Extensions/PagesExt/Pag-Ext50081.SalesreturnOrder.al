namespace Top.Top;

using Microsoft.Sales.Document;

pageextension 50081 "Sales return Order" extends "Sales Return Order"
{
    layout
    {

        moveafter("Sell-to Customer Name"; "Salesperson Code")
        modify("Salesperson Code")
        {
            ShowMandatory = true;
        }
    }
}
