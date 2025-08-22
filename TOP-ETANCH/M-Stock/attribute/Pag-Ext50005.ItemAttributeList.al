namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item.Attribute;

pageextension 50005 "Item Attribute List" extends "Item Attributes"
{
    layout
    {

        addafter(Values)
        {
            field("Unit of Measure"; Rec."Unit of Measure")
            {
                ApplicationArea = all;

            }

        }
        addafter(Name)
        {
            field("Type Attribut"; Rec."Type Attribut")
            {
                ApplicationArea = all;

            }
        }
    }
}
