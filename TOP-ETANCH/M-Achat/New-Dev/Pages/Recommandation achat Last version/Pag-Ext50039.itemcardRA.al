namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;

pageextension 50039 "item card RA" extends "Item Card"
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Item No"; Rec."Vendor Item No.")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("reference origine"; Rec."reference origine")
            {
                ApplicationArea = all;
            }
        }
        addafter(Inventory)
        {
            field("Couverture demandée"; rec."Couverture demandée") { ApplicationArea = all; }
            field("Mode de calcul VMJ"; rec."Mode de calcul VMJ") { ApplicationArea = all; }
        }
    }
}
