namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Transfer;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Top.Top;

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
                    /*  SalesLine: Record "Sales Line";
                     OrdrePrep: Record "Ordre de preparation";
                     CuSeries: Codeunit "No. Series";
                     SalesSetup: Record "Sales & Receivables Setup";
                     OrdrePrepPage: Page "Liste bon de préparation";
                     LocationCode: Code[20];
                     verif: Codeunit VerificationStock;
                     location: Record Location; */
                    PrépEvent: Codeunit "PréparationEvent";
                    OrdrePrep: record "Ordre de preparation";


                begin
                    "PrépEvent"."GénérerOrdredePréparation"(OrdrePrep."document type"::Transfert, rec."No.");

                    /*   OrdrePrep.SetRange("Order No", Rec."No.");
                      if OrdrePrep.FindFirst() then
                          Error('Un bon de préparation existe déjà pour cette commande');



                      OrdrePrep.SetRange("Order No", Rec."No.");
                      OrdrePrep.SetFilter(Statut, '<>%1', OrdrePrep.Statut::"Créé");
                      if OrdrePrep.FindFirst() then
                          Error('La commande %1 est en cours de préparation.', OrdrePrep."Order No");

                      SalesLine.SetCurrentKey("Document Type", "Document No.");
                      SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
                      SalesLine.SetRange("Document No.", Rec."No.");
                      if SalesLine.FindFirst() then
                          repeat
                              if SalesLine."Location Code" = '' then
                                  Error('Il faut avoir un magasin dans les lignes de commande', SalesLine."No.")

                          until SalesLine.Next() = 0;

                      SalesLine.Reset();
                      SalesLine.SetCurrentKey("Document Type", "Document No.");
                      SalesLine.SetRange("Document Type", SalesLine."Document Type"::invoice);
                      SalesLine.SetRange("Document No.", Rec."No.");

                      if SalesLine.FindFirst() then
                          repeat
                              LocationCode := SalesLine."Location Code";
                              OrdrePrep.Reset();
                              OrdrePrep.SetRange("Order No", Rec."No.");
                              OrdrePrep.SetRange("Magasin", LocationCode);
                              if not OrdrePrep.FindFirst() then begin
                                  OrdrePrep.Init();
                                  OrdrePrep."Order No" := Rec."No.";
                                  OrdrePrep."Magasin" := LocationCode;
                                  OrdrePrep."Creation date" := CurrentDateTime;
                                  OrdrePrep.Statut := OrdrePrep.Statut::"Créé";
                                  OrdrePrep."document type" := OrdrePrep."document type"::Facture;
                                  SalesSetup.Get();
                                  OrdrePrep.Insert(true);
                              end;
                          until SalesLine.Next() = 0;
                      Message('Un bon de préparation a été créé avec succés'); */
                    /*   OrdrePrep.Reset();
                      OrdrePrep.SetRange("Order No", Rec."No.");
                      OrdrePrepPage.SetTableView(OrdrePrep);
                      OrdrePrepPage.Run(); */
                end;
            }

        }

    }


}

