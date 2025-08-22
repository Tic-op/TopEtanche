namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;

pageextension 50023 ItemCategory extends "Item Categories"
{
    layout
    {


        addafter(Description)
        {

            field("Default Depot"; Rec."Default Depot") { ApplicationArea = all; }
        }
    }
}
