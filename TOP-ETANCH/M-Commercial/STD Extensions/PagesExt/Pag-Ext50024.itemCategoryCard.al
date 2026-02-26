namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Attribute;

pageextension 50024 itemCategoryCard extends "Item Category Card"
{


    layout
    {


        addafter(Description)
        {
            field(Level; Rec.Level)
            {
                ApplicationArea = all;
                enabled = rec.Parent = '';
            }

            field("Default Depot"; Rec."Default Depot")
            {

                ApplicationArea = all;
                Enabled = (rec.Level = rec.Level::Type);
            }

            field(Parent; Rec.Parent)
            {
                ApplicationArea = all;
                Enabled = ((rec.level <> rec.level::Famille) and (Rec.level <> 0));
            }
        }
        modify("Parent Category")
        {
            Visible = false;

        }
    }
    Actions
    {

        addlast(processing)
        {
            action(supprimer)
            {
                ApplicationArea = all;
                Caption = 'supprimer mapping';
                visible = false;
                trigger onaction()
                var
                    iavmap: Record "Item Attribute Value Mapping";
                begin
                    iavmap.DeleteAll(false);
                end;

            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin

        rec.Parent := rec."Parent Category";
    end;
}
