namespace CPAIBC.CPAIBC;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Item;
using BCSPAREPARTS.BCSPAREPARTS;
using Microsoft.Inventory.Ledger;

codeunit 50020 "Purch Rcpt Pricing Mgt"
{
    Permissions = tabledata "Purch. Rcpt. Line" = m;

    procedure GetVendorFromReceipt(DocumentNo: Code[20]; var VendorNo: Code[20]; var VendorName: Text[100])
    var
        RcptLine: Record "Purch. Rcpt. Line";
        Vendor: Record Vendor;
    begin
        RcptLine.SetRange("Document No.", DocumentNo);
        if not RcptLine.FindFirst() then
            exit;

        VendorNo := RcptLine."Buy-from Vendor No.";

        if Vendor.Get(VendorNo) then begin
            VendorName := Vendor.Name;
            /*   MargeStdToapply := Vendor."Marge Std";
              MargeAutoToapply := Vendor."Marge Auto";
              MargeGrosToAPPLY := Vendor."Marge Gros";
              MethodeCalcul := Vendor."Méthode de Calcul"; */
        end
    end;

    ////////////**********COSTING *******************

    procedure CalcPurchaseAmount(DocumentNo: Code[20]; ItemNo: Code[20]; currency: code[10]): Decimal
    var
        RcptLine: Record "Purch. Rcpt. Line";
        RcptHeader: Record "Purch. Rcpt. Header";
        currFactor, Total : Decimal;
        Qty: Decimal;
    begin
        currFactor := 1;
        if currency = '' then begin
            RcptHeader.get(DocumentNo);
            if RcptHeader."Currency Code" <> '' then
                currFactor := 1 / RcptHeader."Currency Factor";
        end;
        RcptLine.SetRange("Document No.", DocumentNo);
        RcptLine.SetRange(Type, RcptLine.Type::Item);
        RcptLine.SetFilter(Quantity, '>0');
        if ItemNo <> '' then
            RcptLine.SetRange("No.", ItemNo);
        if RcptLine.FindSet() then
            repeat
                Total += RcptLine."Direct Unit Cost" * RcptLine.Quantity * (1 - RcptLine."Line Discount %" / 100);
                Qty += RcptLine.Quantity;
            until RcptLine.Next() = 0;

        if Qty = 0 then
            exit(0);
        if ItemNo <> '' then
            exit((Total * currFactor) / Qty);

        exit(Total * currFactor);


    end;


    procedure CalcCostAmountFromILE(DocumentNo: Code[20]; ItemNo: Code[20]; CalcBase: option PMP,PR): Decimal
    var
        ILE: Record "Item Ledger Entry";
        Total: Decimal;
        Qty: Integer;
        RcptLine: Record "Purch. Rcpt. Line";
        item: Record Item;

    begin

        ILE.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
        ILE.SetRange("Document No.", DocumentNo);
        ILE.SetRange("Entry Type", ILE."Entry Type"::Purchase);
        if ItemNo <> '' then
            ILE.SetRange("item No.", ItemNo);

        ILE.SetAutoCalcFields("Cost Amount (Actual)", "Cost Amount (expected)");

        if ILE.FindSet() then
            repeat
                Total += ILE."Cost Amount (Actual)" + ILE."Cost Amount (expected)";
                Qty += ILE.Quantity;

            until ILE.Next() = 0;

        if Qty = 0 then
            exit;
        if ItemNo <> '' then begin
            Item.get(ItemNo);
            if not Item."Cost is Adjusted" then
                Error('Vous devez ajuster le cout de %1', Item."No.");
            RcptLine.SetCurrentKey("Document No.", "Line No.");
            RcptLine.SetRange("Document No.", DocumentNo);
            RcptLine.SetRange("No.", ItemNo);
            RcptLine.findset(true);
            repeat
                RcptLine.PRCost := ROUND(Total / Qty, 0.001, '=');
                RcptLine.PMPCost := Item."Unit cost";
                RcptLine.CalcBase := CalcBase;
                RcptLine.Modify();
            until RcptLine.next = 0;
        end
        else
            exit(Total);
    end;


    procedure AssignAdditionnalCharges(DocumentNo: Code[20]; TotalCharges: Decimal)
    var
        RcptLine: Record "Purch. Rcpt. Line";
        TotalCostValue: Decimal;
    begin
        TotalCostValue := CalcPurchaseAmount(DocumentNo, '', '');
        if (TotalCostValue = 0) then // (TotalCharges = 0) OR 
            exit;
        RcptLine.SetRange("Document No.", DocumentNo);
        RcptLine.SetRange(Type, RcptLine.Type::Item);
        RcptLine.SetFilter(Quantity, '>0');
        RcptLine.FindSet(true);
        if TotalCharges = 0 then
            RcptLine.ModifyAll(OtherUnitCost, 0)
        else
            repeat

                RcptLine.OtherUnitCost := (TotalCharges * (CalcPurchaseAmount(DocumentNo, RcptLine."No.", '') / TotalCostValue))
                                                           ;
                RcptLine.Modify();
            until RcptLine.Next() = 0;
    end;


    ////////////**********PRICING *******************

    procedure CalcTheoreticalSalesPrice(DocumentNo: Code[20]; ItemNo: Code[20]; MargeStdToapply: decimal; MargeGrosToAPPLY: decimal; FiltreDescription: text)
    var
        RcptLine: Record "Purch. Rcpt. Line";
        BaseCost: Decimal;
        Item: Record Item;
    begin
        if (FiltreDescription <> '') and ((MargeGrosToAPPLY < 0) or (MargeStdToapply < 0)) then
            Error('Les pourcentages des marges doivent être positifs pour %1', FiltreDescription);





        Item.get(ItemNo);
        if not Item."Cost is Adjusted" then
            Error('Vous devez ajuster le cout de %1', Item."No.");



        RcptLine.SetRange("Document No.", DocumentNo);
        RcptLine.SetRange("No.", ItemNo);
        if FiltreDescription <> '' then
            RcptLine.setfilter(Description, FiltreDescription);


        if RcptLine.findset(true) then
            repeat
                case RcptLine.CalcBase of
                    RcptLine.CalcBase::PR:
                        BaseCost := RcptLine.PRCost;

                    RcptLine.CalcBase::PMP:
                        BaseCost := RcptLine.PMPCost;
                end;
                BaseCost += RcptLine.OtherUnitCost;

                //Prix marché
                RcptLine."P. Marché" := RcptLine.Getprixmarchéarticle();
                RcptLine."P. Marché Gros" := RcptLine.Getprixmarchégros();


                if BaseCost = 0 then begin
                    RcptLine.Validate("Prix Std", 0);
                    RcptLine.validate("Prix Gros", 0);
                    // RcptLine.Validate("Prix Auto", 0);
                end
                else begin

                    if FiltreDescription = '' then begin
                        RcptLine."% Marge Gros" := item.MargeGrosToAPPLY(); // MargeGrosToAPPLY;
                        RcptLine."% Marge Std" := item.MrgStd;//MargeStdToapply;

                    end
                    else begin
                        RcptLine."% Marge Gros" := MargeGrosToAPPLY;
                        RcptLine."% Marge Std" := MargeStdToapply;
                    end;

                    if RcptLine."% Marge Std" > 0 then
                        RcptLine.Validate("Prix Std", ROUND(BaseCost * (1 + RcptLine."% Marge Std" / 100), 0.001, '='))
                    else
                        RcptLine.Validate("Prix Std", 0); // pas de marge !!!
                    if RcptLine."% Marge Gros" > 0 then
                        RcptLine.Validate("Prix Gros", ROUND(BaseCost * (1 + RcptLine."% Marge Gros" / 100), 0.001, '='))
                    else
                        RcptLine.Validate("Prix Gros", 0);// pas de marge !!!

                end;


                // RcptLine."% Marge Auto" := MargeAutoToapply;

                RcptLine.Modify();
            until RcptLine.Next() = 0;
    end;



    procedure GapCalc(DocumentNo: Code[20])
    var
        RcptLine: Record "Purch. Rcpt. Line";
        Item: Record Item;

    begin
        RcptLine.SetRange("Document No.", DocumentNo);
        RcptLine.SetRange(Type, RcptLine.Type::Item);
        RcptLine.findset(true);
        repeat
            Item.get(RcptLine."No.");
            if (RcptLine."Prix Gros" <= 0) or (RcptLine."Prix Std" <= 0) then
                Error('Le prix de la référence %1 est soucieux !', Item."No.");

            if RcptLine."P. Marché" <> 0 then begin
                RcptLine."Ecart Marché" := RcptLine."Prix Std" - RcptLine."P. Marché";
                RcptLine."% Ecart Marché" := ((RcptLine."Prix Std" - RcptLine."P. Marché") * 100 / RcptLine."P. Marché") DIV 1;
                // RcptLine.Modify();

            end
            else
                RcptLine."% Ecart Marché" := 0;
            if RcptLine."P. Marché Gros" <> 0 then begin

                RcptLine."Ecart Marché Gros" := RcptLine."Prix Std" - RcptLine."P. Marché Gros";
                RcptLine."% Ecart Marché Gros" := ((RcptLine."Prix Gros" - RcptLine."P. Marché Gros") * 100 / RcptLine."P. Marché Gros") DIV 1;
                //RcptLine.Modify();
            end
            else
                RcptLine."% Ecart Marché Gros" := 0;

            RcptLine.Modify();
        until RcptLine.Next() = 0;


    end;

    procedure ApplyUnitPrice(DocumentNo: Code[20])
    var
        RcptLine: Record "Purch. Rcpt. Line";
        Item: Record Item;
        PurshEvent: Codeunit PurchaseEvents;
    begin

        RcptLine.SetRange("Document No.", DocumentNo);
        RcptLine.SetRange(Type, RcptLine.Type::Item);
        RcptLine.findset(true);
        repeat
            Item.get(RcptLine."No.");
            if (RcptLine."Prix Gros" <= 0) or (RcptLine."Prix Std" <= 0) then
                Error('Le prix de la référence %1 est soucieux !', Item."No.");
            Item.validate("Prix standard", RcptLine."Prix Std");
            Item.Modify();
            RcptLine."Price confirmation Date" := CurrentDateTime;
            RcptLine.Modify();
            PurshEvent.CancelSalesPrice('GROS', Item."No.", CurrentDateTime.Date);
            PurshEvent.InsertSalesPrice('GROS', Item."No.", CurrentDateTime.date, RcptLine."Prix Gros");
            PurshEvent.CancelSalesPrice('Auto', Item."No.", CurrentDateTime.Date);
            PurshEvent.InsertSalesPrice('Auto', Item."No.", CurrentDateTime.date, RcptLine."Prix Auto");

        until RcptLine.Next() = 0;


    end;

    ////////////////////////TRANSFERT*****************

    procedure CreateReclassJournalFromReceipt(
   DocumentNo: Code[20];
   JournalTemplate: Code[10];
   JournalBatch: Code[10];
    ToLocation: Code[10])
    var
        RcptLine: Record "Purch. Rcpt. Line";
        ItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
        ILE: Record "Item Ledger Entry";
    begin
        RcptLine.SetRange("Document No.", DocumentNo);
        RcptLine.SetRange(Type, RcptLine.Type::Item);
        RcptLine.SetFilter(Quantity, '>0');

        if not RcptLine.FindSet() then
            Error('Aucune ligne article trouvée pour cette réception.');

        LineNo := 10000;

        repeat
            if RcptLine."Price confirmation Date" = 0DT then
                error('le prix de %1 n''est pas encore confirmé');

            ItemJnlLine.Init();
            ItemJnlLine."Journal Template Name" := JournalTemplate;
            ItemJnlLine."Journal Batch Name" := JournalBatch;
            ItemJnlLine."Line No." := LineNo;

            ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Transfer);
            ItemJnlLine.Validate("Posting Date", Today);
            ILe.setrange("Document No.", RcptLine."Document No.");
            ILE.SetRange("Document Line No.", RcptLine."Line No.");
            ile.SetFilter("Remaining Quantity", '>0');
            if ILE.FindFirst() then begin
                ItemJnlLine.Validate("Item No.", ile."Item No.");
                ItemJnlLine.Validate(Quantity, ILE."Remaining Quantity");

            end else
                Error('Aucune entrée de stock disponible pour le document %1 et la ligne %2.', RcptLine."Document No.", RcptLine."Line No.");



            ItemJnlLine.Validate("Location Code", RcptLine."Location Code");
            ItemJnlLine.Validate("New Location Code", ToLocation);
            ItemJnlLine."Source Code" := 'FRECLASS';

            ItemJnlLine."Document No." := DocumentNo;
            ItemJnlLine."External Document No." := RcptLine."Order No.";

            ItemJnlLine.Insert(true);

            LineNo += 10000;
        until RcptLine.Next() = 0;
    end;




}
