namespace TOPETANCH.TOPETANCH;

using Microsoft.Sales.History;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Finance.VAT.Setup;
using Top.Top;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Team;
using Microsoft.Foundation.Company;
using Microsoft.Bank.Payment;

report 50109 FactureVenteGRP
{
    ApplicationArea = All;
    Caption = 'FactureVenteGRP';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'FactureVenteGRP.rdl';
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
            column(Your_Reference; "Your Reference")
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

            dataitem("LDVR"; "Ligne DocVente Regroupée")
            {
                UseTemporary = true;
                column(Shipment_No_; "Shipment No.") { }
                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(VAT__; "VAT %") { }
                column(Line_Discount__; "Line Discount %") { }
                column(Amount; Amount) { }
                column(TotalBrut; TotalBrut) { }
                column(TotalHT; TotalHT) { }
                column(totalRemise; totalRemise) { }
                column(totalTVA; totalTVA) { }
                column(netApayer; netApayer) { }
                column(VAT_Amount; "VAT Amount") { }

                trigger OnAfterGetRecord()
                var
                    CUTextMontant: Codeunit "Montant Toute Lettres";
                    SalesInvoiceLinesTotaux: record "Sales Invoice Line";
                begin
                    SalesInvoiceLinesTotaux.SetRange("Document No.", "Sales Invoice Header"."No.");
                    SalesInvoiceLinesTotaux.Findset();
                    repeat

                        if SalesInvoiceLinesTotaux.Type = SalesInvoiceLinesTotaux.Type::Item then begin

                            Totalremise += SalesInvoiceLinesTotaux."Quantity (Base)" * SalesInvoiceLinesTotaux."Unit Price" *
                              SalesInvoiceLinesTotaux."Line Discount %" / 100;
                            TotalHT += SalesInvoiceLinesTotaux."Quantity (Base)" * SalesInvoiceLinesTotaux."Unit Price" *
                              (1 - SalesInvoiceLinesTotaux."Line Discount %" / 100);
                            TotalBrut += SalesInvoiceLinesTotaux."Quantity (Base)" * SalesInvoiceLinesTotaux."Unit Price";
                            TotalTva += SalesInvoiceLinesTotaux."Quantity (Base)" * SalesInvoiceLinesTotaux."Unit Price" *
                             (1 - SalesInvoiceLinesTotaux."Line Discount %" / 100) * (SalesInvoiceLinesTotaux."VAT %" / 100);
                            NetaPayer += SalesInvoiceLinesTotaux."Quantity (Base)" * SalesInvoiceLinesTotaux."Unit Price" *
                             (1 - SalesInvoiceLinesTotaux."Line Discount %" / 100) * (1 + SalesInvoiceLinesTotaux."VAT %" / 100);
                        end;
                        if SalesInvoiceLinesTotaux.Type = SalesInvoiceLinesTotaux.Type::"G/L Account" then
                            NetaPayer += SalesInvoiceLinesTotaux.Amount;
                    until SalesInvoiceLinesTotaux.Next() = 0;

                    if txtMntTLettres = '' then
                        CUTextMontant."Montant en texte"(txtMntTLettres, NetaPayer);
                end;
            }
            dataitem(TempVATEntry;
            "VAT Entry")
            {
                UseTemporary = true;


                column(VAT_Prod__Posting_Group;
                "VAT Prod. Posting Group")
                { }
                column(AmountTVA; Amount) { }
                column(Base; Base) { }

            }
            trigger OnAfterGetRecord()
            var
                SalesP: record "Salesperson/Purchaser";
                PL: Record "Payment Line";
                PC: Record "Payment Class";
                CU: Codeunit "Sales Document Line Mngmt";


            begin


                CU.InsertLinesFromSalesDoc("No.", 112, LDVR);
                BuildTempVATEntriesFromSalesInvoice();


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


    procedure BuildTempVATEntriesFromSalesInvoice()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        VATAmount: Decimal;
        lig: Integer;
        Customer: Record Customer;
        vatRate: Decimal;
        VAT_PostingGroup: Record "VAT Posting Setup";
    begin
        TempVATEntry.Reset();
        TempVATEntry.DeleteAll();


        SalesInvoiceLine.SetRange("Document No.", "Sales Invoice Header"."No.");
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);

        if SalesInvoiceLine.FindSet() then
            repeat
                vatRate := SalesInvoiceLine."VAT %";
                if vatRate = 0 then begin //cas d'exo ou en suspension 
                    Customer.get(SalesInvoiceLine."Sell-to Customer No.");
                    VAT_PostingGroup.GET(Customer."VAT Bus. Posting Group", SalesInvoiceLine."VAT Prod. Posting Group");
                    vatRate := VAT_PostingGroup."VAT %";
                end;

                VATAmount :=
                Round(
                    SalesInvoiceLine."Unit Price" * SalesInvoiceLine."Quantity (Base)" * (1 - SalesInvoiceLine."Line Discount %" / 100) * vatRate / 100,
                    0.001);




                lig += 1;
                TempVATEntry.Init();
                TempVATEntry."Entry No." := lig;
                TempVATEntry."Posting Date" := SalesInvoiceLine."Posting Date";
                TempVATEntry."Document No." := SalesInvoiceLine."No.";
                TempVATEntry."VAT Bus. Posting Group" := SalesInvoiceLine."VAT Bus. Posting Group";
                TempVATEntry."VAT Prod. Posting Group" := SalesInvoiceLine."VAT Prod. Posting Group";
                //      TempVATEntry. := SalesLine."VAT %";
                TempVATEntry.Base := SalesInvoiceLine."Unit Price" * SalesInvoiceLine."Quantity (Base)" * (1 - SalesInvoiceLine."Line Discount %" / 100);
                TempVATEntry.Amount := VATAmount;

                TempVATEntry.Insert();

            until SalesInvoiceLine.Next() = 0;
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
        TotalHT, NetaPayer, solde : decimal;
        reference: Code[20];

        TotalNet: Decimal;
        vendorref: Boolean;
        Cust: record Customer;
        PaiementText: Text;
        NomClient: text[100];

}
