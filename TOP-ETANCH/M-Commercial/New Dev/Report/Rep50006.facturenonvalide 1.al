namespace Top.Top;

using Microsoft.Sales.Document;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;
using Microsoft.CRM.Team;

report 50006 "facture non validée"
{
    ApplicationArea = All;
    Caption = 'facture non validée';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'factureNonValidée.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Posting Date";

            column(logo; companyInf.Picture)
            { }
            column(CompanyName; companyInf.Name) { }
            column(CompanyAdress; companyInf.Address) { }
            column(CompanyCity; companyInf.City) { }
            column(CompanyCodeP; companyInf."Post Code") { }
            column(CompanyPhone; companyInf."Phone No.") { }
            column(CompanyPhone2; companyInf."Phone No. 2") { }
            column(CompanyEmail; companyInf."E-Mail") { }
            column(CompanyWeb; companyInf."Home Page") { }

            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(VAT_Registration_No_; "VAT Registration No.") { }

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


            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesHeader;


                column(No; reference)
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

                    if SansRemise then begin
                        Remise := 0;
                        "Line Discount %" := 0;
                        "Line Discount Amount" := 0;
                        montant := Quantity * "Unit Price";
                    end else begin
                        Remise := montant - (montant * "Line Discount %" / 100);
                        totalremise += Remise;
                    end;

                    tva := Round(montant * "VAT %" / 100);
                    TotalBrut += montant;
                    totalTVA += tva;
                    MontantNet := TotalBrut + totalTVA;
                    MontantNet2 := MontantNet2 + montant + tva;

                    txtMntTLettres := '';
                    MontTlettre."Montant en texte"(txtMntTLettres, MontantNet2);

                    reference := "No.";
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
            begin
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
                //"Montant Timbre" := 1;

                if "Sell-to Customer Name 2" = '' then
                    "Sell-to Customer Name 2" := "Sell-to Customer Name";

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

                    field("Afficher code "; OptionReference)
                    {
                        Caption = 'Afficher code ';
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
        SansRemise := false;
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
        SansRemise: Boolean;




}
