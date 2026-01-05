namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;

report 50020 "Disponibilité commande cadre"
{
    ApplicationArea = All;
    Caption = 'Disponibilité commande cadre';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'DispoCommandeCadre.rdl';
    dataset
    {
        dataitem(salesline; "sales line")
        {
            DataItemTableView = where("Document Type" = const("Blanket Order"));
            column(DocumentNo; "Document No.")
            {
            }
            column(Posting_Date; "Posting Date") { }
            column(LineNo; "Line No.")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(No; "No.")
            {
            }
            column(Ref; Item."Vendor Item No." + ' ' + Item."reference origine") { }

            column(Description; Description)
            {
            }
            column(OutstandingQuantity; "Outstanding Quantity")
            {
            }
            column(Dispo; Dispo) { }
            column(SurCmdeAchat; Item."Qty. on Purch. Order") { }
            column(Fournisseur; Item."Vendor Name") { }
            trigger OnAfterGetRecord()
            var
            begin
                if type <> Type::Item then
                    CurrReport.Skip();
                if not Item.get("No.") then
                    CurrReport.Skip();

                dispo := GetDisponibilite(true);
                Item.CalcFields("Qty. on Purch. Order");

                if (ShowAs = ShowAs::Disponible) and (dispo < "Outstanding Quantity") then
                    CurrReport.Skip();
                if (ShowAs = ShowAs::"Non disponible") and (dispo > "Outstanding Quantity") then
                    CurrReport.Skip();
                if (ShowAs = ShowAs::"Prochainement dispo") and
                 (dispo + item."Qty. on Purch. Order" < "Outstanding Quantity") then
                    CurrReport.Skip();
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
                    field("Afficher "; ShowAs) { ApplicationArea = all; }

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
        Item: Record Item;
        ShowAs: Option Tout,"Non disponible","Disponible","Prochainement dispo";
        dispo: Decimal;
}
