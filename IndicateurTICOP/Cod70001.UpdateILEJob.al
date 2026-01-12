namespace PHARMATECCLOUD.PHARMATECCLOUD;



using System.Threading;
using Microsoft.Inventory.Location;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.CRM.Opportunity;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Posting;
using Microsoft.Inventory.Ledger;
using Microsoft.Finance.GeneralLedger.Setup;
using System.Reflection;

codeunit 50101 "ILE UPDATE JOB "
{


    //TableNo = "Job Queue Entry";
    Permissions = tabledata "Item Ledger Entry" = m;
    trigger OnRun()
    var
        all: Boolean;

    begin
        //    DestroyLocationDemoContenent();
        UpdateILE_Info(false);
    end;


    local procedure DestroyLocationDemoContenent()
    var
        IJL: record 83;
        Line: integer;
        CUItemJnChkLine: Codeunit "Item Jnl.-Post Line";
        ILE: Record "Item Ledger Entry";

    begin
        /*
                ILE.SetCurrentKey("Type de transfert");
                ILE.SetRange("Type de transfert", ILE."Type de transfert"::"Sortie Définitive");
                ILE.SetCurrentKey(Open, Positive);
                ILE.SetRange(Open, true);
                ILE.SetRange(Positive, true);
                IF ILE.FindFirst() then
                    repeat
                        IJL.Reset();
                        line += 10000;
                        IJL.init;
                        IJL."Posting Date" := Today;
                        IJL."Document Date" := Today;
                        IJL.Validate("Item No.", ILE."Item No.");
                        IJL.Validate(Quantity, ILE."Remaining Quantity");
                        IJL."Entry Type" := IJL."Entry Type"::"Negative Adjmt.";
                        IJL."Document No." := ILE."Document No.";
                        IJL."Journal Template Name" := 'Démo';
                        IJL."Journal Batch Name" := 'Démo';
                        IJL."Line No." := Line;
                        IJL.VALIDATE("Location Code", ILE."Location Code");
                        IJL.Description := 'Echantillon ' + ILE."Nom Origine";
                        IJL."Source Code" := 'démo';
                        InsertReservationEntryItemJournalLine(IJL, ILE."Lot No.", ILE."Expiration Date", ILE."Entry No.");
                        CUItemJnChkLine.RunWithCheck(IJL);
                    UNTIL ILE.NEXT = 0;
                    */
    END;



    local procedure InsertReservationEntryItemJournalLine(ItemJLine: Record "Item Journal Line"; LotNo: code[50]; ExperiationDate: Date; ILE_EntryNo: integer)
    var
        ReservationEntry: Record "Reservation Entry";


    begin

        ReservationEntry.Init();
        ReservationEntry.validate("Source Type", 83);
        ReservationEntry.validate("Source Subtype", 3);
        ReservationEntry.validate("Source ID", ItemJLine."Journal Template Name");
        ReservationEntry.validate("Source Batch Name", ItemJLine."Journal Batch Name");
        ReservationEntry.validate("Source Ref. No.", ItemJLine."Line No.");
        ReservationEntry.validate("Item No.", ItemJLine."Item No.");
        ReservationEntry."Variant Code" := ItemJLine."Variant Code";
        ReservationEntry.validate("Location Code", ItemJLine."Location Code");
        ReservationEntry.validate("Quantity (Base)", -ItemJLine.Quantity);
        ReservationEntry.validate("Lot No.", LotNo);
        ReservationEntry.validate("Expiration Date", ExperiationDate);
        ReservationEntry.validate("Reservation Status", ReservationEntry."Reservation Status"::Prospect);
        ReservationEntry."Created By" := UserId;
        ReservationEntry.Validate("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        ReservationEntry.Validate("Appl.-to Item Entry", ILE_EntryNo);
        ReservationEntry."Creation Date" := today;
        ReservationEntry.insert;
    end;

    procedure UpdateILE_Info(all: Boolean)
    var

        ILE: record "Item Ledger Entry";
        MontantMarge: Decimal;
        SalesEvent: Codeunit SalesEvents;
        Item: Record Item;
        TypeHelper: Codeunit "Type Helper";

        Hour: Integer;
        Minute: Integer;
        Second: Integer;
        Customer: Record Customer;
        Vendor: Record Vendor;


    begin
        ILE.LockTable();

        ILE.SETCURRENTKEY("Item No.", "Posting Date");
        ILE.SETFILTER("Item No.", '<>%1', '');
        TypeHelper.GetHMSFromTime(Hour, Minute, Second, DT2Time(CurrentDateTime));

        if not all and (Hour <= 16) then
            ILE.SETRANGE("Posting Date", CALCDATE('<-1W>', TODAY), TODAY);


        ILE.SETAUTOCALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)", "Sales Amount (Expected)", "Sales Amount (Actual)");
        if ILE.FindFirst() then begin

            repeat
                Item.get(ILE."Item No.");
                IlE."Operation Cost" := (ILE."Cost Amount (Actual)") + (ILE."Cost Amount (Expected)");
                /*   ILE.Famille := Item.Famille;
                  ILE."Sous-famille 1" := Item."Sous-famille 1";
                  ILE."Sous-famille 2" := Item."Sous-famille 2"; */
                ILE.Designation := item.Description;

                if ile."Entry Type" = ILE."Entry Type"::Sale then begin
                    ILE."Sales Operation Amount" := ILE."Sales Amount (Actual)" + ILE."Sales Amount (Expected)";
                    MontantMarge := ILE."Sales Operation Amount" + IlE."Operation Cost";

                    ILE."Profit Amount" := MontantMarge;

                    Customer.get(ILE."Source No.");
                    ILE."Nom Origine" := Customer.Name;
                    //////OD 270225
                    // ILE."Groupe Compta Client" := Customer."Customer Posting Group";
                    //////


                    if ILE."Sales Operation Amount" <> 0 then
                        ILE."Profit %" := (MontantMarge / IlE."Sales Operation Amount") * 100
                    else
                        ILE."Profit %" := 0;

                    if ILE."Operation Cost" <> 0 then
                        ILE."Purchase Profit %" := -(MontantMarge / ILE."Operation Cost") * 100
                    else
                        ILE."Purchase Profit %" := 100;
                end;

                if ILE."Entry Type" = ILE."Entry Type"::Purchase then begin

                    if Vendor.get(ILE."Source No.") then begin
                        ILE."Nom Origine" := Vendor.Name;
                        // ILE."Groupe Compta Client" := Vendor."Vendor Posting Group";

                    end;


                end;

                ILE.Modify(true);

            until ILE.Next() = 0
        end;
    end;

    /*local procedure LancerDevis(var SalesHeader: Record "Sales Header")
    var
        Opp: Record Opportunity;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then begin
            repeat
                if SalesHeader.Status = SalesHeader.Status::Open then begin

                    if SalesHeader."External Document No." <> '' then begin

                        if Opp.Get(SalesHeader."External Document No.") then begin

                            if opp."Fin de la première période" <= Today then begin

                                SalesHeader.Status := SalesHeader.Status::Released;
                                SalesHeader.Modify();

                            end;
                        end;
                    end;
                end;
            until SalesHeader.Next() = 0;
        end;
    end;*/

}


