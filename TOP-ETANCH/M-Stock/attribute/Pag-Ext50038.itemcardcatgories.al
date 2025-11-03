namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Attribute;

pageextension 50038 "item card catégories" extends "Item Card"
{
    layout { 
        addbefore("Item Category Code"){

            field("Famille Category";Rec."Famille Category"){
                ApplicationArea = all ;
            }
            field("Catégorie Category";Rec."Catégorie Category")
            {
                ApplicationArea = all ;

            }
            field("Produit Category";Rec."Produit Category")
            {
                ApplicationArea = all ;
            }
            field("Type category";Rec."Type category")
            {
                ApplicationArea = all ;
            }
            


        }

          modify("Item Category Code")
        {
            visible=false ;
        }
    }
   
}
