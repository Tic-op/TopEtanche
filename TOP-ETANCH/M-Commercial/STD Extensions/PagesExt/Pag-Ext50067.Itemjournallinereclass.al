namespace Top.Top;

using Microsoft.Inventory.Journal;

pageextension 50067 "Item journal line reclass" extends "Item Reclass. Journal"
{
    Layout
    {

        modify("Bin Code")
        {
            Visible = true;
        }
        modify("New Bin Code")
        {
            visible = true;
        }

    }



}
