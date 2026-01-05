namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50061 "Posted Sales Shipment Lines Ex" extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Line Discount %"; Rec."Line Discount %") { ApplicationArea = all; }
            field("Unit Price"; Rec."Unit Price") { ApplicationArea = all; }
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = all; }

        }
    }
}
