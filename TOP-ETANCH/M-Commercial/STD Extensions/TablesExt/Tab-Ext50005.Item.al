
namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using Microsoft.Foundation.Calendar;
using Microsoft.Sales.Customer;
using Microsoft.Pricing.PriceList;
using Top.Top;
using Microsoft.Warehouse.Structure;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Document;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Location;
using Microsoft.CRM.Team;
using Microsoft.Warehouse.Ledger;

tableextension 50005 Itemext extends Item
{
    fields
    {

        /*  field(50000; Salesperson; Code[20])
         {

             Caption = 'salesperson';
             FieldClass = FlowFilter;


         } */




        field(50006; "Qty. to ship on order line"; Decimal)
        {
            Caption = 'Qté unitaire à livrer';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Sales Line"."Qty. to Ship (Base)" where("Document Type" = const(Order),
                                                                            Type = const(Item),
                                                                            "No." = field("No."),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Bin Code" = field("Bin Filter"), "Qty. to Ship (Base)" = filter(> 0)) //AM only Positive quantities
                                                                           );
        }


        field(50007; "Inventory in Warehouse"; Decimal)
        {
            Caption = 'Stock dans emplacement';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Warehouse Entry"."Qty. (Base)" where("Item No." = field("No."), "Location Code" = field("Location Filter"), "Bin Code" = field("Bin Filter")));

        }
        field(50008; "Unité de Dépot"; Code[10])
        {
            Caption = 'Unité de Dépot';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(50009; "Purchases (Nbr)"; Integer)
        {


            Caption = 'Purchases (Nbr)';
            // DecimalPlaces = 0 : 5;
            Editable = false;
            TableRelation = "Item Ledger Entry";
            FieldClass = FlowField;
            CalcFormula = count("Item Ledger Entry" where("Entry Type" = const(Purchase),
                                                                             "Item No." = field("No."),

                                                                             "Location Code" = field("Location Filter"),
                                                                             "Drop Shipment" = field("Drop Shipment Filter"),
                                                                             "Variant Code" = field("Variant Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Lot No." = field("Lot No. Filter"),
                                                                             "Serial No." = field("Serial No. Filter"),
                                                                             "Package No." = field("Package No. Filter")));
        }


        field(50010; QtyAN; Decimal)
        {
            Caption = 'Qty achétée N';
        }
        field(50011; "QtyAN-1"; Decimal)
        {
            Caption = 'Qty achétée N-1';
        }
        field(50012; "QtyAN-2"; Decimal)
        {
            Caption = 'Qty achétée N-2';
        }
        field(50013; "Qty vendue"; decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = - sum("Item Ledger Entry"."Quantity" where("Entry Type" = const(sale),
                                                                             "Item No." = field("No."),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Location Code" = field("Location Filter"),
                                                                             "Drop Shipment" = field("Drop Shipment Filter"),
                                                                             "Variant Code" = field("Variant Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Lot No." = field("Lot No. Filter"),
                                                                             "Serial No." = field("Serial No. Filter"),
                                                                             "Package No." = field("Package No. Filter")));

        }
        field(50014; "Purchases Receipt (Qty.)"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry"."Quantity" where("Entry Type" = const(Purchase),
                                                                             "Item No." = field("No."),
                                                                             "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Location Code" = field("Location Filter"),
                                                                             "Drop Shipment" = field("Drop Shipment Filter"),
                                                                             "Variant Code" = field("Variant Filter"),
                                                                             "Posting Date" = field("Date Filter"),
                                                                             "Lot No." = field("Lot No. Filter"),
                                                                             "Serial No." = field("Serial No. Filter"),
                                                                             "Package No." = field("Package No. Filter")));
            Caption = 'Purchases Receipt (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

        }
        field(50015; "QVenteN-1"; Decimal)
        {
            Editable = false;
        }
        field(50016; "QVenteN-2"; Decimal)
        {
            Editable = false;
        }
        field(50017; "QVenteN"; Decimal)
        {
            Editable = false;
        }
        field(50018; "Default depot"; Text[25])
        {
            TableRelation = Location where(Type = filter('Dépot'));

        }
        field(50019; "Vendor Name"; text[100])
        { Caption = 'Nom fournisseur'; }
        /*   field(50119; "Couverture demandée"; integer)

          {
              /// besoin Achat AM
          } */
        /*    field(50120; "lignes demandes prix"; integer)
           {
               FieldClass = FlowField;
               CalcFormula = count("Purchase Line" where("Document Type" = const("Purchase Document Type"::Quote), "No." = field("No.")));
           } */

        Field(50070; "Qty Confirmed in Blanket Order"; Decimal)
        {
            Caption = 'Quantité confirmée sur commande cadre achat';
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line".Restant where("Document Type" = const("Purchase Document Type"::"Blanket Order"), Type = const("Purchase Line Type"::Item),
           "No." = field("No."), "Confirmé par fournisseur" = const(true)));
            DecimalPlaces = 0 : 3;
        }
        Field(50199; "Qty Correction in Shipments"; Decimal)
        {
            FieldClass = flowfield;
            Calcformula = Sum("Sales Shipment Line"."Quantity (Base)" where("No." = field("No."), Correction = const(true),
             "Quantity (Base)" = filter(< 0), "Qty. Invoiced (Base)" = const(0)));
        }


        field(50200; "Qty on invoice"; Decimal) //IS12092025
        {
            Caption = 'Qté à facturer';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Sales Line".Quantity where("Document Type" = const(Invoice),
                                                                            Type = const(Item),
                                                                            "No." = field("No."),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Bin Code" = field("Bin Filter"), "Shipment No." = const(''), Quantity = filter(> 0))//AM only Positive quantities
                                                                           );

            DecimalPlaces = 0 : 3;
        }
        field(50201; "Prix marché"; decimal)
        {
            DecimalPlaces = 3 : 3;

            trigger onvalidate()
            var
            begin
                if "Prix marché" > "Prix standard" then
                    validate("Unit Price", "Prix marché")
                else
                    Validate("Unit Price", "Prix standard");

                SyncPriceAndMargin(1);


            end;

        }


        Field(50202; "Prix standard"; decimal)
        {

            DecimalPlaces = 3 : 3;
            trigger onvalidate()
            var
            begin
                if "Prix marché" > "Prix standard" then
                    validate("Unit Price", "Prix marché")
                else
                    Validate("Unit Price", "Prix standard");

                SyncPriceAndMargin(1);


            end;

        }

        Field(50203; MrgMarché; decimal)
        {
            DecimalPlaces = 0 : 2;
            trigger onvalidate()
            var
            begin
                SyncPriceAndMargin(2);

            end;

        }
        Field(50204; MrgStd; decimal)
        {
            DecimalPlaces = 0 : 2;
            trigger onvalidate()
            var
            begin
                SyncPriceAndMargin(2);

            end;

        }


        modify("Base Unit of Measure")
        {
            trigger OnAfterValidate()
            begin
                if "Unité de Dépot" = '' then
                    "Unité de Dépot" := "Base Unit of Measure";
            end;
        }
        modify("Vendor No.")
        {
            Trigger OnAfterValidate()
            var
                vendor: Record Vendor;
            begin
                Vendor.get("Vendor No.");
                "Vendor Name" := vendor.name;

                Modify(false);

            end;
        }

    }
    keys
    {

        key(RorderQty; "Reorder Quantity") { }
        key(BudgQty; "Budget Quantity") { }


    }



    /*  local procedure UpdateItemCategory()
     begin
         if Famille <> '' then
             "Item Category Code" := Famille;
         if "Sous-famille 1" <> '' then
             "Item Category Code" := "Sous-famille 1";
         if "Sous-famille 2" <> '' then
             "Item Category Code" := "Sous-famille 2";
     end; */


    procedure ControlUnitéDépot(Qty: decimal; locationCode: code[10]);
    Var
        unité: record "Item Unit of Measure";
        QtyPerWhUnit: decimal;
        magasin: Record Location;

    begin
        if magasin.get(locationCode) then begin
            if magasin.Type = magasin.type::"Dépot" then
                if "Unité de Dépot" <> "Base Unit of Measure" then begin
                    if unité.get("No.", "Unité de Dépot") then
                        QtyPerWhUnit := unité."Qty. per Unit of Measure";


                    /* if (Qty MOD QtyPerWhUnit) <> 0 then
                        error('Quantité doit être multiple de %1 pour chaque opération de sortie dans le magasin %2 , veuillez vérifier la quantité saisie où/et effectuer les transferts nécessaire', QtyPerWhUnit, locationCode)
 */ //IS 07082025
                end
        end
    end;

    procedure CalcQuantitéBaseSortie(Location: code[10]): decimal;
    var
        itemrec: record item;
        locationrec: record location;
        unité: record "Item Unit of Measure";
    begin
        locationrec.get(location);
        if locationrec.Type = locationrec.Type::"Dépot" then
            unité.get("No.", "Unité de Dépot")
        else
            unité.get("No.", "Sales Unit of Measure");

        exit(unité."Qty. per Unit of Measure");
        //Modify();



    end;




    /* procedure PurchasesOrSalesNbr(ItemID: Code[20]; type: Integer): integer
    var
        ILE: Record "Item Ledger Entry";
        ItemRec: Record Item;
        DocumentNo: Code[20];
        LastDocumentNo: Code[20];
        NB: integer;
    begin
        NB := 0;
        ILE.SetFilter("Item No.", ItemID);

        if type = 0 then
            ILE.SetRange(ILE."Document Type", ILE."Document Type"::"Purchase Receipt")
        else
            ILE.SetRange(ILE."Document Type", ILE."Document Type"::"Sales Shipment");

        // ItemRec."Purchases (Nbr)" := 0;
        LastDocumentNo := '';

        if ILE.FindFirst() then begin
            repeat
                DocumentNo := ILE."Document No.";
                if ILE."Document No." <> LastDocumentNo then begin
                    LastDocumentNo := ILE."Document No.";
                    ItemRec."Purchases (Nbr)" := ItemRec."Purchases (Nbr)" + 1;
                    NB := NB + 1;
                end;
            until ILE.Next() = 0;
        end;
        exit(NB);
    end; */

    procedure SyncPriceAndMargin(CalcSource: Integer)
    begin
        if Rec."Unit Cost" = 0 then begin
            Rec.MrgMarché := 0;
            Rec.MrgStd := 0;
            exit;
        end;

        case CalcSource of
            1:
                begin
                    // Prix → % marge
                    if Rec."Prix marché" <> 0 then
                        Rec.MrgMarché :=
                            ((Rec."Prix marché" - Rec."Unit Cost") / Rec."Unit Cost") * 100
                    else
                        Rec.MrgMarché := 0;

                    if Rec."Prix standard" <> 0 then
                        Rec.MrgStd :=
                              ((Rec."Prix standard" - Rec."Unit Cost") / Rec."Unit Cost") * 100
                    else
                        Rec.MrgStd := 0;
                end;

            2:
                begin

                    if Rec.MrgMarché <> xRec.MrgMarché then
                        Rec.validate("Prix marché", ROUND(
                            Rec."Unit Cost" * (1 + Rec.MrgMarché / 100), 0.001, '=')
                        );

                    if Rec.MrgStd <> xRec.MrgStd then
                        Rec.validate("Prix standard", ROUND(
                            Rec."Unit Cost" * (1 + Rec.MrgStd / 100), 0.001, '='));

                end;

        end;
    end;

    procedure UpdateNewPrices(NewCost: Decimal) // the cost can be : Unit cost, or Cost in date (to be calculated)
    var
        SalesPriceList: Record "Price List Line";
    begin
        //let s consider that margins are fixes
        if Rec.MrgMarché <> xRec.MrgMarché then
            Rec.validate("Prix marché", ROUND(
               NewCost * (1 + Rec.MrgMarché / 100), 0.001, '=')
            );

        if Rec.MrgStd <> xRec.MrgStd then
            Rec.validate("Prix standard", ROUND(
               NewCost * (1 + Rec.MrgStd / 100), 0.001, '='));

        //We also apply that on sales price, active. at the end we remake it as active 

    end;

    procedure GetPurchaseFiscalYear(RecLItem: Record Item; VAR QAchatN: Decimal; VAR "QAchatN-1": Decimal; VAR "QAchatN-2": Decimal; VAR NbAchatN: Integer; VAR "NbAchatN-1": Integer; VAR "NbAchatN-2": Integer)
    begin

        RecLItem.SetFilter("Date Filter", '%1..%2', CalcDate('<-2Y>', DMY2Date(1, 1, Date2DMY(Today, 3))), CalcDate('<-2Y>', DMY2Date(31, 12, Date2DMY(Today, 3))));
        RecLItem.CalcFields("Purchases Receipt (Qty.)", "Purchases (Nbr)");
        "QAchatN-2" := RecLItem."Purchases Receipt (Qty.)";
        "NbAchatN-2" := RecLItem."Purchases (Nbr)";

        RecLItem.SetFilter("Date Filter", '%1..%2', CalcDate('<-1Y>', DMY2Date(1, 1, Date2DMY(Today, 3))), CalcDate('<-1Y>', DMY2Date(31, 12, Date2DMY(Today, 3))));
        RecLItem.CalcFields("Purchases Receipt (Qty.)", "Purchases (Nbr)");
        "QAchatN-1" := RecLItem."Purchases Receipt (Qty.)";
        "NbAchatN-1" := RecLItem."Purchases (Nbr)";

        RecLItem.SetFilter("Date Filter", '%1..%2', DMY2Date(1, 1, Date2DMY(Today, 3)), DMY2Date(31, 12, Date2DMY(Today, 3)));
        RecLItem.CalcFields("Purchases Receipt (Qty.)", "Purchases (Nbr)");
        QAchatN := RecLItem."Purchases Receipt (Qty.)";
        NbAchatN := RecLItem."Purchases (Nbr)";

    end;

    procedure GetSalesFiscalYear(RecLItem: Record Item; VAR VCY: Decimal; VAR VLY: Decimal; VAR VLY2: Decimal; VAR VenteAnnéeRoulante: Decimal)
    var
    begin

        RecLItem.SetFilter("Date Filter", '%1..%2', DMY2DATE(1, 1, DATE2DMY(TODAY, 3)), DMY2DATE(31, 12, DATE2DMY(TODAY, 3)));
        RecLItem.CalcFields("Qty vendue");
        VCY := RecLItem."Qty vendue";


        RecLItem.SetFilter("Date Filter", '%1..%2', CalcDate('<-1Y>', DMY2DATE(1, 1, DATE2DMY(TODAY, 3))), CalcDate('<-1Y>', DMY2DATE(31, 12, DATE2DMY(TODAY, 3))));
        RecLItem.CalcFields("Qty vendue");
        VLY := RecLItem."Qty vendue";


        RecLItem.SetFilter("Date Filter", '%1..%2', CalcDate('<-2Y>', DMY2DATE(1, 1, DATE2DMY(TODAY, 3))), CalcDate('<-2Y>', DMY2DATE(31, 12, DATE2DMY(TODAY, 3))));
        RecLItem.CalcFields("Qty vendue");
        VLY2 := RecLItem."Qty vendue";


        RecLItem.SetFilter("Date Filter", '%1..%2', CalcDate('-1A', TODAY), TODAY);
        RecLItem.CalcFields("Qty vendue");
        VenteAnnéeRoulante := RecLItem."Qty vendue";
    end;

    Procedure CalcDisponibilitéWithResetFilters(locationCode: Code[25]; binCode: Code[25]): Decimal;
    var
        DispoReset: decimal;
    Begin
        DispoReset := CalcDisponibilité(locationCode, binCode);
        setfilter("Location Filter", '');
        SetFilter("Bin Filter", '');
        CalcFields("Qty. to ship on order line", "Inventory in Warehouse", "Qty on invoice", Inventory);
        exit(DispoReset); ///To be verified


    End;

    procedure CalcDisponibilité(locationCode: Code[25]; binCode: Code[25]): Decimal
    var
        Location: Record Location;
        dispo: Decimal;
        filtremagasin: text;
        SL: record "Sales Line";
        SLFAct: Record "Sales Line";
    begin



        if locationCode <> '' then begin
            if not Location.Get(locationCode) then
                exit(0);

            /*     if Location.Type = Location.Type::Tampon then
                    exit(0); */

            SetFilter("Location Filter", locationCode);

            if binCode <> '' then begin
                SetFilter("Bin Filter", binCode);
                CalcFields("Qty. to ship on order line", "Inventory in Warehouse", "Qty on invoice");

                exit("Inventory in Warehouse" - "Qty. to ship on order line" - "Qty on invoice");
            end

            else begin

                CalcFields("Inventory", "Qty. to ship on order line", "Qty on invoice");

                exit("Inventory" - "Qty. to ship on order line" - "Qty on invoice");

            end;
        end
        else begin
            dispo := 0;
            //ALL Locations
            Location.Reset();
            if Location.FindFirst() then begin
                repeat
                    if (Location.Type <> Location.Type::Tampon) and (Location.Type <> Location.Type::Casse) and (NOT Location."Use As In-Transit") then begin
                        SetFilter("Location Filter", Location.Code);
                        CalcFields("Inventory", "Qty. to ship on order line", "Qty on invoice");
                        // message('Qty to ship %1 , Location Filter %2 ,Bin filter ; % 3', "Qty. to ship on order line", "Location Filter", "Bin Filter", "No.");
                        //  message('Qty to ship %1', Item."Qty. to ship on order line");
                        dispo += "Inventory" - "Qty. to ship on order line" - "Qty on invoice";

                        // message(' location filter %1 Quantity %2', "Location Filter", Inventory - "Qty. to ship on order line");

                        filtremagasin := GetFilters();
                        // message(filtremagasin + '     %1       %2     ', Item."Inventory" - Item."Qty. to ship on order line", dispo);
                    end;
                until Location.Next() = 0;
            end;
            begin
                SL.setrange("Document Type", "Sales Document Type"::Order);
                SL.setrange(Type, "Sales Line Type"::item);
                SL.setrange("Location Code", '');
                SL.setrange("No.", "No.");
                SL.SetFilter("Qty. to Ship (Base)", '>%1', 0);
                Sl.CalcSums("Qty. to Ship (Base)");

                SLFAct.setrange("Document Type", "Sales Document Type"::Invoice);
                SLFAct.setrange(Type, "Sales Line Type"::Item);
                SLFAct.setrange("Location Code", '');
                SLFAct.SetRange("No.", "No.");
                SLFAct.setfilter("Quantity (Base)", '>%1', 0);
                SLFAct.CalcSums("Quantity (Base)");
            end;
            exit(dispo - SL."Qty. to Ship (Base)" - SLFAct."Quantity (Base)");
        end;
    end;

    procedure CalcStock(ItemNo: code[25]; locationCode: code[25]; binCode: code[25]): Decimal
    var
        Item: Record Item;
    begin
        //If locationCode = '' then exit(0);

        if NOT Item.Get(ItemNo) then exit(0);
        if locationCode <> '' then begin


            Item.SetFilter("Location Filter", locationCode);

            if binCode <> '' then begin
                Item.SetFilter("Bin Filter", binCode);
                Item.CalcFields("Inventory in Warehouse");

                exit(Item."Inventory in Warehouse");
            end
        end;

        Item.CalcFields("Inventory");
        exit(Item."Inventory");


        exit(0);

    end;

    Procedure MargeGrosToAPPLY(): Decimal


    var
        LP: record "Price List Line";
    begin


        begin
            LP.SetCurrentKey("Asset Type", "Asset No.", "Source Type", "Source No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            LP.SetAscending("Starting Date", false);
            LP.SetRange("Source Type", LP."Source Type"::"Customer Price Group");
            LP.SetRange("Source No.", 'GROS');
            /*  PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
             PriceListLine.SetRange("Asset No.",); */
            LP.setrange("Product No.", "No.");


            if LP.findlast() then
                exit(LP.MrgStd)
            else
                exit(0)


        end;


    end;



    procedure ListeEmplacementDispo() EmplList: Text
    var
        binContent: Record "Bin Content";
        loc0: code[25];
    begin
        binContent.SetRange("Item No.", "No.");
        binContent.SetFilter(Quantity, '>0');

        if binContent.FindSet() then
            repeat
                if loc0 <> binContent."Location Code" then
                    EmplList := EmplList + ' \ ' + binContent."Location Code" + ' : ';
                EmplList := EmplList + ' ' + binContent."Bin Code";

                loc0 := binContent."Location Code";
            until binContent.Next() = 0;
    end;

    procedure ShowListeEmplacementDispo()
    var
        binContent: Record "Bin Content";
    begin
        binContent.SetRange("Item No.", "No.");
        binContent.SetFilter(Quantity, '>0');
        if binContent.FindSet() then
            Page.RunModal(Page::"Bin Content", binContent);


    end;








}

