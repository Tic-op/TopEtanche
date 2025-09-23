namespace Top.Top;

using Microsoft.Sales.Document;

pageextension 50031 "Sales Quote List" extends "Sales Quotes"
{
    actions //IS12092025
    {

        modify(MakeInvoice)
        {   
            trigger OnAfterAction()
            var
                SE: Codeunit SalesEvents;
            begin
                SE.ArchiveDevis(rec."No.");
            end;
        }
        modify(MakeOrder)
        {       Caption= 'générer expédition vente';
            trigger OnAfterAction()
            var
                SE: Codeunit SalesEvents;
            begin
                SE.ArchiveDevis(rec."No.");
            end;
        }

        addlast(Processing)
        {

            action(CreateBlanketOrder)
            {
                ApplicationArea = All;
                Caption = 'Créer commande cadre vente ';
                Image = CreateWhseLoc;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CVCMAKER: Codeunit SalesBlanketOrderFromQuote;
                begin
                    if not Confirm('Voulez-vous créer une commande vente cadre?') then
                        exit;
                    CVCMAKER.StartCreationBlanOrder(Rec."No.");
                    //Get & Open the Sales B.O

                end;
            }
        }
    }
}

