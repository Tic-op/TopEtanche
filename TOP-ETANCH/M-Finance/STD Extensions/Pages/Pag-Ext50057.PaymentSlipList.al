namespace Top.Top;

using Microsoft.Bank.Payment;

pageextension 50057 "Payment Slip List" extends "Payment Slip List"
{
    layout
    {
        addafter("Status Name")
        {
            field(Amount; Rec.Amount)
            {
                ApplicationArea = all;
            }

            field("Lignes disponibles"; Rec."Lignes disponibles")
            {
                Style = Favorable;
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        addafter("Create Payment Slip")
        {
            action("Paiement en cours")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = true;
                PromotedCategory = Process;
                Image = CostEntries;
                ApplicationArea = all;
                RunObject = page "Payment Lines List";
            }

            action("Etat Caisse")
            {
                Image = CashReceiptJournal;
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = All;

                trigger OnAction()
                var
                    cais: Report "Caisse journalière";
                begin
                    cais.Run();
                end;
            }
        }


    }

}
