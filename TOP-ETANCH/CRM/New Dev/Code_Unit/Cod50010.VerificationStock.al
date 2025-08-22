namespace PHARMATEC.PHARMATEC;
using Microsoft.Sales.Document;
using Microsoft.Sales.Setup;
using Microsoft.Utilities;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Inventory.Ledger;
using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Location;
using Microsoft.Warehouse.ADCS;
using Microsoft.Warehouse.Ledger;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Item;

codeunit 50010 "VerificationStock"
{
    /* trigger OnRun()
     var
         test: Codeunit "TICOP TOP-ETANCH";
         test2: Record 7303;

     begin
         message('%1', test.login('', '1234', ''));

     end;*/


    procedure ItemAvailInLocation(salesLine: Record "Sales Line"; Location: Record Location; bin: Record Bin): Boolean
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
    end;

    procedure LocationHasBins(Location: Record Location): Boolean
    var
        Bins: Record Bin;
    begin
        Bins.SetFilter("Location Code", Location.Code);
        exit(Bins.FindFirst());
    end;



    procedure VerificationFusioncommande(BlanketOrderNo: code[20]; var listeCommande: code[500]): boolean
    var
        SalesLine: Record "Sales Line";
        //listecommande2: code[500];
        Numcommande: code[20];
    begin
        listeCommande := '';
        SalesLine.SetCurrentKey("Document Type", "Blanket Order No.", "Blanket Order Line No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.setrange("Blanket Order No.", blanketOrderNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter(Quantity, '>0');
        SalesLine.setrange("Quantity Shipped", 0);

        if SalesLine.FindFirst() then
            repeat
                if SalesLine."Document No." <> Numcommande then begin

                    if listeCommande = '' then
                        listeCommande := SalesLine."Document No."
                    else
                        listecommande := listecommande + '|' + SalesLine."Document No."
                end;
                Numcommande := SalesLine."Document No.";

            until SalesLine.Next() = 0;

        exit(listecommande <> '');



    end;

    procedure FusionCommande(blanketOrderNo: code[20]) NoCommande: Code[20] //IS
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NewSalesHeader: Record "Sales Header";
        NewSalesLine: Record "Sales Line";
        OLDSalesLine: Record "Sales Line";
        CuseriesNo: Codeunit "No. Series";
        salesSetup: Record "Sales & Receivables Setup";
        SE: Codeunit SalesEvents;
        Line: Integer;
        //    Numcommande: code[20];
        listeCommande: code[500];
        Archiv: Codeunit ArchiveManagement;
    begin

        salesSetup.Get();
        if VerificationFusioncommande(BlanketOrderNo, listeCommande) then begin
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetFilter("No.", listeCommande);


            if SalesHeader.FindFirst() then begin

                NewSalesHeader.Init();
                NewSalesHeader := SalesHeader;
                NewSalesHeader.Validate("Posting Date", Today);
                NewSalesHeader."No." := CuseriesNo.GetNextNo(salesSetup."Order Nos.", WorkDate(), true);
                NewSalesHeader."Blanket Order No." := blanketOrderNo;
                NewSalesHeader.Insert(true);

                //repeat   ****

                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetFilter("Document No.", listeCommande);
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter(Quantity, '>0');
                SalesLine.setrange("Quantity Shipped", 0);

                if SalesLine.FindFirst() then begin
                    Line := 10000;
                    repeat
                        // Vérifie si la ligne existe déjà dans la nouvelle commande
                        OLDSalesLine.Reset();
                        OLDSalesLine.SetRange("Document Type", NewSalesHeader."Document Type");
                        OLDSalesLine.SetRange("Document No.", NewSalesHeader."No.");
                        OLDSalesLine.SetRange(Type, OLDSalesLine.Type::Item);
                        OLDSalesLine.SetRange("No.", SalesLine."No.");
                        OLDSalesLine.SetRange("Location Code", SalesLine."Location Code");
                        OLDSalesLine.SetRange("Bin Code", SalesLine."Bin Code");
                        OLDSalesLine.SetRange("Unit Price", SalesLine."Unit Price");
                        OLDSalesLine.SetRange("Line Discount %", SalesLine."Line Discount %");
                        OLDSalesLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");

                        if OLDSalesLine.FindFirst() then begin
                            OLDSalesLine.Validate(Quantity, OLDSalesLine.Quantity + SalesLine.Quantity);
                            OLDSalesLine.Modify();
                        end else begin
                            NewSalesLine := SalesLine;
                            NewSalesLine."Document Type" := NewSalesHeader."Document Type";
                            NewSalesLine.Validate("Document No.", NewSalesHeader."No.");
                            NewSalesLine."Line No." := Line;
                            NewSalesLine.Insert(true);
                            Line += 10000;
                        end;
                    until SalesLine.Next() = 0;
                end;
                // until SalesHeader.Next() = 0;

            end;




            SalesHeader.Reset();
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetFilter("No.", listeCommande);

            if SalesHeader.Findfirst() then //****
                repeat
                    Archiv.StoreSalesDocument(SalesHeader, false);
                    SalesHeader.Delete(true);
                until SalesHeader.Next() = 0;
            /* 
                        SalesLine.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        SalesLine.SetFilter("Document No.", listeCommande);
                        SalesLine.DeleteAll(true);
                        SalesHeader.DeleteAll(true);
             */
            NoCommande := NewSalesHeader."No.";
            Message('Commande %1', NoCommande);
            SE.InsertApprobation(NewSalesHeader);
        end
        else
            Error('Aucun commande à regrouper  pour la commande cadre %1', blanketOrderNo);
    end;


    procedure FusionLigneCommande(SalesType: Enum "Sales Document Type"; SalesHNo: Code[20])
    var
        SaleL: record "Sales Line";
        SaleL2: record "Sales Line";
        SaleL3: record "Sales Line";
    begin
        SaleL.setrange("Document Type", SalesType);
        SaleL.setrange("Document No.", SalesHNo);

        if SaleL.findfirst() then
            repeat
                SaleL2.Reset();
                SaleL2.setrange("Document Type", SalesType);
                SaleL2.setrange("Document No.", SalesHNo);
                SaleL2.setrange("Location Code", SaleL."Location Code");
                SaleL2.setrange("Bin Code", SaleL."Bin Code");
                SaleL2.setrange("Line Discount %", SaleL."Line Discount %");
                SaleL2.setrange("Unit Price", SaleL."Unit Price");
                SaleL2.setrange("Unit of Measure Code", SaleL."Unit of Measure Code");
                if SaleL2.Count() > 1 then begin
                    SaleL2.findlast();
                    SaleL3.init();
                    SaleL2.CalcSums(quantity);
                    SaleL2.modify();
                    SaleL3 := SaleL2;
                    SaleL3.Validate(Quantity, SaleL2.Quantity);
                    SaleL3."Line No." := SaleL3.GetLastLineNo() + 10000;
                    SaleL2.DeleteAll();
                    SaleL3.insert(true);
                end

            until SaleL.next = 0



    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Entry", OnAfterInsertEvent, '', false, false)]
    procedure CalculDisponibilitéBinContent(var Rec: Record "Warehouse Entry")
    Var
        BinC: record "Bin Content";
        item: record item;
    begin

        if Rec."Bin Code" <> '' then
            if Binc.get(rec."Location Code", rec."Bin Code", rec."Item No.") then begin
                item.get(rec."Item No.");
                BinC."Disponibilité" := item."CalcDisponibilité"(item."No.", rec."Location Code", rec."Bin Code");


            end;
    end;




}

