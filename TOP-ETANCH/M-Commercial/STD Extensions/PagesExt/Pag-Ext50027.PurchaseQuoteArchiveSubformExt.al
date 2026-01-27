namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Archive;

pageextension 50027 PurchaseQuoteArchiveSubformExt extends "Purchase Quote Archive Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Confirmé par fournisseur"; Rec."Confirmé par fournisseur")
            {
                ApplicationArea = all;
            }
        }
    }
}
