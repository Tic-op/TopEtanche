namespace PHARMATEC.PHARMATEC;

using Microsoft.Sales.Document;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;

pageextension 50045 BlanketSalesOrderSubform extends "Blanket Sales Order Subform"
{

    layout
    {

        addafter(Description)
        {
            /*  field(StockGlobal; item.CalcStock(Rec."No.", '', ''))
             {
                 Caption = 'Stock Global';
                 DecimalPlaces = 0 : 0;
                 Editable = false;
                 Style = Strong;
                 ApplicationArea = all;



             } */
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
                Caption = 'Stock sur Mag';
                DecimalPlaces = 0 : 0;
                Editable = false;
                Style = Strong;
                ApplicationArea = all;



            }
            field("Disponibilité"; rec.GetDisponibilite(false))
            {
                Caption = 'Disponibilité sur Mag';
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;
                // Enabled = rec."Location Code" <> '';
                trigger OnDrillDown()
                var
                    dispo: Decimal;

                begin
                    if rec."Location Code" <> '' then
                        PreparationTransfertBlanket(Rec."Document Type", Rec."Document No.", rec."Line No.");
                end;

            }


        }


        addafter("Location Code")
        {
            field("Bin Code"; Rec."Bin Code")
                     {
                         Visible = not Lignecomptoir;
                         ApplicationArea = all;
                         Editable = true;
                         Enabled = editBinBool and not Lignecomptoir;
                     } // **********IS 22/05/2025 */

            /*  field(Disponibilité; "Disponibilité")
             {
                 DecimalPlaces = 0 : 0;
                 Style = Favorable;
                 Editable = false;
                 ApplicationArea = all;
             }
  */

        }
        addafter(Quantity)
        {/* 
            field("Quantity on Sales Order"; QuantityOnSaleOrder())
            {
                caption = 'Quantité sur commande vente';
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
                editable = false;
            } */
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
                enabled = false;
                Visible = false;


            }
            field("Qty in Orders"; Rec."Qty in Orders")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
                editable = false;
            }
            field("Qté ouverte"; Rec."Quantity (Base)" - rec."Qty. Shipped (Base)" - REc."Qty in Orders")
            {


                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
                Editable = false;

            }
        }

        modify("Location Code")
        {
            enabled = not Lignecomptoir;
            visible = not Lignecomptoir;
            /*   Visible = false;
              Enabled = false; */
            trigger OnBeforeValidate()
            begin
                //CurrPage.Update();
            end;
        }



        movebefore("Unit of Measure Code"; "Qty. to Ship")
        movebefore("Location Code"; Quantity)
        modify("Qty. to Ship")
        {
            enabled = not Lignecomptoir;
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
        modify("Unit of Measure Code")
        {
            Visible = false;
        }


        movebefore("Location Code"; Quantity)
        modify("Shipment Date") { visible = false; }




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
                    Lignepréparation: Record "Ligne préparation";
                    Ordreprep: Record "Ordre de preparation";


                begin

                    Itemdist.deleteall();
                    "Lignepréparation".findfirst;
                    repeat
                        If not Ordreprep.get("Lignepréparation"."Document No.") then
                            "Lignepréparation".Delete(true);




                    until "Lignepréparation".next = 0;

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

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SH: record "Sales Header";
    begin
        Stock := 0;
        "Disponibilité" := 0;

        begin
            // CheckBlockageInsertion();
            if (SH.get("Sales Document Type"::"Blanket Order", rec."Document No.")) then
                if SH.TotallyInvoiced() then Error('Commande cadre Totalement facturée');
        end;
    end;


    trigger OnAfterGetRecord()
    var
        item: Record Item;
    begin
        if item.get(rec."No.") then
            "Disponibilité" := item.CalcDisponibilité(Rec."Location Code", Rec."Bin Code");
        GetLigneVentecomptoir();
    end;

    trigger OnAfterGetCurrRecord()
    var


    begin
        LocationHasBin();
        //CurrPage.Editable(insertAllow);
        GetLigneVentecomptoir();


    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Stock := 0;
        "Disponibilité" := 0;
        //if rec."Document Type" = "Sales Document Type"::"Blanket Order" then
        // rec.CheckBlockageInsertion();

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



    begin
        SalesH.get(Documenttype, documentno);
        SalesH.CalcFields("Bon de preparations");
        if SalesH."Bon de preparations" > 0 then begin

            message('Impossible de distribuer les lignes de ce document, des préparations associées existent.');
            exit;
        end;

        SalesL.get(Documenttype, documentno, Lineno);
        if not Item.get(SalesL."No.") then exit; // AM 190925
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




    trigger OnOpenPage()
    var

    begin

        // rec.SetAutoCalcFields("Qty in Orders"); 



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

    procedure QuantityOnSaleOrder(): decimal

    var
        SalesL: record "Sales Line";
    begin
        SalesL.Setrange("Document Type", "Sales Document Type"::order);
        SalesL.setrange("Blanket Order No.", rec."Document No.");
        SalesL.setrange("Blanket Order Line No.", rec."Line No.");
        SalesL.calcsums("Outstanding Qty. (Base)");
        exit(SalesL."Outstanding Qty. (Base)");



    end;

    /*  procedure InsertAllowing(varboolinvoiced: Boolean)
     var
         SalesLine: record "Sales Line";
     // boolinvoiced: Boolean;
     begin
         insertAllow := varboolinvoiced;
         /*  SalesLine.setrange("Document Type", rec."Document Type");
          SalesLine.setrange("Document No.", rec."Document No.");
          if SalesLine.FindFirst() then
              repeat
                  if SalesLine.Quantity <> SalesLine."Quantity Invoiced" then
                      exit(true);
              until SalesLine.next() = 0
          else
              exit(true);

          exit(boolinvoiced);
   */
    //  CurrPage.Update();

    //  end;
    procedure GetLigneVentecomptoir()
    var
        SalesH: record "Sales Header";
    begin


        Lignecomptoir := rec.LigneVentecomptoir();


    end;

    /* procedure PreparationTransfertBlanket()
     Var
         itemdist: record "Item Distribution";
         location: record Location;
         BinC: record "Bin Content";
         dispo: decimal;

         DispPage: Page "itemdistribution";
         item: record item;


     begin
         itemdist.SetRange("Source Doc type", rec."Document Type");
         itemdist.setrange("Source Doc No.", rec."No.");
         itemdist.setrange("Source Line No.", rec."Line No.");
         itemdist.DeleteAll();

         location.SetRange("Use As In-Transit", false);


         if not item.get(rec."No.") then exit; // AM190925

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

                                 item.get(rec."No.");
                                 itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);
                                 itemdist."Source Doc type" := rec."Document Type";

                                 itemdist."Source Doc No." := rec."Document No.";
                                 itemdist."Source Line No." := rec."Line No.";
                                 if itemdist.insert() then;

                             end
                         until BinC.Next() = 0
                 end
                 else

                     if item."CalcDisponibilité"(location.code, '') > 0 then begin
                         //   Message('%1', location.Code);
                         itemdist.INIT();
                         itemdist.Item := Rec."No.";
                         itemdist."Location Code" := location.code;
                         itemdist."Bin Code" := '';

                         itemdist.Qty := item."CalcDisponibilité"(location.code, '');

                         item.get(rec."No.");
                         itemdist."Qté Base Sortie" := item."CalcQuantitéBaseSortie"(location.Code);
                         itemdist."Source Doc type" := rec."Document Type";

                         itemdist."Source Doc No." := rec."Document No.";
                         itemdist."Source Line No." := rec."Line No.";

                         if itemdist.insert() then;

                     end;
             until location.next() = 0;


         DispPage.SetDoc(rec."Document Type", Rec."Document No.", Rec."Line No.", rec."Qty. to Ship");
         DispPage.initvalue(1);

         itemdist.reset;
         itemdist.setrange("Source Doc type", rec."Document Type");
         itemdist.SetRange("Source Doc No.", rec."Document No.");
         itemdist.SetRange("Source Line No.", rec."Line No.");
         DispPage.SetTableView(itemdist);

         DispPage.Run();

     end;*/
    procedure PreparationTransfertBlanket(Documenttype: enum "Sales Document Type"; documentno: Code[20]; Lineno: integer)
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

        if not item.Get(SalesL."No.") then exit; //AM190925

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


    var
        Disponibilité: Decimal;
        Stock: Decimal;
        item: Record item;
        editBinBool: boolean;
        insertAllow: boolean;

        Lignecomptoir: boolean;
        DisponibilitéGlobal: Decimal;
        StockGlobal: Decimal;



}


