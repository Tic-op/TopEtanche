namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Document;
using Microsoft.Warehouse.ADCS;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;

codeunit 50001 FindItemRec
{
    /*  procedure FindItemReception(SalesOrderNo: Code[20]; Barcode: Code[50]): Text
     var
         SalesHeader: Record "Purchase Header";
         SalesLine: Record "Purchase Line";
         ItemIdentifier: Record "Item Identifier";
         Item: Record Item;
         ItemUnit: Record "Item Unit of Measure";
         ItemNo: Code[20];
         Result: Text;
         Qty: Decimal;
         UOMCode: Code[10];
     begin
         Result := '';

         if not ItemIdentifier.Get(Barcode) then
             Result := '-1'
         else begin
             ItemNo := ItemIdentifier."Item No.";
             UOMCode := ItemIdentifier."Unit of Measure Code";

             if not SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then
                 Result := '-2'
             else begin
                 SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                 SalesLine.SetRange("Document No.", SalesOrderNo);
                 SalesLine.SetRange("No.", ItemNo);

                 if SalesLine.FindFirst() then begin
                     if Item.Get(ItemNo) then begin
                         Qty := 0;
                         if ItemUnit.Get(Item."No.", UOMCode) then
                             Qty := ItemUnit."Qty. per Unit of Measure";

                         Result :=
                             'Item No: ' + Item."No." + ' | ' +
                             'Description: ' + Item.Description + ' | ' +
                             'Unité: ' + UOMCode + ' | ' + 'Future dépot:' + Item."Default depot";
                         // + ' | Qty/UOM: ' + Format(Qty)
                     end else
                         Result := '-1';
                 end else
                     Result := '0';
             end;
         end;

         exit(Result);
     end; */

    procedure FindItemReception(SalesOrderNo: Code[20]; Barcode: Code[50]; desc: Text): Text
    var
        SalesHeader: Record "Purchase Header";
        SalesLine: Record "Purchase Line";
        ItemIdentifier: Record "Item Identifier TICOP";
        Item: Record Item;
        ItemUnit: Record "Item Unit of Measure";
        ItemNo: Code[20];
        Result: Text;
        Qty: Decimal;
        UOMCode: Code[10];
    begin
        Result := '';
        if Barcode <> '' then begin
            if not ItemIdentifier.Get(Barcode) then begin
                Result := '-1';
            end
            else begin
                ItemNo := ItemIdentifier."Item No.";
                UOMCode := ItemIdentifier."Unit of Measure Code";
            end;
        end
        else if desc <> '' then begin
            if Item.Get(desc) then begin
                ItemNo := Item."No.";
                UOMCode := Item."Base Unit of Measure";
            end else begin
                if Item.FindFirst() then begin
                    repeat
                        if Item.Description = desc then begin
                            ItemNo := Item."No.";
                            UOMCode := Item."Base Unit of Measure";
                        end;
                    until Item.Next() = 0;

                    if ItemNo = '' then
                        Result := 'Description not found';
                end;
            end;
        end;
        if ItemNo <> '' then begin
            if not SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo) then begin
                Result := '-2';
            end
            else begin
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", SalesOrderNo);
                SalesLine.SetRange("No.", ItemNo);
                if SalesLine.FindFirst() then begin
                    if Item.Get(ItemNo) then begin
                        Qty := 0;
                        if ItemUnit.Get(Item."No.", UOMCode) then
                            Qty := ItemUnit."Qty. per Unit of Measure";

                        Result :=
                            'Item No: ' + Item."No." + ' | ' +
                            'Description: ' + Item.Description + ' | ' +
                            'Unité: ' + UOMCode + ' | ' +
                            'Future dépot: ' + Item."Default depot";
                    end
                    else begin
                        Result := '-1';
                    end;
                end
                else begin
                    Result := '0';
                end;
            end;
        end;

        exit(Result);
    end;




}
