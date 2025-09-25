namespace Pharmatec.Pharmatec;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using PHARMATECCLOUD.PHARMATECCLOUD;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Sales.History;

pageextension 50007 "Blanket Sales Order" extends "Blanket Sales Order"
{
    layout
    {
        addafter("Salesperson Code")
        {
            /* field("Work Description"; Work_description)
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    myoutstream: OutStream;
                begin
                    rec."Work Description".CreateOutStream(myoutstream);
                    myoutstream.WriteText(Work_description);


                end;

            } */
            field("Vente comptoir"; Rec."Vente comptoir")
            {
                ApplicationArea = all;
                Enabled = not PartiallyShipped;
                trigger OnValidate()
                begin
                    /*    if rec.PartiallyShipped() then
                           error('Le document est partiellement expédiée'); */
                    CurrPage.update();
                end;


            }
        }
        addbefore("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    CurrPage.update;
                end;
            }
            /* field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
             {
                 ApplicationArea = all;
             } */


        }
        addafter("Payment Terms Code")
        {
            field("Type de facturation"; rec."Type de facturation")
            {
                Visible = true;
                Caption = 'Type de facturation';
                ApplicationArea = all;
            }
            field("Ship-to Code2"; Rec."Ship-to Code")
            {

                ApplicationArea = all;
                Visible = true;

            }
        }
        moveafter("Salesperson Code"; "Location Code")
        modify("Location Code")
        {
            ApplicationArea = all;
            visible = true;
            caption = 'magasin de livraison';
            trigger OnbeforeValidate()
            var
                location: record Location;
                salesL: record "Sales Line";
            begin

                if rec."Vente comptoir" then begin
                    location.get(rec."Location Code");
                    if location.type <> location.Type::"Point de vente" then
                        error('Pour une vente comptoir veuillez choisir un magasin de type "point de vente"');
                    SalesL.setrange("Document Type", Rec."Document Type");
                    salesL.setrange("Document No.", rec."No.");
                    if salesL.FindFirst() then
                        repeat
                            SalesL.Validate("Location Code", rec."Location Code");
                        until SalesL.next() = 0;
                end;

            end;
        }
        addlast("Shipping and Billing")
        {
            field("Mode de livraison"; Rec."Mode de livraison")
            {
                ApplicationArea = all;
                Visible = true;
            }
            field("Documents vérifiés"; Rec."Documents vérifiés")
            {
                ApplicationArea = all;
                enabled = venteSuspension;
            }
        }



        modify("Campaign No.") { visible = false; }
        modify("Responsibility Center") { visible = false; }
        modify("Assigned User ID") { visible = false; }
        modify("Shortcut Dimension 1 Code") { visible = false; }
        modify("Shortcut Dimension 2 Code") { visible = false; }
        modify("Prices Including VAT")
        {
            visible = false;
        }


    }
    actions
    {
        modify(MakeOrder)
        {

            Enabled = rec."Type de facturation" <> rec."Type de facturation"::"Contre remboursement";

        }
        addbefore("O&rder")
        {
            action("Générer une facture") //IS 110925
            {
                Image = Invoice;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                // visible = false;
                Enabled = (Rec."Type de facturation" = Rec."Type de facturation"::"Contre remboursement");

                trigger OnAction()
                var
                    InvoiceHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    Cu: codeunit SalesEvents;
                begin

                    Cu.CheckConditions(Rec);
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");

                    if SalesLine.FindFirst() then
                        repeat
                            SalesLine.TestField("Location Code");
                        until SalesLine.Next() = 0;

                    InvoiceHeader := Rec.TransferToSalesInvoice();
                    PAGE.Run(PAGE::"Sales Invoice", InvoiceHeader);
                end;
            }

            action("Facturer les expéditions")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = Invoice;
                ApplicationArea = all;
                Caption = 'Facturer les expéditions';
                Enabled = (rec."Type de facturation" = rec."Type de facturation"::"Commande Totale");
                trigger OnAction()
                var
                    salesline: Record "Sales Line";
                    ff: report 295;
                    salesH: record "Sales Header";
                    BlanketOrderLine: record "Sales Line";
                    SalesInvL: Record "Sales Line";
                    param: text;
                    salesevent: codeunit 50052;

                begin
                    /* BlanketOrderLine.SetRange("Document No.", rec."No.");
                    BlanketOrderLine.SetRange("Completely Shipped", false); */
                    rec.CalcFields("Completely Shipped");
                    if not rec."Completely Shipped" then Error('la commande n''est pas totalement livrée');
                    /*   if BlanketOrderLine.FindFirst() then
                          Error('la commande n''est pas totalement livrée'); */


                    if rec."Type de facturation" <> rec."Type de facturation"::"Commande Totale" then
                        error('le type de facturation n''est pas commande totale');


                    SalesInvL.setrange("Document Type", "Sales Document Type"::invoice);
                    SalesInvL.setrange("Blanket Order No.", rec."No.");

                    SalesInvL.setrange(Type, "Sales Line Type"::Item);
                    if SalesInvL.findfirst() then
                        Error('Facture existe !!');
                    //salesH.setrange("Blanket Order No.", rec."No.");
                    salesH.SetRange("Document Type", salesH."Document Type"::Order);
                    salesH.Setrange("Blanket Order No.", Rec."No.");
                    ff.InitializeRequest(today, today, today, false, true, false, false);

                    if salesH.Count = 0 then
                        Error('Pas records de %1', salesH.GetFilters);
                    Message('%1   %2', salesH.count, salesH.GetFilters());
                    // salesevent.InsertStampLine(salesH);//by AM
                    ff.SetTableView(salesH);

                    param := format(rec."No.");
                    //ff.Execute(format(rec."No.") + format(CurrentDateTime));

                    ff.Execute(param);
                    Clear(param);
                    // ff.Execute(' ');
                    //report.RunModal(50025, false, false, salesH);
                end;
            }
            action(Fusion)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = Order;
                ApplicationArea = all;
                Caption = 'Fusionner commandes';
                trigger OnAction()
                var
                    verif: Codeunit VerificationStock;
                    salesheader: Record "Sales Header";
                begin
                    // if salesheader.get(rec."No.") then
                    verif.FusionCommande(rec."No.");
                    // Message('Les commandes de vente ont été fusionnées avec succès.');



                end;
            }


        }
    }

    /* trigger OnAfterGetCurrRecord()

    var
        MyinStream: instream;
        MyoutStream: outstream;
    begin

        rec.CalcFields("Work Description");
        rec."Work Description".CreateInStream(MyinStream);
        rec."Work Description".CreateoutStream(MyoutStream);

        MyinStream.Read(Work_description);
        MyoutStream.Writetext(Work_description);
        rec.modify();

    end;

 */

    /*  trigger OnAfterGetRecord()
     begin

         //CurrPage.SalesLines.Page.InsertAllowing(not rec.TotallyInvoiced());
         // CurrPage.SalesLines.Page.Editable(false);
         //  booleenabled := not rec.TotallyInvoiced();
         PartiallyShipped := rec.PartiallyShipped();
     end; */

    trigger OnAfterGetRecord()
    var
        CustomerPostingGroup: record "Customer Posting Group";

    begin
        PartiallyShipped := rec.PartiallyShipped();
        venteSuspension := false;
        if CustomerPostingGroup.get(rec."Customer Posting Group") then
            venteSuspension := CustomerPostingGroup.Suspension;



    end;

    Var
        venteSuspension: Boolean;

    var
        Work_description: text;
        customer: Record Customer;
        booleenabled: Boolean;
        PartiallyShipped: Boolean;




}
