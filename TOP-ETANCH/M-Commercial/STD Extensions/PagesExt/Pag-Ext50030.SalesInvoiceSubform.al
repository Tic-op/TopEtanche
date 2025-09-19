/* namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;

pageextension 50030 "Sales Invoice Subform" extends "Sales Invoice Subform"
{

    layout
    {

        addbefore(Quantity)
        {
            field(Stock; item.CalcStock(Rec."No.", Rec."Location Code", Rec."Bin Code"))
            {
                DecimalPlaces = 0 : 0;
                Editable = false;
                Style = Strong;
                ApplicationArea = all;



            }
            field(Disponibilité; item.CalcDisponibilité(Rec."Location Code", Rec."Bin Code"))
            {
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;


            }
        }
    }
    var
        item: Record Item;
}
 */