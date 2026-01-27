/// <summary>
/// Report InvoiceReport (ID 50103).
/// </summary>
report 50105 AvoirVente
{
    ApplicationArea = All;
    Caption = 'Avoir vente';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Avoir.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem("SalesCrHeader"; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "Sell-to Customer No.";
            column(CommentaireFacture; GetComments())
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Livraison_Date; DateLivraison)
            {

            }
            column(SalesPersonName; SalesPersonName)
            { }
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

            column(matriculeFiscale; MF)
            { }
            column(External_Document_No_; "External Document No.")
            { }
            column(Timbre; MontantTimbre)
            { }
            column(MontantLettre; MontantLettre) { }
            column(total_afficher; total_afficher)
            { }
            column(VAT_Registration_No_; "VAT Registration No.")
            { }
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




            dataitem("SalesCreditLines"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = where(type = filter(item)); // ??? Compte général



                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemTableView = where("entry type" = filter(Sale));
                    DataItemLinkReference = SalesCreditLines;
                    //   DataItemLink = "Document No." = field(return ), "Document line no." = FIELD("shipment Line No.");


                    column(i; "Document Line No.") { }
                    column(No; reference) { } ////SalesCreditLines."No."
                    column(Description; SalesCreditLines.Description) { }


                    column(Lots; "Lot no.")
                    { }
                    column(ExpirationDatesGLOBAL; "Expiration Date")
                    { }
                    column(ILE_Qty; Abs(Quantity))
                    { }
                    column(PU; SalesCreditLines."Unit Price")
                    { }

                    column(VAT__; SalesCreditLines."VAT %")
                    { }
                    column(Montant; SalesCreditLines.Amount * Quantity / SalesCreditLines.Quantity)
                    { }
                    column(Remise; SalesCreditLines."Line Discount %")
                    { }
                    column(textDoc; textDoc)
                    { }

                    column(TotalBrut; TotalBrut) { }
                    column(TotalRemise; TotalRemise) { }
                    column(totalTVA; totalTVA) { }
                    column(TotalNet; TotalNet) { }

                    column(tva; tva) { }
                    column(txtMntTLettres; txtMntTLettres) { }
                    trigger onpredataitem()
                    begin

                        SetRange("Document No.", RV);
                        SetRange("Document line No.", RVLine);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        //  SHIPH: Record "Sales Shipment Header";
                        item: record item;
                    begin
                        /*   IF Doc0 <> "Document No." then
                               textDoc := 'Bon de livraison N° ' + "Document No."
                           else
                               textDoc := '';
                           Doc0 := "Document No.";
                           */

                        TotalBrut += SalesCreditLines."Unit Price" * Quantity;
                        tva := (SalesCreditLines.Amount * SalesCreditLines."VAT %" * Quantity / SalesCreditLines.Quantity) / 100;
                        TotalNet += SalesCreditLines.Amount * Quantity / SalesCreditLines.Quantity;
                        TotalRemise += Quantity * (SalesCreditLines."Line Discount Amount" / SalesCreditLines.Quantity);
                        totalTVA += tva;
                        txtMntTLettres := '';
                        MontTlettre."Montant en texte"(txtMntTLettres, TotalNet + totalTVA + SalesCrHeader."Stamp Amount");
                        // MontTlettre."Montant en texte"(txtMntTLettres, TotalNet + totalTVA);

                        reference := SalesCreditLines."No.";

                        if SalesCreditLines.type = "Sales Line Type"::Item then begin

                            if Vendorref then begin

                                if item.get("Item No.") then
                                    reference := item."Vendor Item No.";
                            end
                        end

                    end;

                }
                trigger OnAfterGetRecord()
                begin
                    GetPostedReturn();

                end;


            }
            trigger OnPreDataItem()
            begin


                MontantLettre := '';
                total_afficher := 0;

            end;

            trigger OnAfterGetRecord()

            var
                SalesP: Record "Salesperson/Purchaser";


            begin


                SalesCrHeader."Stamp Amount" := CalcStampAmount();

                MontantTimbre := SalesCrHeader."Stamp Amount";

                SalesP.SetRange("Code", SalesCrHeader."Salesperson Code");
                companyInfo.get();
                companyInfo.CalcFields(Picture);

                if SalesP.FindFirst() then
                    SalesPersonName := SalesP.Name;

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
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }




    procedure CalcStampAmount(): Decimal
    var
        GLSetup: Record "General Ledger Setup";
        SalesCrediMemoLine: Record "Sales Cr.Memo Line";
    begin
        GLSetup.Get();

        SalesCrediMemoLine.SetRange("Document No.", SalesCrHeader."No.");
        SalesCrediMemoLine.SetRange(Type, SalesCrediMemoLine.Type::"G/L Account");
        SalesCrediMemoLine.SetRange("No.", GLSetup."compte timbre fiscal");



        if SalesCrediMemoLine.FindFirst() then begin

            exit((SalesCrediMemoLine.Amount));

        end;


    end;


    local procedure GetPostedReturn()
    var
        RVPostedLine: Record "Return Receipt Line";

    begin
        RV := '';
        RVLine := 0;
        RVPostedLine.SetCurrentKey("Return Order No.", "Return Order Line No.");
        RVPostedLine.SetRange("Return Order No.", SalesCreditLines."Order No.");
        RVPostedLine.SetRange("Return Order Line No.", SalesCreditLines."Order Line No.");
        if RVPostedLine.FindFirst() then begin

            RV := RVPostedLine."Document No.";
            RVLine := RVPostedLine."Line No.";
        end
        else begin

            RV := SalesCreditLines."Document No.";
            RVLine := SalesCreditLines."Line No.";
        end;


    end;



    var


        RV: code[20];
        RVLine: Integer;
        SalesPersonName: Text[50];
        discount: decimal;
        prixUnitaire: decimal;
        MontTlettre: Codeunit "Montant Toute Lettres";
        VatBaseAmount: Decimal;
        Doc0: code[20];
        textDoc: Text;
        Vat: Decimal;
        QtyLigne: integer;
        ILEAmount: decimal;
        ILEDiscountAmount: decimal;
        ILEAmountIncludingDiscount: decimal;
        ILEAmountIncludingVAT: decimal;
        ILE_VAT_AMOUNT: decimal;
        item_description: text;
        MontantTimbre: decimal;
        MontantLettre: text;
        total_afficher: decimal;
        companyInfo: Record "Company Information";
        MF: text;
        dateLivraison: Date;
        TotalBrut: Decimal;
        ExpirationDatesGLOBAL: Text;
        tva: Decimal;
        totalTVA: Decimal;
        TotalNet: Decimal;
        baseHT: Decimal;
        TotalRemise: Decimal;
        txtMntTLettres: text;
        reference: text;
        vendorref: Boolean;



    local procedure GetComments() Comm: Text
    var
        comment: Record "Sales Comment Line";
    begin
        comment.SetRange("Document Type", comment."Document Type"::"Credit Memo");
        comment.SetRange("No.", "SalesCrHeader"."No.");
        if comment.FindFirst() then
            repeat
                Comm := Comm + ' ' + comment.Comment;
            until comment.Next() = 0;

    end;
}
