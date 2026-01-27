
namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Tracking;

pageextension 50040 "Item Tracking Summary" extends "Item Tracking Summary"
{
    layout
    {
        moveafter("Lot No."; "Expiration Date")
        modify("Expiration Date")
        {
            Visible = true;
        }
        addafter("Total Quantity")
        {
            field("Demandée dans l'emplacement"; Rec."Demandée dans l'emplacement")
            {
                ApplicationArea = all;
                Visible = BinContentVisible;
                DecimalPlaces = 0 : 5;
            }

            field("Qté Restante par emplacement"; rec."Qté Restante par emplacement")
            {
                ApplicationArea = all;
                Visible = BinContentVisible;
                DecimalPlaces = 0 : 5;

            }
        }



    }
}