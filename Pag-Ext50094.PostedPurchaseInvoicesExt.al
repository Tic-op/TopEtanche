namespace Top.Top;

using Microsoft.Purchases.History;

pageextension 50094 "Posted Purchase Invoices Ext" extends "Posted Purchase Invoices"
{
    layout
    {

        addafter("Buy-from Vendor Name")
        {

            field("Buy-from Address"; Rec."Buy-from Address") { ApplicationArea = all; }
            field("VAT Registration No."; Rec."VAT Registration No.") { ApplicationArea = all; }
        }
    }
}
