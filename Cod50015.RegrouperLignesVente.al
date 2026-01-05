namespace Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;

codeunit 50015 "Sales Document Line Mngmt"
{
    procedure InsertLinesFromSalesDoc(SalesDocNo: Code[20]; SalesDocType: Integer; var LDV: Record "Ligne DocVente Regroupée" temporary)

    begin
        if SalesDocNo = '' then
            exit;
        LDV.DeleteAll();
        IF SalesDocType > 0 then
            InsertLinesFromSalesDocument(SalesDocNo, SalesDocType, LDV);
        IF SalesDocType = 110 then
            InsertLinesFromSalesShipment(SalesDocNo, LDV);
        IF SalesDocType = 112 then
            InsertLinesFromSalesInvoice(SalesDocNo, LDV);
        IF SalesDocType = 114 then
            InsertLinesFromSalesCreditMemo(SalesDocNo, LDV);

    end;

    local procedure InsertLinesFromSalesDocument(
       SalesDocNo: Code[20];
       SalesDocType: Integer;
       var LDV: Record "Ligne DocVente Regroupée" temporary)
    var
        Lines: Record "Sales Line";
    begin
        Lines.SetRange("Document Type", SalesDocType);
        Lines.SetRange("Document No.", SalesDocNo);
        Lines.SetRange(Type, Lines.Type::Item);

        if Lines.FindSet() then
            repeat
                InsertOrAccumulateLDV(
                    Lines."No.",
                    Lines.Description,
                    Lines.Quantity,
                    Lines."Unit Price",
                    Lines."Line Discount %",
                    Lines.Amount,
                    Lines."VAT %",
                    Lines."Amount Including VAT",
                    Lines."Unit of Measure Code",
                    LDV);
            until Lines.Next() = 0;
    end;


    local procedure InsertLinesFromSalesShipment(
       SalesDocNo: Code[20];
       var LDV: Record "Ligne DocVente Regroupée" temporary)
    var
        Lines: Record "Sales Shipment Line";
    begin
        Lines.SetRange("Document No.", SalesDocNo);
        Lines.SetRange(Type, Lines.Type::Item);
        //  Lines.setfilter("Quantity (Base)")

        if Lines.FindSet() then
            repeat
                InsertOrAccumulateLDV(
                    Lines."No.",
                    Lines.Description,
                    Lines.Quantity,
                    Lines."Unit Price",
                    Lines."Line Discount %",
                    (((Lines.Quantity) * (Lines."Unit Price")) * ((100 - Lines."Line Discount %") / 100)),
                    Lines."VAT %",
                     (((Lines.Quantity) * (Lines."Unit Price")) * ((100 - Lines."Line Discount %") / 100)) * (1 + Lines."VAT %" / 100),
                    Lines."Unit of Measure Code",
                    LDV);
            until Lines.Next() = 0;
    end;

    local procedure InsertLinesFromSalesInvoice(SalesDocNo: Code[20]; var LDV: Record "Ligne DocVente Regroupée" temporary)
    var
        Lines: Record "Sales Invoice Line";

    begin
        Lines.SetRange("Document No.", SalesDocNo);
        Lines.SetRange(Type, Lines.Type::Item);

        if Lines.FindSet() then
            repeat
                InsertOrAccumulateLDV(
                    Lines."No.",
                    Lines.Description,
                    Lines.Quantity,
                    Lines."Unit Price",
                    Lines."Line Discount %",
                    Lines.Amount,
                    Lines."VAT %",
                    Lines."Amount Including VAT",
                    Lines."Unit of Measure Code",
                    LDV);
            until Lines.Next() = 0;
    end;

    local procedure InsertLinesFromSalesCreditMemo(SalesDocNo: Code[20]; var LDV: Record "Ligne DocVente Regroupée" temporary)
    var
        Lines: Record "Sales Cr.Memo Line";

    begin
        Lines.SetRange("Document No.", SalesDocNo);
        Lines.SetRange(Type, Lines.Type::Item);

        if Lines.FindSet() then
            repeat
                InsertOrAccumulateLDV(
                    Lines."No.",
                    Lines.Description,
                    Lines.Quantity,
                    Lines."Unit Price",
                    Lines."Line Discount %",
                    Lines.Amount,
                    Lines."VAT %",
                    Lines."Amount Including VAT",
                    Lines."Unit of Measure Code",
                    LDV);
            until Lines.Next() = 0;
    end;


    local procedure InsertOrAccumulateLDV(
        ItemNo: Code[20];
        Description: Text[100];
        Quantity: Decimal;
        UnitPrice: Decimal;
        LineDiscountPct: Decimal;
        Amount: Decimal;
        VATPct: Decimal;
        AmountInclVAT: Decimal;
        UOMCode: Code[10];
        var LDV: Record "Ligne DocVente Regroupée" temporary)
    var
        VATAmount: Decimal;
    begin
        VATAmount := AmountInclVAT - Amount;


        if LDV.Get(
            ItemNo,
            UnitPrice,
            LineDiscountPct,
            UOMCode)
        then begin
            // cumul
            LDV.Quantity += Quantity;
            LDV.Amount += Amount;
            LDV."VAT Amount" += VATAmount;
            LDV."Amount Including VAT" += AmountInclVAT;
            LDV.Modify();
        end else begin
            //  insertion
            LDV.Init();
            LDV."Item No." := ItemNo;
            LDV.Description := Description;
            LDV.Quantity := Quantity;
            LDV."Unit Price" := UnitPrice;
            LDV."Line Discount %" := LineDiscountPct;
            LDV.Amount := Amount;
            LDV."VAT %" := VATPct;
            LDV."VAT Amount" := VATAmount;
            LDV."Amount Including VAT" := AmountInclVAT;
            LDV."Unit of Measure Code" := UOMCode;
            LDV.Insert();
        end;
    end;



}
