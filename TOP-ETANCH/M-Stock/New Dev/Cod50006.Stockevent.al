namespace Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Transfer;
using Microsoft.Sales.Posting;

codeunit 50006 PréparationEvent
{ 

    Procedure GénérerOrdredePréparation(DocumentType : option "Commande","Transfert","Facture" ; documentNo : Code [20])  
    var 
    SalesH : record "Sales Header" ;
    SalesLine : Record "Sales Line" ;
    TransferH : record "Transfer Header" ;
    transferLine : record "Transfer Line" ;
    OrdrePrep : record "Ordre de preparation" ;
    Lignepréparation : Record "Ligne préparation" ;
     LocationCode: Code[20];
   

    begin 
       
                 OrdrePrep.setrange("document type",DocumentType);
                  OrdrePrep.SetRange("Order No",documentNo);
                    if OrdrePrep.FindFirst() then
                        Error('Un bon de préparation existe déjà pour %1 Numéro %2',DocumentType ,documentNo);



                    
                   /*  OrdrePrep.SetRange("Order No", Rec."No.");
                    OrdrePrep.SetFilter(Statut, '<>%1', OrdrePrep.Statut::"Créé");
                    if OrdrePrep.FindFirst() then
                        Error('La commande %1 est en cours de préparation.', OrdrePrep."Order No"); */


                        If (DocumentType = DocumentType ::Facture) or (DocumentType = DocumentType::Commande) then begin 




                      

                    SalesLine.SetCurrentKey("Document Type", "Document No.");
                    if DocumentType = DocumentType ::Facture then 
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
                    if DocumentType = DocumentType::Commande then 
                      SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);

                    SalesLine.SetRange("Document No.", documentNo);
                    if SalesLine.FindFirst() then
                        repeat
                            if SalesLine."Location Code" = '' then
                                Error('Il faut avoir un magasin dans les lignes de commande', SalesLine."No.")

                        until SalesLine.Next() = 0;

                    SalesLine.Reset();
                    SalesLine.SetCurrentKey("Document Type", "Document No.");
                   if DocumentType = DocumentType ::Facture then 
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
                    if DocumentType = DocumentType::Commande then 
                      SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.",documentNo);

                    if SalesLine.FindFirst() then
                        repeat
                            LocationCode := SalesLine."Location Code";
                            OrdrePrep.Reset();
                             if DocumentType = DocumentType ::Facture then 
                    OrdrePrep.SetRange("Document Type", DocumentType::Facture);
                    if DocumentType = DocumentType::Commande then 
                       OrdrePrep.SetRange("Document Type", DocumentType::Commande);
                            OrdrePrep.SetRange("Order No",documentNo);
                            OrdrePrep.SetRange("Magasin", LocationCode);
                            if not OrdrePrep.FindFirst() then begin
                                OrdrePrep.Init();
                                OrdrePrep."Order No" := documentNo;
                                OrdrePrep."Magasin" := LocationCode;
                                OrdrePrep."Creation date" := CurrentDateTime;
                                OrdrePrep.Statut := OrdrePrep.Statut::"Créé";
                                OrdrePrep."document type" := DocumentType ;
                              //  OrdrePrep."document type" := OrdrePrep."document type"::Facture;
                                //SalesSetup.Get();
                                OrdrePrep.Insert(true);
                            end;
                        until SalesLine.Next() = 0;
                    Message('Un bon de préparation a été créé avec succés');
                  
                        end ;


                          If (DocumentType = DocumentType ::Transfert) then  begin 

 
                    transferLine.Reset();
                    transferLine.SetCurrentKey("Document No.");
                   
                   
                    transferLine.SetRange("Document No.",documentNo);

                    if transferLine.FindFirst() then
                            LocationCode := transferLine."Transfer-from Code";
                            OrdrePrep.Reset();
                            OrdrePrep.setrange("document type",DocumentType::Transfert);
                            OrdrePrep.SetRange("Order No",documentNo);
                            OrdrePrep.SetRange("Magasin", LocationCode);
                            if not OrdrePrep.FindFirst() then begin
                                OrdrePrep.Init();
                                OrdrePrep."Order No" := documentNo;
                                OrdrePrep."Magasin" := LocationCode;
                                OrdrePrep."Creation date" := CurrentDateTime;
                                OrdrePrep.Statut := OrdrePrep.Statut::"Créé";
                                OrdrePrep."document type" := DocumentType ;
                              //  OrdrePrep."document type" := OrdrePrep."document type"::Facture;
                                //SalesSetup.Get();
                               OrdrePrep.Insert(true)  
                            end;
                    Message('Un bon de préparation a été créé avec succés');
                  


                          end ;
                end;



                Procedure InitialiserLignesPréparation(OrdrePrepNo : Code [20]) : Boolean 
                var OrdrePréparation : record "Ordre de preparation" ;
                 LignePréparation : record "Ligne préparation" ;

                
                 salesL: record "Sales Line" ;
                 TransfertLine : record "Transfer Line" ;
                
                
                begin 

                    "OrdrePréparation".get(OrdrePrepNo);
                    
                    if "OrdrePréparation"."document type" = "OrdrePréparation"."document type"::Transfert then 
                    begin 
                       TransfertLine.setrange("Document No.","OrdrePréparation"."Order No");
                       if TransfertLine.findfirst then repeat
                       LignePréparation.init();
                       "LignePréparation"."Document No." := OrdrePrepNo ;
                       "LignePréparation"."Source type." := "LignePréparation"."Source type."::Transfert ;
                       "LignePréparation"."Source No.":=TransfertLine."Document No.";
                       "LignePréparation"."Source line No." := TransfertLine."Line No.";
                       "LignePréparation".Location := TransfertLine."Transfer-from Code";
                       "LignePréparation"."Bin Code":= TransfertLine."Transfer-from Bin Code";
                       "LignePréparation"."item No.":=TransfertLine."Item No.";
                       "LignePréparation".description:=TransfertLine.Description;
                       "LignePréparation".Qty:=TransfertLine."Quantity (Base)";

                        "LignePréparation".Insert();
                       until TransfertLine.next= 0 ;


                    end ;

                     if ("OrdrePréparation"."document type" = "OrdrePréparation"."document type"::Facture) or 
                     ("OrdrePréparation"."document type" = "OrdrePréparation"."document type"::Commande) then 

                     begin 

                         salesL.setrange("Document No.","OrdrePréparation"."Order No");
                         salesL.setrange("Location Code","OrdrePréparation".Magasin);
                         salesL.setrange(type,"Sales Line Type"::item);
                         salesL.setfilter("Quantity (Base)", '>%1',0);
                       if salesL.findfirst then repeat
                       LignePréparation.init();
                       "LignePréparation"."Document No." := OrdrePrepNo ;
                       "LignePréparation"."Source type." := "OrdrePréparation"."document type"; ;
                       "LignePréparation"."Source No.":=salesL."Document No.";
                       "LignePréparation"."Source line No." := salesL."Line No.";
                       "LignePréparation".Location := salesL."Location Code";
                       "LignePréparation"."Bin Code":= salesL."Bin Code";
                       "LignePréparation"."item No.":=salesL."No.";
                       "LignePréparation".description:=salesL.Description;
                       "LignePréparation".Qty:=salesL."Quantity (Base)";

                        "LignePréparation".Insert();
                       until salesL.next= 0 ;
        

                     end;





                end;

        //  [EventSubscriber(ObjectType::Table, Database::"Warehouse Entry", OnAfterInsertEvent, '', false, false)]

                [EventSubscriber(ObjectType::Table,Database::"Ordre de preparation",OnAfterInsertEvent,'',false,false)]

                Procedure InitLignePréparation(var Rec: Record "Ordre de preparation" ;RunTrigger: Boolean)

                var begin 
                      "InitialiserLignesPréparation"(Rec.No);

                end;

               [EventSubscriber(ObjectType::Codeunit,Codeunit::"Sales-Post",OnBeforePostSalesDoc,'',false,false)]
               Procedure CheckPréparationSalesHeader(var SalesHeader: Record "Sales Header")
               var Ordreprep : record "Ordre de preparation" ;
                begin 
                  if (SalesHeader."Document Type" = "Sales Document Type" ::Invoice)
                  then 
                   
                   "CheckPréparation"(Ordreprep."document type"::Facture,SalesHeader."No.");
                  
                   if (SalesHeader."Document Type" = "Sales Document Type" ::Order)
                  then 
                  
                    "CheckPréparation"(Ordreprep."document type"::Commande,SalesHeader."No.");
                     end;

                [EventSubscriber(ObjectType::Codeunit,Codeunit::"TransferOrder-Post (Yes/No)",OnBeforePost,'',false,false)]
                Procedure CheckPréparationTransfert(var TransHeader: Record "Transfer Header")
               var Ordreprep : record "Ordre de preparation" ;
              
                begin 
                   "CheckPréparation"(Ordreprep."document type"::Transfert,TransHeader."No.");

                end ;

               Procedure CheckPréparation(DocumentType : option "Commande","Transfert","Facture" ; documentNo : Code [20])
               var OrdrePrep : Record "Ordre de preparation";
               begin 
                  OrdrePrep.setrange("document type",DocumentType);
                  OrdrePrep.SetRange("Order No",documentNo);
                  OrdrePrep.setfilter(Statut,'<>%1', OrdrePrep.Statut::"livré") ;

                    if OrdrePrep.FindFirst()  then
                        Error('Un Ordre de préparation associé à ce document dont le statut est différent de "livré" existe. Impossible de valider ce docment.');



               end;







     





        





   
    
}
