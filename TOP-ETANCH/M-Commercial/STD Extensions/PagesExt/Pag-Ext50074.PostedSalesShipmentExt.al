namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50074 "Posted Sales Shipment Ext" extends "Posted Sales Shipment"
{
    actions
    {
        addafter("&Print")
        {
            action("Payer")
            {
                Caption = 'Payer';
                Image = PaymentForecast;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FichePaiementBL: Page "Fiche Paiement BL";
                begin
                    FichePaiementBL.SetShipment(Rec);
                    FichePaiementBL.RunModal();
                end;
            }
        }
    }

}
