

namespace SalesManagement.SalesManagement;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Account;

pageextension 50135 "GL_Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Local Currency")
        {

            group(TICOP)
            {
                field("compte timbre fiscal"; rec."compte timbre fiscal")
                {
                    ApplicationArea = all;
                    Caption = 'Compte timbre fiscal';
                }
                field("Montant timbre fiscal"; rec."Montant timbre fiscal")
                {
                    ApplicationArea = all;
                    Caption = 'Montant timbre fiscal';
                }

                field("Compte Fin. dev."; Rec."Compte Fin. dev.")
                {
                    ApplicationArea = all;
                    Caption = 'Compte Fin. dev.';
                }

                field("Compte Commission Bancaire"; Rec."Compte Commission Bancaire")
                {
                    ApplicationArea = all;

                }
                field("Compte TVA /Commission"; Rec."Compte TVA /Commission")
                {
                    ApplicationArea = all;

                }
                field("Compte Interrêt bancaire"; Rec."Compte Interrêt bancaire")
                {
                    ApplicationArea = all;

                }
                field("Frais timbre/Achat"; Rec."Frais timbre/Achat")
                {
                    ApplicationArea = all;
                }
                field("compte timbre/Achat"; Rec."Compte timbre/Achat")
                {
                    ApplicationArea = all;
                }
                field("TVA RS Publique"; rec."TVA RS Publique")
                {
                    ApplicationArea = all;

                }
                field("Compte TVA RS Publique"; rec."Compte TVA RS Publique")
                {
                    ApplicationArea = all;
                }
                field("Gains écr. apurement"; Rec."Gains écr. apurement")
                {
                    ApplicationArea = all;

                }
                field("Pertes écr. apurement"; Rec."Pertes écr. apurement")
                {
                    ApplicationArea = all;

                }
            }
        }
    }
}