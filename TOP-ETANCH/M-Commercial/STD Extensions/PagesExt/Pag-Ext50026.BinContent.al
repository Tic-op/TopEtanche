namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.Structure;

pageextension 50026 BinContent extends "Bin Contents"
{
    Editable = false;
    DeleteAllowed = false;
    layout
    {
        addafter("Barre Code")
        {
            field("Disponibilité"; Rec."Disponibilité")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
    }
}
