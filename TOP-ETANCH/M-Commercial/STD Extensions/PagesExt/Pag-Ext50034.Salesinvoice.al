namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Setup;
using Microsoft.Inventory.Location;
using PHARMATEC.PHARMATEC;
using TopEtanch.TopEtanch;

pageextension 50034 Salesinvoice extends "Sales Invoice"
{ InsertAllowed = false ;

layout {

  addafter("Shipping and Billing")
        {
            group(Autre)
            {

                field("Payment Terms Code "; Rec."Payment Terms Code") { ApplicationArea = all; }
                field("Payment Method Code "; Rec."Payment Method Code") { ApplicationArea = all; }
                field("Type de facturation"; rec."Type de facturation")
                {
                    Visible = rec."Blanket Order No." = '';
                    Caption = 'Type de facturation';
                    ApplicationArea = all;
                    Importance = Promoted;
                    Enabled = rec."Blanket Order No." = '';
                }
                field("Mode de livraison"; Rec."Mode de livraison")
                {
                    // Visible = false;
                    //  Caption = 'Type de facturation';
                    ApplicationArea = all;
                    Importance = Promoted;
                    // Enabled = false;

                }
                field("Bon de preparations"; Rec."Bon de preparations")
                {
                    Caption = 'Bon de preparations';
                    ApplicationArea = all;

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
} } }
 actions
    {  addafter("Test Report")
      
        {
 action("Bon de préparation")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = ItemGroup ;

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
                    "PrépEvent"."GénérerOrdredePréparation"(OrdrePrep."document type"::Facture, rec."No.");

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
             action(imprimer_ticket) { 
                 Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = PrintVoucher ;

                Caption = 'Imprimer Tickets'; 
                trigger OnAction() 
                var 
                SalesInvoiceH : record "Sales Header" ;

                
                begin
                    /* SalesInvoiceH.get(rec."Document Type",rec."No.");
                    report.runmodal(50028, true, true, SalesInvoiceH); */



                end;




            }

        

}   

   
}}
