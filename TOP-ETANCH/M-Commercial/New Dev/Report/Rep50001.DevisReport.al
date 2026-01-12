namespace BCSPAREPARTS.BCSPAREPARTS;

using Microsoft.Sales.Document;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Setup;
using Microsoft.CRM.Team;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Sales.Customer;

report 50100 DevisReport
{
    ApplicationArea = All;
    Caption = 'Devis';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'devis.rdl';
    DefaultLayout = RDLC;
    dataset
    {

        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Posting Date";

            column(logo; companyInf.Picture) { }
            column(MFS; companyInf."VAT Registration No.") { }
            column(Tel; companyInf."Phone No.") { }
            column(FAX; companyInf."Fax No.") { }
            column(Name; companyInf.Name) { }
            column(Adress; companyInf.Address) { }

            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(Document_Date; "Document Date")
            {

            }
            column(No_document; "No.")
            {

            }
            column(Order_Date; "Order Date")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
                IncludeCaption = true;
            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            // column(Montant_Timbre; "Montant Timbre") { }
            column(Posting_Date; "Document Date")
            {
                IncludeCaption = true;
            }

            column(numcommande; ncommande)
            { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(SalespersonName; SalespersonName) { }
            column(Salespersonphone; Salespersonphone) { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(Sell_to_Address; "Sell-to Address" + ' ' + "Bill-to Address 2" + ' ' + "Sell-to City")
            {
            }
            column(Sell_to_City; "Sell-to City")
            {
            }
            column(CompanyName; companyInf.Name) { }
            column(CompanyAdress; companyInf.Address) { }
            column(CompanyCity; companyInf.City) { }
            column(CompanyCodeP; companyInf."Post Code") { }
            column(CompanyPhone; companyInf."Phone No.") { }
            column(CompanyPhone2; companyInf."Phone No. 2") { }
            column(CompanyEmail; companyInf."E-Mail") { }
            column(CompanyWeb; companyInf."Home Page") { }

            column(External_Document_No_; "External Document No.") { }
            column(Your_Reference; "Your Reference") { }
            Column(Timbre; Timbre) { }



            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = where("Document Type" = const("Sales Document Type"::Quote));
                DataItemLinkReference = SalesHeader;


                column(No_; reference)
                {
                    //IncludeCaption = true;
                }

                column(Line_Discount__; "Line Discount %")
                {

                }
                column(Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(Unit_Price; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(Line_Amount; "Line Amount")
                {
                    IncludeCaption = true;
                }
                column(Amount; Amount)
                {
                    IncludeCaption = true;
                }
                column(Item_Reference_No_; "Item Reference No.")
                {
                    IncludeCaption = true;
                }
                column(VAT__; "VAT %")
                {
                    IncludeCaption = true;
                }
                column(MontantNet; MontantNet)
                {

                }
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
                column(Line_Discount_Amount; "Line Discount Amount")
                { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(txtMntTLettres; txtMntTLettres) { }

                trigger OnAfterGetRecord()
                var
                    Cust: record Customer;
                    item: Record Item;
                begin
                    if "Sales Line"."No." = '' then
                        CurrReport.Skip();

                    montant := Round("Sales Line".Amount);

                    /*   if SansRemise then begin
                          Remise := 0;
                          "Line Discount %" := 0;
                          "Line Discount Amount" := 0;
                          montant := Quantity * "Unit Price";
                      end else */
                    begin
                        Remise := montant - (montant * "Line Discount %" / 100);
                        totalremise += Remise;
                    end;

                    tva := Round(montant * "VAT %" / 100);
                    TotalBrut += montant;
                    totalTVA += tva;
                    MontantNet := TotalBrut + totalTVA;
                    MontantNet2 := MontantNet2 + montant + tva;

                    txtMntTLettres := '';
                    MontTlettre."Montant en texte"(txtMntTLettres, MontantNet2 + timbre);

                    reference := "No.";
                    if Type = "Sales Line Type"::Item then begin

                        if Vendorref then begin

                            if item.get("No.") then
                                reference := item."Vendor Item No.";
                        end
                    end

                    /*   if OptionReference = OptionReference::Vide then begin
                          i += 1;
                          reference := Format(i);
                      end;
                      if OptionReference = OptionReference::Origine then begin
                          item.get("No.");
                          reference := item."Item Origin";
                          if reference = '' then
                              reference := '**';
                      end; */
                end;





            }


            trigger OnAfterGetRecord()
            var
                SalesP: Record "Salesperson/Purchaser";
                item: Record Item;
                SE: Codeunit SalesEvents;
                Customer: record Customer;
                GLS: record "General Ledger Setup";
            begin
                Customer.get("Sell-to Customer No.");
                if Customer.Stamp then begin
                    GLS.get();
                    timbre := GLS."Montant timbre fiscal";

                end;
                companyInf.get;
                companyInf.CalcFields(Picture);
                ncommande := '';
                SH2.SetRange("Document Type", "Document Type"::Order);
                SH2.SetFilter("Quote No.", "No.");
                if SH2.FindLast() then
                    ncommande := SH2."No.";


                Validate(Status, Status::Released);
                Modify();
                if SalesP.get("Salesperson Code") then
                    SalespersonName := Salesp.Name;
                SalespersonPhone := Salesp."Phone No.";
                //  Montant Timbre" := 1;

                /*   if "Sell-to Customer Name 2" = '' then
                      "Sell-to Customer Name 2" := "Sell-to Customer Name"; */

                "No. Printed" += 1;
                Modify();
                SE.ArchiveDevis("No.");

            end;


        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                    field("Afficher référence fournisseur"; Vendorref)
                    {
                        Caption = 'Afficher référence fournisseur';
                        ApplicationArea = all;
                        // Editable = IsEditable;

                    }
                    /*  field(SansRemise; SansRemise)
                     {
                         Caption = 'Sans remise ';
                         ApplicationArea = all;
                     } */
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
    trigger OnInitReport()
    begin
        //  SansRemise := false;
    end;

    var
        companyInf: Record "Company Information";

        SH2: Record "Sales Header";
        ncommande: Code[25];
        MontantNet: Decimal;
        TotalBrut: Decimal;
        montant: Decimal;
        tva: Decimal;
        totalTVA: Decimal;
        Remise: Decimal;
        totalremise: Decimal;
        Montantnet2: decimal;
        timbre: decimal;
        SalespersonName: text;
        Salespersonphone: text;
        MontTlettre: Codeunit "Montant Toute Lettres";
        txtMntTLettres: text;
        reference: text;
        i: Integer;
        OptionReference: Option "Article","Origine","Vide";
        //  SansRemise: Boolean;
        Vendorref: Boolean;






}