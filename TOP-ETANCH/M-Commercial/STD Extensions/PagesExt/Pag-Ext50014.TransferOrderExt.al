namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Transfer;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;

pageextension 50014 TransferOrderExt extends "Transfer Order"
{
    layout
    {

        addafter(Status)
        {

            field("N° Commande"; Rec."Source No.")
            {
                ApplicationArea = all;
                Visible = true;
            }
            field("Bon de preparation"; Rec."Bon de preparation")
            {
                ApplicationArea = all;
                Visible = true;
                trigger OnDrillDown()
                var
                    ListBonPre: Page "Liste bon de préparation";
                    OrderPre: record "Ordre de preparation";
                begin
                    OrderPre.setrange("Order No", rec."No.");
                    ListBonPre.SetTableView(OrderPre);
                    ListBonPre.Run();
                end;
            }

        }
    }
    actions
    {
        addafter(Post)
        {
            action(TransferStockMinAction)
            {
                Caption = 'Demande d''alimentation de stock';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ExtracReport: Report 50003;
                begin
                    ExtracReport.SetTransferNo(rec."No.");
                    ExtracReport.Run();

                end;

            }
            action("Générer bon de préparation")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                Caption = 'Générer bon de préparation';

                trigger OnAction()
                var
                    OrdrePrep: Record "Ordre de preparation";
                begin

                    OrdrePrep.SetRange(OrdrePrep."Order No", Rec."No.");
                    if OrdrePrep.FindFirst() then
                        Error('Un ordre de préparation existe déjà ');


                    OrdrePrep.Init();
                    OrdrePrep."Order No" := Rec."No.";
                    OrdrePrep."Magasin" := Rec."Transfer-from Code";
                    OrdrePrep."Creation date" := CurrentDateTime;
                    OrdrePrep.Statut := OrdrePrep.Statut::"Créé";
                    OrdrePrep."document type" := OrdrePrep."document type"::Transfert;

                    OrdrePrep.Insert(true);

                    Message('Ordre de préparation créé');
                end;
            }

        }

    }


}

