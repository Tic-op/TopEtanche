namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Setup;

pageextension 50011 SalesSetupPage extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Bon de prepation No"; Rec."Bon de prepation No")
            {
                ApplicationArea = all;
            }
        }
        addlast("Background Posting")
        {

            field("Utiliser Pré-BL"; Rec."Utiliser Pré-BL")
            {
                ApplicationArea = all;

            }
            field("Utiliser Pré-Facture"; Rec."Utiliser Pré-Facture")
            {
                ApplicationArea = all;
            }
            field("Client Divers"; Rec."Client Divers")
            {
                ApplicationArea = all;
            }
        }
    }

}
