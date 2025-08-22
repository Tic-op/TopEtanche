namespace TopEtanch.TopEtanch;

using Microsoft.Sales.History;

tableextension 50007 "Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(50108; "Type de facturation"; Option)
        {
            OptionMembers = "","Contre remboursement","Fact. Mensuelle","Fact. Plafond","Commande Totale";
        }
        field(50110; "Vente comptoir"; Boolean)
        {

        }
        field(50111; "Mode de livraison"; Option)
        {
            OptionMembers = "comptoir","Top Etanchéité","Transporteur Externe";

        }
    }
}
