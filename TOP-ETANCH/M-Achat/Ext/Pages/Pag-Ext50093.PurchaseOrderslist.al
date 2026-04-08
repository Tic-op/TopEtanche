namespace Top.Top;

using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;

pageextension 50093 "Purchase Orders list" extends "Purchase Order list"
{

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if Rec."Currency Code" <> '' then begin

                    Rec.TestField("DI No.");
                    CheckNGP(Rec);
                    if not confirm('Voulez-vous vraiment Valider cette commande? avec un taux de change %1', False, Round(1 / rec."Currency Factor", 0.0000001, '=')) then Message('cette commande ne peut pas etre validée');
                end;
            end;
        }
    }
    local procedure CheckNGP(PurchaseOrder: record "Purchase Header")
    var
        PurchaseLines: Record "Purchase Line";
        itm: Record Item;
    begin
        PurchaseLines.SetRange(PurchaseLines."Document Type", PurchaseOrder."Document Type");
        PurchaseLines.SetRange(PurchaseLines."Document No.", PurchaseOrder."No.");
        PurchaseLines.SetRange(PurchaseLines.Type, PurchaseLines.type::Item);
        PurchaseLines.FindFirst();
        repeat
            PurchaseLines.TestField("Tariff No.");
            PurchaseLines.TestField(PurchaseLines."Country region origin code");
        until PurchaseLines.Next() = 0;


    end;
}
