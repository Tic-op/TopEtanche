namespace Top.Top;

using Microsoft.Sales.Document;

pageextension 50066 SaleslineFactboxtry extends "Sales Line FactBox"
{
    layout
    {
        addlast(Item)
        {
            /* part(historique; HistVenteArticleSubform)
            {
                Provider = SalesLines;
                SubPageLink = "Customer No" = field("Sell-to Customer No.");

                Caption = 'Historique article-Client';
                //   UpdatePropagation=both ;
                ApplicationArea = all;

            }
             */
        }
    }
}
