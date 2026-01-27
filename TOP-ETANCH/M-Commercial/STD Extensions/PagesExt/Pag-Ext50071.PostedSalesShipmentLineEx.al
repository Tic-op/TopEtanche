namespace Top.Top;
using Microsoft.Sales.History;
using Microsoft.Sales.Customer;

pageextension 50071 "Posted Sales Shipment Line Ex" extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter("No.")
        {
            field(Date; Rec."Posting Date")
            {
                ApplicationArea = all;

            }
        }
        addafter("Sell-to Customer No.")
        {
            field(NomClient; NomClient)
            {
                ApplicationArea = all;
            }
        }


    }

    trigger OnAfterGetRecord()
    var
        cust: Record Customer;
    begin
        if cust.get(rec."Sell-to Customer No.") then
            NomClient := cust.name
        else
            NomClient := '';
    end;

    var
        NomClient: Text;
}
