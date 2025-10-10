namespace AAP.AAP;

using Microsoft.Sales.Document;

pageextension 60100 "Remise Facture Commande" extends "Sales Order Subform"
{
    layout
    {
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
    }
}
pageextension 60101 "Remise Facture Devis" extends "Sales Quote Subform"
{
    layout
    {
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
    }
}
pageextension 60102 "Remise Facture Facture" extends "Sales Invoice Subform"
{
    layout
    {
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
    }
}
pageextension 60103 "Remise Facture Avoir" extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
    }
}
pageextension 60104 "Remise Facture Commande Cadre" extends "Blanket Sales Order Subform"
{
    layout
    {
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
    }
}


