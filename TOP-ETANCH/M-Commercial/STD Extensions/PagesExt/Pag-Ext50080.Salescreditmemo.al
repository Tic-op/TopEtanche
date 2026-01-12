namespace Top.Top;

using Microsoft.Sales.Document;

pageextension 50080 "Sales credit memo " extends "Sales Credit Memo"
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
