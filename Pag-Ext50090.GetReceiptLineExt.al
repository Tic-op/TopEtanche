namespace Top.Top;

using Microsoft.Purchases.History;

pageextension 50090 "Get Receipt Line Ext" extends "Get Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = all;
            }
            field(Order; Rec.Order)
            {
                ApplicationArea = all;

            }
        }

    }
    actions
    {
        addafter("Show Document")
        {
            action("Actualiser documents")
            {
                Image = UpdateDescription;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CU: Codeunit PurchaseEvents;
                begin
                    Rec.findfirst;
                    repeat
                        CU.UpdateDocInExtractReceipt(rec."Document No.", Rec."Line No.");
                    until Rec.Next() = 0;
                end;
            }
        }
    }
}
