namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Attribute;
using Microsoft.Inventory.Location;

tableextension 50023 itemcategoryExt extends "Item Category"
{
    fields
    {
        field(50000; "Default Depot"; Text[25])
        {
            Caption = 'Dépot de récéption par défaut';
            DataClassification = ToBeClassified;
            TableRelation = Location where(type = filter('Dépot'));
            Trigger OnValidate()
            var
                IC: record "Item Category";
            begin
                IC.SetRange("Parent Category", Code);
                if IC.Findset() then
                    IC.ModifyAll("Default Depot", "Default Depot");
            end;
        }
        field(50001; Level; Option)
        {
            Caption = 'Niveau catégorie';
            OptionMembers = "",Famille,Catégorie,Produit,"Type",Matériau;
            trigger OnValidate()
            begin

            end;


        }

        field(50002; Parent; Code[20])
        {
            TableRelation = if (Level = const(Catégorie)) "Item Category".code where(Level = const(famille))
            else if (Level = const(Produit)) "Item Category".code where(Level = const(catégorie))
            else if (Level = const("type")) "Item Category".code where(Level = const(Produit))
            else if (Level = const(Matériau)) "Item Category".code where(Level = const("type"));


            trigger OnValidate()
            begin


                Validate("Parent Category", Parent);


            end;

        }
        modify("Parent Category")
        {
            trigger OnAfterValidate()
            var
            begin
                Parent := "Parent Category";
                Modify();
            end;
        }



    }

    keys
    {

        key(DefaultDepot; "Default Depot") { }
    }




}
