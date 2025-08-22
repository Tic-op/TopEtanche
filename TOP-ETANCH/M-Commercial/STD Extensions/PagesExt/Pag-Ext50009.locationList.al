namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Location;

pageextension 50009 "location List" extends "Location List"
{
    layout
    {

        addafter(Name)
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = all;

            }

        }
    }
}
