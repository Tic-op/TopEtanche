pageextension 50066 purchaseArchive extends "Purchase Order Archive"
{
    layout
    {
        addlast(General)
        {
            field("DI No."; Rec."DI No.")
            {
                ApplicationArea = all;
                Importance = Promoted;



            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}