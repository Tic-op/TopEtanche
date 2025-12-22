namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;

pageextension 50062 "Sales Quote Fact Boxes" extends "Sales Quote"
{
    layout
    {
        addlast(factboxes)
        {
            part(historique; HistVenteArticleSubform)
            {
                SubPageLink = "Customer No" = field("Sell-to Customer No.");
                //Provider =SalesLines;
                //   UpdatePropagation=both ;
                Caption = 'Historique article-Client';
                ApplicationArea = all;

            }
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
        Cust: Record Customer;
        item: record Item;
    begin
        CurrPage.historique.page.ISFactbox(true);
        CurrPage.SalesLines.Page.GetRecord(SalesLine);
        Cust.get(rec."Sell-to Customer No.");
        CurrPage.historique.page.SetCustomer(Cust);
        if SalesLine.Type = "Sales Line Type"::item then begin
            if item.get(SalesLine."No.") then;
            CurrPage.historique.page.Setitem(item);

            CurrPage.historique.page.InsertValues(true);
            CurrPage.historique.page.Update(true);

            // CurrPage.Update(false);
        end

    end;



}

