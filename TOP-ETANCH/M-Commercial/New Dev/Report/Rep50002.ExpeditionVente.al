namespace BCSPAREPARTS.BCSPAREPARTS;

using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.CRM.Team;
using Microsoft.Inventory.Item;

report 50002 BL
{
    Caption = 'Bon de Livraison';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'BL.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";

            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }

            /* column(SalesPersonName; SalesPersonName)
            { } */
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

            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesShipmentHeader;
                DataItemTableView = where(Quantity = filter(<> 0), Type = const(item));
                column(Item_Reference_No_; reference)
                { }
                column(Description; Description)
                { }

                column(Quantity; Quantity)
                { }
                column(Unit_Price; "Unit Price")
                { }
                column(Line_Discount__; "Line Discount %")
                { }

                column(VAT__; "VAT %")
                { }
                column(VAT_Base_Amount; "VAT Base Amount")
                { }
                column(MontantNet; MontantNet)
                {
                }
                column(No; reference) { }

                column(totalTVA; totalTVA)
                {
                }
                column(montant; montant)
                { }
                column(tva; tva)
                { }
                column(TotalBrut; TotalBrut)
                { }
                column(Remise; Remise)
                { }


                column(totalremise; totalremise)
                { }
                column(txtMntTLettres; txtMntTLettres) { }
                trigger OnPreDataItem()
                begin





                    TotalBrut := 0;
                    totalremise := 0;



                end;


                trigger OnAfterGetRecord()
                var
                    cust: Record Customer;
                    item: Record Item;
                begin
                    if "Sales Shipment Line"."No." = '' then
                        CurrReport.Skip();

                    //"Sales Shipment Line".get("Document No.");
                    //"Sales Shipment Line".get("Document No.", "Line No.");
                    ncommande := '';
                    // if SalesShipmentHeader.FindLast() then
                    //   ncommande := SalesShipmentHeader."No.";


                    montant := ((("Sales Shipment Line".Quantity) * ("Sales Shipment Line"."Unit Price")) * ((100 - "Line Discount %") / 100));
                    tva := (montant * "VAT %" / 100);
                    TotalBrut += montant;
                    totalTVA := tva;
                    MontantNet := TotalBrut + totalTVA;
                    Remise := (Quantity * "Unit Price" * "Line Discount %" / 100);
                    totalremise += (montant * "Line Discount %" / 100);
                    MontantNet2 := MontantNet2 + tva + montant;
                    txtMntTLettres := '';
                    MontTlettre."Montant en texte"(txtMntTLettres, MontantNet2);


                    reference := "No.";
                    if Type = type::Item then begin

                        if Vendorref then begin

                            if item.get("No.") then
                                reference := item."Vendor Item No.";
                        end
                    end


                end;


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
            begin
                SalesP.SetRange("Code", SalesShipmentHeader."Salesperson Code");

                if SalesP.FindFirst() then
                    SalesPersonName := SalesP.Name;
                SalesPersonPhone := SalesP."Phone No.";

                Cust.get("Sell-to Customer No.");
                cust.CalcFields("Balance Due (LCY)");
                Solde := Cust."Balance Due (LCY)";
                /*    if "Sell-to Customer Name 2" = '' then
                       "Sell-to Customer Name 2" := "Sell-to Customer Name"; */


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
    trigger OnInitReport()
    begin
        //  SansRemise := false;
        Vendorref := true;
    end;


    var
        companyInf: Record "Company Information";
        MontantNet: Decimal;
        TotalBrut: Decimal;
        montant: Decimal;
        tva: Decimal;
        totalTVA: Decimal;
        ncommande: Code[25];
        Remise: Decimal;
        totalremise: Decimal;
        SalesPersonName: Text[50];
        MontTlettre: Codeunit "Montant Toute Lettres";
        txtMntTLettres: text;
        MontantNet2: Decimal;
        SalesPersonPhone: text;
        Solde: decimal;
        reference: text;
        Vendorref: Boolean;


}
