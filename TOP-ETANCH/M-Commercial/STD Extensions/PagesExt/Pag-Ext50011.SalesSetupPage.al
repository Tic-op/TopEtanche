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
    }

}
