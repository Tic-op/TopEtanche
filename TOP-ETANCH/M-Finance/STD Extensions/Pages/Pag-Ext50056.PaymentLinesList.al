namespace Top.Top;

using Microsoft.Bank.Payment;

pageextension 50056 "Payment Lines List" extends "Payment Lines List"
{
    layout
    {




        addafter(Amount)
        {

            field(Risque; Rec.Risque)
            {
                ApplicationArea = All;

            }
            field("Engagement financier"; Rec."Engagement financier")
            {
                ApplicationArea = All;

            }
            field("Copied To No."; Rec."Copied To No.")
            {
                ApplicationArea = All;

            }
            field("Banque Entête"; Rec."Banque Entête")
            {
                ApplicationArea = all;

            }

        }
        addafter("Account Type")
        {
            field(Designation; Rec.Designation) { ApplicationArea = all; }

        }
        addafter("Drawee Reference")
        {
            field("External Document No."; Rec."External Document No.")
            {
                Caption = 'N° document externe';
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetRange("Copied To No.", '');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('Opération interdite');
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        NbrSelect: Integer;
        ConfirmMessage: Text;
        montant: Decimal;

    begin
        if CloseAction = ACTION::LookupOK then begin

            CurrPage.SetSelectionFilter(xrec);

            xrec.MarkedOnly(true);

            if Rec.FindFirst() then
                repeat
                    NbrSelect += 1;
                    montant += Rec.Amount;
                until Rec.Next() = 0;

            if Confirm('Vous avez sélectionné %1 lignes avec un montant de %2. Voulez-vous continuer ?', true, NbrSelect, montant) then
                exit(true)
            else
                exit(false);

        end;

    end;

}
