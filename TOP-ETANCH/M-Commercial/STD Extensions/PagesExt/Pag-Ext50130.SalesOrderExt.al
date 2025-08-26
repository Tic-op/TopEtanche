namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.sales.Document;
using Microsoft.Inventory.Item.Attribute;
using Pharmatec.Pharmatec;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;
using TOPETANCH.TOPETANCH;
using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;

pageextension 50130 ExtSalesOrder extends "Sales Order"
{

    layout
    {
        addafter("Posting Date")
        {
            field("Prise en charge"; Rec."Prise en charge")
            {
                ApplicationArea = all;

            }
            /* field("Vente comptoir"; Rec."Vente comptoir")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin

                    CurrPage.update();
                end;
            } */

        }


        modify("Sell-to Customer No.")
        {

            Importance = Promoted;
            trigger OnAfterValidate()
            var
                customer: Record Customer;
            begin
                rec."Prise en charge" := true;
                rec.Modify();
                if rec."Sell-to Customer No." <> '' then begin
                    customer.Get(rec."Sell-to Customer No.");
                    if customer."Cause du blocage" <> customer."Cause du blocage"::"Non bloqué" then
                        Error('Ce client est bloqué pour la raison suivante \%1 !', customer."Cause du blocage");
                end;






            end;

        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Promised Delivery Date")
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Importance = Promoted;
        }
        modify(WorkDescription)
        {
            Importance = Promoted;
        }

        modify(Status)
        {
            Importance = Additional;
        }
        modify("Due Date")
        {
            Importance = Additional;
        }
        modify("Requested Delivery Date")
        {
            Importance = Additional;
            Visible = false;

        }
        modify("Sell-to Contact No.")
        {
            Importance = Additional;
        }
        modify("VAT Reporting Date")
        {
            Importance = Additional;
            Visible = false;
        }
        modify("Sell-to Contact")
        {
            Importance = Additional;
        }


        modify("Invoice Details")
        {
            Visible = false;
        }

        modify("Shipping and Billing")
        {
            Visible = false;
        }

        modify(Control1900201301) // ACOMPTE GROUP
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = true;

            ApplicationArea = all;
            trigger OnAfterValidate()
            var
                location: record Location;
            begin

                /* if rec."Vente comptoir" then begin
                    location.get(rec."Location Code");
                    if location.type <> location.Type::"Point de vente" then
                        error('Pour une vente comptoir veuillez choisir un magasin de type "point de vente"');

                end;
*/
            end;

        }



        moveafter("Salesperson Code"; "Location Code")




        addafter("Shipping and Billing")
        {
            group(Autre)
            {

                field("Payment Terms Code "; Rec."Payment Terms Code") { ApplicationArea = all; }
                field("Payment Method Code "; Rec."Payment Method Code") { ApplicationArea = all; }
                field("Type de facturation"; rec."Type de facturation")
                {
                    Visible = false;
                    Caption = 'Type de facturation';
                    ApplicationArea = all;
                    Importance = Promoted;
                    Enabled = false;
                }
                field("Mode de livraison"; Rec."Mode de livraison")
                {
                    // Visible = false;
                    //  Caption = 'Type de facturation';
                    ApplicationArea = all;
                    Importance = Promoted;
                    // Enabled = false;

                }
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


            }
        }

    }
    actions
    {

        addfirst(processing)
        {
            action("Approbation")
            {
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Caption = 'Approuver Vente';
                trigger OnAction()
                var
                    ContactApprobation: record ContactApprobation;
                    ContactApprobationPage: page ContactApprobation;
                begin
                    ContactApprobation.SetRange("Order No.", rec."No.");
                    ContactApprobationPage.SetTableView(ContactApprobation);
                    ContactApprobationPage.GetShipped(rec."Completely Shipped");
                    ContactApprobationPage.Run();


                end;




            }

            action("affecter Lot")
            {

                Image = Lot;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Caption = '1-Affecter Lot';
                trigger OnAction()
                var
                    LotMgt: Codeunit "Lot Management";
                    SaleL: Record "Sales Line";
                    item: Record Item;
                    tracking: record "Item Tracking Code";


                    SalesEvents: Codeunit SalesEvents;
                    attr: record "Item Attribute";
                    atr: record "Item Attribute Value Mapping";
                    atttr: record "Item Attribute Value Selection";
                    attrr: record "Item Attribute Value";
                    df: page "Item Card";

                begin

                    SalesEvents.AssignLotNoToSalesOrder(rec."Document Type", rec."No.");

                    //Test sur prise en charge
                    SaleL.setrange("Document No.", rec."No.");
                    SaleL.setrange(Type, "Sales Line Type"::Item);
                    if SaleL.findfirst then
                        repeat
                            item.get(SaleL."No.");
                            if tracking.get(item."Item Tracking Code") then begin
                                if tracking."Lot Specific Tracking" and tracking."Lot Warehouse Tracking" then
                                    if SaleL."Bin Code" <> '' then
                                        LotMgt.AffecterNoLot(SaleL);
                            end
                        until SaleL.next = 0;



                    /* 
                                        SaleL.setrange("Document No.", rec."No.");
                                        SaleL.setrange(Type, "Sales Line Type"::Item);
                                        if SaleL.findfirst then
                                            repeat
                                                if SaleL."Bin Code" <> '' then
                                                    LotMgt.AffecterNoLot(SaleL)
                                                else
                                                    SalesEvents.AssignLotNoToSalesOrderLine(SaleL)
                                              until SaleL.Next() = 0;
                     */








                end;
            }
            action("Bon de préparation")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;

                Caption = 'Génerer bon de Préparation';

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    OrdrePrep: Record "Ordre de preparation";
                    CuSeries: Codeunit "No. Series";
                    SalesSetup: Record "Sales & Receivables Setup";
                    OrdrePrepPage: Page "Liste bon de préparation";
                    LocationCode: Code[20];
                    verif: Codeunit VerificationStock;
                    location: Record Location;
                begin


                    OrdrePrep.SetRange("Order No", Rec."No.");
                    if OrdrePrep.FindFirst() then
                        Error('Un bon de préparation existe déjà pour cette commande');



                    OrdrePrep.SetRange("Order No", Rec."No.");
                    OrdrePrep.SetFilter(Statut, '<>%1', OrdrePrep.Statut::"Créé");
                    if OrdrePrep.FindFirst() then
                        Error('La commande %1 est en cours de préparation.', OrdrePrep."Order No");

                    SalesLine.SetCurrentKey("Document Type", "Document No.");
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."No.");
                    if SalesLine.FindFirst() then
                        repeat
                            if SalesLine."Location Code" = '' then
                                Error('Il faut avoir un magasin dans les lignes de commande', SalesLine."No.")

                        until SalesLine.Next() = 0;

                    SalesLine.Reset();
                    SalesLine.SetCurrentKey("Document Type", "Document No.");
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."No.");

                    if SalesLine.FindFirst() then
                        repeat
                            LocationCode := SalesLine."Location Code";
                            OrdrePrep.Reset();
                            OrdrePrep.SetRange("Order No", Rec."No.");
                            OrdrePrep.SetRange("Magasin", LocationCode);
                            if not OrdrePrep.FindFirst() then begin
                                OrdrePrep.Init();
                                OrdrePrep."Order No" := Rec."No.";
                                OrdrePrep."Magasin" := LocationCode;
                                OrdrePrep."Creation date" := CurrentDateTime;
                                OrdrePrep.Statut := OrdrePrep.Statut::"Créé";
                                OrdrePrep."document type" := OrdrePrep."document type"::Commande;
                                SalesSetup.Get();
                                OrdrePrep.Insert(true);
                            end;
                        until SalesLine.Next() = 0;
                    Message('Un bon de préparation a été créé avec succés');
                    /*   OrdrePrep.Reset();
                      OrdrePrep.SetRange("Order No", Rec."No.");
                      OrdrePrepPage.SetTableView(OrdrePrep);
                      OrdrePrepPage.Run(); */
                end;

            }

        }

    }



}