codeunit 50113 PurchaseEvents
{
    //<<< Check Affectaion des frais droit douane montant facture par rapport a la répartion du montant par NGP 
    Permissions = tabledata "Purch. Rcpt. Line" = m, tabledata "Purch. Rcpt. Header" = m;
    //et Origine 
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", OnbeforepostPurchaseDoc, '', false, false)]
    local procedure CheckDroitDouane(PurchaseHeader: Record "Purchase Header")
    var
        DD: Record DroitDouaneLedgerEntry;
        PurchaseLine: Record "Purchase Line";


    begin
        if PurchaseHeader."Currency Code" <> '' then exit;
        if PurchaseHeader."DI No." = '' then exit;
        dd.SetRange("DI No", PurchaseHeader."DI No.");
        dd.CalcSums(Amount);
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange("Droit douane", true);
        PurchaseLine.CalcSums(Amount);
        // PurchaseHeader.CalcFields(amount);
        if PurchaseLine.Amount > 0 then
            if PurchaseLine.Amount <> dd.Amount then error('Vérifier le montant Droit douane dans facture %1 et le montant réparti dans %2', PurchaseHeader."No.", PurchaseHeader."DI No.");
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", OnbeforepostPurchaseDoc, '', false, false)]
    local procedure OnbeforepostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    var
        ImpFolder: Record "Import Folder";
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo" then exit; /////OD 27032025
        if PurchaseHeader."Currency Code" <> '' then begin
            PurchaseHeader.TestField(PurchaseHeader."DI No.");

            ImpFolder.get(PurchaseHeader."DI No.");
            ImpFolder.TestField("Currency Factor");

            if PurchaseHeader."Currency Factor" <> 1 / ImpFolder."Currency Factor" then
                Error('La commande %1 et le dossier %2 n''ont pas le même taux de change', PurchaseHeader."No.", PurchaseHeader."DI No.");

        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", OnbeforepostPurchaseDoc, '', false, false)]
    local procedure StampEvent(PurchaseHeader: Record "Purchase Header")
    var
        i: Enum "Purchase Document Status";
        PurchaseLine: Record "Purchase Line";
        Vend: record Vendor;


    begin
        if (PurchaseHeader."Currency Code" <> '') then exit;
        Vend.get(PurchaseHeader."Buy-from Vendor No.");
        if not Vend.Stamp then exit;
        // if not PurchaseHeader.Stamp then exit;

        PurchaseHeader.Status := PurchaseHeader.Status::Open;



        if PurchaseHeader.Invoice and not PurchaseHeader.Receive and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then
            error('Pour facturer une Réception déjà réceptionnée, passez par une facture Achat puis regoupez les Expéditions');


        if (PurchaseHeader.Invoice and PurchaseHeader.Receive and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order)) then begin
            PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
            PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
            PurchaseLine.SetFilter("qty. to receive", '<>0');
            if not PurchaseLine.FindFirst() then
                Error('Pas de lignes à réceptionner !');

        end;
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice)
        OR (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) THEN begin
            if (PurchaseHeader.Invoice and PurchaseHeader.Receive and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order))

            OR ((PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice))

             then begin
                if CheckTypeTimbre(PurchaseHeader) then
                    InsertStampLine(PurchaseHeader, true)
                else
                    InsertStampLine(PurchaseHeader, false)

            end; //and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)


        end;

        //SalesHeader.Status := i;
        //  SalesHeader.Modify();
    end;

    procedure CheckTypeTimbre(Rec: Record "Purchase Header") Frais: Boolean
    var
        purchLine: record "Purchase Line";
    begin
        if (rec."DI No." <> '') and (Rec."Document Type" = rec."Document Type"::order) then exit(true);
        purchLine.SetRange("Document Type", Rec."Document Type");
        purchLine.SetRange("Document No.", Rec."No.");
        purchLine.SetRange(type, purchLine.type::Item);
        if purchLine.FindSet() then
            exit(true)
        else
            exit(false);

    end;

    local procedure InsertStampLine(Rec: Record "purchase Header"; frais: Boolean)
    var

        GLSetup: Record "General Ledger Setup";

        RecLPurchLine: Record "Purchase Line";
        RecLPurchLine1: Record "Purchase Line";
        VarILineNo: Integer;
        Vend: record Vendor;

    begin
        Vend.get(rec."Buy-from Vendor No.");
        if Vend.Stamp then begin

            GLSetup.GET;
            GLSetup.TestField("Montant timbre fiscal");
            GLSetup.TestField("Frais timbre/Achat");
            GLSetup.TestField("Compte timbre/Achat");

            RecLPurchLine.RESET;
            RecLPurchLine.SETRANGE("Document Type", Rec."Document Type");
            RecLPurchLine.SETRANGE("Document No.", Rec."No.");
            if frais then begin
                RecLPurchLine.SETRANGE(RecLPurchLine.Type, RecLPurchLine.Type::"Charge (Item)");
                RecLPurchLine.SETRANGE(RecLPurchLine."No.", GLSetup."Frais timbre/Achat");
            end else begin
                RecLPurchLine.SETRANGE(RecLPurchLine.Type, RecLPurchLine.Type::"G/L Account");
                RecLPurchLine.SETRANGE(RecLPurchLine."No.", GLSetup."Compte timbre/Achat");
            end;
            IF RecLPurchLine.FIND('-') THEN BEGIN
                REPEAT
                    RecLPurchLine.DELETE;
                UNTIL RecLPurchLine.NEXT = 0;
            END;

            RecLPurchLine.RESET;
            RecLPurchLine.SETRANGE("Document Type", rec."Document Type");
            RecLPurchLine.SETRANGE("Document No.", Rec."No.");
            IF RecLPurchLine.FIND('-') THEN BEGIN
                IF RecLPurchLine.FINDLAST THEN
                    VarILineNo := RecLPurchLine."Line No." + 50;
                IF rec."Document Type" IN [rec."Document Type"::Invoice, rec."Document Type"::Order, rec."Document Type"::"Credit Memo",
                   rec."Document Type"::"Return Order"] THEN BEGIN
                    RecLPurchLine1.VALIDATE("Document Type", rec."Document Type");
                    RecLPurchLine1.VALIDATE("Document No.", rec."No.");
                    RecLPurchLine1."Line No." := VarILineNo;
                    if frais then begin
                        RecLPurchLine1.VALIDATE(Type, RecLPurchLine1.Type::"Charge (Item)");
                        RecLPurchLine1.VALIDATE("No.", GLSetup."Frais timbre/Achat");
                    end else begin
                        RecLPurchLine1.VALIDATE(Type, RecLPurchLine1.Type::"G/L Account");
                        RecLPurchLine1.VALIDATE("No.", GLSetup."Compte timbre/Achat");

                    end;
                    RecLPurchLine1.VALIDATE("Buy-from Vendor No.", rec."Buy-from Vendor No.");
                    RecLPurchLine1.Description := 'Timbre Fiscal Loi 93/53';
                    RecLPurchLine1.VALIDATE(Quantity, 1);
                    RecLPurchLine1.VALIDATE("Direct Unit Cost", GLSetup."Montant timbre fiscal");
                    RecLPurchLine1.INSERT;

                end;

                //Affectation du frais
                if RecLPurchLine1.Type = RecLPurchLine1.type::"Charge (Item)" then
                    if rec."DI No." = '' then
                        AffecterFrais(RecLPurchLine1)
                    else
                        AffecterFraisRecept(RecLPurchLine1);


            END;
        END;

    END;

    procedure AffecterFrais(recLPurchaseCharge: record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
        ItemChargePurch: record "Item Charge Assignment (Purch)";
        PurchaseItemLines: record "Purchase Line";
        NumLine: Integer;
        CUItemchargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        percent: Decimal;

        compteur: integer;
        Somme_percent: Decimal;
        Somme_ValueToAssig: Decimal;

    begin
        PurchaseHeader.get(recLPurchaseCharge."Document Type", recLPurchaseCharge."Document No.");
        PurchaseHeader.CalcFields(Amount);

        recLPurchaseCharge.TestField(Quantity, 1);

        PurchaseItemLines.SETRANGE("Document type", recLPurchaseCharge."document Type");
        PurchaseItemLines.SETRANGE("Document No.", recLPurchaseCharge."document No.");
        PurchaseItemLines.SETRANGE(Type, PurchaseItemLines.Type::Item);
        IF PurchaseItemLines.FINDFIRST THEN BEGIN
            NumLine := 0;
            REPEAT
                compteur += 1;
                percent := ROUND(PurchaseItemLines.amount / PurchaseHeader.Amount, 0.00001, '=');

                ItemChargePurch."Document Type" := recLPurchaseCharge."Document Type";
                ItemChargePurch."Document No." := recLPurchaseCharge."Document No.";
                ItemChargePurch."Document Line No." := recLPurchaseCharge."Line No.";
                ItemChargePurch."Line No." := NumLine + 10000;
                ItemChargePurch."Item Charge No." := recLPurchaseCharge."No.";
                ItemChargePurch.VALIDATE("Item No.", PurchaseItemLines."No.");
                if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
                    ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Order
                else
                    ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Invoice;
                ItemChargePurch."Applies-to Doc. No." := ItemChargePurch."Document No.";
                ItemChargePurch."Applies-to Doc. Line No." := PurchaseItemLines."Line No.";
                ItemChargePurch.validate("Unit Cost", recLPurchaseCharge."Direct Unit Cost");


                if compteur <> PurchaseItemLines.Count then begin
                    ItemChargePurch.Validate("Amount to Assign", recLPurchaseCharge.Amount * percent);
                    ItemChargePurch.Validate("Qty. to Assign", percent);
                    Somme_percent += percent;
                    Somme_ValueToAssig += ROUND(recLPurchaseCharge.Amount * percent);

                end
                else begin
                    ItemChargePurch.Validate("Amount to Assign", recLPurchaseCharge.Amount - Somme_ValueToAssig);
                    ItemChargePurch.Validate("Qty. to Assign", 1 - Somme_percent);



                end;

                ItemChargePurch.Insert();
                // message('Insertion et affectation Ligne %1 --> %2 %\%3', PurchaseItemLines."No.", percent, recLPurchaseCharge.Amount * percent);


                //ItemChargePurch.FindLast();
                NumLine := ItemChargePurch."Line No.";
            UNTIL PurchaseItemLines.NEXT = 0;

        END;
    end;

    procedure AffecterFraisRecept(recLPurchaseCharge: record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
        ItemChargePurch: record "Item Charge Assignment (Purch)";
        PurchaseItemLines: record "Purch. Rcpt. Line";
        NumLine: Integer;
        CUItemchargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        percent: Decimal;
        purchRecepHeader: record "Purch. Rcpt. Header";
        compteur: integer;
        Somme_percent: Decimal;
        Somme_ValueToAssig: Decimal;

    begin
        PurchaseHeader.get(recLPurchaseCharge."Document Type", recLPurchaseCharge."Document No.");
        purchRecepHeader.SetRange("DI No.", PurchaseHeader."DI No.");
        purchRecepHeader.FindFirst();

        recLPurchaseCharge.TestField(Quantity, 1);
        PurchaseItemLines.SETRANGE("Document No.", purchRecepHeader."No.");
        PurchaseItemLines.SETRANGE(Type, PurchaseItemLines.Type::Item);
        IF PurchaseItemLines.FINDFIRST THEN BEGIN
            NumLine := 0;
            REPEAT

                ItemChargePurch."Document Type" := recLPurchaseCharge."Document Type";
                ItemChargePurch."Document No." := recLPurchaseCharge."Document No.";
                ItemChargePurch."Document Line No." := recLPurchaseCharge."Line No.";
                ItemChargePurch."Line No." := NumLine + 10000;
                ItemChargePurch."Item Charge No." := recLPurchaseCharge."No.";
                ItemChargePurch.VALIDATE("Item No.", PurchaseItemLines."No.");
                ItemChargePurch."DI No." := purchRecepHeader."DI No.";

                ItemChargePurch."Applies-to Doc. Type" := ItemChargePurch."Applies-to Doc. Type"::Receipt;
                ItemChargePurch."Applies-to Doc. No." := ItemChargePurch."Document No.";
                ItemChargePurch."Applies-to Doc. Line No." := PurchaseItemLines."Line No.";
                ItemChargePurch.validate("Unit Cost", recLPurchaseCharge."Direct Unit Cost");
                CUItemchargePurch.CreateRcptChargeAssgnt(PurchaseItemLines, ItemChargePurch);

                CUItemchargePurch.AssignItemCharges(recLPurchaseCharge, recLPurchaseCharge.Quantity, recLPurchaseCharge."Line Amount", 1);
                ItemChargePurch.FindLast();
                NumLine := ItemChargePurch."Line No.";

            UNTIL PurchaseItemLines.NEXT = 0;

        END;
    end;


    procedure updateNGPOrigin(var purchOrderLine: Record "Purchase Line")
    var
        PurchReceipLine: Record "Purch. Rcpt. Line";

    begin
        if Confirm('Voulez -vous mettre à jour les NGP et origines dans la reception liée à la commande achat %1', false, purchOrderLine."Document No.") then begin
            purchOrderLine.FindFirst();
            repeat
                PurchReceipLine.Reset();
                PurchReceipLine.SetRange("Order No.", purchOrderLine."Document No.");
                PurchReceipLine.SetRange("Order Line No.", purchOrderLine."Line No.");
                if PurchReceipLine.FindFirst() then
                    PurchReceipLine."Tariff No." := purchOrderLine."Tariff No.";
                PurchReceipLine."Country region origin code" := purchOrderLine."Country region origin code";
                PurchReceipLine.Modify(true);
            until purchOrderLine.Next() = 0;
            Message('La mise à jour des NGP et Origine est réalisée avec succès');
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", OnbeforepostPurchaseDoc, '', false, false)]
    Procedure CheckTamponHeader(var PurchaseHeader: Record "Purchase Header")
    Var
        PurchL: record "Purchase Line";
    begin

        if PurchaseHeader."Currency Code" = '' then
            exit;
        If ((PurchaseHeader."Document Type" = "Purchase Document Type"::Order) and (PurchaseHeader.Receive)) or (PurchaseHeader."Document Type" = "purchase document type"::Invoice)

         then begin
            PurchL.setrange("Document Type", PurchaseHeader."Document Type");
            PurchL.SetRange("Document No.", PurchaseHeader."No.");
            PurchL.SetRange(Type, "Purchase Line Type"::Item);
            if PurchL.FindSet()
            then
                repeat
                    CheckTampon(PurchL);

                until PurchL.next() = 0;

        end;
    end;

    Procedure CheckTampon(PurchL: record "Purchase Line")
    var
        Location: record Location;
    begin
        Location.get(PurchL."Location Code");
        If location.Type <> location.Type::Tampon then
            error('Récéption impossible, type magasin est différent de "Tampon"');


    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line",
           OnAfterValidateEvent, "Location Code", false, false)]
    local procedure PurchaseLine_OnAfterValidateLocation(
           var Rec: Record "Purchase Line";
           xRec: Record "Purchase Line")
    begin
        // Si l'utilisateur avait déjà saisi un coût
        if xRec."Direct Unit Cost" <> 0 then begin
            // Et si BC l’a écrasé
            if Rec."Direct Unit Cost" <> xRec."Direct Unit Cost" then begin
                // Rec.Validate("Direct Unit Cost", xRec."Direct Unit Cost");
                rec.validate("Direct Unit Cost", xrec."Direct Unit Cost");
            end;
        end;

        if xRec."Line Discount %" <> 0 then begin
            // Et si BC l’a écrasé
            if Rec."Line Discount %" <> xRec."Line Discount %" then begin
                Rec.Validate("Line Discount %", xRec."Line Discount %");
            end;
        end;
        // rec.modify(false);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", OnBeforeDrillDown, '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var

        ImportFolder: Record "Import Folder";

    begin
        case DocumentAttachment."Table ID" of

            Database::"Import Folder":
                begin
                    RecRef.Open(DATABASE::"Import Folder");
                    if ImportFolder.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(ImportFolder);
                end;


        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", OnAfterOpenForRecRef, '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of

            DATABASE::"Import Folder":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnAfterInitFieldsFromRecRef, '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of

            DATABASE::"Import Folder":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;



    procedure CancelSalesPrice(Group: Code[25]; "No.": Code[25]; Date0: Date)
    var
        SalesPrice: Record "Price List Line";
    // SalesPriceLine: record "Price List Line";
    begin
        SalesPrice.RESET;
        SalesPrice.SETFILTER("Product No.", "No.");
        SalesPrice.SETRANGE("Source Type", SalesPrice."Source Type"::"Customer Price Group");
        SalesPrice.setrange("Source No.", Group);

        IF SalesPrice.FINDFIRST THEN
            REPEAT
                IF SalesPrice."Starting Date" = 0D THEN
                    ERROR('Date début est nulle dans la quantitative %1', "No.");


                IF (SalesPrice."Ending Date" = 0D) OR (SalesPrice."Ending Date" >= TODAY) THEN BEGIN
                    SalesPrice."Ending Date" := CALCDATE('<-1D>', Date0);
                    SalesPrice.Status := SalesPrice.Status::Inactive;
                    SalesPrice.Modify();
                END;
            UNTIL SalesPrice.NEXT = 0;



    end;


    procedure InsertSalesPrice(Group: Code[25]; "No.": Code[25]; Date0: Date; Price: Decimal)
    var
        SalesPrice: Record "Price List Line";
        SalesPriceHeader: Record "Price List header";
        SalesPriceLine: record "Price List Line";
        ItemRec: Record Item;

    begin

        SalesPriceHeader.SetRange("Source Type", SalesPriceHeader."Source Type"::"Customer Price Group");
        SalesPriceHeader.setrange("Source No.", Group);

        if SalesPriceHeader.FindFirst() then begin
            clear(SalesPrice);
            SalesPrice.init();
            SalesPrice."Source Type" := SalesPrice."Source Type"::"Customer Price Group";
            SalesPrice.validate("Source No.", Group);
            SalesPrice.validate("Product No.", "No.");
            SalesPrice.Validate("Starting Date", Date0);
            SalesPrice.validate("Ending Date", 0D);
            SalesPrice.Validate("Allow Invoice Disc.", false);
            SalesPrice.validate("Minimum Quantity", 1);
            SalesPrice.Validate(Status, SalesPrice.Status::Active);//By AM
            SalesPrice.Validate("Prix standard", Price);// BY AM 230126
            SalesPrice.Validate("Price List Code", SalesPriceHeader.Code);


            if not SalesPrice.Insert() then begin
                message('SalesPrice n''est pas inserée');
                modifySalesPrice(Group, "No.", Date0, Price);


            end;
            SalesPrice.Verify();
            // ItemRec.get("No.");
            // ItemRec.InsertArchivePrix(Group, Price);



        end
        else
            message('vous devez créer une liste des prix pour le group %1', group);

    end;

    procedure ModifySalesPrice(Group: Code[25]; "No.": Code[25]; Date0: Date; Price: Decimal)
    var
        SalesPrice: Record "Price List Line";
        SalesPriceHeader: Record "Price List header";
        SalesPriceLine: record "Price List Line";
        item: Record item;
    begin
        if item.get("No.") then begin
            if SalesPrice.get("No.", SalesPrice."Source Type"::"Customer Price Group", Group, date0, '', '', item."Sales Unit of Measure", 1) then begin
                SalesPrice.Validate("Prix standard", Price);// AM 23012026
                SalesPrice."Ending Date" := 0D;
                SalesPrice.Status := SalesPrice.Status::active;//By AM
                SalesPrice.Modify();
            end;
        end;
    end;

    procedure UpdateShipmtNoReception(OrderNo: Code[20]; ShipmentCA: Code[20])
    var
        ReceiptHeader: Record "Purch. Rcpt. Header";
    begin

        ReceiptHeader.SetCurrentKey("Order No.");
        ReceiptHeader.SetRange("Order No.", OrderNo);
        ReceiptHeader.Modifyall("Vendor Shipment No.", ShipmentCA);

    end;

    procedure UpdateDocInExtractReceipt(Reception: Code[20]; Line: Integer)
    var
        RecLine: Record "Purch. Rcpt. Line";
        Order: Record "Purchase Header";
        RecHeader: Record "Purch. Rcpt. Header";
    begin
        RecLine.get(Reception, Line);
        RecHeader.get(Reception);
        if RecHeader."Order No." = '' then exit;

        Order.get(Order."Document Type"::Order, RecHeader."Order No.");

        RecLine.Order := RecHeader."Order No.";
        RecLine."Vendor Shipment No." := Order."Vendor Shipment No.";
        RecLine.Modify();

    end;


}