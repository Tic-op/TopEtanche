namespace Top.Top;

using Microsoft.Sales.Document;

pageextension 50031 "Sales Quote List" extends "Sales Quotes"
{
    actions //IS12092025
    {

        modify(MakeInvoice)
        {
            enabled = rec."Type de facturation" = rec."Type de facturation"::"Contre remboursement";
            trigger OnAfterAction()
            var
                SE: Codeunit SalesEvents;
            begin
                SE.ArchiveDevis(rec."No.");
            end;
        }
        modify(MakeOrder)
        {
            Caption = 'générer expédition vente'; // AM à faire
            enabled = rec."Type de facturation" <> rec."Type de facturation"::"Contre remboursement";
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
                Enabled = QuoteActionsEnabled and (rec."Type de facturation" <> rec."Type de facturation"::"Contre remboursement");
                trigger OnAction()
                var
                    CVCMAKER: Codeunit SalesBlanketOrderFromQuote;
                    BlanketorderNo: code[20];
                    SH: record "Sales Header";
                    BlanketPage: page "Blanket Sales Order";
                begin
                    if not Confirm('Voulez-vous créer une commande vente cadre?') then
                        exit;
                    BlanketorderNo := CVCMAKER.StartCreationSalesBlanOrder(Rec."No.");
                    if SH.get("Sales Document Type"::"Blanket Order", BlanketorderNo) then
                        if Confirm('Voulez vous ouvrir la commande cadre crée ?', true) then begin
                            BlanketPage.SetRecord(SH);
                            BlanketPage.Run();

                        end;
                    //Get & Open the Sales B.O

                end;
            }
        }
    }
}

