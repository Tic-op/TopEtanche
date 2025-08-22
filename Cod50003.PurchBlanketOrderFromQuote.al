namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;
using Microsoft.Utilities;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Archive;

codeunit 50003 "Purch Blanket Order From Quote"
{



    procedure StartCreationBlanOrder(QuoteNo: Code[20])

    var
        Vend: Record Vendor;
        PurchQuoteLine: Record "Purchase Line";
        Rec: Record "Purchase Header";
        BlOrderNo: Code[20];
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Quote);
        Rec.SetRange("No.", QuoteNo);
        Rec.FindFirst();

        Vend.get(Rec."Buy-from Vendor No.");
        Vend.TestField(Blocked, Vend.Blocked::" ");

        BlOrderNo := CreatePurchHeader(Rec, Vend."Prepayment %");

        TransferQuoteToBlkOrderLines(QuoteNo, BlOrderNo, Vend);

        ArchivePurchaseQuote(rec);
        Rec.DeleteLinks();
        Rec.Delete();
        PurchQuoteLine.SetRange("Document Type", PurchQuoteLine."Document Type"::Quote);
        PurchQuoteLine.SetRange("Document No.", QuoteNo);

        PurchQuoteLine.DeleteAll();

    end;

    local procedure CreatePurchHeader(PurchHeader: Record "Purchase Header"; PrepmtPercent: Decimal): Code[25]


    var
        PurchOrderHeader: Record "purchase header";
        PurchOrderLine: Record "purchase line";
    begin

        PurchOrderHeader := PurchHeader;
        PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::"Blanket Order";
        PurchOrderHeader."No. Printed" := 0;
        PurchOrderHeader.Status := PurchOrderHeader.Status::Open;
        PurchOrderHeader."No." := '';
        PurchOrderHeader."Quote No." := PurchHeader."No.";

        PurchOrderHeader.InitRecord();

        PurchOrderLine.LockTable();
        PurchOrderHeader.Insert(true);

        PurchOrderHeader."Order Date" := today;
        if PurchHeader."Posting Date" <> 0D then
            PurchOrderHeader."Posting Date" := today;

        PurchOrderHeader.InitFromPurchHeader(PurchHeader);
        PurchOrderHeader."Inbound Whse. Handling Time" := PurchHeader."Inbound Whse. Handling Time";

        PurchOrderHeader."Prepayment %" := PrepmtPercent;
        if PurchOrderHeader."Posting Date" = 0D then
            PurchOrderHeader."Posting Date" := WorkDate();
        PurchOrderHeader.Modify();

        exit(PurchOrderHeader."No.");
    end;

    local procedure TransferQuoteToBlkOrderLines(QuoteNo: Code[20]; BlOrderNo: Code[20]; Vend: Record Vendor)
    var
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        IsHandled: Boolean;
        PurchOrderLine: Record "Purchase Line";
        PurchQuoteLine: Record "Purchase Line";
    begin

        if QuoteNo = '' then
            Error('Impossible d''insérer des lignes... Le devis est nul');

        if BlOrderNo = '' then
            Error('Impossible d''insérer des lignes... La commande cadre est nulle');


        PurchQuoteLine.SetRange("Document Type", PurchQuoteLine."Document Type"::Quote);
        PurchQuoteLine.SetRange("Document No.", QuoteNo);
        PurchQuoteLine.SetFilter("Unit Cost", '<>0');
        PurchQuoteLine.SetFilter(Quantity, '<>0');
        PurchQuoteLine.SetRange("Confirmé par fournisseur", true); //IS
        PurchQuoteLine.FindFirst();
        repeat

            PurchOrderLine := PurchQuoteLine;
            PurchOrderLine."Document Type" := PurchOrderLine."Document Type"::"Blanket Order";
            PurchOrderLine."Document No." := BlOrderNo;
            PurchOrderLine.Restant := PurchQuoteLine.Restant;


            PurchLineReserve.TransferPurchLineToPurchLine(
              PurchQuoteLine, PurchOrderLine, PurchQuoteLine."Outstanding Qty. (Base)");
            PurchOrderLine."Shortcut Dimension 1 Code" := PurchQuoteLine."Shortcut Dimension 1 Code";
            PurchOrderLine."Shortcut Dimension 2 Code" := PurchQuoteLine."Shortcut Dimension 2 Code";
            PurchOrderLine."Dimension Set ID" := PurchQuoteLine."Dimension Set ID";



            if Vend."Prepayment %" <> 0 then
                PurchOrderLine."Prepayment %" := Vend."Prepayment %";
            if PurchOrderLine."No." <> '' then
                PurchOrderLine.DefaultDeferralCode();
            PurchOrderLine.Insert();


        until PurchQuoteLine.Next() = 0;
    end;

    local procedure ArchivePurchaseQuote(var PurchaseHeader: Record "Purchase Header")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
        IsHandled: Boolean;
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        /*  IsHandled := false;
         if IsHandled then
             exit; */

        PurchSetup.get;
        case PurchSetup."Archive Quotes" of
            PurchSetup."Archive Quotes"::Always:
                ArchiveManagement.ArchPurchDocumentNoConfirm(PurchaseHeader);
            PurchSetup."Archive Quotes"::Question:
                ArchiveManagement.ArchivePurchDocument(PurchaseHeader);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ArchiveManagement", OnBeforePurchLineArchiveInsert, '', true, true)]
    local procedure OnBeforeInsertPurchLineArchive(var PurchaseLineArchive: Record "Purchase Line Archive"; PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLineArchive."Confirmé par fournisseur" := PurchaseLine."Confirmé par fournisseur";
    end;


}
