namespace TOPETANCH.TOPETANCH;

using Microsoft.Inventory.Setup;

pageextension 50002 ParamStockExt extends "Inventory Setup"
{
    layout
    {
        addafter("Item Nos.")
        {
            field("N° inventaire"; Rec."Inventory No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
