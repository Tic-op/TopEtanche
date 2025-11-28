namespace BCSPAREPARTS.BCSPAREPARTS;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Ledger;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;

tableextension 50096 "Item Ext RA" extends Item
{
    fields
    {

        field(50119; "Couverture demandée"; integer)
        {
            /// besoin Achat AM
            MinValue = 0;
        }
        field(50120; "lignes demandes prix"; integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Purchase Line" where("Document Type" = const("Purchase Document Type"::Quote), "No." = field("No.")));
        }
        field(50121; "Quantité à recommander"; decimal)
        {
            MinValue = -1;

        }
        field(50122; "Mode de calcul VMJ"; Option)
        {
            Caption = 'Mode de calcul vente moyenne journalière';
            DataClassification = ToBeClassified;
            OptionMembers = " ","VMJ stock disponible","VMJ sur période";
        }

        field(50123; "Sold (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Item Ledger Entry"."Quantity" where("Entry Type" = const(Sale),
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
            Caption = 'Vente livrée (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }





    }

    keys
    {
        // key(KeyOrigin; "Item Origin") { }
    }
    fieldgroups
    {
        addlast(DropDown; Inventory, "Qty. on Sales Order") { }
        addlast(Brick; Inventory, "Qty. on Sales Order") { }

    }
    trigger OnInsert()
    begin
        "Costing Method" := "Costing Method"::Average;
       // validate("Gen. Prod. Posting Group", 'PR');
       // validate("Inventory Posting Group", 'PR');
        // validate("Base Unit of Measure", 'PCE');
    end;

    trigger OnModify()
    begin
        IF "Base Unit of Measure" = '' then
            validate("Base Unit of Measure", 'PCE');
    end;

    ///## début besoin Achat AM
    procedure CalculEcoulement(Datefirst: Date; Datelast: Date; Methode_calculVMJ: option "","VMJ Effective","VMJ sur période"; BoolCalcul: Boolean): decimal
    var
    begin
        if BoolCalcul = false then exit(0);
        "Location Filter" := '';
        SetAutoCalcFields("Qty. on Purch. Order", "Qty. on Sales Order", Inventory);
        if Methode_calculVMJ = 0 then exit(0);
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




    end;

    procedure CalcRecommandation(Datefirst: Date; Datelast: Date; Methode_calculVMJ: option "","VMJ Effective","VMJ sur période"): decimal;
    var
        Recommandation: decimal;
        CD: DateFormula;

    begin
        SetAutoCalcFields("Qty. on Purch. Order", "Qty. on Sales Order", Inventory);
        if "Couverture demandée" = 0 then exit(0);
        if Methode_calculVMJ = 0 then exit(0);

        if Methode_calculVMJ = Methode_calculVMJ::"VMJ sur période" then begin
            if CalculVMJ(Datefirst, Datelast, true) <> 0 then
                Recommandation := Round(((("Couverture demandée") - CalculEcoulement(Datefirst, Datelast, Methode_calculVMJ::"VMJ sur période", true)) * CalculVMJ(Datefirst, Datelast, true) - "Qty. on Purch. Order"), 1, '>');


            if Recommandation > 0 then begin
                "Quantité à recommander" := Recommandation;
                Rec.Modify(false);

                exit(Recommandation)
            end
            else begin
                "Quantité à recommander" := -1;
                Rec.Modify(false);


                exit(-1)
            end;

        end
        else begin
            if CalculVMJEffective(Datefirst, Datelast, true) <> 0 then
                Recommandation := Round(((("Couverture demandée") - CalculEcoulement(Datefirst, Datelast, Methode_calculVMJ::"VMJ Effective", true)) * CalculVMJEffective(Datefirst, Datelast, true) - "Qty. on Purch. Order"), 1, '>');


            if Recommandation > 0 then begin
                "Quantité à recommander" := Recommandation;
                Rec.Modify(false);

                exit(Recommandation)
            end else begin
                "Quantité à recommander" := -1;
                Rec.Modify(false);


                exit(-1)
            end;

        end;




    end;



    procedure CalculVMJ(Datefirst: Date; Datelast: Date; BoolCalcul: Boolean): decimal
    var
        item: record item;
        ILE: record "Item Ledger Entry";
        /* Datefirst: Date;
        Datelast: Date; */
        VMJ: decimal;
        int: integer;
    begin
        if BoolCalcul = false then exit(0);
        ILE.SetCurrentKey("Item No.", "Posting Date");
        ILE.setrange("Item No.", "No.");
        ILE.setrange("Posting Date", Datefirst, Datelast);
        ILE.setrange("Entry Type", "Item Ledger Entry Type"::Sale);
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


    procedure CalculVMJEffective(DateDebut: Date; DateFin: Date; BoolCalcul: Boolean): decimal

    var
        NJ: Decimal;
        NJR: Decimal;
        QtéCons: Decimal;
        DDC: date;
        ILE: record "Item Ledger Entry";
        D0: date;
        Item: record item;
        Item0: record item;
        // CalendarMgmt: Codeunit "Calendar Management";
        NJ_Repos: integer;
        CMJ: decimal;
        // cal: record "Base Calendar";
        // baseCal: Record "Customized Calendar Change";
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
                //if location.Type <> location.Type::Casse then
                item0.setfilter("Location Filter", '%1|%2', Item0."Location Filter", location.code)

            until location.Next() = 0;

            Item0.SETRANGE("Date Filter", D0);



            // Item.SETFILTER("Location Filter", '<>%1&<>%2', 'A99', 'A98');
            location.reset;
            Item.SETFILTER("Location Filter", '');
            location.findfirst();
            repeat
                //   if location.Type <> location.Type::Casse then
                item0.setfilter("Location Filter", '%1|%2', Item0."Location Filter", location.code)

            until location.Next() = 0;


            Item.SETRANGE("Date Filter", DateDebut, D0);
            Item.CALCFIELDS("Net Change");
            IF Item."Net Change" > 0 /* OR Item0."Sold Qty"  */THEN BEGIN
                NJ += 1;
                /* if baseCal.get() then
                    IF CalendarMgmt.IsNonworkingDay(D0, baseCal) THEN //// Calendrier !!!!
                        NJ_Repos += 1; */
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

    Procedure DernierPrixProposé(): decimal
    var
        OffrePrix: Record "Offre de prix ";
    begin
        OffrePrix.SetCurrentKey("Item No.", "Date", Price);
        OffrePrix.setrange("Item No.", "No.");
        if OffrePrix.findlast then
            exit(OffrePrix.Price)
        else
            exit(0);

    end;

    /*  procedure CalcDisponibilité(locationCode: Code[25]; binCode: Code[25]): Decimal
     begin
         if locationCode <> '' then begin
             Rec.SetFilter("Location Filter", locationCode);

             if binCode <> '' then begin
                 Rec.SetFilter("Bin Filter", binCode);
                 Rec.CalcFields("Qty. to ship on order line", "Inventory in Warehouse");
                 exit(Rec."Inventory in Warehouse" - Rec."Qty. to ship on order line");
             end;
         end;

         Rec.CalcFields("Inventory", "Qty. to ship on order line");
         exit(Rec."Inventory" - Rec."Qty. to ship on order line");
     end; */

    /*  procedure LierOrigine()
     var

         itemrec, itm : record item;
         itemVide: Record item;
     Begin

         //itemVide.SetRange("Item Origin", '');
         itemVide.FindFirst();
         repeat
             itemrec.Reset();
             itemrec.setrange(Description, itemVide.Description);
             itemrec.setfilter("No.", '<>%1', itemVide."No.");
             // itemrec.setfilter("Item Origin", '<>%1', '');
             if itemrec.FindFirst() then begin
                 // message(itemrec.GetFilters);
                 itm.get(itemVide."No.");
                 // Message(Itm."No.");
                 //itm."Item Origin" := itemrec."Item Origin";
                 itm.Modify();

             end;
         until itemVide.next = 0;
     end; */



    ///## fin besoin Achat AM

}
