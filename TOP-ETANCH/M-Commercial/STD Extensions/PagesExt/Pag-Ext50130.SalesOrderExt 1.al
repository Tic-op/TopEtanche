namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.sales.Document;
using Microsoft.Inventory.Item.Attribute;

using Microsoft.Sales.Customer;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Top.Top;
using Microsoft.Inventory.Item;
using TOPETANCH.TOPETANCH;
using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;

pageextension 50130 ExtSalesOrder extends "Sales Order"
{
    // InsertAllowed = false;
    layout
    {

        modify("Sell-to Customer Name")
        {
            StyleExpr = StyleSusp;
        }
        addafter("Sell-to Customer Name")
        {

            field("Sell-to Customer Name2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("Due Date")
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
            field("Commande cadre associée"; rec.GetBlanketSalesOrder)
            {
                editable = false;
                ApplicationArea = all;
                Trigger OnDrillDown()
                begin
                    rec.ShowBlanketOrder();
                end;
            }
        }


        modify("Sell-to Customer No.")
        {

            Importance = Promoted;
            trigger OnAfterValidate()
            var
                customer: Record Customer;
                RS: Page "Usual Search";
                SalesHeader: Record "Sales Header";

            begin
                /*  rec."Prise en charge" := true;
                 rec.Modify(); */
                if rec."Sell-to Customer No." <> '' then begin
                    customer.Get(rec."Sell-to Customer No.");
                    if customer."Cause du blocage" <> customer."Cause du blocage"::"Non bloqué" then
                        Error('Ce client est bloqué pour la raison suivante \%1 !', customer."Cause du blocage");
                end;



                /* begin
                    if SalesHeader.Get(Rec."Document Type", Rec."No.") then begin
                        SalesHeader.TestField(Status, SalesHeader.Status::Open);
                        RS.initvar(SalesHeader."Document Type", SalesHeader."No.");
                        //RS.Run();
                        RS.RunModal();

                        // Page.RunModal(50029);
                        CurrPage.Update();

                    end

                end; */
            end;
        }
        /*  modify("Sell-to Customer Name")
         {
             trigger OnAfterValidate()
             var
                 RS: Page "Usual Search";
                 SalesHeader: Record "Sales Header";
             begin

                 if SalesHeader.Get(Rec."Document Type", Rec."No.") then begin
                     SalesHeader.TestField(Status, SalesHeader.Status::Open);
                     RS.initvar(SalesHeader."Document Type", SalesHeader."No.");
                     //RS.Run();
                     RS.RunModal();

                     // Page.RunModal(50029);
                     CurrPage.Update();

                 end
             end;
         } */



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
        moveafter("Sell-to Customer Name"; "Salesperson Code")

        modify("Salesperson Code")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        modify(WorkDescription)
        {
            //Importance = Promoted;
            visible = false;
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
            caption = 'magasin de livraison';
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
        modify("Currency Code") { visible = false; }



        moveafter("Salesperson Code"; "Location Code")
        modify("Foreign Trade") { Visible = false; }






        addafter("Shipping and Billing")
        {
            group(Autre)
            {

                field("Payment Terms Code "; Rec."Payment Terms Code") { ApplicationArea = all; }
                field("Payment Method Code "; Rec."Payment Method Code") { ApplicationArea = all; }
                field("Type de facturation"; rec."Type de facturation")
                {
                    Visible = rec."Blanket Order No." = '';
                    Caption = 'Type de facturation';
                    ApplicationArea = all;
                    Importance = Promoted;
                    Enabled = rec."Blanket Order No." = '';
                }
                field("Mode de livraison"; Rec."Mode de livraison")
                {
                    // Visible = false;
                    //  Caption = 'Type de facturation';
                    ApplicationArea = all;
                    Importance = Promoted;
                    // Enabled = false;

                }



            }
        }

    }


    actions
    {
        addbefore(Post)
        {
            action("Générer une facture") //IS 110925
            {
                Image = Invoice;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                visible = false;
                Enabled = (Rec."Type de facturation" = Rec."Type de facturation"::"Contre remboursement");

                trigger OnAction()
                var
                    InvoiceHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                begin
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
        }

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
                    SaleL.setrange("Document Type", rec."Document Type");
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

                Caption = 'Générer bon de préparation';

                trigger OnAction()
                var
                    /*  SalesLine: Record "Sales Line";
                     OrdrePrep: Record "Ordre de preparation";
                     CuSeries: Codeunit "No. Series";
                     SalesSetup: Record "Sales & Receivables Setup";
                     OrdrePrepPage: Page "Liste bon de préparation";
                     LocationCode: Code[20];
                     verif: Codeunit VerificationStock;
                     location: Record Location; */
                    PrépEvent: Codeunit "PréparationEvent";
                    OrdrePrep: record "Ordre de preparation";


                begin
                    "PrépEvent"."GénérerOrdredePréparation"(OrdrePrep."document type"::Commande, rec."No.");
                end;

            }
            action(VérifiPrep)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = PrintVoucher;
                visible = false;
                Caption = 'Imprimer feuille préparation';
                trigger OnAction()
                var
                    Ligneprep: record "Ligne préparation";
                begin
                    Ligneprep.setrange("Source type.", Ligneprep."Source type."::Facture);
                    Ligneprep.setrange("Source No.", Rec."No.");
                    if Ligneprep.FindSet() then
                        Report.RunModal(50015, true, true, Ligneprep);
                end;
            }

        }
        addafter(MoveNegativeLines)
        {
            action(ExtractAvailableBlanketOrderLines)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Image = CollapseAll;
                visible = true;
                enabled = not (rec."Type de facturation" = rec."Type de facturation"::"Commande Totale");
                Caption = 'Extraire lignes commande cadre disponible';
                trigger OnAction()
                var
                    BODialog: Page "Dialog BO Extraction";
                    ExtractLinkedOrderOnly: Boolean;
                    InsertInSameOrder: Boolean;
                    BOExtractionHandler: Codeunit "BO Extraction Handler";
                    Cust: record Customer;
                begin
                    Cust.get(rec."Sell-to Customer No.");
                    if Cust."Type de facturation" = Cust."Type de facturation"::"Commande Totale" then error('Action interdite,Type facturation client doit être différent de "Commande totale"');
                    // 1️⃣ Open the BO Extraction dialog
                    if BODialog.RunModal() <> Action::OK then
                        exit;

                    // 2️⃣ Retrieve user choices
                    BODialog.GetExtractionSelection(ExtractLinkedOrderOnly);
                    BODialog.GetInsertionSelection(InsertInSameOrder);

                    // 3️⃣ Call the codeunit to handle extraction & insertion
                    BOExtractionHandler.ExtractFromBlanketOrdersWithMessage(
                        Rec."Sell-to Customer No.",  // Customer No.
                        Rec."No.",                   // Current sales order No.
                        ExtractLinkedOrderOnly,      // true = only linked blanket order lines
                        InsertInSameOrder);          // true = insert in current order, false = create new order
                end;



            }
        }

    }


    trigger OnAfterGetCurrRecord()
    begin
        if rec.ModifiedGenCustomerGroup() then
            StyleSusp := 'Unfavorable'
        else
            StyleSusp := 'Normal';
    end;

    var
        StyleSusp: Text;
}
