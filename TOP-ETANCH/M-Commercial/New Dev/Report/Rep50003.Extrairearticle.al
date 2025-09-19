namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Transfer;
using Microsoft.Sales.Document;

report 50003 "Extraire article"
{
    //ApplicationArea = All;
    Caption = 'Extraire article';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", Famille, Description;
            trigger OnAfterGetRecord()
            var
                TransferLine: Record "Transfer Line";
                ItemStockMin: Record "Item stock min by location";
                DisponibiliteDest: Decimal;
                DispoMagasinSource: Decimal;
                StockMin: Decimal;
                QtyToTransfer: Decimal;
                LineNo: Integer;
                sl: Record "Sales Line";
            //item: Record item;
            begin
                if TransferHeader."Transfer-from Code" = '' then
                    Error('Le magasin source doit être rempli');
                if TransferHeader."Transfer-to Code" = '' then
                    Error('Le magasin destination doit être rempli');

                ItemStockMin.SetRange(Location, TransferHeader."Transfer-to Code");
                ItemStockMin.SetRange(Item, "No.");

                if ItemStockMin.FindFirst() then begin
                    repeat
                        if Item.Get(ItemStockMin.Item) then begin
                            DisponibiliteDest := "CalcDisponibilité"(TransferHeader."Transfer-to Code", '');
                            StockMin := ItemStockMin."Stock min";

                            if DisponibiliteDest < StockMin then begin
                                QtyToTransfer := StockMin - DisponibiliteDest;
                                DispoMagasinSource := item."CalcDisponibilité"(TransferHeader."Transfer-from Code", '');

                                if DispoMagasinSource <= QtyToTransfer then
                                    QtyToTransfer := DispoMagasinSource;

                                if QtyToTransfer > 0 then begin
                                    TransferLine.SetRange("Document No.", TransferHeader."No.");
                                    if TransferLine.FindLast() then
                                        LineNo := TransferLine."Line No." + 10000
                                    else
                                        LineNo := 10000;

                                    TransferLine.Init();
                                    TransferLine."Document No." := TransferHeader."No.";
                                    TransferLine."Line No." := LineNo;
                                    TransferLine.Validate("Item No.", ItemStockMin.Item);
                                    TransferLine.Validate(Quantity, QtyToTransfer);
                                    TransferLine.Validate("Transfer-from Code", TransferHeader."Transfer-from Code");
                                    TransferLine.Validate("Transfer-to Code", TransferHeader."Transfer-to Code");
                                    TransferLine.Insert(true);
                                end;
                            end;
                        end;
                    until ItemStockMin.Next() = 0;
                end;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }
    }

    procedure SetTransferNo(TransfertNo0: Code[20])
    begin
        TransferHeader.Get(TransfertNo0);
        TransferHeader.TestField(Status, 0);
    end;

    var
        TransferHeader: Record "Transfer Header";
}
