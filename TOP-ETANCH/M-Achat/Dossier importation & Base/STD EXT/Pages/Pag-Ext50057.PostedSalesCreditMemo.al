namespace PHARMATEC.PHARMATEC;

using Microsoft.Sales.History;

pageextension 50157 "Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {

    }
    actions
    {
        addafter(Print)
        {
            /*  action("Imprimer avoir Financier")
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
                     SH: Record "Sales Cr.Memo Header";

                 begin


                     sh.SetRange("No.", Rec."No.");
                     report.RunModal(50035, true, true, sh);

                 end;
             } */
        }
    }
}
