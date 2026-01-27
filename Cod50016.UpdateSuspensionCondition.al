namespace Top.Top;
using Microsoft.Sales.Document;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.History;
using Microsoft.Sales.Customer;

codeunit 50016 UpdateSuspensionCondition
{
    Permissions = tabledata "Sales Shipment Header" = Rim, tabledata "Sales Shipment Line" = Rim, tabledata "Sales Invoice Header" = Rim, tabledata "Sales Invoice Line" = rim
    , tabledata "Sales Cr.Memo Header" = rim, tabledata "Sales Cr.Memo Line" = Rim;

    procedure CorrigerDocumentVente(var SalesHeader: Record "Sales Header";
            NewVATBusPostingGroup: Code[20];
                    NewBusPostingGroup: Code[20]
    )
    var
        SalesLine: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";
        SalesShipmentHeader: Record "Sales Shipment Header";

    begin

        if (SalesHeader."VAT Bus. Posting Group" = NewVATBusPostingGroup) AND
   (SalesHeader."Gen. Bus. Posting Group" = NewBusPostingGroup) then
            exit;

        if NOT (SalesHeader."Document Type" = SalesHeader."Document Type"::"Order")
        AND NOT (SalesHeader."Document Type" = SalesHeader."Document Type"::"Quote")
        AND NOT (SalesHeader."Document Type" = SalesHeader."Document Type"::"Invoice") then
            exit;



        SalesHeader.CalcFields(Shipped);

        if (NewBusPostingGroup = '') or (NewVATBusPostingGroup = '') then
            Error('Groupe vide');

        //header
        SalesHeader."VAT Bus. Posting Group" := NewVATBusPostingGroup;
        SalesHeader."Gen. Bus. Posting Group" := NewBusPostingGroup;
        SalesHeader.Modify(false);

        //ligne to be be updated
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");

        if SalesLine.FindSet(true) then
            repeat

                if SalesLine."Quantity Invoiced" <> 0 then
                    Error('Certaines lignes sont déjà facturées');


                if (SalesLine.Type <> SalesLine.Type::" ") then begin

                    // Affectation directe
                    SalesLine."VAT Bus. Posting Group" := NewVATBusPostingGroup;
                    SalesLine."Gen. Bus. Posting Group" := NewBusPostingGroup;

                    VATPostingSetup.Get(NewVATBusPostingGroup, SalesLine."VAT Prod. Posting Group");
                    SalesLine."VAT %" := VATPostingSetup."VAT %";
                    SalesLine."Amount Including VAT" :=
                     SalesLine."VAT Base Amount" + Round(SalesLine."VAT Base Amount" * SalesLine."VAT %" / 100);
                    SalesLine.Modify(false);
                end;
            until SalesLine.Next() = 0;

        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and SalesHeader.Shipped then begin

            SalesShipmentHeader.SetCurrentKey("Order No.");
            SalesShipmentHeader.SetRange("Order No.", SalesHeader."No.");

            if SalesShipmentHeader.FindSet() then
                repeat
                    CorrigerExpédition(SalesShipmentHeader."No.", NewVATBusPostingGroup, NewBusPostingGroup);
                until SalesShipmentHeader.Next() = 0;
        end;
    end;


    local procedure CorrigerExpédition(BLNo: Code[20]; NewVATBusPostingGroup: Code[20];
                    NewBusPostingGroup: Code[20])
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        SalesShipmentHeader.GET(BLNo);

        if (SalesShipmentHeader."VAT Bus. Posting Group" <> NewVATBusPostingGroup) OR
                (SalesShipmentHeader."Gen. Bus. Posting Group" <> NewBusPostingGroup) then begin
            SalesShipmentHeader."VAT Bus. Posting Group" := NewVATBusPostingGroup;
            SalesShipmentHeader."Gen. Bus. Posting Group" := NewBusPostingGroup;
            SalesShipmentHeader.modify(false);

            SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");

            if SalesShipmentLine.FindSet(true) then
                repeat
                    if SalesShipmentLine."Qty. Invoiced (Base)" <> 0 then
                        Error('Certaines quantités sont déjà facturées dans %1', SalesShipmentHeader."No.");
                    if SalesShipmentLine.Type <> SalesShipmentLine.Type::" " then begin

                        SalesShipmentLine."VAT Bus. Posting Group" := NewVATBusPostingGroup;
                        SalesShipmentLine."Gen. Bus. Posting Group" := NewBusPostingGroup;


                        VATPostingSetup.Get(NewVATBusPostingGroup, SalesShipmentLine."VAT Prod. Posting Group");

                        SalesShipmentLine."VAT %" := VATPostingSetup."VAT %";

                        SalesShipmentLine.Modify(false);
                    end;
                until SalesShipmentLine.Next() = 0;

        end;
    end;



}
