namespace Top.Top;

using Microsoft.Sales.History;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;
using Microsoft.Sales.Document;

using System.Security.User;

pageextension 50091 InvoiceSubformSimul extends "Sales Invoice Subform"
{


    layout
    {
        addlast(Control39)
        {
            group("Marge Globale")
            {
                //visible = VisibleMarge;
                field("Montant marge"; rec.CalculMontantTotal() - rec.CalculMontantCoutTotal())
                {
                    ApplicationArea = all;
                }
                field("% Marge"; rec.CalculTauxMarge())
                {
                    visible = false;

                    ApplicationArea = all;
                }
            }

            group(Simulation)
            {
                editable = not ClientTTC;
                Visible = ClientDivers;
                field("Valeur à affecter"; "Valeuràmodifier")
                {
                    Visible = true;
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        SalesL: record "Sales Line";
                        postedShipments: record "Sales Shipment Line"; //Spécialement pour Facture 

                    begin

                        CalculValeurCaption();
                        if "Valeuràmodifier" = "Valeuràmodifier"::"Réinitialisation" then
                            IF CONFIRM('Êtes vous sure de remettre à zéro tout changement ? ', FALSE) then begin

                                begin
                                    SalesL.setrange("Document Type", rec."Document Type");
                                    SalesL.setrange(type, "Sales Line Type"::Item);
                                    SalesL.setrange("Document No.", rec."Document No.");

                                    if salesL.FindFirst() then
                                        repeat
                                            if SalesL."Shipment No." = '' then
                                                SalesL.Validate("No.", SalesL."No.")
                                            else begin
                                                postedShipments.get(SalesL."Shipment No.", SalesL."Shipment Line No.");
                                                SalesL.validate("Unit Price", postedShipments."Unit Price");
                                            end;



                                            SalesL.validate("Line Discount %", 0);
                                            SalesL.modify(true);
                                        until SalesL.next = 0;



                                end
                            end
                    end;


                }
                field("Total à appliquer"; "total à appliquer")
                {
                    visible = true;
                    Importance = Standard;
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '' + "Caption valeur";
                    enabled = "Valeuràmodifier" <> "Valeuràmodifier"::"Réinitialisation";
                    trigger OnValidate()
                    var
                        SalesH: record "Sales Header";

                    begin
                        SalesH.get(rec."Document Type", rec."Document No.");
                        if SalesH.Status <> SalesH.status::Open then error('statut doit être ouvert!!');
                        AppliquerSimulation("total à appliquer");
                        CurrPage.Update();
                    end;

                }
            }


        }


    }
    var
        Valeuràmodifier: Option "Total TTC","Réinitialisation"; //"Total HT","Total TTC",Marge,Remise,"Réinitialisation";
        "TotalTTC à Appliquer": decimal;

        "Caption valeur": text;
        "total à appliquer": decimal;
        VisibleMarge: Boolean;
        ClientTTc: Boolean;
        ClientDivers: Boolean;

    trigger OnOpenPage()
    begin
        "Valeuràmodifier" := "Valeuràmodifier"::"Total TTC";
        "total à appliquer" := 0;
        CalculValeurCaption();
        //CalculVisibilitéMarge();
        CheckClientDivers();
    end;

    trigger OnAfterGetRecord()
    var
        customer: record Customer;
        // ItemAllCompanies: Codeunit InsertAllItems;
        DispoTotale: Decimal;
    begin
        //  CalculVisibilitéMarge();

        // GetLastSalePrice();
        // updateStock();
        /*  if Rec."No." <> '' then begin
             DispoTotale := ItemAllCompanies.CalcdispoAllCompanies(Rec."No.", '');
             Rec."Total Availability" := DispoTotale;
         end; */

        if customer.get(rec."Sell-to Customer No.") then begin
            ClientTTc := customer."Prices Including VAT";
        end;
        CheckClientDivers();

    end;



    /*    procedure CalculVisibilitéMarge()
       var
           userSetup: record "User Setup";
       begin
           userSetup.get(UserId);
           VisibleMarge := userSetup."Visibilité Marge ";


       end; */
    Procedure CheckClientDivers()
    Var
        Salessetup: record "Sales & Receivables Setup";

    begin
        Salessetup.get();
        if Salessetup."Client Divers" = REc."Sell-to Customer No." then
            ClientDivers := true else
            ClientDivers := false;

    end;

    procedure AppliquerTTC(ValeurTTC: decimal)
    Var
        SalesL: record "Sales line";
        SalesL1: record "Sales line";
        totalTTC: decimal;
        DifferenceTTC: decimal;
        remiseGlobale: decimal;
        SommeBrutincludingTVA: decimal;
    begin
        SalesL.setfilter("Document No.", rec."Document No.");
        SalesL.setrange(type, "Sales Line Type"::Item);
        SalesL.setfilter("Quantity Invoiced", '>0');
        if salesL.FindFirst() then error('une partie de cette commande a été facturée');

        If ValeurTTC > TotalSalesLine."Amount Including VAT" then error('valeur superieure ');
        SommeBrutincludingTVA := 0;

        SalesL1.setfilter("Document No.", rec."Document No.");
        SalesL1.setrange(type, "Sales Line Type"::Item);
        if SalesL1.FindFirst() then
            repeat
                SommeBrutincludingTVA += (SalesL1.Quantity * SalesL1."Unit Price" * (1 + (SalesL1."VAT %" / 100)));
            until SalesL1.Next() = 0;

        remiseGlobale := 100 * (1 - (ValeurTTC / (SommeBrutincludingTVA)));


        affecterremise(remiseGlobale);
    end;

    procedure AppliquerSimulation(Valeur: decimal)
    Var
        SalesL: record "Sales line";
        SalesL1: record "Sales line";
        totalTTC: decimal;
        DifferenceTTC: decimal;
        remiseGlobale: decimal;
        SommeBrutincludingTVA: decimal;
        SommeBrut: decimal;
        SommeNet: decimal;
        SommeNetincludingTVA: decimal;
    begin
        SalesL.setrange("Document No.", rec."Document No.");
        SalesL.setrange(type, "Sales Line Type"::Item);
        SalesL.setfilter("Quantity Invoiced", '>0');
        if salesL.FindFirst() then error('une partie de cette commande a été facturée');





        /*  if "Valeuràmodifier" = "Valeuràmodifier"::Remise then begin
             if (valeur < 0) or (valeur > 100)
             then
                 error('la remise doit être entre 0 et 100')
             else
                 affecterremise(valeur);


         end; */
        if "Valeuràmodifier" = "Valeuràmodifier"::"Total TTC" then begin

            // If Valeur > TotalSalesLine."Amount Including VAT" then error('valeur superieure ');
            SommeBrutincludingTVA := 0;
            SalesL1.setrange("Document No.", rec."Document No.");
            SalesL1.setrange(type, "Sales Line Type"::Item);
            if SalesL1.FindFirst() then
                repeat
                    SommeBrutincludingTVA += (SalesL1.Quantity * SalesL1."Unit Price" * (1 + (SalesL1."VAT %" / 100)));
                until SalesL1.Next() = 0;

            remiseGlobale := 100 * (1 - (Valeur / (SommeBrutincludingTVA)));

            affecterremise(remiseGlobale);

        end;
        /*   if "Valeuràmodifier" = "Valeuràmodifier"::"Total HT" then begin
              // If Valeur > TotalSalesLine.Amount then error('valeur superieure ');
              SommeBrut := 0;

              SalesL1.setrange("Document No.", rec."Document No.");
              SalesL1.setrange(type, "Sales Line Type"::Item);
              if SalesL1.FindFirst() then
                  repeat
                      SommeBrut += (SalesL1.Quantity * SalesL1."Unit Price");
                  until SalesL1.Next() = 0;
              remiseGlobale := 100 * (1 - (Valeur / SommeBrut));
              affecterremise(remiseGlobale);
          end; */

        /*    if "Valeuràmodifier" = "Valeuràmodifier"::Marge then begin
               if (Valeur < 0) or (valeur >= 100) then error('Valeur marge doit être positive et strictement inférieure à 100');
               affecterMarge(Valeur);

           end; */
    end;


    procedure affecterremise(RemiseGlobale: decimal)
    var
        SalesL: Record "Sales Line";
    begin
        if RemiseGlobale < 0 then begin
            // Error('la valeur de la simulation va introduire une remise négative, pensez à augmenter le prix !!') 
            SalesL.setrange("Document No.", rec."Document No.");
            SalesL.setrange(type, "Sales Line Type"::Item);
            if SalesL.FindFirst() then begin
                repeat
                    SalesL.Validate("Line Discount %", 0);
                    SalesL.Validate("Unit Price", SalesL."Unit Price" * (1 - RemiseGlobale / 100));
                    SalesL.Modify(true);
                until SalesL.Next() = 0
            end



        end


        else begin
            SalesL.setrange("Document No.", rec."Document No.");
            SalesL.setrange(type, "Sales Line Type"::Item);
            if SalesL.FindFirst() then begin
                repeat
                    SalesL.Validate("Line Discount %", RemiseGlobale);
                    SalesL.Modify(true);
                until SalesL.Next() = 0
            end
        end
    end;

    procedure affecterMarge(Marge: decimal)
    var
        SalesL: record "Sales Line";


    begin
        SalesL.setrange("Document No.", rec."Document No.");
        SalesL.setrange(type, "Sales Line Type"::Item);
        if SalesL.FindFirst() then begin
            repeat
                //if (100 * (1 - (SalesL."Unit Cost" * (1 + Marge / 100)) / SalesL."Unit Price")) < 0
                //message(' remise à affecter %1', 100 * (1 - (SalesL."Unit Cost" / (SalesL."Unit Price" * (1 - Marge / 100)))));
                if (1 - (SalesL."Unit Cost" / (SalesL."Unit Price" * (1 - Marge / 100)))) < 0


                then begin

                    // message('la valeur de la marge va introduire une remise négative, pensez à augmenter le prix !!');
                    SalesL.Validate("Line Discount %", 0);
                    SalesL.Validate("Unit Price", SalesL."Unit cost" / (1 - Marge / 100));
                    //(1 - (1 - (SalesL."Unit Cost" * (1 + Marge / 100)) / SalesL."Unit Price"))); // Marge sur Achat

                end

                else
                    SalesL.Validate("Line Discount %", 100 * (1 - SalesL."Unit Cost" / (SalesL."Unit Price" * (1 - Marge / 100))));
                // message('%1', SalesL."Line Discount %");
                // SalesL.Validate("Line Discount %", 100 * (1 - (SalesL."Unit Cost" * (1 + Marge / 100)) / SalesL."Unit Price")); Marge sur Achat
                //SalesL.Validate("Unit Price", (rec."Unit Cost" * (1 + Marge)) / (1 - rec."Line Discount %" / 100));
                // SalesL.Validate("Line Discount %", RemiseGlobale);
                SalesL.Modify(true);
            until SalesL.Next() = 0
        end


    end;

    procedure CalculValeurCaption()
    var
    begin
        //  if "Valeuràmodifier" = "Valeuràmodifier"::Marge then
        //    "Caption valeur" := '% Marge';
        //if "Valeuràmodifier" = "Valeuràmodifier"::Remise then
        //  "Caption valeur" := '% Remise';
        //if "Valeuràmodifier" = "Valeuràmodifier"::"Total HT" then
        //  "Caption valeur" := 'Total HT';
        if "Valeuràmodifier" = "Valeuràmodifier"::"Total TTC" then
            "Caption valeur" := 'Total TTC';
    end;

}