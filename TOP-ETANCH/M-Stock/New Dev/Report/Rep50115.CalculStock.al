namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;

using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Counting.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Warehouse.Ledger;

report 50115 "Calcul Stock"
{
    ApplicationArea = All;
    Caption = 'Calcul Stock';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;


    dataset
    {
        dataitem("Inventory header"; "Inventory header")
        {

            dataitem(Item; Item)
            {
                DataItemTableView = sorting("No.") where(Type = const(Inventory), Blocked = const(false));
                RequestFilterFields = "No.";

                dataitem(Location; Location)
                {
                    //RequestFilterFields = Code;
                    DataItemTableView = where("Use As In-Transit" = const(false));

                    DataItemLinkReference = "Inventory header";
                    DataItemLink = Code = field("Location code");
                    RequestFilterFields = Code;
                    dataitem(Bin; Bin)
                    {
                        DataItemLinkReference = Location;
                        DataItemLink = "Location Code" = field(Code);
                        DataItemTableView = where(Empty = const(false));
                        RequestFilterFields = "Code";

                        trigger OnAfterGetRecord()
                        begin
                            InsertQtyFromBins(Location.Code, Bin.Code, Item);
                        end;

                        trigger OnPreDataItem()
                        begin

                            if "Inventory header".Bin <> '' then
                                SetRange(Code, "Inventory header".Bin);
                        end;
                    }
                    /*                     trigger OnPreDataItem()
                                        begin
                                            if "Inventory header"."Location Code" <> '' then
                                                SetRange(Code, "Inventory header"."Location Code");
                                        end; */


                    trigger OnAfterGetRecord()
                    var
                        InventoryLine: Record "Inventroy Line";
                        verif: Codeunit VerificationStock;
                    begin

                        if not verif.LocationHasBins(Location) then begin
                            InsertQtyFromLocation(Location.Code, Item);
                        end;
                    end;
                }
                /*   trigger OnPreDataItem()
                  begin

                      location.SetRange(Code, "Inventory header"."Location Code");
                  end; */
            }
            trigger OnAfterGetRecord()
            begin
                No_Inventaire := "Inventory header".No;
                PurgeInventoryLigne(No_Inventaire);
            end;


        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {


                group(Options)
                {
                    /* field("Code Magasin"; "Inventory header"."Location code")
                    {

                        Editable = false;
                    } */
                }
            }
        }
        actions
        {
            area(Processing)
            {
                // Ajoute des actions si nécessaire
            }
        }

    }
    trigger OnPreReport()
    begin
        //PurgeInventoryLigne(No_Inventaire);
    end;

    trigger OnInitReport()

    begin
        //Message(No_Inventaire);
        // Récupérer les paramètres passés lors de l'appel
        //   No_Inventaire := Param1;
    end;

    var
        No_Inventaire: code[25];

    local procedure InsertQtyFromBins(LocationCode: Code[25]; BinCode: Code[25]; Item: Record Item)
    var
        InventoryLine: Record "Inventroy Line";
        stock: Decimal;
        lastLineNo: Integer;
    begin
        //item.get(InventoryLine."Inventory No.");
        //Message('%1   , %2', No_Inventaire, "Inventory header".No);
        Item.SetFilter("Location Filter", LocationCode);
        Item.SetFilter("Bin Filter", BinCode);
        Item.CalcFields("Inventory in Warehouse");
        stock := item."Inventory in Warehouse";

        if stock <= 0 then
            exit;
        //Message('%1   , %2', No_Inventaire, No_Inventaire);
        InventoryLine.Init();
        InventoryLine."Inventory No." := No_Inventaire;
        lastLineNo := GetLastLineNo(No_Inventaire) + 10000;

        InventoryLine."line No" := lastLineNo + 1;
        InventoryLine."Item No." := Item."No.";
        InventoryLine."Location Code" := LocationCode;
        InventoryLine."Bin Code" := BinCode;
        InventoryLine.Inventory := stock;

        InventoryLine.Validate("Item No.", Item."No.");
        InventoryLine.Validate("Location Code", LocationCode);
        InventoryLine.Validate("Bin Code", BinCode);
        InventoryLine.Validate(Inventory, stock);

        InventoryLine.Insert();
        //dispatchInventaire(InventoryLine);

    end;


    local procedure InsertQtyFromLocation(LocationCode: Code[25]; Item: Record Item)
    var
        InventoryLine: Record "Inventroy Line";
        stock: Decimal;
        lastLineNo: Integer;
    begin

        item.SetFilter("Location Filter", LocationCode);
        item.CalcFields(Inventory);
        stock := item.Inventory;

        if stock <= 0 then
            exit;
        // InventoryLine.SetFilter("Inventory No.", No_Inventaire);
        InventoryLine.Init();
        InventoryLine."Inventory No." := No_Inventaire;
        lastLineNo := GetLastLineNo(No_Inventaire) + 10000;

        InventoryLine."line No" := lastLineNo + 1;
        InventoryLine."Item No." := Item."No.";
        InventoryLine."Location Code" := LocationCode;
        InventoryLine.Inventory := stock;

        InventoryLine.Validate("Item No.", Item."No.");
        InventoryLine.Validate("Location Code", LocationCode);
        InventoryLine.Validate(Inventory, stock);

        InventoryLine.Insert();

    end;


    local procedure GetLastLineNo(NumIUnventaire: code[25]): integer
    var
        InvL: record "Inventroy Line";
    begin
        InvL.setrange("Inventory No.", NumIUnventaire);
        if InvL.FindLast() then
            exit(InvL."line No")
        else
            exit(0);
    end;

    local procedure PurgeInventoryLigne(NumIUnventaire: code[25]): integer
    var
        InvL: record "Inventroy Line";
        InvH: Record "Inventory header";
    begin
        if InvH.Get(NumIUnventaire) then
            if ((InvH.Status = InvH.Status::Ouvert) and (InvH."Count No." = 1)) then begin
                InvL.SetFilter("Inventory No.", NumIUnventaire);
                InvL.DeleteAll();
            end;

    end;

    /*  procedure dispatchInventaire(var INVL: record "Inventroy Line")
     var
         WH: record "Warehouse Entry";
         ILE: record "Item Ledger Entry";
         Q: query "Item By Lot No. Item Ledg.";
         QT: query "Lot Numbers by Bin";
         QK: query "Item By Lot No. Res.";
         INVLTOINSERT: record "Inventroy Line";
     begin
         if INVL."Bin code" <> '' then



         QT.SetRange(Item_No, INVL."Item No.");
         QT.SetRange(Location_code, invl."Location Code");
         Qt.setrange(Bin_code, invl."Bin code");
         QT.open;
         while Qt.read() do begin
             INVLTOINSERT := InvL;


             INVLTOINSERT."line No" := INVLTOINSERT."line No" + 1;

             //    INVLTOINSERT."Item No." := Qt.Item_No;

             //  INVLTOINSERT."Bin Code" := Qt.Bin_Code;
             //INVLTOINSERT."Location Code" := Qt.Location_Code;
             INVLTOINSERT."N° lot" := Qt.Lot_No;
             INVLTOINSERT.insert();

         end;
         InvL.delete;









     end; */

    Procedure LOT_Dispatcher(var INVL: Record "Inventroy Line")
    var
        Whentry: record "Warehouse Entry";
        InvL_InS: Record "Inventroy Line";
        Whentry2: record "Warehouse Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";

    begin

        if invL."Bin code" <> '' then begin
            Whentry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated, "Package No.", "SIFT Bucket No.");
            Whentry.setrange("Item No.", invl."Item No.");
            Whentry.setrange("Location Code", invl."Location Code");
            Whentry.SetRange("Bin Code", invL."Bin code");
            Whentry.SetCurrentKey("Location Code", "Item No.", "Variant Code", "Zone Code", "Bin Code", "Lot No.", "SIFT Bucket No.");
            if Whentry.findfirst then
                InvL_InS := invl;
            repeat
                InvL_InS."line No" := GetLastLineNo(INVL."Inventory No.");
                InvL_InS."N° lot" := Whentry."Lot No.";
                Whentry2 := Whentry;
                Whentry2.CalcSums(Quantity);
                InvL_InS.Inventory := whentry2.Quantity;
                InvL_InS.Modify();
                if not existLine(InvL_InS) then begin
                    InvL_InS.insert();

                    INVL.delete();
                end;

            until Whentry.next = 0
        end
        else begin
            ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.", "Package No.");
            ItemLedgerEntry.SetRange("Item No.", invL."Item No.");
            ItemLedgerEntry.SetRange("Location Code", invL."Location Code");
            ItemLedgerEntry.SetRange("Lot No.", invL."N° lot");

            if ItemLedgerEntry.FindFirst then begin
                InvL_InS := invL;
                InvL_InS."Line No" := GetLastLineNo(INVL."Inventory No.");
                InvL_InS."N° lot" := ItemLedgerEntry."Lot No.";
                InvL_InS.Inventory := ItemLedgerEntry.Quantity;
                InvL_InS.Modify();

                if not ExistLine(InvL_InS) then begin
                    InvL_InS.Insert();
                    INVL.Delete();
                end;
            end;
        end;
    end;

    procedure existLine(invL: record "Inventroy Line"): Boolean
    var
        invLigne: record "Inventroy Line";


    begin

        invLigne.SetRange("Inventory No.", invLigne."Inventory No.");

        invLigne.SetRange("Location Code", invLigne."Location Code");
        invLigne.SetRange("Bin code", invLigne."Bin code");
        invLigne.SetRange("Item No.", invLigne."Item No.");
        invLigne.SetRange("N° lot", invLigne."N° lot");

        if invLigne.FindFirst() then
            exit(true)
        else
            exit(false);


    end;

}
