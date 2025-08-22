namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;

pageextension 50004 "Purchase Quote Ext" extends "Purchase Quote"
{
    layout
    {

    }
    actions
    {
        addlast(Processing)
        {

            action(CreateBlanketOrder)
            {
                ApplicationArea = All;
                Caption = 'Créer commande cadre achat ';
                Image = CreateWhseLoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CACMAKER: Codeunit "Purch Blanket Order From Quote";
                begin
                    if not Confirm('Voulez-vous créer une commande achat cadre?') then
                        exit;
                    CACMAKER.StartCreationBlanOrder(Rec."No.");
                end;
            }
        }
    }

}
