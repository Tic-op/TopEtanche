namespace Top.Top;

using Microsoft.Inventory.Item;

pageextension 50048 "Item lookup" extends "Item Lookup"
{

      Layout {
addafter("Vendor No.")
{
    field("Vendor Name";Rec."Vendor Name"){
        visible = true ; ApplicationArea= all ;

    }
    
}       
addafter(InventoryCtrl)
{
    field(Disponibilité;rec."CalcDisponibilitéWithResetFilters"('','')){
        visible=true;
        ApplicationArea=all;
        DecimalPlaces = 0:3 ;
    }  
}
}}
