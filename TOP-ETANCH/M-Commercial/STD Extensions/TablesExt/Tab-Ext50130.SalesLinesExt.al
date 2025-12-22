namespace Ticop_pharmatec.Ticop_pharmatec;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.CRM.Team;
using Microsoft.Foundation.Company;
using Microsoft.CRM.Opportunity;
using Microsoft.Warehouse.ADCS;
using Microsoft.Inventory.Item;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using PHARMATECCLOUD.PHARMATECCLOUD;
using Microsoft.Inventory.Ledger;


tableextension 50130 SalesLinesExt extends "Sales Line"
{



    fields
    {
        /*  modify(Quantity)
         {
             trigger OnAfterValidate()
             var
                 salesordersub: page "Sales Order Subform";

             begin
                 if "Document Type" = "Document Type"::Quote Then
                     "Qté initial opp. " := Quantity;
                 CheckQuantiy("Quantity (Base)");
                 if "Document Type" = "Document Type"::"Blanket Order" then
                     salesordersub.ControlDisponibilité();

             end;
         } */

        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            var

                reservationEntry: Record "Reservation Entry";
            begin
                CheckQuantiy("Qty. to Ship (Base)");
                if "Document Type" = "Sales Document Type"::Order then
                    if LigneVentecomptoir() then TestField("Qty. to Ship", Quantity);
                if "Document Type" = "Document Type"::Order Then begin
                    reservationEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");
                    reservationEntry.SetRange("Source ID", "Document No.");
                    reservationEntry.setrange("Source Ref. No.", "Line No.");

                    if reservationEntry.FindFirst() then
                        repeat
                            reservationEntry.Delete(true);

                        until reservationEntry.Next() = 0;


                end;

            end;
        }





        field(50001; "Statut lig. devis"; Option)
        {
            Caption = 'Statut lig. devis';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Encours","Gagné","Perdu";
            Editable = false;

        }
        field(50002; "Qté initial opp. "; Decimal)
        {
            Caption = 'Qté initial opp.';
            DataClassification = ToBeClassified;
            Editable = false;
            DecimalPlaces = 0;
        }
        field(50000; "SalesPerson"; Code[25])
        {
            Caption = 'Commercial';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(50003; "Opportunity No"; code[20])
        {
            Caption = 'Numéro Opportunité';
            DataClassification = ToBeClassified;
            TableRelation = "Opportunity";

        }
        field(50004; "Total TTC (Total expédiée)"; Decimal)
        {
            Caption = 'Total TTC (Total expédiée)';
            DataClassification = ToBeClassified;
            Editable = false;

        }
        /* field(50004; "Qty"; Decimal)
        {
            Caption = 'Qté sur commande vente';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Qty. on Sales Order" where("No." = field("No.")));

        } */


        /*  field(50004; "Amount Inc VAT"; Decimal)
         {
             FieldClass = FlowField;
             CalcFormula = 

         }
       */
        /*    field(50006; Print; Boolean) //AM useless
           {
               Caption = 'Imprimé';
           }
           field(50007; "Impression No"; Integer) { } //AM useless */

        field(50005; "Qty in Orders"; Decimal)
        {
            Caption = 'Qté Sur Commande (base)';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = FILTER(Order),
             "Blanket Order No." = field("Document No."), "Blanket Order Line No." = field("Line No.")));



        }



        field(50008; Preparé; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Ligne préparation" where("Source No." = field("Document No."), "Source line No." = field("Line No.")));

        } //AM Useless
        field(50009; "statut ligne préparation"; Option) //AM Useless
        {
            Caption = 'Statut';
            OptionMembers = "Créé","En cours","Préparé","Regroupé","livré";
            FieldClass = FlowField;
            CalcFormula = lookup("Ligne préparation".Statut where("Source No." = field("Document No."), "Source line No." = field("Line No.")));


        }
        field(50010; "Preparation Order No."; Code[20])
        {

            //DataClassification = ToBeClassified;
            // TableRelation = "Ordre de preparation".No WHERE("Order No" = FIELD("Document No."), Magasin = FIELD("Location Code"));
            FieldClass = FlowField;
            // CalcFormula = lookup("Ordre de preparation".No WHERE("Order No" = FIELD("Document No."), Magasin = FIELD("Location Code")));
            CalcFormula = lookup("Ligne préparation"."Document No." where("Source No." = field("Document No."), "Source line No." = field("Line No.")));

        }
        field(50011; "Identifier Code"; Code[100])
        {
            Caption = 'Barre Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Identifier TICOP".Code WHERE("Item No." = field("No.")));
            Editable = false;
        }
        field(50012; "Barre Code"; Code[20])
        {

            Editable = false;
            FieldClass = Normal;


        }
        field(50013; "Shipping No."; code[20])
        {
            Editable = false;
        }

        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                SalesH: Record "Sales Header";
                OrdrePrep: Record "Ordre de preparation";
            begin
                // OrdrePrep.SetRange("Order No", "Document No.");
                //OrdrePrep.SetRange(Statut, OrdrePrep.Statut::"Créé"); ??? Nosense 
                //if OrdrePrep.FindFirst() then
                //   Error('Impossible de modifier le magasin, veuillez supprimer le bon préparation existant');
                CalcFields("Preparé");
                if "Preparé" then
                    Error('Impossible de modifier le magasin, veuillez supprimer le bon préparation existant');
                CheckQuantiy("Quantity (Base)");
                CheckQuantiy("Qty. to Ship (Base)");
                SalesH.Get("Document Type", "Document No.");
                if Type = "Sales Line Type"::Item then
                    if SalesH."Vente comptoir" then
                        TestField("Location Code", SalesH."Location Code");
                /*  ControlDisponibilité(); */
                "ControlDisponibilitéSaleslines"();
            end;
        }

        modify("Quantity")
        {
            trigger OnAfterValidate()
            var
            begin
                "ControlDisponibilitéSaleslines"();
            end;
        }
        modify("Bin Code")
        {
            trigger OnAfterValidate()
            begin
                "ControlDisponibilitéSaleslines"();
            end;
        }



    }
    keys
    {
        key(keydate; "Planned Shipment Date") { }

    }



    /* trigger OnInsert()
    var
        CompInfo: record "Company Information";
        SH: record "Sales Header";

    begin
        CompInfo.get();
        "type" := "Sales Line Type"::"Item"; */
    // "Location Code" := CompInfo."Location Code";
    /* if "Document Type" = "Sales Document Type"::"Blanket Order" then
        CheckBlockageInsertion();
*/
    /*  SH.get("Document Type", "Document No.");
     if SH.TotallyInvoiced() then Error('Commande carde Totalement facturée');

*/
    //*end;

    trigger OnAfterInsert()
    var //location : record location; 
        SalesH: record "Sales Header";
        ORdreprep: Record "Ordre de preparation";
    begin
        SalesH.get("Document Type", "Document No.");
        if type = "Sales Line Type"::Item then
            if SalesH."Vente comptoir" then begin
                SalesH.TestField("Location Code");
                validate("Location Code", SalesH."Location Code");
                validate("Qty. to Ship", Quantity);
            end;
        "Shipping No." := SalesH."Shipping No.";

        /*  SalesH.CalcFields("Bon de preparations");
         if SalesH."Bon de preparations" > 0 then
             error('Impossible d''ajouter des lignes. Des préparations associées existent.');
  */
        ORdreprep.setrange("Order No", "Document No.");
        ORdreprep.SetRange(Statut, ORdreprep.Statut::"Créé", ORdreprep.Statut::"En cours");
        if ORdreprep.FindFirst() then
            error('veuillez préparer les préparations existantes avant d''ajouter des lignes');
    end;

    /* trigger OnBeforeInsert()
    var
        SH: record "Sales Header";
    begin
        // CheckBlockageInsertion();
        SH.get("Document Type", "Document No.");
        if SH.TotallyInvoiced() then Error('Commande carde Totalement facturée');
    end; */




    trigger OnModify()
    var
        OrdrePrep: Record "Ordre de preparation";

    begin
        /*  if "Document Type" = "Document Type"::Order then begin
             OrdrePrep.SetRange("Order No", "Document No.");
             if OrdrePrep.FindFirst() then begin
                 //if OrdrePrep.Statut = OrdrePrep.Statut::"Créé" then
                 Error('Impossible de modifier cette ligne, veuillez supprimer le bon de préparation associé.');
             end; */

        CalcFields("Preparé");
        if "Preparé" then
            Error('Impossible de modifier cette ligne, veuillez supprimer le bon de préparation associé.');

    end;

    trigger OnDelete()
    var
        OrdrePrep: Record "Ordre de preparation";
    begin
        /*   if (("Document Type" = "Document Type"::Order) or ("Document Type" = "Sales Document Type"::Invoice)) and (type = "Sales Line Type"::item) then begin
              OrdrePrep.SetRange("Order No", "Document No.");
              //OrdrePrep.SetFilter(Statut, '<>%1', OrdrePrep.Statut::"Créé");
              if OrdrePrep.FindFirst() then
                  Error('Impossible de supprimer cette ligne , veuillez supprimer le bon de préparation associé.');
          end; */
        CalcFields("Preparé");
        if "Preparé" then
            Error('Impossible de supprimer cette ligne, veuillez supprimer le bon de préparation associé.');
    end;










    procedure SalesLineDispatcherBin(locationCode: code[25]; QtyDemande: Integer): Integer
    var
        SalesL: Record "Sales Line";
        magasin: Record Location;
        BinC: Record "Bin Content";
        QtyRestante: Integer;
        item: Record Item;
        noligne: integer;
    begin
        item.Get(Rec."No.");
        //Check Availibility(item,'','') ...

        QtyRestante := QtyDemande;
        if magasin.get(locationCode) then begin
            //if magasin.FindFirst() then begin
            repeat
                item."Location Filter" := magasin.Code;
                item.CalcFields(Inventory, "Qty. to ship on order line");

                if (item.Inventory - item."Qty. to Ship on Order Line") > QtyDemande then begin
                    BinC.SetRange("Location Code", magasin.Code);
                    BinC.SetRange("Item No.", rec."No.");
                    BinC.SetAutoCalcFields(BinC.Quantity);
                    BinC.SetFilter(Quantity, '>0');

                    if BinC.FindFirst() then
                        repeat
                            item."Bin Filter" := BinC."Bin Code";
                            item.CalcFields("Qty. to Ship on Order Line");

                            SalesL.Init();
                            SalesL := rec;
                            //SalesL."Document No." := salesline."Document No.";
                            //SalesL."Document Type" := salesline."Document Type";
                            noligne := GetLastLineNo() + 10000;

                            SalesL.Validate("Line No.", noligne);
                            if QtyRestante <= binc.Quantity then begin
                                SalesL.Validate(Quantity, QtyRestante);
                                QtyRestante := 0

                            end
                            else begin
                                SalesL.Validate(Quantity, binc.Quantity);
                                QtyRestante := QtyRestante - binc.Quantity

                            end;
                            //   SalesL.Validate(Quantity, salesline."Qty. to Ship" - QtyRestante);
                            SalesL.Validate("Location Code", magasin.Code);
                            SalesL."Bin Code" := BinC."Bin Code";
                            SalesL.Insert();
                        until (BinC.Next() = 0) or (QtyRestante = 0);

                    exit(QtyRestante);


                    /* else begin

                        item."Location Filter" := magasin.Code;
                        item.CalcFields(Inventory, "Qty. to Ship on Order Line");
                        if (item.Inventory - item."Qty. to Ship on Order Line") > salesline."Qty. to Ship" then begin
                            SalesL.Init();
                            SalesL := salesline;
                            noligne := GetLastLineNo() + 10000;
                            SalesL.Validate("Line No.", noligne);
                            if QtyRestante < item.Inventory then begin
                                SalesL.Validate(Quantity, QtyRestante);
                                QtyRestante := 0;
                            end

                            else begin
                                SalesL.Validate(Quantity, item.Inventory);
                                QtyRestante := QtyRestante - item.Inventory;
                            end;
                            SalesL.Validate("Location Code", magasin.Code);
                        end;
                    end;
 */
                end;

            until magasin.Next() = 0;
        end else
            Error('Aucun emplacement trouvé avec ce filtre.');
    end;

    /* local procedure SalesLineDispatcherLocation(locationCode: Code[25]; QtyDemande: Integer): Integer
    var
        SalesL: Record "Sales Line";
        magasin: Record Location;
        item: Record Item;
        QtyRestante: Integer;
        noligne: Integer;
    begin


        item.SetRange("Location Filter", locationCode);
        item.CalcFields(Inventory);

        if item.Inventory = 0 then
            exit(QtyDemande); 

        QtyRestante := QtyDemande;

            SalesL.Init();
            SalesL := Rec; 
            noligne := GetLastLineNo() + 10000;

            SalesL.Validate("Line No.", noligne);

            if QtyRestante <= item.Inventory then begin
                SalesL.Validate(Quantity, QtyRestante);
                QtyRestante := 0;
            end else begin
                SalesL.Validate(Quantity, item.Inventory);
                QtyRestante := QtyRestante - item.Inventory;
            end;

            SalesL.Validate("Location Code", locationCode);
            SalesL."Bin Code" := ''; 
            SalesL.Insert(true);

        exit(QtyRestante);
    end;
     */

    procedure GetLastLineNo(): integer
    var
        salesL: record "Sales Line";


    begin
        SalesL.setrange("Document Type", "Document Type");
        SalesL.setrange("Document No.", "Document No.");
        if SalesL.FindLast() then
            exit(salesL."Line No.")
        else
            exit(0);


    end;

    procedure LigneVentecomptoir(): boolean
    var
        SalesH: record "Sales Header";
    begin
        if SalesH.get("Document Type", "Document No.") then
            exit(SalesH."Vente comptoir");


    end;

    procedure CheckQuantiy(Qty: decimal)
    var
        item: record item;
    begin
        if item.get("No.") then begin
            if "Document Type" = "Sales Document Type"::order then
                item."ControlUnitéDépot"(Qty, "Location Code");

        end

    end;

    Procedure ControlDisponibilitéSaleslines()
    var
    begin
        if ("Document Type" = "Sales Document Type"::Invoice) or ("Document Type" = "Sales Document Type"::Invoice) then begin

            if GetDisponibilite(false) < 0 then
                error('Quantité non disponible.');
        end;


    end;

    procedure GetDisponibilite(Total: boolean): Decimal
    var
        Item: Record Item;
    begin
        if Item.Get("No.") then begin
            if total then
                exit(Item.CalcDisponibilité('', ''))
            else
                exit(Item.CalcDisponibilité("Location Code", "Bin Code"));
        end
    end;



    // end;

    /*  procedure CheckBlockageInsertion()
      var
          BoolInsertionblocked: Boolean;
          SalesLine: Record "Sales Line";

      begin
          message('CheckBlockage');
          BoolInsertionblocked := false;



          SalesLine.setrange("Document Type", "Document Type");
          SalesLine.setrange("Document No.", "Document No.");
          if SalesLine.FindFirst() then
              repeat
                  //BoolInsertionblocked := BoolInsertionblocked or (SalesLine.Quantity <> SalesLine."Quantity Invoiced");
                  if SalesLine.Quantity <> SalesLine."Quantity Invoiced" then
                      BoolInsertionblocked := true;
                  Message('%1', BoolInsertionblocked);

              until SalesLine.next() = 0;
           else
               BoolInsertionblocked := false; 


          if BoolInsertionblocked then error('Commande cadre totallement facturée');




      end;*/





}
