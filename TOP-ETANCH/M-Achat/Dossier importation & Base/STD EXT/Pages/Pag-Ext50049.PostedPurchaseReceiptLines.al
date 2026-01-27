namespace TopEtanch.TopEtanch;


using Microsoft.Purchases.History;

pageextension 50149 "Posted Purchase Receipt Lines" extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
                Visible = true;
            }

        }
    }
}
