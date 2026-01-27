namespace Top.Top;
using Microsoft.Sales.Customer;

pageextension 50064 "Customer List Ext" extends "Customer List"
{
    layout
    {
        addafter(name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.") { ApplicationArea = all; }
        }
    }
}
