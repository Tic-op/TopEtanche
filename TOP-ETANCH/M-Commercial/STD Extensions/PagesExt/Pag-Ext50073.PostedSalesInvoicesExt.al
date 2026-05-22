namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50073 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Bill-to Address"; Rec."Bill-to Address")
            {
                ApplicationArea = all;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
            }
        }
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
