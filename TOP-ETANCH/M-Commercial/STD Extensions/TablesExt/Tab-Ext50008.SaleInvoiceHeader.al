namespace TopEtanch.TopEtanch;

using Microsoft.Sales.History;

tableextension 50008 SaleInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50108; "Type de facturation"; Option)
        {
            OptionMembers = "","Contre remboursement","Fact. Mensuelle","Fact. Plafond","Commande Totale";
        }
    }
}
