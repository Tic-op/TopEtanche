namespace Top.Top;

using Microsoft.Purchases.History;

pageextension 50090 "Get Receipt Line Ext" extends "Get Receipt Lines"
{
    layout
    {
        addbefore("Document No.")
        {
            field(Sélectionné; Rec.Sélectionner)
            {
                ApplicationArea = all;

            }
        }
        addafter("Document No.")
        {
            /*field("Vendor Shipment No"; Rec."Vendor Shipment No.")
            {
                ApplicationArea = all;
            }*/
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

            action("Séléctionner la ligne")
            {
                ApplicationArea = All;
                Image = SelectMore;
                ShortcutKey = F9;
                trigger OnAction()
                var
                    CU: Codeunit PurchaseEvents;
                begin
                    CU.SelectReceiptToInvoice(rec."Document No.", Rec."Line No.");
                end;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        CU: Codeunit PurchaseEvents;

    begin
        if not Confirm('Voulez-vous vraiment quitter cette page ?', false) then
            Error('Continuez votre sélection...');

    end;
}
