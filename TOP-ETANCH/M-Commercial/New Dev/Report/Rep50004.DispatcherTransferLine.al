namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Transfer;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Item;
using PHARMATEC.PHARMATEC;
using Microsoft.Inventory.Location;

report 50004 "Dispatch Transfer Lines"
{
    Caption = 'Dispatch Transfer Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem(TransferLine; "Transfer Line")
        {
            dataitem(Location; Location)
            {
                DataItemTableView = where("Use As In-Transit" = const(false));

                dataitem(Bin; Bin)
                {
                    DataItemLinkReference = Location;
                    DataItemLink = "Location Code" = field(Code);
                    DataItemTableView = where(Empty = const(false));
                    RequestFilterFields = "Code";

                    trigger OnPreDataItem()
                    var
                        verif: Codeunit VerificationStock;
                    begin
                        if not verif.LocationHasBins(Location) then
                            CurrReport.Skip();
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        DispatchFromBins(Location.Code, Code, RemainingQty, TransferLine);
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if TransferLine."Transfer-from Code" <> '' then
                        SetRange(Code, TransferLine."Transfer-from Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RemainingQty := TransferLine.Quantity;
                noligne := TransferLine."Line No.";
            end;
        }
    }

    var
        RemainingQty: Decimal;
        noligne: Integer;

    local procedure DispatchFromBins(locationCode: Code[25]; BinCode: Code[25]; var QtyDemande: Decimal; transferLine: Record "Transfer Line")
    var
        TransferL: Record "Transfer Line";
        item: Record Item;
        dispo: Decimal;
    begin
        if QtyDemande <= 0 then
            exit;

        item.get(transferLine."Item No.");
        item.SetFilter("Location Filter", locationCode);
        item.SetFilter("Bin Filter", BinCode);
        item.CalcFields("Inventory in Warehouse", "Qty. to ship on order line");

        dispo := item."Inventory in Warehouse" - item."Qty. to ship on order line";

        if dispo <= 0 then
            exit;

        TransferL.Init();
        TransferL := transferLine;
        noligne += 1;
        TransferL."Line No." := noligne;
        if QtyDemande <= dispo then begin
            TransferL.Validate(Quantity, QtyDemande);
            QtyDemande := 0;
            transferLine.Description := '*****Ligne Dispatchée*****';
            transferLine.Validate(Quantity, 0);
            transferLine.Modify();
        end else begin
            TransferL.Validate(Quantity, dispo);
            QtyDemande -= dispo;
        end;
        TransferL.Validate("Transfer-from Code", locationCode);
        TransferL.Validate("Transfer-from Bin Code", BinCode);
        TransferL.Insert();
    end;
}