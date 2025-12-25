pageextension 50164 pourchaseorderExt extends "Purchase Order"
{
    layout
    {

        addlast(General)
        {
            field("DI No."; Rec."DI No.")
            {
                ApplicationArea = all;
                Importance = Promoted;
                Caption = 'No Dossier importation';



            }

        }
    }

    actions
    {


        addafter("Archive Document")
        {

            action(UpdateNGPOrigin)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Visible = true;
                caption = 'MAJ Origine NGP';
                Image = Purchasing;
                // AccessByPermission = tabledata "Purch. Rcpt. Line" = m;
                trigger OnAction()
                var
                    RecepLine: Record "Purch. Rcpt. Line";
                    PurchOrderLines: Record "Purchase Line";
                    cupurchevent: Codeunit PurchaseEvents;
                begin
                    if Rec."Currency Code" <> '' then begin

                        Rec.TestField("DI No.");
                        PurchOrderLines.SetRange("Document Type", PurchOrderLines."Document Type"::Order);
                        PurchOrderLines.SetRange("Document No.", Rec."No.");
                        if PurchOrderLines.FindFirst() then
                            cupurchevent.updateNGPOrigin(PurchOrderLines);



                    end;

                end;
            }





        }
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if Rec."Currency Code" <> '' then begin

                    Rec.TestField("DI No.");
                    CheckNGP(Rec);
                    if not confirm('Voulez-vous vraiment Valider cette commande? avec un taux de change %1', False, 1 / rec."Currency Factor") then Message('cette commande ne peut pas etre validée');
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


