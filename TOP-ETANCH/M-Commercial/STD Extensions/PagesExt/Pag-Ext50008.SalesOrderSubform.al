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
            field("DisponibilitéGlobal"; rec.GetDisponibilite())
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
            field(Disponibilité; rec.GetDisponibilite())
            {
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;


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

            trigger OnBeforeValidate()
            begin
                //OldQty := xRec."Qty. to Ship";
                // ControlDisponibilité();
            end;

            trigger OnAfterValidate()
            begin
                //if OldQty <> 0 THEN
                // rec.validate("Qty. to Ship", OldQty);

            end;
        }

        modify("Qty. to Ship")
        {
            enabled = not Lignecomptoir;
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
                    item.GetLastSales(Rec."Sell-to Customer No.", rec."Sell-to Customer No.", rec."VAT %");


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
                // ControlDisponibilité();
            end;

            trigger OnAfterValidate()
            var
                OrdrePrep: Record "Ordre de preparation";
            begin
                //UpdateStockInfo();
                LocationHasBin();

                // rec.Validate("Quantity", 0);

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
                if (rec."Bin Code" = '') and editBinBool then error('Emplacement obligatoire dans ce magasin');

            end;



        }

        moveafter("Location Code"; "Bin Code")



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

                begin

                    Itemdist.deleteall();
                    /* 
                                        recSalesLine.SetRange("Document Type", rec."Document Type");
                                        recSalesLine.SetRange("Document no.", rec."Document no.");
                                        recSalesLine.SetRange("Line no.", rec."Line no.");
                                        dispatch.SetTableView(recSalesLine);
                                        dispatch.Run(); */


                end;


            }
            action("Distribution Article")
            {
                Caption = 'Distribution Article';
                ApplicationArea = All;
                Image = Bin;
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
            action("delete all")
            {
                Caption = 'Supprimer ligne résérvation';
                ApplicationArea = All;
                Image = Bin;
                visible = false;
                trigger OnAction()
                var
                    SL: record "Sales Line";
                    RE: record "Reservation Entry";
                    inv: Record "Inventroy Line";
                    ship: record "Sales Shipment Header";
                    wh: record "Warehouse Entry";
                    Cu: Codeunit SalesEvents;
                    item: record item;
                    cuv: Codeunit VerificationStock;
                    OP: Record "Ordre de preparation";
                    Binc: Record "Bin Content";

                begin
                    /* Sl.SetRange("Document No.", rec."Document No.");
                    Sl.DeleteAll(true); */
                    // RE.DeleteAll(true);
                    //inv.DeleteAll();
                    cu.DeleteReservationEntry(Rec);
                    Binc.findfirst();
                    repeat
                        Binc."Disponibilité" := item."CalcDisponibilité"(Binc."Location Code", Binc."Bin Code");
                        Binc.modify();

                    until Binc.next = 0;
                    /*     item.findfirst();
                        repeat
                            if item."Unité de Dépot" = '' then
                                item."Unité de Dépot" := item."Base Unit of Measure";
                            item.Modify();

                        until item.next = 0; */

                    //Cuv.FusionLigneCommande(rec."Document Type", rec."Document No.");
                    /*  OP.SetFilter("document type", '');
                     OP.ModifyAll("document type", 'Commande');
  */

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


    begin
        SalesL.get(Documenttype, documentno, Lineno);
        itemdist.SetRange("Source Doc type", Documenttype);
        itemdist.setrange("Source Doc No.", documentno);
        itemdist.setrange("Source Line No.", Lineno);
        // itemdist.DeleteAll(); 
        if itemdist.FindFirst() then
            repeat
                itemdist.delete();
            until itemdist.next = 0;


        location.SetRange("Use As In-Transit", false);
        location.SetFilter(Code, '<>%1', SalesL."Location Code");

        if location.findfirst() then
            repeat

                if location."Bin Mandatory" then begin
                    BinC.setrange("Location Code", location.Code);

                    if BinC.FindFirst() then
                        repeat
                            Dispo := item."CalcDisponibilité"(location.code, binc."Bin Code");
                            if item."CalcDisponibilité"(location.code, binc."Bin Code") > 0 then begin
                                itemdist.INIT();
                                itemdist.validate(Item, SalesL."No.");
                                itemdist.validate("Location Code", location.code);
                                itemdist."Bin Code" := binC."Bin Code";

                                itemdist.Qty := dispo;

                                item.get(SalesL."No.");
                                itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);
                                itemdist."Source Doc type" := SalesL."Document Type";

                                itemdist."Source Doc No." := SalesL."Document No.";
                                itemdist."Source Line No." := SalesL."Line No.";
                                if itemdist.insert() then;

                            end
                        until BinC.Next() = 0
                end
                else

                    if item."CalcDisponibilité"(location.code, '') > 0 then begin
                        //   Message('%1', location.Code);
                        itemdist.INIT();
                        itemdist.Item := SalesL."No.";
                        itemdist."Location Code" := location.code;
                        itemdist."Bin Code" := '';

                        itemdist.Qty := item."CalcDisponibilité"(location.code, '');

                        item.get(SalesL."No.");
                        itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);
                        itemdist."Source Doc type" := SalesL."Document Type";

                        itemdist."Source Doc No." := SalesL."Document No.";
                        itemdist."Source Line No." := SalesL."Line No.";

                        if itemdist.insert() then;

                    end;
            until location.next() = 0;


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


    begin
        SalesL.get(Documenttype, documentno, Lineno);
        itemdist.SetRange("Source Doc type", Documenttype);
        itemdist.setrange("Source Doc No.", documentno);
        itemdist.setrange("Source Line No.", Lineno);
        //itemdist.DeleteAll(); 
        if itemdist.FindFirst() then
            repeat
                itemdist.delete();
            until itemdist.next = 0;
        location.SetRange("Use As In-Transit", false);
        //may be we ll add new filters

        if SalesL."Location Code" <> '' then
            location.setrange(Code, SalesL."Location Code");


        if location.findfirst() then
            repeat

                if location."Bin Mandatory" then begin
                    BinC.setrange("Location Code", location.Code);

                    if BinC.FindFirst() then
                        repeat
                            Dispo := item."CalcDisponibilité"(location.code, binc."Bin Code");
                            if item."CalcDisponibilité"(location.code, binc."Bin Code") > 0 then begin
                                itemdist.INIT();
                                itemdist.validate(Item, Rec."No.");
                                itemdist.validate("Location Code", location.code);
                                itemdist."Bin Code" := binC."Bin Code";

                                itemdist.Qty := dispo;

                                item.get(SalesL."No.");
                                itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);
                                itemdist."Source Doc type" := Documenttype;

                                itemdist."Source Doc No." := documentno;
                                itemdist."Source Line No." := Lineno;
                                if itemdist.insert() then;

                            end
                        until BinC.Next() = 0
                end
                else

                    if item."CalcDisponibilité"(location.code, '') > 0 then begin

                        itemdist.INIT();
                        //
                        itemdist."Source Doc type" := Documenttype;
                        itemdist."Source Doc No." := documentno;
                        itemdist."Source Line No." := Lineno;
                        //
                        itemdist.Item := SalesL."No.";
                        itemdist."Location Code" := location.code;
                        itemdist."Bin Code" := '';

                        itemdist.Qty := item."CalcDisponibilité"(location.code, '');

                        item.get(rec."No.");
                        itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);


                        if itemdist.insert() then;

                    end;
            until location.next() = 0;



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

    Procedure ControlDisponibilité()
    var
        QuantitéDispo: decimal;
    begin
        if (rec.type = "Sales Line Type"::item) and (rec."Document Type" = "Sales Document Type"::Order) then begin
            QuantitéDispo := item.CalcDisponibilité(Rec."Location Code", Rec."Bin Code");
            If rec."Quantity (Base)" > (item.CalcDisponibilité(Rec."Location Code", Rec."Bin Code") + xRec."Quantity (Base)") then;
            Error('La quantité disponible dans ce magasin est inférieure à la quantité (base) saisie');
        end;

    end;



    var
        Disponibilité: Decimal;
        Stock: Decimal;
        item: Record item;

        editBinBool: Boolean;
        dispatchAll: Boolean;
        Lignecomptoir: Boolean;
        venteComptoir: Boolean;


}
