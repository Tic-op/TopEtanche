namespace Top.Top;

using Microsoft.Sales.History;

pageextension 50063 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    actions
    {
        addafter(Print)
        {
            action("Payer")
            {
                Image = PaymentForecast;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    FichePaiement: Page "Fiche Paiement";
                begin

                    //    if CaisseMngmt.CalcRestantCommande(rec."No.") > 0 then begin
                    FichePaiement.SetRecord(Rec);
                    FichePaiement.RunModal();
                    //    end
                    //else
                    //Error('Déja payé !');

                    CurrPage.Update();

                end;
            }
        }
    }
}
