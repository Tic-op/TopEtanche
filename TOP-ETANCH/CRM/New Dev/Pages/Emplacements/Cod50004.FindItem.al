namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.ADCS;
using Microsoft.Inventory.Item;

codeunit 50004 FindItemEMP
{
    TableNo = "Item Identifier";

    /*  procedure FindItem(Barcode: Code[50]; Description: Text[100]; ItemNo: Code[20]) Result: Text
     var
         ItemIdentifier: Record "Item Identifier";
         Item: Record Item;
         UOMCode: Code[10];
     begin
         Result := '';

         if Barcode <> '' then begin
             if ItemIdentifier.Get(Barcode) then begin
                 if Item.Get(ItemIdentifier."Item No.") then begin
                     UOMCode := ItemIdentifier."Unit of Measure Code";
                     Result := 'Item No: ' + Item."No." + ' | ' +
                               'Description: ' + Item.Description + ' | ' +
                               'Fournisseur: ' + Item."Vendor No." + ' | ' +
                               'Unité: ' + UOMCode + ' | ';
                     exit(Result);
                 end;
             end
             else begin
                 Result := '-1';
                 exit(Result);
             end;
         end;

         if ItemNo <> '' then begin
             if Item.Get(ItemNo) then begin
                 UOMCode := Item."Base Unit of Measure";
                 Result := 'Item No: ' + Item."No." + ' | ' +
                           'Description: ' + Item.Description + ' | ' +
                           'Fournisseur: ' + Item."Vendor No." + ' | ' +
                           'Unité: ' + UOMCode + ' | ';
                 exit(Result);
             end
             else begin
                 Result := '-2';
                 exit(Result);
             end;
         end;

         if Description <> '' then begin
             Item.SetFilter(Description, '*' + Description + '*');
             if Item.FindFirst() then begin
                 UOMCode := Item."Base Unit of Measure";
                 Result := 'Item No: ' + Item."No." + ' | ' +
                           'Description: ' + Item.Description + ' | ' +
                           'Fournisseur: ' + Item."Vendor No." + ' | ' +
                           'Unité: ' + UOMCode + ' | ';
                 exit(Result);
             end
             else begin
                 Result := 'Description not found';
                 exit(Result);
             end;
         end;

         Result := 'Veuillez spécifier un code-barre, numéro d''article ou description';
     end; */

    procedure FindItem(Search: Text[250]): Text
    var
        ItemIdentifier: Record "Item Identifier TICOP";
        Item: Record Item;
    begin

        if Search = '' then
            exit('Veuillez saisir un code-barre, numéro d''article ou description');

        if Item.Get(Search) then
            exit('Item No: ' + Item."No." + ' | Description: ' + Item.Description + ' | Fournisseur: ' + Item."Vendor No." + ' | Unité: ' + Item."Base Unit of Measure");

        if ItemIdentifier.Get(Search) then
            if Item.Get(ItemIdentifier."Item No.") then
                exit('Item No: ' + Item."No." + ' | Description: ' + Item.Description + ' | Fournisseur: ' + Item."Vendor No." + ' | Unité: ' + ItemIdentifier."Unit of Measure Code");

        Item.SetFilter(Description, '*' + Search + '*');
        if Item.FindFirst() then
            exit('Item No: ' + Item."No." + ' | Description: ' + Item.Description + ' | Fournisseur: ' + Item."Vendor No." + ' | Unité: ' + Item."Base Unit of Measure");
        exit('Aucun résultat trouvé pour: ' + Search);
    end;



}
