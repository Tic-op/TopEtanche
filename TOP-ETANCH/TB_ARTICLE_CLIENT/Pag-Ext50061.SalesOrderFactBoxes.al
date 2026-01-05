/* namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;

pageextension 50061 "Sales Order Fact Boxes" extends "Sales Order"
{
    layout
    {



        addlast(factboxes)
        {
            part(historique; HistVenteArticleSubform)
            {
                visible = false;
                Provider = SalesLines;
                SubPageLink = "Customer No" = field("Sell-to Customer No."), "Item No" = field("No.");

                Caption = 'Historique article-Client';
                //   UpdatePropagation=both ;
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetcurrRecord()
    var
        SalesLine: Record "Sales Line";
        Cust: Record Customer;
        item: record Item;
        History: Record 50008;
    begin
        CurrPage.historique.page.ISFactbox(true);
        CurrPage.SalesLines.Page.GetRecord(SalesLine);
        Cust.get(rec."Sell-to Customer No.");
        CurrPage.historique.page.SetCustomer(Cust);
        if SalesLine.Type = "Sales Line Type"::item then begin
            if item.get(SalesLine."No.") then;
            CurrPage.historique.page.Setitem(item);

            CurrPage.historique.page.InsertValues(true);
            //  CurrPage.historique.page.Update(true);
            CurrPage.historique.page.Activate();

            //CurrPage.Update(false);
        end

    end;




}

 */