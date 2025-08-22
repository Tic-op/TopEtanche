namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Customer;

pageextension 50019 CustomerPostingGroupList extends "Customer Posting Groups"
{
    layout
    {

        addafter(Description)
        {

            field(Suspension; Rec.Suspension) { ApplicationArea = all; }
        }
    }
}
