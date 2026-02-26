namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Document;
using Microsoft.Warehouse.ADCS;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;

codeunit 50001 FindItemRec
{


    procedure FindItemReception(SalesOrderNo: Code[20]; Barcode: Code[50]; desc: Text): Text
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
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
            if Item.Get(Barcode) then begin
                ItemNo := Item."No.";
                UOMCode := Item."Base Unit of Measure";
            end
            else
                if ItemIdentifier.Get(Barcode) then begin
                    ItemNo := ItemIdentifier."Item No.";
                    UOMCode := ItemIdentifier."Unit of Measure Code";
                end
                else
                    Result := '-1';
        end

        else if desc <> '' then begin
            Item.SetFilter(Description, desc);
            if Item.FindFirst() then begin
                repeat
                    if Item.Description = desc then begin
                        ItemNo := Item."No.";
                        UOMCode := Item."Base Unit of Measure";
                    end;
                until Item.Next() = 0;
            end;
        end
        else
            Result := 'Code à barre vide';

        if ItemNo <> '' then begin
            if not PurchHeader.Get(PurchHeader."Document Type"::Order, SalesOrderNo) then begin
                Result := '-2';
            end
            else begin
                if Item.Get(ItemNo) then begin

                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SetRange("Document No.", SalesOrderNo);
                    PurchLine.SetRange("No.", ItemNo);

                    if PurchLine.FindFirst() then begin
                        Qty := 0;
                        if ItemUnit.Get(Item."No.", UOMCode) then
                            Qty := ItemUnit."Qty. per Unit of Measure";

                        Result := 'Item No: ' + Item."No." + ' | ' +
                                  'Description: ' + Item.Description + ' | ' +
                                  'Unité: ' + Qty.ToText() + '| 1';
                    end
                    else begin
                        Result := 'Item No: ' + Item."No." + ' | ' +
                                  'Description: ' + Item.Description + ' | ' +
                                  'Unité: ' + Qty.ToText() + '| 0';
                    end;

                end
                else
                    Result := '-1';
            end;
        end;

        exit(Result);
    end;


}
