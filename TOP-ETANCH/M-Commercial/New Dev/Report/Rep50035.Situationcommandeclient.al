namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;

report 50035 "Situation commande client"
{
    ApplicationArea = All;
    Caption = 'Situation commande client';
    DefaultLayout = RDLC;
    RDLCLayout = 'Situation Commandes Clients.RDL';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(SalesLine; "Sales Line")
        {
            RequestFilterFields = "Sell-to Customer No.";
            DataItemTableView = where("Qty. to Ship (Base)" = filter(<> 0), "Document Type" = filter("Sales Document Type"::Order | "Sales Document Type"::"Blanket Order"), Type = const("Sales Line Type"::Item));
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(QuantityBase; "Quantity (Base)")
            {
            }
            column(QtytoShipBase; "Qty. to Ship (Base)")
            {
            }
            column(Dispo; Dispo)
            {

            }
            column(Tampon; Tampon)
            {

            }
            Column(CommandeAchat; CommandeAchat)
            {

            }
            Column(CommandeCadreAchat; CommandeCadreAchat)
            {

            }
            Column(Commande; Commande)
            { }
            Column(Cadre; Cadre) { }

            trigger OnAfterGetRecord()
            var
                Itemrec: record Item;

            begin
                Commande := 0;
                Cadre := 0;
                Dispo := GetDisponibilite(true);
                CommandeAchat := 0;
                CommandeCadreAchat := 0;


                Itemrec.get("No.");

                Itemrec.CalcFields("Qty. on Purch. Order", "Qty Confirmed in Blanket Order");

                CommandeAchat := Itemrec."Qty. on Purch. Order";
                CommandeCadreAchat := Itemrec."Qty Confirmed in Blanket Order";
                itemrec.setrange("Location Filter", 'LIV');
                Itemrec.CalcFields(Inventory);
                Tampon := Itemrec.inventory;
                Itemrec.Reset();





                if "Document Type" = "Sales Document Type"::Order then begin
                    Commande := "Qty. to Ship (Base)";
                    If Commande = 0 then CurrReport.skip;
                end;

                if "Document Type" = "Sales Document Type"::"Blanket Order" then begin
                    Cadre := "Qty. to Ship (Base)";
                    If cadre = 0 then CurrReport.skip;
                end



            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        Commande, Cadre : decimal;
        CommandeCadreAchat, CommandeAchat, Tampon, Dispo : decimal;
}
