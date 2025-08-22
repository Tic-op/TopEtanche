namespace TOPETANCH.TOPETANCH;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Warehouse.Activity;
using Microsoft.Warehouse.Ledger;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Item;

codeunit 50012 "Lot Management"
{

    Procedure AffecterNoLot(SalesLine: Record "Sales Line")
    var
        BinC: record "Bin Content";
        WHEntry: Record "Warehouse Entry";
        Re: record "Reservation Entry";
        QtyToAssign: decimal;
        Availabileqty: decimal;
        ch: Codeunit "Item Tracking Data Collection";
        pg: page 9126;
        gh: record "Tracking Specification";
        gg: record "Bin Content";
        df: record 338;
        WH2: record "Warehouse Entry";
        QTéLotEmplacement: decimal;
        track: record "Item Tracking Code";
        item: record Item;


    begin
        item.get(SalesLine."No.");
        if item."Item Tracking Code" = '' then exit;
        track.get(item."Item Tracking Code");
        if not track."Lot Warehouse Tracking" or (SalesLine."Bin Code" = '') then exit;



        DeleteReservationEntry(SalesLine);
        BinC.get(SalesLine."Location Code", SalesLine."Bin Code", SalesLine."No.", SalesLine."Variant Code", SalesLine."Unit of Measure Code");
        QtyToAssign := SalesLine."Qty. to Ship";
        WHEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated, "Package No.", "SIFT Bucket No.");
        WHEntry.setrange("Item No.", SalesLine."No.");
        WHEntry.SetRange("Location Code", SalesLine."Location Code");
        WHEntry.setrange("Bin Code", SalesLine."Bin Code");
        WHEntry.SetCurrentKey("Expiration Date", "Item No.", "Lot No.");

        if WHEntry.findfirst then
            repeat

                Binc.setfilter("Lot No. Filter", WHEntry."Lot No.");
                WH2 := WHEntry;
                wh2.setrange("Lot No.", WHEntry."Lot No.");
                wh2.CalcSums(Quantity);
                // QTéLotEmplacement := wh2.Quantity;



                BinC.CalcFields("Quantity (Base)", "Pick Quantity (Base)", Quantity);

                QTéLotEmplacement := BinC."Quantity (Base)";
                //message('%1  %2 %3', Whentry."Bin Code", Whentry."Lot No.", BinC."Quantity");
                if "QTéLotEmplacement" > 0 then begin

                    AvailabileQty := QTéLotEmplacement + "QuantitéRésérvée"(SalesLine, WHEntry."Lot No.");
                    // message('%1 , %2 , %3', WHEntry."Bin Code", WHEntry."Lot No.", Availabileqty);
                    if Availabileqty > 0 then begin
                        // message('%1 , %2 , %3', WHEntry."Bin Code", WHEntry."Lot No.", Availabileqty);
                        if Availabileqty > QtyToAssign then begin
                            insérerResérvation(SalesLine, WhEntry, QtyToAssign);
                            // QtyToAssign -= Availabileqty;
                            break;


                        end
                        else begin
                            "insérerResérvation"(SalesLine, WhEntry, Availabileqty);
                            QtyToAssign -= Availabileqty;
                        end;

                    end;

                end;


            until (Whentry.next = 0); //  or (QtyToAssign <= 0);







    end;

    procedure QuantitéRésérvée(SalesLine: record "Sales Line"; Lot_No: Code[50]): decimal
    var
        RE: record "Reservation Entry";
        CompteurQty: decimal;
        SL: record "Sales Line";
        gfg: page 6510;
        WE: record "Warehouse Entry";
        BC: Record "Bin Content";

    begin

        CompteurQty := 0;
        re.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Reservation Status", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.", "Package No.");
        RE.SetRange("Lot No.", Lot_No);
        RE.SetRange("Item No.", SalesLine."No.");
        RE.SetRange("Source Type", DATABASE::"Sales Line");
        RE.setrange("Location Code", SalesLine."Location Code");
        RE.SetAutoCalcFields("Bin Code");
        Re.SetRange("Bin Code", SalesLine."Bin Code");
        // RE.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());

        if RE.findfirst() then
            repeat
                SL.get("Sales Document Type"::Order, RE."Source ID", Re."Source Ref. No.");
                if SL."Bin Code" = SalesLine."Bin Code" then
                    CompteurQty += RE."Quantity (Base)";

            until RE.Next() = 0;


        exit(RE."Quantity (Base)");

    end;





    local procedure DeleteReservationEntry(SalesLine: Record "Sales Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        //Message('Suppression réservation lot...');
        ReservationEntry.SetCurrentKey("Serial No.", "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line");
        ReservationEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
        ReservationEntry.SetFilter("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetFilter("Item No.", SalesLine."No.");
        ReservationEntry.SetFilter("Location Code", SalesLine."Location Code");
        if ReservationEntry.FindFirst() then
            ReservationEntry.DeleteAll();
    end;



    local procedure insérerResérvation(SalesLine: record "Sales Line"; WhEntry: Record "Warehouse Entry"; QtyToAssign: decimal);

    var
        ReservationEntry: Record "Reservation Entry";

    begin

        ReservationEntry.Init();
        ReservationEntry."Source Type" := DATABASE::"Sales Line";
        ReservationEntry."Source Subtype" := SalesLine."Document Type".AsInteger();
        ReservationEntry."Source ID" := SalesLine."Document No.";
        ReservationEntry."Source Ref. No." := SalesLine."Line No.";
        ReservationEntry."Item No." := SalesLine."No.";
        ReservationEntry."Variant Code" := SalesLine."Variant Code";
        ReservationEntry."Location Code" := SalesLine."Location Code";
        ReservationEntry."Bin Code" := SalesLine."Bin Code";

        ReservationEntry.validate("Quantity (Base)", -QtyToAssign);
        ReservationEntry."Lot No." := WhEntry."Lot No.";
        ReservationEntry."Expiration Date" := WhEntry."Expiration Date";

        //ReservationEntry.validate("Appl.-to Item Entry", ILE_EntryNo);  by AM 160125
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
        ReservationEntry."Created By" := UserId;//TICOP
        ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        ReservationEntry."Creation Date" := today;
        ReservationEntry.insert(true);
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Item Tracking Data Collection", OnAfterCreateEntrySummary, '', true, true)]
    local procedure Binavailability(TrackingSpecification: Record "Tracking Specification"; var TempGlobalEntrySummary: Record "Entry Summary" temporary)
    var
        reserEntry: Record "Reservation Entry";
    //entrysummary:record 338;
    //entrysummarypage :page "Item Tracking Summary";


    begin
        //   Message(TrackingSpecification."Bin Code");// A utiliser comme filter dans reservation entry
        //   Message(TrackingSpecification."Lot No.");
        If TempGlobalEntrySummary."Bin Active" then begin
            reserEntry.CalcFields("bin code");// defined in table
            reserEntry.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Reservation Status", "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.", "Package No.");
            reserEntry.SetRange("Lot No.", TempGlobalEntrySummary."Lot No.");
            reserEntry.SetRange("bin code", TrackingSpecification."Bin Code"); //defined in table
            if reserEntry.FindSet() then begin
                // reserEntry.SetRange(Positive, true);
                reserEntry.CalcSums("Quantity (Base)");
                TempGlobalEntrySummary."Demandée dans l'emplacement" := abs(reserEntry."Quantity (Base)");
                // "Bin requestedQty" To define in table
                TempGlobalEntrySummary."Qté Restante par emplacement" := TempGlobalEntrySummary."Bin Content" - abs(TempGlobalEntrySummary."Demandée dans l'emplacement");
                TempGlobalEntrySummary.Modify();
            end

        end;

    end;




}
