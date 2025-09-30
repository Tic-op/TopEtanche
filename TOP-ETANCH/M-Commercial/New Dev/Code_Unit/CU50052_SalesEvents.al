codeunit 50052 SalesEvents
{
    Permissions = tabledata "Item Ledger Entry" = rimd, tabledata "Sales Shipment Header" = m, tabledata "Sales Shipment Line" = m;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostLines, '', false, false)]
    procedure "control facture"(SalesHeader: Record "Sales Header")
    var
        customer: Record Customer;
        salesLine: Record "Sales Line";
        totalAmount: Decimal;
        blanketS: Record "Sales Line";
        InvSalesLine: Record "Sales Line";
        totalQty: Decimal;
        Qtyrestante: Decimal;
        totalQtyOrdered: Decimal;

    //commandecadre: record "Sales Header";
    begin
        //Message('%1, %2 , ', SalesHeader."Document Type", SalesHeader."No.");

        // if not SalesHeader.Invoice then
        //exit;

        case SalesHeader."Type de facturation" of
            SalesHeader."Type de facturation"::"Contre remboursement":
                begin
                    if not SalesHeader.Invoice then
                        Error('Veuillez expédier et facturer');
                end;
            SalesHeader."Type de facturation"::"Fact. Mensuelle":
                begin
                    if SalesHeader.Invoice and (SalesHeader."Document Type" = SalesHeader."Document Type"::order) then
                        Error('Vous ne pouvez facturer qu''à la fin du mois');
                end;
            SalesHeader."Type de facturation"::"Fact. Plafond":
                begin
                    if customer.Get(SalesHeader."Sell-to Customer No.") then begin
                        // SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                        // SalesLine.SetRange("Document No.", SalesHeader."No.");
                        //salesLine.setrange(Type, salesLine.Type::Item);
                        //salesLine.SetAutoCalcFields("Amount Including VAT");
                        // salesLine.CalcFields("Amount Including VAT");//***

                        // totalAmount := SalesLine."Total TTC (Total expédiée)";
                        //if totalAmount < customer.Seuil then


                        // Error('Le montant total doit dépasser le seuil facturation Client');

                        SalesHeader.CalcFields("Amount Including VAT");
                        if SalesHeader."Amount Including VAT" + SalesHeader."Stamp Amount" < customer.Seuil then
                            Error('Le montant total doit dépasser le seuil facturation Client');
                    end;
                end;

            SalesHeader."Type de facturation"::"Commande Totale":
                begin
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
                        if SalesHeader.Invoice then
                            Error('Vous ne pouvez pas facturer cette commande qu''à partir de la commande cadre');
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin

                        InvSalesLine.setrange("Document Type", InvSalesLine."Document Type"::Invoice);
                        InvSalesLine.SetRange("Document No.", SalesHeader."No.");
                        InvSalesLine.setrange(Type, InvSalesLine.Type::Item);
                        if InvSalesLine.FindFirst() then
                             repeat begin
 
                                 // message('%1', InvSalesLine."Blanket Order No.");
                                 salesLine.setrange("Document Type", salesLine."Document Type"::"Blanket Order");
                                 salesLine.setrange("Document No.", InvSalesLine."Blanket Order No.");
                                 //salesLine.setrange("Sales Document Type"::"Blanket Order", salesLine."Blanket Order No.");
                                 //  commandecadre.SetAutoCalcFields(commandecadre."Completely Shipped");
                                 //Error('%1', salesLine.count);
                                 salesLine.SetRange("Completely Shipped", false);
                                 //Error('%1', salesLine.count);
                                 if salesLine.findfirst then
                                     // if not commandecadre."Completely Shipped" then
                                     error('La commande n''est pas totalement livrée');
 
                             end;
                            until InvSalesLine.next = 0;
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", OnAfterRun, '', false, false)]

    procedure CopieBlanketSalesOrderNumberToSalesOrder(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
    begin
        SalesOrderHeader."Blanket Order No." := SalesHeader."No.";
        SalesOrderHeader."Location Code" := SalesHeader."Location Code";
        SalesOrderHeader.Modify();
        InsertApprobation(SalesOrderHeader);

    end;





    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", OnBeforeInsertSalesOrderHeader, '', false, false)]
    procedure CopyLocationCodeFromBlanketOrderToSalesOrder(SalesOrderHeader: Record "Sales Header"; var BlanketOrderSalesHeader: Record "Sales Header")
    begin

        //SalesOrderHeader.validate("Location Code", BlanketOrderSalesHeader."Location Code");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Invoice", OnBeforeOnRun, '', false, false)]
    Procedure CheckConditionsbeforeQuotetoinvoice(var SalesHeader: Record "Sales Header")
    var
    begin
        CheckConditions(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", OnBeforeOnRun, '', false, false)]

    Procedure CheckConditionsbeforeQuotetoOrder(var SalesHeader: Record "Sales Header")
    var
    begin
        CheckConditions(SalesHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", OnBeforeInsertSalesOrderHeader, '', false, false)]
    procedure AffecterSoucheBLFromQuote(var SalesOrderHeader: Record "Sales Header")
    var
    begin
        AffecterSoucheBL(SalesOrderHeader);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Invoice", OnCreateSalesInvoiceHeaderOnBeforeSalesInvoiceHeaderInsert, '', false, false)]
    Procedure affecterSoucheInvoice(var SalesInvoiceHeader: Record "Sales Header")
    var
        seriesMgt: Codeunit "No. Series";
        SalesSetup: record "Sales & Receivables Setup";
    begin
        SalesSetup.get();
        if not SalesSetup."Utiliser Pré-Facture" then exit;
        SalesInvoiceHeader."No." := seriesMgt.GetNextNo(SalesSetup."Posted Invoice Nos.");
        SalesInvoiceHeader."Posting No." := SalesInvoiceHeader."No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", OnBeforeRun, '', false, false)]
    Procedure CheckConditions(var SalesHeader: Record "Sales Header")
    var
    begin
        CheckBlocageClient(SalesHeader);
        ControlVentecomptoir(SalesHeader);
        CheckSuspension(SalesHeader);
        CheckDispo(SalesHeader);
        CheckCustomerCredit(SalesHeader);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", OnBeforeCreateSalesHeader, '', false, false)]
    Procedure AffecterSoucheBL(var OrderSalesHeader: Record "Sales Header")
    var
        seriesMgt: Codeunit "No. Series";
        SalesSetup: record "Sales & Receivables Setup";
    begin
        SalesSetup.get();
        if not SalesSetup."Utiliser Pré-BL" then exit;
        OrderSalesHeader."No." := seriesMgt.GetNextNo(SalesSetup."Posted Shipment Nos.");
        OrderSalesHeader."Shipping No." := OrderSalesHeader."No.";

    end;

    procedure CheckCustomerCredit(var SalesHeader: Record "Sales Header")
    var
        Cust: record Customer;
    begin
        //  message('Check customer Credit');
        // Cust.SetLoadFields("No."); Cust.calcrestant ne fonctionne plus je pense qu'il faut importer tout les champs que calcrestant() utilise car la procedure s'execute au niveu du record pas la table
        Cust.get(SalesHeader."Sell-to Customer No.");
        SalesHeader.CalcFields("Amount Including VAT");
        if (SalesHeader."Amount Including VAT" + SalesHeader."Stamp Amount") > cust.CalcRestant() then Error('Montant supérieur aux solde client');



    end;


    procedure CheckDispo(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        AvailableQty: Decimal;
        item: Record Item;

    begin



        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        if SalesLine.FindFirst() then
            repeat
                // if item.get(SalesLine."No.") then
                AvailableQty := SalesLine.GetDisponibilite(false);
                if SalesLine."Qty. to Ship" > AvailableQty then
                    Error('Vous ne pouvez pas passer cette commande car l''article "%1" n''a pas suffisamment de disponibilité en stock.', SalesLine."No.");

            until SalesLine.Next() = 0;
    end;

    procedure CheckBlocageClient(var SalesHeader: Record "Sales Header")
    var
        Customer: record Customer;
    begin
        if Customer.get(SalesHeader."Sell-to Customer No.") then begin
            if customer."Cause du blocage" <> Customer."Cause du blocage"::"Non bloqué" then
                error('Client bloqué :: cause du blocage "%1"', Customer."Cause du blocage");
        end;
    end;


    procedure InsertApprobation(var SalesOrderHeader: Record "Sales Header") /// By AM 020425
    var
        contact: record contact;
        ContactApprobation: record ContactApprobation;
    begin
        //  message('insert approbation');
        contact.setrange("No Organisation", SalesOrderHeader."Sell-to Customer No.");
        contact.SetRange("Approuver Vente", true);
        contact.SetFilter("Organizational Level Code", '<>%1', '');
        if Contact.findfirst() then
            repeat
                ContactApprobation.init();
                ContactApprobation."Order No." := SalesOrderHeader."No.";
                ContactApprobation."Organizational Level Code" := contact."Organizational Level Code";
                ContactApprobation."Customer No." := SalesOrderHeader."Sell-to Customer No.";
                if ContactApprobation.insert(true) then;
            until Contact.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"sales-post", OnBeforePostSalesDoc, '', false, false)]
    Procedure ONbeforePost(var SalesHeader: Record "Sales Header")
    var
    begin
        CheckBlocage(SalesHeader);
        CheckApprobation(SalesHeader);
        ControlSource(SalesHeader);//Momentary
        StampEvent(SalesHeader);


    end;
    procedure CheckBlocage(var SalesHeader: Record "Sales Header")
    var
        Customer: record Customer;
    begin

        if SalesHeader.ship and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            if Customer.get(SalesHeader."Sell-to Customer No.") then
                if Customer."Cause du blocage" <> Customer."Cause du blocage"::"Non bloqué" then
                    error('Expédition non autorisée, Client Bloqué à cause de %1', Customer."Cause du blocage")
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]

    Procedure CheckApprobation(var SalesHeader: Record "Sales Header")
    var
        ContactApprobation: record ContactApprobation;
    begin
        ContactApprobation.SetRange("Order No.", SalesHeader."No.");
        if ContactApprobation.findfirst() then
            repeat
                if ContactApprobation."Contact " = '' then error('Veuillez mettre à jour la liste des Approbations');
                if ContactApprobation.Via = ContactApprobation.via::" " then error('le %1 %2 du Client %2  n''a pas encore approuvé l''éxpédition', ContactApprobation."Organizational Level Code", ContactApprobation."Contact ", ContactApprobation."Customer No.");

            until ContactApprobation.next = 0;

    end;

    procedure ControlContact(var SalesHeader: Record "Sales Header")
    var
        Contact: record contact;
        Cont1: record contact;

    begin
        if SalesHeader.Invoice then begin
            Contact.get(SalesHeader."Bill-to Contact No.");
            Cont1.SetCurrentKey("Company No.");
            Cont1.setrange("Company No.", contact."Company No.");
            cont1.setrange(Type, "Contact Type"::Person);
            cont1.SetRange("Approuver Vente", true);
            if cont1.findfirst() then
                repeat
                    IF CONFIRM('Veuillez informer le contact %1 avant de facturer', FALSE, cont1.Name) then begin

                    end
                    else
                        error('error');
                until Cont1.Next() = 0;


        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostInvoice, '', false, false)]
    Procedure ControlFacturation(var SalesHeader: Record "Sales Header")
    var
    begin
        MinimumAfacturer(SalesHeader);


    end;

    Procedure ControlSource(var SalesHeader: Record "Sales Header")
    var
    begin

        if (SalesHeader."Blanket Order No." = '') and (SalesHeader."Quote No." = '') then begin

            //Peut être le traitement = f(Typefacturation) 
            Error('ce document n''a pas été issu ni d''un devis ni d''une commande cadre , veuillez respecter le process vente défini.');

        end


    end;
    procedure MinimumAfacturer(var SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
    begin

        if customer.get(SalesHeader."Sell-to Customer No.") then begin
            if Customer."Type de facturation" = Customer."Type de facturation"::"Fact. Plafond" then begin
                Customer.CalcFields(customer."Shipped Not Invoiced");
                if Customer."Shipped Not Invoiced" < Customer.Seuil then
                    Error('Le montant total doit dépasser le seuil de facturation client');
            end;
        end;
    end;




    local procedure GetRemainingQtyFromItemLedgerEntries(var ILE_EntryNo: integer; ItemNo: Code[25];
   LocationCode: code[25]; var QteRestante: Decimal; var previousLotNo: Code[50]; var previousExperiationDate: Date; var All_previousLotNo: Text): Boolean
    var
        ILE: Record "Item Ledger Entry";
        TotalRestant: Decimal;
        ILE0: Record "Item Ledger Entry";
        reservedQty: Decimal;

    begin
        ILE_EntryNo := 0;
        // ILE.setfilter("Entry No.", '>%1', entryNo);
        ILE.SetCurrentKey("Item No.", Positive, "Location Code", "Variant Code");
        ile.SetFilter("Item No.", ItemNo);
        ile.SetRange(Positive, true);
        ILE.SetFilter("Location Code", LocationCode);
        ile.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.", "Package No.");
        ILE.SetRange(Open, true);
        ILE.SetCurrentKey("Lot No.");
        //ILE.SetFilter("Lot No.", '<>%1&<>%2', All_previousLotNo, '');
        if All_previousLotNo <> '' then
            ILE.SetFilter("Lot No.", All_previousLotNo)
        else
            ILE.SetFilter("Lot No.", '<>%1', '');


        ILE.SetCurrentKey("Expiration Date", "Item No.");
        ILE.SetFilter("Expiration Date", '>=%1|%2', previousExperiationDate, 0D);


        //if ItemNo = 'NA100' then
        //Message('Lines Found %1', ILE.count);
        if ILE.FindFirst() then begin

            ILE0.SetCurrentKey("Item No.", Positive, "Location Code", "Variant Code");
            ILE0.SetFilter("Item No.", ItemNo);
            ILE0.SetRange(Positive, true);
            ILE0.SetFilter("Location Code", LocationCode);
            ILE0.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.", "Package No.");
            ILE0.SetRange(Open, true);
            ILE0.SetCurrentKey("Lot No.");
            ILE0.setrange("Lot No.", ile."Lot No.");

            ILE0.SetCurrentKey("Expiration Date", "Item No.");
            ILE0.SetRange("Expiration Date", ILE."Expiration Date");
            ILE0.CalcSums("Remaining Quantity");


            TotalRestant := 0;
            reservedQty := ReservedQty(ItemNo, ILE."Lot No.", LocationCode);
            if reservedQty <= ILE0."Remaining Quantity" then
                TotalRestant := ILE0."Remaining Quantity" - reservedQty;


            if QteRestante <= TotalRestant then
                QteRestante := 0
            else
                QteRestante := QteRestante - TotalRestant;
            if All_previousLotNo = '' then
                All_previousLotNo := '<>' + ILE."Lot No."
            else
                All_previousLotNo := All_previousLotNo + '&<>' + ILE."Lot No.";

            ILE_EntryNo := ILE."Entry No.";
            previousLotNo := ILE."Lot No.";
            previousExperiationDate := ILE."Expiration Date";
            exit(true); //Lot trouvé
        end;
        exit(false);//Lot non trouvé
    end;



    procedure AssignLotNoToSalesOrder(DocType: Enum "Sales Document Type"; DocNo: Code[25])
    var
        SalesLine: Record "Sales Line";


        QteRestante: Decimal;
        QteReserve: Decimal;
        previousLotNo: Code[50];
        previousExperiationDate: Date;
        FindLotNo: Boolean;
        All_LotNo: Text;
        item: Record Item;
        ILE_EntryNo: Integer;
        itemTracking: record "Item Tracking Code";
        LotM: codeunit "Lot Management";
        dd: Codeunit 22;

    begin
        if DocType <> DocType::Order then  //maybe can accepted when it s an invoice
            exit;

        SalesLine.SetRange("Document Type", DocType);
        SalesLine.SetFilter("document No.", DocNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Qty. to Ship", '<>0');

        SalesLine.FindFirst();
        repeat
            item.get(SalesLine."No.");
            if item."Item Tracking Code" <> '' then begin
                /*   itemTracking.get(item."Item Tracking Code"); // #AM 
                  if itemTracking."Lot Warehouse Tracking" then begin //    affectation des lots en cas de suivie emplacement 
                      LotM.AffecterNoLot(SalesLine);

                      SalesLine.Next();
                  end;// // #end AM    */
                DeleteReservationEntry(SalesLine);
                QteRestante := SalesLine."Qty. to Ship";
                previousLotNo := '';
                previousExperiationDate := Today;
                All_LotNo := '';
                repeat
                    QteReserve := QteRestante;
                    FindLotNo := GetRemainingQtyFromItemLedgerEntries(ILE_EntryNo, SalesLine."No.", SalesLine."Location Code", QteRestante, previousLotNo, previousExperiationDate, All_LotNo);
                    if FindLotNo then begin
                        QteReserve := QteReserve - QteRestante;
                        InsertReservationEntry(ILE_EntryNo, SalesLine, previousLotNo, previousExperiationDate, QteReserve);
                    end;
                until (QteRestante = 0) OR not FindLotNo;

                if not FindLotNo then
                    Message('Attention !!! \Pas de lot à affecter pour %1 de %2  \Magasin %3', QteRestante, SalesLine."No.", SalesLine."Location Code");


            end;
        until SalesLine.next = 0;

        Message('Des lots ont été affectés...');
    end;





    local procedure InsertReservationEntry(ILE_EntryNo: Integer; SalesLine: Record "Sales Line"; LotNo: code[50]; ExperiationDate: Date; QtyToInsert: Decimal)
    var
        ReservationEntry: Record "Reservation Entry";
        BinC: record "Bin Content";


    begin





        //if SalesLine."No." = 'NA100' then
        //Message('Insertion %1', QtyToInsert);
        ReservationEntry.Init();
        ReservationEntry."Source Type" := DATABASE::"Sales Line";
        ReservationEntry."Source Subtype" := SalesLine."Document Type".AsInteger();
        ReservationEntry."Source ID" := SalesLine."Document No.";
        ReservationEntry."Source Ref. No." := SalesLine."Line No.";
        ReservationEntry."Item No." := SalesLine."No.";
        ReservationEntry."Variant Code" := SalesLine."Variant Code";
        ReservationEntry."Location Code" := SalesLine."Location Code";
        ReservationEntry."Bin Code" := SalesLine."Bin Code";

        ReservationEntry.validate("Quantity (Base)", -QtyToInsert);
        ReservationEntry."Lot No." := LotNo;
        ReservationEntry."Expiration Date" := ExperiationDate;

        //ReservationEntry.validate("Appl.-to Item Entry", ILE_EntryNo);  by AM 160125
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
        ReservationEntry."Created By" := UserId;//TICOP
        ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        ReservationEntry."Creation Date" := today;
        ReservationEntry.insert;
    end;






    procedure DeleteReservationEntry(SalesLine: Record "Sales Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        //Message('Suppression réservation lot...');
        ReservationEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
        ReservationEntry.SetFilter("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetFilter("Item No.", SalesLine."No.");
        ReservationEntry.SetFilter("Location Code", SalesLine."Location Code");
        if ReservationEntry.FindFirst() then
            ReservationEntry.DeleteAll();
    end;






    procedure ReservedQty(ItemNo: Code[25]; LotNo: Code[50]; LocationCode: Code[25]): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin

        ReservationEntry.SetFilter("Item No.", ItemNo);
        ReservationEntry.SetRange("Lot No.", LotNo);
        ReservationEntry.SetFilter("Location Code", LocationCode);

        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Surplus);

        ReservationEntry.SetRange("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        ReservationEntry.SetFilter("Quantity (Base)", '<0');

        if ReservationEntry.FindFirst() then
            ReservationEntry.CalcSums("Quantity (Base)");


        // if ItemNo = 'NA100' then
        // Message('déja reservé %1', ReservationEntry."Quantity (Base)");

        exit(-ReservationEntry."Quantity (Base)")
    end;



    procedure AssignLotNoToSalesOrderLine(var SalesLine: record "Sales Line")
    var

        QteRestante: Decimal;
        QteReserve: Decimal;
        previousLotNo: Code[50];
        previousExperiationDate: Date;
        FindLotNo: Boolean;
        All_LotNo: Text;
        item: Record Item;
        ILE_EntryNo: Integer;
        itemTracking: record "Item Tracking Code";
        LotM: codeunit "Lot Management";

    begin

        if SalesLine."Document Type" <> "Sales Document Type"::order then  //maybe can accepted when it s an invoice
            exit;
        if SalesLine.Type <> "Sales Line Type"::Item then
            exit;

        if SalesLine."Qty. to Ship" = 0 then
            exit;



        item.get(SalesLine."No.");
        if item."Item Tracking Code" <> '' then begin
            itemTracking.get(item."Item Tracking Code");
            if itemTracking."Lot Warehouse Tracking" or (SalesLine."Bin Code" <> '') then exit;


            DeleteReservationEntry(SalesLine);
            QteRestante := SalesLine."Qty. to Ship";
            previousLotNo := '';
            previousExperiationDate := Today;
            All_LotNo := '';
            repeat
                QteReserve := QteRestante;
                FindLotNo := GetRemainingQtyFromItemLedgerEntries(ILE_EntryNo, SalesLine."No.", SalesLine."Location Code", QteRestante, previousLotNo, previousExperiationDate, All_LotNo);
                if FindLotNo then begin
                    QteReserve := QteReserve - QteRestante;
                    InsertReservationEntry(ILE_EntryNo, SalesLine, previousLotNo, previousExperiationDate, QteReserve);
                end;
            until (QteRestante = 0) OR not FindLotNo;

            if not FindLotNo then
                Message('Attention !!! \Pas de lot à affecter pour %1 de %2  \Magasin %3', QteRestante, SalesLine."No.", SalesLine."Location Code");



        end;



    end;



    [EventSubscriber(ObjectType::Codeunit, codeunit::"sales-post", OnbeforePostSalesDoc, '', false, false)]
    procedure StampEvent(SalesHeader: Record "Sales Header")
    var
        i: Enum "Sales Document Status";
        SalesLine: Record 37;
    begin
        if SalesHeader."Currency Code" <> '' then exit;
        // if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (not SalesHeader."Prise en charge") then // AM 05/11/24
        // error('Veuillez valider la préparation à livrer avant de valider la commande'); // AM 05/11/24

        SalesHeader.Status := SalesHeader.Status::Open;

        //   if SalesHeader.Invoice and not SalesHeader.Ship and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then
        //     error('Pour facturer un BL déjà livré, passez par une facture Vente puis regoupez les Expéditions');


        if (SalesHeader.Invoice and SalesHeader.Ship and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) then begin
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            SalesLine.SetFilter("Qty. to Ship", '<>0');
            if not SalesLine.FindFirst() then
                Error('Pas de lignes à expédier !');

        end;
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) then
            InsertStampLine(SalesHeader);
        //Message('%1--%2--%3', SalesHeader.Invoice, SalesHeader.Ship, SalesHeader."Document Type");

        if ((SalesHeader.Invoice and SalesHeader.Ship) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) then
            InsertStampLine(SalesHeader);



    end;

    procedure InsertStampLine(Rec: Record "Sales Header")
    var

        GLSetup: Record "General Ledger Setup";
        Customer: Record Customer;
        RecLSalesLine: Record "Sales Line";
        RecLSalesLine1: Record "Sales Line";
        VarILineNo: Integer;
        GLAccount: Record 15;
    begin

        GLSetup.GET;
        GLSetup.TestField("Montant timbre fiscal");
        GLSetup.TestField("Compte timbre fiscal");
        Customer.get(Rec."Bill-to Customer No.");

        IF Customer.Stamp THEN BEGIN
            RecLSalesLine.RESET;
            RecLSalesLine.SETRANGE("Document Type", Rec."Document Type");
            RecLSalesLine.SETRANGE("Document No.", Rec."No.");
            RecLSalesLine.SETRANGE(RecLSalesLine.Type, RecLSalesLine.Type::"G/L Account");
            RecLSalesLine.SETRANGE(RecLSalesLine."No.", GLSetup."compte timbre fiscal");
            IF RecLSalesLine.FIND('-') THEN BEGIN
                REPEAT
                    RecLSalesLine.DELETE;
                UNTIL RecLSalesLine.NEXT = 0;
            END;

            RecLSalesLine.RESET;
            RecLSalesLine.SETRANGE("Document Type", Rec."Document Type");
            RecLSalesLine.SETRANGE("Document No.", Rec."No.");
            IF RecLSalesLine.FIND('-') THEN BEGIN
                IF RecLSalesLine.FINDLAST THEN
                    VarILineNo := RecLSalesLine."Line No." + 50;
                IF rec."Document Type" IN [rec."Document Type"::Invoice, rec."Document Type"::Order, rec."Document Type"::"Credit Memo",
                   rec."Document Type"::"Return Order"] THEN BEGIN
                    RecLSalesLine1.VALIDATE("Document Type", rec."Document Type");
                    RecLSalesLine1.VALIDATE("Document No.", rec."No.");
                    RecLSalesLine1."Line No." := VarILineNo;
                    RecLSalesLine1.VALIDATE(Type, RecLSalesLine1.Type::"G/L Account");

                    RecLSalesLine1.VALIDATE("No.", GLSetup."compte timbre fiscal");
                    RecLSalesLine1.VALIDATE("Sell-to Customer No.", rec."Sell-to Customer No.");
                    RecLSalesLine1.VALIDATE("Location Code", rec."Location Code");
                    RecLSalesLine1.Description := 'Timbre Fiscal Loi 93/53';
                    RecLSalesLine1.VALIDATE(Quantity, 1);

                    GLAccount.GET(GLSetup."compte timbre fiscal");
                    ///160125    by OD et AM
                    IF rec."Document Type" IN [rec."Document Type"::"Credit Memo",
                   rec."Document Type"::"Return Order"] THEN
                        RecLSalesLine1.VALIDATE("Unit Price", -GLSetup."Montant timbre fiscal")
                    else
                        RecLSalesLine1.VALIDATE("Unit Price", GLSetup."Montant timbre fiscal");
                    RecLSalesLine1."VAT Prod. Posting Group" := GLAccount."VAT Prod. Posting Group";
                    RecLSalesLine1."Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                    RecLSalesLine1."VAT Bus. Posting Group" := rec."VAT Bus. Posting Group";
                    RecLSalesLine1."Gen. Bus. Posting Group" := rec."Gen. Bus. Posting Group";

                    RecLSalesLine1.INSERT;
                END;
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Report, Report::"Combine Shipments", OnAfterInsertSalesInvHeader, '', false, false)]
    procedure insertstamp(var SalesHeader: Record "Sales Header")

    var
        salesevent: Codeunit 50052;

    begin

        salesevent.InsertStampLine(SalesHeader);



    end;

    procedure ControlVentecomptoir(var SalesHeader: Record "Sales Header")
    var
        SalesL: record "Sales Line";
    begin
        If SalesHeader."Vente comptoir" then begin
            SalesL.setrange("Document Type", SalesHeader."Document Type");
            salesL.setrange("Document No.", SalesHeader."No.");
            if SalesL.FindFirst() then
                repeat
                    SalesL.CalcFields("Qty in Orders");
                    SalesL.TestField("Qty in Orders", 0);
                    SalesL.TestField("Location Code", SalesHeader."Location Code");
                    SalesL.TestField("Bin Code", '');
                    SalesL.TestField("Qty. to Ship (Base)", SalesL."Quantity (Base)");
                until SalesL.next = 0;
        end

    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Item Jnl.-Post Line", OnBeforePostItemJnlLine, '', false, false)]
    procedure ControlMouvementDépot(var ItemJournalLine: Record "Item Journal Line")
    var
        location: record Location;
        item: Record item;
    begin
        if location.get(ItemJournalLine."Location Code") then begin  /// Magasin n'existe pas dans le cas d'un transfert AM
            if location.Type = location.type::"Dépot" then begin
                item.get(ItemJournalLine."Item No.");
                item."ControlUnitéDépot"(ItemJournalLine."Quantity (Base)", ItemJournalLine."Location Code");
            end;
        end;
    end;


    procedure CheckSuspension(SalesHeader: Record "Sales Header")
    var
        CPP: Record "Customer Posting Group";
        Customer: record Customer;
    begin
        if SalesHeader."Document Type" = "Sales Document Type"::"Blanket Order" then begin
            Customer.get(SalesHeader."Sell-to Customer No.");
            CPP.get(SalesHeader."Customer Posting Group");
            if SalesHeader."Customer Posting Group" = customer."Customer Posting Group" then begin

                if CPP.Suspension then begin
                    if not SalesHeader."Documents vérifiés" then
                        error('Veuillez vérifier les documents du clients ou bien changer le group client %1 pour cette affaire ', CPP.Code);

                end
            end


        end


    end;

    procedure ArchiveDevis(noDevis: text) //IS12092025
    var
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesHeader: Record "Sales Header";
    begin

        if SalesHeader.get(SalesHeader."Document Type"::Quote, noDevis) then
            //Error('Devis introuvable');
        ArchiveManagement.StoreSalesDocument(SalesHeader, false);
    end;

}