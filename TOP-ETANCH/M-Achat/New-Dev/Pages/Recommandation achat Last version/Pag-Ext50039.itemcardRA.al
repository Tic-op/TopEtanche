namespace BSPCloud.BSPCloud;

using Microsoft.Inventory.Item;

pageextension 50039 "item card RA" extends "Item Card"
{
    layout
    {
        addafter(Inventory)
        {
            field("Couverture demandée"; rec."Couverture demandée") { ApplicationArea = all; }
            field("Mode de calcul VMJ"; rec."Mode de calcul VMJ") { ApplicationArea = all; }
        }
    }
}
