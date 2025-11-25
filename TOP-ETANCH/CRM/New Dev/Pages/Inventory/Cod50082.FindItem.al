namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.ADCS;
using Microsoft.Inventory.Item;

codeunit 50082 FindItem
{

    procedure FindItem(InventoryNo: Code[20]; Barcode: Code[50]): Text
    var
        InventoryHeader: Record "Inventory Header";
        InventoryLine: Record "Inventroy Line";
        ItemIdentifier: Record "Item Identifier TICOP";
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

            if not InventoryHeader.Get(InventoryNo) then
                Result := '-2'
            else begin
                InventoryLine.SetRange("Inventory No.", InventoryNo);
                InventoryLine.SetRange("Item No.", ItemNo);

                if InventoryLine.FindFirst() then begin
                    if Item.Get(ItemNo) then begin

                        Qty := 0;
                        if ItemUnit.Get(Item."No.", UOMCode) then
                            Qty := ItemUnit."Qty. per Unit of Measure";
                        Result :=
                          'Item No: ' + Item."No." + ' | ' + 'Description: ' + Item.Description + ' | ' + 'Fournisseur: ' + item."Vendor No." + ' | ' + 'Unité: ' + UOMCode + ' | ' + 'Qty/unité: ' + Format(Qty) //+ ' | ' + 'Magasin: ' + ' | ' + InventoryLine."Location Code" 
                    end else
                        Result := '-1';
                end else
                    Result := '0';
            end;
        end;

        exit(Result);
    end;
}
