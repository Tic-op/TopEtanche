pageextension 50069 purchaseSetupExt extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Import folder No"; Rec."Import folder No")
            {
                ApplicationArea = all;
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