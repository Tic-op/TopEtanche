namespace BCSPAREPARTS.BCSPAREPARTS;

using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.CRM.Team;
using Microsoft.Inventory.Item;
using Top.Top;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Finance.VAT.Ledger;

report 50014 "BL RGRP"
{
    Caption = 'Bon de Livraison RGRP';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'BLRGRP.rdl';

    DefaultLayout = RDLC;
    dataset
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";

            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }

            column(Your_Reference; "Your Reference")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(VAT_Registration_No_; "VAT Registration No.")
            {

            }


            column(Salesperson_Code; "Salesperson Code")
            { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            { }

            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            { }
            column(Sell_to_Address; "Sell-to Address")
            { }
            column(Sell_to_City; "Sell-to City")
            { }
            column(Document_Date; "Document Date")
            { }
            column(No_; "No.")
            { }
            column(Order_No_; "Order No.")
            {

            }


            column(External_Document_No_; "External Document No.")
            { }

            column(picture; companyInf.Picture)
            { }
            column(CompanyName; companyInf.Name) { }
            column(CompanyAdress; companyInf.Address) { }
            column(CompanyCity; companyInf.City) { }
            column(CompanyCodeP; companyInf."Post Code") { }
            column(CompanyPhone; companyInf."Phone No.") { }
            column(CompanyPhone2; companyInf."Phone No. 2") { }
            column(CompanyEmail; companyInf."E-Mail") { }
            column(CompanyWeb; companyInf."Home Page") { }
            column(txtMntTLettres; txtMntTLettres) { }


            dataitem("LDVR"; "Ligne DocVente Regroupée")
            {
                UseTemporary = true;
                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(VAT__; "VAT %")
                {

                }
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
                    SalesishipLinesTotaux: record "Sales Shipment Line";
                begin
                    SalesishipLinesTotaux.SetRange("Document No.", SalesShipmentHeader."No.");
                    // SalesishipLines.CalcSums("Line Amount","Line Discount Amount","Amount Including VAT",Amount,"VAT Base Amount");
                    SalesishipLinesTotaux.FindFirst();
                    repeat
                        Totalremise += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price" *
                          SalesishipLinesTotaux."Line Discount %" / 100;
                        TotalHT += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price" *
                          (1 - SalesishipLinesTotaux."Line Discount %" / 100);
                        TotalBrut += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price";
                        TotalTva += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price" *
                         (1 - SalesishipLinesTotaux."Line Discount %" / 100) * (SalesishipLinesTotaux."VAT %" / 100);
                        NetaPayer += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price" *
                         (1 - SalesishipLinesTotaux."Line Discount %" / 100) * (1 + SalesishipLinesTotaux."VAT %" / 100);


                    until SalesishipLinesTotaux.Next() = 0;

                    if txtMntTLettres = '' then
                        CUTextMontant."Montant en texte"(txtMntTLettres, NetaPayer);
                end;
            }
            dataitem(TempVATEntry; "VAT Entry")
            {
                UseTemporary = true;


                column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }
                column(AmountTVA; Amount) { }
                column(Base; Base) { }

            }
            trigger OnPreDataItem()
            begin

                MontantNet2 := 0;

                companyInf.get;
                companyInf.CalcFields(Picture);
            end;


            trigger OnAfterGetRecord()

            var
                SalesP: record "Salesperson/Purchaser";
                Cust: record Customer;
                CU: Codeunit "Sales Document Line Mngmt";
            begin
                BuildTempVATEntriesFromSalesShipment();
                SalesP.SetRange("Code", SalesShipmentHeader."Salesperson Code");

                if SalesP.FindFirst() then
                    SalesPersonName := SalesP.Name;
                SalesPersonPhone := SalesP."Phone No.";

                Cust.get("Sell-to Customer No.");
                cust.CalcFields("Balance Due (LCY)");
                Solde := Cust."Balance Due (LCY)";
                /*  if "Sell-to Customer Name 2" = '' then
                     "Sell-to Customer Name 2" := "Sell-to Customer Name"; */

                CU.InsertLinesFromSalesDoc("No.", 110, LDVR);

            end;

            trigger OnPostDataItem()
            var


            begin

            end;


        }



    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field("Afficher référence fournisseur"; Vendorref)
                {
                    Caption = 'Afficher référence fournisseur';
                    ApplicationArea = all;
                    // Editable = IsEditable;

                }

            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    procedure BuildTempVATEntriesFromSalesShipment()
    var
        SalesshipLine: Record "Sales Shipment Line";
        VATAmount: Decimal;
        lig: Integer;
        Customer: Record Customer;
        vatRate: Decimal;
        VAT_PostingGroup: Record "VAT Posting Setup";
    begin
        TempVATEntry.Reset();
        TempVATEntry.DeleteAll();


        SalesshipLine.SetRange("Document No.", SalesSHipmentHeader."No.");
        SalesshipLine.SetRange(Type, SalesshipLine.Type::Item);

        if SalesshipLine.FindSet() then
            repeat
                vatRate := SalesshipLine."VAT %";
                if vatRate = 0 then begin //cas d'exo ou en suspension 
                    Customer.get(SalesshipLine."Sell-to Customer No.");
                    VAT_PostingGroup.GET(Customer."VAT Bus. Posting Group", SalesshipLine."VAT Prod. Posting Group");
                    vatRate := VAT_PostingGroup."VAT %";
                end;

                VATAmount :=
                Round(
                    SalesshipLine."Unit Price" * SalesshipLine."Quantity (Base)" * (1 - SalesshipLine."Line Discount %" / 100) * vatRate / 100,
                    0.001);




                lig += 1;
                TempVATEntry.Init();
                TempVATEntry."Entry No." := lig;
                TempVATEntry."Posting Date" := SalesshipLine."Posting Date";
                TempVATEntry."Document No." := SalesshipLine."No.";
                TempVATEntry."VAT Bus. Posting Group" := SalesshipLine."VAT Bus. Posting Group";
                TempVATEntry."VAT Prod. Posting Group" := SalesshipLine."VAT Prod. Posting Group";
                //      TempVATEntry. := SalesLine."VAT %";
                TempVATEntry.Base := SalesshipLine."Unit Price" * SalesshipLine."Quantity (Base)" * (1 - SalesshipLine."Line Discount %" / 100);
                TempVATEntry.Amount := VATAmount;

                TempVATEntry.Insert();

            until SalesshipLine.Next() = 0;
    end;


    var
        companyInf: Record "Company Information";

        SalesPersonName: Text[250];
        MontTlettre: Codeunit "Montant Toute Lettres";
        txtMntTLettres: text;
        MontantNet2: Decimal;
        SalesPersonPhone: text;
        Solde: decimal;
        Vendorref: Boolean;


        MttBrut, totalRemise, totalTVA, netApayer, TotalHT, TotalBrut : decimal;


}
