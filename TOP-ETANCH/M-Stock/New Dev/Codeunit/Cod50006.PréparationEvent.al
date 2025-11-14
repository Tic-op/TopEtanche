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
     incount : integer ;
   

    begin 
               incount :=  0 ;
               /*   OrdrePrep.setrange("document type",DocumentType);
                  OrdrePrep.SetRange("Order No",documentNo);
                    if OrdrePrep.FindFirst() then
                        Error('Un bon de préparation existe déjà pour %1 Numéro %2',DocumentType ,documentNo);
 */


                    
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
                                Error('Il faut avoir un magasin dans les lignes du document', SalesLine."No.")

                        until SalesLine.Next() = 0;

                    SalesLine.Reset();
                    SalesLine.SetCurrentKey("Document Type", "Document No.");
                   if DocumentType = DocumentType ::Facture then 
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
                    if DocumentType = DocumentType::Commande then 
                      SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.",documentNo);
                    SalesLine.SetAutoCalcFields("Preparé");

                    if SalesLine.FindFirst() then
                        repeat 
                            if SalesLine."Preparé" then continue ;
                            LocationCode := SalesLine."Location Code";
                            OrdrePrep.Reset();
                             if DocumentType = DocumentType ::Facture then 
                    OrdrePrep.SetRange("Document Type", DocumentType::Facture);
                    if DocumentType = DocumentType::Commande then 
                       OrdrePrep.SetRange("Document Type", DocumentType::Commande);
                            OrdrePrep.SetRange("Order No",documentNo);
                            OrdrePrep.SetRange("Magasin", LocationCode);
                            OrdrePrep.setrange(Statut,OrdrePrep.Statut::"Créé",OrdrePrep.Statut::"En cours");
                            if not OrdrePrep.FindFirst() then begin
                                OrdrePrep.Init();
                                OrdrePrep."Order No" := documentNo;
                                OrdrePrep."Magasin" := LocationCode;
                                OrdrePrep."Creation date" := CurrentDateTime;
                                OrdrePrep.Statut := OrdrePrep.Statut::"Créé";
                                OrdrePrep."document type" := DocumentType ;
                                OrdrePrep.Demandeur := SalesLine."Sell-to Customer No.";
                                SalesLine.CalcFields("Sell-to Customer Name");
                                OrdrePrep."Nom demandeur" := SalesLine."Sell-to Customer Name";
                              //  OrdrePrep."document type" := OrdrePrep."document type"::Facture;
                                //SalesSetup.Get();
                                OrdrePrep.Insert(true);
                                incount+=1 ;
                            end;
                        until SalesLine.Next() = 0;
                        if incount>0 then 
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
                               OrdrePrep.setrange(Statut,OrdrePrep.Statut::"Créé",OrdrePrep.Statut::"En cours");
                            if not OrdrePrep.FindFirst() then begin
                                OrdrePrep.Init();
                                OrdrePrep."Order No" := documentNo;
                                OrdrePrep."Magasin" := LocationCode;
                                OrdrePrep."Creation date" := CurrentDateTime;
                                OrdrePrep.Statut := OrdrePrep.Statut::"Créé";
                                OrdrePrep."document type" := DocumentType ;
                OrdrePrep.Demandeur := transferLine."Transfer-to Code";
                OrdrePrep."Nom demandeur" := TransferH."Transfer-to Name";
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
                       "LignePréparation".Demandeur := "OrdrePréparation".Demandeur;
                       "LignePréparation"."Nom demandeur" := "OrdrePréparation"."Nom demandeur";
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
                       "LignePréparation".Demandeur := "OrdrePréparation".Demandeur;
                       "LignePréparation"."Nom demandeur" := "OrdrePréparation"."Nom demandeur";


                                                    // "LignePréparation".Qty:=salesL."Quantity (Base)";
                        if "LignePréparation"."Source type." = "LignePréparation"."Source type."::Facture then
                        "LignePréparation".Qty := salesL."Qty. to Invoice (Base)";
                        if "LignePréparation"."Source type."= "LignePréparation"."Source type."::Commande then 
                         "LignePréparation".Qty := salesL."Qty. to Ship (Base)";
                         salesL.CalcFields("Preparé");
                         if not SalesL."Preparé" then 
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
        OrdrePrep.setfilter(Statut, '<>%1', OrdrePrep.Statut::"Préparé");

                    if OrdrePrep.FindFirst()  then
            Error('Un Ordre de préparation associé à ce document dont le statut est différent de "préparé" existe. Impossible de valider ce docment.');



    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    procedure AssignePostedDocNumToPrepOrder(var SalesHeader: Record "Sales Header"; SalesInvHdrNo: Code[20]; SalesShptHdrNo: Code[20])
    var
        OrdrePrep: Record "Ordre de preparation";
    begin
        If SalesHeader."Document Type" = "Sales Document Type"::Invoice then begin
            OrdrePrep.setrange("document type", OrdrePrep."document type"::Facture);
            OrdrePrep.setrange("Order No", SalesHeader."No.");
            If OrdrePrep.Findset() then
                OrdrePrep.ModifyAll("Num document validé", SalesInvHdrNo, false);
        end;
        If SalesHeader."Document Type" = "Sales Document Type"::Order then begin
            OrdrePrep.setrange("document type", OrdrePrep."document type"::Commande);
            OrdrePrep.setrange("Order No", SalesHeader."No.");
            If OrdrePrep.Findset() then
                OrdrePrep.ModifyAll("Num document validé", SalesShptHdrNo, false);
        end;


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnAfterTransferOrderPostShipment, '', false, false)]

    procedure AssignePostedDocNumToPrepOrderTransfert(var TransferHeader: Record "Transfer Header"; var TransferShipmentHeader: Record "Transfer Shipment Header")
    var
        OrdrePrep: Record "Ordre de preparation";
    begin
        OrdrePrep.setrange("document type", OrdrePrep."document type"::Transfert);
        OrdrePrep.setrange("Order No", TransferHeader."No.");
        If OrdrePrep.Findset() then
            OrdrePrep.ModifyAll("Num document validé", TransferShipmentHeader."No.", false);

    end;



















}
