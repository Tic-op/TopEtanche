namespace Top.Top;
using Microsoft.Sales.Document;

codeunit 50019 "BO Extraction Handler"
{

    Subtype = Normal;

    procedure ExtractFromBlanketOrdersWithMessage(
        CustomerNo: Code[20];
        CurrentOrderNo: Code[20];
        ExtractFromCurrentOrderOnly: Boolean; // true = only blanket lines of current order; false = all customer lines
        InsertInCurrentOrder: Boolean) // true = insert in current order; false = create new order
    var

        SalesLine, BlanketLine : Record "Sales Line";
        SalesHeader, NewOrder, BlanketOrderHeader : Record "Sales Header";
        QtyAvailable: Decimal;
        QtyNeeded: Decimal;
        QtyToInsert: Decimal;
        NewOrderCreated: Boolean;
        LinesInserted: Integer;
        CreatedOrderNo: Code[20];
        Response: Integer;
        Cu: Codeunit 87;

    begin
        NewOrderCreated := false;
        CreatedOrderNo := '';
        LinesInserted := 0;

        // 1️⃣ Filter blanket order lines
        BlanketLine.setrange("Document Type", "Sales Document Type"::"Blanket Order");
        BlanketLine.SetRange("Sell-to Customer No.", CustomerNo);
        if ExtractFromCurrentOrderOnly then
            BlanketLine.SetRange("Document No.", CurrentOrderNo);

        if not BlanketLine.FindSet() then begin
            Message('Aucune ligne commande cadre vente trouvée');
            exit;
        end;

        // 2️⃣ Loop through blanket lines
        repeat
            BlanketOrderHeader.Reset();
            if (not BlanketOrderHeader.get(BlanketLine."Document Type", BlanketLine."Document No.")) or
             (BlanketOrderHeader."Type de facturation" = BlanketOrderHeader."Type de facturation"::"Commande Totale")
            then
                continue;
            QtyAvailable := BlanketLine.GetDisponibilite(true);
            QtyNeeded := BlanketLine.Quantity;

            // Determine quantity to insert
            if QtyAvailable < QtyNeeded then
                QtyToInsert := QtyAvailable
            else
                QtyToInsert := QtyNeeded;

            if QtyToInsert > 0 then begin
                // 3️⃣ Insert line in target order
                if InsertInCurrentOrder then begin
                    SalesLine.Init();
                    SalesLine := BlanketLine;
                    SalesLine.Validate("Document Type", "Sales Document Type"::Order);
                    SalesLine.Validate("Document No.", CurrentOrderNo);
                    // SalesLine.Type := SalesLine.Type::Item;
                    //SalesLine.Validate("No.", BlanketLine."No.");
                    SalesLine.Validate(Quantity, QtyToInsert);
                    SalesLine."Line No." := SalesLine.GetLastLineNo() + 10000;

                    SalesLine.Insert();
                end
                else begin
                    if not NewOrderCreated then begin
                        SalesHeader.Init();
                        SalesHeader."Document Type" := "Sales Document Type"::Order;
                        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
                        SalesHeader.Insert(true);
                        CreatedOrderNo := SalesHeader."No.";
                        NewOrderCreated := true;
                    end;

                    SalesLine.Init();
                    SalesLine := BlanketLine;
                    SalesLine.Validate("Document Type", "Sales Document Type"::Order);
                    SalesLine.Validate("Document No.", CreatedOrderNo);
                    // SalesLine.Type := SalesLine.Type::Item;
                    //  SalesLine.Validate("No.", BlanketLine."No.");
                    SalesLine.Validate(Quantity, QtyToInsert);

                    SalesLine."Line No." := SalesLine.GetLastLineNo() + 10000;

                    SalesLine.Insert();
                end;

                // 4️⃣ Update blanket order line
                BlanketLine.Validate(Quantity, BlanketLine.Quantity - QtyToInsert);

                BlanketLine.Modify();

                // 5️⃣ Count inserted lines
                LinesInserted += 1;
            end;

        until BlanketLine.Next() = 0;

        // 6️⃣ Show message to user
        if LinesInserted = 0 then begin
            Message('Pas de quantité disponible à insérer');
        end else begin
            if InsertInCurrentOrder then
                Message('%1 ligne(s) ont été insérée(s) dans la commande courante %2.', LinesInserted, CurrentOrderNo)
            else begin

                if Confirm('%1 ligne(s) ont étét insérée(s) dans la nouvelle commande  %2. Voulez-vous l''ouvrir?', true, LinesInserted, CreatedOrderNo) then begin
                    NewOrder.reset();
                    NewOrder.setrange("Document Type", "Sales Document Type"::Order);
                    NewOrder.setrange("No.", CreatedOrderNo);

                end;
                PAGE.Run(42, SalesHeader);
            end;
        end;
    end;




}


