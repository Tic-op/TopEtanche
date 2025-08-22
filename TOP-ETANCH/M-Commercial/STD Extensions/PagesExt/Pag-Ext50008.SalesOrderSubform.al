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



               } */
            field("DisponibilitéGlobal"; item.CalcDisponibilité(Rec."No.", '', ''))
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
            field(Disponibilité; item.CalcDisponibilité(Rec."No.", Rec."Location Code", Rec."Bin Code"))
            {
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;


                trigger OnDrillDown()
                var
                    dispo: Decimal;
                begin
                    PreparationTransfert();
                end;

            }
            field("Preparation Order No."; Rec."Preparation Order No.")
            {
                ApplicationArea = all;
            }
            field("Barre Code"; Rec."Barre Code")
            {
                ApplicationArea = all;
            }

        }
        addafter(Quantity)
        {

            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
                enabled = false;


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

                rec.Validate("Quantity", 0);

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

                begin

                    recSalesLine.SetRange("Document Type", rec."Document Type");
                    recSalesLine.SetRange("Document no.", rec."Document no.");
                    recSalesLine.SetRange("Line no.", rec."Line no.");
                    dispatch.SetTableView(recSalesLine);
                    dispatch.Run();


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
                        DistributionArticle()
                    // else
                    // Error('Un magasin est déja affecter à cette ligne');
                end;
            }
            action("delete all")
            {
                Caption = 'Supprimer ligne résérvation';
                ApplicationArea = All;
                Image = Bin;
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
                        Binc."Disponibilité" := item."CalcDisponibilité"(Binc."Item No.", Binc."Location Code", Binc."Bin Code");
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

    procedure PreparationTransfert()
    Var
        itemdist: record "Item Distribution";
        location: record Location;
        BinC: record "Bin Content";
        dispo: decimal;

        DispPage: Page "itemdistribution";
        item: record item;


    begin
        itemdist.DeleteAll();

        location.SetRange("Use As In-Transit", false);

        if location.findfirst() then
            repeat

                if location."Bin Mandatory" then begin
                    BinC.setrange("Location Code", location.Code);

                    if BinC.FindFirst() then
                        repeat
                            Dispo := item."CalcDisponibilité"(rec."No.", location.code, binc."Bin Code");
                            if item."CalcDisponibilité"(rec."No.", location.code, binc."Bin Code") > 0 then begin
                                itemdist.INIT();
                                itemdist.validate(Item, Rec."No.");
                                itemdist.validate("Location Code", location.code);
                                itemdist."Bin Code" := binC."Bin Code";

                                itemdist.Qty := dispo;

                                item.get(rec."No.");
                                itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);
                                if itemdist.insert() then;

                            end
                        until BinC.Next() = 0
                end
                else

                    if item."CalcDisponibilité"(rec."No.", location.code, '') > 0 then begin
                        //   Message('%1', location.Code);
                        itemdist.INIT();
                        itemdist.Item := Rec."No.";
                        itemdist."Location Code" := location.code;
                        itemdist."Bin Code" := '';

                        itemdist.Qty := item."CalcDisponibilité"(rec."No.", location.code, '');

                        item.get(rec."No.");
                        itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);

                        if itemdist.insert() then;

                    end;
            until location.next() = 0;


        DispPage.SetDoc(rec."Document Type", Rec."Document No.", Rec."Line No.", rec."Qty. to Ship");
        DispPage.initvalue(1);
        DispPage.SetRecord(itemdist);

        DispPage.Run();

    end;




    procedure DistributionArticle()
    Var
        itemdist: record "Item Distribution";
        location: record Location;
        BinC: record "Bin Content";
        dispo: decimal;

        DispPage: Page "itemdistribution";
        item: record item;


    begin
        itemdist.DeleteAll();
        location.SetRange("Use As In-Transit", false);
        //may be we ll add new filters
        if rec."Location Code" <> '' then
            location.setrange(Code, rec."Location Code");


        if location.findfirst() then
            repeat

                if location."Bin Mandatory" then begin
                    BinC.setrange("Location Code", location.Code);

                    if BinC.FindFirst() then
                        repeat
                            Dispo := item."CalcDisponibilité"(rec."No.", location.code, binc."Bin Code");
                            if item."CalcDisponibilité"(rec."No.", location.code, binc."Bin Code") > 0 then begin
                                itemdist.INIT();
                                itemdist.validate(Item, Rec."No.");
                                itemdist.validate("Location Code", location.code);
                                itemdist."Bin Code" := binC."Bin Code";

                                itemdist.Qty := dispo;

                                item.get(rec."No.");
                                itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);
                                if itemdist.insert() then;

                            end
                        until BinC.Next() = 0
                end
                else

                    if item."CalcDisponibilité"(rec."No.", location.code, '') > 0 then begin

                        itemdist.INIT();
                        itemdist.Item := Rec."No.";
                        itemdist."Location Code" := location.code;
                        itemdist."Bin Code" := '';

                        itemdist.Qty := item."CalcDisponibilité"(rec."No.", location.code, '');

                        item.get(rec."No.");
                        itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);

                        if itemdist.insert() then;

                    end;
            until location.next() = 0;



        DispPage.SetDoc(rec."Document Type", Rec."Document No.", Rec."Line No.", rec."Qty. to Ship");
        DispPage.initvalue(0);
        DispPage.SetRecord(itemdist);
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
            QuantitéDispo := item.CalcDisponibilité(Rec."No.", Rec."Location Code", Rec."Bin Code");
            If rec."Quantity (Base)" > (item.CalcDisponibilité(Rec."No.", Rec."Location Code", Rec."Bin Code") + xRec."Quantity (Base)") then;
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
