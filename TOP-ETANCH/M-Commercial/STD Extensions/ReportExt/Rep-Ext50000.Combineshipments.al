namespace Top.Top;

using Microsoft.Sales.Document;

reportextension 50000 "Combine shipments" extends "Combine Shipments"
{
    dataset
    {   modify(SalesOrderHeader)
       {
        RequestFilterFields = "Type de facturation" ;
       }
    }
}
