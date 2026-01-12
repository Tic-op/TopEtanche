namespace TopEtanch.TopEtanch;

using Microsoft.Sales.History;
using Microsoft.Bank.Payment;
using Microsoft.Inventory.Ledger;

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
        field(50004; "Règlement en cours"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Line".Amount where("facture caisse" = field("No."), "Copied To No." = filter(''), "Status No." = filter(0)));
            Caption = 'Règlement caisse';

        }
        field(50008; Invoiced; Boolean)
        {
            Caption = 'Facturé';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Item Ledger Entry" where("document no." = field("no."), "Invoiced Quantity" = filter(<> 0)));

        }
    }
}
