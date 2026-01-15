namespace TopEtanch.TopEtanch;


using Microsoft.Purchases.Vendor;

pageextension 50078 vendor extends "Vendor Card"
{
    layout
    {


        addafter(Blocked)
        {

            field("Stamp"; Rec.Stamp)
            {
                ApplicationArea = all;
                Caption = 'Timbre Fiscal';
            }
            field("Equipement"; Rec.Equipement)
            {
                ApplicationArea = all;
                Caption = 'Equipement';
            }
        }
    }
}
