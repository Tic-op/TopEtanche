namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Location;
using PHARMATECCLOUD.PHARMATECCLOUD;

pageextension 50006 Location extends "Location Card"
{
    layout
    {

        addlast(General)
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = all;
                caption = 'Type magasin';
            }
            /* field(tampon; Rec.tampon)
            {
                ApplicationArea = all;
            }  */
            field("Qty Minimum"; Rec."Qty Minimum")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;

            }
            field("Dépot associé"; Rec."Dépot associé")
            {
                Enabled = rec.Type = rec.type::"Point de vente";
                ApplicationArea = all;

            }
        }
    }
}