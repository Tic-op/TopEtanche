namespace Pharmatec.Pharmatec;

using Microsoft.Inventory.Item;
using Microsoft.Foundation.Calendar;
using Microsoft.Sales.Customer;
using Top.Top;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;
using PHARMATECCLOUD.PHARMATECCLOUD;
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
        field(50201;"Prix minimal";decimal){

            
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
            var vendor : Record Vendor ;
              begin 
                Vendor.get("Vendor No.");
                "Vendor Name":=vendor.name;
              
                Modify(false);
                 
              end;
        }

    }
    keys
    {

        //key(KeyOrigin; "Item Origin") { }

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

    Procedure CalcDisponibilitéWithResetFilters(locationCode: Code[25]; binCode: Code[25]) : Decimal;
    var DispoReset : decimal ;
    Begin 
          DispoReset:= CalcDisponibilité(locationCode, binCode);
          setfilter("Location Filter",'');
          SetFilter("Bin Filter",'');
          CalcFields("Qty. to ship on order line", "Inventory in Warehouse", "Qty on invoice",Inventory);
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

   

    /*  procedure CalculEcoulement(Datefirst: Date; Datelast: Date; Methode_calculVMJ: option "VMJ Effective","VMJ sur période"; BoolCalcul: Boolean): decimal
     var
     begin
         if BoolCalcul = false then exit(0);
         "Location Filter" := '';
         SetAutoCalcFields("Qty. on Purch. Order", "Qty. on Sales Order", Inventory);
         if Methode_calculVMJ = Methode_calculVMJ::"VMJ sur période" then begin
             if CalculVMJ(Datefirst, Datelast, true) <> 0 then begin

                 exit((Inventory - "Qty. on Sales Order") / CalculVMJ(Datefirst, Datelast, true));
             end
             else
                 exit(0);
         end
         else begin
             if CalculVMJEffective(Datefirst, Datelast, true) <> 0 then begin

                 exit((Inventory - "Qty. on Sales Order") / CalculVMJEffective(Datefirst, Datelast, true));
             end
             else
                 exit(0);

         end;




     end; */

    /*  procedure CalcRecommandation(Datefirst: Date; Datelast: Date; Methode_calculVMJ: option "VMJ Effective","VMJ sur période"): decimal;
     var
         Recommandation: decimal;
         CD: DateFormula;

     begin
         SetAutoCalcFields("Qty. on Purch. Order", "Qty. on Sales Order", Inventory);
         if "Couverture demandée" = 0 then exit(0);

         if Methode_calculVMJ = Methode_calculVMJ::"VMJ sur période" then begin
             if CalculVMJ(Datefirst, Datelast, true) <> 0 then
                 Recommandation := Round(((("Couverture demandée") - CalculEcoulement(Datefirst, Datelast, Methode_calculVMJ::"VMJ sur période", true)) * CalculVMJ(Datefirst, Datelast, true) - "Qty. on Purch. Order"), 1, '>');


             if Recommandation > 0 then
                 exit(Recommandation) else
                 exit(-1)
         end
         else begin
             if CalculVMJEffective(Datefirst, Datelast, true) <> 0 then
                 Recommandation := Round(((("Couverture demandée") - CalculEcoulement(Datefirst, Datelast, Methode_calculVMJ::"VMJ Effective", true)) * CalculVMJEffective(Datefirst, Datelast, true) - "Qty. on Purch. Order"), 1, '>');


             if Recommandation > 0 then
                 exit(Recommandation) else
                 exit(-1)

         end;



     end;
  */


    /*  procedure CalculVMJ(Datefirst: Date; Datelast: Date; BoolCalcul: Boolean): decimal
     var
         item: record item;
         ILE: record "Item Ledger Entry";

         VMJ: decimal;
         int: integer;
     begin
         if BoolCalcul = false then exit(0);
         ILE.SetCurrentKey("Item No.", "Posting Date");
         ILE.setrange("Item No.", "No.");
         ILE.setrange("Entry Type", "Item Ledger Entry Type"::Sale);
         ILE.setrange("Posting Date", Datefirst, Datelast);
         if Ile.findfirst() then begin
             // Datefirst := ILE."Posting Date";
             // ILE.FindLast();
             // Datelast := ILE."Posting Date";
             ILE.CalcSums(Quantity);
             VMJ := abs(ILE.quantity / (Datelast - Datefirst + 1));
             exit(VMJ);



         end
         else
             exit(0);
     end;
  */

    /*  procedure CalculVMJEffective(DateDebut: Date; DateFin: Date; BoolCalcul: Boolean): decimal

     var
         NJ: Decimal;
         NJR: Decimal;
         QtéCons: Decimal;
         DDC: date;
         ILE: record "Item Ledger Entry";
         D0: date;
         Item: record item;
         Item0: record item;
         CalendarMgmt: Codeunit "Calendar Management";
         NJ_Repos: integer;
         CMJ: decimal;
         cal: record "Base Calendar";
         baseCal: Record "Customized Calendar Change";
         location: record Location;

     begin
         NJ := 0;   // Dispo
         NJR := 0; // Rupture
         QtéCons := 0;
         DDC := 0D;
         if DateDebut = 0D then exit(0);
         if BoolCalcul = false then exit(0);

         ILE.SETCURRENTKEY("Item No.", "Posting Date");
         ILE.SETFILTER("Item No.", "No.");
         ILE.SETRANGE("Posting Date", DateDebut, DateFin);

         ILE.SETCURRENTKEY("Entry Type", Nonstock, "Item No.", "Posting Date");
         ILE.SETFILTER("Entry Type", '%1|%2|%3|%4', ILE."Entry Type"::Sale, ILE."Entry Type"::Consumption, ILE."Entry Type"::"Assembly Consumption", "Item Ledger Entry Type"::"Negative Adjmt.");

         IF ILE.FINDFIRST THEN
             REPEAT
                 QtéCons -= ILE.Quantity;
                 IF ILE.Quantity < 0 THEN
                     DDC := ILE."Posting Date";
                 IF QtéCons <= 0 THEN
                     DDC := 0D;
             UNTIL ILE.NEXT = 0;



         Item.GET("No.");
         Item0.GET("No.");
         D0 := 0D;
         D0 := DateDebut;
         REPEAT
             // Item0.SETFILTER("Location Filter", '<>%1&<>%2', 'A99', 'A98');
             Item0.SETFILTER("Location Filter", '');
             location.findfirst();
             repeat
                 if location.Type <> location.Type::Casse then
                     item0.setfilter("Location Filter", '%1|%2', Item0."Location Filter", location.code)

             until location.Next() = 0;

             Item0.SETRANGE("Date Filter", D0);



             // Item.SETFILTER("Location Filter", '<>%1&<>%2', 'A99', 'A98');
             location.reset;
             Item.SETFILTER("Location Filter", '');
             location.findfirst();
             repeat
                 if location.Type <> location.Type::Casse then
                     item0.setfilter("Location Filter", '%1|%2', Item0."Location Filter", location.code)

             until location.Next() = 0;


             Item.SETRANGE("Date Filter", DateDebut, D0);
             Item.CALCFIELDS("Net Change");
             IF Item."Net Change" > 0 // OR Item0."Sold Qty"  
             THEN BEGIN
                 NJ += 1;
                 if baseCal.get() then
                     IF CalendarMgmt.IsNonworkingDay(D0, baseCal) THEN //// Calendrier !!!!
                         NJ_Repos += 1;
             END
             ELSE
                 NJR += 1;



             D0 := CALCDATE('<1D>', D0); /// := D0 + 1
            // message(format(D0));
         UNTIL D0 = DateFin;


         //ERROR('%1',QtéCons);
         IF (NJ - NJ_Repos) <> 0 THEN
             CMJ := QtéCons / ((NJ - NJ_Repos) + 1);


         exit(CMJ);

     end;
  */


    ///## fin besoin Achat AM 
}
