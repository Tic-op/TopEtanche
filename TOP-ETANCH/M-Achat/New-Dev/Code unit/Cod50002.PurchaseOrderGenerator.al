namespace TopEtanch.TopEtanch;
using Microsoft.Purchases.Document;

codeunit 50002 "Purchase Order Generator"
{
    Subtype = Normal;
    procedure GenerateOrderLinesFromBlanket(OrderNo: Code[20]; DD: Date; DF: Date)
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseLineOrder: Record "Purchase Line";
        VendorNo: Code[20];
        Order: Record "Purchase Header";
        Line: Integer;
        LinesCount: Integer;
    begin
        Order.get(Order."Document Type"::Order, OrderNo);
        Order.TestField("Buy-from Vendor No.");

        if (DD = 0D) OR (DF = 0D) OR (DD > DF) then
            Error('Problème de date...');

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::"Blanket Order");
        PurchaseLine.SetRange("Buy-from Vendor No.", Order."Buy-from Vendor No.");
        PurchaseLine.SetRange("Confirmé par fournisseur", true);
        PurchaseLine.SetRange("Expected Receipt Date", DD, DF);
        //     PurchaseLine.SetAutoCalcFields("DOP sur Commande", "DOP sur Réception");/// A réviser

        if PurchaseLine.IsEmpty then
            Error('Pas de lignes dans les commandes cadres...');

        if PurchaseLine.FindSet() then
            repeat

                //if (PurchaseLine."DOP sur Commande" + PurchaseLine."DOP sur Réception") < PurchaseLine.Quantity then begin  // 
                if PurchaseLine.restant > 0 then begin

                    Line += 10000;
                    LinesCount += 1;

                    PurchaseLineOrder.Init();
                    PurchaseLineOrder.Validate("Document Type", PurchaseLineOrder."Document Type"::Order);
                    PurchaseLineOrder.Validate("Document No.", OrderNo);
                    PurchaseLineOrder."Line No." := Line;
                    PurchaseLineOrder.Validate("Type", PurchaseLine."Type");
                    PurchaseLineOrder.Validate("No.", PurchaseLine."No.");
                    PurchaseLineOrder.Validate("Unit of Measure Code", PurchaseLine."Unit of Measure Code");
                    //PurchaseLineOrder.Validate("Quantity", PurchaseLine."Quantity" - (PurchaseLine."DOP sur Commande" + PurchaseLine."DOP sur Réception"));
                    // Message('1 - %1   cout   %2 ', PurchaseLineOrder."No.", PurchaseLineOrder."Unit Cost");
                    PurchaseLineOrder.Validate("Quantity", PurchaseLine."Restant");
                    //Message('2-  %1   cout   %2 ', PurchaseLineOrder."No.", PurchaseLineOrder."Unit Cost");
                    PurchaseLineOrder.Validate("Unit Cost", PurchaseLine."Unit Cost");
                    //PurchaseLineOrder."Unit Cost" := PurchaseLine."Unit Cost";
                    //  Message('3-  %1   cout   %2 ', PurchaseLineOrder."No.", PurchaseLineOrder."Unit Cost");


                    PurchaseLineOrder.Validate("Line Discount %", PurchaseLine."Line Discount %");
                    //PurchaseLineOrder."Line Discount %" := PurchaseLine."Line Discount %";

                    //    Message('4-  %1   cout   %2  remise %3 ', PurchaseLineOrder."No.", PurchaseLineOrder."Unit Cost", PurchaseLine."Line Discount %");
                    PurchaseLineOrder.Validate("Entry Point", PurchaseLine."Entry Point");
                    //  Message('5-  %1   cout   %2 ', PurchaseLineOrder."No.", PurchaseLineOrder."Unit Cost");
                    PurchaseLineOrder.Validate("Expected Receipt Date", PurchaseLine."Expected Receipt Date");

                    //  Message('6-   %1   cout   %2 ', PurchaseLineOrder."No.", PurchaseLineOrder."Unit Cost");


                    PurchaseLineOrder."Blanket Order Line No." := PurchaseLine."Line No.";
                    PurchaseLineOrder."Blanket Order No." := PurchaseLine."Document No.";
                    //PurchaseLineOrder.Restant := PurchaseLine.Restant;

                    //Message('%1   cout   %2 ', PurchaseLineOrder."No.", PurchaseLineOrder."Unit Cost");
                    PurchaseLineOrder.Insert(true);

                end;
            until PurchaseLine.Next() = 0;

        Message('%1 ligne(s) confirmations ont été transformées en lignes de commande.', LinesCount);
    end;
}