namespace Top.Top;
using Microsoft.Inventory.Item;

codeunit 50013 FindItem_Prep
{
    

  [ServiceEnabled]
 procedure FindItemReception(prepNo: Code[20]; barcode: Code[50]; desc: Text): Text
    var
        PrepHeader: Record "Ordre de preparation";
        PrepLine: Record "Ligne préparation";
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
            if not PrepHeader.Get(prepNo) then begin
                Result := '-2';
            end
            else begin
                if Item.Get(ItemNo) then begin

                    PrepLine.SetRange("Document No.",prepNo);
                   // PurchLine.SetRange("Document No.", SalesOrderNo);
                    PrepLine.SetRange("item No.",ItemNo);
                    if PrepLine.FindFirst() then begin
                        Qty := 0;
                        if ItemUnit.Get(Item."No.", UOMCode) then
                            Qty := ItemUnit."Qty. per Unit of Measure";

                        Result := 'Item No: ' + Item."No." + ' | ' +
                             'Description: ' + Item.Description + ' | '+//'Fournisseur: ' + ' | ' + Item."Vendor Name" + ' | ' +
                             'Unité: ' + Qty.ToText() ;
                            // 'Future dépot: ' + Item."Default depot" + ' | ';
                    end
                    else begin
                        Result := '0' ;/* 'Item No: ' + Item."No." + ' | ' +
                            'Description: ' + Item.Description + //'Fournisseur: ' + ' | ' + Item."Vendor Name" + ' | ' +
                            'Unité: ' + Qty.ToText() ;//' | ' +
                           // 'Future dépot: ' + Item."Default depot" + ' | ' + '0'; */
                    end;
                end
                else
                
                begin
                    Result := '-1';
                end;
            end;
        end;

        exit(Result);
    end;
}