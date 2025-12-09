namespace Top.Top;

using Microsoft.Sales.History;
using Microsoft.Inventory.Item;
using Microsoft.CRM.Team;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;

report 50007 BLPageComplete
{
    Caption = 'Bon de Livraison';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'BLFixe.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            RequestFilterFields = "Sell-to Customer No.";

            column(Valorise; BL_Valorisé) { }
           // column(VAT_Registration_No2; "VAT Registration No2") { }
            column(logo; companyInf.Picture) { }
            column(MFS; companyInf."VAT Registration No.") { }
            column(Tel; companyInf."Phone No.") { }
            column(FAX; companyInf."Fax No.") { }
            column(Name; companyInf.Name) { }
            column(Adress; companyInf.Address) { }
          //  Column(HeaderJPG; companyInf."Header JPG") { }
           // column(FooterJPG; companyInf."Footer JPG") { }
            column(EMAIL; companyInf."E-Mail") { }




            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(SalesPersonPhone; SalesPersonPhone) { }
            column(SalesPersonName; SalesPersonName)
            { }
            column(Salesperson_Code; "Salesperson Code")
            { }

            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            { }
            column(Sell_to_Customer_Name_2; "Sell-to Customer Name 2") { }
            column(Sell_to_Address; "Sell-to Address")
            { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Sell_to_City; "Sell-to City")
            { }
            column(Document_Date; "Document Date")
            { }
            column(No_; "No.")
            { }
            column(Order_No_; "Order No.")
            {

            }

            column(VAT_Registration_No_; "VAT Registration No.") { }

            column(External_Document_No_; "External Document No.")
            { }
            column(timbre; timbre) { }
            column(solde; Solde)
            { }
            column(phone; phone) { }
            column(HeaderTotal; HeaderTotal) { }
            column(HeaderTVA; HeaderTVA) { }
            column(HeaderHT; HeaderHT) { }
            column(TVA19Amount; TVA19Amount) { }
            column(TVA19Base; TVA19Base) { }
            column(HeaderDiscount; HeaderDiscount) { }




            dataitem("SalesShipmentLine"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesShipmentHeader;
                UseTemporary = true;
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


                column(totalTVA; totalTVA)
                {

                }


                column(montant; montant)
                { }

                column(PrixTTC; Round(("Unit Price" * (1 + ("VAT %" / 100))) * Quantity)) { } //IS 080725

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
                    montant := ((Quantity * "Unit Price") * ((100 - "Line Discount %") / 100));
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

                companyInf.get;
                companyInf.CalcFields(Picture)//, "Header JPG", "Footer JPG");
            end;


            trigger OnAfterGetRecord()

            var
                SalesP: record "Salesperson/Purchaser";
                Cust: record Customer;
                SIL: Record "Sales Shipment Line";
                temp_i, line, j : integer;
            begin
                SalesP.SetRange("Code", SalesShipmentHeader."Salesperson Code");

                if SalesP.FindFirst() then
                    SalesPersonName := SalesP.Name;
                SalesPersonPhone := SalesP."Phone No.";

                Cust.get("Sell-to Customer No.");
                cust.CalcFields("Balance Due (LCY)");
                phone := Cust."Phone No.";
                Solde := Cust."Balance Due (LCY)";
                if "Sell-to Customer Name 2" = '' then
                    "Sell-to Customer Name 2" := "Sell-to Customer Name";

               
                

                CalculerTotaux("No.");
                Clear(SIL);
                ;
                SIL.SetRange("Document No.", "No.");
                SIL.SetRange(Type, SIL.Type::Item);
                SIL.FindSet();
                j := SIL.count;

                repeat
                    SalesShipmentLine.init;

                    SalesShipmentLine := SIL;
                    SalesShipmentLine.Insert();

                    line := SIL."Line No.";
                until SIL.next = 0;



                // IF j MOD 30 <> 0 then 
                for temp_i := j MOD 34 to 24 do begin
                    line += 11;
                    SalesShipmentLine.Init();
                    SalesShipmentLine."Document No." := SalesShipmentHeader."No.";
                    SalesShipmentLine."Line No." := line;
                    SalesShipmentLine.Type := SalesShipmentLine.Type::Item;
                    SalesShipmentLine.insert(false);
                end;




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

        sansremise := false;
        "BL_Valorisé" := true;

    end;

    local procedure CalculerTotaux(DocumentNo: Code[20])
    var
        SSL: Record "Sales Shipment Line";
        Montant: Decimal;
        RemiseLigne: Decimal;
        TVA: Decimal;
    begin


        SSL.Reset();
        SSL.SetRange("Document No.", DocumentNo);
        SSL.SetRange(Type, SSL.Type::Item);

        if SSL.FindFirst() then
            repeat
                Montant := SSL.Quantity * SSL."Unit Price";

                RemiseLigne := 0;
                if SSL."Line Discount %" <> 0 then
                    RemiseLigne := Montant * SSL."Line Discount %" / 100;
                Montant := Montant - RemiseLigne;


                if SSL."VAT %" = 19 then begin
                    TVA := Montant * 0.19;
                    TVA19Base += Montant;
                    TVA19Amount += TVA;
                end;

                TotalBrut += Montant;
                totalremise += RemiseLigne;
            until SSL.Next() = 0;


        HeaderHT := TVA19Base;
        HeaderTVA := TVA19Amount;
        HeaderDiscount := totalremise;
        HeaderTotal := ROUND(HeaderHT + HeaderTVA, 0.001, '=');

        MontantNet2 := HeaderTotal;


        txtMntTLettres := '';
        MontTlettre."Montant en texte"(txtMntTLettres, MontantNet2);
    end;



    var
        OptionReference: Option "Article","Origine","Vide";

        BL_Valorisé: Boolean;
        companyInf: Record "Company Information";
        MontantNet: Decimal;
        TotalBrut: Decimal;
        montant: Decimal;
        totalTVA: Decimal;
        ncommande: Code[25];
        ExpirationDatesGLOBAL: Text;
        Remise: Decimal;
        totalremise: Decimal;
        SalesPersonName: Text[50];
        MontTlettre: Codeunit "Montant Toute Lettres";
        txtMntTLettres: text;
        MontantNet2: Decimal;
        timbre: decimal;
        SalesPersonPhonE, phone : text;
        Solde: decimal;
        // Afficherref: Boolean;
        reference: Code[20];
        i: Decimal;
        SansRemise: Boolean;
        IsEditable: Boolean;
        TVA19Amount, TVA19Base, TVA7Amount, TVA7Base, TVA0Amount, TVA0Base : decimal;
        HeaderHT, HeaderTVA, HeaderDiscount, HeaderTotal : decimal;
                Vendorref: Boolean;


}