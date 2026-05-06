report 50120 AvoirFinancier
{
    ApplicationArea = All;
    Caption = 'AvoirFinancier';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'AvoirFinancier.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(SalesCrHeader; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "Sell-to Customer No.";

            column(No_; "No.") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_City; "Sell-to City") { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Document_Date; "Document Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(VAT_Registration_No_; "VAT Registration No.") { }

            column(CommentaireFacture; GetComments()) { }
            column(SalesPersonName; SalesPersonName) { }
            column(Timbre; MontantTimbre) { }
            //column(txtMntTLettres; txtMntTLettres) { }
            column(MontantLettre; MontantLettre) { }
            column(CompanyName; companyInfo.Name) { }
            column(CompanyAdress; companyinfo.Address) { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyCodeP; companyinfo."Post Code") { }
            column(CompanyPhone; companyinfo."Phone No.") { }
            column(CompanyPhone2; companyinfo."Phone No. 2") { }
            column(CompanyEmail; companyinfo."E-Mail") { }
            column(CompanyWeb; companyinfo."Home Page") { }

            column(picture; companyInfo.Picture) { }

            column(TotalBrut; TotalBrut) { }
            column(TotalRemise; TotalRemise) { }
            column(totalTVA; totalTVA) { }
            column(TotalNet; TotalNet) { }

            dataitem(SalesCreditLines; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");

                column(Type; Type) { }
                column(No; "No.") { }
                column(Description; Description) { }
                column(ILE_Qty; Quantity) { }
                column(PU; "Unit Price") { }
                column(Montant; Amount) { }
                column(VAT__; "VAT %") { }
                column(Remise; "Line Discount %") { }
                column(tva; tva) { }
                /*  column(TotalBrut;TotalBrut) { }
                  column(TotalRemise;TotalRemise) { }
                  column(totalTVA; totalTVA) { }
                  column(TotalNet; TotalNet) { }*/

                trigger OnAfterGetRecord()
                var
                    ItemRec: Record Item;
                begin
                    //  Totaux
                    TotalBrut += "Unit Price" * Quantity;
                    TotalNet += Amount;

                    tva := (Amount * "VAT %") / 100;
                    totalTVA += tva;

                    TotalRemise += "Line Discount Amount";

                    MontantLettre := '';
                    MontTlettre."Montant en texte"(MontantLettre, TotalNet + totalTVA + SalesCrHeader."Stamp Amount");


                end;
            }

            trigger OnPreDataItem()
            begin
                // Reset
                TotalBrut := 0;
                TotalNet := 0;
                totalTVA := 0;
                TotalRemise := 0;
                MontantLettre := '';
            end;

            trigger OnAfterGetRecord()
            var
                SalesP: Record "Salesperson/Purchaser";
            begin
                companyInfo.Get();
                companyInfo.CalcFields(Picture);

                // Timbre
                SalesCrHeader."Stamp Amount" := CalcStampAmount();
                MontantTimbre := SalesCrHeader."Stamp Amount";

                // Commercial
                SalesP.SetRange(Code, "Salesperson Code");
                if SalesP.FindFirst() then
                    SalesPersonName := SalesP.Name;

                // Montant en lettres
                MontTlettre."Montant en texte"(
                    MontantLettre,
                    TotalNet + totalTVA + MontantTimbre
                );
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {

            }
        }
    }



    // 🔹 Calcul timbre
    procedure CalcStampAmount(): Decimal
    var
        GLSetup: Record "General Ledger Setup";
        SalesLine: Record "Sales Cr.Memo Line";
    begin
        GLSetup.Get();

        SalesLine.SetRange("Document No.", SalesCrHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
        SalesLine.SetRange("No.", GLSetup."compte timbre fiscal");

        if SalesLine.FindFirst() then
            exit(SalesLine.Amount);

        exit(0);
    end;


    local procedure GetComments() Comm: Text
    var
        comment: Record "Sales Comment Line";
    begin
        comment.SetRange("Document Type", comment."Document Type"::"Credit Memo");
        comment.SetRange("No.", SalesCrHeader."No.");

        if comment.FindSet() then
            repeat
                Comm += ' ' + comment.Comment;
            until comment.Next() = 0;
    end;

    var
        SalesPersonName: Text[50];
        companyInfo: Record "Company Information";

        TotalBrut: Decimal;
        TotalRemise: Decimal;
        totalTVA: Decimal;
        TotalNet: Decimal;
        tva: Decimal;

        MontantLettre: Text;
        MontTlettre: Codeunit "Montant Toute Lettres";

        MontantTimbre: Decimal;

}