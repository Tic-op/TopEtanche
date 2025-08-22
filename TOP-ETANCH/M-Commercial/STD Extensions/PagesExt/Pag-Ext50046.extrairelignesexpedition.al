namespace TOPETANCH.TOPETANCH;

using Microsoft.Sales.History;

pageextension 50046 "extraire lignes expedition " extends "Get Shipment Lines"
{
    layout
    {

        addafter("Document No.")
        {

            field("Blanket Order No."; Rec."Blanket Order No.")
            {

                Visible = true;
                ApplicationArea = all;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SalesShipL: record "Sales Shipment Line";
    begin
        ///// à faire 



    end;
}
