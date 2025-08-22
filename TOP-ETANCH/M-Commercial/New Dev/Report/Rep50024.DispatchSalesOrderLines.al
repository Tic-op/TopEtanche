namespace Pharmatec.Pharmatec;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Location;

report 50024 "Dispatch Sales Order Lines"
{
    Caption = 'Disptach Sales Order Lines';
    ProcessingOnly = true;
    dataset
    {
        dataitem(SalesLine; "Sales Line")
        {
            dataitem(Location; Location)
            {
                RequestFilterFields = code;
                DataItemTableView = where("Use As In-Transit" = const(false));



                dataitem(Bin; Bin)
                {
                    DataItemLinkReference = Location;
                    DataItemLink = "Location code" = field(code);
                    DataItemTableView = where(Empty = const(false));
                    RequestFilterFields = "Code";
                    trigger OnAfterGetRecord()
                    begin
                        InsertQtyFromBins(Location.Code, Code, RemainingQty, SalesLine);
                        // Message(Bin.Code);


                    end;




                }


                trigger OnAfterGetRecord()
                var
                    verif: Codeunit VerificationStock;
                begin
                    IF NOT verif.LocationHasBins(Location) THEN begin
                        InsertQtyFormLocation(Location.Code, RemainingQty, SalesLine);
                    end;



                end;

            }
            trigger OnAfterGetRecord()

            begin
                RemainingQty := SalesLine."Qty. to Ship";
                noligne := salesline."Line No.";
            end;

            trigger OnPostDataItem()
            begin
                /*  if RemainingQty <> 0 then
                     SalesLine.Validate(Quantity, RemainingQty);
                 SalesLine.Modify(); */


            end;


        }



    }
    /* 
        local procedure LocationHasBins(): Boolean
        var
            Bins: Record Bin;
        begin
            Bins.SetFilter("Location Code", Location.Code);
            exit(Bins.FindFirst());
        end;

        local procedure ItemAvailInLocation(): Boolean
        var
            Item: Record Item;
        begin
            if SalesLine.Type = SalesLine.Type::Item then begin
                item.get(salesLine."No.");
                Item.SetFilter("Location Filter", Location.Code);
                Item.SetFilter("Bin Filter", Bin."Code");
                Item.CalcFields("Inventory in Warehouse");

                exit(Item."Inventory in Warehouse" > 0);
            end
            else
                exit(false);
        end; */


    var
        RemainingQty: Decimal;
        noligne: Integer;

    local procedure InsertQtyFromBins(locationCode: Code[25]; BinCode: Code[25]; var QtyDemande: Decimal; salesline2: Record "Sales Line")
    var
        SalesL: Record "Sales Line";
        item: Record Item;
        dispo: Decimal;
    begin

        if QtyDemande <= 0 then
            exit;


        item.get(salesLine."No.");
        item.SetFilter("Location Filter", LocationCode);
        item.SetFilter("Bin Filter", BinCode);
        item.CalcFields("Inventory in Warehouse", "Qty. to ship on order line");

        dispo := item."Inventory in Warehouse" - item."Qty. to ship on order line";



        if dispo <= 0 then
            exit;


        SalesL.Init();
        SalesL := salesline2;
        noligne += 1;
        SalesL."Line No." := noligne;
        if QtyDemande <= dispo then begin
            SalesL.Validate(Quantity, QtyDemande);
            QtyDemande := 0;
            salesline2.Description := '*****Ligne Dispatchée*****';
            salesline2.validate(Quantity, 0);
            salesline2.Modify();

        end else begin
            SalesL.Validate(Quantity, dispo);
            QtyDemande -= dispo;
        end;
        SalesL.Validate("Location Code", locationCode);
        SalesL.Validate("Bin Code", BinCode);
        SalesL.Insert();

        //   Message('InsertQtyFormLBBBIN %1 \%2', SalesL.Quantity, SalesL);


    end;





    local procedure InsertQtyFormLocation(locationCode: Code[25]; var QtyDemande: Decimal; salesline2: Record "Sales Line"): Decimal
    var
        SalesL: Record "Sales Line";
        item: Record Item;
        dispo: Decimal;

    begin

        if QtyDemande <= 0 then
            exit;


        item.get(salesLine."No.");
        item.SetFilter("Location Filter", LocationCode);
        item.CalcFields(Inventory, "Qty. on Sales Order");
        dispo := item.Inventory - item."Qty. on Sales Order";


        if dispo <= 0 then
            exit;
        SalesL.Init();
        SalesL := salesline2;
        noligne += 1;
        SalesL."Line No." := noligne;
        if QtyDemande <= dispo then begin
            SalesL.Validate(Quantity, QtyDemande);
            QtyDemande := 0;
            salesline2.Description := '*****Ligne Dispatchée****';
            salesline2.validate(Quantity, 0);
            salesline2.Modify();
        end else begin
            SalesL.Validate(Quantity, dispo);
            QtyDemande -= dispo;
        end;
        SalesL.Validate("Location Code", locationCode);
        SalesL.Insert();
        //  Message('InsertQtyFormLocation %1 \%2', SalesL.Quantity, SalesL);
    end;

}
