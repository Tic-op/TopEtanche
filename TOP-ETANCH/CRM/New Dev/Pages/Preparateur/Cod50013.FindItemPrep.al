namespace Top.Top;
using Microsoft.Inventory.Item;

codeunit 50013 FindItem_Prep
{


    [ServiceEnabled]
    procedure FindItemPrep(prepNo: Code[20]; barcode: Code[50]; desc: Text): Text
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
            if Item.Get(Barcode) then begin
                ItemNo := Item."No.";
                UOMCode := Item."Base Unit of Measure";
            end
            else if ItemIdentifier.Get(Barcode) then begin

                ItemNo := ItemIdentifier."Item No.";
                UOMCode := ItemIdentifier."Unit of Measure Code";
            end

            else
                Result := '-1';

        end
        else if desc <> '' then begin

            item.SetFilter(Description, desc);
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
            if not PrepHeader.Get(prepNo) then begin
                Result := '-2';
            end
            else begin
                if Item.Get(ItemNo) then begin


                    PrepLine.SetRange("Document No.", prepNo);
                    // PurchLine.SetRange("Document No.", SalesOrderNo);
                    PrepLine.SetRange("item No.", ItemNo);
                    if PrepLine.FindFirst() then begin
                        Qty := 0;
                        if ItemUnit.Get(Item."No.", UOMCode) then
                            Qty := ItemUnit."Qty. per Unit of Measure";

                        Result := 'Item No: ' + Item."No." + ' | ' +
                             'Description: ' + Item.Description + ' | ' +//'Fournisseur: ' + ' | ' + Item."Vendor Name" + ' | ' +
                             'Unité: ' + Qty.ToText() + ' |1';
                        // 'Future dépot: ' + Item."Default depot" + ' | ';
                    end
                    else begin
                        Result := 'Item No: ' + Item."No." + ' | ' +
                             'Description: ' + Item.Description + ' | ' +//'Fournisseur: ' + ' | ' + Item."Vendor Name" + ' | ' +
                             'Unité: ' + Qty.ToText() + ' |0';/* 'Item No: ' + Item."No." + ' | ' +
                            'Description: ' + Item.Description + //'Fournisseur: ' + ' | ' + Item."Vendor Name" + ' | ' +
                            'Unité: ' + Qty.ToText() ;//' | ' +
                           // 'Future dépot: ' + Item."Default depot" + ' | ' + '0'; */
                    end;
                end
                else begin
                    Result := '-1';
                end;
            end;
        end;
        // else
        //   Result := ' Code à barr vide';



        exit(Result);
    end;
}