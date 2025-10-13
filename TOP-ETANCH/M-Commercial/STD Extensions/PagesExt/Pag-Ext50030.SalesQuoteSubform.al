namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Location;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Item;

pageextension 50030 SalesQuoteSubform extends "Sales Quote Subform"
{
    layout
    { 
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
        modify("Location Code")
        {
            trigger OnBeforeValidate()
            begin
                //  CurrPage.Update();
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
        
        
        addafter("Location Code"){


        field("Bin Code";Rec."Bin Code"){
               visible = true;
               ApplicationArea = all ;
            trigger OnValidate()
            begin
                //ControlDisponibilité();
                if (rec."Bin Code" = '') then error('Emplacement obligatoire dans ce magasin');

            end;


            }

        }
        addafter(Description)
        {     field("DisponibilitéGlobal"; rec.GetDisponibilite(true))
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
    }
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
        item: Record Item;
}
