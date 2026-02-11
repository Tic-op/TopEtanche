namespace Top.Top;
using Microsoft.Purchases.Document;

pageextension 50089 "Purchase order list Ext" extends "Purchase Order List"
{
    layout
    {
        addafter("Pay-to Name")
        {
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = All;
            }
        }
    }
}