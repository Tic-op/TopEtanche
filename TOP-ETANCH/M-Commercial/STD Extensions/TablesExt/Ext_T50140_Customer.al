// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.SalesManagement;

using Microsoft.Sales.Customer;
using Microsoft.CRM.Contact;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;
using Microsoft.Bank.Payment;
using Microsoft.Sales.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.PaymentTerms;
using System.Security.User;
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
        field(50001; Plafond; Decimal)
        {

            Caption = 'Plafond';
            DataClassification = ToBeClassified;

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
                if "Cause du blocage" = "Cause du blocage"::"Non bloqué" then
                    AbilityToBlockCustomer();

                validate(Blocked, Blocked::" ");


                Message('Cause du blocage = ' + format("Cause du blocage"));


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
            var
                salessetup: record "Sales & Receivables Setup";
            begin
                /*         Salessetup.Get();
              If Not Salessetup."PEC Type facturation" then exit ; */

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
        field(60116; "Délai de Recouvrement"; DateFormula)
        {
            Caption = 'Délai de Recouvrement';
            DataClassification = ToBeClassified;
        }
        modify("Credit Limit (LCY)")
        {
            trigger OnAfterValidate()
            begin
                if "Credit Limit (LCY)" > 0 then
                    AbilityToBlockCustomer();
            end;
        }




    }
    procedure CalcRestant() restant: decimal
    begin


        Blocked := Blocked::" "; //Initialiser la valeur pour se baser sur le blocage spécifique
        //Modify();

        if (Blocked <> Blocked::" ") and ("Cause du blocage" = "Cause du blocage"::"Non bloqué") then begin
            "Cause du blocage" := "Cause du blocage"::Autres;
            //  Modify();
        end;

        if rec."Credit Limit (LCY)" <= 0 then
            exit(99999999);




        //"Payment in progress (LCY)",
        CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)");
        restant := rec."Credit Limit (LCY)" - (rec."Balance (LCY)" + rec."Outstanding Orders (LCY)" + rec."Shipped Not Invoiced (LCY)" - rec."Return Not Invoiced" + rec.Encours_Financier());


        if (restant <= 0) and (("Cause du blocage" = "Cause du blocage"::"Autres") OR ("Cause du blocage" = "Cause du blocage"::"Non bloqué")) then begin
            "Cause du blocage" := "Cause du blocage"::"Dépassement du plafond";
            //Modify();
        end;

    end;

    procedure ShowCalcRestant()

    textToShow: Text;
    begin
        if rec."Credit Limit (LCY)" <= 0 then begin
            message('Crédit autorisé = 0 ');
            exit;
        end;
        CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Return Not Invoiced");

        textToShow := 'Crédit autorisé = ' + format(rec."Credit Limit (LCY)") + '\';
        textToShow := textToShow + 'Solde = ' + format(rec."Balance (LCY)") + '\\';
        textToShow := textToShow + 'BL NF = ' + format(rec."Shipped Not Invoiced (LCY)") + '\';
        textToShow := textToShow + 'Retour NF = ' + format(-rec."Return Not Invoiced") + '\';
        textToShow := textToShow + 'Commande = ' + format(rec."Outstanding Orders (LCY)") + '\\';

        textToShow := textToShow + 'Encours Financier = ' + format(rec.Encours_Financier()) + '\';
        // textToShow := textToShow + 'Encours de paiement = ' + format(rec."Payment in progress (LCY)") + '\';






        message(textToShow);
    end;

    procedure Encours_Financier(): decimal
    var
        // pg: Page "Payment Lines List";

        retourvar: decimal;
    begin
        Clear(pl);
        pl.SetCurrentKey("Copied To No.", "Copied To Line");
        PL.SetRange("Copied To No.", '');
        pl.SetCurrentKey("Account Type", "Account No.", "Copied To Line", "Payment in Progress");
        Pl.setrange("Account Type", Pl."Account Type"::Customer);
        PL.setfilter("Account No.", "No.");
        Pl.SetAutoCalcFields(Risque);
        PL.setfilter("Risque", '<>%1', pl.Risque::" ");

        //PL.setfilter("Risque", '<> %1', 0);

        if PL.findfirst then begin
            //  exit(format(PL.Count));
            repeat
                if PL."Due Date" <> 0D then             //(PL."Due Date" - Today >= 3)
                    if (PL.Risque = PL.Risque::BQ) AND (Today < PL."Due Date" + 3) then begin
                        retourvar += PL.Amount;
                        PL.Mark(TRUE);

                    end;
                if (PL.Risque <> PL.Risque::BQ) or (PL."Due Date" = 0D) then begin
                    retourvar += PL.Amount;
                    PL.Mark(TRUE);

                end;
            until Pl.next() = 0;
        end;
        exit(-retourvar);
    end;

    procedure ShowEncours_Financier()
    begin
        PL.MarkedOnly(true);
        Page.RunModal(10872, PL);

    end;


    trigger OnInsert()
    begin
        Validate("Combine Shipments", true);

    end;

    trigger OnAfterRename()
    var
        contact: record contact;
    begin
        if contact.findfirst then
            repeat
                contact.UpdateCustomerNo();

            until contact.next() = 0;


    end;

    trigger OnAfterModify()
    begin

        if not IsBlocked() then
            "Cause du blocage" := "Cause du blocage"::"Non bloqué";

    end;


    local procedure AbilityToBlockCustomer(): Boolean
    var
        rec91: Record "User Setup";

    begin
        rec91.get(UserId);
        if not rec91."Blockage Client" then
            Error('Impossible d''effectuer cette action... Vous n''avez pas ce droit');
    end;

    procedure EchéanceDépassée(DateRèglement: Date; DateVente: Date): Boolean
    var
        PaymentTerms: Record "Payment Terms";

    begin


        if "Payment Terms Code" <> '' then begin
            PaymentTerms.get("Payment Terms Code");
            PaymentTerms.TestField("Due Date Calculation");



            if Calcdate(PaymentTerms."Due Date Calculation", DateVente) < DateRèglement then
                exit(true);
        end;
    end;


    var
        PL: Record "Payment Line";


}







