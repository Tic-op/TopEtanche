namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Pricing.PriceList;

page 50026 "Détail vente article"
{
    ApplicationArea = All;
    Caption = 'Détail vente article';
    PageType = Card;
    SourceTable = Item;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
              Field(Inventory;Rec.Inventory){}
              field("Unit Price";Rec."Unit Price"){}
                field(CalcVAT; round(Rec."Unit Price" * (1 + VAT_Rate / 100))) { Editable = false; }
                field("Sur Cmde Vente"; Rec."Qty. on Sales Order") { }
                field("Sur Cmde Achat"; Rec."Qty. on Purch. Order") { }
                Field("Sur facture Vente"; rec."Qty on invoice")
                {

                }
                
            }
            Grid(HIST)
            {

                part(Historique; HistVenteArticleSubform)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    SubPageLink = "Item No" = field("No.");
                    UpdatePropagation = Both;

                }
                part(Disponibilité; LocationPart)
                {
                    ApplicationArea = basic, suite;
                    editable = false;
                }

            }
            group("Liste des prix")
            {
                Part(Prices; PriceListSubform)
                {
                    SubPageLink = "Product No." = field("no.");
                    // SubPageView = where("Price Includes VAT" = const(false));
                }
            }
            /*      Grid(LocationPart)
                  {
                      part(Disponibilité; LocationPart)
                      {
                          ApplicationArea = basic, suite;
                          editable = false;




                      }
                  }
                  /*Grid (Prices)
                  {
                      Part(Prices) 
                      {
                      }
                  } */
        }
    }
    trigger OnOpenPage()

    begin
        CurrPage."Disponibilité".Page.SetItem(Rec);
        CurrPage.Historique.Page.SetCustomer(Customer);
        CurrPage.Historique.Page.Setitem(rec);




    end;


    Procedure SetCustomer(Cust: Record Customer)
    begin

        Customer := Cust ; 
     end;

    Procedure Setitem(Item0: record Item; VAT_Rate0: Decimal)
    begin
        item := item0;
        VAT_Rate := VAT_Rate0;
    end;

    var
        Customer: Record Customer;
        item: record item;
        VAT_Rate: Decimal;

}
