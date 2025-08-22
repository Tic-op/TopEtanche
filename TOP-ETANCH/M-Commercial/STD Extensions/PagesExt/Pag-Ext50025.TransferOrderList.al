namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Transfer;

pageextension 50025 TransferOrderList extends "Transfer Orders"
{
    Layout
    {
        addafter("Transfer-to Code")
        {
            field("Num récéption"; Rec."Num récéption")
            {

                ApplicationArea = all;
                Editable = false;
            }


        }



    }
}
