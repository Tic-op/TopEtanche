namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Customer;

pageextension 50012 CustomerPostingGroup extends "Customer Posting Group Card"
{
    layout
    {

        addafter(Description)
        {
            field(Suspension; Rec.Suspension) { ApplicationArea = all; }
        }

    }
}
