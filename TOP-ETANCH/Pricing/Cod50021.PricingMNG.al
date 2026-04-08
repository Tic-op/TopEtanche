namespace TopEstimatedPricing.TopEstimatedPricing;
using Microsoft.Pricing.PriceList;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.History;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Posting;

codeunit 50021 PricingMNG
{
    procedure UpdatePriceLineFromItem(var PriceLine: Record "Price List Line"; var Item: Record Item)
    var
        Cost: Decimal;
    begin
        // 🔹 1. Base Cost
        Cost := item.GetBaseCost();

        if Cost = 0 then
            exit;
        PriceLine."Estimated Cost" := Cost;
        // 🔹 2. Recalcul prix standard (selon marge de la ligne)
        PriceLine."Prix standard" :=
            ROUND(Cost * (1 + PriceLine.MrgStd / 100), 0.001);

        // 🔹 3. Recalcul marge marché (si prix marché existe)
        if PriceLine."Prix marché" <> 0 then
            PriceLine.MrgMarché :=
                ((PriceLine."Prix marché" - Cost) / Cost) * 100;

        // 🔹 4. Prix final
        if PriceLine."Prix marché" > PriceLine."Prix standard" then
            PriceLine."Unit Price" := PriceLine."Prix marché"
        else
            PriceLine."Unit Price" := PriceLine."Prix standard";
    end;

    procedure UpdateAllPriceLinesFromItem(var Item: Record Item)
    var
        // Item: Record Item;
        PriceLine: Record "Price List Line";
    begin
        /*   if not Item.Get(ItemNo) then
              exit; */

        PriceLine.Reset();
        PriceLine.setrange("Price List Code", 'PRIX GROS');
        PriceLine.setrange("Source No.", 'GROS');
        // PriceLine.SetRange("Asset Type", PriceLine."Asset Type"::Item);
        PriceLine.SetRange("Product No.", Item."No.");
        PriceLine.setrange(Status, PriceLine.Status::Active);
        // PriceLine.SetFilter("Starting Date", '%1..', Today);
        PriceLine.SetFilter("Ending Date", '%1|>=%2', 0D, Today);

        if PriceLine.FindSet() then
            repeat
                UpdatePriceLineFromItem(PriceLine, Item);
                PriceLine.Modify(false);
                PriceLine.Verify();
            until PriceLine.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnafterPurchRcptLineInsert, '', false, false)]
    local procedure UpdateEstimatedCostAfterPurchaseReception(/* var PurchHeader: Record "Purchase Header"; */  PurchaseLine: Record "Purchase Line")
    var
        // PurchLine: Record "Purchase Line";
        ItemRec: Record Item;
        NewCost: Decimal;
        PurchHeader: record "Purchase Header";
    begin
        PurchHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        // 🔹 conditions métier
        if PurchHeader."Currency Code" <> '' then exit;

        if PurchHeader."Document Type" <> PurchHeader."Document Type"::Order then
            exit;

        if PurchHeader.Invoice then
            exit;

        if PurchHeader."Currency Code" <> '' then
            exit;


        // 🔹 parcourir les lignes
        /*   PurchLine.SetRange("Document Type", PurchHeader."Document Type");
          PurchLine.SetRange("Document No.", PurchHeader."No.");
          PurchLine.SetRange(Type, PurchLine.Type::Item); */

        // if PurchLine.FindSet() then
        //   repeat
        if PurchaseLine.Type <> PurchaseLine.Type::Item then
            exit;
        if not ItemRec.Get(PurchaseLine."No.") then
            //continue;
            exit;


        ItemRec.CalcFields(Inventory);

        if (ItemRec.Inventory) + PurchaseLine."Qty. to Receive (Base)" = 0 then
            exit;// continue;
        if PurchaseLine."Qty. to Receive (Base)" = 0 then exit;

        /*   // 🔹 calcul coût estimé pondéré
          NewCost :=
              ((ItemRec.Inventory * ItemRec."Unit Cost") +
              (PurchaseLine.CalcCostWithCharges() * PurchaseLine."Qty. to Receive (Base)")) /
              (ItemRec.Inventory + PurchaseLine."Qty. to Receive (Base)"); */

        // 🔥 clé : on déclenche TON moteur
        // ItemRec.Validate("estimated cost", Round(NewCost, 0.001));
        RecalculateEstimatedCost(PurchaseLine."No.");
        // ItemRec.Modify(false);

        //  until PurchLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPurchInvLineInsert, '', false, false)]
    local procedure EstimatedCostOnInvoice(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchHeader: Record "Purchase Header")
    var
        //  PurchInvLine: Record "Purch. Inv. Line";
        PricingMgt: Codeunit PricingMNG;
    // PurchInvHeader: record "Purch. Inv. Header";
    begin

        if PurchInvHeader."Currency Code" <> '' then exit;
        if (PurchHeader."Document Type" = "Purchase Document Type"::Order) and PurchHeader.Receive and PurchHeader.Invoice then
            exit;
        // uniquement facture
        //  if PurchInvHdrNo = '' then
        //  exit;
        if (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) or ((PurchHeader."Document Type" = "Purchase Document Type"::Order) and PurchHeader.invoice) then //begin

            /*   PurchInvLine.SetRange("Document No.", PurchInvHdrNo);
              PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);

              if PurchInvLine.FindSet() then
                  repeat */
        PricingMgt.RecalculateEstimatedCost(PurchInvLine."No.");
        //   until PurchInvLine.Next() = 0;
        //  end;

    end;

    procedure RecalculateEstimatedCost(ItemNo: Code[20])
    var
        ItemRec: Record Item;
        PurchRcptLine: Record "Purch. Rcpt. Line";

        InventoryQty: Decimal;
        UnitCost: Decimal;

        CorrectionSum: Decimal;

        NewEstimatedCost: Decimal;
    begin
        // 🔍 Récupérer l'article
        if not ItemRec.Get(ItemNo) then
            exit;

        // 🔵 STOCK ACTUEL
        ItemRec.CalcFields(Inventory);

        InventoryQty := ItemRec.Inventory;
        if InventoryQty = 0 then
            exit;

        UnitCost := ItemRec."Unit Cost";

        // 🔴 SOMME DES CORRECTIONS
        PurchRcptLine.SetRange("No.", ItemNo);

        if PurchRcptLine.FindSet() then
            repeat
                if PurchRcptLine."Qty. Invoiced (Base)" = 0 then begin // Ahaya chawki 
                                                                       //If PurchRcptLine."Qty. Rcd. Not Invoiced" > 0 then
                    CorrectionSum +=
                        PurchRcptLine."Quantity (Base)" *
                        (GetReceiptUnitCost(PurchRcptLine) - UnitCost);
                end;

            until PurchRcptLine.Next() = 0;

        // 🧮 FORMULE DIRECTE
        NewEstimatedCost :=
            UnitCost + (CorrectionSum / InventoryQty);

        NewEstimatedCost := Round(NewEstimatedCost, 0.001, '=');

        // 🚫 éviter update inutile
        if Abs(ItemRec."Estimated Cost" - NewEstimatedCost) < 0.001 then
            exit;

        // 🔥 UPDATE
        ItemRec.Validate("Estimated Cost", NewEstimatedCost);
        ItemRec.Modify(false);
    end;
    /*   procedure RecalculateEstimatedCost(ItemNo: Code[20])
      var
          ItemRec: Record Item;
          ValueEntry: Record "Value Entry";
          PurchRcptLine: Record "Purch. Rcpt. Line";

          TotalQty: Decimal;
          TotalValue: Decimal;

          QtyStock: Decimal;
          ValueStock: Decimal;

          QtyNotInvoiced: Decimal;
          CostNotInvoiced: Decimal;
      begin
          if not ItemRec.Get(ItemNo) then
              exit;

          // 🔵 1. STOCK ACTUEL (coût réel BC)
          ItemRec.CalcFields(Inventory);

          QtyStock := ItemRec.Inventory;
          ValueStock := QtyStock * ItemRec."Unit Cost";

          // 🔴 2. RÉCEPTIONS NON FACTURÉES
          PurchRcptLine.SetRange("No.", ItemNo);
          PurchRcptLine.SetFilter("Quantity", '>0');
          PurchRcptLine.SetFilter("Qty. Invoiced (Base)", '<>%1', PurchRcptLine."Quantity (Base)");

          if PurchRcptLine.FindSet() then
              repeat
                  QtyNotInvoiced += PurchRcptLine."Quantity (Base)";

                  CostNotInvoiced +=
                      PurchRcptLine."Quantity (Base)" *
                      GetReceiptUnitCost(PurchRcptLine);

              until PurchRcptLine.Next() = 0;

          // 🧮 3. TOTAL
          TotalQty := QtyStock + QtyNotInvoiced;
          TotalValue := ValueStock + CostNotInvoiced;

          if TotalQty = 0 then
              exit;

          // 🔥 4. UPDATE
          ItemRec.Validate("estimated cost", Round(TotalValue / TotalQty, 0.001, '='));
          //  ITemrec."Last Estimated Cost Source" := Itemrec."Last Estimated Cost Source"::Import;
          ItemRec.Modify(false);
      end; */


    procedure GetReceiptUnitCost(PurchRcptLine: Record "Purch. Rcpt. Line"): Decimal
    var
        PurchLine: Record "Purchase Line";
    begin
        if PurchLine.Get(
            PurchLine."Document Type"::Order,
            PurchRcptLine."Order No.",
            PurchRcptLine."Order Line No.") then
            exit(PurchLine.CalcCostWithCharges());

        exit(PurchRcptLine."Direct Unit Cost");
    end;
}
