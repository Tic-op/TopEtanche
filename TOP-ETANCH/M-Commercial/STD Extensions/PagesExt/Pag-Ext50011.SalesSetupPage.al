namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Setup;
using Top.Top;

pageextension 50011 SalesSetupPage extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Bon de prepation No"; Rec."Bon de prepation No")
            {
                ApplicationArea = all;
            }
        }
        addlast("Background Posting")
        {

            field("Utiliser Pré-BL"; Rec."Utiliser Pré-BL")
            {
                ApplicationArea = all;

            }
            field("Utiliser Pré-Facture"; Rec."Utiliser Pré-Facture")
            {
                ApplicationArea = all;
            }
            field("Client Divers"; Rec."Client Divers")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Payment Methods")
        {
            group("Ticop Actions")
            {
                Caption = 'Ticop Actions';
                action(UpdateILEJob)
                {
                    Caption = 'Update ILE Job';
                    ApplicationArea = All;
                    Image = RefreshVoucher;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        UpdateILEJobCodeunit: Codeunit "ILE UPDATE JOB ";
                    begin
                        if Confirm('Voulez-vous mettre à jour toutes les entrées de journal de stock des articles ?', false) then begin
                            UpdateILEJobCodeunit.UpdateILE_Info(true);
                            Message('Item Ledger Entries updated successfully.');
                        end;
                    end;
                }
            }
        }
    }
}
