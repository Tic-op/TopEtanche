namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;

pageextension 50024 itemCategoryCard extends "Item Category Card"
{


    layout
    {


        addafter(Description)
        {

            field("Default Depot"; Rec."Default Depot") { ApplicationArea = all; }
        }
    }
}
