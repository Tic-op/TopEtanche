namespace Top.Top;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Archive;
using Microsoft.Sales.Document;
using Ticop_pharmatec.Ticop_pharmatec;
using Microsoft.Sales.history;

page 50027 HistVenteArticleSubform
{
    ApplicationArea = All;
    Caption = 'HistVenteArticleSubform';
    PageType = ListPart;
    SourceTable = HistVenteArticle;
    SourceTableTemporary = true;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Customer No"; Rec."Customer No")
                {
                    ToolTip = 'Specifies the value of the No client field.', Comment = '%';
                    Visible = not Factbox;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Visible = not Factbox;
                }

                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Type document field.', Comment = '%';
                }
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the No document field.', Comment = '%';
                    visible = not Factbox;
                }
                field("Date"; Rec."Date Document")
                {
                    ToolTip = 'Specifies the value of the Date Document field.', Comment = '%';
                }
                field(Remise; Rec.Remise)
                {
                    ToolTip = 'Specifies the value of the Remise field.', Comment = '%';
                }
                field("Price HT"; Rec."Price HT")
                {
                    ToolTip = 'Specifies the value of the Prix HT field.', Comment = '%';
                }
                field("Price TTC"; Rec."Price TTC")
                {
                    ToolTip = 'Specifies the value of the Prix TTC field.', Comment = '%';
                }


            }
        }
    }
    trigger OnOpenPage()
    begin
        InsertValues(true);

    end;

    procedure InsertValues(UniqCustomer: Boolean)
    var
        SalesShipLine: record "Sales Shipment Line";
        SalesLineArchive: Record "Sales Line Archive";
        SalesInvoiceLine: record "Sales Invoice Line";
        InvoiceLine: record "Sales Line";
        PréBLLine: record "Sales Line";
        //rec: Record HistVenteArticle temporary;
        // Pagedétail: Page "Détail vente article";
        Cust: record Customer;

        DA: Record "Détails Article";
        Shipdate, invoicedate, orderdate, quotedate, Dadate : Date;


    begin

        Shipdate := 0D;
        invoicedate := 0D;
        orderdate := 0D;
        quotedate := 0D;
        Dadate := 0D;
        rec.DeleteAll();
        // insert into BL started 
        SalesShipLine.SetLoadFields("No.", "Quantity (Base)", "Unit Price", "Line Discount %", "VAT %", "VAT Base Amount", "Posting Date", "Order No.", "Order Line No.", "Sell-to Customer No.");
        //SalesShipLine.SetCurrentKey("Order No.", "Order Line No.", "Posting Date");

        if UniqCustomer then begin
            SalesShipLine.SetCurrentKey("Sell-to Customer No.");
            SalesShipLine.setrange("Sell-to Customer No.", Customer."No.");
            DA.setrange("Source No", Customer."No.");
        end;

        SalesShipLine.SetCurrentKey("no.", "Posting Date");//key to be added
        SalesShipLine.setrange("No.", Item."No.");
        SalesShipLine.SetFilter(Quantity, '>0');
        Da.SetCurrentKey("Date Document");
        DA.setrange("Item No", item."No.");
        DA.SetRange("Document Type", Da."Document Type"::"Expédition");
        if Da.findlast then
            Dadate := Da."Date Document";
        If SalesShipLine.findlast then
            Shipdate := SalesShipLine."Posting Date";


        If (Shipdate >= Dadate) and (Shipdate <> 0D)

       then begin
            rec.Init();
            rec."Item No" := Item."No.";
            rec."Document Type" := rec."Document Type"::"Expédition";
            rec."Customer No" := SalesShipLine."Sell-to Customer No.";
            Cust.get(SalesShipLine."Sell-to Customer No.");
            rec."Customer Name" := Cust.Name;
            rec."Document No" := SalesShipLine."Document No.";
            rec."Price HT" := SalesShipLine."Unit Price" * (1 - SalesShipLine."Line Discount %" / 100);
            rec."Price TTC" := ROUND(SalesShipLine."Unit Price" * (1 - SalesShipLine."Line Discount %" / 100) * (1 + SalesShipLine."VAT %" / 100));
            rec.Remise := SalesShipLine."Line Discount %";
            rec."Date Document" := SalesShipLine."Posting Date";
            if not rec.insert(true) then rec.modify(false);
            ;
        end
        else
            if Dadate <> 0D then begin
                rec.Init();
                rec."Item No" := Item."No.";
                rec."Document Type" := rec."Document Type"::"Expédition";
                rec."Customer No" := da."Source No";
                Cust.get(Da."Source No");
                rec."Customer Name" := Cust.Name;
                rec."Document No" := Da."Document No";
                rec."Price HT" := Da."Price HT";
                rec."Price TTC" := Da."Price TTC";
                rec.Remise := da.Remise;
                rec."Date Document" := Da."Date Document";
                if not rec.insert(true) then rec.modify(false);
                ;

            end;

        Dadate := 0D;
        Da.Reset();

        //insert BL ended 


        //insert to Quote started 
        SalesLineArchive.SetLoadFields("No.", "Sell-to Customer No.", "VAT %", "Amount Including VAT", "Line Amount", "Line Discount %");
        // SalesLineArchive.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        if UniqCustomer then begin
            SalesLineArchive.SetCurrentKey("Sell-to Customer No.");

            SalesLineArchive.setrange("Sell-to Customer No.", Customer."No.");
            DA.setrange("Source No", Customer."No.");

        end;



        SalesLineArchive.SetCurrentKey("Document Type", "Document No.", "Doc. No. Occurrence", "Version No.", "Line No.");
        SalesLineArchive.setrange("Document Type", "Sales Document Type"::Quote);
        SalesLineArchive.setrange("No.", item."No.");
        Da.SetCurrentKey("Date Document");
        DA.setrange("Item No", item."No.");
        DA.SetRange("Document Type", Da."Document Type"::"Devis");

        if Da.findlast then
            Dadate := Da."Date Document";
        If SalesLineArchive.findlast then
            quotedate := SalesLineArchive."Shipment Date";





        if (quotedate >= Dadate) and (quotedate <> 0D)

               then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::"Devis";
            rec."Customer No" := SalesLineArchive."Sell-to Customer No.";
            Cust.get(SalesLineArchive."Sell-to Customer No.");
            rec."Customer Name" := Cust.Name;
            rec."Document No" := SalesLineArchive."Document No.";
            rec."Price HT" := SalesLineArchive."Unit Price" * (1 - SalesLineArchive."Line Discount %" / 100);
            rec."Price TTC" := SalesLineArchive."Unit Price" * (1 - SalesLineArchive."Line Discount %" / 100) * (1 + SalesLineArchive."VAT %" / 100);
            rec.Remise := SalesLineArchive."Line Discount %";
            rec."Date Document" := SalesLineArchive."Shipment Date";
            if not rec.insert(true) then rec.modify(false);
            ;
        end
        else if Dadate <> 0D then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::"Devis";
            rec."Customer No" := da."Source No";
            Cust.get(Da."Source No");
            rec."Customer Name" := Cust.Name;
            rec."Document No" := Da."Document No";
            rec."Price HT" := Da."Price HT";
            rec."Price TTC" := da."Price TTC";
            rec.Remise := da.Remise;
            rec."Date Document" := da."Date Document";
            if not rec.insert(true) then rec.modify(false);
            ;

        end;
        /*  SalesLineArchive.reset();
         SalesLineArchive.setrange("Document Type", "Sales Document Type"::Quote);
         SalesLineArchive.setrange("No.", item."No.");
         SalesLineArchive.setrange("Sell-to Customer No.", Customer."No.");
         if SalesLineArchive.FindLast() then begin
             rec.Init();
             rec."Item No" := item."No.";
             rec."Document Type" := rec."Document Type"::"Devis";
             rec."Customer No" := Customer."No.";
             rec."Customer Name" := Customer.Name;
             rec."Document No" := SalesLineArchive."Document No.";
             rec."Price HT" := SalesLineArchive."Line Amount";
             rec."Price TTC" := SalesLineArchive."Amount Including VAT";
             rec.Remise := SalesLineArchive."Line Discount %";
             rec."Date Document" := SalesLineArchive."Shipment Date";
             rec.Insert();
         end;  */

        Dadate := 0D;
        Da.Reset();
        SalesInvoiceLine.SetLoadFields("No.", "Sell-to Customer No.", "VAT %", "Amount Including VAT", "Line Amount", "Line Discount %", "Posting Date");//, "Sell-to Customer Name"); ooesn't exist in this app ???
                                                                                                                                                         // SalesLineArchive.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        if UniqCustomer then begin
            SalesInvoiceLine.SetCurrentKey("Sell-to Customer No.");

            SalesInvoiceLine.setrange("Sell-to Customer No.", Customer."No.");
            DA.setrange("Source No", Customer."No.");
        end;
        SalesInvoiceLine.SetCurrentKey("Order No.", "Order Line No.", "Posting Date");
        // SalesInvoiceLine.setrange("Document Type", "Sales Document Type"::Quote);
        SalesInvoiceLine.setrange("No.", item."No.");
        Da.SetCurrentKey("Date Document");
        DA.setrange("Item No", item."No.");
        DA.SetRange("Document Type", Da."Document Type"::"Facture validée");

        if Da.findlast then
            Dadate := Da."Date Document";
        If SalesInvoiceLine.findlast then
            invoicedate := SalesInvoiceLine."Posting Date";

        if (invoicedate >= Dadate) and (invoicedate <> 0D) then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::"Facture validée";
            rec."Customer No" := SalesInvoiceLine."Sell-to Customer No.";

            Cust.get(SalesInvoiceLine."Sell-to Customer No.");
            rec."Customer Name" := Cust.Name;
            rec."Document No" := SalesInvoiceLine."Document No.";
            rec."Price HT" := SalesInvoiceLine."Unit Price" * (1 - SalesInvoiceLine."Line Discount %" / 100);
            rec."Price TTC" := SalesInvoiceLine."Unit Price" * (1 - SalesInvoiceLine."Line Discount %" / 100) * (1 + SalesInvoiceLine."VAT %" / 100);
            rec.Remise := SalesInvoiceLine."Line Discount %";
            rec."Date Document" := SalesInvoiceLine."Posting Date";
            if not rec.insert(true) then rec.modify(false);
            ;
        end
        else if Dadate <> 0D then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::"Facture validée";
            rec."Customer No" := da."Source No";

            Cust.get(Da."Source No");
            rec."Customer Name" := Cust.Name;
            rec."Document No" := da."Document No";
            rec."Price HT" := Da."Price HT";
            rec."Price TTC" := da."Price TTC";
            rec.Remise := da.Remise;
            rec."Date Document" := da."Date Document";
            if not rec.insert(true) then rec.modify(false);
            ;




        end;
        // debut préBL 

        Dadate := 0D;
        Da.Reset();
        PréBLLine.SetLoadFields("No.", "Planned Shipment Date", "Sell-to Customer No.", "VAT %", "Amount Including VAT", "Posting Date", "Line Amount", "Line Discount %"); //"Sell-to Customer Name" )
        // SalesLineArchive.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        if UniqCustomer then begin
            PréBLLine.SetCurrentKey("Sell-to Customer No.");

            PréBLLine.setrange("Sell-to Customer No.", Customer."No.");
            Da.setrange("Source No", Customer."No.");
        end;
        PréBLLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        // SalesInvoiceLine.setrange("Document Type", "Sales Document Type"::Quote);
        "PréBLLine".setrange("Document Type", "Sales Document Type"::Order);

        PréBLLine.setrange("No.", item."No.");
        // "PréBLLine".SetFilter("Shipping No.", '<> %1', '');  Check Sales setup "Utiliser Pré-BL"  //AM 290925
        Da.SetCurrentKey("Date Document");
        DA.setrange("Item No", item."No.");
        DA.SetRange("Document Type", Da."Document Type"::"Commande Pré-BL");
        if Da.findlast then
            Dadate := Da."Date Document";
        If "PréBLLine".findlast then
            orderdate := "PréBLLine"."Planned Shipment Date";

        if (orderdate >= Dadate) and (orderdate <> 0D) then begin
            rec.Init();
            rec."Document Type" := rec."Document Type"::"Commande Pré-BL";
            rec."Item No" := item."No.";

            rec."Customer No" := PréBLLine."Sell-to Customer No.";
            Cust.get("PréBLLine"."Sell-to Customer No.");
            rec."Customer Name" := Cust.name;

            rec."Document No" := PréBLLine."Document No.";
            rec."Price HT" := PréBLLine."Unit Price" * (1 - PréBLLine."Line Discount %" / 100);
            rec."Price TTC" := PréBLLine."Unit Price" * (1 - PréBLLine."Line Discount %" / 100) * (1 + PréBLLine."VAT %" / 100);
            rec.Remise := PréBLLine."Line Discount %";
            rec."Date Document" := PréBLLine."Planned Shipment Date";
            if not rec.insert(true) then rec.modify(false);
            ;
        end
        else if Dadate <> 0D then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::"Facture validée";
            rec."Customer No" := da."Source No";

            Cust.get(Da."Source No");
            rec."Customer Name" := Cust.Name;
            rec."Document No" := da."Document No";
            rec."Price HT" := Da."Price HT";
            rec."Price TTC" := da."Price TTC";
            rec.Remise := da.Remise;
            rec."Date Document" := da."Date Document";
            if not rec.insert(true) then rec.modify(false);

        end;
        //debut facture 
        InvoiceLine.SetLoadFields("No.", "Sell-to Customer No.", "VAT %", "Amount Including VAT", "Line Amount", "Line Discount %", "Planned Shipment Date");
        // SalesLineArchive.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        if UniqCustomer then begin
            InvoiceLine.SetCurrentKey("Sell-to Customer No.");

            InvoiceLine.setrange("Sell-to Customer No.", Customer."No.");
        end;
        InvoiceLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        // SalesInvoiceLine.setrange("Document Type", "Sales Document Type"::Quote);
        InvoiceLine.setrange("Document Type", "Sales Document Type"::Invoice);

        InvoiceLine.setrange("No.", item."No.");
        if InvoiceLine.FindLast() then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::Facture;
            rec."Customer No" := InvoiceLine."Sell-to Customer No.";
            Cust.get(InvoiceLine."Sell-to Customer No.");
            rec."Customer Name" := Cust.Name;

            rec."Document No" := InvoiceLine."Document No.";
            rec."Price HT" := InvoiceLine."Unit Price" * (1 - InvoiceLine."Line Discount %" / 100);
            rec."Price TTC" := InvoiceLine."Unit Price" * (1 - InvoiceLine."Line Discount %" / 100) * (1 + InvoiceLine."VAT %" / 100);
            rec.Remise := InvoiceLine."Line Discount %";
            rec."Date Document" := InvoiceLine."Planned Shipment Date";
            if not rec.insert(true) then rec.modify(false);
            ;
        end;



    end;

    procedure InsertValuesOld(UniqCustomer: Boolean)
    var
        SalesShipLine: record "Sales Shipment Line";
        SalesLineArchive: Record "Sales Line Archive";
        SalesInvoiceLine: record "Sales Invoice Line";
        InvoiceLine: record "Sales Line";
        PréBLLine: record "Sales Line";
        //rec: Record HistVenteArticle temporary;
        // Pagedétail: Page "Détail vente article";
        Cust: record Customer;

    begin
        rec.DeleteAll();
        // insert into BL started 
        SalesShipLine.SetLoadFields("No.", "Quantity (Base)", "Unit Price", "Line Discount %", "VAT %", "VAT Base Amount", "Posting Date", "Order No.", "Order Line No.", "Sell-to Customer No.");
        //SalesShipLine.SetCurrentKey("Order No.", "Order Line No.", "Posting Date");

        if UniqCustomer then begin
            SalesShipLine.SetCurrentKey("Sell-to Customer No.");

            SalesShipLine.setrange("Sell-to Customer No.", Customer."No.");
        end;

        SalesShipLine.SetCurrentKey("no.", "Posting Date");//key to be added
        SalesShipLine.setrange("No.", Item."No.");
        SalesShipLine.SetFilter(Quantity, '>0');
        if SalesShipLine.findlast then begin
            rec.Init();
            rec."Item No" := Item."No.";
            rec."Document Type" := rec."Document Type"::"Expédition";
            rec."Customer No" := SalesShipLine."Sell-to Customer No.";
            Cust.get(SalesShipLine."Sell-to Customer No.");
            rec."Customer Name" := Cust.Name;
            rec."Document No" := SalesShipLine."Document No.";
            rec."Price HT" := SalesShipLine."Unit Price" * (1 - SalesShipLine."Line Discount %" / 100);
            rec."Price TTC" := ROUND(SalesShipLine."Unit Price" * (1 - SalesShipLine."Line Discount %" / 100) * (1 + SalesShipLine."VAT %" / 100));
            rec.Remise := SalesShipLine."Line Discount %";
            rec."Date Document" := SalesShipLine."Posting Date";
            if rec.insert(true) then;
            ;
        end;
        //insert BL ended 


        //insert to Quote started 
        SalesLineArchive.SetLoadFields("No.", "Sell-to Customer No.", "VAT %", "Amount Including VAT", "Line Amount", "Line Discount %");
        // SalesLineArchive.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        if UniqCustomer then begin
            SalesLineArchive.SetCurrentKey("Sell-to Customer No.");

            SalesLineArchive.setrange("Sell-to Customer No.", Customer."No.");
        end;
        SalesLineArchive.SetCurrentKey("Document Type", "Document No.", "Doc. No. Occurrence", "Version No.", "Line No.");
        SalesLineArchive.setrange("Document Type", "Sales Document Type"::Quote);
        SalesLineArchive.setrange("No.", item."No.");
        if SalesLineArchive.FindLast() then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::"Devis";
            rec."Customer No" := SalesLineArchive."Sell-to Customer No.";
            Cust.get(SalesLineArchive."Sell-to Customer No.");
            rec."Customer Name" := Cust.Name;
            rec."Document No" := SalesLineArchive."Document No.";
            rec."Price HT" := SalesLineArchive."Unit Price" * (1 - SalesLineArchive."Line Discount %" / 100);
            rec."Price TTC" := SalesLineArchive."Unit Price" * (1 - SalesLineArchive."Line Discount %" / 100) * (1 + SalesLineArchive."VAT %" / 100);
            rec.Remise := SalesLineArchive."Line Discount %";
            rec."Date Document" := SalesLineArchive."Shipment Date";
            if rec.insert(true) then;
            ;
        end;
        /*  SalesLineArchive.reset();
         SalesLineArchive.setrange("Document Type", "Sales Document Type"::Quote);
         SalesLineArchive.setrange("No.", item."No.");
         SalesLineArchive.setrange("Sell-to Customer No.", Customer."No.");
         if SalesLineArchive.FindLast() then begin
             rec.Init();
             rec."Item No" := item."No.";
             rec."Document Type" := rec."Document Type"::"Devis";
             rec."Customer No" := Customer."No.";
             rec."Customer Name" := Customer.Name;
             rec."Document No" := SalesLineArchive."Document No.";
             rec."Price HT" := SalesLineArchive."Line Amount";
             rec."Price TTC" := SalesLineArchive."Amount Including VAT";
             rec.Remise := SalesLineArchive."Line Discount %";
             rec."Date Document" := SalesLineArchive."Shipment Date";
             rec.Insert();
         end;  */
        SalesInvoiceLine.SetLoadFields("No.", "Sell-to Customer No.", "VAT %", "Amount Including VAT", "Line Amount", "Line Discount %", "Posting Date", "Sell-to Customer Name");
        // SalesLineArchive.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        if UniqCustomer then begin
            SalesInvoiceLine.SetCurrentKey("Sell-to Customer No.");

            SalesInvoiceLine.setrange("Sell-to Customer No.", Customer."No.");
        end;
        SalesInvoiceLine.SetCurrentKey("Order No.", "Order Line No.", "Posting Date");
        // SalesInvoiceLine.setrange("Document Type", "Sales Document Type"::Quote);
        SalesInvoiceLine.setrange("No.", item."No.");
        if SalesInvoiceLine.FindLast() then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::"Facture validée";
            rec."Customer No" := SalesInvoiceLine."Sell-to Customer No.";
            rec."Customer Name" := SalesInvoiceLine."Sell-to Customer Name";
            rec."Document No" := SalesInvoiceLine."Document No.";
            rec."Price HT" := SalesInvoiceLine."Unit Price" * (1 - SalesInvoiceLine."Line Discount %" / 100);
            rec."Price TTC" := SalesInvoiceLine."Unit Price" * (1 - SalesInvoiceLine."Line Discount %" / 100) * (1 + SalesInvoiceLine."VAT %" / 100);
            rec.Remise := SalesInvoiceLine."Line Discount %";
            rec."Date Document" := SalesInvoiceLine."Posting Date";
            if rec.insert(true) then;
            ;
        end;
        // debut préBL 
        PréBLLine.SetLoadFields("No.", "Planned Shipment Date", "Sell-to Customer No.", "Sell-to Customer Name", "VAT %", "Amount Including VAT", "Posting Date", "Line Amount", "Line Discount %");
        // SalesLineArchive.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        if UniqCustomer then begin
            PréBLLine.SetCurrentKey("Sell-to Customer No.");

            PréBLLine.setrange("Sell-to Customer No.", Customer."No.");
        end;
        PréBLLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        // SalesInvoiceLine.setrange("Document Type", "Sales Document Type"::Quote);
        "PréBLLine".setrange("Document Type", "Sales Document Type"::Order);

        PréBLLine.setrange("No.", item."No.");
        // "PréBLLine".SetFilter("Shipping No.", '<> %1', '');  Check Sales setup "Utiliser Pré-BL"  //AM 290925

        if PréBLLine.FindLast() then begin
            rec.Init();
            rec."Document Type" := rec."Document Type"::"Commande Pré-BL";
            rec."Item No" := item."No.";

            rec."Customer No" := PréBLLine."Sell-to Customer No.";
            rec."Customer Name" := PréBLLine."Sell-to Customer Name";
            rec."Document No" := PréBLLine."Document No.";
            rec."Price HT" := PréBLLine."Unit Price" * (1 - PréBLLine."Line Discount %" / 100);
            rec."Price TTC" := PréBLLine."Unit Price" * (1 - PréBLLine."Line Discount %" / 100) * (1 + PréBLLine."VAT %" / 100);
            rec.Remise := PréBLLine."Line Discount %";
            rec."Date Document" := PréBLLine."Planned Shipment Date";
            if rec.insert(true) then;
            ;
        end;
        //debut facture 
        InvoiceLine.SetLoadFields("No.", "Sell-to Customer No.", "VAT %", "Amount Including VAT", "Line Amount", "Line Discount %", "Sell-to Customer Name", "Planned Shipment Date");
        // SalesLineArchive.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        if UniqCustomer then begin
            InvoiceLine.SetCurrentKey("Sell-to Customer No.");

            InvoiceLine.setrange("Sell-to Customer No.", Customer."No.");
        end;
        InvoiceLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        // SalesInvoiceLine.setrange("Document Type", "Sales Document Type"::Quote);
        InvoiceLine.setrange("Document Type", "Sales Document Type"::Invoice);

        InvoiceLine.setrange("No.", item."No.");
        if InvoiceLine.FindLast() then begin
            rec.Init();
            rec."Item No" := item."No.";
            rec."Document Type" := rec."Document Type"::Facture;
            rec."Customer No" := InvoiceLine."Sell-to Customer No.";
            rec."Customer Name" := InvoiceLine."Sell-to Customer Name";

            rec."Document No" := InvoiceLine."Document No.";
            rec."Price HT" := InvoiceLine."Unit Price"; //* (1 - InvoiceLine."Line Discount %" / 100); commented by chb
            rec."Price TTC" := InvoiceLine."Unit Price" * (1 + InvoiceLine."VAT %" / 100);//* (1 - InvoiceLine."Line Discount %" / 100) commented by chb
            rec.Remise := InvoiceLine."Line Discount %";
            rec."Date Document" := InvoiceLine."Planned Shipment Date";
            if rec.insert(true) then;
            ;
        end;



    end;


    /*   trigger OnAfterGetRecord()
      var
          cust: Record customer;
      begin
          if rec."Customer Name" = '' then begin

              Cust.SetLoadFields("No.", Name);
              Cust.get(rec."Customer No");
              rec."Customer Name" := cust.Name;
          end


      end; */

    procedure SetCustomer(Cust0: Record Customer)
    begin

        Customer := Cust0;
    end;

    Procedure Setitem(Item0: record Item)
    begin
        item := item0;
    end;

    Procedure ISFactbox(Factboxvisibility: Boolean);
    begin
        Factbox := Factboxvisibility;

    end;

    var
        Item: record Item;
        Customer: Record Customer;
        Factbox: Boolean;


}
