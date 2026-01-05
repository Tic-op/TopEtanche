namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;

pageextension 50068 "Cr.memo card " extends "Sales Credit Memo"
{
    actions
    {


        addlast(processing)
        {
            action(imprimer_Ticket_Retour)
            {
                ApplicationArea = all;
                trigger onaction()
                var
                    SalesH: record "Sales Header";
                    item: Record Item;

                begin
                    /* SalesH.setrange("Document Type",rec."Document Type");
                    SalesH.setrange("No.",rec."No.");
                    report.RunModal(50017;); */
                    // item.DeleteAll(false);


                end;
            }
        }
    }
}
