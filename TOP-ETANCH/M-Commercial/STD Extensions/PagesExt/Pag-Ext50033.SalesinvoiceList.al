namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Setup;
using TopEtanch.TopEtanch;

pageextension 50033 SalesinvoiceList extends "Sales Invoice List"
{// InsertAllowed = false ;
    layout
    {

        modify("Sell-to Customer No.")
        {
            StyleExpr = StylePreparation;
        }

        modify("Sell-to Customer Name")
        {
            StyleExpr = StylePreparation;
        }
        modify("Posting date")
        {
            StyleExpr = StylePreparation;
        }
        modify("No.")
        {
            StyleExpr = StylePreparation;
        }

        addafter("No.")
        {
            field("Posting No."; Rec."Posting No.")
            {
                Style = Favorable;
                ApplicationArea = all;
            }

        }

        addafter(Status)
        {

            field("Bon de preparations"; Rec."Bon de preparations")
            {

                Caption = 'Bon de preparations';
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    ListBonPre: Page "Liste bon de préparation";
                    OrderPre: record "Ordre de preparation";
                begin
                    OrderPre.setrange("Order No", rec."No.");
                    ListBonPre.SetTableView(OrderPre);
                    ListBonPre.Run();
                end;
            }
            field("Bon de preparations préparés"; Rec."Bon de preparations préparés")
            {
                Caption = 'Bon de préparations préparés';
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    ListBonPre: Page "Liste bon de préparation";
                    OrderPre: record "Ordre de preparation";
                begin
                    OrderPre.setrange("Order No", rec."No.");
                    OrderPre.SetRange(Statut, OrderPre.Statut::"Préparé");
                    ListBonPre.SetTableView(OrderPre);
                    ListBonPre.Run();
                end;
            }
        }

    }
    actions
    {
        addlast(Processing)
        {
            action(ReserveInvoiceNo)
            {
                Caption = 'Réserver Numéros';
                Image = RegisteredDocs;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin

                    CurrPage.SetSelectionFilter(SalesHeader);

                    if not Confirm('Voulez vous attribuer des numéros de validation pour %1 factures ? \fitlres : %2', false, SalesHeader.Count, Rec.GetFilters) then
                        exit;



                    if SalesHeader.IsEmpty() then
                        Error('Veuillez sélectionner au moins une facture.');
                    SalesHeader.MarkedOnly(true);


                    ReserveInvoiceNumbers(SalesHeader);
                end;
            }
        }


    }
    Trigger OnOpenPage()
    begin

        // rec.SetFilter("Date Filter", '');
    end;

    trigger OnAfterGetRecord()
    begin
        if (rec.Status = rec.Status::Open) and (Rec."Bon de preparations préparés" = Rec."Bon de preparations")
        and (Rec."Bon de preparations" <> 0) then
            StylePreparation := 'Favorable'
        else
            StylePreparation := 'Standard';
    end;

    local procedure ReserveInvoiceNumbers(var SalesHeader: Record "Sales Header")
    var
        //   SalesHeader: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: Code[20];
        Date0: Date;
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Posted Invoice Nos.");

        //SalesHeader.Copy(SalesHeaderSel);
        SalesHeader.SetAutoCalcFields(Amount);
        if SalesHeader.FindSet(true) then begin
            repeat
                if Date0 = 0D then
                    Date0 := SalesHeader."Posting Date";

                if Date0 <> SalesHeader."Posting Date" then
                    Error('Impossible de réserver pour des différentes dates');

                if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then
                    error('Vous ne pouvez exécuter cette action que sur les factures');


                if SalesHeader.Amount <= 0 then
                    Error('Montant doit être positif');

                CheckCombinedLines(SalesHeader."No.");

                NewNo :=
                    NoSeriesMgt.GetNextNo(SalesSetup."Posted Invoice Nos.", SalesHeader."Posting Date", true);

                SalesHeader.Validate("Posting No.", NewNo);
                SalesHeader.Modify(true);

            until SalesHeader.Next() = 0;
        end;

        Message('Numéros réservés avec succès.');
    end;

    local procedure CheckCombinedLines(No: Code[20])
    var
        SL: Record "Sales Line";
    begin
        SL.setrange("Document Type", SL."Document Type"::Invoice);
        SL.SetRange("Document No.", No);
        SL.SetRange(Type, SL.Type::Item);
        SL.SetRange("Shipment No.", '');
        if SL.FindFirst() then
            Error('La facture %1 n''est pas regroupée !');

    end;

    var
        StylePreparation: Text;
}
