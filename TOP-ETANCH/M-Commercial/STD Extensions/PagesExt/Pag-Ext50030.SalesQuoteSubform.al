namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;

pageextension 50030 SalesQuoteSubform extends "Sales Quote Subform"
{
    layout
    { 
         modify("No.")
        {
            trigger OnDrillDown()
            var
                item: record Item;

            begin
                item.SetLoadFields("No.");
                if item.get(rec."No.") then
                    item.GetLastSales(Rec."Sell-to Customer No.", rec."Sell-to Customer No.", rec."VAT %");
            end;


        }
        
        
        addafter("Location Code"){


        field("Bin Code";Rec."Bin Code"){
               visible = true;
               ApplicationArea = all ;
            trigger OnValidate()
            begin
                //ControlDisponibilité();
                if (rec."Bin Code" = '') then error('Emplacement obligatoire dans ce magasin');

            end;

        }
    }
        addbefore(Quantity)
        {     field("DisponibilitéGlobal"; rec.GetDisponibilite(true))
            {
                Caption = 'Disponibilité Globale';
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;
            }
            field(Stock; item.CalcStock(Rec."No.", Rec."Location Code", Rec."Bin Code"))
            {
                Caption = 'Stock sur Mag';
                DecimalPlaces = 0 : 0;
                Editable = false;
                Style = Strong;
                ApplicationArea = all;

            }
            field("Disponibilité"; rec.GetDisponibilite(false))
            {
                Caption = 'Disponibilité sur Mag';
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;
                  Enabled = rec."Location Code" <> '';

            }
        }
    }
    var
        item: Record Item;
}
