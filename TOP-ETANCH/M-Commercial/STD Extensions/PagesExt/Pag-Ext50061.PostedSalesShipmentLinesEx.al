namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50061 "Posted Sales Shipment Lines Ex" extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Unit Price"; Rec."Unit Price") { ApplicationArea = all; }
            field("Line Discount %"; Rec."Line Discount %") { ApplicationArea = all; }
            field("VAT %"; Rec."VAT %") { ApplicationArea = all; }
            field(HT; rec."Unit Price" * rec.Quantity * (1 - (rec."Line Discount %" / 100)))
            {
                ApplicationArea = all;
                editable = false;

            }
            Field(TTC; rec."Unit Price" * rec.Quantity * (1 - (rec."Line Discount %" / 100)) * (1 + (rec."VAT %" / 100)))
            {
                ApplicationArea = all;
                editable = false;
            }
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = all; }

        }
    }
}
