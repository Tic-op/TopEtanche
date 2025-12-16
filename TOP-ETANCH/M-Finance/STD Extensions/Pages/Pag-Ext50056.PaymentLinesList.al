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
    }
    trigger OnOpenPage()
    begin
        rec.SetRange("Copied To No.", '');
    end;
}
