namespace Pharmatec.Pharmatec;

using Microsoft.Sales.Document;
using Microsoft.Warehouse.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Pricing;
using TopEtanch.TopEtanch;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Warehouse.Structure;
using Microsoft.Sales.History;
using Microsoft.Inventory.Location;
using Microsoft.Foundation.Navigate;

pageextension 50008 "Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter(Description)
        {
            /*    field(StockGlobal; item.CalcStock(Rec."No.", '', ''))
               {   
                   Caption = 'Stock Global';
                   DecimalPlaces = 0 : 0;
                   Editable = false;
                   Style = Strong;
                   ApplicationArea = all;
                }
            */
            field("DisponibilitéGlobal"; rec.GetDisponibilite(true))
            {
                Caption = 'Disponibilité Globale';
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;
            }
            field(Stock; item.CalcStock(Rec."No.", Rec."Location Code", Rec."Bin Code"))
            {
                DecimalPlaces = 0 : 0;
                Editable = false;
                Style = Strong;
                ApplicationArea = all;



            }
            field(Disponibilité; rec.GetDisponibilite(false))
            {
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;
                Enabled = rec."Location Code" <> '';


                trigger OnDrillDown()
                var
                    dispo: Decimal;
                begin
                    if rec."Location Code" <> '' then
                        PreparationTransfert(Rec."Document Type", Rec."Document No.", rec."Line No.");
                end;

            }


        }

        modify(Quantity)
        {

            DrillDownPageId = "Item Tracking Lines";
            Editable = not Lignecomptoir;
            trigger OnDrillDown()

            var
            //Item_trackin_line: page "Item Tracking Lines";


            begin

                rec.OpenItemTrackingLines();

            end;



            trigger OnafterValidate()
            var
            begin
                /*    if rec."Location Code" = '' then begin
                       if rec.GetDisponibilite(true) < 0 then error('Quantité non disponible..')
                   end
                   else if rec.GetDisponibilite(false) < 0 then error('Quantité non disponible..') */
            end;
        }
        modify("Qty. to Invoice")
        {
            visible = false;
        }

        modify("Qty. to Ship")
        {
            enabled = not Lignecomptoir;
            visible = false;
            trigger OnBeforeValidate()
            var

            begin
                //CheckBP();
                //Message('Vous devez penser à réaffecter les lots, car vous avez modifié la quantité');
                //  ControlDisponibilité();
            end;

            trigger OnDrillDown()
            begin

            end;
        }
        modify("No.")
        {
            trigger OnDrillDown()
            var
                item: record Item;

            begin
                item.SetLoadFields("No.");
                if item.get(rec."No.") then
                    item.GetLastSales(Rec."Sell-to Customer No.", rec."Sell-to Customer Name", rec."VAT %");
            end;


        }
        modify("Qty. to Assemble to Order")
        {

            Visible = false;
        }
        modify("Reserved Quantity")
        {

            Visible = false;
        }
        modify("Tax Area Code")
        {

            Visible = false;
        }
        modify("Tax Group Code")
        {

            Visible = false;
        }
        modify("Qty. to Assign")
        {

            Visible = false;
        }
        modify("Item Charge Qty. to Handle")
        {

            Visible = false;
        }
        modify("Allow Item Charge Assignment")
        {

            Visible = false;
        }
        modify("Qty. Assigned")
        {

            Visible = false;
        }
        /*  modify("Unit of Measure")
         {

             visible = false;
         } */
        modify("Location Code")
        {
            enabled = not Lignecomptoir;
            //visible = not Lignecomptoir;

            trigger OnBeforeValidate()
            begin
                //  CurrPage.Update();
            end;

            trigger OnAfterValidate()
            var
                OrdrePrep: Record "Ordre de preparation";
                disp: decimal;
            begin
                //UpdateStockInfo();
                LocationHasBin();

                // rec.Validate("Quantity", 0);
                /* 
                                if rec."Location Code" = '' then begin
                                    disp := rec.GetDisponibilite(true);
                                    if disp < rec."Quantity (Base)" then error('Quantité non disponible..');

                                end
                                else begin
                                    disp := rec.GetDisponibilite(false);
                                    if disp < rec."Quantity (Base)" then error('Quantité non disponible..');
                                end;
                 */



                begin


                    OrdrePrep.SetRange("Order No", rec."Document No.");
                    OrdrePrep.SetRange("Magasin", Rec."Location Code");
                    OrdrePrep.SetRange(Statut, OrdrePrep.Statut::"Créé");

                    if OrdrePrep.FindFirst() then
                        Error('Impossible de modifier le magasin car un bon de préparation existe déjà pour cette ligne. Veuillez supprimer le bon de préparation.');
                end;
            end;


        }
        /*  modify("Unit of Measure Code")
         {

             visible = false;
         } */

        modify("Bin Code")
        {
            ApplicationArea = all;
            // editable = not Lignecomptoir;
            Enabled = editBinBool; //and not Lignecomptoir;
            visible = true;
            trigger OnafterValidate()
            begin
                //ControlDisponibilité();
                /*   if rec."Location Code" = '' then begin
                      if rec.GetDisponibilite(true) < 0 then error('Quantité non disponible..')
                  end
                  else if rec.GetDisponibilite(false) < 0 then error('Quantité non disponible..');

                  if (rec."Bin Code" = '') and editBinBool then error('Emplacement obligatoire dans ce magasin');
   */
            end;



        }

        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        moveafter("Location Code"; "Bin Code")
        movebefore("Location Code"; Quantity)
        modify("Shipment Date") { visible = false; }
        modify("Planned Delivery Date") { visible = false; }
        modify("Planned Shipment Date") { visible = false; }
        modify("Promised Delivery Date") { visible = false; }
        modify("Requested Delivery Date") { visible = false; }




    }
    actions
    {

        addlast(processing)
        {
            action("Dispatch Sales Line")
            {
                Caption = 'Dispatch';
                ApplicationArea = All;
                Image = Bin;
                Enabled = (rec."Quantity Shipped" = 0) and not Lignecomptoir;

                /* trigger OnAction()

                begin
                    Qtyrestante := rec."Qty. to Ship (Base)";
                    Qtyrestante := rec.SalesLineDispatcherBin('MTEST', Qtyrestante);
                end; */

                trigger OnAction()
                var
                    dispatch: Report "Dispatch Sales Order Lines";
                    recSalesLine: Record "Sales Line";
                    Itemdist: record "Item Distribution";
                    SH: record "Sales Header";
                    SL: record "Sales Line";

                begin

                    Itemdist.deleteall();
                    /* 
                                        recSalesLine.SetRange("Document Type", rec."Document Type");
                                        recSalesLine.SetRange("Document no.", rec."Document no.");
                                        recSalesLine.SetRange("Line no.", rec."Line no.");
                                        dispatch.SetTableView(recSalesLine);
                                        dispatch.Run(); */
                    Sh.FindFirst();
                    repeat
                        SL.Reset();
                        SL.setrange("Document Type", sh."Document Type");
                        SL.SetRange("Document No.", sh."No.");
                        if SL.Findset() then
                            SL.ModifyAll("Shipping No.", sh."Shipping No.");
                    until Sh.Next() = 0;
                end;


            }
            action("Distribution Article")
            {
                Caption = 'Distribution Article';
                ApplicationArea = All;
                Image = Bin;
                ShortcutKey = 'Alt+G';
                Enabled = (rec."Quantity Shipped" = 0) and not Lignecomptoir;

                trigger OnAction()
                var
                    item: record item;
                begin
                    //if rec."Location Code" = '' then



                    if rec."Qty. to Ship" = 0 then
                        message('Quantité article sur ligne vente doit être supérieure à 0')

                    else
                        DistributionArticle(Rec."Document Type", Rec."Document No.", rec."Line No.")
                    // else
                    // Error('Un magasin est déja affecter à cette ligne');
                end;
            }
        }
        addlast("&Line")
        {
            action(Tableau_de_Bord)
            {

                ApplicationArea = All;
                Image = Bin;
                visible = true;
                Promoted = false;
                ShortcutKey = 'Alt+B';
                trigger OnAction()
                var
                    item: record Item;

                begin
                    item.SetLoadFields("No.");
                    if item.get(rec."No.") then
                        item.GetLastSales(Rec."Sell-to Customer No.", rec."Sell-to Customer Name", rec."VAT %");
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        DispatchAllowed();
        GetLigneVentecomptoir();
    end;

    trigger OnAfterGetCurrRecord()
    var


    begin
        LocationHasBin();
        DispatchAllowed();
        GetLigneVentecomptoir();



    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SalesH: record "Sales Header";
    begin
        if SalesH.get("Sales Document Type"::Order, rec."Document No.") then
            if salesh."Vente comptoir" then error('Impossible d''ajouter une ligne vente : vente comptoir');



    end;




    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Stock := 0;
        "Disponibilité" := 0;
        //CurrPage.Update();

    end;

    procedure PreparationTransfert(Documenttype: enum "Sales Document Type"; documentno: Code[20]; Lineno: integer)
    Var
        itemdist: record "Item Distribution";
        location: record Location;
        BinC: record "Bin Content";
        dispo: decimal;
        SalesL: record "Sales Line";

        DispPage: Page "itemdistribution";
        item: record item;
        BaseSortie: decimal;


    begin
        SalesL.get(Documenttype, documentno, Lineno);
        // itemdist.SetRange("Source Doc type", Documenttype); 
        itemdist.setrange("Source Doc No.", documentno);
        itemdist.setrange("Source Line No.", Lineno);
        itemdist.DeleteAll();
        /* if itemdist.FindFirst() then
            repeat
                itemdist.delete();
            until itemdist.next = 0; */

        if not item.Get(SalesL."No.") then exit; //AM190925
        location.SetFilter(Code, '<>%1', SalesL."Location Code");
        location.SetRange("Use As In-Transit", false);


        if location.findset() then
            repeat
                BaseSortie := item."CalcQuantitéBaseSortie"(location.Code);
                if location."Bin Mandatory" then begin
                    BinC.setrange("Location Code", location.Code);
                    BinC.SetRange("Item No.", SalesL."No.");

                    if BinC.Findset() then
                        repeat
                            Dispo := item."CalcDisponibilité"(location.code, binc."Bin Code");
                            if Dispo > 0 //item."CalcDisponibilité"(location.code, binc."Bin Code") > 0 
                            then begin
                                itemdist.INIT();
                                itemdist.validate(Item, SalesL."No.");
                                itemdist.validate("Location Code", location.code);
                                itemdist."Bin Code" := binC."Bin Code";

                                itemdist.Qty := dispo;

                                //item.get(SalesL."No.");
                                itemdist."Qté Base Sortie" := BaseSortie;
                                itemdist."Source Doc type" := SalesL."Document Type";

                                itemdist."Source Doc No." := SalesL."Document No.";
                                itemdist."Source Line No." := SalesL."Line No.";
                                if itemdist.insert() then;

                            end
                        until BinC.Next() = 0
                end
                else begin
                    Dispo := item."CalcDisponibilité"(location.code, '');
                    if Dispo > 0 then begin
                        //   Message('%1', location.Code);
                        itemdist.INIT();
                        itemdist.Item := SalesL."No.";
                        itemdist."Location Code" := location.code;
                        itemdist."Bin Code" := '';

                        itemdist.Qty := dispo;

                        //item.get(SalesL."No.");
                        itemdist."Qté Base Sortie" := BaseSortie;
                        itemdist."Source Doc type" := SalesL."Document Type";

                        itemdist."Source Doc No." := SalesL."Document No.";
                        itemdist."Source Line No." := SalesL."Line No.";

                        if itemdist.insert() then;

                    end;
                end;

            until location.next() = 0;

        Commit();


        DispPage.SetDoc(SalesL."Document Type", SalesL."Document No.", SalesL."Line No.", SalesL."Qty. to Ship");
        DispPage.initvalue(1);
        itemdist.reset;
        itemdist.setrange("Source Doc type", SalesL."Document Type");
        itemdist.SetRange("Source Doc No.", SalesL."Document No.");
        itemdist.SetRange("Source Line No.", SalesL."Line No.");
        DispPage.SetTableView(itemdist);

        DispPage.Run();

    end;




    procedure DistributionArticle(Documenttype: enum "Sales Document Type"; documentno: Code[20]; Lineno: integer)
    Var
        itemdist: record "Item Distribution";

        location: record Location;
        BinC: record "Bin Content";
        dispo: decimal;

        DispPage: Page "itemdistribution";
        item: record item;
        SalesL: record "Sales Line";
        SalesH: Record "Sales Header";
        BaseSortie: decimal;



    begin
        /*  SalesH.get(Documenttype, documentno);
         SalesH.CalcFields("Bon de preparations");
         if SalesH."Bon de preparations" > 0 then begin


         end; */


        SalesL.get(Documenttype, documentno, Lineno);
        SalesL.CalcFields("Preparé");
        if SalesL."Preparé" then begin
            message('Impossible de distribuer cette ligne, des préparations associées existent.');
            exit;
        end;

        if not Item.get(SalesL."No.") then exit; // AM 190925
        //itemdist.SetRange("Source Doc type", Documenttype);
        itemdist.setrange("Source Doc No.", documentno);
        itemdist.setrange("Source Line No.", Lineno);
        itemdist.DeleteAll();
        /*  if itemdist.FindFirst() then
             repeat
                 itemdist.delete();
             until itemdist.next = 0; */

        //may be we ll add new filters

        if SalesL."Location Code" <> '' then
            location.setrange(Code, SalesL."Location Code");
        location.SetRange("Use As In-Transit", false);


        if location.findfirst() then
            repeat
                BaseSortie := item."CalcQuantitéBaseSortie"(location.Code);
                if location."Bin Mandatory" then begin
                    BinC.setrange("Location Code", location.Code);
                    BinC.setrange("Item No.", item."No.");//151225

                    if BinC.FindFirst() then
                        repeat
                            Dispo := item."CalcDisponibilité"(location.code, binc."Bin Code");
                            if dispo > 0 then begin
                                itemdist.INIT();
                                itemdist.validate(Item, Rec."No.");
                                itemdist.validate("Location Code", location.code);
                                itemdist."Bin Code" := binC."Bin Code";

                                itemdist.Qty := dispo;

                                item.get(SalesL."No.");
                                itemdist."Qté Base Sortie" := BaseSortie;
                                itemdist."Source Doc type" := Documenttype;

                                itemdist."Source Doc No." := documentno;
                                itemdist."Source Line No." := Lineno;

                                if itemdist.insert() then;

                            end
                        until BinC.Next() = 0
                end
                else begin
                    Dispo := item."CalcDisponibilité"(location.code, '');

                    if Dispo > 0 then begin

                        itemdist.INIT();
                        //
                        itemdist."Source Doc type" := Documenttype;
                        itemdist."Source Doc No." := documentno;
                        itemdist."Source Line No." := Lineno;
                        //
                        itemdist.Item := SalesL."No.";
                        itemdist."Location Code" := location.code;
                        itemdist."Bin Code" := '';

                        itemdist.Qty := dispo;

                        item.get(rec."No.");
                        itemdist."Qté Base Sortie" := BaseSortie;


                        if itemdist.insert() then;

                    end;
                end;
            until location.next() = 0;

        Commit();

        DispPage.SetDoc(Documenttype, documentno, Lineno, SalesL."Qty. to Ship");
        DispPage.initvalue(0);
        itemdist.reset;
        itemdist.setrange("Source Doc type", Documenttype);
        itemdist.SetRange("Source Doc No.", documentno);
        itemdist.SetRange("Source Line No.", Lineno);
        //itemdist.findset();
        DispPage.SetTableView(itemdist);
        DispPage.Run();



    end;

    procedure LocationHasBin()
    var
        location: record Location;
    begin
        if location.get(rec."Location Code") then
            editBinBool := location."Bin Mandatory"
        else
            editBinBool := false;





    end;

    procedure DispatchAllowed(): Boolean
    var
        salesH: record "Sales Header";
    begin
        if SalesH.get(Rec."Document Type", Rec."Document No.") then // le champs vente comptoir passe dans la commande vente depuis la commande cadre 
            if salesH."Vente comptoir" then exit(false);
        exit(true);

    end;

    procedure GetLigneVentecomptoir()
    var
        SalesH: record "Sales Header";
    begin


        Lignecomptoir := rec.LigneVentecomptoir();


    end;

    /* procedure SetVenteComptoir()
    begin
        venteComptoir := true;
    end; */





    var
        Disponibilité: Decimal;
        Stock: Decimal;
        item: Record item;

        editBinBool: Boolean;
        dispatchAll: Boolean;
        Lignecomptoir: Boolean;
        venteComptoir: Boolean;


}
