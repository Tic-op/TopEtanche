namespace TopEtanch.TopEtanch;


using Microsoft.Purchases.Document;

pageextension 50152 "Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {

    }
    actions
    {
        addafter(Post)
        {/* 
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
                    AFF: Report AvoirFinancierFourniss;
                begin
                    AFF.Run;
                end;
            } */
        }
    }
}
