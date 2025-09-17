namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;

page 50026 "Détail vente article"
{
    ApplicationArea = All;
    Caption = 'Détail vente article';
    PageType = Card;
    SourceTable = Item;
    
    layout
    {
        area(Content)
        {
            Grid(General)
            {
                Caption = 'General';
              Field(Inventory;Rec.Inventory){}
              field("Unit Price";Rec."Unit Price"){}
              field(CalcVAT; Rec."Unit Price" * SalesL."VAT %" ) {}
              field("Qty. on Sales Order";Rec."Qty. on Sales Order") {}
              field("Qty. on Purch. Order";Rec."Qty. on Purch. Order"){}
                
            }
           /*  Grid (HIST) {

               part (HistArticleClient , HistArticleClient )
               {


               }
                

            }
            Grid(LocationPart)
            {
                part()
            }
            Grid (Prices)
            {
                Part(Prices) 
                {
                }
            } */
        }
    } 
     Procedure SetSalesLine(SL : Record "Sales Line") begin 

        SalesL := SL ; 
     end;
      Procedure SetCustomer(Cust : Record Customer) begin 

        Customer := Cust ; 
     end;

    var  Customer : Record Customer ; 
         SalesL : Record "Sales Line" ;
}
