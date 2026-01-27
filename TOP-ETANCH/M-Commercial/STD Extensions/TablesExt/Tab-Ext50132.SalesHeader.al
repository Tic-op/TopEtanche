namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Setup;
using System.Security.User;
using Microsoft.CRM.Team;

using Microsoft.Inventory.Location;
using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.History;

tableextension 50132 SalesHeader extends "Sales Header"
{
    fields
    {
        field(50000; "Stamp Amount"; Decimal)
        {
            Caption = 'Montant Timbre';
            DataClassification = ToBeClassified;
        }
        /*  field(50005; "Nombre de Cartons"; integer)
         {
             Caption = 'Nombre de Carton';
             DataClassification = ToBeClassified;
         }
         field(50006; "Prise en charge"; Boolean)
         {

             Caption = 'Prise en charge';
             DataClassification = ToBeClassified;

         } */

        field(50108; "Type de facturation"; Option)
        {
            OptionMembers = "","Contre remboursement","Fact. Mensuelle","Fact. Plafond","Commande Totale";

            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                BlanketSalesLine: Record "Sales header";
            begin


                if "Document Type" <> "Document Type"::"Blanket Order" then
                    exit;
                /* 
                                BlanketSalesLine.Reset();
                                BlanketSalesLine.SetRange("Blanket Order No.", "No.");
                                BlanketSalesLine.SetRange("Document Type", BlanketSalesLine."Document Type"::Order);

                                if BlanketSalesLine.Findfirst() then begin

                                    repeat
                                        if SalesHeader.Get(SalesHeader."Document Type"::Order, BlanketSalesLine."Document No.") then begin
                                            if SalesHeader."Type de facturation" <> "Type de facturation" then begin
                                                SalesHeader."Type de facturation" := "Type de facturation";
                                                SalesHeader.Modify(true);
                                            end;
                                        end;
                                    until BlanketSalesLine.Next() = 0;
                                end;  */
                SalesHeader.setrange("Blanket Order No.", "No.");
                if SalesHeader.findfirst then
                    repeat
                        SalesHeader."Type de facturation" := "Type de facturation";
                        SalesHeader.modify();
                    until SalesHeader.next = 0;
            end;
        }
        field(50109; "Blanket Order No."; Code[20])
        {

            Caption = 'No commande cadre';
        }
        field(50110; "Vente comptoir"; Boolean)
        {
            InitValue = false;
            trigger OnValidate()
            var
                location: Record Location;
                SalesL: Record "Sales Line";
            begin
                if "Vente comptoir" then begin
                    "Mode de livraison" := "Mode de livraison";


                    if "Document Type" = "Document Type"::"Blanket Order" then begin
                        if location.Get("Location Code") then begin
                            if location.Type <> location.Type::"Point de vente" then
                                Error('Pour une commande ouverte, veuillez choisir un magasin de type "Point de vente".');
                        end else
                            Error('Le magasin spécifié n''existe pas.');
                    end;


                    SalesL.SetRange("Document Type", "Document Type");
                    SalesL.SetRange("Document No.", "No.");
                    if SalesL.FindFirst() then
                        if Confirm('La mise à jour de ce champ va affecter les lignes commandes, veuillez confirmer', true) then
                            repeat
                                SalesL.Validate("Location Code", "Location Code");
                                SalesL.Validate("Qty. to Ship", SalesL.Quantity);
                                SalesL.Modify();
                            until SalesL.Next() = 0;
                end else begin

                    SalesL.SetRange("Document Type", "Document Type");
                    SalesL.SetRange("Document No.", "No.");
                    if SalesL.FindFirst() then
                        repeat
                            SalesL.CalcFields("Qty in Orders");
                            if SalesL."Qty in Orders" <> 0 then
                                Error('Des commandes ont été préparées depuis cette commande. Supprimez-les avant d''annuler l''option "Vente comptoir".');
                        until SalesL.Next() = 0;
                end;
            end;

        }
        field(50111; "Mode de livraison"; Option)
        {
            OptionMembers = "comptoir","Top Etanchéité","Transporteur Externe";
            trigger OnValidate()
            begin
                if "Vente comptoir" then TestField("Mode de livraison", "Mode de livraison"::comptoir);
            end;

        }
        field(50012; "Bon de preparations"; Integer)
        {

            Caption = 'Bon de preparations';
            FieldClass = FlowField;
            // CalcFormula = count("Ordre de preparation" where("Order No" = field("No."), Statut = filter("Créé" | "Regroupé" | "Préparé" | "En cours")));
            CalcFormula = count("Ordre de preparation" where("Order No" = field("No.")));
        }
        field(50013; "Bon de preparations préparés"; integer)
        {

            Caption = 'Bon de preparations';
            FieldClass = FlowField;
            // CalcFormula = count("Ordre de preparation" where("Order No" = field("No."), Statut = filter("Créé" | "Regroupé" | "Préparé" | "En cours")));
            CalcFormula = count("Ordre de preparation" where("Order No" = field("No."), Statut = const("Préparé")));
        }
        field(60100; "Documents vérifiés"; Boolean)
        {
            Caption = 'Documents client Vérifiés';
        }

        modify("document Date")
        {
            trigger OnAfterValidate()
            begin
                if "document type" = "document type"::Quote then
                    ApplyVatSuspension("document Date");
            end;

        }

        modify("Order Date")
        {
            trigger OnAfterValidate()
            begin
                if "document type" = "document type"::Quote then
                    ApplyVatSuspension("Order Date");
            end;

        }
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                ApplyVatSuspension("Posting Date");
            end;
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()

            var
                CustomerRec: Record Customer;
                GLSetup: Record "General Ledger Setup";
            begin

                "Stamp Amount" := 0;
                GLSetup.get;

                ApplyVatSuspension(Today);


                if "Sell-to Customer No." <> '' then begin
                    if CustomerRec.Get("Sell-to Customer No.") and CustomerRec.Stamp then begin
                        "Stamp Amount" := GLSetup."Montant timbre fiscal";
                        // BY AM 090125
                        If ("Document Type" = "Sales Document Type"::Order) OR ("Document Type" = "Sales Document Type"::Invoice) then
                            if (CustomerRec."Cause du blocage" <> CustomerRec."Cause du blocage"::"Non bloqué") then
                                error('Client bloqué à cause du %1', CustomerRec."Cause du blocage");
                        // END AM 090125
                        //if ("Document Type" = "Document Type"::"Blanket Order") or ("Document Type" = "Document Type"::Invoice) then
                        "Type de facturation" := CustomerRec."Type de facturation";// IS
                    end;


                end;

            end;

        }
        modify("Salesperson Code")
        {
            trigger OnafterValidate()
            var
                UserSetup: record 91;
                salesperson: Record "Salesperson/Purchaser";
            begin
                if UserSetup.get(UserId) then begin

                    if UserSetup."Salespers./Purch. Code" <> '' then
                        SetSalespersonCode('', "Salesperson Code")
                end;

                if Rec."Salesperson Code" <> '' then begin
                    salesperson.get(Rec."Salesperson Code");
                    if rec."Location Code" = '' then begin
                        rec."Location Code" := salesperson.Magasin;
                    end;
                end;
            end;






        }
        /*   modify("Location Code")
           {

               trigger OnBeforeValidate()
               var
                   location: record Location;
               begin
                   if "Vente comptoir" then begin
                       /*  location.get("Location Code");
                        if location.Type <> location.type::"Point de vente" then
                            error('le magasin choisi n''est pas un point de vente'); */
        // end


        //  end;
        // }
        modify("Location Code")
        {
            trigger OnBeforeValidate()
            var
                location: Record Location;
            begin

                //  if "Vente comptoir" then begin

                //    if "Document Type" = "Document Type"::Order then
                //      exit;


                if location.Get("Location Code") then begin
                    if (location.Type <> location.Type::"Point de vente")// and (Location.Type <> Location.type::Tampon)
                     then
                        Error('Le magasin choisi n''est pas un point de vente.');
                    //    end else
                    //      Error('Le magasin spécifié est introuvable.');
                end;
            end;
        }




    }
    /* 
        trigger OnDelete()
        begin
            if ("Posting No." <> '') or ("Document Type" = "Document Type"::Invoice) then
                Error('Vous ne pouvez pas supprimer un document qui a déjà été facturé : %1', "Posting No.");
        end; */

    trigger OnBeforeDelete()


    begin
        if ("Posting No." <> '') then
            Error('Ce document comporte un numéro de facture réservé %1', "Posting No.");
        ;
        if ("Shipping No." <> '') then
            Error('Ce document comporte un numéro de BL réservé %1', "Shipping No.");
        ;
    end;

    trigger OnAfterDelete()
    var
        salesL: Record "Sales Line";
        ContactApprobation: record ContactApprobation;
    begin
        SalesL.setrange("Document Type", "Document Type");
        salesL.setrange("Document No.", "No.");
        salesL.DeleteAll(true);
        if "Document Type" = "Sales Document Type"::Order then begin
            ContactApprobation.setrange("Order No.", "No.");
            ContactApprobation.DeleteAll(true);
        end


    end;

    procedure TotallyInvoiced(): Boolean // 170425
    var
        SalesL: record "Sales Line";
    begin
        // if "Document Type" = "Sales Document Type"::"Blanket Order" then begin

        SalesL.setrange("Document Type", "Sales Document Type"::"Blanket Order");
        SalesL.setrange("Document No.", "No.");
        SalesL.Setfilter(Quantity, '<> %1', 0);
        If SalesL.Count = 0 then
            exit(false)
        else

            if SalesL.FindFirst() then begin
                repeat
                    if SalesL."Quantity (Base)" <> SalesL."Qty. Invoiced (Base)" then begin

                        exit(false);
                    end
                until SalesL.next = 0;


                exit(true);
            end;
        //end


    end;

    procedure NotTotallyInvoiced(): Boolean
    begin
        exit(not TotallyInvoiced());
    end;

    procedure PartiallyShipped(): Boolean
    var
        SaleL: record "Sales Line";
    begin


        SaleL.setrange("Document Type", "Document Type");
        SaleL.setrange("Document No.", "No.");
        if salel.FindFirst() then
            repeat
                if (SaleL."Qty. Shipped (Base)" <> 0) //or (SaleL."Outstanding Quantity" <> SaleL.Quantity) 
                then
                    exit(true);
            until SaleL.next() = 0;
        exit(false);
    end;

    procedure TransferToSalesInvoice(): Record "Sales Header" // IS 11092025
    var
        NewInvoiceHeader: Record "Sales Header";
        NewInvoiceLine: Record "Sales Line";
        SL: Record "Sales Line";
        LineNo: Integer;
        seriesMgt: Codeunit "No. Series";
        SalesSetup: record "Sales & Receivables Setup";
        Salesevent: codeunit SalesEvents;
    begin

        SalesSetup.get();
        NewInvoiceHeader.Init();
        NewInvoiceHeader."Document Type" := NewInvoiceHeader."Document Type"::Invoice;
        NewInvoiceHeader.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
        NewInvoiceHeader.Validate("Bill-to Customer No.", Rec."Bill-to Customer No.");
        NewInvoiceHeader.Validate("Currency Code", Rec."Currency Code");
        NewInvoiceHeader.Validate("Payment Terms Code", Rec."Payment Terms Code");
        NewInvoiceHeader.Validate("Posting Date", Today);
        NewInvoiceHeader.Validate("Document Date", Today);
        // NewInvoiceHeader."Posting No." := seriesMgt.GetNextNo(SalesSetup."Posted Invoice Nos.");
        If SalesSetup."Utiliser Pré-Facture" then //AM 091025
            Salesevent.affecterSoucheInvoice(NewInvoiceHeader);
        NewInvoiceHeader.Insert(true);

        SL.SetRange("Document Type", Rec."Document Type");
        SL.SetRange("Document No.", Rec."No.");

        /* if SL.FindFirst() then begin
            LineNo := 10000;
            repeat
                NewInvoiceLine.Init();
                NewInvoiceLine."Document Type" := NewInvoiceHeader."Document Type";
                NewInvoiceLine."Document No." := NewInvoiceHeader."No.";
                NewInvoiceLine."Line No." := LineNo;
                NewInvoiceLine.Validate("Type", SL."Type");
                NewInvoiceLine.Validate("No.", SL."No.");
                NewInvoiceLine.Validate("Quantity", SL."Quantity");//AM 290925 changed from  SL."Qty. to Ship"
                NewInvoiceLine.Validate("Location Code", SL."Location Code");
                // NewInvoiceLine.validate("Bin Code", SL."Bin Code"); Promleme testfield sur location 
                NewInvoiceLine."Bin Code" := Sl."Bin Code"; //AM 290925
                NewInvoiceLine.Validate("Unit of Measure Code", SL."Unit of Measure Code");
                NewInvoiceLine.Validate("Unit Price", SL."Unit Price");
                NewInvoiceLine.Insert(true);
                LineNo += 10000;
            until SL.Next() = 0; */
        if SL.FindFirst() then begin  // New version AM 091025
            LineNo := 10000;
            repeat
                NewInvoiceLine.Init();
                NewInvoiceLine := SL;
                NewInvoiceLine."Document Type" := NewInvoiceHeader."Document Type";
                NewInvoiceLine."Document No." := NewInvoiceHeader."No.";
                NewInvoiceLine."Line No." := SL."Line No.";
                NewInvoiceLine.Validate("Quantity", SL."Quantity");
                NewInvoiceLine.Insert(true);
            until SL.Next() = 0;




        end;

        exit(NewInvoiceHeader);
    end;

    trigger OnDelete()

    begin
        if ("Document Type" = "Document Type"::invoice) and ("Posting No." <> '') then
            Error('Vous ne pouvez pas supprimer ce document');
    end;


    local procedure ApplyVatSuspension(Date0: Date)
    var
        VatSusp: Record "Customer VAT Suspension";
        Cust: Record Customer;
    begin
        if ("Sell-to Customer No." = '') then
            exit;

        Cust.get("Sell-to Customer No.");
        // Recherche suspension active
        VatSusp.Reset();
        VatSusp.SetRange("Customer No.", "Sell-to Customer No.");

        VatSusp.SetFilter("Start Date", '<=%1', Date0);
        VatSusp.SetFilter("End Date", '>=%1', Date0);

        if VatSusp.FindFirst() then begin

            VatSusp.TestField("VAT Bus. Posting Group");
            VatSusp.TestField("Bus. Posting Group");
            Message('Attention !! Client en %1', "VAT Bus. Posting Group");
            Validate("VAT Bus. Posting Group", VatSusp."VAT Bus. Posting Group");
            validate("Gen. Bus. Posting Group", VatSusp."Bus. Posting Group");
            "Your reference" := VatSusp.Description;
        end
        ELSE begin
            Validate("VAT Bus. Posting Group", Cust."VAT Bus. Posting Group");
            validate("Gen. Bus. Posting Group", Cust."Gen. Bus. Posting Group");
            "Your reference" := '';

        end;

    end;

    Procedure GetBlanketSalesOrder(): Code[20]
    var
        SH: record "Sales Header";
    begin

        If Sh.get("Sales Document Type"::"Blanket Order", "No.") then
            exit(SH."No.")
        else
            exit('');

    end;

    Procedure ShowBlanketOrder()
    var
        SH: record "Sales Header";
        Pagef: page "Blanket Sales Order";

    begin

        SH.setrange("Document Type", "Sales Document Type"::"Blanket Order");
        Sh.setrange("No.", "No.");
        if Sh.findset then
            Page.runmodal(507, SH);


    end;

    Procedure NeedPreparation(): Boolean
    var
        SL: record "Sales Line";
    begin
        SL.setrange("Document Type", "Document Type");
        SL.setrange("Document No.", "No.");
        SL.SetFilter("Location Code", '<>%1', "Location Code");
        if SL.findset() then
            exit(true)
        else
            exit(false)


    end;

    procedure ModifiedGenCustomerGroup(): Boolean
    var
        cust: Record customer;
    begin
        //Test visuel si le client a changé de groupe, utilisé dans le cas de SUSPENSION
        if cust.get("Sell-to Customer No.") then begin
            if rec."Gen. Bus. Posting Group" <> cust."Gen. Bus. Posting Group" then
                exit(true);
        end;
    end;



    var
        IsCompletelyInvoiced: Boolean;

}