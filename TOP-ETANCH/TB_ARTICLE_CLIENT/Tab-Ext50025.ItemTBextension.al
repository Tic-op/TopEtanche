namespace BSPCloud.BSPCloud;

using Microsoft.Inventory.Item;
using Microsoft.Sales.History;
using Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;

tableextension 50225 ItemTBextension extends Item
{
     Procedure GetLastSales(CustNo: Code[20]; CustName: text[100]; VAT_Rate: decimal)
    var
        SalesShipLine: record "Sales Shipment Line";
        SalesLine: Record "Sales Line";
        Hist: Record HistVenteArticle temporary;
        Pagedétail: Page "Détail vente article";
        Cust: record Customer;
    begin
       
        Cust.get(CustNo);

        "Pagedétail".SetCustomer(Cust);
        "Pagedétail".Setitem(Rec, VAT_Rate);
        "Pagedétail".SetRecord(Rec);
        "Pagedétail".Run();










    end;
     
}
