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
                Caption = 'Stock/Mag';
                DecimalPlaces = 0 : 0;
                Editable = false;
                Style = Strong;
                ApplicationArea = all;



            }
            field("Disponibilité"; item.CalcDisponibilité(Rec."No.", Rec."Location Code", Rec."Bin Code"))
            {
                Caption = 'Disponibilité/Mag';
                DecimalPlaces = 0 : 0;
                Style = Favorable;
                Editable = false;
                ApplicationArea = all;
                trigger OnDrillDown()
                var
                    dispo: Decimal;

                begin
                    PreparationTransfertBlanket();
                end;

            }


        }


        addafter("Location Code")
        {
            /*          field("Bin Code"; Rec."Bin Code")
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
            /*  enabled = not Lignecomptoir;
             visible = not Lignecomptoir; */
            Visible = false;
            Enabled = false;
        }



        movebefore("Unit of Measure Code"; "Qty. to Ship")
        modify("Qty. to Ship")
        {
            enabled = not Lignecomptoir;
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
        "Disponibilité" := item.CalcDisponibilité(Rec."No.", Rec."Location Code", Rec."Bin Code");
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

    procedure PreparationTransfertBlanket()
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


