namespace Top.Top;

using Microsoft.Inventory.Journal;

pageextension 50087 "Reval Journal Action Ext" extends "Revaluation Journal"
{
    actions
    {
        addlast(Processing)
        {
            action(InitInventoryRevaluation)
            {
                Caption = 'Initialiser réévaluation inventaire';
                Image = Calculate;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Génère les lignes de réévaluation à partir de l''inventaire importé au 01/01/2026.';

                trigger OnAction()
                var
                    RevalCU: Codeunit "Init Revaluation Inventory";
                    IJL: Record "Item Journal Line";

                begin

                    Error('Développement en cours');
                    // Lancement du traitement
                    RevalCU.Run(DMY2Date(1, 1, 2026));

                    Message(
                      'Initialisation terminée avec succès.\' +
                      'Veuillez contrôler les lignes avant comptabilisation.');
                end;
            }
        }
    }
}

