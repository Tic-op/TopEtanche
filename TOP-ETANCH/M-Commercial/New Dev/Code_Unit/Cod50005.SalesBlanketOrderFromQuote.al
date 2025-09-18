namespace Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Archive;
using Microsoft.Sales.Setup;
using Microsoft.Utilities;

codeunit 50005 SalesBlanketOrderFromQuote
{
    procedure StartCreationBlanOrder(QuoteNo: Code[20])

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
        /*  IsHandled := false;
         if IsHandled then
             exit; */

        SalesSetup.get;
        case SalesSetup."Archive Quotes" of
            SalesSetup."Archive Quotes"::Always:
                ArchiveManagement.ArchiveSalesDocument(SalesHeader);
            SalesSetup."Archive Quotes"::Question:
                ArchiveManagement.ArchiveSalesDocument(SalesHeader);
        end;
    end;


}
