namespace Top.Top;

using Microsoft.Bank.BankAccount;

pageextension 50052 "Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addafter("Bank Acc. Posting Group")
        {
            field(Journal; Rec.Journal)
            {
                ApplicationArea = all;
            }
        }
        addafter(Communication)
        {
            group(Commision)
            {
                field("Com Remises Chèques"; Rec."Com Remises Chèques")
                {
                    ApplicationArea = All;
                    Caption = 'Commission Remises Chèques';
                }
                field("Com Remises Effets"; Rec."Com Remises Effets")
                {
                    ApplicationArea = All;
                    Caption = 'Commission Remises Effets';
                }
                field("Com Esc Effets"; Rec."Com Esc Effets")
                {
                    ApplicationArea = All;
                    Caption = 'Commission Esc Effets';
                }
                field("Com Chèques Impayés"; Rec."Com Chèques Impayés")
                {
                    ApplicationArea = All;
                    Caption = 'Commission Chèques Impayés';
                }
                field("Com Effets Impayés"; Rec."Com Effets Impayés")
                {
                    ApplicationArea = All;
                    Caption = 'Commission Effets Impayés';
                }
                field("Plafond Escompte comm."; Rec."Plafond Escompte comm.")
                {
                    ApplicationArea = All;
                    Caption = 'Plafond Escompte Commissions';
                }
            }

        }
    }
}
