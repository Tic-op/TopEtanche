namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;

tableextension 50023 itemcategoryExt extends "Item Category"
{
    fields
    {
        field(50000; "Default Depot"; Text[25])
        {
            Caption = 'Default Depot';
            DataClassification = ToBeClassified;
            TableRelation = Location where(type = filter('Dépot'));
        }



    }

    keys
    {

        key(DefaultDepot; "Default Depot") { }
    }




}
