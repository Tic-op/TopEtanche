namespace Top.Top;

using Microsoft.CRM.Team;

pageextension 50084 "Salesperson/Purchaser Card Ex" extends "Salesperson/Purchaser Card"
{
    layout
    {

        addafter(Name)
        {
            field(Magasin; Rec.Magasin) { ApplicationArea = all; }
        }
    }
}
