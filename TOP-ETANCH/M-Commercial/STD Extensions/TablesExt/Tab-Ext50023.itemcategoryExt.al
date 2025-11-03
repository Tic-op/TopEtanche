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
        }
        field(50001; Level; Option)
        {
            Caption = 'Niveau catégorie';
            OptionMembers = "",Famille,Catégorie,Produit,"Type";
            trigger OnValidate()
            begin
                if level <> Level::Type then begin
                    "Fiche matériaux" := '';
                    Modify();
                end

            end;
        }
        field(50002; "Fiche matériaux"; Code[50])
        {
            TableRelation = if (Level = const("Type")) "Fiche matériaux".Code;

        }



    }

    keys
    {

        key(DefaultDepot; "Default Depot") { }
    }

    procedure applyattributMatériaux()
    Var
        ItemAttribut: Record "Item Attribute";
        itemarrtibuteValue: record "Item Attribute Value";
        ItemattributeMapping: record "Item Attribute Value Mapping";

    begin


    end;


}
