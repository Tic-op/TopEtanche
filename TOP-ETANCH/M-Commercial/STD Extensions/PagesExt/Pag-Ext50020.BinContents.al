namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.Structure;

pageextension 50020 BinContents extends "Bin Contents"
{
    layout
    {

        addafter("Bin Code")
        {

            field("Barre Code"; Rec."Barre Code")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
    }
}
