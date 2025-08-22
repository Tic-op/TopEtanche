namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;
using Microsoft.Foundation.Address;
using Microsoft.Purchases.History;
using Microsoft.Purchases.RoleCenters;
using Microsoft.Sales.Document;

tableextension 50024 PurchaseLineExt extends "Purchase Line"

{

    fields
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                //if "Document Type" = "Document Type"::"Blanket Order" then //IS 07082025
                MAJ_Qté_Restante();



            end;
        }
        /*  field(50000; Marked; Boolean)
         {
             Caption = 'Marked';
             DataClassification = ToBeClassified;
             trigger OnValidate()
             begin
                 "MAJ_Qté_Restante"();
             end;
         } */
        field(50001; NoCommandeAchat; Code[20])
        {
            Caption = 'N° commande achat';
            DataClassification = ToBeClassified;
        }
        field(50002; "A commander"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
            InitValue = 0;
            trigger OnValidate()
            begin
                MAJ_Qté_Restante();
                // Message('%1  %2', Rec."A commander", Rec.Restant);
                if "A commander" > Restant then
                    Error('La quantité à commander doit être <= à la quantité restante');
            end;

        }
        field(50003; Restant; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }

        field(50004; "Qty commandée"; Decimal)
        {
            Caption = 'Qté commandée';
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document Type" = CONST(Order), "No." = FIELD("No."), "Blanket Order No." = FIELD("Document No."), "Blanket Order Line No." = field("Line No.")));
        }
        field(50006; "Tariff No."; Code[20])
        {
            Caption = 'Nomencalture Produit';
            DataClassification = ToBeClassified;
        }
        field(50007; "Country region origin code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No Origine';
            TableRelation = "Country/Region";
        }

        /////////////********* DOP CHB
        field(50008; "DOP sur Commande"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Quantity where("Document Type" = filter(order), "DOP No." = field("Document No."), "DOP Line No." = field("Line No.")));
        }



        field(50009; "DOP No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° DOP';
            TableRelation = "Purchase Header"."no." WHERE("Document Type" = CONST(Quote), "Buy-from Vendor No." = field("Buy-from Vendor No."));

        }

        field(50010; "DOP Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ligne DOP';
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = CONST(Quote),
            "Buy-from Vendor No." = field("Buy-from Vendor No.")
            , "Document No." = field("DOP No."),
            "No." = field("No."));
        }
        field(50011; "Confirmé par fournisseur"; Boolean)
        {
            Caption = 'Confirmé par fournisseur';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                PurchasePlanningRec: Record PurchasePlanning;
            begin
                if "Document Type" <> "Document Type"::Quote then
                    exit;
                if "Confirmé par fournisseur" then begin
                    PurchasePlanningRec.SetRange("Vendor No.", "Buy-from Vendor No.");
                    PurchasePlanningRec.SetFilter("Expected Date", '>%1', WorkDate());
                    PurchasePlanningRec.SetRange("Approved by Vendor", true);
                    PurchasePlanningRec.setrange("Real Date", 0D);

                    if PurchasePlanningRec.FindFirst() then
                        validate("Expected Receipt Date", PurchasePlanningRec."Expected Date");

                end
                else
                    validate("Expected Receipt Date", 0D);
            end;
        }

        field(50012; "DOP sur Réception"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line".Quantity where("DOP No." = field("Document No."), "DOP Line No." = field("Line No.")));
        }
        /* modify("Expected Receipt Date")  ///// IS070325 A REVISER
        {

            trigger OnafterValidate()
            var
                PurchasePlanningRec: Record PurchasePlanning;
            begin
                if Rec."Document Type" <> Rec."Document Type"::Quote then
                    exit;

                PurchasePlanningRec.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                //PurchasePlanningRec.SetFilter("Expected Date", '>%1', WorkDate());
                PurchasePlanningRec.SetRange("Approved by Vendor", true);
                PurchasePlanningRec.SetRange("Expected Date", Rec."Expected Receipt Date");

                if not PurchasePlanningRec.FindFirst() then
                 Error('La date ne correspond pas à la date du planning');
            end;

        } */


    }


    trigger OnDelete()
    begin
        if "Document Type" = "Document Type"::Order then
            //MAJ_Qté_Restante();
            Restant := Quantity;
    end;

    procedure MAJ_Qté_Restante()
    var
        PL: Record "Purchase Line";
    begin
        if "Document Type" = "Document Type"::Quote then begin //IS 07082025
            Restant := Quantity;
        end;
        if "Document Type" = "Document Type"::"Blanket Order" then begin
            CalcFields("Qty commandée");
            //Restant := "Outstanding Qty. (Base)" - "Qty commandée" 
            Restant := Quantity - "Qty commandée"// - "A commander";
            //     Modify();
        end;

        /*   if "Document Type" = "Document Type"::"Order" then begin
              if PL.get(PL."Document Type"::"Blanket Order", "Blanket Order No.", "Blanket Order Line No.") then begin
                  PL.CalcFields("Qty commandée");
                  PL.Restant := PL."Outstanding Qty. (Base)" - PL."Qty commandée";//- PL."A commander";
                  PL.Modify();
              end;
          end; */
    end;



}
