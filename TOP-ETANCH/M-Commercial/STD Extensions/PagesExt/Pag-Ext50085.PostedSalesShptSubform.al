namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50085 "Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
{
    Layout
    {

        addafter(Quantity)
        {
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = all;
                editable = false;
            }
            field("Line Discount %"; Rec."Line Discount %")
            {
                ApplicationArea = all;
                editable = false;
            }
            Field("VAT %"; Rec."VAT %")
            {
                ApplicationArea = all;
                editable = false;
            }
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
        }
    }
}
