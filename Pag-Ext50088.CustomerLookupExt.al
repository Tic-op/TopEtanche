namespace Top.Top;

using Microsoft.Sales.Customer;

pageextension 50088 "Customer Lookup Ext" extends "Customer Lookup"
{
    layout
    {
        modify("Responsibility Center") { Visible = false; }
        modify("Location Code") { Visible = false; }

        addafter(Name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                Editable = false;
                ApplicationArea = all;

            }
        }
    }
}
