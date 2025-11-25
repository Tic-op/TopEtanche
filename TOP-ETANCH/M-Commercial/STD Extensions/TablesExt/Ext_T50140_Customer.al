// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.SalesManagement;

using Microsoft.Sales.Customer;
using Microsoft.CRM.Contact;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;
using Microsoft.Bank.Payment;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Intrastat;

tableextension 50140 CustomerExtension extends Customer
{
    fields
    {

        field(50004; "Client Initial"; Code[20])
        {//TICOP AM
            tablerelation = Customer;
        }

        field(50141; Stamp; Boolean)
        {//TICOP AM
            Caption = 'timbre';
            InitValue = true;
        }
        /*   field(50142; "Risque financier"; Decimal)
           {//TICOP CB
               Caption = 'Risque financier';
               FieldClass = FlowField;
               CalcFormula = - sum("Payment Line".Amount where("Account No." = field("No."), Risque = filter(<> '')
               , "Copied To No." = filter('')));
               Editable = false;
           }
           */
        field(50143; "Code Secteur"; Code[20])
        {
            Caption = 'Code Secteur';
            DataClassification = ToBeClassified;
            TableRelation = Territory.Code;
            NotBlank = true;
        }
        field(50144; "Cause du blocage"; option)
        {

            Caption = 'Cause du blocage';
            OptionMembers = "Non bloqué","Impayé","Facture non réglée","Echéance non réspectée","Dépassement du plafond","Autres";

            trigger OnValidate()
            begin

                validate(Blocked, Blocked::" ");

            end;

        }

        field(50145; "Return Not Invoiced"; decimal)
        {
            Caption = 'Retour non facturé';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Return Rcd. Not Invd." WHERE("Document Type" = CONST("Return Order"), "Bill-to Customer No." = FIELD("No."), "Currency Code" = FIELD("Currency Filter"), "Shipment Date" = FIELD("Date Filter")));
            Editable = false;
            //
        }
        field(50146; "Contre remboursement"; Boolean)
        {
            Caption = 'Contre remboursement';

        }
        field(50147; "Public"; Boolean)
        {
            Caption = 'Public';

        }
        field(50148; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "","Prospect","Client";
          

        }


        field(50150; "Type de facturation"; Option)
        {
            Caption = 'Type de facturation';
            OptionMembers = "","Contre remboursement","Fact. Mensuelle","Fact. Plafond","Commande Totale";
            trigger OnValidate()
            begin


                "Combine Shipments" := (("Type de facturation" = "Type de facturation"::"Commande Totale") AND ("Type de facturation" = "Type de facturation"::"Fact. Mensuelle"));
                if "Type de facturation" <> "Type de facturation"::"Fact. Plafond" then Seuil := 0;
                modify();
            end;

        }
        field(50151; Seuil; Decimal)
        {
             Caption = 'Minimum à facturer';
        }
        field(50152; "Customer type"; Option)
        {
            Caption = 'Type client';
            OptionMembers = "","Revendeur","normal","particulier";
        }




    }
    procedure CalcRestant() restant: decimal
    begin


        /*  Blocked := Blocked::" "; //Initialiser la valeur pour se baser sur le blocage spécifique
                                  //Modify();

         if (Blocked <> Blocked::" ") and ("Cause du blocage" = "Cause du blocage"::"Non bloqué") then begin
             "Cause du blocage" := "Cause du blocage"::Autres;
             //  Modify();
         end;*/

        if rec."Credit Limit (LCY)" <= 0 then
             exit(99999999);




        //"Payment in progress (LCY)",
        CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)");
        restant := rec."Credit Limit (LCY)" - (rec."Balance (LCY)" + rec."Outstanding Orders (LCY)" + rec."Shipped Not Invoiced (LCY)" - rec."Return Not Invoiced");//+ rec.Encours_Financier()); à définir urgent

        /* 
                if (restant <= 0) and (("Cause du blocage" = "Cause du blocage"::"Autres") OR ("Cause du blocage" = "Cause du blocage"::"Non bloqué")) then begin
                    "Cause du blocage" := "Cause du blocage"::"Dépassement du plafond"; */
        //Modify();
        // end;
        //  Message('calcrestant() %1', restant);

    end;



    trigger OnInsert()
    begin
        Validate("Combine Shipments", true);

    end;

    trigger OnAfterRename()
    var
        contact: record contact;
    begin
        contact.findfirst;
        repeat
            contact.UpdateCustomerNo();

        until contact.next() = 0;


    end;






}







