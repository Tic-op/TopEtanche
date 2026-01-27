namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50073 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Remaining Amount")
        {
            field("Règlement en cours"; rec."Règlement en cours")
            {
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                Style = Favorable;
            }
        }
    }
}
