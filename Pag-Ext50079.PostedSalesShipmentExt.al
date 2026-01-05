namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50079 "Posted Sales Shipments Ext" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Règlement en cours"; Rec."Règlement en cours")
            {
                ApplicationArea = all;
                Style = Favorable;
                BlankZero = true;
            }

        }
    }
}
