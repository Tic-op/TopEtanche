namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Transfer;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Location;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Item;
using PHARMATEC.PHARMATEC;

pageextension 50015 TransferOrderSubform extends "Transfer Order Subform"
{
    layout
    {
        modify("Transfer-To Bin Code")
        {
            Visible = true;
        }
        modify("Transfer-from Bin Code")
        {
            Visible = true;
        }
        modify("Qty. to ship")
        {
            visible = false;
        }
        modify("Qty. to Receive")
        {
            Visible = false;
        }
        modify("Receipt Date")
        { visible = false; }
        modify("Shipment Date") { visible = false; }
        modify("Reserved Quantity Inbnd.") { visible = false; }
        modify("Reserved Quantity Outbnd.") { visible = false; }
        modify("Reserved Quantity Shipped") { visible = false; }

        addafter(Description)
        {
            field("Disponibilité globale"; rec.GetDisponibilite(true))
            {
                ApplicationArea = all;
                visible = true;
                DecimalPlaces = 0 : 3;
                Editable = false;
                trigger OnDrillDown()
                var
                    Location: record Location;
                    Bin: record Bin;
                    Textmessage: text;
                    item: Record item;

                begin
                    if item.get(rec."Item No.") then begin
                        Location.findset();
                        Textmessage := '';
                        repeat
                            if (location.Type = location.type::Casse) or (Location.type = location.type::Tampon) then continue;
                            Textmessage := Textmessage + Location.Code + '------' + item."CalcDisponibilité"(Location.code, '').ToText() + '\';
                            if location."Bin Mandatory" then begin
                                Bin.SetRange("Location Code", Location.code);
                                if bin.FindFirst() then
                                    repeat
                                        Textmessage := Textmessage + '>>>>' + Bin.Code + '------' + item."CalcDisponibilité"(Location.code, bin.code).ToText() + '\';


                                    until bin.next = 0;


                            end





                        until location.next = 0;
                        Message(Textmessage);
                    end


                end;
            }
            field("Disponibilité"; rec.GetDisponibilite(false))
            {
                ApplicationArea = all;
                Visible = true;
                DecimalPlaces = 0 : 3;
                editable = false;
            }

        }

    }
    actions
    {
        addlast(processing)
        {
            action("Dispatch transfer line")
            {
                Caption = 'Dispatch';
                ApplicationArea = All;
                Image = NewTransferOrder;

                trigger OnAction()
                var
                    Dispatch: Report "Dispatch Transfer Lines";
                    TL: Record "Transfer Line";
                    Location: Record Location;
                    verif: Codeunit VerificationStock;

                begin
                    TL.SetRange("Document No.", Rec."Document No.");
                    TL.SetRange("Line No.", Rec."Line No.");

                    if TL.FindFirst() then begin
                        if Location.Get(TL."Transfer-from Code") then begin
                            if verif.LocationHasBins(Location) then begin
                                Dispatch.SetTableView(TL);
                                Dispatch.Run();
                            end else
                                Error('Impossible de dispatcher cette ligne, le magasin n''a pas d''emplacements');
                        end;
                    end;
                end;

            }
            action("Proposer emplacements")
            {
                Caption = 'Proposer des emplacement';
                Image = Allocate;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedOnly = true;
                ApplicationArea = All;
                visible = false;


                trigger OnAction()
                var
                    Binc: record "Bin Content";
                    TransferHeader: Record "Transfer Header";
                    TransferLine: record "Transfer Line";
                    Qtémin: decimal;
                    item: record Item;

                begin

                    TransferHeader.get(rec."Document No.");
                    Binc.SetCurrentKey("Disponibilité");
                    if item."CalcDisponibilité"(TransferHeader."Transfer-from Code", '') < rec."Quantity (Base)" then
                        message('La quantité saisie %1 n''est pas disponible dans le magasin %2', rec."Quantity (Base)", TransferHeader."Transfer-from Code")
                    else begin
                        Binc.setrange("Location Code", TransferHeader."Transfer-from Code");
                        Binc.setrange("Item No.", rec."Item No.");
                        Binc.setfilter("Disponibilité", '>%1', 0);
                        Binc.SetAutoCalcFields("Quantity (Base)", Quantity);
                        Binc.findfirst();
                        repeat
                            //"Qtémin" := Binc."Quantity (Base)";
                            "Qtémin" := Binc."Disponibilité";

                            TransferLine.Init();
                            TransferLine."Document No." := TransferHeader."No.";
                            TransferLine."Line No." := lastlineNo() + 10000;
                            TransferLine.Validate("Item No.", rec."Item No.");
                            TransferLine."Transfer-from Bin Code" := Binc."Bin Code";

                            If "Qtémin" < rec."Quantity (Base)" then
                                TransferLine.Validate("Quantity (Base)", "Qtémin")
                            else
                                TransferLine.validate("Quantity (Base)", rec."Quantity (Base)");
                            if TransferLine."Quantity (Base)" <> 0 then
                                TransferLine.insert();
                            rec.validate("Quantity (Base)", rec."Quantity (Base)" - "Qtémin");
                            rec.modify(true);
                        until (Binc.next() = 0) or (rec."Quantity (Base)" = 0);


                        if rec."Quantity (Base)" <= 0 then rec.Delete(true);
                    end;


                end;
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    var
        OrdrePrep: Record "Ordre de preparation";

    begin
        OrdrePrep.setrange("document type", OrdrePrep."document type"::Transfert);
        OrdrePrep.SetRange("Order No", rec."Document No.");
        // OrdrePrep.setrange(Statut,OrdrePrep.Statut::"Créé");
        if OrdrePrep.Findset() then begin
            //if OrdrePrep.Statut = OrdrePrep.Statut::"Créé" then
            Error('Impossible de modifier cette ligne, un bon de préparation associé existe, penser à supprimer le bon de préparation');
        end;
    end;

    procedure lastlineNo(): integer
    var
        transferL: record "Transfer Line";
    begin

        transferL.setrange("Document No.", rec."Document No.");
        if transferL.findlast() then
            exit(transferL."Line No.") else
            exit(0);



    end;
}
