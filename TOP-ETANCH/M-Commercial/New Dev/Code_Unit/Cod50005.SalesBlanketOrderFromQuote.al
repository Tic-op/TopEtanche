namespace Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Archive;
using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Setup;
using Microsoft.Utilities;

codeunit 50005 SalesBlanketOrderFromQuote
{

    procedure StartCreationSalesBlanOrder(QuoteNo: Code[20]): Code[25]

    var
        customer: Record Customer;
        SalesQuoteLine: Record "Sales Line";
        Rec: Record "Sales Header";
        BlOrderNo: Code[20];
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Quote);
        Rec.SetRange("No.", QuoteNo);
        Rec.FindFirst();

        customer.get(Rec."Sell-to Customer No.");
        customer.TestField(Blocked, customer.Blocked::" ");

        BlOrderNo := CreateSalesHeader(Rec, customer."Prepayment %");

        TransferQuoteToBlkOrderLines(QuoteNo, BlOrderNo, customer);

        ArchiveSalesQuote(rec);
        Rec.DeleteLinks();
        Rec.Delete();
        SalesQuoteLine.SetRange("Document Type", SalesQuoteLine."Document Type"::Quote);
        SalesQuoteLine.SetRange("Document No.", QuoteNo);
        SalesQuoteLine.DeleteAll();
        Exit(BlOrderNo);
    end;

    local procedure CreateSalesHeader(SalesHeader: Record "Sales Header"; PrepmtPercent: Decimal): Code[25]


    var
        SalesOrderHeader: Record "Sales header";
        SalesOrderLine: Record "Sales line";
    begin

        SalesOrderHeader := SalesHeader;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::"Blanket Order";
        SalesOrderHeader."No. Printed" := 0;
        SalesOrderHeader.Status := SalesOrderHeader.Status::Open;
        SalesOrderHeader."No." := '';
        SalesOrderHeader."Quote No." := SalesHeader."No.";

        SalesOrderHeader.InitRecord();

        SalesOrderLine.LockTable();
        SalesOrderHeader.Insert(true);

        SalesOrderHeader."Order Date" := today;
        if SalesHeader."Posting Date" <> 0D then
            SalesOrderHeader."Posting Date" := today;

        SalesOrderHeader.InitFromSalesHeader(SalesHeader);

        SalesOrderHeader."Prepayment %" := PrepmtPercent;
        if SalesOrderHeader."Posting Date" = 0D then
            SalesOrderHeader."Posting Date" := WorkDate();
        SalesOrderHeader.Modify();

        exit(SalesOrderHeader."No.");
    end;

    local procedure TransferQuoteToBlkOrderLines(QuoteNo: Code[20]; BlOrderNo: Code[20]; customer: Record Customer)
    var
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        IsHandled: Boolean;
        SalesOrderLine: Record "Sales Line";
        SalesQuoteLine: Record "Sales Line";
    begin

        if QuoteNo = '' then
            Error('Impossible d''insérer des lignes... Le devis est nul');

        if BlOrderNo = '' then
            Error('Impossible d''insérer des lignes... La commande cadre est nulle');


        SalesQuoteLine.SetRange("Document Type", SalesQuoteLine."Document Type"::Quote);
        SalesQuoteLine.SetRange("Document No.", QuoteNo);
        SalesQuoteLine.SetFilter("Unit Cost", '<>0');
        SalesQuoteLine.SetFilter(Quantity, '<>0');
        SalesQuoteLine.FindFirst();
        repeat

            SalesOrderLine := SalesQuoteLine;
            SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::"Blanket Order";
            SalesOrderLine."Document No." := BlOrderNo;


            SalesLineReserve.TransferSaleLineToSalesLine(
              SalesQuoteLine, SalesOrderLine, SalesQuoteLine."Outstanding Qty. (Base)");
            SalesOrderLine."Shortcut Dimension 1 Code" := SalesQuoteLine."Shortcut Dimension 1 Code";
            SalesOrderLine."Shortcut Dimension 2 Code" := SalesQuoteLine."Shortcut Dimension 2 Code";
            SalesOrderLine."Dimension Set ID" := SalesQuoteLine."Dimension Set ID";

            if customer."Prepayment %" <> 0 then
                SalesOrderLine."Prepayment %" := customer."Prepayment %";
            if SalesOrderLine."No." <> '' then
                SalesOrderLine.DefaultDeferralCode();
            SalesOrderLine.Insert();


        until SalesQuoteLine.Next() = 0;
    end;

    local procedure ArchiveSalesQuote(var SalesHeader: Record "Sales Header")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
        IsHandled: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        ArchiveManagement.StoreSalesDocument(SalesHeader, false);
    end;

    procedure CreateDocumentsQuote(QuoteNo: Code[20])
    var
        OrderNo, BlanketOrderNo : Code[20];
        SH: record "Sales Header";
    begin
        if confirm('Ce devis va être transformer en une commande et une commande cadre, puis va être archivé et supprimé, voulez vous confirmer cette action', false)
        then begin
            OrderNo := CreateAvailableItemsOrderFromQuote(QuoteNo);
            BlanketOrderNo := CreateAvItemsBlanketOrderFromQuote(QuoteNo);
            SH.get("Sales Document Type"::Quote, QuoteNo);
            ArchiveSalesQuote(SH);// ?? 
            SH.Delete(true);
        end;




        /*  if OrderNo <> '' then begin
             If Confirm('Commande %1 a été crée depuis ce devis, voulez-vous l''ouvrir ?', true, OrderNo) then begin

                 SH.setrange("Document Type", "Sales Document Type"::Order);
                 SH.SetRange("No.", OrderNo);
                 if SH.findset() then
                     PAge.RunModal(Page::"Sales Order", SH);
             end;

         end; */
        /*  if BlanketOrderNo <> '' then begin
             If Confirm('Commande cadre %1 a été crée depuis ce devis, voulez-vous l''ouvrir ?', true, BlanketOrderNo) then begin

                 SH.setrange("Document Type", "Sales Document Type"::"Blanket Order");
                 SH.SetRange("No.", BlanketOrderNo);
                 if SH.findset() then
                     PAge.RunModal(Page::"Blanket Sales Order", SH);
             end;

         end*/
    end;

    Procedure CreateAvailableItemsOrderFromQuote(QuoteNo: code[20]): Code[20]
    var
        SalesQuoteH, SalesOrderH : Record "Sales Header";
        SalesQuoteL, SalesOrderL : record "Sales Line";
        CuseriesNo: Codeunit "No. Series";
        salesSetup: Record "Sales & Receivables Setup";
    begin
        salesSetup.Get();
        SalesQuoteH.get("Sales Document Type"::Quote, QuoteNo);
        SalesQuoteL.setrange("Document Type", "Sales Document Type"::Quote);
        SalesQuoteL.setrange("Document No.", QuoteNo);
        SalesQuoteL.Setfilter("Qté à commander", '>%1', 0);
        IF SalesQuoteL.FindSet() then begin
            SalesOrderH.Init();
            SalesOrderH := SalesQuoteH;
            SalesOrderH."Document Type" := "Sales Document Type"::Order;

            SalesOrderH."No." := CuseriesNo.GetNextNo(salesSetup."Order Nos.", WorkDate(), true);
            SalesOrderH.Status := "Sales Document Status"::Open;
            SalesOrderH."Document Date" := Today;
            SalesOrderH."Quote No." := QuoteNo;
            SalesOrderH.insert(true);
            repeat
                SalesOrderL := SalesQuoteL;
                SalesOrderL."Document Type" := "Sales Document Type"::Order;
                SalesOrderL.validate("Document No.", SalesOrderH."No.");
                SalesOrderL.Insert(true);
                SalesOrderL.validate(Quantity, SalesQuoteL."Qté à commander");//To make sure it throws an error if Dispo < qty 
                SalesOrderL.Modify();
            until SalesQuoteL.next = 0;

            exit(SalesOrderH."No.");
        end;
        exit('');


    end;

    Procedure CreateAvItemsBlanketOrderFromQuote(QuoteNo: code[20]): Code[20]
    var
        SalesQuoteH, BlanketSalesOrderH : Record "Sales Header";
        SalesQuoteL, BlanketSalesOrderL : record "Sales Line";
        CuseriesNo: Codeunit "No. Series";
        salesSetup: Record "Sales & Receivables Setup";
    begin
        salesSetup.Get();
        SalesQuoteH.get("Sales Document Type"::Quote, QuoteNo);
        SalesQuoteL.setrange("Document Type", "Sales Document Type"::Quote);
        SalesQuoteL.setrange("Document No.", QuoteNo);
        SalesQuoteL.Setfilter("Qté panier", '>%1', 0);
        IF SalesQuoteL.FindSet() then begin
            BlanketSalesOrderH.Init();
            BlanketSalesOrderH := SalesQuoteH;
            BlanketSalesOrderH."Document Type" := "Sales Document Type"::"Blanket Order";
            BlanketSalesOrderH."No." := CuseriesNo.GetNextNo(salesSetup."Blanket Order Nos.", WorkDate(), true);
            BlanketSalesOrderH.Status := "Sales Document Status"::Open;
            BlanketSalesOrderH."Document Date" := Today;
            BlanketSalesOrderH."Quote No." := QuoteNo;
            BlanketSalesOrderH.insert(true);
            repeat
                BlanketSalesOrderL := SalesQuoteL;
                BlanketSalesOrderL."Document Type" := "Sales Document Type"::"Blanket Order";
                BlanketSalesOrderL.validate("Document No.", BlanketSalesOrderH."No.");
                BlanketSalesOrderL.validate(Quantity, SalesQuoteL."Qté panier");
                BlanketSalesOrderL.Insert(true);
            until SalesQuoteL.next = 0;

            exit(BlanketSalesOrderH."No.");
        end;
        exit('');


    end;
}
