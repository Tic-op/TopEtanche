namespace Top.Top;

using Microsoft.Sales.Pricing;
using Microsoft.Pricing.PriceList;

pageextension 50041 "Price list" extends "Sales Price Lists"
{
    actions{

        addfirst(Processing)
        {
            action(delete_all) {
                ApplicationArea = all ;
               
                trigger OnAction() var 
                
                Pricelistheader : record "Price List Header" ;
                 begin 
             Pricelistheader.DeleteAll(true);

                end;
            }
        }
    }
}
