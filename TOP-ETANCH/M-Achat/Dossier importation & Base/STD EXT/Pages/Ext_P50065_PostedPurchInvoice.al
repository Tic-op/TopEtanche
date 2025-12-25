pageextension 50165 purchaseinvoice extends "Posted Purchase Invoice"
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
        addbefore("Update Document")
        {
            action("Mettre à jour le document")
            {
                RunObject = page 50068;
                ApplicationArea = all;
                RunPageLink = "No." = field("No.");
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;

            }
        }
        modify("Update Document")
        { Visible = false; }
    }


    var
        myInt: Integer;
}