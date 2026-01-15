
namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.History;

pageextension 50160 "Posted Purchase Credit Memo" extends "Posted Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("DI No."; Rec."DI No.")
            {
                ApplicationArea = all;
                Importance = Promoted;



            }
        }

    }
    actions
    {
        /*  addafter("&Print")
         {
             action("Imprimer avoir Financier")
             {
                 ApplicationArea = All;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 Visible = true;
                 Image = PrintReport;
                 trigger OnAction()
                 var
                     AF: Report AvoirFinancier;
                     PH: Record "Purch. Cr. Memo Hdr.";

                 begin


                     PH.SetRange("No.", Rec."No.");
                     report.RunModal(50035, true, true, PH);

                 end;
             }
         } */
    }
}
