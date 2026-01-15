namespace TOPETANCH.TOPETANCH;

using Microsoft.Sales.History;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Team;
using Microsoft.Foundation.Company;
using Microsoft.Bank.Payment;

report 50103 FactureVente
{
    ApplicationArea = All;
    Caption = 'FactureVente';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'FactureValide.rdl';
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Sell-to Customer No.";

            column(Sell_to_Customer_Name; NomClient)
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(VAT_Registration_No_; Cust."VAT Registration No.") { }

            column(Sell_to_Address; "Sell-to Address" + ' ' + "Bill-to Address 2" + ' ' + "Sell-to City")
            {

            }
            column(Sell_to_City; "Sell-to City")
            {

            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {

            }
            column(No_; "No.")
            {

            }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(External_Document_No_; "External Document No.")
            {

            }

            column(Posting_Date; "Posting Date")
            {

            }

            column(Salesperson_Code; "Salesperson Code")
            {

            }
            column(Salesperson_Name; SalespersonName)
            {

            }
            column(Payment_Method_Code; "Payment Method Code")
            { }
            column(Payment_Terms_Code; "Payment Terms Code") { }


            column(picture; companyInfo.Picture)
            { }
            column(CompanyName; companyInfo.Name) { }
            column(CompanyAdress; companyinfo.Address) { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyCodeP; companyinfo."Post Code") { }
            column(CompanyPhone; companyinfo."Phone No.") { }
            column(CompanyPhone2; companyinfo."Phone No. 2") { }
            column(CompanyEmail; companyinfo."E-Mail") { }
            column(CompanyWeb; companyinfo."Home Page") { }
            column(Timbre; "Stamp Amount") { }
            column(MontantNetHeader; MontantNetHeader) { }
            column(txtMntTLettres; txtMntTLettres) { }

            column(PaiementText; PaiementText) { }




            dataitem("SalesInvLines"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemTableView = where(type = filter(item));



                column(No; reference) { }
                column(VAT__; "VAT %") { }

                column(Item_Reference_No_; reference)
                { }
                column(Quantity; Quantity)
                {

                }
                column(Shipment_Date; "Shipment Date")
                {

                }

                column(Unit_Price; "Unit Price")
                {

                }
                column(Amount; Amount)
                {

                }
                column(Line_Discount__; "Line Discount %")
                {

                }
                column(Line_Discount_Amount; "Line Discount Amount")
                { }
                column(Description; Description)
                {

                }
                column(VAT_Base_Amount; "VAT Base Amount")
                {

                }
                column(MontantNet; MontantNet)
                {

                }
                column(MontantNet2; MontantNet2)
                {

                }
                column(totalTVA; totalTVA)
                {

                }
                column(Groupe; "No." + ' ' + format(TotalNet / Quantity)) { }
                column(TotalNet; TotalNet) { }
                //column(TotalBrut; TotalBrut)
                //{ }
                column(tva; tva)
                { }
                column(baseHT; baseHT)
                { }
                column(TotalRemise; TotalRemise)
                { }
                column(montant; montant)
                { }

                column(Line_Amount; "Line Amount") { }

                column(Line_Amount_Including_VAT; "Amount Including VAT") { }





                trigger OnAfterGetRecord()
                VAR
                begin



                    /* if SalesinvoiceL."No." = '' then
                         CurrReport.Skip();*/


                    /*   montant := SalesinvoiceL.Amount;
                      tva := (Amount * "VAT %" / 100);
                      TotalBrut += montant;
                      totalTVA += tva;
                      MontantNet := TotalBrut + totalTVA;
                      MontantNet2 := MontantNet2 + tva + Amount;
                      TotalNet += Amount;
                      TotalRemise += "Line Discount Amount";
                      txtMntTLettres := '';
                      MontTlettre."Montant en texte"(txtMntTLettres, MontantNet2); */
                    /* 
                                        if "No." <> LastArticleCode then
                                            CalculerTotal();
                                        //else
                                        // CurrReport.Skip();
                                        LastArticleCode := "No."; */
                    CalculerTotal();
                    if Type = "Sales Line Type"::Item then begin

                        if Vendorref then begin

                            if item.get("No.") then
                                reference := item."Vendor Item No.";
                        end
                        else
                            reference := "No.";
                    end
                end;
            }

            trigger OnAfterGetRecord()
            var
                SalesP: record "Salesperson/Purchaser";
                PL: Record "Payment Line";
                PC: Record "Payment Class";

            begin
                If NomClient = '' then
                    NomClient := "Sell-to Customer Name";
                if "Sell-to Customer Name 2" <> '' then NomClient := "Sell-to Customer Name 2";
                companyInfo.get;
                companyInfo.CalcFields(Picture);
                if SalesP.get("Salesperson Code") then
                    SalespersonName := Salesp.Name;
                SalespersonPhone := Salesp."Phone No.";
                Cust.get("Sell-to Customer No.");
                cust.CalcFields("Balance (LCY)");
                Solde := Cust."Balance Due (LCY)";
                //CalculerTotal();
                "Sales Invoice Header".CalcFields("Amount Including VAT");
                MontantNetHeader := "Sales Invoice Header"."Amount Including VAT"; //+ "Sales Invoice Header"."Stamp Amount";
                MontTlettre."Montant en texte"(txtMntTLettres, MontantNetHeader);


                PL.SetCurrentKey("Facture caisse");
                PL.SetRange("Facture caisse", "No.");
                PL.SetFilter("Status No.", '%1|%2', 0, 10000);
                PL.SetRange("Account No.", "Bill-to Customer No.");

                if PL.FindFirst() then
                    repeat
                        PC.get(PL."Payment Class");
                        if PC."Type caisse" = PC."Type caisse"::"Espèce" then
                            PaiementText += ' -ES ' + format(PL."Credit Amount");
                        if PC."Type caisse" = PC."Type caisse"::Retenue then
                            PaiementText += ' -RS ' + format(PL."Credit Amount");
                        if PC."Type caisse" = PC."Type caisse"::TPE then
                            PaiementText += ' -CR ' + format(PL."Credit Amount");
                        if PC."Type caisse" = PC."Type caisse"::"Chèque" then
                            PaiementText += ' -CHQ N° ' + PL."External Document No." + ' ' + PL."Bank Account Name" + ' ' + format(PL."Credit Amount");
                        if PC."Type caisse" = PC."Type caisse"::"Traite" then
                            PaiementText += ' -TR N° ' + PL."External Document No." + ' du ' + format(PL."Due Date") + ' ' + PL."Bank Account Name" + ' ' + format(PL."Credit Amount");
                    until PL.Next() = 0;


                if PaiementText <> '' then
                    PaiementText := 'Payé par ' + ' ' + PaiementText;
            end;
        }


    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Afficher référence fournisseur"; Vendorref)
                {
                    Caption = 'Afficher référence fournisseur';
                    ApplicationArea = all;
                    // Editable = IsEditable;

                }
                field(NomClient; NomClient)
                {
                    //  visible = false;
                    ApplicationArea = all;
                    Caption = 'Nom du client passager';
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    local procedure CalculerTotal()
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        SalesInvLine.SetRange("Document No.", SalesInvLines."Document No.");
        SalesInvLine.SetRange("No.", SalesInvLines."No.");
        SalesInvLine.setrange(Type, "Sales Line Type"::Item);


        TotalQuantity := 0;
        MontantTotal := 0;
        PV_Brut := 0;
        PV_Net := 0;
        TotalBrut := 0;
        totalTVA := 0;
        MontantNet := 0;
        MontantNet2 := 0;

        if SalesInvLine.findfirst() then begin
            repeat

                //TotalQuantity += SalesInvLine.Quantity;
                // MontantTotal += SalesInvLine."Line Amount";
                PV_Brut := SalesInvLine."Unit Price";
                PV_Net += SalesInvLine."Line Amount";

                Montant := SalesInvLine."Line Amount";
                tva := (SalesInvLines."Line Amount" * SalesInvLines."VAT %" / 100);
                TotalBrut += Montant;
                totalTVA += tva;
                // MontantNet := TotalBrut + totalTVA;
                //MontantNet2 += tot + SalesInvLine."Line Amount";
                TotalRemise += SalesInvLine."Line Discount Amount";
            //TotalNet += SalesInvLines.Amount;

            until SalesInvLine.Next() = 0;

            //MontantNet := MontantNet + "Sales Invoice Header"."Stamp Amount";


            //  txtMntTLettres := '';
            // MontTlettre."Montant en texte"(txtMntTLettres, MontantNet);
        end;
    end;

    var


        companyname: text;
        companyadress: text;

        salesper: Record "Salesperson/Purchaser";
        Item: Record Item;
        Vendor: Record Vendor;
        vendorname: Text;
        salespername: text;
        MontantTotal: Decimal;
        MontantNetHeader: Decimal;


        TotalQuantity: Decimal;
        LastArticleCode: Code[20];
        TotalQuantityToShip: Decimal;
        TotalQtyShipped: Decimal;
        PV_Brut: Decimal;
        PV_Net: Decimal;

        companyInfo: Record "Company Information";

        MontantNet: Decimal;
        TotalBrut: Decimal;

        montant: Decimal;
        tva: Decimal;
        totalTVA: Decimal;
        baseHT: Decimal;
        TotalRemise: Decimal;
        txtMntTLettres: text;
        MontantNet2: Decimal;


        MontTlettre: Codeunit "Montant Toute Lettres";

        SalespersonName: text;
        SalespersonPhone: text;
        solde: decimal;
        reference: Code[20];

        TotalNet: Decimal;
        vendorref: Boolean;
        Cust: record Customer;
        PaiementText: Text;
        NomClient: text[100];

}
